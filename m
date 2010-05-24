From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 3/6] nilfs2: rename nilfs_recover_logical_segments function
Date: Tue, 25 May 2010 01:39:06 +0900
Message-ID: <1274719149-24371-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

The function name of nilfs_recover_logical_segments makes no sense.
This changes the name into nilfs_salvage_orphan_logs to clarify the
role of the function.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/recovery.c  |   11 +++++------
 fs/nilfs2/segment.h   |    6 +++---
 fs/nilfs2/the_nilfs.c |    2 +-
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index 1c883b1..fd7fb41 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -719,9 +719,8 @@ static void nilfs_finish_roll_forward(struct the_nilfs *nilfs,
 }
 
 /**
- * nilfs_recover_logical_segments - salvage logical segments written after
- * the latest super root
- * @nilfs: the_nilfs
+ * nilfs_salvage_orphan_logs - salvage logs written after the latest checkpoint
+ * @nilfs: nilfs object
  * @sbi: nilfs_sb_info
  * @ri: pointer to a nilfs_recovery_info struct to store search results.
  *
@@ -738,9 +737,9 @@ static void nilfs_finish_roll_forward(struct the_nilfs *nilfs,
  *
  * %-ENOMEM - Insufficient memory available.
  */
-int nilfs_recover_logical_segments(struct the_nilfs *nilfs,
-				   struct nilfs_sb_info *sbi,
-				   struct nilfs_recovery_info *ri)
+int nilfs_salvage_orphan_logs(struct the_nilfs *nilfs,
+			      struct nilfs_sb_info *sbi,
+			      struct nilfs_recovery_info *ri)
 {
 	int err;
 
diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
index 1897d87..c799678 100644
--- a/fs/nilfs2/segment.h
+++ b/fs/nilfs2/segment.h
@@ -240,9 +240,9 @@ extern int nilfs_read_super_root_block(struct the_nilfs *, sector_t,
 				       struct buffer_head **, int);
 extern int nilfs_search_super_root(struct the_nilfs *,
 				   struct nilfs_recovery_info *);
-extern int nilfs_recover_logical_segments(struct the_nilfs *,
-					  struct nilfs_sb_info *,
-					  struct nilfs_recovery_info *);
+extern int nilfs_salvage_orphan_logs(struct the_nilfs *,
+				     struct nilfs_sb_info *,
+				     struct nilfs_recovery_info *);
 extern void nilfs_dispose_segment_list(struct list_head *);
 
 #endif /* _NILFS_SEGMENT_H */
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index a94908e..9f2cb01 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -319,7 +319,7 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 		goto failed_unload;
 	}
 
-	err = nilfs_recover_logical_segments(nilfs, sbi, &ri);
+	err = nilfs_salvage_orphan_logs(nilfs, sbi, &ri);
 	if (err)
 		goto failed_unload;
 
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
