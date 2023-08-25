From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 25/29] xfs: support nowait for
 xfs_buf_item_init()
Date: Sat, 26 Aug 2023 08:16:15 +1000
Message-ID: <ZOkoL8nuXJDVZM1H@dread.disaster.area>
References: <20230825135431.1317785-1-hao.xu@linux.dev>
 <20230825135431.1317785-26-hao.xu@linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-cachefs-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693001787;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=e7wexPTMQfq9UjuBTM8Ip0+eBUjIvA9qLgDcWCTyiHM=;
	b=LfjC6V+VrxwN/GF7d4jh+eKXQjnwgCccx34QtvYy1wsvyHP76WQ/AinA0QjnOu7HDKq3+p
	HGT27Twb19UuEmFhV9lR9oEpMqJ9jP0MxtFdY8+UNR2NN3ZlQJEjvtebAt42PJapNQfrL7
	2+RG2YZPNjsqmihtwBNX5oR9Jv4TYVI=
In-Reply-To: <20230825135431.1317785-26-hao.xu@linux.dev>
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

On Fri, Aug 25, 2023 at 09:54:27PM +0800, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> support nowait for xfs_buf_item_init() and error out -EAGAIN to
> _xfs_trans_bjoin() when it would block.
> 
> Signed-off-by: Hao Xu <howeyxu@tencent.com>
> ---
>  fs/xfs/xfs_buf_item.c         |  9 +++++++--
>  fs/xfs/xfs_buf_item.h         |  2 +-
>  fs/xfs/xfs_buf_item_recover.c |  2 +-
>  fs/xfs/xfs_trans_buf.c        | 16 +++++++++++++---
>  4 files changed, 22 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 023d4e0385dd..b1e63137d65b 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -827,7 +827,8 @@ xfs_buf_item_free_format(
>  int
>  xfs_buf_item_init(
>  	struct xfs_buf	*bp,
> -	struct xfs_mount *mp)
> +	struct xfs_mount *mp,
> +	bool   nowait)
>  {
>  	struct xfs_buf_log_item	*bip = bp->b_log_item;
>  	int			chunks;
> @@ -847,7 +848,11 @@ xfs_buf_item_init(
>  		return 0;
>  	}
>  
> -	bip = kmem_cache_zalloc(xfs_buf_item_cache, GFP_KERNEL | __GFP_NOFAIL);
> +	bip = kmem_cache_zalloc(xfs_buf_item_cache,
> +				GFP_KERNEL | (nowait ? 0 : __GFP_NOFAIL));
> +	if (!bip)
> +		return -EAGAIN;
> +
>  	xfs_log_item_init(mp, &bip->bli_item, XFS_LI_BUF, &xfs_buf_item_ops);
>  	bip->bli_buf = bp;

I see filesystem shutdowns....

> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index 016371f58f26..a1e4f2e8629a 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -57,13 +57,14 @@ xfs_trans_buf_item_match(
>   * If the buffer does not yet have a buf log item associated with it,
>   * then allocate one for it.  Then add the buf item to the transaction.
>   */
> -STATIC void
> +STATIC int
>  _xfs_trans_bjoin(
>  	struct xfs_trans	*tp,
>  	struct xfs_buf		*bp,
>  	int			reset_recur)
>  {
>  	struct xfs_buf_log_item	*bip;
> +	int ret;
>  
>  	ASSERT(bp->b_transp == NULL);
>  
> @@ -72,7 +73,11 @@ _xfs_trans_bjoin(
>  	 * it doesn't have one yet, then allocate one and initialize it.
>  	 * The checks to see if one is there are in xfs_buf_item_init().
>  	 */
> -	xfs_buf_item_init(bp, tp->t_mountp);
> +	ret = xfs_buf_item_init(bp, tp->t_mountp,
> +				tp->t_flags & XFS_TRANS_NOWAIT);
> +	if (ret < 0)
> +		return ret;
> +
>  	bip = bp->b_log_item;
>  	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
>  	ASSERT(!(bip->__bli_format.blf_flags & XFS_BLF_CANCEL));
> @@ -92,6 +97,7 @@ _xfs_trans_bjoin(
>  	xfs_trans_add_item(tp, &bip->bli_item);
>  	bp->b_transp = tp;
>  
> +	return 0;
>  }
>  
>  void
> @@ -309,7 +315,11 @@ xfs_trans_read_buf_map(
>  	}
>  
>  	if (tp) {
> -		_xfs_trans_bjoin(tp, bp, 1);
> +		error = _xfs_trans_bjoin(tp, bp, 1);
> +		if (error) {
> +			xfs_buf_relse(bp);
> +			return error;
> +		}
>  		trace_xfs_trans_read_buf(bp->b_log_item);

So what happens at the callers when we have a dirty transaction and
joining a buffer fails with -EAGAIN?

Apart from the fact this may well propagate -EAGAIN up to userspace,
cancelling a dirty transaction at this point will result in a
filesystem shutdown....

Indeed, this can happen in the "simple" timestamp update case that
this "nowait" semantic is being aimed at. We log the inode in the
timestamp update, which dirties the log item and registers a
precommit operation to be run. We commit the
transaction, which then runs xfs_inode_item_precommit() and that
may need to attach the inode to the inode cluster buffer. This
results in:

xfs_inode_item_precommit
  xfs_imap_to_bp
    xfs_trans_read_buf_map
      _xfs_trans_bjoin
        xfs_buf_item_init(XFS_TRANS_NOWAIT)
	  kmem_cache_zalloc(GFP_NOFS)
	  <memory allocation fails>
      gets -EAGAIN error
    propagates -EAGAIN
  fails due to -EAGAIN

And now xfs_trans_commit() fails with a dirty transaction and the
filesystem shuts down.

IOWs, XFS_TRANS_NOWAIT as it stands is fundamentally broken. Once we
dirty an item in a transaction, we *cannot* back out of the
transaction. We *must block* in every place that could fail -
locking, memory allocation and/or IO - until the transaction
completes because we cannot undo the changes we've already made to
the dirty items in the transaction....

It's even worse than that - once we have committed intents, the
whole chain of intent processing must be run to completionr. Hence
we can't tolerate backing out of that defered processing chain half
way through because we might have to block.

Until we can roll back partial dirty transactions and partially
completed defered intent chains at any random point of completion,
XFS_TRANS_NOWAIT will not work.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
