From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/5] nilfs2: use list_first_entry
Date: Thu,  5 May 2011 13:13:50 +0900
Message-ID: <1304568833-31021-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1304568833-31021-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1304568833-31021-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This uses list_first_entry macro instead of list_entry if it's used to
get the first entry.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/recovery.c |   12 ++++++------
 fs/nilfs2/segment.c  |    4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index ba4a645..a604ac0 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -387,9 +387,9 @@ static int nilfs_scan_dsync_log(struct the_nilfs *nilfs, sector_t start_blocknr,
 static void dispose_recovery_list(struct list_head *head)
 {
 	while (!list_empty(head)) {
-		struct nilfs_recovery_block *rb
-			= list_entry(head->next,
-				     struct nilfs_recovery_block, list);
+		struct nilfs_recovery_block *rb;
+
+		rb = list_first_entry(head, struct nilfs_recovery_block, list);
 		list_del(&rb->list);
 		kfree(rb);
 	}
@@ -416,9 +416,9 @@ static int nilfs_segment_list_add(struct list_head *head, __u64 segnum)
 void nilfs_dispose_segment_list(struct list_head *head)
 {
 	while (!list_empty(head)) {
-		struct nilfs_segment_entry *ent
-			= list_entry(head->next,
-				     struct nilfs_segment_entry, list);
+		struct nilfs_segment_entry *ent;
+
+		ent = list_first_entry(head, struct nilfs_segment_entry, list);
 		list_del(&ent->list);
 		kfree(ent);
 	}
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 8a2b428..186cabb 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -957,8 +957,8 @@ static int nilfs_segctor_apply_buffers(struct nilfs_sc_info *sci,
 
  dispose_buffers:
 	while (!list_empty(listp)) {
-		bh = list_entry(listp->next, struct buffer_head,
-				b_assoc_buffers);
+		bh = list_first_entry(listp, struct buffer_head,
+				      b_assoc_buffers);
 		list_del_init(&bh->b_assoc_buffers);
 		brelse(bh);
 	}
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
