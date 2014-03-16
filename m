From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH 0/6] nilfs2: implement tracking of live blocks
Date: Sun, 16 Mar 2014 12:01:54 +0100
Message-ID: <532584A2.8000004@gmx.net>
References: <cover.1394966728.git.andreas.rohner@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1394966728.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2014-03-16 11:47, Andreas Rohner wrote:
> Hi,
> 
> This patch set implements the tracking of live blocks in segments. This 
> information is crucial in implementing better GC policies, because 
> now the policies can make informed decisions about which segments have 
> the biggest number of reclaimable blocks.

IMPORTANT:
I forgot to mention, that the patches are based on linux-next/master,
because they rely on previous patches that aren't in master yet.

br,
Andreas Rohner

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
