From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: fix sanity check of btree level in nilfs_btree_root_broken()
Date: Wed, 29 Apr 2015 22:18:34 +0900
Message-ID: <1430313514-28450-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=WJ1holB15HQHoDsU8s6/Qt4ANC5SpDKmgjWos3LgKVk=;
        b=zob+c6reuT4LQ3HweUPfQh7nKxoys8oJU+0ZZ1QJHsfH7rgY1AWrlvfqiBcO5wN/Qz
         vBzduPpWUW5v8TQguPpJRpEes6CFijkDRmyNxlOXXAKodEkfNBhXKWhEuzo24Gcj8Svj
         hZeOJosyTCiFm6SqCurJ9FVQEklgIFdS1AMtmmQpxHQB3Mfazvr5Q0H2YemCYY9fI1z1
         0hKZl5ZPE28B/PPW0q8GF/32NnUNwLXs+jMGpX1R8Nm4zF7Uvl4Us8bN8JlRDMJWMYoq
         ZjVsO3v4WZOZrOPpUA0pDroGZHQb2ob1lZc2qlx7U4qOzbzThgwWPGuLIqy6jsYqltY6
         Cnbg==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

The range check for b-tree level parameter in nilfs_btree_root_broken()
is wrong; it accepts the case of "level == NILFS_BTREE_LEVEL_MAX" even
though the level is limited to values in the range of 0 to
(NILFS_BTREE_LEVEL_MAX - 1).

Since the level parameter is read from storage device and used to index
nilfs_btree_path array whose element count is NILFS_BTREE_LEVEL_MAX, it
can cause memory overrun during btree operations if the boundary value
is set to the level parameter on device.

This fixes the broken sanity check and adds a comment to clarify that
the upper bound NILFS_BTREE_LEVEL_MAX is exclusive.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
---
 fs/nilfs2/btree.c         | 2 +-
 include/linux/nilfs2_fs.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 059f371..919fd5b 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -388,7 +388,7 @@ static int nilfs_btree_root_broken(const struct nilfs_btree_node *node,
 	nchildren = nilfs_btree_node_get_nchildren(node);
 
 	if (unlikely(level < NILFS_BTREE_LEVEL_NODE_MIN ||
-		     level > NILFS_BTREE_LEVEL_MAX ||
+		     level >= NILFS_BTREE_LEVEL_MAX ||
 		     nchildren < 0 ||
 		     nchildren > NILFS_BTREE_ROOT_NCHILDREN_MAX)) {
 		pr_crit("NILFS: bad btree root (inode number=%lu): level = %d, flags = 0x%x, nchildren = %d\n",
diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index ff3fea3..9abb763 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -460,7 +460,7 @@ struct nilfs_btree_node {
 /* level */
 #define NILFS_BTREE_LEVEL_DATA          0
 #define NILFS_BTREE_LEVEL_NODE_MIN      (NILFS_BTREE_LEVEL_DATA + 1)
-#define NILFS_BTREE_LEVEL_MAX           14
+#define NILFS_BTREE_LEVEL_MAX           14	/* Max level (exclusive) */
 
 /**
  * struct nilfs_palloc_group_desc - block group descriptor
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
