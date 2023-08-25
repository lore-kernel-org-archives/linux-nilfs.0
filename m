From: Hao Xu <hao.xu@linux.dev>
Subject: [PATCH 28/29] xfs: support nowait semantics for
 xc_ctx_lock in xlog_cil_commit()
Date: Fri, 25 Aug 2023 21:54:30 +0800
Message-ID: <20230825135431.1317785-29-hao.xu@linux.dev>
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
 bh=o5eD4gq5Ypmv7xNjaJcQB3ZOSw79lNA3YgufxQ7kbUU=; b=UedNVGiGYIWkN4hjfXmv+Fjo54
 CfENgG/MNAzHh8s/B9cwl7+tV8oqiSf83JzJEXgf78j3wQ3RW7uCrxPNaIn38j4PBTI4MNR4nF2Ro
 Za5infCqajVRlMZ2v1s6ojdg7H2hE/XjuHKJN0GKkOTF3BFE1oLdOC9Bel+oiiWbULZ0=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=o5eD4gq5Ypmv7xNjaJcQB3ZOSw79lNA3YgufxQ7kbUU=; b=IpByl2jfb5vGs0N4155iCjK4RZ
 mm6VYwc+XOCoQU2G35lE/sCOUIUHXXHUAjGqEFRmIz3ZxeqdQAeU+pF4YfK6L8xOxawYgzAcp6+Gk
 dyvDdBXyQ0J9ivacweqyBrNZ2qpPARrmoxOlqzXIkCovW56p0gFllNeQ/G8vJa7D7c7w=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1692972368;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=o5eD4gq5Ypmv7xNjaJcQB3ZOSw79lNA3YgufxQ7kbUU=;
 b=IDkI/8FcKGXMrBLpAzKCujyKyUIvnRClPZG+PDDA+Kg6Ww/HgNrG0d8/UaYBPttRvdNV2G
 ImRsaH6EObyEWgQtf31bAS82oxf65cz7kpZXIj7D5nH1V4igKHLmt2T1OZkYhVy9UsI8OJ
 u9rq7LaZ7EE10dyazZwRdVBs5aqDaMI=
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

Apply trylock logic for xc_ctx_lock in xlog_cil_commit() in nowait
case and error out -EAGAIN for xlog_cil_commit().

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/xfs/xfs_log_cil.c  | 12 ++++++++++--
 fs/xfs/xfs_log_priv.h |  2 +-
 fs/xfs/xfs_trans.c    |  4 +++-
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index b31830ee36dd..6d054359bbb5 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1613,7 +1613,7 @@ xlog_cil_process_intents(
  * background commit, returns without it held once background commits are
  * allowed again.
  */
-void
+int
 xlog_cil_commit(
 	struct xlog		*log,
 	struct xfs_trans	*tp,
@@ -1623,6 +1623,7 @@ xlog_cil_commit(
 	struct xfs_cil		*cil = log->l_cilp;
 	struct xfs_log_item	*lip, *next;
 	uint32_t		released_space = 0;
+	bool			nowait = tp->t_flags & XFS_TRANS_NOWAIT;
 
 	/*
 	 * Do all necessary memory allocation before we lock the CIL.
@@ -1632,7 +1633,12 @@ xlog_cil_commit(
 	xlog_cil_alloc_shadow_bufs(log, tp);
 
 	/* lock out background commit */
-	down_read(&cil->xc_ctx_lock);
+	if (nowait) {
+		if (!down_read_trylock(&cil->xc_ctx_lock))
+			return -EAGAIN;
+	} else {
+		down_read(&cil->xc_ctx_lock);
+	}
 
 	if (tp->t_flags & XFS_TRANS_HAS_INTENT_DONE)
 		released_space = xlog_cil_process_intents(cil, tp);
@@ -1668,6 +1674,8 @@ xlog_cil_commit(
 
 	/* xlog_cil_push_background() releases cil->xc_ctx_lock */
 	xlog_cil_push_background(log);
+
+	return 0;
 }
 
 /*
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 41edaa0ae869..eb7a1241deab 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -580,7 +580,7 @@ int	xlog_cil_init(struct xlog *log);
 void	xlog_cil_init_post_recovery(struct xlog *log);
 void	xlog_cil_destroy(struct xlog *log);
 bool	xlog_cil_empty(struct xlog *log);
-void	xlog_cil_commit(struct xlog *log, struct xfs_trans *tp,
+int	xlog_cil_commit(struct xlog *log, struct xfs_trans *tp,
 			xfs_csn_t *commit_seq, bool regrant);
 void	xlog_cil_set_ctx_write_state(struct xfs_cil_ctx *ctx,
 			struct xlog_in_core *iclog);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index f1f84a3dd456..e5beda636a37 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1037,7 +1037,9 @@ __xfs_trans_commit(
 		xfs_trans_apply_sb_deltas(tp);
 	xfs_trans_apply_dquot_deltas(tp);
 
-	xlog_cil_commit(log, tp, &commit_seq, regrant);
+	error = xlog_cil_commit(log, tp, &commit_seq, regrant);
+	if (error)
+		goto out_unreserve;
 
 	xfs_trans_free(tp);
 
-- 
2.25.1
