From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix segctor bug that causes file system corruption
Date: Thu, 2 Jan 2014 19:59:28 +0300
Message-ID: <741898E4-B794-47FF-ABF6-2DCACA2AED43@dubeyko.com>
References: <1388674131-22579-1-git-send-email-andreas.rohner@gmx.net>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=HXTSdSvUvOuuBFttcrMLJA1F35ABMJ+DpxgX44mSEXk=;
	b=jbejFR0aljIjhEyf3mIlcblqyLp5A0SxdxRAMo6GNUUh5LKFIruJzyRkG9RPvakqVlzQydW6FPHr4QCSEVFZ8Q5CkB/4DEneAYAaflj7jzbgunXXZozjxtKhmThKCFvd;
In-Reply-To: <1388674131-22579-1-git-send-email-andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Hi Andreas,

On Jan 2, 2014, at 5:48 PM, Andreas Rohner wrote:

> There is a bug in the function nilfs_segctor_collect, which results in
> active data being written to a segment, that is marked as clean. It is
> possible, that this segment is selected for a later segment
> construction, whereby the old data is overwritten.
> 

Thank you for your patch. But, currently, I doubt that your patch is correct.

What version of the kernel did you used during the issue reproducing?
Do you have the patch [1] in your kernel?

The description of the issue looks like the problem that it was fixed in my
patch. So, do you confident that you reproduce the issue with presence of patch [1]
in your kernel? Could you check and confirm it?

Of course, you can discover some new issue. But, currently, I can't understand
relation between the error message from nilfs_sufile_do_cancel_free() and next
messages from nilfs_bmap_last_key() from your description. So, I need to think over
your description more deeply and I need in confirmation that you reproduce the
issue with presence of patch [1] in your kernel.

Thanks,
Vyacheslav Dubeyko.

[1] http://comments.gmane.org/gmane.comp.file-systems.nilfs.user/3082

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
