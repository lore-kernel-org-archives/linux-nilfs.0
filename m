From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 3/9] nilfs2: add helper functions to get type of blocks on ifile
Date: Mon, 16 May 2011 18:05:16 +0900
Message-ID: <1305536722-1311-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1305536722-1311-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1305536722-1311-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This adds a helper function which classifies meta-data blocks managed
under persistent object allocator of nilfs.

The persistent object allocator uses three types of blocks, a
descriptor block, a bitmap block, and an entry block, on a single
meta-data file.  The helper function calculates this type from a given
block offset of the metadata file.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/alloc.c |   35 +++++++++++++++++++++++++++++++++--
 fs/nilfs2/alloc.h |   10 ++++++++++
 2 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/alloc.c b/fs/nilfs2/alloc.c
index eed4d7b..b2d17f7 100644
--- a/fs/nilfs2/alloc.c
+++ b/fs/nilfs2/alloc.c
@@ -172,8 +172,7 @@ nilfs_palloc_group_desc_add_entries(struct inode *inode,
  * @inode: inode of metadata file using this allocator
  * @nr: serial number of the entry (e.g. inode number)
  */
-static unsigned long
-nilfs_palloc_entry_blkoff(const struct inode *inode, __u64 nr)
+unsigned long nilfs_palloc_entry_blkoff(const struct inode *inode, __u64 nr)
 {
 	unsigned long group, group_offset;
 
@@ -331,6 +330,38 @@ void *nilfs_palloc_block_get_entry(const struct inode *inode, __u64 nr,
 }
 
 /**
+ * nilfs_palloc_block_type - classify type of a block
+ * @inode: inode of metadata file using this allocator
+ * @blkoff: offset of the block to be classified (in block)
+ * @entrynr: first entry number in the block [out]
+ */
+int nilfs_palloc_block_type(const struct inode *inode, __u64 blkoff,
+			    __u64 *entrynr)
+{
+	struct nilfs_mdt_info *mi = NILFS_MDT(inode);
+	__u64 ngroups1 = blkoff;
+	unsigned long offset1, offset2, ngroups2;
+	int ret;
+
+	offset1 = do_div(ngroups1, mi->mi_blocks_per_desc_block);
+	if (offset1 == 0) {
+		ret = NILFS_PALLOC_DESC_BLOCK;
+	} else {
+		ngroups2 = (offset1 - 1) / mi->mi_blocks_per_group;
+		offset2 = (offset1 - 1) % mi->mi_blocks_per_group;
+		if (offset2 == 0) {
+			ret = NILFS_PALLOC_BITMAP_BLOCK;
+		} else {
+			ret = NILFS_PALLOC_ENTRY_BLOCK;
+			*entrynr = (ngroups1 + ngroups2) *
+				nilfs_palloc_entries_per_group(inode) +
+				mi->mi_entries_per_block * (offset2 - 1);
+		}
+	}
+	return ret;
+}
+
+/**
  * nilfs_palloc_find_available_slot - find available slot in a group
  * @inode: inode of metadata file using this allocator
  * @group: group number
diff --git a/fs/nilfs2/alloc.h b/fs/nilfs2/alloc.h
index f5fde36..bcd5749 100644
--- a/fs/nilfs2/alloc.h
+++ b/fs/nilfs2/alloc.h
@@ -43,10 +43,20 @@ nilfs_palloc_entries_per_group(const struct inode *inode)
 }
 
 int nilfs_palloc_init_blockgroup(struct inode *, unsigned);
+unsigned long nilfs_palloc_entry_blkoff(const struct inode *inode, __u64 nr);
 int nilfs_palloc_get_entry_block(struct inode *, __u64, int,
 				 struct buffer_head **);
 void *nilfs_palloc_block_get_entry(const struct inode *, __u64,
 				   const struct buffer_head *, void *);
+int nilfs_palloc_block_type(const struct inode *inode, __u64 blkoff,
+			    __u64 *entrynr);
+
+/* block types */
+enum {
+	NILFS_PALLOC_DESC_BLOCK,	/* descriptor block */
+	NILFS_PALLOC_BITMAP_BLOCK,	/* bitmap block */
+	NILFS_PALLOC_ENTRY_BLOCK,	/* entry block */
+};
 
 /**
  * nilfs_palloc_req - persistent allocator request and reply
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
