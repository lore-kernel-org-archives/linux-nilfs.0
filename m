From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Applying nice/ionice to nilfs-cleanerd
Date: Mon, 08 Aug 2011 20:59:32 +0900 (JST)
Message-ID: <20110808.205932.260179154.ryusuke@osrg.net>
References: <201108081009.31334.dexen.devries@gmail.com>
	<20110808.192014.264198882.ryusuke@osrg.net>
	<201108081227.54922.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201108081227.54922.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 8 Aug 2011 12:27:54 +0200, dexen deVries wrote:
> On Monday 08 of August 2011 12:20:14 you wrote:
> > And, we already have min_clean_segments threashold.  Why not just add
> > mc_nice and mc_ionice as below (rather than introduce the new
> > threthold) ?
> > 
> >  # Sheduing priority
> >  # if clean segments < min_clean_segments.
> >  mc_nice				-5
> > 
> >  # IO sheduing class and priority
> >  # if clean segments < min_clean_segments.
> >  mc_ionice			realtime
> 
> switching to faster free-space reclaimation already increases load on the 
> computer. If this also switched cleanerd to higher priority at the same 
> moment, the load increase could be sharp and unpleaseant. The idea was to have 
> three levels of cleanerd operation, rather than two.
> 
> 1) slow operation
> 2) fast operation -- when less than min_clean_segments is available
> 3) fast & aggressive (high nice and ionice priority) -- when there's even less 
> free space available
> 
> ...with the hope that the 3rd level would rarely ever be reached, because the 
>
> 2nd level would suffice most of the time.

Maybe, we should reorganize config parameters when using three or more
operation levels.  I feel we are reaching the breaking point from the
standpoint of both readability of the conffile and complexity of the
implementation.

I'm thinking about the following structural description (or git config
format and so on) for v2.2.

But, for the meantime, I'd like to add mc_nice and mc_ionice to avoid
the starvation issue simply.


mode default {
    device                 *   # target device (implicit)
    cleaning_interval      5
    nsegments_per_clean    2
    nice                   0
    ionice                 idle
}

mode low_capacity {
    start                  free_space < 10%
    exit                   free_space >= 20%
    cleaning_interval      1
    nsegments_per_clean    4
}

mode emerg {
    start                  free_space < 8%
    exit                   free_space >= 12%
    nice                   -5
    ionice                 realtime
}

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
