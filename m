From: Hao Xu <hao.xu@linux.dev>
Subject: [PATCH 02/29] xfs: rename XBF_TRYLOCK to XBF_NOWAIT
Date: Fri, 25 Aug 2023 21:54:04 +0800
Message-ID: <20230825135431.1317785-3-hao.xu@linux.dev>
References: <20230825135431.1317785-1-hao.xu@linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Transfer-Encoding:MIME-Version:References:
 In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=T0rAQ2m4NCOjyQSS+sDl9LbRcvD63qBgcFke1LvzwG4=; b=KJGvAs/DAr7x7ba8XUEa/pyx4t
 mK+gixvMDl2e1AtOaCDYggfaY5AxhBM2H/CgzzkYg5FqCXe+jOp3fcQkq42O6Q70pNJwiJtGnL7b8
 TbLMV7pStgnLtRvjkjCB7bmJ86BnK7EFg/Kah2MR/IOvQ+zSuDWpiXe4854wRV60KFHo=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=T0rAQ2m4NCOjyQSS+sDl9LbRcvD63qBgcFke1LvzwG4=; b=Ysv0JYVrOmj6kn68LxCpfoo0QD
 8rel3dn1iUz+e0dxHqoq6juC3fCXISn494Bl7hEgHSkZsHsQIN0P7cpRl7RpIzXMjMuu/xGTA53pD
 Eskjy1F/eaDmys2/pSBMZZaC1pz7W5vJ3wrvLJ0+t/aQvintfrHRFUE7eYEolaCbuQqI=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1692971737;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=T0rAQ2m4NCOjyQSS+sDl9LbRcvD63qBgcFke1LvzwG4=;
 b=FhWBDojlb1xYVHNahPbh8JswlNyJ/7jP1EQwNTm7cO8OehSugwUDArDmc1mbqA0BkMNMvY
 d5QJXx+UI3kBCUhvBoGQg8tDI16sv1k0yhgjUCPvI7yY9h5j0N5DBUGFQcYH7e2p4/SYF7
 drCs2jVg1zT9ErcXMBzhoggf+SCjkYU=
In-Reply-To: <20230825135431.1317785-1-hao.xu@linux.dev>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Wanpeng Li <wanpengli@tencent.com>, "Darrick J . Wong" <djwong@kernel.org>, Dominique Martinet <asmadeus@codewreck.org>, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>, linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org, codalist@coda.cs.cmu.edu, cluster-devel@redhat.com, linux-cachefs@redhat.com, linux-ext4@vger.kernel.org, devel@lists.orangefs.org, linux-cifs@vger.kernel.org, ecryptfs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-block@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, netdev@vger.kernel.org, samba-technical@lists.samba.org, linux-unionfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org, bpf@vger.kernel.o

From: Hao Xu <howeyxu@tencent.com>

XBF_TRYLOCK means we need lock but don't block on it, we can use it to
stand for not waiting for memory allcation. Rename XBF_TRYLOCK to
XBF_NOWAIT, which is more generic.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/xfs/libxfs/xfs_alloc.c       | 2 +-
 fs/xfs/libxfs/xfs_attr_remote.c | 2 +-
 fs/xfs/libxfs/xfs_btree.c       | 2 +-
 fs/xfs/scrub/repair.c           | 2 +-
 fs/xfs/xfs_buf.c                | 6 +++---
 fs/xfs/xfs_buf.h                | 4 ++--
 fs/xfs/xfs_dquot.c              | 2 +-
 7 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 3069194527dd..a75b9298faa8 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3183,7 +3183,7 @@ xfs_alloc_read_agf(
 	ASSERT((flags & (XFS_ALLOC_FLAG_FREEING | XFS_ALLOC_FLAG_TRYLOCK)) !=
 			(XFS_ALLOC_FLAG_FREEING | XFS_ALLOC_FLAG_TRYLOCK));
 	error = xfs_read_agf(pag, tp,
-			(flags & XFS_ALLOC_FLAG_TRYLOCK) ? XBF_TRYLOCK : 0,
+			(flags & XFS_ALLOC_FLAG_TRYLOCK) ? XBF_NOWAIT : 0,
 			&agfbp);
 	if (error)
 		return error;
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index d440393b40eb..2ccb0867824c 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -661,7 +661,7 @@ xfs_attr_rmtval_invalidate(
 			return error;
 		if (XFS_IS_CORRUPT(args->dp->i_mount, nmap != 1))
 			return -EFSCORRUPTED;
-		error = xfs_attr_rmtval_stale(args->dp, &map, XBF_TRYLOCK);
+		error = xfs_attr_rmtval_stale(args->dp, &map, XBF_NOWAIT);
 		if (error)
 			return error;
 
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 6a6503ab0cd7..77c4f1d83475 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1343,7 +1343,7 @@ xfs_btree_read_buf_block(
 	int			error;
 
 	/* need to sort out how callers deal with failures first */
-	ASSERT(!(flags & XBF_TRYLOCK));
+	ASSERT(!(flags & XBF_NOWAIT));
 
 	error = xfs_btree_ptr_to_daddr(cur, ptr, &d);
 	if (error)
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index ac6d8803e660..9312cf3b20e2 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -460,7 +460,7 @@ xrep_invalidate_block(
 
 	error = xfs_buf_incore(sc->mp->m_ddev_targp,
 			XFS_FSB_TO_DADDR(sc->mp, fsbno),
-			XFS_FSB_TO_BB(sc->mp, 1), XBF_TRYLOCK, &bp);
+			XFS_FSB_TO_BB(sc->mp, 1), XBF_NOWAIT, &bp);
 	if (error)
 		return 0;
 
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 15d1e5a7c2d3..9f84bc3b802c 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -228,7 +228,7 @@ _xfs_buf_alloc(
 	 * We don't want certain flags to appear in b_flags unless they are
 	 * specifically set by later operations on the buffer.
 	 */
-	flags &= ~(XBF_UNMAPPED | XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD);
+	flags &= ~(XBF_UNMAPPED | XBF_NOWAIT | XBF_ASYNC | XBF_READ_AHEAD);
 
 	atomic_set(&bp->b_hold, 1);
 	atomic_set(&bp->b_lru_ref, 1);
@@ -543,7 +543,7 @@ xfs_buf_find_lock(
 	struct xfs_buf          *bp,
 	xfs_buf_flags_t		flags)
 {
-	if (flags & XBF_TRYLOCK) {
+	if (flags & XBF_NOWAIT) {
 		if (!xfs_buf_trylock(bp)) {
 			XFS_STATS_INC(bp->b_mount, xb_busy_locked);
 			return -EAGAIN;
@@ -886,7 +886,7 @@ xfs_buf_readahead_map(
 	struct xfs_buf		*bp;
 
 	xfs_buf_read_map(target, map, nmaps,
-		     XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD, &bp, ops,
+		     XBF_NOWAIT | XBF_ASYNC | XBF_READ_AHEAD, &bp, ops,
 		     __this_address);
 }
 
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 549c60942208..8cd307626939 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -45,7 +45,7 @@ struct xfs_buf;
 
 /* flags used only as arguments to access routines */
 #define XBF_INCORE	 (1u << 29)/* lookup only, return if found in cache */
-#define XBF_TRYLOCK	 (1u << 30)/* lock requested, but do not wait */
+#define XBF_NOWAIT	 (1u << 30)/* mem/lock requested, but do not wait */
 #define XBF_UNMAPPED	 (1u << 31)/* do not map the buffer */
 
 
@@ -68,7 +68,7 @@ typedef unsigned int xfs_buf_flags_t;
 	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
 	/* The following interface flags should never be set */ \
 	{ XBF_INCORE,		"INCORE" }, \
-	{ XBF_TRYLOCK,		"TRYLOCK" }, \
+	{ XBF_NOWAIT,		"NOWAIT" }, \
 	{ XBF_UNMAPPED,		"UNMAPPED" }
 
 /*
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 7f071757f278..5bc01ed4b2d7 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1233,7 +1233,7 @@ xfs_qm_dqflush(
 	 * Get the buffer containing the on-disk dquot
 	 */
 	error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, dqp->q_blkno,
-				   mp->m_quotainfo->qi_dqchunklen, XBF_TRYLOCK,
+				   mp->m_quotainfo->qi_dqchunklen, XBF_NOWAIT,
 				   &bp, &xfs_dquot_buf_ops);
 	if (error == -EAGAIN)
 		goto out_unlock;
-- 
2.25.1
