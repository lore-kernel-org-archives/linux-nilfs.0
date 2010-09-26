From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Performance about nilfs2 for SSD
Date: Sun, 26 Sep 2010 18:17:07 +0900 (JST)
Message-ID: <20100926.181707.70807240.ryusuke@osrg.net>
References: <AANLkTinLswg7ko3T-cGsSMMqPfcM0dZB7GN2o6Q2b3gY@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinLswg7ko3T-cGsSMMqPfcM0dZB7GN2o6Q2b3gY-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: yuehaixu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yhxu-jgEIgUtgKzeHXe+LvDLADg@public.gmane.org

Hi,
On Sat, 25 Sep 2010 18:54:04 -0400, Yuehai Xu wrote:
> Hi,
> 
> I have a SSD which is Intel x25-v, I use it to test the performance of
> different file systems. The results seems confusing to me. It is from
> postmark in which I set file number to 50,000 with each size from 9216
> bytes to 15360 bytes
> 
> 	EXT3	NILFS2	BTRFS	EXT4	XFS	REISERFS	EXT2					
> PostMark(R)	146.67Kb/s  52.21Kb/s	90.59Kb/s	
> 172.12Kb/s	60.39Kb/s	146.67Kb/s	83.25Kb/s
> PostMark(W)	28.09Mb/s	10Mb/s	17.35Mb/s	31.04Mb/s	11.56Mb/s	28.09Mb/s	15.94Mb/s
> 
> From the results, the throughput both for R/W of NILFS2 is much
> smaller than EXT3. As I noticed that the performance of NILFS2 for SSD
> is much better than other file systems from the web site. What's the
> matter with my own test result? My kernel is 2.6.32, and I use default
> way to format NILFS2, nothing special is done. So, my questions are:
> 
> 1. Are there any special parameters that I need to configure when I
> mount/format my SSD?

Nilfs in latest kernels have "discard" mount option, but I think
it won't change the above result dramatically.

> 2. Is the performance much different from different kind of SSD?
> 3. As I know, NILFS2 is a kind of Log-file system, which means it
> always makes the random writes sequentially and tries to avoid the
> cost of overwrite for SSD. Does it need to overwrite its meta data?
> Since I think NILFS2 should always make a mapping table, how about
> when the mapping table need to be updated?

For older SSD drives, it may be true.

But, recent intelligent SSD drives are doing LFS like optimizations
internally, so I guess they would show similar trend.

Unfortunately NILFS2 has performance issue due to its DAT and Garbage
Collection design, and it seems to be hurting the merit of LFS for
such high-throughput devices.

DAT is metadata which is used to convert indirect block addresses
(called virtual block number) to real block addresses.  This makes
relocation of disk blocks possible, but at the same time, it makes
latency of disk access double against blocks read first time.

To mitigate this design drawback, nilfs is applying readahead for such
metadata, but it has much room for tuning.  For instance, I recently
sent some patches to improve read performance on intel SSD for 2.6.36.

For details on the metadata organization and disk address conversion
of NILFS2, please see the slides:

  http://www.nilfs.org/papers/jls2009-nilfs.pdf

A link page ( http://www.nilfs.org/en/links.html ) has some more
related links.

> 4. What's special has done to optimize the performance of SSD? I guess
> Log-file systems might have better performance than fast file systems
> such as EXT2/3, but at least right now the results shows that I was
> wrong.

As I wrote above, recent SSD drives adopt own LFS like optimization,
and the performance characteristics are greatly affected by it.  It's
well explained in the following article:

  http://lwn.net/Articles/353411/


Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
