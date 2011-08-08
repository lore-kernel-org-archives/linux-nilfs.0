From: Gordan Bobic <gordan-UpbECiGlrmGsTnJN9+BGXg@public.gmane.org>
Subject: Re: Applying nice/ionice to nilfs-cleanerd
Date: Mon, 08 Aug 2011 10:16:55 +0100
Message-ID: <1acf9d5248e152de61150d81dd6beab2@mail.shatteredsilicon.net>
References: <28d103cbef1f8ebb3a7b458509e53c4d@mail.shatteredsilicon.net>
 <20110808.082319.114757823.ryusuke@osrg.net>
 <201108081009.31334.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201108081009.31334.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

 On Mon, 8 Aug 2011 10:09:31 +0200, dexen deVries 
 <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

 [lowering cleanerd priority]

> However, may be a downside to /always/ running cleanerd niced and
> ioniced.  I
> believe that currently cleanerd's activity slows other processes down 
> a lot
> when filesystem is almost full -- which means that it oftet won't
> become truly
> full, because clearned will free enough space for other processes to 
> be able
> to complete their work. If, on the other hand, cleanerd was highly 
> niced and
> ioniced, it could end up being starved of CPU and disk bandwidth and 
> not
> freeing enough free space, which could cause other processes to 
> exhaust free
> space on filesystem and abord when not able to write to filesystem.

 I was just thinking about that. This would only be an issue on a system 
 that is either very constrained in terms of disk space or is never idle. 
 though.

> Perhaps it would be enough to have cleanerd automatically switch 
> priority
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
> which woud mean, `use low priority (nice & ionice) when there's at
> least 8% of
> free segments; if there's less use higher priority' -- so cleanerd 
> would
> reclaim free space more aggressively when there's little free space 
> left.

 I was thinking about something similar. Realtime ionice is OTT, though, 
 I don't think it should ever be ioniced over normal. But yes, I think 
 this would be a good idea.

 Gordan
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
