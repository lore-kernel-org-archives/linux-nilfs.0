From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/6] nilfs2: add blocksize member to nilfs object
Date: Tue, 25 May 2010 01:39:04 +0900
Message-ID: <1274719149-24371-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1274719149-24371-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1274719149-24371-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

This stores blocksize in nilfs objects for the successive refactoring
of recovery logic.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/the_nilfs.c |    1 +
 fs/nilfs2/the_nilfs.h |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 8c10973..870a127 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -604,6 +604,7 @@ int init_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi, char *data)
 			   when reloading fails. */
 	}
 	nilfs->ns_blocksize_bits = sb->s_blocksize_bits;
+	nilfs->ns_blocksize = blocksize;
 
 	err = nilfs_store_disk_layout(nilfs, sbp);
 	if (err)
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 1ab9745..85df47f 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -82,6 +82,7 @@ enum {
  * @ns_gc_inodes: dummy inodes to keep live blocks
  * @ns_gc_inodes_h: hash list to keep dummy inode holding live blocks
  * @ns_blocksize_bits: bit length of block size
+ * @ns_blocksize: block size
  * @ns_nsegments: number of segments in filesystem
  * @ns_blocks_per_segment: number of blocks per segment
  * @ns_r_segments_percentage: reserved segments percentage
@@ -168,6 +169,7 @@ struct the_nilfs {
 
 	/* Disk layout information (static) */
 	unsigned int		ns_blocksize_bits;
+	unsigned int		ns_blocksize;
 	unsigned long		ns_nsegments;
 	unsigned long		ns_blocks_per_segment;
 	unsigned long		ns_r_segments_percentage;
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
