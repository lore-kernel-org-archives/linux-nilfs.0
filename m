From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v2 3/5] nilfs-utils: refactoring of
 nilfs_reclaim_segment to add minblocks param
Date: Sat, 25 Jan 2014 03:04:20 +0900 (JST)
Message-ID: <20140125.030420.27809393.konishi.ryusuke@lab.ntt.co.jp>
References: <cover.1390310509.git.andreas.rohner@gmx.net>
	<cover.1390310509.git.andreas.rohner@gmx.net>
	<36ef66ee15b3de8ca00815a6baa7bf6b62ca57d4.1390310509.git.andreas.rohner@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <36ef66ee15b3de8ca00815a6baa7bf6b62ca57d4.1390310509.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 21 Jan 2014 14:59:42 +0100, Andreas Rohner wrote:
> nilfs_reclaim_segment gathers all the necessary information to decide,
> how many reclaimable blocks there are in the segments that are to be
> cleaned.
> 
> By enabling the passing of the threshold value
> minblocks, nilfs_reclaim_segment can check the actual value against the
> threshold.
> 
> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
> ---
>  include/nilfs_gc.h               | 4 ++--
>  lib/gc.c                         | 5 +++--
>  sbin/cleanerd/cleanerd.c         | 5 +++--
>  sbin/nilfs-resize/nilfs-resize.c | 2 +-
>  4 files changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/include/nilfs_gc.h b/include/nilfs_gc.h
> index 7628ce1..f9fbde4 100644
> --- a/include/nilfs_gc.h
> +++ b/include/nilfs_gc.h
> @@ -15,8 +15,8 @@
>  #include "nilfs.h"
>  
>  ssize_t nilfs_reclaim_segment(struct nilfs *nilfs,
> -			      __u64 *segnums, size_t nsegs,
> -			      __u64 protseq, nilfs_cno_t protcno);
> +			      __u64 *segnums, size_t nsegs, __u64 protseq,
> +			      nilfs_cno_t protcno, unsigned long minblocks);

This breaks compatibility of libnilfsgc library.

Please add new function with the extended arguments, the old function
can share implementation of the new function.

Ryusuke Konishi


>  static inline int nilfs_suinfo_reclaimable(const struct nilfs_suinfo *si)
> diff --git a/lib/gc.c b/lib/gc.c
> index 1152299..0b0e2d6 100644
> --- a/lib/gc.c
> +++ b/lib/gc.c
> @@ -607,10 +607,11 @@ static int nilfs_toss_bdescs(struct nilfs_vector *bdescv)
>   * @nsegs: size of the @segnums array
>   * @protseq: start of sequence number of protected segments
>   * @protcno: start checkpoint number of protected period
> + * @minblocks: minimal number of free blocks in a segment
>   */
>  ssize_t nilfs_reclaim_segment(struct nilfs *nilfs,
> -			      __u64 *segnums, size_t nsegs,
> -			      __u64 protseq, nilfs_cno_t protcno)
> +			      __u64 *segnums, size_t nsegs, __u64 protseq,
> +			      nilfs_cno_t protcno, unsigned long minblocks)
>  {
>  	struct nilfs_vector *vdescv, *bdescv, *periodv, *vblocknrv;
>  	sigset_t sigset, oldset, waitset;
> diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
> index 575656b..6dd9d24 100644
> --- a/sbin/cleanerd/cleanerd.c
> +++ b/sbin/cleanerd/cleanerd.c
> @@ -1372,8 +1372,9 @@ static ssize_t nilfs_cleanerd_clean_segments(struct nilfs_cleanerd *cleanerd,
>  	}
>  	cleanerd->no_timeout = 0;
>  
> -	ret = nilfs_reclaim_segment(cleanerd->nilfs, segnums, nsegs,
> -				    protseq, protcno);
> +	ret = nilfs_reclaim_segment(cleanerd->nilfs, segnums,
> +			nsegs, protseq, protcno,
> +			nilfs_cleanerd_min_free_blocks_threshold(cleanerd));
>  	if (ret > 0) {
>  		for (i = 0; i < ret; i++)
>  			syslog(LOG_DEBUG, "segment %llu cleaned",
> diff --git a/sbin/nilfs-resize/nilfs-resize.c b/sbin/nilfs-resize/nilfs-resize.c
> index c8b0868..2850268 100644
> --- a/sbin/nilfs-resize/nilfs-resize.c
> +++ b/sbin/nilfs-resize/nilfs-resize.c
> @@ -595,7 +595,7 @@ static ssize_t nilfs_resize_move_segments(struct nilfs *nilfs,
>  			return -1;
>  
>  		ret = nilfs_reclaim_segment(nilfs, snp, nc,
> -					    sustat.ss_prot_seq, 0);
> +					    sustat.ss_prot_seq, 0, 0);
>  		if (ret < 0)
>  			return -1;
>  
> -- 
> 1.8.5.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
