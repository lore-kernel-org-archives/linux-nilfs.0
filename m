From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH RFC] nilfs2: add a tracepoint for tracking stage
 transition of segment construction
Date: Thu, 04 Sep 2014 03:23:01 +0900 (JST)
Message-ID: <20140904.032301.485257681380760394.konishi.ryusuke@lab.ntt.co.jp>
References: <1409660379-17011-1-git-send-email-mitake.hitoshi@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=kp854rBrKNQ+r2RMZXrSZeRUtvyWko6jurddIsV3YQo=;
        b=uZhvCwcHEKRx1lawx1LhsTRx0v08tk+0P465JfyaKR5YWuvVBnM85uclryKmow6Rj3
         L5RgekwrcGaSZJeCwmreR3L4lH0K+V1h9Kt0deg+fMjObZOXw+gqq9fHRlrTBVS00C/W
         HvRa5MOLx7FrzWyKfMdI298tJoZ8E63Gp3xYI4O8k9p+YfPXkzNc+8xWHKIXDU4TVM7b
         un2y9BZCt7XvKqLpV6kz78h6LMpPCO+3aLfJqmq0TGCt7HJtYLtIO+ouZdqBVoGAziYG
         c0c+FXp5HPDqSiPiOjKm5fGNkFyTKKIx7cXfWyt7wyU49MeI8Wbtq30kSW8iIWYXjwBl
         zEmQ==
In-Reply-To: <1409660379-17011-1-git-send-email-mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Mitake Hitoshi <mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

Hi Mitake-san,
On Tue,  2 Sep 2014 21:19:39 +0900, Mitake Hitoshi wrote:
> From: Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
> 
> This patch adds a tracepoint for tracking stage transition of block
> collection in segment construction. With the tracepoint, we can
> analysis the behavior of segment construction in depth. It would be
> useful for bottleneck detection and debugging, etc.
> 
> The tracepoint is created with the standard trace API of linux (like
> ext3, ext4, f2fs and btrfs). So we can analysis with existing tools
> easily. Of course, more detailed analysis will be possible if we can
> create nilfs specific analysis tools.
> 
> Below is an example of event dump with Brendan Gregg's perf-tools
> (https://github.com/brendangregg/perf-tools). Time consumption between
> each stage can be obtained.
> 
> $ sudo bin/tpoint nilfs2:nilfs2_collection_stage_transition
> Tracing nilfs2:nilfs2_collection_stage_transition. Ctrl-C to end.
>         segctord-14875 [003] ...1 28311.067794: nilfs2_collection_stage_transition: sci = ffff8800ce6de000, stage = ST_INIT
>         segctord-14875 [003] ...1 28311.068139: nilfs2_collection_stage_transition: sci = ffff8800ce6de000, stage = ST_GC
>         segctord-14875 [003] ...1 28311.068139: nilfs2_collection_stage_transition: sci = ffff8800ce6de000, stage = ST_FILE
>         segctord-14875 [003] ...1 28311.068486: nilfs2_collection_stage_transition: sci = ffff8800ce6de000, stage = ST_IFILE
>         segctord-14875 [003] ...1 28311.068540: nilfs2_collection_stage_transition: sci = ffff8800ce6de000, stage = ST_CPFILE
>         segctord-14875 [003] ...1 28311.068561: nilfs2_collection_stage_transition: sci = ffff8800ce6de000, stage = ST_SUFILE
>         segctord-14875 [003] ...1 28311.068565: nilfs2_collection_stage_transition: sci = ffff8800ce6de000, stage = ST_DAT
>         segctord-14875 [003] ...1 28311.068573: nilfs2_collection_stage_transition: sci = ffff8800ce6de000, stage = ST_SR
>         segctord-14875 [003] ...1 28311.068574: nilfs2_collection_stage_transition: sci = ffff8800ce6de000, stage = ST_DONE
> 
> For capturing transition correctly, this patch renames the member scnt
> of nilfs_cstage and adds wrappers for the member. With this change,
> every transition of the stage can produce trace event in a correct
> manner.
> 
> Of course the tracepoint added by this patch is very limited, so we
> need to add more points for detailed analysis. This patch is something
> like demonstration. If this concept is acceptable for the nilfs
> community, I'd like to add more tracepoints and prepare analysis
> tools.

Great!

This tracepoint support looks to be what I wanted to introduce to
nilfs2 to help debugging and performance analysis. I felt it's really
nice after I tried this patch with the perf-tools though I am not
familiar with the manner of the tracepoints.

Could you proceed this work from what you think useful ?  I will help
sending this work to upstream step by step, and would like to extend
it learning various tracepoint features.

By the way, your mail addresses differ between the author line (from
line) and the sob line.  Can you include a "From" line so that the
mail addresses match between them.

Thanks,
Ryusuke Konishi

> Signed-off-by: Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
> ---
>  fs/nilfs2/segment.c           | 70 ++++++++++++++++++++++++++++++-------------
>  fs/nilfs2/segment.h           |  5 ++--
>  include/trace/events/nilfs2.h | 50 +++++++++++++++++++++++++++++++
>  3 files changed, 103 insertions(+), 22 deletions(-)
>  create mode 100644 include/trace/events/nilfs2.h
> 
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index a1a1916..e841e22 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -76,6 +76,35 @@ enum {
>  	NILFS_ST_DONE,
>  };
>  
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/nilfs2.h>
> +
> +/*
> + * nilfs_sc_cstage_inc(), nilfs_sc_cstage_set(), nilfs_sc_cstage_get() are
> + * wrapper functions of stage count (nilfs_sc_info->sc_stage.__scnt). Users of
> + * the variable must use them because transition of stage count must involve
> + * trace events (trace_nilfs2_collection_stage_transition).
> + *
> + * nilfs_sc_cstage_get() isn't required for the above purpose because it doesn't
> + * produce events. It is provided just for making the intention clear.
> + */
> +static inline void nilfs_sc_cstage_inc(struct nilfs_sc_info *sci)
> +{
> +	sci->sc_stage.__scnt++;
> +	trace_nilfs2_collection_stage_transition(sci);
> +}
> +
> +static inline void nilfs_sc_cstage_set(struct nilfs_sc_info *sci, int next_scnt)
> +{
> +	sci->sc_stage.__scnt = next_scnt;
> +	trace_nilfs2_collection_stage_transition(sci);
> +}
> +
> +static inline int nilfs_sc_cstage_get(struct nilfs_sc_info *sci)
> +{
> +	return sci->sc_stage.__scnt;
> +}
> +
>  /* State flags of collection */
>  #define NILFS_CF_NODE		0x0001	/* Collecting node blocks */
>  #define NILFS_CF_IFILE_STARTED	0x0002	/* IFILE stage has started */
> @@ -1055,7 +1084,7 @@ static int nilfs_segctor_collect_blocks(struct nilfs_sc_info *sci, int mode)
>  	size_t ndone;
>  	int err = 0;
>  
> -	switch (sci->sc_stage.scnt) {
> +	switch (nilfs_sc_cstage_get(sci)) {
>  	case NILFS_ST_INIT:
>  		/* Pre-processes */
>  		sci->sc_stage.flags = 0;
> @@ -1064,7 +1093,7 @@ static int nilfs_segctor_collect_blocks(struct nilfs_sc_info *sci, int mode)
>  			sci->sc_nblk_inc = 0;
>  			sci->sc_curseg->sb_sum.flags = NILFS_SS_LOGBGN;
>  			if (mode == SC_LSEG_DSYNC) {
> -				sci->sc_stage.scnt = NILFS_ST_DSYNC;
> +				nilfs_sc_cstage_set(sci, NILFS_ST_DSYNC);
>  				goto dsync_mode;
>  			}
>  		}
> @@ -1072,10 +1101,10 @@ static int nilfs_segctor_collect_blocks(struct nilfs_sc_info *sci, int mode)
>  		sci->sc_stage.dirty_file_ptr = NULL;
>  		sci->sc_stage.gc_inode_ptr = NULL;
>  		if (mode == SC_FLUSH_DAT) {
> -			sci->sc_stage.scnt = NILFS_ST_DAT;
> +			nilfs_sc_cstage_set(sci, NILFS_ST_DAT);
>  			goto dat_stage;
>  		}
> -		sci->sc_stage.scnt++;  /* Fall through */
> +		nilfs_sc_cstage_inc(sci);  /* Fall through */
>  	case NILFS_ST_GC:
>  		if (nilfs_doing_gc()) {
>  			head = &sci->sc_gc_inodes;
> @@ -1096,7 +1125,7 @@ static int nilfs_segctor_collect_blocks(struct nilfs_sc_info *sci, int mode)
>  			}
>  			sci->sc_stage.gc_inode_ptr = NULL;
>  		}
> -		sci->sc_stage.scnt++;  /* Fall through */
> +		nilfs_sc_cstage_inc(sci);  /* Fall through */
>  	case NILFS_ST_FILE:
>  		head = &sci->sc_dirty_files;
>  		ii = list_prepare_entry(sci->sc_stage.dirty_file_ptr, head,
> @@ -1118,10 +1147,10 @@ static int nilfs_segctor_collect_blocks(struct nilfs_sc_info *sci, int mode)
>  		}
>  		sci->sc_stage.dirty_file_ptr = NULL;
>  		if (mode == SC_FLUSH_FILE) {
> -			sci->sc_stage.scnt = NILFS_ST_DONE;
> +			nilfs_sc_cstage_set(sci, NILFS_ST_DONE);
>  			return 0;
>  		}
> -		sci->sc_stage.scnt++;
> +		nilfs_sc_cstage_inc(sci);
>  		sci->sc_stage.flags |= NILFS_CF_IFILE_STARTED;
>  		/* Fall through */
>  	case NILFS_ST_IFILE:
> @@ -1129,7 +1158,7 @@ static int nilfs_segctor_collect_blocks(struct nilfs_sc_info *sci, int mode)
>  					      &nilfs_sc_file_ops);
>  		if (unlikely(err))
>  			break;
> -		sci->sc_stage.scnt++;
> +		nilfs_sc_cstage_inc(sci);
>  		/* Creating a checkpoint */
>  		err = nilfs_segctor_create_checkpoint(sci);
>  		if (unlikely(err))
> @@ -1140,7 +1169,7 @@ static int nilfs_segctor_collect_blocks(struct nilfs_sc_info *sci, int mode)
>  					      &nilfs_sc_file_ops);
>  		if (unlikely(err))
>  			break;
> -		sci->sc_stage.scnt++;  /* Fall through */
> +		nilfs_sc_cstage_inc(sci);  /* Fall through */
>  	case NILFS_ST_SUFILE:
>  		err = nilfs_sufile_freev(nilfs->ns_sufile, sci->sc_freesegs,
>  					 sci->sc_nfreesegs, &ndone);
> @@ -1156,7 +1185,7 @@ static int nilfs_segctor_collect_blocks(struct nilfs_sc_info *sci, int mode)
>  					      &nilfs_sc_file_ops);
>  		if (unlikely(err))
>  			break;
> -		sci->sc_stage.scnt++;  /* Fall through */
> +		nilfs_sc_cstage_inc(sci);  /* Fall through */
>  	case NILFS_ST_DAT:
>   dat_stage:
>  		err = nilfs_segctor_scan_file(sci, nilfs->ns_dat,
> @@ -1164,10 +1193,10 @@ static int nilfs_segctor_collect_blocks(struct nilfs_sc_info *sci, int mode)
>  		if (unlikely(err))
>  			break;
>  		if (mode == SC_FLUSH_DAT) {
> -			sci->sc_stage.scnt = NILFS_ST_DONE;
> +			nilfs_sc_cstage_set(sci, NILFS_ST_DONE);
>  			return 0;
>  		}
> -		sci->sc_stage.scnt++;  /* Fall through */
> +		nilfs_sc_cstage_inc(sci);  /* Fall through */
>  	case NILFS_ST_SR:
>  		if (mode == SC_LSEG_SR) {
>  			/* Appending a super root */
> @@ -1177,7 +1206,7 @@ static int nilfs_segctor_collect_blocks(struct nilfs_sc_info *sci, int mode)
>  		}
>  		/* End of a logical segment */
>  		sci->sc_curseg->sb_sum.flags |= NILFS_SS_LOGEND;
> -		sci->sc_stage.scnt = NILFS_ST_DONE;
> +		nilfs_sc_cstage_set(sci, NILFS_ST_DONE);
>  		return 0;
>  	case NILFS_ST_DSYNC:
>   dsync_mode:
> @@ -1190,7 +1219,7 @@ static int nilfs_segctor_collect_blocks(struct nilfs_sc_info *sci, int mode)
>  		if (unlikely(err))
>  			break;
>  		sci->sc_curseg->sb_sum.flags |= NILFS_SS_LOGEND;
> -		sci->sc_stage.scnt = NILFS_ST_DONE;
> +		nilfs_sc_cstage_set(sci, NILFS_ST_DONE);
>  		return 0;
>  	case NILFS_ST_DONE:
>  		return 0;
> @@ -1435,7 +1464,8 @@ static int nilfs_segctor_collect(struct nilfs_sc_info *sci,
>  			goto failed;
>  
>  		/* The current segment is filled up */
> -		if (mode != SC_LSEG_SR || sci->sc_stage.scnt < NILFS_ST_CPFILE)
> +		if (mode != SC_LSEG_SR ||
> +		    nilfs_sc_cstage_get(sci) < NILFS_ST_CPFILE)
>  			break;
>  
>  		nilfs_clear_logs(&sci->sc_segbufs);
> @@ -1924,7 +1954,7 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
>  	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
>  	int err;
>  
> -	sci->sc_stage.scnt = NILFS_ST_INIT;
> +	nilfs_sc_cstage_set(sci, NILFS_ST_INIT);
>  	sci->sc_cno = nilfs->ns_cno;
>  
>  	err = nilfs_segctor_collect_dirty_files(sci, nilfs);
> @@ -1952,7 +1982,7 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
>  			goto failed;
>  
>  		/* Avoid empty segment */
> -		if (sci->sc_stage.scnt == NILFS_ST_DONE &&
> +		if (nilfs_sc_cstage_get(sci) == NILFS_ST_DONE &&
>  		    nilfs_segbuf_empty(sci->sc_curseg)) {
>  			nilfs_segctor_abort_construction(sci, nilfs, 1);
>  			goto out;
> @@ -1966,7 +1996,7 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
>  			nilfs_segctor_fill_in_file_bmap(sci);
>  
>  		if (mode == SC_LSEG_SR &&
> -		    sci->sc_stage.scnt >= NILFS_ST_CPFILE) {
> +		    nilfs_sc_cstage_get(sci) >= NILFS_ST_CPFILE) {
>  			err = nilfs_segctor_fill_in_checkpoint(sci);
>  			if (unlikely(err))
>  				goto failed_to_write;
> @@ -1985,7 +2015,7 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
>  		if (unlikely(err))
>  			goto failed_to_write;
>  
> -		if (sci->sc_stage.scnt == NILFS_ST_DONE ||
> +		if (nilfs_sc_cstage_get(sci) == NILFS_ST_DONE ||
>  		    nilfs->ns_blocksize_bits != PAGE_CACHE_SHIFT) {
>  			/*
>  			 * At this point, we avoid double buffering
> @@ -1998,7 +2028,7 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
>  			if (err)
>  				goto failed_to_write;
>  		}
> -	} while (sci->sc_stage.scnt != NILFS_ST_DONE);
> +	} while (nilfs_sc_cstage_get(sci) != NILFS_ST_DONE);
>  
>   out:
>  	nilfs_segctor_drop_written_files(sci, nilfs);
> diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
> index 38a1d00..1e9b931 100644
> --- a/fs/nilfs2/segment.h
> +++ b/fs/nilfs2/segment.h
> @@ -66,13 +66,14 @@ struct nilfs_recovery_info {
>  
>  /**
>   * struct nilfs_cstage - Context of collection stage
> - * @scnt: Stage count
> + * @__scnt: Stage count, must be accessed via wrappers:
> + *          nilfs_sc_cstage_inc(), nilfs_sc_cstage_set(), nilfs_sc_cstage_get()
>   * @flags: State flags
>   * @dirty_file_ptr: Pointer on dirty_files list, or inode of a target file
>   * @gc_inode_ptr: Pointer on the list of gc-inodes
>   */
>  struct nilfs_cstage {
> -	int			scnt;
> +	int			__scnt;
>  	unsigned		flags;
>  	struct nilfs_inode_info *dirty_file_ptr;
>  	struct nilfs_inode_info *gc_inode_ptr;
> diff --git a/include/trace/events/nilfs2.h b/include/trace/events/nilfs2.h
> new file mode 100644
> index 0000000..ede71a0
> --- /dev/null
> +++ b/include/trace/events/nilfs2.h
> @@ -0,0 +1,50 @@
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM nilfs2
> +
> +#if !defined(_TRACE_NILFS2_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_NILFS2_H
> +
> +#include <linux/tracepoint.h>
> +
> +struct nilfs_sc_info;
> +
> +#define show_collection_stage(type)					\
> +	__print_symbolic(type,						\
> +	{ NILFS_ST_INIT, "ST_INIT" },					\
> +	{ NILFS_ST_GC, "ST_GC" },					\
> +	{ NILFS_ST_FILE, "ST_FILE" },					\
> +	{ NILFS_ST_IFILE, "ST_IFILE" },					\
> +	{ NILFS_ST_CPFILE, "ST_CPFILE" },				\
> +	{ NILFS_ST_SUFILE, "ST_SUFILE" },				\
> +	{ NILFS_ST_DAT, "ST_DAT" },					\
> +	{ NILFS_ST_SR, "ST_SR" },					\
> +	{ NILFS_ST_DSYNC, "ST_DSYNC" },					\
> +	{ NILFS_ST_DONE, "ST_DONE"})
> +
> +TRACE_EVENT(nilfs2_collection_stage_transition,
> +
> +	    TP_PROTO(struct nilfs_sc_info *sci),
> +
> +	    TP_ARGS(sci),
> +
> +	    TP_STRUCT__entry(
> +		    __field(void *, sci)
> +		    __field(int, stage)
> +	    ),
> +
> +	    TP_fast_assign(
> +			__entry->sci = sci;
> +			__entry->stage = sci->sc_stage.__scnt;
> +		    ),
> +
> +	    TP_printk("sci = %p, stage = %s",
> +		      __entry->sci,
> +		      show_collection_stage(__entry->stage))
> +);
> +
> +#endif /* _TRACE_NILFS2_H */
> +
> +/* This part must be outside protection */
> +#undef TRACE_INCLUDE_FILE
> +#define TRACE_INCLUDE_FILE nilfs2
> +#include <trace/define_trace.h>
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
