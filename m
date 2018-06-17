From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v14 51/74] shmem: Convert shmem_alloc_hugepage to
 XArray
Date: Sat, 16 Jun 2018 19:00:29 -0700
Message-ID: <20180617020052.4759-52-willy@infradead.org>
References: <20180617020052.4759-1-willy@infradead.org>
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
 bh=NN4Zkd8fg6q/Ddft8oEngd+e5mAY6McH/K0Jtt+4emE=; b=bbb6JLF/oPTMW9zPsckiTAWnVo
 XxBBIUGL9ABMulNdtFpliQtizYTnLfVad9ec2mrzXOpEYknweBZrLF/eO9SqSs4JgnpCadopHCUlf
 KtCR67JZDafl511jMWy3pf29exinCp1llYjdW8opjDdF4s9P2G3+g+Ko/fEDhslikSpM=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=NN4Zkd8fg6q/Ddft8oEngd+e5mAY6McH/K0Jtt+4emE=; b=WAAKOUjA98z71e7VslFWupKdBw
 h2a4/p7Alvet5NOqiQFF1/+zhEX6lFOC9mqKxpiZFGqRkg5szOcHNRSlbhmi+etu1dWUUD1gR7MCi
 xqsvTjAU8CuL24P/PH45nXPyC1QJR7y6PI9TiadY/+R/EXRy8NfFtQZ29LivVBn8otOs=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=NN4Zkd8fg6q/Ddft8oEngd+e5mAY6McH/K0Jtt+4emE=; b=gVXIz/NQ7xNYWFBur05MdsBfR
 AubC2EcotKvxAlPvdpiXLMRQ67OK1ovHDzNAKXaDOroV3j4IlZT91Nw1vG2xEFnaOsgrZ5PixQ/QC
 E1k1l5sOvjIvpLY00tfqOtCD7ePgYuLUgFrnexJQj1puXHtCvU5i5Yz2e06/7Rcp7g6YSA67/7KNt
 X+DeRowbuBoUfo3lJ719BQ+Kd96Mw+ef661jvJzPXylKbecGEiP+ESogI9lHg+6Z4od4WPxmqEXS4
 H7FAPQg9hiDpgYB9f2B5HU3r+i74GOiuRDsryxnlLps7L8zKwQ46LNx6f2Kz5PwcrtWxZBMXULlmu
 iw7kdI8Dw==;
In-Reply-To: <20180617020052.4759-1-willy@infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Matthew Wilcox <willy@infradead.org>, linux-f2fs-devel@lists.sourceforge.net, Nicholas Piggin <npiggin@gmail.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>

xa_find() is a slightly easier API to use than
radix_tree_gang_lookup_slot() because it contains its own RCU locking.
This commit removes the last user of radix_tree_gang_lookup_slot()
so remove the function too.

Signed-off-by: Matthew Wilcox <willy@infradead.org>
---
 include/linux/radix-tree.h |  6 +-----
 lib/radix-tree.c           | 44 +-------------------------------------
 mm/shmem.c                 | 14 ++++--------
 3 files changed, 6 insertions(+), 58 deletions(-)

diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
index eefa0b099dd5..081e68b4376b 100644
--- a/include/linux/radix-tree.h
+++ b/include/linux/radix-tree.h
@@ -147,12 +147,11 @@ static inline unsigned int iter_shift(const struct radix_tree_iter *iter)
  * radix_tree_lookup_slot
  * radix_tree_tag_get
  * radix_tree_gang_lookup
- * radix_tree_gang_lookup_slot
  * radix_tree_gang_lookup_tag
  * radix_tree_gang_lookup_tag_slot
  * radix_tree_tagged
  *
- * The first 8 functions are able to be called locklessly, using RCU. The
+ * The first 7 functions are able to be called locklessly, using RCU. The
  * caller must ensure calls to these functions are made within rcu_read_lock()
  * regions. Other readers (lock-free or otherwise) and modifications may be
  * running concurrently.
@@ -263,9 +262,6 @@ void radix_tree_clear_tags(struct radix_tree_root *, struct radix_tree_node *,
 unsigned int radix_tree_gang_lookup(const struct radix_tree_root *,
 			void **results, unsigned long first_index,
 			unsigned int max_items);
-unsigned int radix_tree_gang_lookup_slot(const struct radix_tree_root *,
-			void __rcu ***results, unsigned long *indices,
-			unsigned long first_index, unsigned int max_items);
 int radix_tree_preload(gfp_t gfp_mask);
 int radix_tree_maybe_preload(gfp_t gfp_mask);
 int radix_tree_maybe_preload_order(gfp_t gfp_mask, int order);
diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index 5c8a262f506c..d0f44ea96945 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -1138,7 +1138,7 @@ void __radix_tree_replace(struct radix_tree_root *root,
  * @slot:	pointer to slot
  * @item:	new item to store in the slot.
  *
- * For use with radix_tree_lookup_slot(), radix_tree_gang_lookup_slot(),
+ * For use with radix_tree_lookup_slot() and
  * radix_tree_gang_lookup_tag_slot().  Caller must hold tree write locked
  * across slot lookup and replacement.
  *
@@ -1772,48 +1772,6 @@ radix_tree_gang_lookup(const struct radix_tree_root *root, void **results,
 }
 EXPORT_SYMBOL(radix_tree_gang_lookup);
 
-/**
- *	radix_tree_gang_lookup_slot - perform multiple slot lookup on radix tree
- *	@root:		radix tree root
- *	@results:	where the results of the lookup are placed
- *	@indices:	where their indices should be placed (but usually NULL)
- *	@first_index:	start the lookup from this key
- *	@max_items:	place up to this many items at *results
- *
- *	Performs an index-ascending scan of the tree for present items.  Places
- *	their slots at *@results and returns the number of items which were
- *	placed at *@results.
- *
- *	The implementation is naive.
- *
- *	Like radix_tree_gang_lookup as far as RCU and locking goes. Slots must
- *	be dereferenced with radix_tree_deref_slot, and if using only RCU
- *	protection, radix_tree_deref_slot may fail requiring a retry.
- */
-unsigned int
-radix_tree_gang_lookup_slot(const struct radix_tree_root *root,
-			void __rcu ***results, unsigned long *indices,
-			unsigned long first_index, unsigned int max_items)
-{
-	struct radix_tree_iter iter;
-	void __rcu **slot;
-	unsigned int ret = 0;
-
-	if (unlikely(!max_items))
-		return 0;
-
-	radix_tree_for_each_slot(slot, root, &iter, first_index) {
-		results[ret] = slot;
-		if (indices)
-			indices[ret] = iter.index;
-		if (++ret == max_items)
-			break;
-	}
-
-	return ret;
-}
-EXPORT_SYMBOL(radix_tree_gang_lookup_slot);
-
 /**
  *	radix_tree_gang_lookup_tag - perform multiple lookup on a radix tree
  *	                             based on a tag
diff --git a/mm/shmem.c b/mm/shmem.c
index 8e702b6d84a5..09452ca79220 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1434,23 +1434,17 @@ static struct page *shmem_alloc_hugepage(gfp_t gfp,
 		struct shmem_inode_info *info, pgoff_t index)
 {
 	struct vm_area_struct pvma;
-	struct inode *inode = &info->vfs_inode;
-	struct address_space *mapping = inode->i_mapping;
-	pgoff_t idx, hindex;
-	void __rcu **results;
+	struct address_space *mapping = info->vfs_inode.i_mapping;
+	pgoff_t hindex;
 	struct page *page;
 
 	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGE_PAGECACHE))
 		return NULL;
 
 	hindex = round_down(index, HPAGE_PMD_NR);
-	rcu_read_lock();
-	if (radix_tree_gang_lookup_slot(&mapping->i_pages, &results, &idx,
-				hindex, 1) && idx < hindex + HPAGE_PMD_NR) {
-		rcu_read_unlock();
+	if (xa_find(&mapping->i_pages, &hindex, hindex + HPAGE_PMD_NR - 1,
+								XA_PRESENT))
 		return NULL;
-	}
-	rcu_read_unlock();
 
 	shmem_pseudo_vma_init(&pvma, info, hindex);
 	page = alloc_pages_vma(gfp | __GFP_COMP | __GFP_NORETRY | __GFP_NOWARN,
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
