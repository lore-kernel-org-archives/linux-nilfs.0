From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: fix potential hang in nilfs_error on errors=remount-ro
Date: Mon,  1 Feb 2010 01:50:24 +0900
Message-ID: <1264956624-12470-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

nilfs_error() calls nilfs_detach_segment_constructor() if
errors=remount-ro option is specified, and this may lead to a hang due
to recursive locking of, for instance, nilfs->ns_segctor_sem and
others.

In this case, detaching segment constructor is not necessary because
read-only flag is set to the filesystem and further writes are
blocked.

This fixes the potential hang issue by removing the
nilfs_detach_segment_constructor() call from nilfs_error.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/segment.c |   11 +++++++++--
 fs/nilfs2/super.c   |    3 ---
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 9280b0f..ab439a7 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2875,8 +2875,15 @@ int nilfs_attach_segment_constructor(struct nilfs_sb_info *sbi)
 	struct the_nilfs *nilfs = sbi->s_nilfs;
 	int err;
 
-	/* Each field of nilfs_segctor is cleared through the initialization
-	   of super-block info */
+	if (NILFS_SC(sbi)) {
+		/*
+		 * This happens if the filesystem was remounted
+		 * read/write after nilfs_error degenerated it into a
+		 * read-only mount.
+		 */
+		nilfs_detach_segment_constructor(sbi);
+	}
+
 	sbi->s_sc_info = nilfs_segctor_new(sbi);
 	if (!sbi->s_sc_info)
 		return -ENOMEM;
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 3f88401..f068270 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -96,9 +96,6 @@ void nilfs_error(struct super_block *sb, const char *function,
 	if (!(sb->s_flags & MS_RDONLY)) {
 		struct the_nilfs *nilfs = sbi->s_nilfs;
 
-		if (!nilfs_test_opt(sbi, ERRORS_CONT))
-			nilfs_detach_segment_constructor(sbi);
-
 		down_write(&nilfs->ns_sem);
 		if (!(nilfs->ns_mount_state & NILFS_ERROR_FS)) {
 			nilfs->ns_mount_state |= NILFS_ERROR_FS;
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
