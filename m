From: Gordan Bobic <gordan-UpbECiGlrmGsTnJN9+BGXg@public.gmane.org>
Subject: Re: =?UTF-8?Q?nilfs=5Fcleanerd=20using=20a=20lot=20of=20disk-writ?=
 =?UTF-8?Q?e=20bandwidth?=
Date: Tue, 09 Aug 2011 13:25:07 +0100
Message-ID: <4ef54cf8b3d0b2725aa1788d98ffbbe5@mail.shatteredsilicon.net>
References: <94b06fe504b540199f338f9bd4ed890f@mail.shatteredsilicon.net>
 <201108091303.54968.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201108091303.54968.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

 On Tue, 9 Aug 2011 13:03:54 +0200, dexen deVries 
 <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi Gordan,
>
>
> On Tuesday 09 of August 2011 12:18:12 you wrote:
>>  I'm seeing nilfs_cleanerd using a lot of disk write bandwidth 
>> according
>>  to iotop. It seems to be performing approximately equal amounts of 
>> reads
>>  and writes when it is running. Reads I can understand, but why is 
>> it
>>  writing so much in order to garbage collect? Should it not be just
>>  trying to mark blocks as free? The disk I/O r/w symmetry implies 
>> that it
>>  is trying to do something like defragment the file system. Is there 
>> a
>>  way to configure this behaviour in some way? The main use-case I 
>> have
>>  for nilfs is cheap flash media that suffers from terrible 
>> random-write
>>  performance, but on such media this many writes are going to cause 
>> media
>>  failure very quickly. What can be done about this?
>
>
> I'm not a NILFS2 developer, so don't rely too much on the following 
> remarks!
>
> NILFS2 consider filesystem as a (wrapped around) list of segments, by
> default
> each 8MB. Those segments contain both file data and metadata.
>
> cleanerd operates on whole segments; normally either 2 or 4 in one 
> pass
> (depending on remaining free space). It seems to me a segment is 
> reclaimed
> when there is any amount of garbage in it, no matter how small. Thus
> you see,
> in some cases, about as much of read as of write.
>
> One way could be be to make cleanerd configurable so it doesn't 
> reclaim
> segments that have only very little garbage in them. That would
> probably be a
> trade-off between wasted diskspace and lessened bandwidth use.
>
> As for wearing flash media down, I believe NILFS2 is still very good
> for them,
> because it tends to write in large chunks -- much larger than the 
> original
> 512B sector -- and not over-write once written areas (untill 
> reclaimed by
> cleanerd, often much, much later). Once the flash' large erase unit
> is erased,
> NILFS2 append-writes to it, but not over-writes already written data. 
> Which
> means the flash is erased almost as little as possible.

 Interesting. I still think something should be done to minimize the 
 amount of writes required. How about something like the following. 
 Divide situations into 3 classes (thresholds should be adjustable in 
 nilfs_cleanerd.conf):

 1) Free space good (e.g. space >= 25%)
 Don't do any garbage collection at all, unless an entire block contains 
 only garbage.

 2) Free space low (e.g. 10% < space < 25%)
 Run GC as now, with the nice/ionice applied. Only GC blocks where 
 $block_free_space_percent >= $disk_free_space_percent. So as the disk 
 space starts to decrease, the number of blocks that get considered for 
 GC increase, too.

 3) Free space critical (e.g. space < 10%)
 As 2) but start decreasing niceness/ioniceness (niceness by 3 for every 
 1% drop in free space, so for example:
 10% - 19
 ...
 7% - 10
 ...
 4% - 1
 3% - -2
 ...
 1% - -8

 This would give a very gradual increase in GC aggressiveness that would 
 both minimize unnecessary writes that shorted flash life and provide a 
 softer landing in terms of performance degradation as space starts to 
 run out.

 The other idea that comes to mind on top of this is to GC blocks in 
 order of % of space in the block being reclaimable. That would allow for 
 the minimum number of blocks to always be GC-ed to get the free space 
 above the required threshold.

 Thoughts?

 Gordan
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
