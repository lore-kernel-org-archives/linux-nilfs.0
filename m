From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH v2 4/9] nilfs2: add kmem_cache for SUFILE cache nodes
Date: Sun,  3 May 2015 12:05:17 +0200
Message-ID: <1430647522-14304-5-git-send-email-andreas.rohner@gmx.net>
References: <1430647522-14304-1-git-send-email-andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430647522-14304-1-git-send-email-andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This patch adds a kmem_cache to efficiently allocate SUFILE cache nodes.
One cache node contains a certain number of unsigned 32 bit values and
either a list_head, to string a number of nodes together into a linked
list, or an rcu_head to be able to use the node with an rcu
callback.

These cache nodes can be used to cache small changes to the SUFILE and
apply them later at segment construction.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 fs/nilfs2/sufile.h | 14 ++++++++++++++
 fs/nilfs2/super.c  | 14 ++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
index da78edf..520614f 100644
--- a/fs/nilfs2/sufile.h
+++ b/fs/nilfs2/sufile.h
@@ -28,6 +28,20 @@
 #include <linux/nilfs2_fs.h>
 #include "mdt.h"
 
+#define NILFS_SUFILE_CACHE_NODE_SHIFT	6
+#define NILFS_SUFILE_CACHE_NODE_COUNT	(1 << NILFS_SUFILE_CACHE_NODE_SHIFT)
+
+struct nilfs_sufile_cache_node {
+	__u32 values[NILFS_SUFILE_CACHE_NODE_COUNT];
+	union {
+		struct rcu_head rcu_head;
+		struct list_head list_head;
+	};
+	unsigned long index;
+};
+
+extern struct kmem_cache *nilfs_sufile_node_cachep;
+
 static inline int
 nilfs_sufile_live_blks_ext_supported(const struct inode *sufile)
 {
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index f47585b..97a30db 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -71,6 +71,7 @@ static struct kmem_cache *nilfs_inode_cachep;
 struct kmem_cache *nilfs_transaction_cachep;
 struct kmem_cache *nilfs_segbuf_cachep;
 struct kmem_cache *nilfs_btree_path_cache;
+struct kmem_cache *nilfs_sufile_node_cachep;
 
 static int nilfs_setup_super(struct super_block *sb, int is_mount);
 static int nilfs_remount(struct super_block *sb, int *flags, char *data);
@@ -1397,6 +1398,11 @@ static void nilfs_segbuf_init_once(void *obj)
 	memset(obj, 0, sizeof(struct nilfs_segment_buffer));
 }
 
+static void nilfs_sufile_cache_node_init_once(void *obj)
+{
+	memset(obj, 0, sizeof(struct nilfs_sufile_cache_node));
+}
+
 static void nilfs_destroy_cachep(void)
 {
 	/*
@@ -1413,6 +1419,8 @@ static void nilfs_destroy_cachep(void)
 		kmem_cache_destroy(nilfs_segbuf_cachep);
 	if (nilfs_btree_path_cache)
 		kmem_cache_destroy(nilfs_btree_path_cache);
+	if (nilfs_sufile_node_cachep)
+		kmem_cache_destroy(nilfs_sufile_node_cachep);
 }
 
 static int __init nilfs_init_cachep(void)
@@ -1441,6 +1449,12 @@ static int __init nilfs_init_cachep(void)
 	if (!nilfs_btree_path_cache)
 		goto fail;
 
+	nilfs_sufile_node_cachep = kmem_cache_create("nilfs_sufile_node_cache",
+			sizeof(struct nilfs_sufile_cache_node), 0, 0,
+			nilfs_sufile_cache_node_init_once);
+	if (!nilfs_sufile_node_cachep)
+		goto fail;
+
 	return 0;
 
 fail:
-- 
2.3.7

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
