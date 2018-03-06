From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v8 59/63] f2fs: Convert to XArray
Date: Tue,  6 Mar 2018 11:24:09 -0800
Message-ID: <20180306192413.5499-60-willy@infradead.org>
References: <20180306192413.5499-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=GhZlfTPHHJiPpfSnxpFD0vgaxGZiPr7sjSAMJyjTtro=; b=dfpFLODkqOJI5k7TtphDCR4IH
        xj7NuM2Io0BvAGs/UUW+AIjZ+jrm3xE6I1AEFegOvlH88IeKb04hzkve92AFLrYUlOU4XycjwsLcH
        v4ko25tgZYEcmPQZ+lhJ2U+RThpyNvwtu/EqGJ41d0+heuoonB8WWS+I6h/+6rmC9ImElV3D2AdqB
        ydtGEx/EoOmRRfdnh8M8Fk3HPiFEaYkoL6o+fwK/qLB8ExJo+/6MfyN5K0cJqo7qa7E4W9btSC/NM
        HBwGhWxjfD19NPgdYBfIxMRGbUt0vcVf2wuegJ0dmRvZRYJHZjkT0m9griBxzsxm+PN3aFIIsRJut
    
In-Reply-To: <20180306192413.5499-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

This is a straightforward conversion.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/f2fs/data.c   |  3 +--
 fs/f2fs/dir.c    |  5 +----
 fs/f2fs/inline.c |  6 +-----
 fs/f2fs/node.c   | 10 ++--------
 4 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index dfbccf884d4f..8deac207fbc3 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2384,8 +2384,7 @@ void f2fs_set_page_dirty_nobuffers(struct page *page)
 	xa_lock_irqsave(&mapping->i_pages, flags);
 	WARN_ON_ONCE(!PageUptodate(page));
 	account_page_dirtied(page, mapping);
-	radix_tree_tag_set(&mapping->i_pages,
-			page_index(page), PAGECACHE_TAG_DIRTY);
+	__xa_set_tag(&mapping->i_pages, page_index(page), PAGECACHE_TAG_DIRTY);
 	xa_unlock_irqrestore(&mapping->i_pages, flags);
 	unlock_page_memcg(page);
 
diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index a0aa4dd5a7d4..bf7f33f97fdf 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -708,7 +708,6 @@ void f2fs_delete_entry(struct f2fs_dir_entry *dentry, struct page *page,
 	unsigned int bit_pos;
 	int slots = GET_DENTRY_SLOTS(le16_to_cpu(dentry->name_len));
 	struct address_space *mapping = page_mapping(page);
-	unsigned long flags;
 	int i;
 
 	f2fs_update_time(F2FS_I_SB(dir), REQ_TIME);
@@ -741,10 +740,8 @@ void f2fs_delete_entry(struct f2fs_dir_entry *dentry, struct page *page,
 
 	if (bit_pos == NR_DENTRY_IN_BLOCK &&
 			!truncate_hole(dir, page->index, page->index + 1)) {
-		xa_lock_irqsave(&mapping->i_pages, flags);
-		radix_tree_tag_clear(&mapping->i_pages, page_index(page),
+		xa_clear_tag(&mapping->i_pages, page_index(page),
 				     PAGECACHE_TAG_DIRTY);
-		xa_unlock_irqrestore(&mapping->i_pages, flags);
 
 		clear_page_dirty_for_io(page);
 		ClearPagePrivate(page);
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index eb82891e4ab6..de06efb53cef 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -204,7 +204,6 @@ int f2fs_write_inline_data(struct inode *inode, struct page *page)
 	void *src_addr, *dst_addr;
 	struct dnode_of_data dn;
 	struct address_space *mapping = page_mapping(page);
-	unsigned long flags;
 	int err;
 
 	set_new_dnode(&dn, inode, NULL, NULL, 0);
@@ -226,10 +225,7 @@ int f2fs_write_inline_data(struct inode *inode, struct page *page)
 	kunmap_atomic(src_addr);
 	set_page_dirty(dn.inode_page);
 
-	xa_lock_irqsave(&mapping->i_pages, flags);
-	radix_tree_tag_clear(&mapping->i_pages, page_index(page),
-			     PAGECACHE_TAG_DIRTY);
-	xa_unlock_irqrestore(&mapping->i_pages, flags);
+	xa_clear_tag(&mapping->i_pages, page_index(page), PAGECACHE_TAG_DIRTY);
 
 	set_inode_flag(inode, FI_APPEND_WRITE);
 	set_inode_flag(inode, FI_DATA_EXIST);
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index ce912c33b11e..57b444ba988b 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -88,14 +88,10 @@ bool available_free_memory(struct f2fs_sb_info *sbi, int type)
 static void clear_node_page_dirty(struct page *page)
 {
 	struct address_space *mapping = page->mapping;
-	unsigned int long flags;
 
 	if (PageDirty(page)) {
-		xa_lock_irqsave(&mapping->i_pages, flags);
-		radix_tree_tag_clear(&mapping->i_pages,
-				page_index(page),
+		xa_clear_tag(&mapping->i_pages, page_index(page),
 				PAGECACHE_TAG_DIRTY);
-		xa_unlock_irqrestore(&mapping->i_pages, flags);
 
 		clear_page_dirty_for_io(page);
 		dec_page_count(F2FS_M_SB(mapping), F2FS_DIRTY_NODES);
@@ -1139,9 +1135,7 @@ void ra_node_page(struct f2fs_sb_info *sbi, nid_t nid)
 		return;
 	f2fs_bug_on(sbi, check_nid_range(sbi, nid));
 
-	rcu_read_lock();
-	apage = radix_tree_lookup(&NODE_MAPPING(sbi)->i_pages, nid);
-	rcu_read_unlock();
+	apage = xa_load(&NODE_MAPPING(sbi)->i_pages, nid);
 	if (apage)
 		return;
 
-- 
2.16.1

