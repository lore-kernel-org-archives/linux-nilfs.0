From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH 0/1] add missing blkdev_issue_flush() to nilfs_sync_fs()
Date: Wed, 27 Aug 2014 09:29:59 +0900 (JST)
Message-ID: <20140827.092959.1305564732068171399.konishi.ryusuke@lab.ntt.co.jp>
References: <1408959018-10570-1-git-send-email-andreas.rohner@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=XRgGZVRGZ2uVBChrbOERxNaEEjIsrLiY/Cma23CrB/U=;
        b=gzCQ1YfFEYMgf+jw/syEQQ5/1zBOBef8FBgS96GiWjqjej4W+/0SICZ1k3uBKhS7RN
         TgBuOQlZFdfY40IjJY2+RlLnroUJpZ57X3NKw79czqWZqzubG3593qFaLKOdfUA/3O4K
         Z/aipIBST9jaDYJtN4Dku61o7SdoIe88ugHxUMfEIfEOxCv5Ph05Qk6Vah5irCdWm4bP
         ph2VO88uh1KLbtdPv/XNzwj94+xU7Hv9ypvUB0OHxbJlq3wP8YQOkWRa9w0PRvEA/yti
         lxZMvwSRt3ras92EWTZ3NVwAC6GVmeT9FmkjPLqXv3bW7lxYqeAHwGjujuqVSwosove+
         uCjQ==
In-Reply-To: <1408959018-10570-1-git-send-email-andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Andreas,
On Mon, 25 Aug 2014 11:30:17 +0200, Andreas Rohner wrote:
> Hi,
> 
> I do not know, if this patch is really necessary or not. I am not an 
> expert in how the BARRIER flag should be interpreted. So this patch is 
> more like a question, than a fix for any real bug.
> 
> Looking over the code I noticed, that nilfs_sync_file() gets called by 
> the fsync() syscall and it basically constructs a new partial segment 
> and calls blkdev_issue_flush().
> 
> nilfs_ioctl_sync(), which is used by the cleaner, also essentially works 
> the same way. It writes all the dirty files to disk and calls 
> blkdev_issue_flush().
> 
> nilfs_sync_fs() also writes out all the dirty files, but there is no 
> blkdev_issue_flush() at the end. At first I thought, that 
> nilfs_commit_super() may flush the block device anyway and therefore no 
> additional flush is necessary, but nilfs_sb_dirty(nilfs) is only set to 
> true if a new segment is started. So in the following scenario data 
> could be lost despite a call to sync():
> 
> 1. Write out less data than a full segment
> 2. Call sync()
> 3. nilfs_sb_dirty() is false and nilfs_commit_super() is NOT called
> 4. Cut power to the device
> 5. Data loss
> 
> As I stated above, I am not sure if this is really necessary. Maybe I 
> have overlooked something obvious.

Your indication is right, we have a data integration issue for the
"nilfs_sb_dirty() is false" case in nilfs_sync_fs().

But, I rather would mitigate the cache flush overhead keeping data
integerity instead of simply adding the third blkdev_issue_flush()
call.

We don't have to call blkdev_issue_flush() if the last log was
written synchronously with a cache flush operation.
(this logic looks to be feasible by adding a flag.)

Also, the cache flush is not needed after writing super block; a disk
cache flush is needed BEFORE writing a super block to ensure that the
super block is pointing to a valid log, but a succeeding flush
operation is not needed because the pointer information is recoverable
with mount time recovery.

nilfs_sync_super() uses both FLUSH/FUA options for writing the primary
super block and the FUA option may be superfluous in that sense.
(we need to understand the precise semantics)

Can you improve the patch considering these view points ?

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
