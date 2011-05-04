From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/4] nilfs2: add routine to move secondary super block
Date: Thu,  5 May 2011 03:18:53 +0900
Message-ID: <1304533135-25398-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1304533135-25398-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1304533135-25398-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

After resizing the filesystem, the secondary super block must be moved
to a new location.  This adds a helper function for this.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/super.c |   57 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 57 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 062cca0..eba5b53 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -347,6 +347,63 @@ int nilfs_cleanup_super(struct super_block *sb)
 	return ret;
 }
 
+/**
+ * nilfs_move_2nd_super - relocate secondary super block
+ * @sb: super block instance
+ * @sb2off: new offset of the secondary super block (in bytes)
+ */
+static int nilfs_move_2nd_super(struct super_block *sb, loff_t sb2off)
+{
+	struct the_nilfs *nilfs = sb->s_fs_info;
+	struct buffer_head *nsbh;
+	struct nilfs_super_block *nsbp;
+	sector_t blocknr, newblocknr;
+	unsigned long offset;
+	int sb2i = -1;  /* array index of the secondary superblock */
+	int ret = 0;
+
+	/* nilfs->ns_sem must be locked by the caller. */
+	if (nilfs->ns_sbh[1] &&
+	    nilfs->ns_sbh[1]->b_blocknr > nilfs->ns_first_data_block) {
+		sb2i = 1;
+		blocknr = nilfs->ns_sbh[1]->b_blocknr;
+	} else if (nilfs->ns_sbh[0]->b_blocknr > nilfs->ns_first_data_block) {
+		sb2i = 0;
+		blocknr = nilfs->ns_sbh[0]->b_blocknr;
+	}
+	if (sb2i >= 0 && (u64)blocknr << nilfs->ns_blocksize_bits == sb2off)
+		goto out;  /* super block location is unchanged */
+
+	/* Get new super block buffer */
+	newblocknr = sb2off >> nilfs->ns_blocksize_bits;
+	offset = sb2off & (nilfs->ns_blocksize - 1);
+	nsbh = sb_getblk(sb, newblocknr);
+	if (!nsbh) {
+		printk(KERN_WARNING
+		       "NILFS warning: unable to move secondary superblock "
+		       "to block %llu\n", (unsigned long long)newblocknr);
+		ret = -EIO;
+		goto out;
+	}
+	nsbp = (void *)nsbh->b_data + offset;
+	memset(nsbp, 0, nilfs->ns_blocksize);
+
+	if (sb2i >= 0) {
+		memcpy(nsbp, nilfs->ns_sbp[sb2i], nilfs->ns_sbsize);
+		brelse(nilfs->ns_sbh[sb2i]);
+		nilfs->ns_sbh[sb2i] = nsbh;
+		nilfs->ns_sbp[sb2i] = nsbp;
+	} else if (nilfs->ns_sbh[0]->b_blocknr < nilfs->ns_first_data_block) {
+		/* secondary super block will be restored to index 1 */
+		nilfs->ns_sbh[1] = nsbh;
+		nilfs->ns_sbp[1] = nsbp;
+	} else {
+		brelse(nsbh);
+	}
+out:
+	return ret;
+}
+
 static void nilfs_put_super(struct super_block *sb)
 {
 	struct the_nilfs *nilfs = sb->s_fs_info;
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
