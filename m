From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v5 68/78] mm: Convert cgroup writeback to XArray
Date: Fri, 15 Dec 2017 14:04:40 -0800
Message-ID: <20171215220450.7899-69-willy@infradead.org>
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
 bh=ed2cjUY/lFHEB5PamLl8vHkKy/Jm1RU/y5RJ1SGTVkc=; b=P5tfaAPwsBdcotvPXHhM8x4ecR
 g4K3rDRgvGC2S2OsnwDNt/FbTKIS6NmCU7ppuVFQGE7U8Q2Fa1k+n4oTrSt2G4E41s9qOXU6hp7Uk
 7r+xiPggspFxD8ns/aBqVgvDKa77jQngDnR9IrLXCjLTPu9vXrpH1Aki4rvnA+gze4rw=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=ed2cjUY/lFHEB5PamLl8vHkKy/Jm1RU/y5RJ1SGTVkc=; b=P4aolv2zOUmY6opl6gRetfF8Pq
 zr8VDlFo6U9QwJRrjerUfZ58dKiXhZ1DHpsSb/fp8HIFWOvzVGfNu/Omr7tZYTl5TQ2UXtT4CK6Bh
 ErD1GXPUrx9gg+axa0AK1IKKrwpIlKHNh3TWPVaa4RyjaHhpSIyqZEwjAOI6sm9B4O1s=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=ed2cjUY/lFHEB5PamLl8vHkKy/Jm1RU/y5RJ1SGTVkc=; b=OtH5Y5ZPCgTEf443Pa23Keixg
 i5+ICH/XAWX6BNQQ0rpiixCDCIH46sBbv17ggXZSzf8F9vETzL2zdn/S2xoDYAzHr6rMVJs+LjH2i
 i9z3TnLzODfnVlVfu/1SlL73GCP34F1TDtw2vc/KjfMxmvnZWM1ZYYPvOJFrcxv6F+JkmwfjmNSFX
 mXVT7AnTwi/EQxj/qwByNuMmqlT3SHZ0tdtwP4N+sYmlUM3pyT9SVYezED2m0Y96jSnd+02kInbum
 7FTHPVCVjIfYajUKs5dqvCKjbydJoitEhEpq7RMrkG0aMGWYth0KPwDl0OF4fSnef8xQ5U4tXHG2p
 0AzYD2ULQ==;
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

This is a fairly naive conversion, leaving in place the GFP_ATOMIC
allocation.  By switching the locking around, we could use GFP_KERNEL
and probably simplify the error handling.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 include/linux/backing-dev-defs.h |  2 +-
 include/linux/backing-dev.h      |  2 +-
 mm/backing-dev.c                 | 23 +++++++++++------------
 3 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
index bfe86b54f6c1..074a54aad33c 100644
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -187,7 +187,7 @@ struct backing_dev_info {
 	struct bdi_writeback wb;  /* the root writeback info for this bdi */
 	struct list_head wb_list; /* list of all wbs */
 #ifdef CONFIG_CGROUP_WRITEBACK
-	struct radix_tree_root cgwb_tree; /* radix tree of active cgroup wbs */
+	struct xarray cgwb_xa;		/* radix tree of active cgroup wbs */
 	struct rb_root cgwb_congested_tree; /* their congested states */
 #else
 	struct bdi_writeback_congested *wb_congested;
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 2af5b8a62d1e..715e7582fa03 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -271,7 +271,7 @@ static inline struct bdi_writeback *wb_find_current(struct backing_dev_info *bdi
 	if (!memcg_css->parent)
 		return &bdi->wb;
 
-	wb = radix_tree_lookup(&bdi->cgwb_tree, memcg_css->id);
+	wb = xa_load(&bdi->cgwb_xa, memcg_css->id);
 
 	/*
 	 * %current's blkcg equals the effective blkcg of its memcg.  No
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 84b2dc76f140..04efdf2b401a 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -417,8 +417,8 @@ static void wb_exit(struct bdi_writeback *wb)
 #include <linux/memcontrol.h>
 
 /*
- * cgwb_lock protects bdi->cgwb_tree, bdi->cgwb_congested_tree,
- * blkcg->cgwb_list, and memcg->cgwb_list.  bdi->cgwb_tree is also RCU
+ * cgwb_lock protects bdi->cgwb_xa, bdi->cgwb_congested_tree,
+ * blkcg->cgwb_list, and memcg->cgwb_list.  bdi->cgwb_xa is also RCU
  * protected.
  */
 static DEFINE_SPINLOCK(cgwb_lock);
@@ -539,7 +539,7 @@ static void cgwb_kill(struct bdi_writeback *wb)
 {
 	lockdep_assert_held(&cgwb_lock);
 
-	WARN_ON(!radix_tree_delete(&wb->bdi->cgwb_tree, wb->memcg_css->id));
+	WARN_ON(xa_erase(&wb->bdi->cgwb_xa, wb->memcg_css->id) != wb);
 	list_del(&wb->memcg_node);
 	list_del(&wb->blkcg_node);
 	percpu_ref_kill(&wb->refcnt);
@@ -571,7 +571,7 @@ static int cgwb_create(struct backing_dev_info *bdi,
 
 	/* look up again under lock and discard on blkcg mismatch */
 	spin_lock_irqsave(&cgwb_lock, flags);
-	wb = radix_tree_lookup(&bdi->cgwb_tree, memcg_css->id);
+	wb = xa_load(&bdi->cgwb_xa, memcg_css->id);
 	if (wb && wb->blkcg_css != blkcg_css) {
 		cgwb_kill(wb);
 		wb = NULL;
@@ -614,8 +614,8 @@ static int cgwb_create(struct backing_dev_info *bdi,
 	spin_lock_irqsave(&cgwb_lock, flags);
 	if (test_bit(WB_registered, &bdi->wb.state) &&
 	    blkcg_cgwb_list->next && memcg_cgwb_list->next) {
-		/* we might have raced another instance of this function */
-		ret = radix_tree_insert(&bdi->cgwb_tree, memcg_css->id, wb);
+		ret = xa_store_empty(&bdi->cgwb_xa, memcg_css->id, wb,
+					GFP_ATOMIC);
 		if (!ret) {
 			list_add_tail_rcu(&wb->bdi_node, &bdi->wb_list);
 			list_add(&wb->memcg_node, memcg_cgwb_list);
@@ -682,7 +682,7 @@ struct bdi_writeback *wb_get_create(struct backing_dev_info *bdi,
 
 	do {
 		rcu_read_lock();
-		wb = radix_tree_lookup(&bdi->cgwb_tree, memcg_css->id);
+		wb = xa_load(&bdi->cgwb_xa, memcg_css->id);
 		if (wb) {
 			struct cgroup_subsys_state *blkcg_css;
 
@@ -704,7 +704,7 @@ static int cgwb_bdi_init(struct backing_dev_info *bdi)
 {
 	int ret;
 
-	INIT_RADIX_TREE(&bdi->cgwb_tree, GFP_ATOMIC);
+	xa_init(&bdi->cgwb_xa);
 	bdi->cgwb_congested_tree = RB_ROOT;
 
 	ret = wb_init(&bdi->wb, bdi, 1, GFP_KERNEL);
@@ -717,15 +717,14 @@ static int cgwb_bdi_init(struct backing_dev_info *bdi)
 
 static void cgwb_bdi_unregister(struct backing_dev_info *bdi)
 {
-	struct radix_tree_iter iter;
-	void **slot;
+	XA_STATE(xas, &bdi->cgwb_xa, 0);
 	struct bdi_writeback *wb;
 
 	WARN_ON(test_bit(WB_registered, &bdi->wb.state));
 
 	spin_lock_irq(&cgwb_lock);
-	radix_tree_for_each_slot(slot, &bdi->cgwb_tree, &iter, 0)
-		cgwb_kill(*slot);
+	xas_for_each(&xas, wb, ULONG_MAX)
+		cgwb_kill(wb);
 
 	while (!list_empty(&bdi->wb_list)) {
 		wb = list_first_entry(&bdi->wb_list, struct bdi_writeback,
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
