From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v5 44/78] shmem: Convert find_swap_entry to XArray
Date: Fri, 15 Dec 2017 14:04:16 -0800
Message-ID: <20171215220450.7899-45-willy@infradead.org>
References: <20171215220450.7899-1-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:
 To:From:Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=7lV9Dy41SGDjqxvduF6TDvhRDCy5QMhhHNIDqSIntNg=; b=mqT7bJxCMUn48vmvMKFvhSESch
 97xrKmh/TdtuZL9Z3wainqSGxVs5vXBu/efcovqqQbQcWYjDe6p3SsJU+736O4oBeYvvQxC7TMSye
 gLcUYgQ86s/LfpyJm3nILZ+Y0f+R8Ra1ZWyLKBBl9AMCc2pSfK2iuSDNjy936LEOFC88=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=7lV9Dy41SGDjqxvduF6TDvhRDCy5QMhhHNIDqSIntNg=; b=DbSozRNjON2U7sepQPUsnPkwRt
 gVqAunG3RGHUSLqqdSr3N1SRGAc12q4DaZoSQr9YaNiRhGuIf+ohmG2K79OOfbHGsG58lGWNngmLP
 bu+4cmfpYuY8sxFJqeAG7HhoCL5G5kN7mv2gl6G65u/4y2pGgXRhMUDZx2r9JiLTf/oA=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=7lV9Dy41SGDjqxvduF6TDvhRDCy5QMhhHNIDqSIntNg=; b=s0gVDeLMgcoERl7SwxMA5pORT
 ApCaBcFiz0VDN7A4Obf32BT0yx9eUymVrRoDR/s0ejijxsfZnxCd+2zs+yUfEAQN09CXE3RzHzrSz
 9u4g39g0xBd5+IGKDWPSVpeXeyCuWd81yKiqlLoITryRySfzSTRSeZZyGtfHIPDMSjELuFv2Y0pzi
 mbUO8lEOKuhslay3Awkq7LA/IW4LyD2Io5kS9ivyH3clM7ZqaM48FWYybZAhcQCS2XEWD7PjsZyzD
 A20YVm/uU5CG6LaM5x5oPlcKoe5Yj7uUpYxHSqeWaOQsYdCy2UN6m9GVi+RwYkvSWiaEpMHp4Eyua
 Hx3ZXaOFQ==;
In-Reply-To: <20171215220450.7899-1-willy@infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, linux-xfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-raid@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-usb@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, David Howells <dhowells@redhat.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Rehas Sachdeva <aquannie@gmail.com>, Shaohua Li <shli@kernel.org>, linux-btrfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

This is a 1:1 conversion.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/shmem.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 654f367aca90..ce285ae635ea 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1076,28 +1076,27 @@ static void shmem_evict_inode(struct inode *inode)
 	clear_inode(inode);
 }
 
-static unsigned long find_swap_entry(struct radix_tree_root *root, void *item)
+static unsigned long find_swap_entry(struct xarray *xa, void *item)
 {
-	struct radix_tree_iter iter;
-	void **slot;
-	unsigned long found = -1;
+	XA_STATE(xas, xa, 0);
 	unsigned int checked = 0;
+	void *entry;
 
 	rcu_read_lock();
-	radix_tree_for_each_slot(slot, root, &iter, 0) {
-		if (*slot == item) {
-			found = iter.index;
+	xas_for_each(&xas, entry, ULONG_MAX) {
+		if (xas_retry(&xas, entry))
+			continue;
+		if (entry == item)
 			break;
-		}
 		checked++;
-		if ((checked % 4096) != 0)
+		if ((checked % XA_CHECK_SCHED) != 0)
 			continue;
-		slot = radix_tree_iter_resume(slot, &iter);
+		xas_pause(&xas);
 		cond_resched_rcu();
 	}
-
 	rcu_read_unlock();
-	return found;
+
+	return xas_invalid(&xas) ? -1 : xas.xa_index;
 }
 
 /*
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
