From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 3/3] nilfs2: move iterator to write log into segment buffer
Date: Wed, 10 Feb 2010 00:46:23 +0900
Message-ID: <1265730383-31290-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1265730383-31290-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1265730383-31290-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This moves iterator to submit write requests for a series of logs into
segbuf.c, and hides nilfs_segbuf_write() and nilfs_segbuf_wait() in
the file.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/segbuf.c  |   18 ++++++++++++++++++
 fs/nilfs2/segbuf.h  |    5 +----
 fs/nilfs2/segment.c |    9 ++-------
 3 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index 645c786..ab56fe4 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -40,6 +40,11 @@ struct nilfs_write_info {
 };
 
 
+static int nilfs_segbuf_write(struct nilfs_segment_buffer *segbuf,
+			      struct the_nilfs *nilfs);
+static int nilfs_segbuf_wait(struct nilfs_segment_buffer *segbuf);
+
+
 static struct kmem_cache *nilfs_segbuf_cachep;
 
 static void nilfs_segbuf_init_once(void *obj)
@@ -302,6 +307,19 @@ void nilfs_truncate_logs(struct list_head *logs,
 	}
 }
 
+int nilfs_write_logs(struct list_head *logs, struct the_nilfs *nilfs)
+{
+	struct nilfs_segment_buffer *segbuf;
+	int ret = 0;
+
+	list_for_each_entry(segbuf, logs, sb_list) {
+		ret = nilfs_segbuf_write(segbuf, nilfs);
+		if (ret)
+			break;
+	}
+	return ret;
+}
+
 int nilfs_wait_on_logs(struct list_head *logs)
 {
 	struct nilfs_segment_buffer *segbuf;
diff --git a/fs/nilfs2/segbuf.h b/fs/nilfs2/segbuf.h
index 6af1630..94dfd35 100644
--- a/fs/nilfs2/segbuf.h
+++ b/fs/nilfs2/segbuf.h
@@ -166,13 +166,10 @@ nilfs_segbuf_add_file_buffer(struct nilfs_segment_buffer *segbuf,
 	segbuf->sb_sum.nfileblk++;
 }
 
-int nilfs_segbuf_write(struct nilfs_segment_buffer *segbuf,
-		       struct the_nilfs *nilfs);
-int nilfs_segbuf_wait(struct nilfs_segment_buffer *segbuf);
-
 void nilfs_clear_logs(struct list_head *logs);
 void nilfs_truncate_logs(struct list_head *logs,
 			 struct nilfs_segment_buffer *last);
+int nilfs_write_logs(struct list_head *logs, struct the_nilfs *nilfs);
 int nilfs_wait_on_logs(struct list_head *logs);
 
 static inline void nilfs_destroy_logs(struct list_head *logs)
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index c4fcdd1..ada2f1b 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1764,14 +1764,9 @@ static int nilfs_segctor_prepare_write(struct nilfs_sc_info *sci,
 static int nilfs_segctor_write(struct nilfs_sc_info *sci,
 			       struct the_nilfs *nilfs)
 {
-	struct nilfs_segment_buffer *segbuf;
-	int ret = 0;
+	int ret;
 
-	list_for_each_entry(segbuf, &sci->sc_segbufs, sb_list) {
-		ret = nilfs_segbuf_write(segbuf, nilfs);
-		if (ret)
-			break;
-	}
+	ret = nilfs_write_logs(&sci->sc_segbufs, nilfs);
 	list_splice_tail_init(&sci->sc_segbufs, &sci->sc_write_logs);
 	return ret;
 }
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
