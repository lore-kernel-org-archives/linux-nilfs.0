From: Gordan Bobic <gordan-UpbECiGlrmGsTnJN9+BGXg@public.gmane.org>
Subject: Garbage Collection Method
Date: Thu, 26 Jan 2012 13:08:09 +0000
Message-ID: <4F215039.4000904@bobich.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

Quick question about the garbage collector and what it reclaims and in 
what order.

1) Does it scan blocks from the tail of the file system forward 
sequentially?

2) Does it reclaim blocks regardless of how dirty they are? Or does it 
execute reclaiming on order of maximum dirtyness first in order to 
reduce churn (and flash wear when used on flash media)?

3) What happens when it encounters a block that isn't dirty? Does it 
skip it and reclaim the next dirty block, leaving a "hole"? Or does it 
reclaim everything up to a reclaimable block to make the free space 
contiguous?

4) Assuming this isn't already how it works, how difficult would it be 
to modify the reclaim policy (along with associated book-keeping 
requirements) to reclaim blocks in the order of dirtiest-block-first?

5) If a suitable book-keeping bitmap was in place for 4), could this not 
be used for accurate df reporting?

TIA.

Gordan
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
