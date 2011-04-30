From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH v2 1/2] nilfs2: super root size should change depending on inode size
Date: Sat, 30 Apr 2011 20:11:50 +0900
Message-ID: <1304161911-12046-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1304161911-12046-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1304161911-12046-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

The size of super root structure depends on inode size, so
NILFS_SR_BYTES macro should be a function of the inode size.  This
fixes the issue.

Even though a different size value will be written for a possible
future filesystem with extended inode, but fortunately this does not
break disk format compatibility.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/segbuf.c        |    5 ++++-
 fs/nilfs2/segment.c       |    2 +-
 include/linux/nilfs2_fs.h |    2 +-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index 410ec2b..850a7c0 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -239,12 +239,15 @@ nilfs_segbuf_fill_in_super_root_crc(struct nilfs_segment_buffer *segbuf,
 				    u32 seed)
 {
 	struct nilfs_super_root *raw_sr;
+	struct the_nilfs *nilfs = segbuf->sb_super->s_fs_info;
+	unsigned srsize;
 	u32 crc;
 
 	raw_sr = (struct nilfs_super_root *)segbuf->sb_super_root->b_data;
+	srsize = NILFS_SR_BYTES(nilfs->ns_inode_size);
 	crc = crc32_le(seed,
 		       (unsigned char *)raw_sr + sizeof(raw_sr->sr_sum),
-		       NILFS_SR_BYTES - sizeof(raw_sr->sr_sum));
+		       srsize - sizeof(raw_sr->sr_sum));
 	raw_sr->sr_sum = cpu_to_le32(crc);
 }
 
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index abbfab9..8006d0c 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -894,7 +894,7 @@ static void nilfs_segctor_fill_in_super_root(struct nilfs_sc_info *sci,
 	bh_sr = NILFS_LAST_SEGBUF(&sci->sc_segbufs)->sb_super_root;
 	raw_sr = (struct nilfs_super_root *)bh_sr->b_data;
 
-	raw_sr->sr_bytes = cpu_to_le16(NILFS_SR_BYTES);
+	raw_sr->sr_bytes = cpu_to_le16(NILFS_SR_BYTES(isz));
 	raw_sr->sr_nongc_ctime
 		= cpu_to_le64(nilfs_doing_gc() ?
 			      nilfs->ns_nongc_ctime : sci->sc_seg_ctime);
diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index 8768c46..bd8678f 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -107,7 +107,7 @@ struct nilfs_super_root {
 #define NILFS_SR_DAT_OFFSET(inode_size)     NILFS_SR_MDT_OFFSET(inode_size, 0)
 #define NILFS_SR_CPFILE_OFFSET(inode_size)  NILFS_SR_MDT_OFFSET(inode_size, 1)
 #define NILFS_SR_SUFILE_OFFSET(inode_size)  NILFS_SR_MDT_OFFSET(inode_size, 2)
-#define NILFS_SR_BYTES                  (sizeof(struct nilfs_super_root))
+#define NILFS_SR_BYTES(inode_size)	    NILFS_SR_MDT_OFFSET(inode_size, 3)
 
 /*
  * Maximal mount counts
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
