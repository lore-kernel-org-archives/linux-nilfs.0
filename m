From: Hao Xu <hao.xu@linux.dev>
Subject: [PATCH 27/29] xfs: add a comment for xlog_kvmalloc()
Date: Fri, 25 Aug 2023 21:54:29 +0800
Message-ID: <20230825135431.1317785-28-hao.xu@linux.dev>
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
 bh=4gmh1Yl1nIIBwKe+EGho8dT2/H6COtTrErlOIONZgFQ=; b=JeYw/ghbEqyvp53dkampEvp4dA
 PwHBSnZobkyUOEkTW9nS+/nJhj/Hx4YxrSurAxsJWlJ0z3NI54rI5pZPnIgNU7Z/5oVDvNafHFR2w
 GrSYhcdgs1EEy/S5miY5HzbKQx5jelD+1iHyhkPBPWRk03OtVWCsEuQ9yoqqaj82xWus=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=4gmh1Yl1nIIBwKe+EGho8dT2/H6COtTrErlOIONZgFQ=; b=Fvvotj8E+62pXIFTHEzNcdfKNc
 hZcwCOSWqQfpEKpOw7izUzuyVtXX/ra6rfmkrpsbiwjb3MbZxRo4JYj+9XHhcfBt/4++RdmCtD7Nn
 CDDJKOHEcYnfSFBl3N8kChXfA27WNzJl3KcPPHEHDyzs6cvE54Q0otW1kPifYPaJCVL4=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1692972353;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=4gmh1Yl1nIIBwKe+EGho8dT2/H6COtTrErlOIONZgFQ=;
 b=gfnw7iot2v83zX2rBTLz1spXwFLJTgZUr3L11o+Xtkb6kMiY2V8isvCmRHCyeGMc3m+Cgc
 4QGEiH3BvMZ39xF7zrn0F0ImfXnteloPQ0HANELCYOPXSgll6hNjSPIHSsKK/xLoS1sTMP
 6uHJDx4f8EyPCrO0C+jtU3MY4km0+Ig=
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

vmalloc() always succeed in 64 bit system?
Not a real patch.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/xfs/xfs_log_cil.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index f17c1799b3c4..b31830ee36dd 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -335,6 +335,9 @@ xlog_cil_alloc_shadow_bufs(
 			 * storage.
 			 */
 			kmem_free(lip->li_lv_shadow);
+			/*
+			 * May this be indefinite loop in nowait case?
+			 */
 			lv = xlog_kvmalloc(buf_size);
 
 			memset(lv, 0, xlog_cil_iovec_space(niovecs));
-- 
2.25.1
