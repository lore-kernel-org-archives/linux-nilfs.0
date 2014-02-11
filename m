From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] cldconfig: fix inconsistency in rounding percent values
Date: Tue, 11 Feb 2014 20:22:45 +0900 (JST)
Message-ID: <20140211.202245.52175218.konishi.ryusuke@lab.ntt.co.jp>
References: <9d514116552f5e31b7a867e695abd8fefce8e025.1392115778.git.andreas.rohner@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9d514116552f5e31b7a867e695abd8fefce8e025.1392115778.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 11 Feb 2014 11:50:09 +0100, Andreas Rohner wrote:
> The number of blocks calculated from a percent value given to the
> -min-reclaimable-blocks command line parameter of nilfs-clean is rounded
> up. The same percent value in the configuration file is not rounded up.
> This patch fixes the inconsistency by rounding up both values.
> 
> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

Applied, thanks.

Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
