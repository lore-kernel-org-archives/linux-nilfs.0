From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Applying nice/ionice to nilfs-cleanerd
Date: Mon, 08 Aug 2011 19:20:14 +0900 (JST)
Message-ID: <20110808.192014.264198882.ryusuke@osrg.net>
References: <28d103cbef1f8ebb3a7b458509e53c4d@mail.shatteredsilicon.net>
	<20110808.082319.114757823.ryusuke@osrg.net>
	<201108081009.31334.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201108081009.31334.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ""@osrg.net
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Gordan Bobic <gordan-UpbECiGlrmGsTnJN9+BGXg@public.gmane.org>

Hi,
On Mon, 8 Aug 2011 10:09:31 +0200, dexen deVries wrote:
> On Monday 08 of August 2011 01:23:19 you wrote:
> > At present, you have to manually invoke the cleanerd through the
> > nice/ionice commands or to run renice/ionice later specifying the
> > process ID of the cleanerd.
> > 
> > One way to make this convenient is introducing new directives in
> > /etc/nilfs_cleanerd.conf as follows:
> > 
> >  # Scheduling priority.
> >  nice 19    # niceness -20~19
> > 
> >  # IO scheduling class.
> >  # Supported classes are default, idle, best-effort, and realtime.
> >  ionice_class  idle
> > 
> >  # IO scheduling priority.
> >  # 0-7 is valid for best-effort and realtime classes.
> >  ionice_data   5
> > 
> > Do you think these extensions make sense ?
> 
> 
> it would be nice (hehe) to be able to temporarily lower cleanerd priority when 
> watching a movie or building software. 
> 
> However, may be a downside to /always/ running cleanerd niced and ioniced.  I 
> believe that currently cleanerd's activity slows other processes down a lot 
> when filesystem is almost full -- which means that it oftet won't become truly 
> full, because clearned will free enough space for other processes to be able 
> to complete their work. If, on the other hand, cleanerd was highly niced and 
> ioniced, it could end up being starved of CPU and disk bandwidth and not 
> freeing enough free space, which could cause other processes to exhaust free 
> space on filesystem and abord when not able to write to filesystem.
> 
> Perhaps it would be enough to have cleanerd automatically switch priority 
> based on available free space. For example, if I had
> min_clean_segments      10%
> max_clean_segments      12%
> 
> then also have
> min_clean_segments_low_prio	8%
> 
> low_prio_nice 19
> normal_prio_nice 0
> 
> low_prio_ionice_class idle
> normal_prio_ionice_class realtime
> 
> which woud mean, `use low priority (nice & ionice) when there's at least 8% of 
> free segments; if there's less use higher priority' -- so cleanerd would 
> reclaim free space more aggressively when there's little free space left.

Your worry and idea are ok, but this enhancement looks rather confusing.

Users would misunderstand switching by the min_clean_segments_low_prio
threshold.

We already have mc_cleaning_interval and mc_nsegments_per_clean which
are applied when the number of clean segments is LESS than
min_clean_segments.  OTOH, the low_prio_xx parameters are applied when
the number of clean segments is LARGER than the
min_clean_segments_low_prio.  The comparision should be inverted.

And, we already have min_clean_segments threashold.  Why not just add
mc_nice and mc_ionice as below (rather than introduce the new
threthold) ?

 # Sheduing priority
 # if clean segments < min_clean_segments.
 mc_nice				-5
 
 # IO sheduing class and priority
 # if clean segments < min_clean_segments.
 mc_ionice			realtime


Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
