From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v4 53/73] fs: Convert writeback to XArray
Date: Tue,  5 Dec 2017 16:41:39 -0800
Message-ID: <20171206004159.3755-54-willy@infradead.org>
References: <20171206004159.3755-1-willy@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=yGYlWE0Q3UN71gCcCJY3/Up1efVO+4gWurwmrT/wgzw=; b=trByV+z324VMrM6sD2FfsYaJB
        mOwcSWt7d1cRxNI6tyMKr8KsBmacwymddhNnEo/pPh+YV8aNnL8CUxv9dKP2wDWaKtwVvDMrzIfZA
        98ei0XlqVu3DJKkwuV8K8CXwwEa57GcgOG44LVo+wMjBMkeWpqDnhA8qiCpVcA7SCTzcP+CCDdimN
        Nm7qc62ckvACht0YPI6yJlcLt4SDFpw++Yf/KMhpNvOhbzCysdDsPU1C8WMaKMUQ/bHpgxhMO+39O
        F8RSmyqFGA9HpyVA1pv/BaynVpC2MsKvJwnDCMdw//PdZfyjT8wLGEn7ijdMJ+7VkyhyCE56B42vB
    
In-Reply-To: <20171206004159.3755-1-willy@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

A couple of short loops.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/fs-writeback.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index a3c2352507f6..18ad86ccba96 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -339,9 +339,9 @@ static void inode_switch_wbs_work_fn(struct work_struct *work)
 	struct address_space *mapping = inode->i_mapping;
 	struct bdi_writeback *old_wb = inode->i_wb;
 	struct bdi_writeback *new_wb = isw->new_wb;
-	struct radix_tree_iter iter;
+	XA_STATE(xas, &mapping->pages, 0);
+	struct page *page;
 	bool switched = false;
-	void **slot;
 
 	/*
 	 * By the time control reaches here, RCU grace period has passed
@@ -373,27 +373,20 @@ static void inode_switch_wbs_work_fn(struct work_struct *work)
 	/*
 	 * Count and transfer stats.  Note that PAGECACHE_TAG_DIRTY points
 	 * to possibly dirty pages while PAGECACHE_TAG_WRITEBACK points to
-	 * pages actually under underwriteback.
+	 * pages actually under writeback.
 	 */
-	radix_tree_for_each_tagged(slot, &mapping->pages, &iter, 0,
-				   PAGECACHE_TAG_DIRTY) {
-		struct page *page = radix_tree_deref_slot_protected(slot,
-						&mapping->pages.xa_lock);
-		if (likely(page) && PageDirty(page)) {
+	xas_for_each_tag(&xas, page, ULONG_MAX, PAGECACHE_TAG_DIRTY) {
+		if (PageDirty(page)) {
 			dec_wb_stat(old_wb, WB_RECLAIMABLE);
 			inc_wb_stat(new_wb, WB_RECLAIMABLE);
 		}
 	}
 
-	radix_tree_for_each_tagged(slot, &mapping->pages, &iter, 0,
-				   PAGECACHE_TAG_WRITEBACK) {
-		struct page *page = radix_tree_deref_slot_protected(slot,
-						&mapping->pages.xa_lock);
-		if (likely(page)) {
-			WARN_ON_ONCE(!PageWriteback(page));
-			dec_wb_stat(old_wb, WB_WRITEBACK);
-			inc_wb_stat(new_wb, WB_WRITEBACK);
-		}
+	xas_set(&xas, 0);
+	xas_for_each_tag(&xas, page, ULONG_MAX, PAGECACHE_TAG_WRITEBACK) {
+		WARN_ON_ONCE(!PageWriteback(page));
+		dec_wb_stat(old_wb, WB_WRITEBACK);
+		inc_wb_stat(new_wb, WB_WRITEBACK);
 	}
 
 	wb_get(new_wb);
-- 
2.15.0

