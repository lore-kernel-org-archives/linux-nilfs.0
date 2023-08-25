From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 24/29] xfs: support nowait for
 xfs_buf_read_map()
Date: Sat, 26 Aug 2023 07:53:50 +1000
Message-ID: <ZOki7u/zJGmZtL6g@dread.disaster.area>
References: <20230825135431.1317785-1-hao.xu@linux.dev>
 <20230825135431.1317785-25-hao.xu@linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-cachefs-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693000442;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=C7l1YaJD25TqfZ/bjRwlYqAfEB2vwnWqScd01AsuG7U=;
	b=YZ55oAZcPK5s5uySA3+CzA/8+lWXDl9jrBvh31rkYwtGWcLphMqMGfu15E1VUf0ODlJo/X
	BJspBP2QrcNbddtr8Am5fUKJ6RmfC0t/AeTqVN1fONbqg3BJAfd+j3cW1wSKdlq4iM9GAN
	GH2yUx4eCere/90iE8oPtwJXbr3Arfc=
In-Reply-To: <20230825135431.1317785-25-hao.xu@linux.dev>
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

On Fri, Aug 25, 2023 at 09:54:26PM +0800, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> This causes xfstests generic/232 hung in umount process, waiting for ail
> push, so I comment it for now, need some hints from xfs folks.
> Not a real patch.
> 
> Signed-off-by: Hao Xu <howeyxu@tencent.com>
> ---
>  fs/xfs/xfs_buf.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index cdad80e1ae25..284962a9f31a 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -828,6 +828,13 @@ xfs_buf_read_map(
>  	trace_xfs_buf_read(bp, flags, _RET_IP_);
>  
>  	if (!(bp->b_flags & XBF_DONE)) {
> +//		/*
> +//		 * Let's bypass the _xfs_buf_read() for now
> +//		 */
> +//		if (flags & XBF_NOWAIT) {
> +//			xfs_buf_relse(bp);
> +//			return -EAGAIN;
> +//		}

This is *fundamentally broken*, and apart from anything else breaks
readahead.

IF we asked for a read, we cannot instantiate the buffer and then
*not issue any IO on it* and release it. That leaves an
uninitialised buffer in memory, and there's every chance that
something then trips over it and bad things happen.

A buffer like this *must* be errored out and marked stale so that
the next access to it will then re-initialise the buffer state and
trigger any preparatory work that needs to be done for the new
operation.

This comes back to my first comments that XBF_TRYLOCK cannot simpy
be replaced with XBF_NOWAIT semantics...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
