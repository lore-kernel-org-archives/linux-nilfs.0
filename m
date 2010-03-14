From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 4/6] nilfs2: fix various typos in comments
Date: Sun, 14 Mar 2010 11:28:37 +0900
Message-ID: <1268533719-19454-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1268533719-19454-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1268533719-19454-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This fixes various typos I found in comments of nilfs2.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/alloc.h   |    2 +-
 fs/nilfs2/dat.c     |    2 +-
 fs/nilfs2/gcinode.c |    4 ++--
 fs/nilfs2/page.c    |    4 ++--
 fs/nilfs2/segbuf.c  |    2 +-
 fs/nilfs2/segment.c |    4 ++--
 fs/nilfs2/segment.h |    2 +-
 fs/nilfs2/sufile.c  |    2 +-
 fs/nilfs2/super.c   |    2 +-
 9 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/nilfs2/alloc.h b/fs/nilfs2/alloc.h
index f4543ac..5cccf87 100644
--- a/fs/nilfs2/alloc.h
+++ b/fs/nilfs2/alloc.h
@@ -42,7 +42,7 @@ void *nilfs_palloc_block_get_entry(const struct inode *, __u64,
 				   const struct buffer_head *, void *);
 
 /**
- * nilfs_palloc_req - persistent alloctor request and reply
+ * nilfs_palloc_req - persistent allocator request and reply
  * @pr_entry_nr: entry number (vblocknr or inode number)
  * @pr_desc_bh: buffer head of the buffer containing block group descriptors
  * @pr_bitmap_bh: buffer head of the buffer containing a block group bitmap
diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index 9d1e5de..0131467 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -288,7 +288,7 @@ int nilfs_dat_mark_dirty(struct inode *dat, __u64 vblocknr)
  * @vblocknrs and @nitems.
  *
  * Return Value: On success, 0 is returned. On error, one of the following
- * nagative error codes is returned.
+ * negative error codes is returned.
  *
  * %-EIO - I/O error.
  *
diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
index e16a666..8880a9e 100644
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -28,10 +28,10 @@
  * gcinodes), and this file provides lookup function of the dummy
  * inodes and their buffer read function.
  *
- * Since NILFS2 keeps up multiple checkpoints/snapshots accross GC, it
+ * Since NILFS2 keeps up multiple checkpoints/snapshots across GC, it
  * has to treat blocks that belong to a same file but have different
  * checkpoint numbers.  To avoid interference among generations, dummy
- * inodes are managed separatly from actual inodes, and their lookup
+ * inodes are managed separately from actual inodes, and their lookup
  * function (nilfs_gc_iget) is designed to be specified with a
  * checkpoint number argument as well as an inode number.
  *
diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index a2692bb..fc246db 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -292,7 +292,7 @@ void nilfs_free_private_page(struct page *page)
  * @src: source page
  * @copy_dirty: flag whether to copy dirty states on the page's buffer heads.
  *
- * This fuction is for both data pages and btnode pages.  The dirty flag
+ * This function is for both data pages and btnode pages.  The dirty flag
  * should be treated by caller.  The page must not be under i/o.
  * Both src and dst page must be locked
  */
@@ -388,7 +388,7 @@ repeat:
 }
 
 /**
- * nilfs_copy_back_pages -- copy back pages to orignal cache from shadow cache
+ * nilfs_copy_back_pages -- copy back pages to original cache from shadow cache
  * @dmap: destination page cache
  * @smap: source page cache
  *
diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index 68b08f2..e3f67c6 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -174,7 +174,7 @@ int nilfs_segbuf_reset(struct nilfs_segment_buffer *segbuf, unsigned flags,
 }
 
 /*
- * Setup segument summary
+ * Setup segment summary
  */
 void nilfs_segbuf_fill_in_segsum(struct nilfs_segment_buffer *segbuf)
 {
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 3265bfc..69576a9 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -201,7 +201,7 @@ static int nilfs_prepare_segment_lock(struct nilfs_transaction_info *ti)
  * This function allocates a nilfs_transaction_info struct to keep context
  * information on it.  It is initialized and hooked onto the current task in
  * the outermost call.  If a pre-allocated struct is given to @ti, it is used
- * instead; othewise a new struct is assigned from a slab.
+ * instead; otherwise a new struct is assigned from a slab.
  *
  * When @vacancy_check flag is set, this function will check the amount of
  * free space, and will wait for the GC to reclaim disk space if low capacity.
@@ -2854,7 +2854,7 @@ static void nilfs_segctor_destroy(struct nilfs_sc_info *sci)
  * @sbi: nilfs_sb_info
  *
  * nilfs_attach_segment_constructor() allocates a struct nilfs_sc_info,
- * initilizes it, and starts the segment constructor.
+ * initializes it, and starts the segment constructor.
  *
  * Return Value: On success, 0 is returned. On error, one of the following
  * negative error code is returned.
diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
index 3155e0c..2a79456 100644
--- a/fs/nilfs2/segment.h
+++ b/fs/nilfs2/segment.h
@@ -30,7 +30,7 @@
 #include "sb.h"
 
 /**
- * struct nilfs_recovery_info - Recovery infomation
+ * struct nilfs_recovery_info - Recovery information
  * @ri_need_recovery: Recovery status
  * @ri_super_root: Block number of the last super root
  * @ri_ri_cno: Number of the last checkpoint
diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index b6c36d0..3c6cc60 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -18,7 +18,7 @@
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
  * Written by Koji Sato <koji-sG5X7nlA6pw@public.gmane.org>.
- * Rivised by Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>.
+ * Revised by Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>.
  */
 
 #include <linux/kernel.h>
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 92579cc..896b463 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -436,7 +436,7 @@ static int nilfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	/*
 	 * Compute the overhead
 	 *
-	 * When distributing meta data blocks outside semgent structure,
+	 * When distributing meta data blocks outside segment structure,
 	 * We must count them as the overhead.
 	 */
 	overhead = 0;
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
