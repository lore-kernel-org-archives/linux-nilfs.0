From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 06/23] nilfs2: separate constructor of
	metadata files
Date: Sun, 15 Nov 2009 21:46:44 +0900
Message-ID: <1258289221-3827-7-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This will displace nilfs_mdt_new() constructor with individual
metadata file constructors like nilfs_dat_new(), new_sufile_new(),
nilfs_cpfile_new(), and nilfs_ifile_new().

This makes it possible for each metadata file to have own
intialization code.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/cpfile.c    |   16 ++++++++++++++++
 fs/nilfs2/cpfile.h    |    2 ++
 fs/nilfs2/dat.c       |   23 +++++++++++++++++++++++
 fs/nilfs2/dat.h       |    2 ++
 fs/nilfs2/ifile.c     |   21 +++++++++++++++++++++
 fs/nilfs2/ifile.h     |    2 ++
 fs/nilfs2/sufile.c    |   16 ++++++++++++++++
 fs/nilfs2/sufile.h    |    2 ++
 fs/nilfs2/super.c     |    6 +-----
 fs/nilfs2/the_nilfs.c |   24 ++++--------------------
 10 files changed, 89 insertions(+), 25 deletions(-)

diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index 3f5d5d0..2aaefae 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -926,3 +926,19 @@ int nilfs_cpfile_get_stat(struct inode *cpfile, struct nilfs_cpstat *cpstat)
 	up_read(&NILFS_MDT(cpfile)->mi_sem);
 	return ret;
 }
+
+/**
+ * nilfs_cpfile_new - create cpfile
+ * @nilfs: nilfs object
+ * @cpsize: size of a checkpoint entry
+ */
+struct inode *nilfs_cpfile_new(struct the_nilfs *nilfs, size_t cpsize)
+{
+	struct inode *cpfile;
+
+	cpfile = nilfs_mdt_new(nilfs, NULL, NILFS_CPFILE_INO, 0);
+	if (cpfile)
+		nilfs_mdt_set_entry_size(cpfile, cpsize,
+					 sizeof(struct nilfs_cpfile_header));
+	return cpfile;
+}
diff --git a/fs/nilfs2/cpfile.h b/fs/nilfs2/cpfile.h
index debea89..8ff2b4f 100644
--- a/fs/nilfs2/cpfile.h
+++ b/fs/nilfs2/cpfile.h
@@ -40,4 +40,6 @@ int nilfs_cpfile_get_stat(struct inode *, struct nilfs_cpstat *);
 ssize_t nilfs_cpfile_get_cpinfo(struct inode *, __u64 *, int, void *, unsigned,
 				size_t);
 
+struct inode *nilfs_cpfile_new(struct the_nilfs *nilfs, size_t cpsize);
+
 #endif	/* _NILFS_CPFILE_H */
diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index 1ff8e15..239a422 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -425,3 +425,26 @@ ssize_t nilfs_dat_get_vinfo(struct inode *dat, void *buf, unsigned visz,
 
 	return nvi;
 }
+
+/**
+ * nilfs_dat_new - create dat file
+ * @nilfs: nilfs object
+ * @entry_size: size of a dat entry
+ */
+struct inode *nilfs_dat_new(struct the_nilfs *nilfs, size_t entry_size)
+{
+	static struct lock_class_key dat_lock_key;
+	struct inode *dat;
+	int err;
+
+	dat = nilfs_mdt_new(nilfs, NULL, NILFS_DAT_INO, 0);
+	if (dat) {
+		err = nilfs_palloc_init_blockgroup(dat, entry_size);
+		if (unlikely(err)) {
+			nilfs_mdt_destroy(dat);
+			return NULL;
+		}
+		lockdep_set_class(&NILFS_MDT(dat)->mi_sem, &dat_lock_key);
+	}
+	return dat;
+}
diff --git a/fs/nilfs2/dat.h b/fs/nilfs2/dat.h
index 406070d..98f3306 100644
--- a/fs/nilfs2/dat.h
+++ b/fs/nilfs2/dat.h
@@ -53,4 +53,6 @@ int nilfs_dat_freev(struct inode *, __u64 *, size_t);
 int nilfs_dat_move(struct inode *, __u64, sector_t);
 ssize_t nilfs_dat_get_vinfo(struct inode *, void *, unsigned, size_t);
 
+struct inode *nilfs_dat_new(struct the_nilfs *nilfs, size_t entry_size);
+
 #endif	/* _NILFS_DAT_H */
diff --git a/fs/nilfs2/ifile.c b/fs/nilfs2/ifile.c
index de86401..c1c1fd3 100644
--- a/fs/nilfs2/ifile.c
+++ b/fs/nilfs2/ifile.c
@@ -148,3 +148,24 @@ int nilfs_ifile_get_inode_block(struct inode *ifile, ino_t ino,
 	}
 	return err;
 }
+
+/**
+ * nilfs_ifile_new - create inode file
+ * @sbi: nilfs_sb_info struct
+ * @inode_size: size of an inode
+ */
+struct inode *nilfs_ifile_new(struct nilfs_sb_info *sbi, size_t inode_size)
+{
+	struct inode *ifile;
+	int err;
+
+	ifile = nilfs_mdt_new(sbi->s_nilfs, sbi->s_super, NILFS_IFILE_INO, 0);
+	if (ifile) {
+		err = nilfs_palloc_init_blockgroup(ifile, inode_size);
+		if (unlikely(err)) {
+			nilfs_mdt_destroy(ifile);
+			return NULL;
+		}
+	}
+	return ifile;
+}
diff --git a/fs/nilfs2/ifile.h b/fs/nilfs2/ifile.h
index ecc3ba7..cbca32e 100644
--- a/fs/nilfs2/ifile.h
+++ b/fs/nilfs2/ifile.h
@@ -49,4 +49,6 @@ int nilfs_ifile_create_inode(struct inode *, ino_t *, struct buffer_head **);
 int nilfs_ifile_delete_inode(struct inode *, ino_t);
 int nilfs_ifile_get_inode_block(struct inode *, ino_t, struct buffer_head **);
 
+struct inode *nilfs_ifile_new(struct nilfs_sb_info *sbi, size_t inode_size);
+
 #endif	/* _NILFS_IFILE_H */
diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 37994d4..6fb707a 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -657,3 +657,19 @@ ssize_t nilfs_sufile_get_suinfo(struct inode *sufile, __u64 segnum, void *buf,
 	up_read(&NILFS_MDT(sufile)->mi_sem);
 	return ret;
 }
+
+/**
+ * nilfs_sufile_new - create sufile
+ * @nilfs: nilfs object
+ * @susize: size of a segment usage entry
+ */
+struct inode *nilfs_sufile_new(struct the_nilfs *nilfs, size_t susize)
+{
+	struct inode *sufile;
+
+	sufile = nilfs_mdt_new(nilfs, NULL, NILFS_SUFILE_INO, 0);
+	if (sufile)
+		nilfs_mdt_set_entry_size(sufile, susize,
+					 sizeof(struct nilfs_sufile_header));
+	return sufile;
+}
diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
index 0e99e5c..50d3191 100644
--- a/fs/nilfs2/sufile.h
+++ b/fs/nilfs2/sufile.h
@@ -62,6 +62,8 @@ void nilfs_sufile_do_cancel_free(struct inode *, __u64, struct buffer_head *,
 void nilfs_sufile_do_set_error(struct inode *, __u64, struct buffer_head *,
 			       struct buffer_head *);
 
+struct inode *nilfs_sufile_new(struct the_nilfs *nilfs, size_t susize);
+
 /**
  * nilfs_sufile_scrap - make a segment garbage
  * @sufile: inode of segment usage file
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 77f2e47..05ae52a 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -363,14 +363,10 @@ int nilfs_attach_checkpoint(struct nilfs_sb_info *sbi, __u64 cno)
 	list_add(&sbi->s_list, &nilfs->ns_supers);
 	up_write(&nilfs->ns_super_sem);
 
-	sbi->s_ifile = nilfs_mdt_new(nilfs, sbi->s_super, NILFS_IFILE_INO, 0);
+	sbi->s_ifile = nilfs_ifile_new(sbi, nilfs->ns_inode_size);
 	if (!sbi->s_ifile)
 		return -ENOMEM;
 
-	err = nilfs_palloc_init_blockgroup(sbi->s_ifile, nilfs->ns_inode_size);
-	if (unlikely(err))
-		goto failed;
-
 	down_read(&nilfs->ns_segctor_sem);
 	err = nilfs_cpfile_get_checkpoint(nilfs->ns_cpfile, cno, 0, &raw_cp,
 					  &bh_cp);
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index a80bbb7..d4a731f 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -166,7 +166,6 @@ void put_nilfs(struct the_nilfs *nilfs)
 static int nilfs_load_super_root(struct the_nilfs *nilfs,
 				 struct nilfs_sb_info *sbi, sector_t sr_block)
 {
-	static struct lock_class_key dat_lock_key;
 	struct buffer_head *bh_sr;
 	struct nilfs_super_root *raw_sr;
 	struct nilfs_super_block **sbp = nilfs->ns_sbp;
@@ -187,38 +186,23 @@ static int nilfs_load_super_root(struct the_nilfs *nilfs,
 	inode_size = nilfs->ns_inode_size;
 
 	err = -ENOMEM;
-	nilfs->ns_dat = nilfs_mdt_new(nilfs, NULL, NILFS_DAT_INO, 0);
+	nilfs->ns_dat = nilfs_dat_new(nilfs, dat_entry_size);
 	if (unlikely(!nilfs->ns_dat))
 		goto failed;
 
-	nilfs->ns_gc_dat = nilfs_mdt_new(nilfs, NULL, NILFS_DAT_INO, 0);
+	nilfs->ns_gc_dat = nilfs_dat_new(nilfs, dat_entry_size);
 	if (unlikely(!nilfs->ns_gc_dat))
 		goto failed_dat;
 
-	nilfs->ns_cpfile = nilfs_mdt_new(nilfs, NULL, NILFS_CPFILE_INO, 0);
+	nilfs->ns_cpfile = nilfs_cpfile_new(nilfs, checkpoint_size);
 	if (unlikely(!nilfs->ns_cpfile))
 		goto failed_gc_dat;
 
-	nilfs->ns_sufile = nilfs_mdt_new(nilfs, NULL, NILFS_SUFILE_INO, 0);
+	nilfs->ns_sufile = nilfs_sufile_new(nilfs, segment_usage_size);
 	if (unlikely(!nilfs->ns_sufile))
 		goto failed_cpfile;
 
-	err = nilfs_palloc_init_blockgroup(nilfs->ns_dat, dat_entry_size);
-	if (unlikely(err))
-		goto failed_sufile;
-
-	err = nilfs_palloc_init_blockgroup(nilfs->ns_gc_dat, dat_entry_size);
-	if (unlikely(err))
-		goto failed_sufile;
-
-	lockdep_set_class(&NILFS_MDT(nilfs->ns_dat)->mi_sem, &dat_lock_key);
-	lockdep_set_class(&NILFS_MDT(nilfs->ns_gc_dat)->mi_sem, &dat_lock_key);
-
 	nilfs_mdt_set_shadow(nilfs->ns_dat, nilfs->ns_gc_dat);
-	nilfs_mdt_set_entry_size(nilfs->ns_cpfile, checkpoint_size,
-				 sizeof(struct nilfs_cpfile_header));
-	nilfs_mdt_set_entry_size(nilfs->ns_sufile, segment_usage_size,
-				 sizeof(struct nilfs_sufile_header));
 
 	err = nilfs_mdt_read_inode_direct(
 		nilfs->ns_dat, bh_sr, NILFS_SR_DAT_OFFSET(inode_size));
-- 
1.6.3.4
