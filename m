From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 4/8] nilfs2: move next generation counter into nilfs object
Date: Wed,  9 Mar 2011 21:08:09 +0900
Message-ID: <1299672493-28544-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1299672493-28544-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1299672493-28544-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Moves s_next_generation counter and a spinlock protecting it to nilfs
object from nilfs_sb_info structure.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/inode.c     |    8 ++++----
 fs/nilfs2/sb.h        |    4 ----
 fs/nilfs2/super.c     |   11 -----------
 fs/nilfs2/the_nilfs.c |    5 +++++
 fs/nilfs2/the_nilfs.h |    6 ++++++
 5 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index dd5d6d6..7a3dbe4 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -295,7 +295,7 @@ const struct address_space_operations nilfs_aops = {
 struct inode *nilfs_new_inode(struct inode *dir, int mode)
 {
 	struct super_block *sb = dir->i_sb;
-	struct nilfs_sb_info *sbi = NILFS_SB(sb);
+	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
 	struct inode *inode;
 	struct nilfs_inode_info *ii;
 	struct nilfs_root *root;
@@ -340,9 +340,9 @@ struct inode *nilfs_new_inode(struct inode *dir, int mode)
 	/* ii->i_dir_acl = 0; */
 	ii->i_dir_start_lookup = 0;
 	nilfs_set_inode_flags(inode);
-	spin_lock(&sbi->s_next_gen_lock);
-	inode->i_generation = sbi->s_next_generation++;
-	spin_unlock(&sbi->s_next_gen_lock);
+	spin_lock(&nilfs->ns_next_gen_lock);
+	inode->i_generation = nilfs->ns_next_generation++;
+	spin_unlock(&nilfs->ns_next_gen_lock);
 	insert_inode_hash(inode);
 
 	err = nilfs_init_acl(inode, dir);
diff --git a/fs/nilfs2/sb.h b/fs/nilfs2/sb.h
index 3232e75..6f190df 100644
--- a/fs/nilfs2/sb.h
+++ b/fs/nilfs2/sb.h
@@ -40,10 +40,6 @@ struct nilfs_sb_info {
 
 	/* Segment constructor */
 	struct nilfs_sc_info *s_sc_info; /* segment constructor info */
-
-	/* Inode allocator */
-	spinlock_t s_next_gen_lock;
-	u32 s_next_generation;
 };
 
 static inline struct nilfs_sb_info *NILFS_SB(struct super_block *sb)
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 6dc8b3c..1368c42 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -43,7 +43,6 @@
 #include <linux/init.h>
 #include <linux/blkdev.h>
 #include <linux/parser.h>
-#include <linux/random.h>
 #include <linux/crc32.h>
 #include <linux/vfs.h>
 #include <linux/writeback.h>
@@ -943,16 +942,6 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent)
 	if (err)
 		goto failed_nilfs;
 
-	/*
-	 * Following initialization is overlapped because
-	 * nilfs_sb_info structure has been cleared at the beginning.
-	 * But we reserve them to keep our interest and make ready
-	 * for the future change.
-	 */
-	get_random_bytes(&sbi->s_next_generation,
-			 sizeof(sbi->s_next_generation));
-	spin_lock_init(&sbi->s_next_gen_lock);
-
 	sb->s_op = &nilfs_sops;
 	sb->s_export_op = &nilfs_export_ops;
 	sb->s_root = NULL;
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 40239a9..1bf695e 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -25,6 +25,7 @@
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
+#include <linux/random.h>
 #include <linux/crc32.h>
 #include "nilfs.h"
 #include "segment.h"
@@ -78,6 +79,7 @@ struct the_nilfs *alloc_nilfs(struct block_device *bdev)
 	INIT_LIST_HEAD(&nilfs->ns_dirty_files);
 	INIT_LIST_HEAD(&nilfs->ns_gc_inodes);
 	spin_lock_init(&nilfs->ns_inode_lock);
+	spin_lock_init(&nilfs->ns_next_gen_lock);
 	spin_lock_init(&nilfs->ns_last_segment_lock);
 	nilfs->ns_cptree = RB_ROOT;
 	spin_lock_init(&nilfs->ns_cptree_lock);
@@ -593,6 +595,9 @@ int init_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi, char *data)
 	nilfs->ns_blocksize_bits = sb->s_blocksize_bits;
 	nilfs->ns_blocksize = blocksize;
 
+	get_random_bytes(&nilfs->ns_next_generation,
+			 sizeof(nilfs->ns_next_generation));
+
 	err = nilfs_store_disk_layout(nilfs, sbp);
 	if (err)
 		goto failed_sbh;
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 6106ec5..3ecc968f 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -74,6 +74,8 @@ enum {
  * @ns_dirty_files: list of dirty files
  * @ns_inode_lock: lock protecting @ns_dirty_files
  * @ns_gc_inodes: dummy inodes to keep live blocks
+ * @ns_next_generation: next generation number for inodes
+ * @ns_next_gen_lock: lock protecting @ns_next_generation
  * @ns_mount_opt: mount options
  * @ns_resuid: uid for reserved blocks
  * @ns_resgid: gid for reserved blocks
@@ -159,6 +161,10 @@ struct the_nilfs {
 	/* GC inode list */
 	struct list_head	ns_gc_inodes;
 
+	/* Inode allocator */
+	u32			ns_next_generation;
+	spinlock_t		ns_next_gen_lock;
+
 	/* Mount options */
 	unsigned long		ns_mount_opt;
 
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
