From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH 0/1] nilfs2: add mount option that reduces super block
 writes
Date: Thu, 30 Jan 2014 04:27:12 +0100
Message-ID: <52E9C690.1010404@gmx.net>
References: <CAFvQSYSu5CGxs+K6bZUCtq17PrS_paX3bXBuLBRTba_XWYGgAg@mail.gmail.com> <cover.1391048231.git.andreas.rohner@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1391048231.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014-01-30 03:46, Andreas Rohner wrote:
> I repurposed the ss_pad field of nilfs_segment_summary to contain the 
> crc seed, because I needed a way to distinguish left over segments 
> from previous nilfs2 volumes from real segments that are part of the 
> current file system. 

I just realized, that using the ss_pad field is completely unnecessary.
I just have to check the checksums. The reason why there is a crc_seed
in the first place is to distinguish segments from previous nilfs2
volumes. Sorry for that.

br,
Andreas Rohner


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
