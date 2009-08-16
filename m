From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 4/7] nilfs2: remove individual gfp constants
	for each metadata file
Date: Sun, 16 Aug 2009 15:51:07 +0900
Message-ID: <1250405470-23326-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1250405470-23326-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1250405470-23326-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
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

This gets rid of NILFS_CPFILE_GFP, NILFS_SUFILE_GFP, NILFS_DAT_GFP,
and NILFS_IFILE_GFP.  All of these constants refer to NILFS_MDT_GFP,
and can be removed.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/cpfile.h    |    2 --
 fs/nilfs2/dat.h       |    1 -
 fs/nilfs2/ifile.h     |    1 -
 fs/nilfs2/mdt.c       |    5 +++--
 fs/nilfs2/mdt.h       |    3 +--
 fs/nilfs2/sufile.h    |    1 -
 fs/nilfs2/super.c     |    3 +--
 fs/nilfs2/the_nilfs.c |   12 ++++--------
 8 files changed, 9 insertions(+), 19 deletions(-)

diff --git a/fs/nilfs2/cpfile.h b/fs/nilfs2/cpfile.h
index 788a459..debea89 100644
--- a/fs/nilfs2/cpfile.h
+++ b/fs/nilfs2/cpfile.h
@@ -27,8 +27,6 @@
 #include <linux/buffer_head.h>
 #include <linux/nilfs2_fs.h>
 
-#define NILFS_CPFILE_GFP	NILFS_MDT_GFP
-
 
 int nilfs_cpfile_get_checkpoint(struct inode *, __u64, int,
 				struct nilfs_checkpoint **,
diff --git a/fs/nilfs2/dat.h b/fs/nilfs2/dat.h
index 4b0b47e..91dc337 100644
--- a/fs/nilfs2/dat.h
+++ b/fs/nilfs2/dat.h
@@ -27,7 +27,6 @@
 #include <linux/buffer_head.h>
 #include <linux/fs.h>
 
-#define NILFS_DAT_GFP	NILFS_MDT_GFP
 
 struct nilfs_palloc_req;
 
diff --git a/fs/nilfs2/ifile.h b/fs/nilfs2/ifile.h
index 5d30a35..ecc3ba7 100644
--- a/fs/nilfs2/ifile.h
+++ b/fs/nilfs2/ifile.h
@@ -31,7 +31,6 @@
 #include "mdt.h"
 #include "alloc.h"
 
-#define NILFS_IFILE_GFP  NILFS_MDT_GFP
 
 static inline struct nilfs_inode *
 nilfs_ifile_map_inode(struct inode *ifile, ino_t ino, struct buffer_head *ibh)
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index a5cd801..5b3faf1 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -518,9 +518,10 @@ nilfs_mdt_new_common(struct the_nilfs *nilfs, struct super_block *sb,
 }
 
 struct inode *nilfs_mdt_new(struct the_nilfs *nilfs, struct super_block *sb,
-			    ino_t ino, gfp_t gfp_mask)
+			    ino_t ino)
 {
-	struct inode *inode = nilfs_mdt_new_common(nilfs, sb, ino, gfp_mask);
+	struct inode *inode = nilfs_mdt_new_common(nilfs, sb, ino,
+						   NILFS_MDT_GFP);
 
 	if (!inode)
 		return NULL;
diff --git a/fs/nilfs2/mdt.h b/fs/nilfs2/mdt.h
index df683e0..4315997 100644
--- a/fs/nilfs2/mdt.h
+++ b/fs/nilfs2/mdt.h
@@ -74,8 +74,7 @@ int nilfs_mdt_forget_block(struct inode *, unsigned long);
 int nilfs_mdt_mark_block_dirty(struct inode *, unsigned long);
 int nilfs_mdt_fetch_dirty(struct inode *);
 
-struct inode *nilfs_mdt_new(struct the_nilfs *, struct super_block *, ino_t,
-			    gfp_t);
+struct inode *nilfs_mdt_new(struct the_nilfs *, struct super_block *, ino_t);
 struct inode *nilfs_mdt_new_common(struct the_nilfs *, struct super_block *,
 				   ino_t, gfp_t);
 void nilfs_mdt_destroy(struct inode *);
diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
index a2c4d76..0e99e5c 100644
--- a/fs/nilfs2/sufile.h
+++ b/fs/nilfs2/sufile.h
@@ -28,7 +28,6 @@
 #include <linux/nilfs2_fs.h>
 #include "mdt.h"
 
-#define NILFS_SUFILE_GFP	NILFS_MDT_GFP
 
 static inline unsigned long nilfs_sufile_get_nsegments(struct inode *sufile)
 {
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 7042880..05174c5 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -363,8 +363,7 @@ int nilfs_attach_checkpoint(struct nilfs_sb_info *sbi, __u64 cno)
 	list_add(&sbi->s_list, &nilfs->ns_supers);
 	up_write(&nilfs->ns_super_sem);
 
-	sbi->s_ifile = nilfs_mdt_new(
-		nilfs, sbi->s_super, NILFS_IFILE_INO, NILFS_IFILE_GFP);
+	sbi->s_ifile = nilfs_mdt_new(nilfs, sbi->s_super, NILFS_IFILE_INO);
 	if (!sbi->s_ifile)
 		return -ENOMEM;
 
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 0c45736..d4168e2 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -187,23 +187,19 @@ static int nilfs_load_super_root(struct the_nilfs *nilfs,
 	inode_size = nilfs->ns_inode_size;
 
 	err = -ENOMEM;
-	nilfs->ns_dat = nilfs_mdt_new(
-		nilfs, NULL, NILFS_DAT_INO, NILFS_DAT_GFP);
+	nilfs->ns_dat = nilfs_mdt_new(nilfs, NULL, NILFS_DAT_INO);
 	if (unlikely(!nilfs->ns_dat))
 		goto failed;
 
-	nilfs->ns_gc_dat = nilfs_mdt_new(
-		nilfs, NULL, NILFS_DAT_INO, NILFS_DAT_GFP);
+	nilfs->ns_gc_dat = nilfs_mdt_new(nilfs, NULL, NILFS_DAT_INO);
 	if (unlikely(!nilfs->ns_gc_dat))
 		goto failed_dat;
 
-	nilfs->ns_cpfile = nilfs_mdt_new(
-		nilfs, NULL, NILFS_CPFILE_INO, NILFS_CPFILE_GFP);
+	nilfs->ns_cpfile = nilfs_mdt_new(nilfs, NULL, NILFS_CPFILE_INO);
 	if (unlikely(!nilfs->ns_cpfile))
 		goto failed_gc_dat;
 
-	nilfs->ns_sufile = nilfs_mdt_new(
-		nilfs, NULL, NILFS_SUFILE_INO, NILFS_SUFILE_GFP);
+	nilfs->ns_sufile = nilfs_mdt_new(nilfs, NULL, NILFS_SUFILE_INO);
 	if (unlikely(!nilfs->ns_sufile))
 		goto failed_cpfile;
 
-- 
1.6.3.4
