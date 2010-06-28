From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCHv2 1/3] nilfs2: separate setup of log cursor from init_nilfs
Date: Mon, 28 Jun 2010 19:15:24 +0900
Message-ID: <1277720126-13463-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1277720126-13463-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1277720126-13463-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

This separates a setup routine of log cursor from init_nilfs().  The
routine, nilfs_store_log_cursor, reads the last position of the log
containing a super root, and initializes relevant state on the nilfs
object.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/the_nilfs.c |   45 ++++++++++++++++++++++++++++++++-------------
 1 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 530d277..0d2a46c 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -247,6 +247,36 @@ static void nilfs_clear_recovery_info(struct nilfs_recovery_info *ri)
 }
 
 /**
+ * nilfs_store_log_cursor - load log cursor from a super block
+ * @nilfs: nilfs object
+ * @sbp: buffer storing super block to be read
+ *
+ * nilfs_store_log_cursor() reads the last position of the log
+ * containing a super root from a given super block, and initializes
+ * relevant information on the nilfs object preparatory for log
+ * scanning and recovery.
+ */
+static int nilfs_store_log_cursor(struct the_nilfs *nilfs,
+				  struct nilfs_super_block *sbp)
+{
+	int ret = 0;
+
+	nilfs->ns_last_pseg = le64_to_cpu(sbp->s_last_pseg);
+	nilfs->ns_last_cno = le64_to_cpu(sbp->s_last_cno);
+	nilfs->ns_last_seq = le64_to_cpu(sbp->s_last_seq);
+
+	nilfs->ns_seg_seq = nilfs->ns_last_seq;
+	nilfs->ns_segnum =
+		nilfs_get_segnum_of_block(nilfs, nilfs->ns_last_pseg);
+	nilfs->ns_cno = nilfs->ns_last_cno + 1;
+	if (nilfs->ns_segnum >= nilfs->ns_nsegments) {
+		printk(KERN_ERR "NILFS invalid last segment number.\n");
+		ret = -EINVAL;
+	}
+	return ret;
+}
+
+/**
  * load_nilfs - load and recover the nilfs
  * @nilfs: the_nilfs structure to be released
  * @sbi: nilfs_sb_info used to recover past segment
@@ -615,20 +645,9 @@ int init_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi, char *data)
 	bdi = nilfs->ns_bdev->bd_inode->i_mapping->backing_dev_info;
 	nilfs->ns_bdi = bdi ? : &default_backing_dev_info;
 
-	/* Finding last segment */
-	nilfs->ns_last_pseg = le64_to_cpu(sbp->s_last_pseg);
-	nilfs->ns_last_cno = le64_to_cpu(sbp->s_last_cno);
-	nilfs->ns_last_seq = le64_to_cpu(sbp->s_last_seq);
-
-	nilfs->ns_seg_seq = nilfs->ns_last_seq;
-	nilfs->ns_segnum =
-		nilfs_get_segnum_of_block(nilfs, nilfs->ns_last_pseg);
-	nilfs->ns_cno = nilfs->ns_last_cno + 1;
-	if (nilfs->ns_segnum >= nilfs->ns_nsegments) {
-		printk(KERN_ERR "NILFS invalid last segment number.\n");
-		err = -EINVAL;
+	err = nilfs_store_log_cursor(nilfs, sbp);
+	if (err)
 		goto failed_sbh;
-	}
 
 	/* Initialize gcinode cache */
 	err = nilfs_init_gccache(nilfs);
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
