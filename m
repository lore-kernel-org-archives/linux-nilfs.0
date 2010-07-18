From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 3/4] nilfs2: introduce check flag to btree node buffer
Date: Sun, 18 Jul 2010 10:42:25 +0900
Message-ID: <1279417346-9688-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1279417346-9688-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1279417346-9688-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

nilfs_btree_get_block() now may return untested buffer due to
read-ahead This adds new flag for buffer heads so that the btree code
can check whether the buffer is already verified or not.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/btree.c |   10 +++++++++-
 fs/nilfs2/page.c  |    5 ++++-
 fs/nilfs2/page.h  |    2 ++
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 1b5321c..d3faa0b 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -370,8 +370,16 @@ static int nilfs_btree_node_broken(const struct nilfs_btree_node *node,
 
 int nilfs_btree_broken_node_block(struct buffer_head *bh)
 {
-	return nilfs_btree_node_broken((struct nilfs_btree_node *)bh->b_data,
+	int ret;
+
+	if (buffer_nilfs_checked(bh))
+		return 0;
+
+	ret = nilfs_btree_node_broken((struct nilfs_btree_node *)bh->b_data,
 				       bh->b_size, bh->b_blocknr);
+	if (likely(!ret))
+		set_buffer_nilfs_checked(bh);
+	return ret;
 }
 
 static struct nilfs_btree_node *
diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 8de3e1e..aab11db 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -37,7 +37,8 @@
 
 #define NILFS_BUFFER_INHERENT_BITS  \
 	((1UL << BH_Uptodate) | (1UL << BH_Mapped) | (1UL << BH_NILFS_Node) | \
-	 (1UL << BH_NILFS_Volatile) | (1UL << BH_NILFS_Allocated))
+	 (1UL << BH_NILFS_Volatile) | (1UL << BH_NILFS_Allocated) | \
+	 (1UL << BH_NILFS_Checked))
 
 static struct buffer_head *
 __nilfs_get_page_block(struct page *page, unsigned long block, pgoff_t index,
@@ -129,6 +130,7 @@ void nilfs_forget_buffer(struct buffer_head *bh)
 
 	lock_buffer(bh);
 	clear_buffer_nilfs_volatile(bh);
+	clear_buffer_nilfs_checked(bh);
 	clear_buffer_dirty(bh);
 	if (nilfs_page_buffers_clean(page))
 		__nilfs_clear_page_dirty(page);
@@ -480,6 +482,7 @@ void nilfs_clear_dirty_pages(struct address_space *mapping)
 				lock_buffer(bh);
 				clear_buffer_dirty(bh);
 				clear_buffer_nilfs_volatile(bh);
+				clear_buffer_nilfs_checked(bh);
 				clear_buffer_uptodate(bh);
 				clear_buffer_mapped(bh);
 				unlock_buffer(bh);
diff --git a/fs/nilfs2/page.h b/fs/nilfs2/page.h
index 8abca4d..f53d8da 100644
--- a/fs/nilfs2/page.h
+++ b/fs/nilfs2/page.h
@@ -34,11 +34,13 @@ enum {
 	BH_NILFS_Allocated = BH_PrivateStart,
 	BH_NILFS_Node,
 	BH_NILFS_Volatile,
+	BH_NILFS_Checked,
 };
 
 BUFFER_FNS(NILFS_Allocated, nilfs_allocated)	/* nilfs private buffers */
 BUFFER_FNS(NILFS_Node, nilfs_node)		/* nilfs node buffers */
 BUFFER_FNS(NILFS_Volatile, nilfs_volatile)
+BUFFER_FNS(NILFS_Checked, nilfs_checked)	/* buffer is verified */
 
 
 void nilfs_mark_buffer_dirty(struct buffer_head *bh);
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
