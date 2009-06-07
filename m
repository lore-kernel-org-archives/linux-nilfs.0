From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 4/6] nilfs2: simplify remaining sget() use
Date: Mon,  8 Jun 2009 01:39:31 +0900
Message-ID: <1244392773-14230-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1244392773-14230-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1244392773-14230-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, users@nilfs.org

This simplifies the test function passed on the remaining sget()
callsite in nilfs.

Instead of checking mount type (i.e. ro-mount/rw-mount/snapshot mount)
in the test function passed to sget(), this patch first looks up the
nilfs_sb_info struct which the given mount type matches, and then
acquires the super block instance holding the nilfs_sb_info.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/nilfs2/sb.h        |    1 +
 fs/nilfs2/super.c     |   42 ++++++++++++++++------------------------
 fs/nilfs2/the_nilfs.c |   50 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/the_nilfs.h |    7 ++++++
 4 files changed, 75 insertions(+), 25 deletions(-)

diff --git a/fs/nilfs2/sb.h b/fs/nilfs2/sb.h
index adccd4f..0776ccc 100644
--- a/fs/nilfs2/sb.h
+++ b/fs/nilfs2/sb.h
@@ -60,6 +60,7 @@ struct nilfs_sb_info {
 	struct super_block *s_super;	/* reverse pointer to super_block */
 	struct the_nilfs *s_nilfs;
 	struct list_head s_list;	/* list head for nilfs->ns_supers */
+	atomic_t s_count;		/* reference count */
 
 	/* Segment constructor */
 	struct list_head s_dirty_files;	/* dirty files list */
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 0a62901..7370bc5 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -330,7 +330,7 @@ static void nilfs_put_super(struct super_block *sb)
 	put_nilfs(sbi->s_nilfs);
 	sbi->s_super = NULL;
 	sb->s_fs_info = NULL;
-	kfree(sbi);
+	nilfs_put_sbinfo(sbi);
 }
 
 /**
@@ -775,6 +775,7 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
 	get_nilfs(nilfs);
 	sbi->s_nilfs = nilfs;
 	sbi->s_super = sb;
+	atomic_set(&sbi->s_count, 1);
 
 	err = init_nilfs(nilfs, sbi, (char *)data);
 	if (err)
@@ -892,7 +893,7 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
  failed_sbi:
 	put_nilfs(nilfs);
 	sb->s_fs_info = NULL;
-	kfree(sbi);
+	nilfs_put_sbinfo(sbi);
 	return err;
 }
 
@@ -1000,6 +1001,7 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 
 struct nilfs_super_data {
 	struct block_device *bdev;
+	struct nilfs_sb_info *sbi;
 	__u64 cno;
 	int flags;
 };
@@ -1057,27 +1059,8 @@ static int nilfs_set_bdev_super(struct super_block *s, void *data)
 static int nilfs_test_bdev_super(struct super_block *s, void *data)
 {
 	struct nilfs_super_data *sd = data;
-	int ret;
-
-	if (s->s_bdev != sd->bdev)
-		return 0;
-
-	if (!((s->s_flags | sd->flags) & MS_RDONLY))
-		return 1; /* Reuse an old R/W-mode super_block */
-
-	if (s->s_flags & sd->flags & MS_RDONLY) {
-		if (down_read_trylock(&s->s_umount)) {
-			ret = s->s_root &&
-				(sd->cno == NILFS_SB(s)->s_snapshot_cno);
-			up_read(&s->s_umount);
-			/*
-			 * This path is locked with sb_lock by sget().
-			 * So, drop_super() causes deadlock.
-			 */
-			return ret;
-		}
-	}
-	return 0;
+
+	return sd->sbi && s->s_fs_info == (void *)sd->sbi;
 }
 
 static int
@@ -1098,7 +1081,6 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 	 * much more information than normal filesystems to identify mount
 	 * instance.  For snapshot mounts, not only a mount type (ro-mount
 	 * or rw-mount) but also a checkpoint number is required.
-	 * The results are passed in sget() using nilfs_super_data.
 	 */
 	sd.cno = 0;
 	sd.flags = flags;
@@ -1134,13 +1116,23 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 	}
 
 	/*
-	 * Search specified snapshot or R/W mode super_block
+	 * Find existing nilfs_sb_info struct
 	 */
+	sd.sbi = nilfs_find_sbinfo(nilfs, !(flags & MS_RDONLY), sd.cno);
+
 	if (!sd.cno)
 		/* trying to get the latest checkpoint.  */
 		sd.cno = nilfs_last_cno(nilfs);
 
+	/*
+	 * Get super block instance holding the nilfs_sb_info struct.
+	 * A new instance is allocated if no existing mount is present or
+	 * existing instance has been unmounted.
+	 */
 	s = sget(fs_type, nilfs_test_bdev_super, nilfs_set_bdev_super, &sd);
+	if (sd.sbi)
+		nilfs_put_sbinfo(sd.sbi);
+
 	if (IS_ERR(s)) {
 		err = PTR_ERR(s);
 		goto failed_unlock;
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 92ff3b1..ff8600e 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -664,6 +664,56 @@ int nilfs_near_disk_full(struct the_nilfs *nilfs)
 	return ret;
 }
 
+/**
+ * nilfs_find_sbinfo - find existing nilfs_sb_info structure
+ * @nilfs: nilfs object
+ * @rw_mount: mount type (non-zero value for read/write mount)
+ * @cno: checkpoint number (zero for read-only mount)
+ *
+ * nilfs_find_sbinfo() returns the nilfs_sb_info structure which
+ * @rw_mount and @cno (in case of snapshots) matched.  If no instance
+ * was found, NULL is returned.  Although the super block instance can
+ * be unmounted after this function returns, the nilfs_sb_info struct
+ * is kept on memory until nilfs_put_sbinfo() is called.
+ */
+struct nilfs_sb_info *nilfs_find_sbinfo(struct the_nilfs *nilfs,
+					int rw_mount, __u64 cno)
+{
+	struct nilfs_sb_info *sbi;
+
+	down_read(&nilfs->ns_sem);
+	/*
+	 * The SNAPSHOT flag and sb->s_flags are supposed to be
+	 * protected with nilfs->ns_sem.
+	 */
+	sbi = nilfs->ns_current;
+	if (rw_mount) {
+		if (sbi && !(sbi->s_super->s_flags & MS_RDONLY))
+			goto found; /* read/write mount */
+		else
+			goto out;
+	} else if (cno == 0) {
+		if (sbi && (sbi->s_super->s_flags & MS_RDONLY))
+			goto found; /* read-only mount */
+		else
+			goto out;
+	}
+
+	list_for_each_entry(sbi, &nilfs->ns_supers, s_list) {
+		if (nilfs_test_opt(sbi, SNAPSHOT) &&
+		    sbi->s_snapshot_cno == cno)
+			goto found; /* snapshot mount */
+	}
+ out:
+	up_read(&nilfs->ns_sem);
+	return NULL;
+
+ found:
+	atomic_inc(&sbi->s_count);
+	up_read(&nilfs->ns_sem);
+	return sbi;
+}
+
 int nilfs_checkpoint_is_mounted(struct the_nilfs *nilfs, __u64 cno,
 				int snapshot_mount)
 {
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 99f7e29..be4c040 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -201,6 +201,7 @@ void put_nilfs(struct the_nilfs *);
 int init_nilfs(struct the_nilfs *, struct nilfs_sb_info *, char *);
 int load_nilfs(struct the_nilfs *, struct nilfs_sb_info *);
 int nilfs_count_free_blocks(struct the_nilfs *, sector_t *);
+struct nilfs_sb_info *nilfs_find_sbinfo(struct the_nilfs *, int, __u64);
 int nilfs_checkpoint_is_mounted(struct the_nilfs *, __u64, int);
 int nilfs_near_disk_full(struct the_nilfs *);
 void nilfs_fall_back_super_block(struct the_nilfs *);
@@ -243,6 +244,12 @@ nilfs_detach_writer(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 	mutex_unlock(&nilfs->ns_writer_mutex);
 }
 
+static inline void nilfs_put_sbinfo(struct nilfs_sb_info *sbi)
+{
+	if (!atomic_dec_and_test(&sbi->s_count))
+		kfree(sbi);
+}
+
 static inline void
 nilfs_get_segment_range(struct the_nilfs *nilfs, __u64 segnum,
 			sector_t *seg_start, sector_t *seg_end)
-- 
1.6.2

