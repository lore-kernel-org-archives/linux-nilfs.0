From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH v2 2/2] nilfs2: zero fill unused portion of super root block
Date: Sat, 30 Apr 2011 20:11:51 +0900
Message-ID: <1304161911-12046-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

The super root block is newly-allocated each time it is written back
to disk, so unused portion of the block should be cleared.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/inode.c   |   10 ++++++++++
 fs/nilfs2/segment.c |    7 +++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 2cc8c08..699170e 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -596,6 +596,16 @@ void nilfs_write_inode_common(struct inode *inode,
 	raw_inode->i_flags = cpu_to_le32(ii->i_flags);
 	raw_inode->i_generation = cpu_to_le32(inode->i_generation);
 
+	if (NILFS_ROOT_METADATA_FILE(inode->i_ino)) {
+		struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
+
+		/* zero-fill unused portion in the case of super root block */
+		raw_inode->i_xattr = 0;
+		raw_inode->i_pad = 0;
+		memset((void *)raw_inode + sizeof(*raw_inode), 0,
+		       nilfs->ns_inode_size - sizeof(*raw_inode));
+	}
+
 	if (has_bmap)
 		nilfs_bmap_write(ii->i_bmap, raw_inode);
 	else if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode))
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 8006d0c..8a2b428 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -889,12 +889,14 @@ static void nilfs_segctor_fill_in_super_root(struct nilfs_sc_info *sci,
 {
 	struct buffer_head *bh_sr;
 	struct nilfs_super_root *raw_sr;
-	unsigned isz = nilfs->ns_inode_size;
+	unsigned isz, srsz;
 
 	bh_sr = NILFS_LAST_SEGBUF(&sci->sc_segbufs)->sb_super_root;
 	raw_sr = (struct nilfs_super_root *)bh_sr->b_data;
+	isz = nilfs->ns_inode_size;
+	srsz = NILFS_SR_BYTES(isz);
 
-	raw_sr->sr_bytes = cpu_to_le16(NILFS_SR_BYTES(isz));
+	raw_sr->sr_bytes = cpu_to_le16(srsz);
 	raw_sr->sr_nongc_ctime
 		= cpu_to_le64(nilfs_doing_gc() ?
 			      nilfs->ns_nongc_ctime : sci->sc_seg_ctime);
@@ -906,6 +908,7 @@ static void nilfs_segctor_fill_in_super_root(struct nilfs_sc_info *sci,
 				 NILFS_SR_CPFILE_OFFSET(isz), 1);
 	nilfs_write_inode_common(nilfs->ns_sufile, (void *)raw_sr +
 				 NILFS_SR_SUFILE_OFFSET(isz), 1);
+	memset((void *)raw_sr + srsz, 0, nilfs->ns_blocksize - srsz);
 }
 
 static void nilfs_redirty_inodes(struct list_head *head)
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
