From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v5 56/78] f2fs: Convert to XArray
Date: Fri, 15 Dec 2017 14:04:28 -0800
Message-ID: <20171215220450.7899-57-willy@infradead.org>
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
 bh=T9UHgjsvMOlJWcNj5ey/5z9/Dj+z9dBtLpmY7uJEkvk=; b=SSuTV7ikcdqXmpHEfomV8aTNAT
 rKGm2gOfhvE0aCpm712Sn/0tHzt+Eothnn6vTiSX/I7mlrmY3D2rDr/1j6uZdsuJuIxFXmd04EeyG
 UqEBWqTYJimiR//zZvMYQS7IH634Cg2WNd5RKLqLxKT+RXEDwq/GY7PGKz3vo4UtJshg=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=T9UHgjsvMOlJWcNj5ey/5z9/Dj+z9dBtLpmY7uJEkvk=; b=dAz8Uvqe9EHwZUOhU91DLb4Q1J
 tf+7FWm3rfEt9zOaBDH5U3pZIK3NO7qoXoCDnEkbpzvKv7+Oltrg4CCtBPo/jvQFZ5SauV0lLS14D
 ye124SLbPX53gAZyDg3/1GM+cubM6lHqlALr6PxrwfTfuGFSNP7CaF13u8Mez9J0qz1g=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=T9UHgjsvMOlJWcNj5ey/5z9/Dj+z9dBtLpmY7uJEkvk=; b=QAYpIVuHgMErqCX28Wgz3re6r
 Yaziu0vjT40Pylin/sLzSMi8Ue1Fy/5bkrLwAC4tiKAb61PlvuRtAaXa+OFdTStk0om0z/ICQuSOO
 kdG5ArlRgrfxfz1hu/Zl6FCnZTWodyTHCAXoQBmFvwoYI+U8ktXTAKv4b0Pn2+3mS8Q7CI7KAGorR
 4BjhEHB5igSI2350G8oVlgTokSt+M72rLB2p0e94nuU3lDb9EPyLzgMtiK2XCslXxGzELxki2PW4O
 49ZrjEM6xHLJbDgoFSlaNUtEhtA4pb0GRG/U0Br9FrDQfWGxuTOTOcVi6HOw0xytB1kiHZHmbilRi
 Dz6BQffUQ==;
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

This is a straightforward conversion.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/f2fs/data.c   |  3 +--
 fs/f2fs/dir.c    |  5 +----
 fs/f2fs/inline.c |  6 +-----
 fs/f2fs/node.c   | 10 ++--------
 4 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index c8f6d9806896..1f3f192f152f 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2175,8 +2175,7 @@ void f2fs_set_page_dirty_nobuffers(struct page *page)
 	xa_lock_irqsave(&mapping->pages, flags);
 	WARN_ON_ONCE(!PageUptodate(page));
 	account_page_dirtied(page, mapping);
-	radix_tree_tag_set(&mapping->pages,
-			page_index(page), PAGECACHE_TAG_DIRTY);
+	__xa_set_tag(&mapping->pages, page_index(page), PAGECACHE_TAG_DIRTY);
 	xa_unlock_irqrestore(&mapping->pages, flags);
 	unlock_page_memcg(page);
 
diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index b5515ea6bb2f..296070016ec9 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -708,7 +708,6 @@ void f2fs_delete_entry(struct f2fs_dir_entry *dentry, struct page *page,
 	unsigned int bit_pos;
 	int slots = GET_DENTRY_SLOTS(le16_to_cpu(dentry->name_len));
 	struct address_space *mapping = page_mapping(page);
-	unsigned long flags;
 	int i;
 
 	f2fs_update_time(F2FS_I_SB(dir), REQ_TIME);
@@ -739,10 +738,8 @@ void f2fs_delete_entry(struct f2fs_dir_entry *dentry, struct page *page,
 
 	if (bit_pos == NR_DENTRY_IN_BLOCK &&
 			!truncate_hole(dir, page->index, page->index + 1)) {
-		xa_lock_irqsave(&mapping->pages, flags);
-		radix_tree_tag_clear(&mapping->pages, page_index(page),
+		xa_clear_tag(&mapping->pages, page_index(page),
 				     PAGECACHE_TAG_DIRTY);
-		xa_unlock_irqrestore(&mapping->pages, flags);
 
 		clear_page_dirty_for_io(page);
 		ClearPagePrivate(page);
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 7858b8e15f33..d3c3f84beca9 100644
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
 
-	xa_lock_irqsave(&mapping->pages, flags);
-	radix_tree_tag_clear(&mapping->pages, page_index(page),
-			     PAGECACHE_TAG_DIRTY);
-	xa_unlock_irqrestore(&mapping->pages, flags);
+	xa_clear_tag(&mapping->pages, page_index(page), PAGECACHE_TAG_DIRTY);
 
 	set_inode_flag(inode, FI_APPEND_WRITE);
 	set_inode_flag(inode, FI_DATA_EXIST);
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 6b64a3009d55..0a6d5c2f996e 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -88,14 +88,10 @@ bool available_free_memory(struct f2fs_sb_info *sbi, int type)
 static void clear_node_page_dirty(struct page *page)
 {
 	struct address_space *mapping = page->mapping;
-	unsigned int long flags;
 
 	if (PageDirty(page)) {
-		xa_lock_irqsave(&mapping->pages, flags);
-		radix_tree_tag_clear(&mapping->pages,
-				page_index(page),
+		xa_clear_tag(&mapping->pages, page_index(page),
 				PAGECACHE_TAG_DIRTY);
-		xa_unlock_irqrestore(&mapping->pages, flags);
 
 		clear_page_dirty_for_io(page);
 		dec_page_count(F2FS_M_SB(mapping), F2FS_DIRTY_NODES);
@@ -1142,9 +1138,7 @@ void ra_node_page(struct f2fs_sb_info *sbi, nid_t nid)
 		return;
 	f2fs_bug_on(sbi, check_nid_range(sbi, nid));
 
-	rcu_read_lock();
-	apage = radix_tree_lookup(&NODE_MAPPING(sbi)->pages, nid);
-	rcu_read_unlock();
+	apage = xa_load(&NODE_MAPPING(sbi)->pages, nid);
 	if (apage)
 		return;
 
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
