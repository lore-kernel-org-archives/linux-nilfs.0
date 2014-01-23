From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH v2 0/5] nilfs-utils: skip inefficient gc operations
Date: Thu, 23 Jan 2014 19:12:46 +0100
Message-ID: <52E15B9E.6040307@gmx.net>
References: <cover.1390310509.git.andreas.rohner@gmx.net> <85EBEC6B-CA69-472A-8DDD-8E056F809EC4@dubeyko.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <85EBEC6B-CA69-472A-8DDD-8E056F809EC4-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014-01-23 18:48, Vyacheslav Dubeyko wrote:
> 
> On Jan 21, 2014, at 4:59 PM, Andreas Rohner wrote:
> 
>> Hi,
>>
>> This is the second version of this patch set. It replaces the kind of 
>> hacky use of v_flags with a proper implementation of 
>> NILFS_IOCTL_SET_SUINFO ioctl.
>>
>> v1->v2
>> * Implementation of NILFS_IOCTL_SET_SUINFO
>> * Added mc_min_free_blocks_threshold config option
>>  (if clean segments < min_clean_segments)
>> * Added new command line param for nilfs-clean
>> * Update man- and config-files
>> * Simpler benchmark
> 
> If you are talking about something then it should be in patchset.
> Otherwise, why do you mention about it?
> 
>> This patch set implements a small new feature and there shouldn't be
>> any compatibility issues. It enables the GC to check how much free
>> space can be gained from cleaning a segment and if it is less than a
>> certain threshold it will abort the operation and try a different
>> segment.
> 
> When you have cleaned a segment then you can use the whole one.
> So, if segment has 8 MB in size then it will be available 8 MB free space.
> The phrase "It enables the GC to check how much free space can be gained
> from cleaning a segment" really confuses me. Because I always know
> how much space I gain after cleaning every segment. I suppose that you
> mean something different. Am I correct?

You have to move the live blocks to a new segment, so you gain only (8
MB - live_blocks) of free space.

>> Although no blocks need to be moved, the SUFILE entry of the
>> corresponding segment needs to be updated to avoid an infinite loop.
>>
>> This is potentially useful for all gc policies, but it is especially
>> beneficial for the timestamp policy.
> 
> I completely misunderstand this statement. What do you mean?

Well the timestamp policy always selects the oldest segment. If the
oldest segment is below the threshold it won't be cleaned. If we don't
change the timestamp it will be immediately selected again and it
probably will still be below the threshold and so on in an infinite loop.

>> Lets assume for example a NILFS2
>> volume with 20% static files and lets assume these static files are in 
>> the oldest segments. The current timestamp policy will select the oldest 
>> segments and, since the data is static, move them mostly unchanged to 
>> new segments. After a while they will become the oldest segments again. 
>> Then timestamp will move them again. These moving operations are 
>> expensive and unnecessary.
>>
>> I used a simple benchmark to test the patch set (only a few lines of C). 
>> I used a 100 GB partition and performed the following steps:
>>
>> 1. Write a 20 GB file
>> 2. Write a 50 GB file
>> 3. Overwrite chunks of 1 MB within the 50 GB file at random
>> 4. Repeat step 3 until 60 GB of data is written
>>
>> Steps 3 and 4 are only perfomed to get the GC started. So the benchmark 
>> writes a 130 GB in total to a 100 GB partition.
> 
> How is it possible to save 130 GB in 100 GB partition? Are you magician? :) 

I OVERWRITE the 50 GB file. 130 GB is the total amount of data written
to the partition.

>>
>> HHD:
>>    Timestamp GB Written: 340.7574
>>    Timestamp GB Read:    208.2935
>>    Timestamp Runtime:    7787.546s
>>
>>    Patched GB Written:   313.2566
>>    Patched GB Read:      182.6389
>>    Patched Runtime:      7410.892s
>>
>> SSD:
>>    Timestamp GB Written: 679.3901
>>    Timestamp GB Read:    242.59
>>    Timestamp Runtime:    3022.081s
>>
>>    Patched GB Written:   500.0095
>>    Patched GB Read:      157.475   
>>    Patched Runtime:      2313.448
>>
>> The results for the HDD clearly show, that about 20 GB less data has 
>> been written and read in the patched version. It is reasonable to 
>> assume, that these 20 GB are the static data.
>>
>> The speed of the GC was tuned to the HDD. It was probably too aggressive 
>> for the much faster SSD. That is probably the reason why the difference 
>> in GB written and read is much higher than 20 GB.
> 
> I misunderstand completely what you mean here.

You need to be a bit more specific. These are the results of my
benchmark. The GB Written and GB Read values are calculated by simply
importing /proc/diskstats into R (You subtract the values before the
benchmark from those after the benchmark).

The patched version writes less and reads less. Pretty simple.

br,
Andreas Rohner

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
