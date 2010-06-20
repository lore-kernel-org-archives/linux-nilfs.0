From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: get rid of ns_free_segments_count
Date: Sun, 20 Jun 2010 13:09:41 +0900
Message-ID: <1277006981-7909-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This counter is unused.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/the_nilfs.c |    3 ---
 fs/nilfs2/the_nilfs.h |    2 --
 2 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 9f2cb01..4a9e8a0 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -630,9 +630,6 @@ int init_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi, char *data)
 		err = -EINVAL;
 		goto failed_sbh;
 	}
-	/* Dummy values  */
-	nilfs->ns_free_segments_count =
-		nilfs->ns_nsegments - (nilfs->ns_segnum + 1);
 
 	/* Initialize gcinode cache */
 	err = nilfs_init_gccache(nilfs);
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 85df47f..191560e 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -73,7 +73,6 @@ enum {
  * @ns_last_seq: sequence value of the latest segment
  * @ns_last_cno: checkpoint number of the latest segment
  * @ns_prot_seq: least sequence number of segments which must not be reclaimed
- * @ns_free_segments_count: counter of free segments
  * @ns_segctor_sem: segment constructor semaphore
  * @ns_dat: DAT file inode
  * @ns_cpfile: checkpoint file inode
@@ -150,7 +149,6 @@ struct the_nilfs {
 	u64			ns_last_seq;
 	__u64			ns_last_cno;
 	u64			ns_prot_seq;
-	unsigned long		ns_free_segments_count;
 
 	struct rw_semaphore	ns_segctor_sem;
 
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
