From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v10 50/62] f2fs: Convert to XArray
Date: Thu, 29 Mar 2018 20:42:33 -0700
Message-ID: <20180330034245.10462-51-willy@infradead.org>
References: <20180330034245.10462-1-willy@infradead.org>
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
 bh=uQ9HV77Lgkvf1u+jRkugm6dCZK6WEvbesNm0TrYf/cc=; b=SIb/7P5Qu3KnW5hnCXzmglFyG3
 Kn0Nq1wb7aVGVBqKiG4BMzyASF2YUI+O1h45sv7z3sg3N7wV2y1WEfeWvnk6GWzfiLx06j3jZaveu
 7aPa03myPdcooiGqG4TlK618463jTNO7tQgjJ8KPBSSU5Asp/grSXuo2g/rMIU4BNDlc=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=uQ9HV77Lgkvf1u+jRkugm6dCZK6WEvbesNm0TrYf/cc=; b=dVdd5kgILYuAqKCnKtV3ubBFGI
 YBkM5fA2V0DkKReSQ68PFG3SjeHcP+8n2uGQ4vnv66vbGBmhEBOGSw1mv+BXbySHSxCW8Mrav1lVo
 vJ5WW3LIdln/QKIwqHtWAdER1EpvoIACYIMbGdyS4rmvbu04k5FzKqUa9ohayrcyUIrs=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=uQ9HV77Lgkvf1u+jRkugm6dCZK6WEvbesNm0TrYf/cc=; b=WmII8r+tpsrH4ZWK19S9JWXeP
 F47h2ttirTAYsU4lV1IWLA7Fz4BYeZ+4rcUKL62FT8lRfTlOTb2oP8VWORwwSZDNufSB7KlGwcDFC
 Tt2LytT3R4md2DntWIaflrJuVHa58vhnbNoqkhchSx037sIY2tikPEZPBou+92+7oEBct264GaFVH
 livM1wt/pqRPUb9ow0Kc3YFcpkrbJl1o8UR+XjjE7AoJhfCHz/P2gEmW5M801RTquNgTkae26Rp3Y
 kQu15lxyS0Rw9JIHHuQkQLNTYa6xjwTlWpo0WfKyqirkMCzIp4wv1/6Zx0AAb+gB+nxREkdqbgXhl
 /3KkTd9Kw==;
In-Reply-To: <20180330034245.10462-1-willy@infradead.org>
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
 fs/f2fs/data.c   |  3 +--
 fs/f2fs/dir.c    |  5 +----
 fs/f2fs/inline.c |  6 +-----
 fs/f2fs/node.c   | 10 ++--------
 4 files changed, 5 insertions(+), 19 deletions(-)

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
index 8c9c2f31b253..bd75a3ab95ac 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -699,7 +699,6 @@ void f2fs_delete_entry(struct f2fs_dir_entry *dentry, struct page *page,
 	unsigned int bit_pos;
 	int slots = GET_DENTRY_SLOTS(le16_to_cpu(dentry->name_len));
 	struct address_space *mapping = page_mapping(page);
-	unsigned long flags;
 	int i;
 
 	f2fs_update_time(F2FS_I_SB(dir), REQ_TIME);
@@ -732,10 +731,8 @@ void f2fs_delete_entry(struct f2fs_dir_entry *dentry, struct page *page,
 
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
index 265da200daa8..98b9f99a7f76 100644
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
index ad1c2bf41ddd..27f0c033a0b7 100644
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
2.16.2


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
