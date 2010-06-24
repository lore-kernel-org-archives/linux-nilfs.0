From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 3/3] nilfs2: implement fallback for super root search
Date: Fri, 25 Jun 2010 01:38:39 +0900
Message-ID: <1277397519-6715-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1277397519-6715-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1277397519-6715-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

Although nilfs redundantly uses two super blocks and each may point to
different position on log, the current version of nilfs does not try
fallback to the spare super block when it doesn't find any valid log
at the position that the primary super block points to.

This has been a cause of mount failures due to write order reversals
on barrier less block devices.

This inserts fallback code in error path of nilfs_search_super_root
routine to resolve the mount failure problem.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/the_nilfs.c |   52 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 9e43edd..b38913c 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -38,6 +38,8 @@
 static LIST_HEAD(nilfs_objects);
 static DEFINE_SPINLOCK(nilfs_lock);
 
+static int nilfs_valid_sb(struct nilfs_super_block *sbp);
+
 void nilfs_set_last_segment(struct the_nilfs *nilfs,
 			    sector_t start_blocknr, u64 seq, __u64 cno)
 {
@@ -317,8 +319,50 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 
 	err = nilfs_search_super_root(nilfs, &ri);
 	if (unlikely(err)) {
-		printk(KERN_ERR "NILFS: error searching super root.\n");
-		goto failed;
+		int blocksize;
+
+		if (err != -EINVAL)
+			goto scan_error;
+
+		sbp = nilfs->ns_sbp;
+		if (!nilfs_valid_sb(sbp[1])) {
+			printk(KERN_WARNING
+			       "NILFS warning: unable to fall back to spare"
+			       "super block\n");
+			goto scan_error;
+		}
+		printk(KERN_INFO
+		       "NILFS: try rollback from an earlier position\n");
+
+		/*
+		 * restore super block with its spare and reconfigure
+		 * relevant states of the nilfs object.
+		 */
+		memcpy(sbp[0], sbp[1], nilfs->ns_sbsize);
+		nilfs->ns_crc_seed = le32_to_cpu(sbp[0]->s_crc_seed);
+		nilfs->ns_sbwtime = le64_to_cpu(sbp[0]->s_wtime);
+
+		/* verify consistency between two super blocks */
+		blocksize = BLOCK_SIZE << le32_to_cpu(sbp[0]->s_log_block_size);
+		if (blocksize != nilfs->ns_blocksize) {
+			printk(KERN_WARNING
+			       "NILFS warning: blocksize differs between "
+			       "two super blocks (%d != %d)\n",
+			       blocksize, nilfs->ns_blocksize);
+			goto scan_error;
+		}
+
+		err = nilfs_store_log_cursor(nilfs, sbp[0]);
+		if (err)
+			goto scan_error;
+
+		/* drop clean flag to allow roll-forward and recovery */
+		nilfs->ns_mount_state &= ~NILFS_VALID_FS;
+		valid_fs = 0;
+
+		err = nilfs_search_super_root(nilfs, &ri);
+		if (err)
+			goto scan_error;
 	}
 
 	err = nilfs_load_super_root(nilfs, ri.ri_super_root);
@@ -379,6 +423,10 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 	sbi->s_super->s_flags = s_flags;
 	return 0;
 
+ scan_error:
+	printk(KERN_ERR "NILFS: error searching super root.\n");
+	goto failed;
+
  failed_unload:
 	nilfs_mdt_destroy(nilfs->ns_cpfile);
 	nilfs_mdt_destroy(nilfs->ns_sufile);
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
