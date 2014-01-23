From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH v2 1/5] nilfs-utils: cldconfig add an option to set minimal
 free blocks
Date: Thu, 23 Jan 2014 19:31:44 +0100
Message-ID: <52E16010.3050305@gmx.net>
References: <cover.1390310509.git.andreas.rohner@gmx.net> <22b5b3ac403052d3044dc8c1bebe323191376c03.1390310509.git.andreas.rohner@gmx.net> <B1FCAEBD-EB58-4A06-BD6B-7D4FB533D9F1@dubeyko.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <B1FCAEBD-EB58-4A06-BD6B-7D4FB533D9F1-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2014-01-23 18:49, Vyacheslav Dubeyko wrote:
> 
> On Jan 21, 2014, at 4:59 PM, Andreas Rohner wrote:
> 
>> With this option the user can specify the minimal number of free/dead
>> blocks before a segment can be cleaned.
> 
> "Free or dead" or "free and dead"? What do you mean by free blocks?
> "Free blocks" sounds for me as blocks that I can allocate and to use
> immediately without any operations. If you mean invalid blocks (blocks
> that it was updated in this segment) then I need to do garbage collection
> operation for making it free. So, free blocks are really confusing term. And
> "dead blocks" sounds for me not very good.

I mean updated or deleted blocks, that need to be garbage collected.
Here [1] they are called "dead blocks".

>> This is a threshold for the GC
>> to prevent needless moving of data. If there are less free blocks
>> to gain from cleaning a segment than the specified number, the GC will
>> abort and try again with a different segment.
>>
>> By setting it to 0 this feature is effectively disabled.
>>
>> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
>> ---
>> include/nilfs_cleaner.h           | 19 ++++++++++---------
>> sbin/cleanerd/cldconfig.c         | 40 +++++++++++++++++++++++++++++++++++++++
>> sbin/cleanerd/cldconfig.h         |  4 ++++
>> sbin/cleanerd/cleanerd.c          | 23 ++++++++++++++++++++++
>> sbin/cleanerd/nilfs_cleanerd.conf |  9 +++++++++
>> sbin/nilfs-clean/nilfs-clean.c    | 18 ++++++++++++++----
>> 6 files changed, 100 insertions(+), 13 deletions(-)
>>
>> diff --git a/include/nilfs_cleaner.h b/include/nilfs_cleaner.h
>> index 0bf02aa..42c4aa7 100644
>> --- a/include/nilfs_cleaner.h
>> +++ b/include/nilfs_cleaner.h
>> @@ -46,17 +46,18 @@ struct nilfs_cleaner_args {
>> 	uint64_t start_segnum;	/* start segment number */
>> 	uint64_t nsegs;		/* number of segments */
>> 	uint32_t runtime; /* runtime in seconds */
>> -	uint32_t pad2;
>> +	uint32_t min_free_blocks_threshold;
>> };
>> /* valid flags */
>> -#define NILFS_CLEANER_ARG_PROTECTION_PERIOD	(1 << 0)
>> -#define NILFS_CLEANER_ARG_NSEGMENTS_PER_CLEAN	(1 << 1)
>> -#define NILFS_CLEANER_ARG_CLEANING_INTERVAL	(1 << 2)
>> -#define NILFS_CLEANER_ARG_USAGE_RATE_THRESHOLD	(1 << 3) /* reserved */
>> -#define NILFS_CLEANER_ARG_START_SEGNUM		(1 << 4) /* reserved */
>> -#define NILFS_CLEANER_ARG_NSEGS			(1 << 5) /* reserved */
>> -#define NILFS_CLEANER_ARG_NPASSES		(1 << 6) /* reserved */
>> -#define NILFS_CLEANER_ARG_RUNTIME		(1 << 7) /* reserved */
>> +#define NILFS_CLEANER_ARG_PROTECTION_PERIOD		(1 << 0)
>> +#define NILFS_CLEANER_ARG_NSEGMENTS_PER_CLEAN		(1 << 1)
>> +#define NILFS_CLEANER_ARG_CLEANING_INTERVAL		(1 << 2)
>> +#define NILFS_CLEANER_ARG_USAGE_RATE_THRESHOLD		(1 << 3) /* reserved */
>> +#define NILFS_CLEANER_ARG_START_SEGNUM			(1 << 4) /* reserved */
>> +#define NILFS_CLEANER_ARG_NSEGS				(1 << 5) /* reserved */
>> +#define NILFS_CLEANER_ARG_NPASSES			(1 << 6) /* reserved */
>> +#define NILFS_CLEANER_ARG_RUNTIME			(1 << 7) /* reserved */
>> +#define NILFS_CLEANER_ARG_MIN_FREE_BLOCKS_THRESHOLD	(1 << 8)
> 
> What about NILFS_CLEANER_ARG_MIN_FBLK_THRESHOLD?
> But free blocks really confuse me.

Yes maybe the name is a bit confusing.

>> #define NILFS_CLDCONFIG_SELECTION_POLICY_IMPORTANCE	\
>> @@ -120,6 +122,8 @@ struct nilfs_cldconfig {
>> #define NILFS_CLDCONFIG_RETRY_INTERVAL			60
>> #define NILFS_CLDCONFIG_USE_MMAP			1
>> #define NILFS_CLDCONFIG_LOG_PRIORITY			LOG_INFO
>> +#define NILFS_CLDCONFIG_MIN_FREE_BLOCKS_THRESHOLD	256
>> +#define NILFS_CLDCONFIG_MC_MIN_FREE_BLOCKS_THRESHOLD	128
> 
> Why 256 or 128? What is good? What is bad?
> I am a user. How can I define what value is appropriate?
> How should I think for choosing some value?
> For example, I want to have the fastest performance as possible. How can I define
> an appropriate value? Or, maybe, I want to clean as many segments as possible.
> How should I think?
> 
> Or, maybe, I want combination of GC policies. 

It is the minimal number of dead or free or invalid or however you want
to call them blocks, before a segment is allowed to be cleaned by the
GC. It is a tradeoff, but you are right it is not very intuitive. As I
stated before I am going to change that in the next version.

br,
Andreas Rohner

[1] http://lwn.net/Articles/522507/
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
