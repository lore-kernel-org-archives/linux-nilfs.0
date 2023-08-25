From: Hao Xu <hao.xu@linux.dev>
Subject: [PATCH 22/29] xfs: comment page allocation for nowait
 case in xfs_buf_find_insert()
Date: Fri, 25 Aug 2023 21:54:24 +0800
Message-ID: <20230825135431.1317785-23-hao.xu@linux.dev>
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
 bh=ZAHRQkTlH3B9Ayy3ByDVW6IFO8x4JKviNIiMKvNnRxw=; b=Hy4xaP4RBgwXCe1LEvolm6vBRP
 8AFoKpXRmgkT2sCxZFE3JjItoTuKIzHzEimc6rKRXACZuddiHDg1MKraP8JRW6q93RclbZ5RbSaqG
 Pt3qsaSxdvRsKuZuQVpnjRO38lsRQLTgv0ZrIF9D5a1SdOEFsvt26dCsrIgLHMux6PEs=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=ZAHRQkTlH3B9Ayy3ByDVW6IFO8x4JKviNIiMKvNnRxw=; b=W3XZ4wZ0DAhS8LIA4MaSI//V85
 DzRZR6tozUhDOzLFKshR5SoqsHmqgasy77sLJ3RD7WxX1UqHNfFVcVcuvrpHOkQHvsQ7+aGugYTDH
 ZpMt8b13WMMKWJ9wtevcJUZ1IFi4r4lbq4E5dXLMohEizQRortPe79baqYCCHnwjIxHs=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1692972248;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=ZAHRQkTlH3B9Ayy3ByDVW6IFO8x4JKviNIiMKvNnRxw=;
 b=rqq9t63T1b93nHdvHPb4iPnifbVgNhCPhaGA0/+lVUtdq72oLevGN3oePkSOWgj4tFeMJO
 883BuPqR+igY5LuYYZDHjdap5mSmKgc54EL0giqHkQRTPmks0t1/1oKfHQU1t1pMyd2ThX
 7baCMPgFPzeqpA42kG/A+w1RFMlPw/c=
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

Add comments for page allocation in nowait case in xfs_buf_find_insert()

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/xfs/xfs_buf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index eb3cd7702545..57bdc4c5dde1 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -633,6 +633,8 @@ xfs_buf_find_insert(
 	 * allocate the memory from the heap to minimise memory usage. If we
 	 * can't get heap memory for these small buffers, we fall back to using
 	 * the page allocator.
+	 * xfs_buf_alloc_kmem may return -EAGAIN, let's not return it but turn
+	 * to page allocator as well.
 	 */
 	if (BBTOB(new_bp->b_length) >= PAGE_SIZE ||
 	    xfs_buf_alloc_kmem(new_bp, flags) < 0) {
-- 
2.25.1
