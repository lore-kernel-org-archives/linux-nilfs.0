From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH] nilfs2: depending on flags, update segment usage instead
 of cleaning
Date: Sun, 19 Jan 2014 18:17:17 +0100
Message-ID: <52DC089D.4080504@gmx.net>
References: <cover.1390139797.git.andreas.rohner@gmx.net>	<1390140141-4432-1-git-send-email-andreas.rohner@gmx.net> <20140120.014916.57469358.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140120.014916.57469358.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Ryusuke,

On 2014-01-19 17:49, Ryusuke Konishi wrote:
> Could you consider adding NILFS_IOCTL_SET_SUINFO instead of extending
> v_flags of NILFS_IOCTL_CLEAN_SEGMENTS ?

Yes sure. I actually considered that writing the patch, but then shyed
away from adding a new ioctl.

> It is hacky to extend NILFS_IOCTL_CLEAN_SEGMENTS like this, and,
> unfortunately, argv[]->v_flags of NILFS_IOCTL_CLEAN_SEGMENTS is not
> zero-filled in the current library implementation.  This is our
> mistake (so I will fix it soon), but we cannot use these flags for
> some time.  Otherwise, existing cleanerds will go wrong when this is
> merged into kernel.

Ah yes I didn't think of that.

> Presence of ioctls can be tested with ENOTTY error, so libnilfs
> can know whether nilfs in underlying kernel has NILFS_IOCTL_SET_SUINFO
> ioctl or not, and we can extend the library keeping compatibility
> by using this nature.
> 
> A good example of code updating metadata file is
> nilfs_ioctl_change_cpmode() even though NILFS_IOCTL_SET_SUINFO will
> need nilfs_ioctl_wrap_copy().  It would be helpful for you.
> 
> Additional comments are as follows:
> 
> - For NILFS_IOCTL_SET_SUINFO, v_flags should be used to define which
>   fields (lastmod, nblocks, flags) are modified.  These flags should
>   be defined with bit masks.

Thank you for your comments. I will try and implement it and come back
with a new version of my patch.

Best regards,
Andreas Rohner

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
