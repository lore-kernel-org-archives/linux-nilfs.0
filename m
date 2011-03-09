From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/8] nilfs2: move parameters on nilfs_sb_info into nilfs object
Date: Wed,  9 Mar 2011 21:08:07 +0900
Message-ID: <1299672493-28544-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1299672493-28544-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1299672493-28544-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This moves four parameter variables on nilfs_sb_info s_resuid,
s_resgid, s_interval and s_watermark to the nilfs object.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/sb.h        |    7 -------
 fs/nilfs2/segment.c   |    9 +++++----
 fs/nilfs2/super.c     |   10 +++++-----
 fs/nilfs2/the_nilfs.h |    9 +++++++++
 4 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/fs/nilfs2/sb.h b/fs/nilfs2/sb.h
index d7346c9..0512521 100644
--- a/fs/nilfs2/sb.h
+++ b/fs/nilfs2/sb.h
@@ -34,13 +34,6 @@ struct nilfs_sc_info;
  * NILFS super-block data in memory
  */
 struct nilfs_sb_info {
-	uid_t s_resuid;
-	gid_t s_resgid;
-
-	unsigned long s_interval;	/* construction interval */
-	unsigned long s_watermark;	/* threshold of data amount
-					   for the segment construction */
-
 	/* Fundamental members */
 	struct super_block *s_super;	/* reverse pointer to super_block */
 	struct the_nilfs *s_nilfs;
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 851bcd3..a32d9cb 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2676,6 +2676,7 @@ static void nilfs_segctor_kill_thread(struct nilfs_sc_info *sci)
 static struct nilfs_sc_info *nilfs_segctor_new(struct nilfs_sb_info *sbi,
 					       struct nilfs_root *root)
 {
+	struct the_nilfs *nilfs = sbi->s_nilfs;
 	struct nilfs_sc_info *sci;
 
 	sci = kzalloc(sizeof(*sci), GFP_KERNEL);
@@ -2703,10 +2704,10 @@ static struct nilfs_sc_info *nilfs_segctor_new(struct nilfs_sb_info *sbi,
 	sci->sc_mjcp_freq = HZ * NILFS_SC_DEFAULT_SR_FREQ;
 	sci->sc_watermark = NILFS_SC_DEFAULT_WATERMARK;
 
-	if (sbi->s_interval)
-		sci->sc_interval = sbi->s_interval;
-	if (sbi->s_watermark)
-		sci->sc_watermark = sbi->s_watermark;
+	if (nilfs->ns_interval)
+		sci->sc_interval = nilfs->ns_interval;
+	if (nilfs->ns_watermark)
+		sci->sc_watermark = nilfs->ns_watermark;
 	return sci;
 }
 
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 0576cb2..2f17a2f 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -729,7 +729,7 @@ int nilfs_store_magic_and_option(struct super_block *sb,
 				 struct nilfs_super_block *sbp,
 				 char *data)
 {
-	struct nilfs_sb_info *sbi = NILFS_SB(sb);
+	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
 
 	sb->s_magic = le16_to_cpu(sbp->s_magic);
 
@@ -740,10 +740,10 @@ int nilfs_store_magic_and_option(struct super_block *sb,
 
 	nilfs_set_default_options(sb, sbp);
 
-	sbi->s_resuid = le16_to_cpu(sbp->s_def_resuid);
-	sbi->s_resgid = le16_to_cpu(sbp->s_def_resgid);
-	sbi->s_interval = le32_to_cpu(sbp->s_c_interval);
-	sbi->s_watermark = le32_to_cpu(sbp->s_c_block_max);
+	nilfs->ns_resuid = le16_to_cpu(sbp->s_def_resuid);
+	nilfs->ns_resgid = le16_to_cpu(sbp->s_def_resgid);
+	nilfs->ns_interval = le32_to_cpu(sbp->s_c_interval);
+	nilfs->ns_watermark = le32_to_cpu(sbp->s_c_block_max);
 
 	return !parse_options(data, sb, 0) ? -EINVAL : 0 ;
 }
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 4382780..4a9bf39 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -73,6 +73,10 @@ enum {
  * @ns_cptree_lock: lock protecting @ns_cptree
  * @ns_gc_inodes: dummy inodes to keep live blocks
  * @ns_mount_opt: mount options
+ * @ns_resuid: uid for reserved blocks
+ * @ns_resgid: gid for reserved blocks
+ * @ns_interval: checkpoint creation interval
+ * @ns_watermark: watermark for the number of dirty buffers
  * @ns_blocksize_bits: bit length of block size
  * @ns_blocksize: block size
  * @ns_nsegments: number of segments in filesystem
@@ -152,6 +156,11 @@ struct the_nilfs {
 	/* Mount options */
 	unsigned long		ns_mount_opt;
 
+	uid_t			ns_resuid;
+	gid_t			ns_resgid;
+	unsigned long		ns_interval;
+	unsigned long		ns_watermark;
+
 	/* Disk layout information (static) */
 	unsigned int		ns_blocksize_bits;
 	unsigned int		ns_blocksize;
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
