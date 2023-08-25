From: Hao Xu <hao.xu@linux.dev>
Subject: [PATCH 24/29] xfs: support nowait for xfs_buf_read_map()
Date: Fri, 25 Aug 2023 21:54:26 +0800
Message-ID: <20230825135431.1317785-25-hao.xu@linux.dev>
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
 bh=xYVJABOgP4/8L2CV4jLRK/KE5S9+YcPlTWp5R3EisXs=; b=iXrWfR2NZSQ/h1PYxDKVz2w+c9
 3Wxpk7PiqCT5N3RXxD+nIxa4a0OQtAWKWQQ2mQjBqIi54R0tOeoOhgQ6MVi1GZF3t6csIGwg1bFrw
 /YqX9FiHxi2Z4kbQNA2tYK1sAQwDYaLAfzDu99UkEvHjdi4ACHXFSCmusIPvaGqDehb0=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=xYVJABOgP4/8L2CV4jLRK/KE5S9+YcPlTWp5R3EisXs=; b=GNt6wnb4Qf8zXGA5LLeDUCyH1G
 DXt2zPsGgz2h3+RJ4zA7uxCPlhUZnlXMxRTULQlYDFCBocdJs3QVkE0Mu7NqVt/MUdsTHjHlO2zeY
 BNE4ZukGKtT2pZQ4Pmtjieljx6BO7m7qjwSCFaDyL2YgiC0NN8ayp35tpru6Fvfs/Zpo=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1692972304;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=xYVJABOgP4/8L2CV4jLRK/KE5S9+YcPlTWp5R3EisXs=;
 b=mPHInzP0NdE0PARLrMiNVwBxHc2RcZZ9h1TcJI1UDo2PmUbrGHosmFv1DSPqUTrb8M6kqp
 4M25de/KL1vHeKbgvgWIJvfxIGajB7oK9YCJR4tOksovz6wykfv/qKqEWZZksomlKe2dSa
 K35zik9gA6wCtduft3CmT9CQD0iaLDk=
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

This causes xfstests generic/232 hung in umount process, waiting for ail
push, so I comment it for now, need some hints from xfs folks.
Not a real patch.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/xfs/xfs_buf.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index cdad80e1ae25..284962a9f31a 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -828,6 +828,13 @@ xfs_buf_read_map(
 	trace_xfs_buf_read(bp, flags, _RET_IP_);
 
 	if (!(bp->b_flags & XBF_DONE)) {
+//		/*
+//		 * Let's bypass the _xfs_buf_read() for now
+//		 */
+//		if (flags & XBF_NOWAIT) {
+//			xfs_buf_relse(bp);
+//			return -EAGAIN;
+//		}
 		/* Initiate the buffer read and wait. */
 		XFS_STATS_INC(target->bt_mount, xb_get_read);
 		bp->b_ops = ops;
-- 
2.25.1
