From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 26/29] xfs: return -EAGAIN when nowait
 meets sync in transaction commit
Date: Sat, 26 Aug 2023 07:58:14 +1000
Message-ID: <ZOkj9uTkoHPR/tDV@dread.disaster.area>
References: <20230825135431.1317785-1-hao.xu@linux.dev>
 <20230825135431.1317785-27-hao.xu@linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-cachefs-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693000705;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=cW0O3/wWg85PEwrPYradZqDoNdNN7Dl46r59zYmNTQA=;
	b=g9DJ/meDpM8Jp3tWcAFdNnEHzQCZZm+0ghBBbbadOm2j/vsHwSTfSL3QRKXMdReftHtuQN
	kk3eY41uLFOfGp1L/VaattXQLLEKZPwIpPTkmdWXd4EWA1qL1bU0l2FGZfqdq5Z6MgLt01
	1avXgG7hZFBREq9U9DwZxnmMGplkBLQ=
In-Reply-To: <20230825135431.1317785-27-hao.xu@linux.dev>
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

On Fri, Aug 25, 2023 at 09:54:28PM +0800, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> if the log transaction is a sync one, let's fail the nowait try and
> return -EAGAIN directly since sync transaction means blocked by IO.
> 
> Signed-off-by: Hao Xu <howeyxu@tencent.com>
> ---
>  fs/xfs/xfs_trans.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 7988b4c7f36e..f1f84a3dd456 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -968,12 +968,24 @@ __xfs_trans_commit(
>  	xfs_csn_t		commit_seq = 0;
>  	int			error = 0;
>  	int			sync = tp->t_flags & XFS_TRANS_SYNC;
> +	bool			nowait = tp->t_flags & XFS_TRANS_NOWAIT;
> +	bool			perm_log = tp->t_flags & XFS_TRANS_PERM_LOG_RES;
>  
>  	trace_xfs_trans_commit(tp, _RET_IP_);
>  
> +	if (nowait && sync) {
> +		/*
> +		 * Currently nowait is only from xfs_vn_update_time()
> +		 * so perm_log is always false here, but let's make
> +		 * code general.
> +		 */
> +		if (perm_log)
> +			xfs_defer_cancel(tp);
> +		goto out_unreserve;
> +	}

This is fundamentally broken.  We cannot about a transaction commit
with dirty items at this point with shutting down the filesystem.

This points to XFS_TRANS_NOWAIT being completely broken, too,
because we don't call xfs_trans_set_sync() until just before we
commit the transaction. At this point, it is -too late- for
nowait+sync to be handled gracefully, and it will *always* go bad.

IOWs, the whole transaction "nowait" semantics as designed and
implemented is not a workable solution....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
