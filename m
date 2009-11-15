From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 07/23] nilfs2: separate read method of meta
	data files on super root block
Date: Sun, 15 Nov 2009 21:46:45 +0900
Message-ID: <1258289221-3827-8-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

Will displace nilfs_mdt_read_inode_direct function with an individual
read method: nilfs_dat_read, nilfs_sufile_read, nilfs_cpfile_read.

This provides the opportunity to initialize local variables of each
metadata file after reading the inode.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/cpfile.c    |   10 ++++++++++
 fs/nilfs2/cpfile.h    |    1 +
 fs/nilfs2/dat.c       |   10 ++++++++++
 fs/nilfs2/dat.h       |    1 +
 fs/nilfs2/sufile.c    |   10 ++++++++++
 fs/nilfs2/sufile.h    |    1 +
 fs/nilfs2/the_nilfs.c |   12 ++++++------
 7 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index 2aaefae..d5ad54e 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -928,6 +928,16 @@ int nilfs_cpfile_get_stat(struct inode *cpfile, struct nilfs_cpstat *cpstat)
 }
 
 /**
+ * nilfs_cpfile_read - read cpfile inode
+ * @cpfile: cpfile inode
+ * @raw_inode: on-disk cpfile inode
+ */
+int nilfs_cpfile_read(struct inode *cpfile, struct nilfs_inode *raw_inode)
+{
+	return nilfs_read_inode_common(cpfile, raw_inode);
+}
+
+/**
  * nilfs_cpfile_new - create cpfile
  * @nilfs: nilfs object
  * @cpsize: size of a checkpoint entry
diff --git a/fs/nilfs2/cpfile.h b/fs/nilfs2/cpfile.h
index 8ff2b4f..bc0809e 100644
--- a/fs/nilfs2/cpfile.h
+++ b/fs/nilfs2/cpfile.h
@@ -40,6 +40,7 @@ int nilfs_cpfile_get_stat(struct inode *, struct nilfs_cpstat *);
 ssize_t nilfs_cpfile_get_cpinfo(struct inode *, __u64 *, int, void *, unsigned,
 				size_t);
 
+int nilfs_cpfile_read(struct inode *cpfile, struct nilfs_inode *raw_inode);
 struct inode *nilfs_cpfile_new(struct the_nilfs *nilfs, size_t cpsize);
 
 #endif	/* _NILFS_CPFILE_H */
diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index 239a422..eff3169 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -427,6 +427,16 @@ ssize_t nilfs_dat_get_vinfo(struct inode *dat, void *buf, unsigned visz,
 }
 
 /**
+ * nilfs_dat_read - read dat inode
+ * @dat: dat inode
+ * @raw_inode: on-disk dat inode
+ */
+int nilfs_dat_read(struct inode *dat, struct nilfs_inode *raw_inode)
+{
+	return nilfs_read_inode_common(dat, raw_inode);
+}
+
+/**
  * nilfs_dat_new - create dat file
  * @nilfs: nilfs object
  * @entry_size: size of a dat entry
diff --git a/fs/nilfs2/dat.h b/fs/nilfs2/dat.h
index 98f3306..d31c3aa 100644
--- a/fs/nilfs2/dat.h
+++ b/fs/nilfs2/dat.h
@@ -53,6 +53,7 @@ int nilfs_dat_freev(struct inode *, __u64 *, size_t);
 int nilfs_dat_move(struct inode *, __u64, sector_t);
 ssize_t nilfs_dat_get_vinfo(struct inode *, void *, unsigned, size_t);
 
+int nilfs_dat_read(struct inode *dat, struct nilfs_inode *raw_inode);
 struct inode *nilfs_dat_new(struct the_nilfs *nilfs, size_t entry_size);
 
 #endif	/* _NILFS_DAT_H */
diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 6fb707a..b344f27 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -659,6 +659,16 @@ ssize_t nilfs_sufile_get_suinfo(struct inode *sufile, __u64 segnum, void *buf,
 }
 
 /**
+ * nilfs_sufile_read - read sufile inode
+ * @sufile: sufile inode
+ * @raw_inode: on-disk sufile inode
+ */
+int nilfs_sufile_read(struct inode *sufile, struct nilfs_inode *raw_inode)
+{
+	return nilfs_read_inode_common(sufile, raw_inode);
+}
+
+/**
  * nilfs_sufile_new - create sufile
  * @nilfs: nilfs object
  * @susize: size of a segment usage entry
diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
index 50d3191..b303a80 100644
--- a/fs/nilfs2/sufile.h
+++ b/fs/nilfs2/sufile.h
@@ -62,6 +62,7 @@ void nilfs_sufile_do_cancel_free(struct inode *, __u64, struct buffer_head *,
 void nilfs_sufile_do_set_error(struct inode *, __u64, struct buffer_head *,
 			       struct buffer_head *);
 
+int nilfs_sufile_read(struct inode *sufile, struct nilfs_inode *raw_inode);
 struct inode *nilfs_sufile_new(struct the_nilfs *nilfs, size_t susize);
 
 /**
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index d4a731f..bc7760c 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -204,18 +204,18 @@ static int nilfs_load_super_root(struct the_nilfs *nilfs,
 
 	nilfs_mdt_set_shadow(nilfs->ns_dat, nilfs->ns_gc_dat);
 
-	err = nilfs_mdt_read_inode_direct(
-		nilfs->ns_dat, bh_sr, NILFS_SR_DAT_OFFSET(inode_size));
+	err = nilfs_dat_read(nilfs->ns_dat, (void *)bh_sr->b_data +
+			     NILFS_SR_DAT_OFFSET(inode_size));
 	if (unlikely(err))
 		goto failed_sufile;
 
-	err = nilfs_mdt_read_inode_direct(
-		nilfs->ns_cpfile, bh_sr, NILFS_SR_CPFILE_OFFSET(inode_size));
+	err = nilfs_cpfile_read(nilfs->ns_cpfile, (void *)bh_sr->b_data +
+				NILFS_SR_CPFILE_OFFSET(inode_size));
 	if (unlikely(err))
 		goto failed_sufile;
 
-	err = nilfs_mdt_read_inode_direct(
-		nilfs->ns_sufile, bh_sr, NILFS_SR_SUFILE_OFFSET(inode_size));
+	err = nilfs_sufile_read(nilfs->ns_sufile, (void *)bh_sr->b_data +
+				NILFS_SR_SUFILE_OFFSET(inode_size));
 	if (unlikely(err))
 		goto failed_sufile;
 
-- 
1.6.3.4
