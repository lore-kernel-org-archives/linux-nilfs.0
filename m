From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCHv5 1/5] nilfs2: add nilfs_cleanup_super
Date: Mon, 28 Jun 2010 17:49:29 +0900
Message-ID: <1277714973-12136-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1277714973-12136-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1277714973-12136-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

This function write out filesystem state to super blocks in order to
share the same cleanup work.  This is a preparation for making super
block writeback alternately.

Cc: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/nilfs.h     |    1 +
 fs/nilfs2/super.c     |   28 ++++++++++++++++++++--------
 fs/nilfs2/the_nilfs.c |    5 ++---
 3 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 47d6d79..4695417 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -271,6 +271,7 @@ nilfs_read_super_block(struct super_block *, u64, int, struct buffer_head **);
 extern int nilfs_store_magic_and_option(struct super_block *,
 					struct nilfs_super_block *, char *);
 extern int nilfs_commit_super(struct nilfs_sb_info *, int);
+extern int nilfs_cleanup_super(struct nilfs_sb_info *);
 extern int nilfs_attach_checkpoint(struct nilfs_sb_info *, __u64);
 extern void nilfs_detach_checkpoint(struct nilfs_sb_info *);
 
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 39b28cf..f23a31b 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -278,6 +278,24 @@ int nilfs_commit_super(struct nilfs_sb_info *sbi, int dupsb)
 	return nilfs_sync_super(sbi, dupsb);
 }
 
+/**
+ * nilfs_cleanup_super() - write filesystem state for cleanup
+ * @sbi: nilfs_sb_info to be unmounted or degraded to read-only
+ *
+ * This function restores state flags in the on-disk super block.
+ * This will set "clean" flag (i.e. NILFS_VALID_FS) unless the
+ * filesystem was not clean previously.
+ */
+int nilfs_cleanup_super(struct nilfs_sb_info *sbi)
+{
+	struct nilfs_super_block **sbp = sbi->s_nilfs->ns_sbp;
+	int ret;
+
+	sbp[0]->s_state = cpu_to_le16(sbi->s_nilfs->ns_mount_state);
+	ret = nilfs_commit_super(sbi, 1);
+	return ret;
+}
+
 static void nilfs_put_super(struct super_block *sb)
 {
 	struct nilfs_sb_info *sbi = NILFS_SB(sb);
@@ -289,8 +307,7 @@ static void nilfs_put_super(struct super_block *sb)
 
 	if (!(sb->s_flags & MS_RDONLY)) {
 		down_write(&nilfs->ns_sem);
-		nilfs->ns_sbp[0]->s_state = cpu_to_le16(nilfs->ns_mount_state);
-		nilfs_commit_super(sbi, 1);
+		nilfs_cleanup_super(sbi);
 		up_write(&nilfs->ns_sem);
 	}
 	down_write(&nilfs->ns_super_sem);
@@ -819,7 +836,6 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
 static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 {
 	struct nilfs_sb_info *sbi = NILFS_SB(sb);
-	struct nilfs_super_block *sbp;
 	struct the_nilfs *nilfs = sbi->s_nilfs;
 	unsigned long old_sb_flags;
 	struct nilfs_mount_options old_opts;
@@ -880,11 +896,7 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 		 * the RDONLY flag and then mark the partition as valid again.
 		 */
 		down_write(&nilfs->ns_sem);
-		sbp = nilfs->ns_sbp[0];
-		if (!(sbp->s_state & le16_to_cpu(NILFS_VALID_FS)) &&
-		    (nilfs->ns_mount_state & NILFS_VALID_FS))
-			sbp->s_state = cpu_to_le16(nilfs->ns_mount_state);
-		nilfs_commit_super(sbi, 1);
+		nilfs_cleanup_super(sbi);
 		up_write(&nilfs->ns_sem);
 	} else {
 		/*
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 4a9e8a0..ed58053 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -324,9 +324,8 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 		goto failed_unload;
 
 	down_write(&nilfs->ns_sem);
-	nilfs->ns_mount_state |= NILFS_VALID_FS;
-	nilfs->ns_sbp[0]->s_state = cpu_to_le16(nilfs->ns_mount_state);
-	err = nilfs_commit_super(sbi, 1);
+	nilfs->ns_mount_state |= NILFS_VALID_FS; /* set "clean" flag */
+	err = nilfs_cleanup_super(sbi);
 	up_write(&nilfs->ns_sem);
 
 	if (err) {
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
