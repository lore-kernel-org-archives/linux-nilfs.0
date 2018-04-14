From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v11 49/63] f2fs: Convert to XArray
Date: Sat, 14 Apr 2018 07:13:02 -0700
Message-ID: <20180414141316.7167-50-willy@infradead.org>
References: <20180414141316.7167-1-willy@infradead.org>
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
 bh=uC5r9VNmylEYCyceeTLYI/qscgL3thDU1SJQtGAYfzk=; b=m8Ek3Iiyf6WDXwsh/7/SUH0ROg
 eUncZbFHWU4ZeBtQukgErV9eoVinE1YI6VW5ec/39HWL86Jwmxt1z8qqPRuyrUzuBATJ3lH4kP42y
 QcL1COcWPEap0J8n1An5DOPJlhku/61PgN2NzUXO3EI17L4MUwTasdRVRHEfcBKx7A8I=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=uC5r9VNmylEYCyceeTLYI/qscgL3thDU1SJQtGAYfzk=; b=DUcnCVMljs6R7wo0boyoQKoMr5
 kUFgVqZpdqfcW6vFFphWSgU1fKuX6tnl6sxrovic4f5wZZ8wS0msFbgqWLOGPHr8lL6W4L+3vipGs
 9903+6LfSpEzF99QIaBob0kf1FdMEhYsKSjK4xQTx9M6Os7sr3fiy5Y7KfxGIYhMnZ5w=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=uC5r9VNmylEYCyceeTLYI/qscgL3thDU1SJQtGAYfzk=; b=ClIbRyP7RtkaYL/h9bijOjALi
 CHzfS6NT1hYKqedi7bS+luuuf0FSiAgWwGtXfoXxwIhfIZ0NK5RKCBY/iXmtFmm3YhKXF7tUgsMAN
 Ets06pVO2f/OwsiAvNVASnpyRQAQFGy3TE3yk7rJSi5TQIPIaDtDigW3Ih7H1gFvykY3a1XTl0fJ2
 S6lDm9P+rDipMzX2KaVTqKPjL+vIlGKfCVWpZwyWYGYHS4tEq+AZ46BUHVl1fiGuEkZlVDIm6Vtrd
 ac56nIOQD4uTDvsBb0oa/2FNtN9MAO7HKohPm7wdZgm/C63hcre4oBDAoDab0bWDYrYM88d28T8v5
 FlGFA6zEQ==;
In-Reply-To: <20180414141316.7167-1-willy@infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, James Simmons <jsimmons@infradead.org>, Jaegeuk Kim <jaegeuk@kernel.org>, Andreas Dilger <andreas.dilger@intel.com>, Nicholas Piggin <npiggin@gmail.com>, linux-f2fs-devel@lists.sourceforge.net, Oleg Drokin <oleg.drokin@intel.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Mike Kravetz <mike.kravetz@oracle.com>

From: Matthew Wilcox <mawilcox@microsoft.com>

This is a straightforward conversion.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/f2fs/data.c   | 3 +--
 fs/f2fs/dir.c    | 2 +-
 fs/f2fs/inline.c | 4 ++--
 fs/f2fs/node.c   | 9 +++------
 4 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index d836bfc160f1..676d6a34a7d5 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2427,8 +2427,7 @@ void f2fs_set_page_dirty_nobuffers(struct page *page)
 	xa_lock_irqsave(&mapping->i_pages, flags);
 	WARN_ON_ONCE(!PageUptodate(page));
 	account_page_dirtied(page, mapping);
-	radix_tree_tag_set(&mapping->i_pages,
-			page_index(page), PAGECACHE_TAG_DIRTY);
+	__xa_set_tag(&mapping->i_pages, page_index(page), PAGECACHE_TAG_DIRTY);
 	xa_unlock_irqrestore(&mapping->i_pages, flags);
 	unlock_page_memcg(page);
 
diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 8c9c2f31b253..73d1f7b879cf 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -733,7 +733,7 @@ void f2fs_delete_entry(struct f2fs_dir_entry *dentry, struct page *page,
 	if (bit_pos == NR_DENTRY_IN_BLOCK &&
 			!truncate_hole(dir, page->index, page->index + 1)) {
 		xa_lock_irqsave(&mapping->i_pages, flags);
-		radix_tree_tag_clear(&mapping->i_pages, page_index(page),
+		__xa_clear_tag(&mapping->i_pages, page_index(page),
 				     PAGECACHE_TAG_DIRTY);
 		xa_unlock_irqrestore(&mapping->i_pages, flags);
 
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 265da200daa8..d1f00d56eee1 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -227,8 +227,8 @@ int f2fs_write_inline_data(struct inode *inode, struct page *page)
 	set_page_dirty(dn.inode_page);
 
 	xa_lock_irqsave(&mapping->i_pages, flags);
-	radix_tree_tag_clear(&mapping->i_pages, page_index(page),
-			     PAGECACHE_TAG_DIRTY);
+	__xa_clear_tag(&mapping->i_pages, page_index(page),
+			PAGECACHE_TAG_DIRTY);
 	xa_unlock_irqrestore(&mapping->i_pages, flags);
 
 	set_inode_flag(inode, FI_APPEND_WRITE);
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index f202398e20ea..fd8b9191c7c5 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -88,12 +88,11 @@ bool available_free_memory(struct f2fs_sb_info *sbi, int type)
 static void clear_node_page_dirty(struct page *page)
 {
 	struct address_space *mapping = page->mapping;
-	unsigned int long flags;
+	unsigned long flags;
 
 	if (PageDirty(page)) {
 		xa_lock_irqsave(&mapping->i_pages, flags);
-		radix_tree_tag_clear(&mapping->i_pages,
-				page_index(page),
+		__xa_clear_tag(&mapping->i_pages, page_index(page),
 				PAGECACHE_TAG_DIRTY);
 		xa_unlock_irqrestore(&mapping->i_pages, flags);
 
@@ -1160,9 +1159,7 @@ void ra_node_page(struct f2fs_sb_info *sbi, nid_t nid)
 		return;
 	f2fs_bug_on(sbi, check_nid_range(sbi, nid));
 
-	rcu_read_lock();
-	apage = radix_tree_lookup(&NODE_MAPPING(sbi)->i_pages, nid);
-	rcu_read_unlock();
+	apage = xa_load(&NODE_MAPPING(sbi)->i_pages, nid);
 	if (apage)
 		return;
 
-- 
2.17.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
