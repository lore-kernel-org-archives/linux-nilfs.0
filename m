From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [static superblock discussion] Does nilfs2 do any in-place writes?
Date: Thu, 30 Jan 2014 11:35:05 +0300
Message-ID: <71B2806D-7CF2-4992-A588-EB73EADFFF9F@dubeyko.com>
References: <1389787304.3913.28.camel@slavad-ubuntu> <20140116.002353.94325733.konishi.ryusuke@lab.ntt.co.jp> <1389866912.2565.44.camel@slavad-ubuntu> <20140118.090008.194171715.konishi.ryusuke@lab.ntt.co.jp> <1390901114.2942.11.camel@slavad-ubuntu-12.04> <CAFvQSYSu5CGxs+K6bZUCtq17PrS_paX3bXBuLBRTba_XWYGgAg@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=ym/qFtfRqRj+DH9eAIh+pm660xxHy2cL1G/TI3lFkns=;
	b=VpTVaU4YdNoBzzPupH3bNhhIV8ZB/E0hY7hzaFX4zSqZgEKmYMnp32T4D+By9EsYyECulRn1RJxa0wzXgo+mKEynI8C57UOx/nH2Pr/B54Rqd1EUD9g/rYiwfYlscCAq;
In-Reply-To: <CAFvQSYSu5CGxs+K6bZUCtq17PrS_paX3bXBuLBRTba_XWYGgAg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Clemens,

On Jan 29, 2014, at 9:18 PM, Clemens Eisserer wrote:

> Hi Vyacheslav,
> 
> Just to make sure I understand your approach: You reserve two areas (a
> few mb in size) which are dedicated to hold only super-root data and
> this data is written at the same frequency as the current superblock?

This statement is not fully correct. First of all, primary and secondary
reserved areas should have different frequencies. I suggest
to add information in the secondary reserved area (volume end) during
volume umount or with some big timeout in the case of significant system
uptime.

Primary reserved area should be written by super roots more frequently
than secondary reserved area. Maybe this information should be written
with the same frequency as superblock's updates, currently. But, anyway,
it will be not in-place update as currently. Information will be added by
means of COW policy. Moreover, replication of super roots will increase
reliability, as I suppose.

> If so, this most likely won't improve the situation for flash media
> with weak FTL - as those writes will still be concentrated around a
> few erase blocks. For devices with powerful FTL such as modern SSDs,
> updating the superblock periodically doesn't pose a real problem.
> 

I suppose that my suggestion can improve situation for any FTL.
Why do I think so? First of all, we will change in-place update of
superblocks on policy of filling reserved areas by means of COW
policy. So, as a result, any FTL can use more simple algorithms of
providing clear erase blocks from a pool.

You are worried that writes will be concentrated around a few erase
blocks. But you need to take into account that you are talking about
logical blocks. Because any FTL implements algorithm of mapping
logical blocks into physical once with the goal of wear leveling. So,
in-place update really complicates situation for any FTL. But COW
policy should improve situation for any FTL always because opportunity
to implement efficient algorithm of wear leveling in more simple manner.

So, as a result, when you are talking about logical block placement
then it doesn't mean that you are talking about writes in few physical
erase blocks. Because only mapping table of FTL knows what physical
erase blocks are changed really.

> I am still somewhat favour an optional simple linear-scan.
> Would it be possible to check at mount-time whether the volume was
> cleanly unmounted and otherwise perform a linear scan?

We know about clean (or unclean) umount from the superblock.
So, you should update superblock for keeping such knowledge.
Otherwise, you will need to perform linear scan always.

> So when I mount the volume with o=no_superblock_update a flag is set
> in the superblock, which is reset on a clean volume unmount after the
> most recent segment has been stored in the superblock.
> When at mount-time the flag is still set, nilfs knows a scan is
> required as the segment in the superblock is not up-to-date.
> 

I don't quite follow your thought. If we will not update superblock then
how we can save any changes in superblock? After any mount
s_last_cno can be changed very frequently because of GC activity.
As a result, linear scan will pass through hundreds or thousands segments
without superblock update or any other technique of keeping knowledge
about latest segment.

Thanks,
Vyacheslav Dubeyko.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
