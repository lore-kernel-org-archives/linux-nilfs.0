From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v5 1/1] nilfs2: add missing blkdev_issue_flush() to
 nilfs_sync_fs()
Date: Sat, 13 Sep 2014 23:23:56 +0900 (JST)
Message-ID: <20140913.232356.1854857348878372129.konishi.ryusuke@lab.ntt.co.jp>
References: <1410616556-25943-1-git-send-email-andreas.rohner@gmx.net>
	<1410616556-25943-2-git-send-email-andreas.rohner@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=MYNLdP1HsS9VNmUMfrGWOtqOJsv0hSlYe/wweG4BtYo=;
        b=gJeSQxBFWk26fYI2l/0bCB160miaE7BCIpTLHiIIdq9AdeTOoOblHPp1kvyC/vG4OB
         rL1S5mFpT6mEy+36IJvmms/Zbdecu2KnDaiZaHMxx5BLptnS5enRsuxpGQW9zXwGxjsV
         0CZq94CyfEPp0+jJJCym8mV5RjffSsgxb7E3PgtcVkwdQI/7ehCmBNnEmyw4scoD9Acg
         SXBDePBBONxsLan8EztDmxjiO4tKmmzBcKaxoMJvD5jkbqqGwqayj7OC8uA7WFUidfh/
         tfZjhbo7g4hya556w+UCvnIj5+Dl1vnDvPTzHf2HWrTuJfiMBnXF81Xw0m0wbfpuzZai
         XN/Q==
In-Reply-To: <1410616556-25943-2-git-send-email-andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, 13 Sep 2014 15:55:56 +0200, Andreas Rohner wrote:
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index 422fb54..5a530f3 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -1022,11 +1022,9 @@ static int nilfs_ioctl_sync(struct inode *inode, struct file *filp,
>  		return ret;
>  
>  	nilfs = inode->i_sb->s_fs_info;
> -	if (nilfs_test_opt(nilfs, BARRIER)) {
> -		ret = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
> -		if (ret == -EIO)
> -			return ret;
> -	}
> +	ret = nilfs_flush_device(nilfs);

> +	if (ret == -EIO)
> +		return ret;

One more comment.  I think this special treatment of EIO should be
encapsulated in nilfs_flush_device().  nilfs_ioctl_sync() doesn't have
to know it:

	if (ret < 0)
		return ret;

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
