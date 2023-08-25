From: Hao Xu <hao.xu@linux.dev>
Subject: [PATCH 19/29] xfs: support nowait memory allocation in
 _xfs_buf_alloc()
Date: Fri, 25 Aug 2023 21:54:21 +0800
Message-ID: <20230825135431.1317785-20-hao.xu@linux.dev>
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
 bh=oO47LbY0b5fVyG7D8YYQFkwRO57XM5uT3mfj/DxMSkA=; b=lDHHVVaS9CBRxbKUuvD/25UrZG
 9mcQjaFHEjp0K9T0saRB+egxnI2UvGLiIePFsfcQ0kgkgCd6o3lGlcKajyJVPJTzJPMY1uHkyT2QA
 1SRigado+Ygogvfs5tg+xvvQQJ4r24tyndBEcY6cMnXcoUyDccVbgJ5La8Wod7Nz6pbo=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=oO47LbY0b5fVyG7D8YYQFkwRO57XM5uT3mfj/DxMSkA=; b=cm2uZOwhbMDKc7WCyWyNdNmJ1V
 s1kVgssQweemM+vcFF1lXNwkytBKO1W2wyuoWzpzWUsORpTjWXY88eKdChItVQcvzWlLOi4RrxkHs
 e2Y6f++W4KYVUzuvF0fducyh7bCWY6yxbk6R2axfJNFB6tGaccWClT1bNzEuLpz+lJOY=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1692972199;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=oO47LbY0b5fVyG7D8YYQFkwRO57XM5uT3mfj/DxMSkA=;
 b=j1kjownAAX9hJfB2BxApQkooYMrevfaPLxvPystRVIJaNfbMrYunmfkjCazr0ChWhlvVjY
 lRX7+a9ciN0hwgjNK4X5Fb69aObVTB6DVFK6AZND7C0g5qPAW+vA7D+a0HhCiOEWDX9QRj
 DdPtV8aYlp/xMHVmKP0gIoyMuJWp9/M=
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

Choose different gfp flags to support nowait memory allocation in
_xfs_buf_alloc().

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/xfs/xfs_buf.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 9f84bc3b802c..8b800ce28996 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -220,9 +220,14 @@ _xfs_buf_alloc(
 	struct xfs_buf		*bp;
 	int			error;
 	int			i;
+	bool			nowait = flags & XBF_NOWAIT;
+	gfp_t			gfp_flags = GFP_NOFS |
+					    (nowait ? 0 : __GFP_NOFAIL);
 
 	*bpp = NULL;
-	bp = kmem_cache_zalloc(xfs_buf_cache, GFP_NOFS | __GFP_NOFAIL);
+	bp = kmem_cache_zalloc(xfs_buf_cache, gfp_flags);
+	if (!bp)
+		return -EAGAIN;
 
 	/*
 	 * We don't want certain flags to appear in b_flags unless they are
-- 
2.25.1
