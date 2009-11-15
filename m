From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 05/23] nilfs2: add size option of private
	object to metadata file allocator
Date: Sun, 15 Nov 2009 21:46:43 +0900
Message-ID: <1258289221-3827-6-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1258289221-3827-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1258289221-3827-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This adds an optional "object size" argument to nilfs_mdt_new_common()
function; the argument specifies the size of private object attached
to a newly allocated metadata file inode.

This will afford space to keep local variables for meta data files.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/gcinode.c   |    3 ++-
 fs/nilfs2/mdt.c       |   19 ++++++++++++++-----
 fs/nilfs2/mdt.h       |    5 +++--
 fs/nilfs2/super.c     |    2 +-
 fs/nilfs2/the_nilfs.c |    8 ++++----
 5 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
index e6de0a2..32b04da 100644
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -212,9 +212,10 @@ void nilfs_destroy_gccache(struct the_nilfs *nilfs)
 static struct inode *alloc_gcinode(struct the_nilfs *nilfs, ino_t ino,
 				   __u64 cno)
 {
-	struct inode *inode = nilfs_mdt_new_common(nilfs, NULL, ino, GFP_NOFS);
+	struct inode *inode;
 	struct nilfs_inode_info *ii;
 
+	inode = nilfs_mdt_new_common(nilfs, NULL, ino, GFP_NOFS, 0);
 	if (!inode)
 		return NULL;
 
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index f632611..62074e8 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -445,9 +445,17 @@ static const struct file_operations def_mdt_fops;
  * longer than those of the super block structs; they may continue for
  * several consecutive mounts/umounts.  This would need discussions.
  */
+/**
+ * nilfs_mdt_new_common - allocate a pseudo inode for metadata file
+ * @nilfs: nilfs object
+ * @sb: super block instance the metadata file belongs to
+ * @ino: inode number
+ * @gfp_mask: gfp mask for data pages
+ * @objsz: size of the private object attached to inode->i_private
+ */
 struct inode *
 nilfs_mdt_new_common(struct the_nilfs *nilfs, struct super_block *sb,
-		     ino_t ino, gfp_t gfp_mask)
+		     ino_t ino, gfp_t gfp_mask, size_t objsz)
 {
 	struct inode *inode = nilfs_alloc_inode_common(nilfs);
 
@@ -455,8 +463,9 @@ nilfs_mdt_new_common(struct the_nilfs *nilfs, struct super_block *sb,
 		return NULL;
 	else {
 		struct address_space * const mapping = &inode->i_data;
-		struct nilfs_mdt_info *mi = kzalloc(sizeof(*mi), GFP_NOFS);
+		struct nilfs_mdt_info *mi;
 
+		mi = kzalloc(max(sizeof(*mi), objsz), GFP_NOFS);
 		if (!mi) {
 			nilfs_destroy_inode(inode);
 			return NULL;
@@ -513,11 +522,11 @@ nilfs_mdt_new_common(struct the_nilfs *nilfs, struct super_block *sb,
 }
 
 struct inode *nilfs_mdt_new(struct the_nilfs *nilfs, struct super_block *sb,
-			    ino_t ino)
+			    ino_t ino, size_t objsz)
 {
-	struct inode *inode = nilfs_mdt_new_common(nilfs, sb, ino,
-						   NILFS_MDT_GFP);
+	struct inode *inode;
 
+	inode = nilfs_mdt_new_common(nilfs, sb, ino, NILFS_MDT_GFP, objsz);
 	if (!inode)
 		return NULL;
 
diff --git a/fs/nilfs2/mdt.h b/fs/nilfs2/mdt.h
index 4315997..3eb40e8 100644
--- a/fs/nilfs2/mdt.h
+++ b/fs/nilfs2/mdt.h
@@ -74,9 +74,10 @@ int nilfs_mdt_forget_block(struct inode *, unsigned long);
 int nilfs_mdt_mark_block_dirty(struct inode *, unsigned long);
 int nilfs_mdt_fetch_dirty(struct inode *);
 
-struct inode *nilfs_mdt_new(struct the_nilfs *, struct super_block *, ino_t);
+struct inode *nilfs_mdt_new(struct the_nilfs *, struct super_block *, ino_t,
+			    size_t);
 struct inode *nilfs_mdt_new_common(struct the_nilfs *, struct super_block *,
-				   ino_t, gfp_t);
+				   ino_t, gfp_t, size_t);
 void nilfs_mdt_destroy(struct inode *);
 void nilfs_mdt_clear(struct inode *);
 void nilfs_mdt_set_entry_size(struct inode *, unsigned, unsigned);
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index b6837f4..77f2e47 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -363,7 +363,7 @@ int nilfs_attach_checkpoint(struct nilfs_sb_info *sbi, __u64 cno)
 	list_add(&sbi->s_list, &nilfs->ns_supers);
 	up_write(&nilfs->ns_super_sem);
 
-	sbi->s_ifile = nilfs_mdt_new(nilfs, sbi->s_super, NILFS_IFILE_INO);
+	sbi->s_ifile = nilfs_mdt_new(nilfs, sbi->s_super, NILFS_IFILE_INO, 0);
 	if (!sbi->s_ifile)
 		return -ENOMEM;
 
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index ad391a8..a80bbb7 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -187,19 +187,19 @@ static int nilfs_load_super_root(struct the_nilfs *nilfs,
 	inode_size = nilfs->ns_inode_size;
 
 	err = -ENOMEM;
-	nilfs->ns_dat = nilfs_mdt_new(nilfs, NULL, NILFS_DAT_INO);
+	nilfs->ns_dat = nilfs_mdt_new(nilfs, NULL, NILFS_DAT_INO, 0);
 	if (unlikely(!nilfs->ns_dat))
 		goto failed;
 
-	nilfs->ns_gc_dat = nilfs_mdt_new(nilfs, NULL, NILFS_DAT_INO);
+	nilfs->ns_gc_dat = nilfs_mdt_new(nilfs, NULL, NILFS_DAT_INO, 0);
 	if (unlikely(!nilfs->ns_gc_dat))
 		goto failed_dat;
 
-	nilfs->ns_cpfile = nilfs_mdt_new(nilfs, NULL, NILFS_CPFILE_INO);
+	nilfs->ns_cpfile = nilfs_mdt_new(nilfs, NULL, NILFS_CPFILE_INO, 0);
 	if (unlikely(!nilfs->ns_cpfile))
 		goto failed_gc_dat;
 
-	nilfs->ns_sufile = nilfs_mdt_new(nilfs, NULL, NILFS_SUFILE_INO);
+	nilfs->ns_sufile = nilfs_mdt_new(nilfs, NULL, NILFS_SUFILE_INO, 0);
 	if (unlikely(!nilfs->ns_sufile))
 		goto failed_cpfile;
 
-- 
1.6.3.4
