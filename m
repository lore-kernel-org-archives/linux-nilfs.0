From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v13 60/72] f2fs: Convert to XArray
Date: Mon, 11 Jun 2018 07:06:27 -0700
Message-ID: <20180611140639.17215-61-willy@infradead.org>
References: <20180611140639.17215-1-willy@infradead.org>
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
 bh=shTCii8XN3GaoHud7h6kduHJWwZn5c2W4msLECbUBQ8=; b=Mfsw1BWIFItlb2/pVnwI1k6un+
 G/vZlUy6rA4Xq6y/kDpDVCNnB4Q1xAFq7isTeOCHjN46Ei3HwJsWsidamEv0oyLW9Pu6TjLmGNYR8
 SHbodJBXayjBgbwCxU5A4MQDr75MGRIqExxn7OvLwEMQ2c++MwuRlCD9NUioE9vVtZJE=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=shTCii8XN3GaoHud7h6kduHJWwZn5c2W4msLECbUBQ8=; b=BfENL7hrplDAg8VcDEZDU0+2Xc
 uq9OHlzgQq2IXbZB1baZzHLwxDPGJhRIx/kn0veZkjq6Y/NZu9Y1gcvWRjEzRSdkMoucS5cl9EX70
 ed35NeDM5SS8mTFb2/zCIj/YUVFUciRJm0b3O2/rd8qX9WSXe3yDEVk98FUts0P8Pvw4=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=shTCii8XN3GaoHud7h6kduHJWwZn5c2W4msLECbUBQ8=; b=qaqyTOZa8VV5F24xAEN/p0VqJ
 8pz7p9vrjV+Hm73Sc+0kCD3uYoLjMmA3he5tn2y7ZgcqT0T6b+bN17nN198rjfLBJfmVxTvM020xi
 V9cYnDAl9vhkBWrtGiFlMZed+i+N20oFrFf+qrksvHPwa3VLncNkvS+Yqmejt1Skr+j5Jo7mdp9kS
 K3ZIOcnb530aBKd/YrOqtKC/pokoPCAzJ+GCh9Jr1VLFEEVCEI1vHNohk6c7dBHOwjL1Km+I4tiE4
 OCEgBa7Th99FU3uNSAQgkdImMsaL8LcOn2/pNpsxbz0GnwonnMSFnJJ27n8HSGksHk0ADp+VIlczu
 G6ssNnbpQ==;
In-Reply-To: <20180611140639.17215-1-willy@infradead.org>
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
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, linux-f2fs-devel@lists.sourceforge.net, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>

From: Matthew Wilcox <mawilcox@microsoft.com>

This is a straightforward conversion.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/f2fs/data.c   | 4 ++--
 fs/f2fs/dir.c    | 2 +-
 fs/f2fs/f2fs.h   | 2 +-
 fs/f2fs/inline.c | 2 +-
 fs/f2fs/node.c   | 6 ++----
 5 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index e5c0b1e74ce6..b274300995cd 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2600,13 +2600,13 @@ const struct address_space_operations f2fs_dblock_aops = {
 #endif
 };
 
-void f2fs_clear_radix_tree_dirty_tag(struct page *page)
+void f2fs_clear_page_cache_dirty_tag(struct page *page)
 {
 	struct address_space *mapping = page_mapping(page);
 	unsigned long flags;
 
 	xa_lock_irqsave(&mapping->i_pages, flags);
-	radix_tree_tag_clear(&mapping->i_pages, page_index(page),
+	__xa_clear_tag(&mapping->i_pages, page_index(page),
 						PAGECACHE_TAG_DIRTY);
 	xa_unlock_irqrestore(&mapping->i_pages, flags);
 }
diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 7f955c4e86a4..9c2a23242f64 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -730,7 +730,7 @@ void f2fs_delete_entry(struct f2fs_dir_entry *dentry, struct page *page,
 
 	if (bit_pos == NR_DENTRY_IN_BLOCK &&
 		!f2fs_truncate_hole(dir, page->index, page->index + 1)) {
-		f2fs_clear_radix_tree_dirty_tag(page);
+		f2fs_clear_page_cache_dirty_tag(page);
 		clear_page_dirty_for_io(page);
 		ClearPagePrivate(page);
 		ClearPageUptodate(page);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 4d8b1de83143..1f71ab2ddad9 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -2973,7 +2973,7 @@ int f2fs_migrate_page(struct address_space *mapping, struct page *newpage,
 			struct page *page, enum migrate_mode mode);
 #endif
 bool f2fs_overwrite_io(struct inode *inode, loff_t pos, size_t len);
-void f2fs_clear_radix_tree_dirty_tag(struct page *page);
+void f2fs_clear_page_cache_dirty_tag(struct page *page);
 
 /*
  * gc.c
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 043830be5662..48f40d344a2a 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -226,7 +226,7 @@ int f2fs_write_inline_data(struct inode *inode, struct page *page)
 	kunmap_atomic(src_addr);
 	set_page_dirty(dn.inode_page);
 
-	f2fs_clear_radix_tree_dirty_tag(page);
+	f2fs_clear_page_cache_dirty_tag(page);
 
 	set_inode_flag(inode, FI_APPEND_WRITE);
 	set_inode_flag(inode, FI_DATA_EXIST);
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 47d0e64a95a8..44f3974fddf4 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -103,7 +103,7 @@ bool f2fs_available_free_memory(struct f2fs_sb_info *sbi, int type)
 static void clear_node_page_dirty(struct page *page)
 {
 	if (PageDirty(page)) {
-		f2fs_clear_radix_tree_dirty_tag(page);
+		f2fs_clear_page_cache_dirty_tag(page);
 		clear_page_dirty_for_io(page);
 		dec_page_count(F2FS_P_SB(page), F2FS_DIRTY_NODES);
 	}
@@ -1168,9 +1168,7 @@ void f2fs_ra_node_page(struct f2fs_sb_info *sbi, nid_t nid)
 	if (f2fs_check_nid_range(sbi, nid))
 		return;
 
-	rcu_read_lock();
-	apage = radix_tree_lookup(&NODE_MAPPING(sbi)->i_pages, nid);
-	rcu_read_unlock();
+	apage = xa_load(&NODE_MAPPING(sbi)->i_pages, nid);
 	if (apage)
 		return;
 
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
