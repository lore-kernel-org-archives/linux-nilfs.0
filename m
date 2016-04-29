From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 08/11] nilfs2: move cleanup code of metadata file from inode routines
Date: Fri, 29 Apr 2016 22:15:44 +0900
Message-ID: <1461935747-10380-9-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1461935747-10380-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=ozc9KM8nEVvaDJHr/8GZedFS+ht39M56y1/cbrCh6MQ=;
        b=xD8RwmWeIebRxVNHzhorJIOE5k8iZS1MnjPE17cubAuUztTBT9R6NzRFIVaAbgAWzP
         2KQCXuhfcarku5lwSv7XHDLgEGs9CFSpF6Pt2hJ9Mxe1ndVWkFdkP1iLn4hkrnlyKIZB
         f1rASih1UlsD7eDwjE3Z3j+grxikThmskuLbXPR8IhsIQxwJOMvu2rxLvPioquBgpSHH
         o3GeYgJTj009pPrdH4lPXkZNbRu/za3QWkicgzwdwDsppGKMQpyAM34MmiRNFZyI1BSc
         WzGNB6QVKVcnb/pcjbYLhuAjHyLOVURLM1NclSTxEwo/joDoRmFx60xh4Jyzbf629l45
         X7Mg==
In-Reply-To: <1461935747-10380-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Refactor nilfs_clear_inode() and nilfs_i_callback() so that cleanup
code or resource deallocation related to metadata file will be moved
out to mdt.c.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/inode.c |  5 ++---
 fs/nilfs2/mdt.c   | 25 +++++++++++++++++++++++++
 fs/nilfs2/mdt.h   |  8 ++++++++
 fs/nilfs2/super.c |  8 +++-----
 4 files changed, 38 insertions(+), 8 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 3d3ff46..191bc218 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -755,7 +755,6 @@ void nilfs_truncate(struct inode *inode)
 static void nilfs_clear_inode(struct inode *inode)
 {
 	struct nilfs_inode_info *ii = NILFS_I(inode);
-	struct nilfs_mdt_info *mdi = NILFS_MDT(inode);
 
 	/*
 	 * Free resources allocated in nilfs_read_inode(), here.
@@ -764,8 +763,8 @@ static void nilfs_clear_inode(struct inode *inode)
 	brelse(ii->i_bh);
 	ii->i_bh = NULL;
 
-	if (mdi && mdi->mi_palloc_cache)
-		nilfs_palloc_destroy_cache(inode);
+	if (nilfs_is_metadata_file_inode(inode))
+		nilfs_mdt_clear(inode);
 
 	if (test_bit(NILFS_I_BMAP, &ii->i_state))
 		nilfs_bmap_clear(ii->i_bmap);
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index c8fe584..8a2f8b2 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -28,6 +28,7 @@
 #include "segment.h"
 #include "page.h"
 #include "mdt.h"
+#include "alloc.h"		/* nilfs_palloc_destroy_cache() */
 
 #include <trace/events/nilfs2.h>
 
@@ -465,6 +466,30 @@ int nilfs_mdt_init(struct inode *inode, gfp_t gfp_mask, size_t objsz)
 	return 0;
 }
 
+/**
+ * nilfs_mdt_clear - do cleanup for the metadata file
+ * @inode: inode of the metadata file
+ */
+void nilfs_mdt_clear(struct inode *inode)
+{
+	struct nilfs_mdt_info *mdi = NILFS_MDT(inode);
+
+	if (mdi->mi_palloc_cache)
+		nilfs_palloc_destroy_cache(inode);
+}
+
+/**
+ * nilfs_mdt_destroy - release resources used by the metadata file
+ * @inode: inode of the metadata file
+ */
+void nilfs_mdt_destroy(struct inode *inode)
+{
+	struct nilfs_mdt_info *mdi = NILFS_MDT(inode);
+
+	kfree(mdi->mi_bgl); /* kfree(NULL) is safe */
+	kfree(mdi);
+}
+
 void nilfs_mdt_set_entry_size(struct inode *inode, unsigned entry_size,
 			      unsigned header_size)
 {
diff --git a/fs/nilfs2/mdt.h b/fs/nilfs2/mdt.h
index dc88907..ffb876e 100644
--- a/fs/nilfs2/mdt.h
+++ b/fs/nilfs2/mdt.h
@@ -67,6 +67,11 @@ static inline struct nilfs_mdt_info *NILFS_MDT(const struct inode *inode)
 	return inode->i_private;
 }
 
+static inline int nilfs_is_metadata_file_inode(const struct inode *inode)
+{
+	return inode->i_private != NULL;
+}
+
 /* Default GFP flags using highmem */
 #define NILFS_MDT_GFP      (__GFP_RECLAIM | __GFP_IO | __GFP_HIGHMEM)
 
@@ -82,6 +87,9 @@ int nilfs_mdt_forget_block(struct inode *, unsigned long);
 int nilfs_mdt_fetch_dirty(struct inode *);
 
 int nilfs_mdt_init(struct inode *inode, gfp_t gfp_mask, size_t objsz);
+void nilfs_mdt_clear(struct inode *inode);
+void nilfs_mdt_destroy(struct inode *inode);
+
 void nilfs_mdt_set_entry_size(struct inode *, unsigned, unsigned);
 
 int nilfs_mdt_setup_shadow_map(struct inode *inode,
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 2ed3e40..2cb78b8 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -169,12 +169,10 @@ struct inode *nilfs_alloc_inode(struct super_block *sb)
 static void nilfs_i_callback(struct rcu_head *head)
 {
 	struct inode *inode = container_of(head, struct inode, i_rcu);
-	struct nilfs_mdt_info *mdi = NILFS_MDT(inode);
 
-	if (mdi) {
-		kfree(mdi->mi_bgl); /* kfree(NULL) is safe */
-		kfree(mdi);
-	}
+	if (nilfs_is_metadata_file_inode(inode))
+		nilfs_mdt_destroy(inode);
+
 	kmem_cache_free(nilfs_inode_cachep, NILFS_I(inode));
 }
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
