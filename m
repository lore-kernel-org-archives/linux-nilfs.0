From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v2 1/1] nilfs2: add missing blkdev_issue_flush() to
 nilfs_sync_fs()
Date: Wed, 10 Sep 2014 03:55:40 +0900 (JST)
Message-ID: <20140910.035540.1996373920678181737.konishi.ryusuke@lab.ntt.co.jp>
References: <54070A56.9050807@gmx.net>
	<20140907.141232.2124135104047617747.konishi.ryusuke@lab.ntt.co.jp>
	<540DFD66.1090904@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=pU97I24haCoFnxsEgdLmcUcpfX0ltZJsYQsl3DcPubc=;
        b=IEgbZljovOYSQwc2nP1qVpxAdV6ndrH6nj2cDB5gFZ+zjO3IZddkMDVVvdY2zuWwVC
         +6vH+8qQ6E5fMwrzNh9FTsKnNvTyAVLwV66kxm9LZxiDUfxGzedakUmonFdmnB7UJSkS
         m/saIVA8dTnuip4y4OgQW5L5VR0wSjZO0N8gGtJix6Iu4EMb6RuRPswms8qaqW1hqxlM
         9anYOhXlx2enwe8ABlzXUNqkaski1xSYUWaK5vWRpLpVRcd+xssiZZul2tgAVh6EcqqT
         vd8Z0GolS9lYkfrA3sADPjg9uTfg7fdKikHauqo7eftgobel9oVqCDwQukn4h8ifNv9o
         LYZQ==
In-Reply-To: <540DFD66.1090904-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 08 Sep 2014 21:03:02 +0200, Andreas Rohner wrote:
> 
> Hi Ryusuke,
> 
> Sorry for the late response I was busy over the weekend.
> 
> On 2014-09-07 07:12, Ryusuke Konishi wrote:
>> - clear_nilfs_flushed() seems to be called more than necessary.
>>   Incomplete logs that the mount time recovery of nilfs doesn't
>>   salvage do not need to be flushed.  In this sense, it may be enough
>>   only for logs containing a super root and those for datasync
>>   nilfs_construct_dsync_segment() creates.
> 
> Yes you are right I will change that as well.
> 
> On the other hand it seems to me, that almost any file operation causes
> a super root to be written. Even if you use fdatasync(). If the i_mtime
> on the inode has to be changed, then NILFS_I_INODE_DIRTY is set and the
> fdatasync() turns into a normal sync(), which always writes a super
> root. Every write() to a file causes an update of i_mtime. I could only
> make fdatasync() work as intended with mmap(), but maybe I am missing
> something. So we may not save us a lot of updates by only updating the
> flag in case the log contains a super root...

Uum, this looks another problem. We need efficient fsync/fdatasync/
msync operation.  The above legacy implementation should be replaced
with some new ideas in which metadata update is handled more
efficiently and checkpoint creation is suppressed...

Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
