From: Christian Smith <csmith-r5H9PUQoNxUga4AWyxku7ULnMzgEhdHr@public.gmane.org>
Subject: Re: NILFS2 under stress
Date: Fri, 15 Jun 2012 17:50:24 +0100
Message-ID: <20120615165024.GI16953@csmith-bm.vm.bytemark.co.uk>
References: <CAPLqH6x7OCXS95w7-J+DLdiVkKAuKm=-8ofGwL-rcC19Z679bw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAPLqH6x7OCXS95w7-J+DLdiVkKAuKm=-8ofGwL-rcC19Z679bw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zavi Zavi <zavi05-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Jun 15, 2012 at 12:07:23PM +0300, Zavi Zavi wrote:
> Hi,
> 
> I've been experimenting with NILFS2 on a 8GB USB stick.
> I repeatedly created and deleted a 128MB file. After about 60 attempts, the
> disk got 100% full, and would not respond anymore.
> 
> So I tried repeating this setup after changing the GC settings to be much
> more agressive GC policy
> protection_period       0
> min_clean_segments      10%
> max_clean_segments      20%
> clean_check_interval    1
> nsegments_per_clean     20
> mc_nsegments_per_clean  40
> cleaning_interval       1
> mc_cleaning_interval    1
> retry_interval          3
> 
> This time I was able to do the above even for 80 times, and indeed saw that
> the free space on the device was periodically decreased
> 
> So I continued with filling up the file system to about half of its
> capacity (3.5GB) with large 128MB files.
> I then tried running a small 60 seconds fileserver benchmark of FileBench,
> which uses 1.5GB.
> I was able to run it twice, but then the system got 100% full again, and
> non-responsive.
> I tried running nilfs_cleanerd manually, tried remounting. nothing worked.
> 
> Is NILFS known to be sensitive to stress tests? Is this expected?
> Or am I doing something wrong?

NILFS is certainly sensitive to running out of space. I think NILFS
tries to keep some segments free, for emergency situations. To clean,
there must be some free segments to clean into.

I've also noticed if the cleaner encounters corrupted state, all bets
are off, as it'll never get past the corrupted block and so will
never clean anymore. Eventually the disk will fill and a dump/restore is
the only option. But I've only seen this after power failures, when
running on cheap SSD (I only run it on cheap SSD, as they benefit the
most from the sequential writes).

Basically, if you're running from an 8GB FLASH stick, the machine is not
going to be doing heavy IO. If you are doing heavy IO, then you'll have
a better IO system, which will perform better with a traditional non-COW
filesystem.

The other thing to bear in mind is that setting the protection period
so small will result in the clearner cleaning constantly if you disk
fills beyond the thresholds. This is not healthy, especially for such
small cheap SSD, which will be using the lowest grade FLASH.

Finally, the biggest problem I find on such small devices is doing 
upgrades. Following debian testing, you can easily require 1G+ of upgrades
in the course of a week, and it is difficult to do those all at once if
NILFS is short of space. For some reason, dpkg must use lots of temporary
files, which burn through NILFS disk space.

In summary, I think NILFS is fantastic in short bursts of heavy pressure
so long as space isn't exhausted.

Christian
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
