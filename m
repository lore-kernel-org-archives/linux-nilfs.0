From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCHv5 3/5] nilfs2: separate function that updates log position
Date: Mon, 28 Jun 2010 17:49:31 +0900
Message-ID: <1277714973-12136-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This moves out section that updates information of the recent log
position stored in super blocks from nilfs_commit_super to a new
routine named nilfs_set_log_cursor.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/nilfs.h |    2 ++
 fs/nilfs2/super.c |   30 +++++++++++++++++-------------
 2 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 4695417..6718616 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -270,6 +270,8 @@ extern struct nilfs_super_block *
 nilfs_read_super_block(struct super_block *, u64, int, struct buffer_head **);
 extern int nilfs_store_magic_and_option(struct super_block *,
 					struct nilfs_super_block *, char *);
+extern void nilfs_set_log_cursor(struct nilfs_super_block *,
+				 struct the_nilfs *);
 extern int nilfs_commit_super(struct nilfs_sb_info *, int);
 extern int nilfs_cleanup_super(struct nilfs_sb_info *);
 extern int nilfs_attach_checkpoint(struct nilfs_sb_info *, __u64);
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 4a85dfb..c5328c8 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -237,13 +237,27 @@ static int nilfs_sync_super(struct nilfs_sb_info *sbi, int dupsb)
 	return err;
 }
 
+void nilfs_set_log_cursor(struct nilfs_super_block *sbp,
+			  struct the_nilfs *nilfs)
+{
+	sector_t nfreeblocks;
+
+	/* nilfs->ns_sem must be locked by the caller. */
+	nilfs_count_free_blocks(nilfs, &nfreeblocks);
+	sbp->s_free_blocks_count = cpu_to_le64(nfreeblocks);
+
+	spin_lock(&nilfs->ns_last_segment_lock);
+	sbp->s_last_seq = cpu_to_le64(nilfs->ns_last_seq);
+	sbp->s_last_pseg = cpu_to_le64(nilfs->ns_last_pseg);
+	sbp->s_last_cno = cpu_to_le64(nilfs->ns_last_cno);
+	spin_unlock(&nilfs->ns_last_segment_lock);
+}
+
 int nilfs_commit_super(struct nilfs_sb_info *sbi, int dupsb)
 {
 	struct the_nilfs *nilfs = sbi->s_nilfs;
 	struct nilfs_super_block **sbp = nilfs->ns_sbp;
-	sector_t nfreeblocks;
 	time_t t;
-	int err;
 
 	/* nilfs->sem must be locked by the caller. */
 	if (sbp[0]->s_magic != cpu_to_le16(NILFS_SUPER_MAGIC)) {
@@ -255,20 +269,10 @@ int nilfs_commit_super(struct nilfs_sb_info *sbi, int dupsb)
 			return -EIO;
 		}
 	}
-	err = nilfs_count_free_blocks(nilfs, &nfreeblocks);
-	if (unlikely(err)) {
-		printk(KERN_ERR "NILFS: failed to count free blocks\n");
-		return err;
-	}
-	spin_lock(&nilfs->ns_last_segment_lock);
-	sbp[0]->s_last_seq = cpu_to_le64(nilfs->ns_last_seq);
-	sbp[0]->s_last_pseg = cpu_to_le64(nilfs->ns_last_pseg);
-	sbp[0]->s_last_cno = cpu_to_le64(nilfs->ns_last_cno);
-	spin_unlock(&nilfs->ns_last_segment_lock);
+	nilfs_set_log_cursor(sbp[0], nilfs);
 
 	t = get_seconds();
 	nilfs->ns_sbwtime[0] = t;
-	sbp[0]->s_free_blocks_count = cpu_to_le64(nfreeblocks);
 	sbp[0]->s_wtime = cpu_to_le64(t);
 	sbp[0]->s_sum = 0;
 	sbp[0]->s_sum = cpu_to_le32(crc32_le(nilfs->ns_crc_seed,
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
