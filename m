From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 1/5] nilfs-utils: cldconfig add an option to set minimal free blocks
Date: Thu, 23 Jan 2014 20:49:15 +0300
Message-ID: <B1FCAEBD-EB58-4A06-BD6B-7D4FB533D9F1@dubeyko.com>
References: <cover.1390310509.git.andreas.rohner@gmx.net> <22b5b3ac403052d3044dc8c1bebe323191376c03.1390310509.git.andreas.rohner@gmx.net>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=WD868+VwZrHKw0+uW0yZwPn6f2w9eIfZYWKCZoVfP7k=;
	b=IDBUcwsNqLvQHfzh29FHCFaNPSpK3WNRPuWeG+16X44KCBNGyP8Nq3bS9rPhrcvOOQ/F01+cWUipkOWgod6ZNZ6Aop+e3GDeU2aC2NJoVGdTe8hRLw6ZxywZB03opzDM;
In-Reply-To: <22b5b3ac403052d3044dc8c1bebe323191376c03.1390310509.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


On Jan 21, 2014, at 4:59 PM, Andreas Rohner wrote:

> With this option the user can specify the minimal number of free/dead
> blocks before a segment can be cleaned.

"Free or dead" or "free and dead"? What do you mean by free blocks?
"Free blocks" sounds for me as blocks that I can allocate and to use
immediately without any operations. If you mean invalid blocks (blocks
that it was updated in this segment) then I need to do garbage collection
operation for making it free. So, free blocks are really confusing term. And
"dead blocks" sounds for me not very good.

> This is a threshold for the GC
> to prevent needless moving of data. If there are less free blocks
> to gain from cleaning a segment than the specified number, the GC will
> abort and try again with a different segment.
> 
> By setting it to 0 this feature is effectively disabled.
> 
> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
> ---
> include/nilfs_cleaner.h           | 19 ++++++++++---------
> sbin/cleanerd/cldconfig.c         | 40 +++++++++++++++++++++++++++++++++++++++
> sbin/cleanerd/cldconfig.h         |  4 ++++
> sbin/cleanerd/cleanerd.c          | 23 ++++++++++++++++++++++
> sbin/cleanerd/nilfs_cleanerd.conf |  9 +++++++++
> sbin/nilfs-clean/nilfs-clean.c    | 18 ++++++++++++++----
> 6 files changed, 100 insertions(+), 13 deletions(-)
> 
> diff --git a/include/nilfs_cleaner.h b/include/nilfs_cleaner.h
> index 0bf02aa..42c4aa7 100644
> --- a/include/nilfs_cleaner.h
> +++ b/include/nilfs_cleaner.h
> @@ -46,17 +46,18 @@ struct nilfs_cleaner_args {
> 	uint64_t start_segnum;	/* start segment number */
> 	uint64_t nsegs;		/* number of segments */
> 	uint32_t runtime; /* runtime in seconds */
> -	uint32_t pad2;
> +	uint32_t min_free_blocks_threshold;
> };
> /* valid flags */
> -#define NILFS_CLEANER_ARG_PROTECTION_PERIOD	(1 << 0)
> -#define NILFS_CLEANER_ARG_NSEGMENTS_PER_CLEAN	(1 << 1)
> -#define NILFS_CLEANER_ARG_CLEANING_INTERVAL	(1 << 2)
> -#define NILFS_CLEANER_ARG_USAGE_RATE_THRESHOLD	(1 << 3) /* reserved */
> -#define NILFS_CLEANER_ARG_START_SEGNUM		(1 << 4) /* reserved */
> -#define NILFS_CLEANER_ARG_NSEGS			(1 << 5) /* reserved */
> -#define NILFS_CLEANER_ARG_NPASSES		(1 << 6) /* reserved */
> -#define NILFS_CLEANER_ARG_RUNTIME		(1 << 7) /* reserved */
> +#define NILFS_CLEANER_ARG_PROTECTION_PERIOD		(1 << 0)
> +#define NILFS_CLEANER_ARG_NSEGMENTS_PER_CLEAN		(1 << 1)
> +#define NILFS_CLEANER_ARG_CLEANING_INTERVAL		(1 << 2)
> +#define NILFS_CLEANER_ARG_USAGE_RATE_THRESHOLD		(1 << 3) /* reserved */
> +#define NILFS_CLEANER_ARG_START_SEGNUM			(1 << 4) /* reserved */
> +#define NILFS_CLEANER_ARG_NSEGS				(1 << 5) /* reserved */
> +#define NILFS_CLEANER_ARG_NPASSES			(1 << 6) /* reserved */
> +#define NILFS_CLEANER_ARG_RUNTIME			(1 << 7) /* reserved */
> +#define NILFS_CLEANER_ARG_MIN_FREE_BLOCKS_THRESHOLD	(1 << 8)

What about NILFS_CLEANER_ARG_MIN_FBLK_THRESHOLD?
But free blocks really confuse me.

> 
> enum {
> 	NILFS_CLEANER_STATUS_IDLE,
> diff --git a/sbin/cleanerd/cldconfig.c b/sbin/cleanerd/cldconfig.c
> index 270d360..4d7589c 100644
> --- a/sbin/cleanerd/cldconfig.c
> +++ b/sbin/cleanerd/cldconfig.c
> @@ -456,6 +456,34 @@ nilfs_cldconfig_handle_mc_nsegments_per_clean(struct nilfs_cldconfig *config,
> }
> 
> static int
> +nilfs_cldconfig_handle_min_free_blocks(struct nilfs_cldconfig *config,
> +				       char **tokens, size_t ntoks,
> +				       struct nilfs *nilfs)
> +{
> +	unsigned long n;
> +
> +	if (nilfs_cldconfig_get_ulong_argument(tokens, ntoks, &n) < 0)
> +		return 0;
> +
> +	config->cf_min_free_blocks_threshold = n;
> +	return 0;
> +}
> +
> +static int
> +nilfs_cldconfig_handle_mc_min_free_blocks(struct nilfs_cldconfig *config,
> +					  char **tokens, size_t ntoks,
> +					  struct nilfs *nilfs)
> +{
> +	unsigned long n;
> +
> +	if (nilfs_cldconfig_get_ulong_argument(tokens, ntoks, &n) < 0)
> +		return 0;
> +
> +	config->cf_mc_min_free_blocks_threshold = n;
> +	return 0;
> +}
> +
> +static int
> nilfs_cldconfig_handle_cleaning_interval(struct nilfs_cldconfig *config,
> 					 char **tokens, size_t ntoks,
> 					 struct nilfs *nilfs)
> @@ -576,6 +604,14 @@ nilfs_cldconfig_keyword_table[] = {
> 		"log_priority", 2, 2,
> 		nilfs_cldconfig_handle_log_priority
> 	},
> +	{
> +		"min_free_blocks_threshold", 2, 2,
> +		nilfs_cldconfig_handle_min_free_blocks
> +	},
> +	{
> +		"mc_min_free_blocks_threshold", 2, 2,
> +		nilfs_cldconfig_handle_mc_min_free_blocks
> +	},
> };
> 
> #define NILFS_CLDCONFIG_NKEYWORDS			\
> @@ -641,6 +677,10 @@ static void nilfs_cldconfig_set_default(struct nilfs_cldconfig *config,
> 	config->cf_retry_interval.tv_usec = 0;
> 	config->cf_use_mmap = NILFS_CLDCONFIG_USE_MMAP;
> 	config->cf_log_priority = NILFS_CLDCONFIG_LOG_PRIORITY;
> +	config->cf_min_free_blocks_threshold =
> +		NILFS_CLDCONFIG_MIN_FREE_BLOCKS_THRESHOLD;
> +	config->cf_mc_min_free_blocks_threshold =
> +		NILFS_CLDCONFIG_MC_MIN_FREE_BLOCKS_THRESHOLD;
> }
> 
> static inline int iseol(int c)
> diff --git a/sbin/cleanerd/cldconfig.h b/sbin/cleanerd/cldconfig.h
> index 188ce9b..49ee6be 100644
> --- a/sbin/cleanerd/cldconfig.h
> +++ b/sbin/cleanerd/cldconfig.h
> @@ -102,6 +102,8 @@ struct nilfs_cldconfig {
> 	struct timeval cf_retry_interval;
> 	int cf_use_mmap;
> 	int cf_log_priority;
> +	unsigned long cf_min_free_blocks_threshold;
> +	unsigned long cf_mc_min_free_blocks_threshold;
> };
> 
> #define NILFS_CLDCONFIG_SELECTION_POLICY_IMPORTANCE	\
> @@ -120,6 +122,8 @@ struct nilfs_cldconfig {
> #define NILFS_CLDCONFIG_RETRY_INTERVAL			60
> #define NILFS_CLDCONFIG_USE_MMAP			1
> #define NILFS_CLDCONFIG_LOG_PRIORITY			LOG_INFO
> +#define NILFS_CLDCONFIG_MIN_FREE_BLOCKS_THRESHOLD	256
> +#define NILFS_CLDCONFIG_MC_MIN_FREE_BLOCKS_THRESHOLD	128

Why 256 or 128? What is good? What is bad?
I am a user. How can I define what value is appropriate?
How should I think for choosing some value?
For example, I want to have the fastest performance as possible. How can I define
an appropriate value? Or, maybe, I want to clean as many segments as possible.
How should I think?

Or, maybe, I want combination of GC policies. 

Thanks,
Vyacheslav Dubeyko.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
