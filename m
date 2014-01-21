From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH] nilfs2: depending on flags, update segment usage instead
 of cleaning
Date: Tue, 21 Jan 2014 15:17:08 +0100
Message-ID: <52DE8164.1020303@gmx.net>
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
> Additional comments are as follows:
> 
> - For NILFS_IOCTL_SET_SUINFO, v_flags should be used to define which
>   fields (lastmod, nblocks, flags) are modified.  These flags should
>   be defined with bit masks.

I forgot to mention in my cover letter, that I decided not to use the
v_flags field for the flags, because I needed a new structure to contain
the segment number anyway. It just seemed to be a better choice to put
the flags there as well. But if you want I can always change it to use
the v_flags field.

Best regards,
Andreas Rohner
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
