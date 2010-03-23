From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: fix imperfect completion wait in nilfs_wait_on_logs
Date: Wed, 24 Mar 2010 01:29:37 +0900
Message-ID: <1269361777-16093-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ryusuke-sG5X7nlA6pw@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

nilfs_wait_on_logs has a potential to slip out before completion of
all bio requests when it met an error.  This synchronization fault may
cause unexpected results, for instance, violative access to freed
segment buffers from an end-bio callback routine.

This fixes the issue by ensuring that nilfs_wait_on_logs waits all
given logs.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/segbuf.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index 636eaaf..6129a43 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -323,14 +323,14 @@ int nilfs_write_logs(struct list_head *logs, struct the_nilfs *nilfs)
 int nilfs_wait_on_logs(struct list_head *logs)
 {
 	struct nilfs_segment_buffer *segbuf;
-	int err;
+	int err, ret = 0;
 
 	list_for_each_entry(segbuf, logs, sb_list) {
 		err = nilfs_segbuf_wait(segbuf);
-		if (err)
-			return err;
+		if (err && !ret)
+			ret = err;
 	}
-	return 0;
+	return ret;
 }
 
 /*
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
