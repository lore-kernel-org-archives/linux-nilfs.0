From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v14 61/74] f2fs: Convert to XArray
Date: Sat, 16 Jun 2018 19:00:39 -0700
Message-ID: <20180617020052.4759-62-willy@infradead.org>
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
 bh=f7Iyf3ITTQ3FIk5xcaWpgNSsAQ83TFpCp98rUBknrdw=; b=J5FiotDgi3sWKfydzoPYx6IGEt
 VCaCbK4iV2m824Aih9u+P9qeX8jHnYWtx3Oq3GZ2a4AYVmmfFReOZt+8ks4eSEjWUdZA0V4LmsYuj
 OKWWHLumrWElsZSXsCLNbfo5wLLcCoFfa4FA5SjEBtmJ7p5mZ0gCT6uHjrfHiNentNiU=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=f7Iyf3ITTQ3FIk5xcaWpgNSsAQ83TFpCp98rUBknrdw=; b=If5SzOMCPf7JDqeU9AFMs2eWhN
 IfpfJPbZXycna8yy8JaktuNMQt+dPxub2y+W3TsDf3prURLkQgYvOS1q/n+nDDPhsJ/R6WtzfuTLi
 yGyxKvzZQnuijNTURqzEo58YF0o4YfTmfQMF0LSHVPd9H8/llYCEhFop+Uct0nlMebu8=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=f7Iyf3ITTQ3FIk5xcaWpgNSsAQ83TFpCp98rUBknrdw=; b=CdmkJCRsi+wjbP40k5K1z3WBe
 KVkUK9wUX2QZkLV3tRZ2fNaw62SaxUrS7qTOqkKsS7RHbTqmsSbjVxb7Jd0Y5/JHTHIhCP65nxtz1
 bquETwD1xu7Jk4Bi+pKELSAtdtdyRWeqSrAWvbNiU0d54lv6JzxcmRTorjBjLJ0EqG0H+ToD31xZg
 ZkdyaGjVdTG+tQTEQDVDCvt0O0sF1bPTK6FFmFs1SlwSrwbFUndVMtx0nCmIj3LB1obRbrw4uwcyW
 hklm4Ywthohwu0mDA0435lFvj1q/qJNC8Me2/SDJsK3f2XThaCLNBMzcDbSjDyvNvJhC+EpFMt69f
 mRku16C1Q==;
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

This is a straightforward conversion.

Signed-off-by: Matthew Wilcox <willy@infradead.org>
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
index 10643b11bd59..9aa076be8a0e 100644
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
