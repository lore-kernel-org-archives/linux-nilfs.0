From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/29] xfs: rename XBF_TRYLOCK to
 XBF_NOWAIT
Date: Sat, 26 Aug 2023 07:39:12 +1000
Message-ID: <ZOkfgBlWKVmGN84i@dread.disaster.area>
References: <20230825135431.1317785-1-hao.xu@linux.dev>
 <20230825135431.1317785-3-hao.xu@linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-cachefs-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1692999565;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=YlIwbTf4NFY+lBfWPhxSy9OXMCBOn9GCMNXv5B0g+oU=;
	b=gtcTct1J8oAkyUEWVedJUWNNGgW3SI6moY+2h9y0QKi2glEGuKuIdZvvP9zN4Py5AY4FSb
	0mjCB5EhMAyaYlyeKmgCmpZqAynTLcXLCzVqq5NLTbN3XL7RTg+DyqlnTOIJQbmWvifs7+
	IgZWi4/nhxkn5vE/w6rkT3dlp3W3bZ4=
In-Reply-To: <20230825135431.1317785-3-hao.xu@linux.dev>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/linux-cachefs>, 
 <mailto:linux-cachefs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/linux-cachefs/>
List-Post: <mailto:linux-cachefs@redhat.com>
List-Help: <mailto:linux-cachefs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/linux-cachefs>,
 <mailto:linux-cachefs-request@redhat.com?subject=subscribe>
Errors-To: linux-cachefs-bounces@redhat.com
Sender: "Linux-cachefs" <linux-cachefs-bounces@redhat.com>
Content-Disposition: inline
To: Hao Xu <hao.xu@linux.dev>
Cc: Wanpeng Li <wanpengli@tencent.com>, "Darrick J . Wong" <djwong@kernel.org>, Dominique Martinet <asmadeus@codewreck.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>, linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org, codalist@coda.cs.cmu.edu, cluster-devel@redhat.com, linux-cachefs@redhat.com, linux-ext4@vger.kernel.org, devel@lists.orangefs.org, linux-cifs@vger.kernel.org, ecryptfs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-block@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>, netdev@vger.kernel.org, samba-technical@lists.samba.org, linux-unionfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org

On Fri, Aug 25, 2023 at 09:54:04PM +0800, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> XBF_TRYLOCK means we need lock but don't block on it,

Yes.


> we can use it to
> stand for not waiting for memory allcation. Rename XBF_TRYLOCK to
> XBF_NOWAIT, which is more generic.

No.

Not only can XBF_TRYLOCK require memory allocation, it can require
IO to be issued. We use TRYLOCK for -readahead- and so we *must* be
able to allocate memory and issue IO under TRYLOCK caller
conditions.

[...]

> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index d440393b40eb..2ccb0867824c 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -661,7 +661,7 @@ xfs_attr_rmtval_invalidate(
>  			return error;
>  		if (XFS_IS_CORRUPT(args->dp->i_mount, nmap != 1))
>  			return -EFSCORRUPTED;
> -		error = xfs_attr_rmtval_stale(args->dp, &map, XBF_TRYLOCK);
> +		error = xfs_attr_rmtval_stale(args->dp, &map, XBF_NOWAIT);
>  		if (error)
>  			return error;

XBF_INCORE | XBF_NOWAIT makes no real sense. I mean, XBF_INCORE is
exactly "find a cached buffer or fail" - it's not going to do any
memory allocation or IO so NOWAIT smeantics don't make any sense
here. It's the buffer lock that this lookup is explicitly
avoiding, and so TRYLOCK describes exactly the semantics we want
from this incore lookup.

Indeed, this is a deadlock avoidance mechanism as the transaction
may already have the buffer locked and so we don't want the
xfs_buf_incore() lookup to try to lock the buffer again. TRYLOCK
documents this pretty clearly - NOWAIT loses that context....

> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 6a6503ab0cd7..77c4f1d83475 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -1343,7 +1343,7 @@ xfs_btree_read_buf_block(
>  	int			error;
>  
>  	/* need to sort out how callers deal with failures first */
> -	ASSERT(!(flags & XBF_TRYLOCK));
> +	ASSERT(!(flags & XBF_NOWAIT));
>  
>  	error = xfs_btree_ptr_to_daddr(cur, ptr, &d);
>  	if (error)
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index ac6d8803e660..9312cf3b20e2 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -460,7 +460,7 @@ xrep_invalidate_block(
>  
>  	error = xfs_buf_incore(sc->mp->m_ddev_targp,
>  			XFS_FSB_TO_DADDR(sc->mp, fsbno),
> -			XFS_FSB_TO_BB(sc->mp, 1), XBF_TRYLOCK, &bp);
> +			XFS_FSB_TO_BB(sc->mp, 1), XBF_NOWAIT, &bp);

My point exactly.

xfs_buf_incore() is simply a lookup with XBF_INCORE set. (XBF_INCORE
| XBF_TRYLOCK) has the exactly semantics of "return the buffer only
if it is cached and we can lock it without blocking.

It will not instantiate a new buffer (i.e. do memory allocation) or
do IO because the if it is under IO the buffer lock will be held.

So, essentially, this "NOWAIT" semantic you want is already supplied
by (XBF_INCORE | XBF_TRYLOCK) buffer lookups.

>  	if (error)
>  		return 0;
>  
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 15d1e5a7c2d3..9f84bc3b802c 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -228,7 +228,7 @@ _xfs_buf_alloc(
>  	 * We don't want certain flags to appear in b_flags unless they are
>  	 * specifically set by later operations on the buffer.
>  	 */
> -	flags &= ~(XBF_UNMAPPED | XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD);
> +	flags &= ~(XBF_UNMAPPED | XBF_NOWAIT | XBF_ASYNC | XBF_READ_AHEAD);
>  
>  	atomic_set(&bp->b_hold, 1);
>  	atomic_set(&bp->b_lru_ref, 1);
> @@ -543,7 +543,7 @@ xfs_buf_find_lock(
>  	struct xfs_buf          *bp,
>  	xfs_buf_flags_t		flags)
>  {
> -	if (flags & XBF_TRYLOCK) {
> +	if (flags & XBF_NOWAIT) {
>  		if (!xfs_buf_trylock(bp)) {
>  			XFS_STATS_INC(bp->b_mount, xb_busy_locked);
>  			return -EAGAIN;
> @@ -886,7 +886,7 @@ xfs_buf_readahead_map(
>  	struct xfs_buf		*bp;
>  
>  	xfs_buf_read_map(target, map, nmaps,
> -		     XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD, &bp, ops,
> +		     XBF_NOWAIT | XBF_ASYNC | XBF_READ_AHEAD, &bp, ops,
>  		     __this_address);

That will break readahead (which we use extensively in getdents
operations) if we can't allocate buffers and issue IO under NOWAIT
conditions.

>  }
>  
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 549c60942208..8cd307626939 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -45,7 +45,7 @@ struct xfs_buf;
>  
>  /* flags used only as arguments to access routines */
>  #define XBF_INCORE	 (1u << 29)/* lookup only, return if found in cache */
> -#define XBF_TRYLOCK	 (1u << 30)/* lock requested, but do not wait */
> +#define XBF_NOWAIT	 (1u << 30)/* mem/lock requested, but do not wait */

That's now a really poor comment. It doesn't describe the semantics
or constraints that NOWAIT might imply.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
