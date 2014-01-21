From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH v2 1/5] nilfs-utils: cldconfig add an option to set minimal
 free blocks
Date: Tue, 21 Jan 2014 15:38:45 +0100
Message-ID: <52DE8675.2010101@gmx.net>
References: <cover.1390310509.git.andreas.rohner@gmx.net> <22b5b3ac403052d3044dc8c1bebe323191376c03.1390310509.git.andreas.rohner@gmx.net> <2891656.vdWYFxplD3@coil>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2891656.vdWYFxplD3@coil>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Dexen,

On 2014-01-21 15:10, dexen deVries wrote:
> Will your patches be smart enough to re-claim space if the only available free 
> blocks are under threshold?
> 
> 
> Scenario: FS is running out of free space, and the free blocks to be reclaimed 
> are scattered through segments in small numbers. Several segments have a small 
> number of free blocks, but in each segment the amount is under the threshold. 

No my patches won't do that, but there are two new config options.
Namely min_free_blocks_threshold and mc_min_free_blocks_threshold,
whereby the latter is used if the number of clean segments is below
min_clean_segments, similar to the other mc options.

To accommodate your scenario you could simple set a very low value or
even 0 to mc_min_free_blocks_threshold. So if the number of clean
segments drops below min_clean_segments my patches would be disabled.

Regards,
Andreas Rohner
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
