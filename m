From: Gordan Bobic <gordan-UpbECiGlrmGsTnJN9+BGXg@public.gmane.org>
Subject: Re: =?UTF-8?Q?nilfs=5Fcleanerd=20using=20a=20lot=20of=20disk-writ?=
 =?UTF-8?Q?e=20bandwidth?=
Date: Tue, 09 Aug 2011 16:45:13 +0100
Message-ID: <ef928634707358934e3537e47185ae12@mail.shatteredsilicon.net>
References: <94b06fe504b540199f338f9bd4ed890f@mail.shatteredsilicon.net>
 <201108091303.54968.dexen.devries@gmail.com>
 <4ef54cf8b3d0b2725aa1788d98ffbbe5@mail.shatteredsilicon.net>
 <201108091719.01585.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201108091719.01585.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

 On Tue, 9 Aug 2011 17:19:01 +0200, dexen deVries 
 <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Tuesday 09 of August 2011 14:25:07 you wrote:
>>  Interesting. I still think something should be done to minimize the
>>  amount of writes required. How about something like the following.
>>  Divide situations into 3 classes (thresholds should be adjustable 
>> in
>>  nilfs_cleanerd.conf):
>>
>>  1) Free space good (e.g. space >= 25%)
>>  Don't do any garbage collection at all, unless an entire block 
>> contains
>>  only garbage.
>>
>>  2) Free space low (e.g. 10% < space < 25%)
>>  Run GC as now, with the nice/ionice applied. Only GC blocks where
>>  $block_free_space_percent >= $disk_free_space_percent. So as the 
>> disk
>>  space starts to decrease, the number of blocks that get considered 
>> for
>>  GC increase, too.
>>
>>  3) Free space critical (e.g. space < 10%)
>>  As 2) but start decreasing niceness/ioniceness (niceness by 3 for 
>> every
>>  1% drop in free space, so for example:
>>  10% - 19
>>  ...
>>  7% - 10
>>  ...
>>  4% - 1
>>  3% - -2
>>  ...
>>  1% - -8
>>
>>  This would give a very gradual increase in GC aggressiveness that 
>> would
>>  both minimize unnecessary writes that shorted flash life and 
>> provide a
>>  softer landing in terms of performance degradation as space starts 
>> to
>>  run out.
>>
>>  The other idea that comes to mind on top of this is to GC blocks in
>>  order of % of space in the block being reclaimable. That would 
>> allow for
>>  the minimum number of blocks to always be GC-ed to get the free 
>> space
>>  above the required threshold.
>>
>>  Thoughts?
>
>
> Could end up being too slow. A 2TB filesystem has about 260'000
> segments (given
> the default size of 8MB). cleanerd already takes quite a bit of CPU
> power  at times.
>
> Also, cleanerd can do a lot of HDD seeks, if some parts of metadata
> aren't in
> cache. Performing some 260'000 seeks on a harddrive would take 
> anywhere from
> 1000 to 3000 seconds; that not very interactive. Actually, it gets
> dangerously close to an hour.
>
> However, if the cleanerd did not have to follow this exact algorithm, 
> but
> instead id something roughly similar (heueristics rather than 
> algorithm), it
> could be good enough.

 Well, you could adjust all the numbers in the algorithm. :)

 As an aside, why would you use nilfs on a multi-TB FS? What's the 
 advantage? The way I see it the killer application for nilfs is slow 
 flash media with (probably) poorly implemented wear leveling.

 The idea of the above is that you don't end up suffering poor disk 
 performance due to background clean-up until you actually have a 
 plausible chance of running out of space. What is the point of GC-ing if 
 there is already 80% of empty space ready for writing to? All you'll be 
 doing is making the fs slow for no obvious gain.

> Possibly related, I'd love if cleanerd tented to do some mild
> de-fragmentation
> of files. Not necessarily full-blown, exact defragmentation, just
> placing quite stuff close together.

 If it's garbage collecting involves reading a block and re-writing it 
 without the deleted data, then isn't that already effectively 
 defragmenting the fs?

 Gordan
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
