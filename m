From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCHv2 3/3] nilfs2: reject incompatible filesystem
Date: Thu, 22 Jul 2010 03:22:20 +0900
Message-ID: <1279736540-21556-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1279736540-21556-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1279736540-21556-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

This forces nilfs to check compatibility of feature flags so as to
reject a filesystem with unknown features when it mounts or remounts
the filesystem.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/nilfs.h     |    2 ++
 fs/nilfs2/super.c     |   39 +++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/the_nilfs.c |   20 ++++++++++++++++++++
 3 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index cfedc48..0842d77 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -275,6 +275,8 @@ extern struct nilfs_super_block *
 nilfs_read_super_block(struct super_block *, u64, int, struct buffer_head **);
 extern int nilfs_store_magic_and_option(struct super_block *,
 					struct nilfs_super_block *, char *);
+extern int nilfs_check_feature_compatibility(struct super_block *,
+					     struct nilfs_super_block *);
 extern void nilfs_set_log_cursor(struct nilfs_super_block *,
 				 struct the_nilfs *);
 extern struct nilfs_super_block **nilfs_prepare_super(struct nilfs_sb_info *,
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 1644573..26078b3 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -790,6 +790,30 @@ int nilfs_store_magic_and_option(struct super_block *sb,
 	return !parse_options(data, sb, 0) ? -EINVAL : 0 ;
 }
 
+int nilfs_check_feature_compatibility(struct super_block *sb,
+				      struct nilfs_super_block *sbp)
+{
+	__u64 features;
+
+	features = le64_to_cpu(sbp->s_feature_incompat) &
+		~NILFS_FEATURE_INCOMPAT_SUPP;
+	if (features) {
+		printk(KERN_ERR "NILFS: couldn't mount because of unsupported "
+		       "optional features (%llx)\n",
+		       (unsigned long long)features);
+		return -EINVAL;
+	}
+	features = le64_to_cpu(sbp->s_feature_compat_ro) &
+		~NILFS_FEATURE_COMPAT_RO_SUPP;
+	if (!(sb->s_flags & MS_RDONLY) && features) {
+		printk(KERN_ERR "NILFS: couldn't mount RDWR because of "
+		       "unsupported optional features (%llx)\n",
+		       (unsigned long long)features);
+		return -EINVAL;
+	}
+	return 0;
+}
+
 /**
  * nilfs_fill_super() - initialize a super block instance
  * @sb: super_block
@@ -984,11 +1008,26 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 		nilfs_cleanup_super(sbi);
 		up_write(&nilfs->ns_sem);
 	} else {
+		__u64 features;
+
 		/*
 		 * Mounting a RDONLY partition read-write, so reread and
 		 * store the current valid flag.  (It may have been changed
 		 * by fsck since we originally mounted the partition.)
 		 */
+		down_read(&nilfs->ns_sem);
+		features = le64_to_cpu(nilfs->ns_sbp[0]->s_feature_compat_ro) &
+			~NILFS_FEATURE_COMPAT_RO_SUPP;
+		up_read(&nilfs->ns_sem);
+		if (features) {
+			printk(KERN_WARNING "NILFS (device %s): couldn't "
+			       "remount RDWR because of unsupported optional "
+			       "features (%llx)\n",
+			       sb->s_id, (unsigned long long)features);
+			err = -EROFS;
+			goto restore_opts;
+		}
+
 		sb->s_flags &= ~MS_RDONLY;
 
 		err = nilfs_attach_segment_constructor(sbi);
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index f2efc8c..da67b56 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -385,11 +385,23 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 		goto skip_recovery;
 
 	if (s_flags & MS_RDONLY) {
+		__u64 features;
+
 		if (nilfs_test_opt(sbi, NORECOVERY)) {
 			printk(KERN_INFO "NILFS: norecovery option specified. "
 			       "skipping roll-forward recovery\n");
 			goto skip_recovery;
 		}
+		features = le64_to_cpu(nilfs->ns_sbp[0]->s_feature_compat_ro) &
+			~NILFS_FEATURE_COMPAT_RO_SUPP;
+		if (features) {
+			printk(KERN_ERR "NILFS: couldn't proceed with "
+			       "recovery because of unsupported optional "
+			       "features (%llx)\n",
+			       (unsigned long long)features);
+			err = -EROFS;
+			goto failed_unload;
+		}
 		if (really_read_only) {
 			printk(KERN_ERR "NILFS: write access "
 			       "unavailable, cannot proceed.\n");
@@ -644,6 +656,10 @@ int init_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi, char *data)
 		if (err)
 			goto out;
 
+		err = nilfs_check_feature_compatibility(sb, sbp);
+		if (err)
+			goto out;
+
 		blocksize = BLOCK_SIZE << le32_to_cpu(sbp->s_log_block_size);
 		if (sb->s_blocksize != blocksize &&
 		    !sb_set_blocksize(sb, blocksize)) {
@@ -669,6 +685,10 @@ int init_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi, char *data)
 	if (err)
 		goto failed_sbh;
 
+	err = nilfs_check_feature_compatibility(sb, sbp);
+	if (err)
+		goto failed_sbh;
+
 	blocksize = BLOCK_SIZE << le32_to_cpu(sbp->s_log_block_size);
 	if (sb->s_blocksize != blocksize) {
 		int hw_blocksize = bdev_logical_block_size(sb->s_bdev);
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
