From: Christian Smith <csmith-r5H9PUQoNxUga4AWyxku7ULnMzgEhdHr@public.gmane.org>
Subject: Re: Garbage Collection Method
Date: Fri, 27 Jan 2012 16:00:04 +0000
Message-ID: <20120127160004.GK750@csmith-bm.vm.bytemark.co.uk>
References: <4F215039.4000904@bobich.net>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4F215039.4000904-UpbECiGlrmGsTnJN9+BGXg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gordan Bobic <gordan-UpbECiGlrmGsTnJN9+BGXg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jan 26, 2012 at 01:08:09PM +0000, Gordan Bobic wrote:
> Hi,
>
> Quick question about the garbage collector and what it reclaims and in  
> what order.
>
> 1) Does it scan blocks from the tail of the file system forward  
> sequentially?

Yes

>
> 2) Does it reclaim blocks regardless of how dirty they are? Or does it  
> execute reclaiming on order of maximum dirtyness first in order to  
> reduce churn (and flash wear when used on flash media)?

The former.

>
> 3) What happens when it encounters a block that isn't dirty? Does it  
> skip it and reclaim the next dirty block, leaving a "hole"? Or does it  
> reclaim everything up to a reclaimable block to make the free space  
> contiguous?

It is cleaned regardless. Free space appears to always be contiguous.

>
> 4) Assuming this isn't already how it works, how difficult would it be  
> to modify the reclaim policy (along with associated book-keeping  
> requirements) to reclaim blocks in the order of dirtiest-block-first?
>
> 5) If a suitable book-keeping bitmap was in place for 4), could this not  
> be used for accurate df reporting?


Not being a NILFS developer, I can't answer either of these in detail.

However, as I understand it, the filesystem driver does not depend on the
current cleaning policy, and can skip cleaning specific blocks should those
blocks be sufficiently clean. Segments need not be written sequentially,
as each segment contains a pointer to the next segment that will be written
and hence why lssu always lists two segments as active (the current segment
and the next segment to be written).

It's just that the current GC just cleans all segments sequentially. It's
easier to just cycle through the segments in a circular fashion.

What would be useful is to be able to select the write segment into which 
the cleaner will write live data. That way, the system could maintain two
log "heads", one for active hot data, and one for inactive cold data. Then
all cleaning would be done to the cold head, and all new writes to the hot
head on the assumption that the new write will either be temporary (and
hence discarded sooner rather than later) or not be updated for some time
(and hence cleaned to a cold segment by the cleaner) with the hope that
we'll have a bimodal distribution of clean and dirty data. Then the 
cleaner can concentrate on cleaning hot segments, with the occasional clean
of cold segments.

Accurate df reporting is more tricky, as checkpoints and snapshots make it
decidedly not trivial to account for overwritten data. As such, the current
df reporting is probably the best we can manage within the current
constraints.

Christian
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
