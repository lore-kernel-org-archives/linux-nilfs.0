From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 3/6] nilfs2: use device's backing_dev_info for
	btree node caches
Date: Mon,  8 Jun 2009 15:07:16 +0900
Message-ID: <1244441239-20032-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1244441239-20032-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1244441239-20032-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Previously, default_backing_dev_info was used for the mapping of btree
node caches.  This uses device dependent backing_dev_info to allow
detailed control of the device for the btree node pages.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/btnode.c |    5 +++--
 fs/nilfs2/btnode.h |    2 +-
 fs/nilfs2/mdt.c    |    2 +-
 fs/nilfs2/nilfs.h  |    1 +
 fs/nilfs2/super.c  |    9 +++++++--
 5 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index 4cc07b2..0e01957 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -48,13 +48,14 @@ void nilfs_btnode_cache_init_once(struct address_space *btnc)
 
 static struct address_space_operations def_btnode_aops;
 
-void nilfs_btnode_cache_init(struct address_space *btnc)
+void nilfs_btnode_cache_init(struct address_space *btnc,
+			     struct backing_dev_info *bdi)
 {
 	btnc->host = NULL;  /* can safely set to host inode ? */
 	btnc->flags = 0;
 	mapping_set_gfp_mask(btnc, GFP_NOFS);
 	btnc->assoc_mapping = NULL;
-	btnc->backing_dev_info = &default_backing_dev_info;
+	btnc->backing_dev_info = bdi;
 	btnc->a_ops = &def_btnode_aops;
 }
 
diff --git a/fs/nilfs2/btnode.h b/fs/nilfs2/btnode.h
index 35faa86..3e22751 100644
--- a/fs/nilfs2/btnode.h
+++ b/fs/nilfs2/btnode.h
@@ -38,7 +38,7 @@ struct nilfs_btnode_chkey_ctxt {
 };
 
 void nilfs_btnode_cache_init_once(struct address_space *);
-void nilfs_btnode_cache_init(struct address_space *);
+void nilfs_btnode_cache_init(struct address_space *, struct backing_dev_info *);
 void nilfs_btnode_cache_clear(struct address_space *);
 int nilfs_btnode_submit_block(struct address_space *, __u64, sector_t,
 			      struct buffer_head **, int);
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index c3eb539..9b149a1 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -453,7 +453,7 @@ struct inode *
 nilfs_mdt_new_common(struct the_nilfs *nilfs, struct super_block *sb,
 		     ino_t ino, gfp_t gfp_mask)
 {
-	struct inode *inode = nilfs_alloc_inode(sb);
+	struct inode *inode = nilfs_alloc_inode_common(nilfs);
 
 	if (!inode)
 		return NULL;
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index da6fc0b..edf6a59 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -263,6 +263,7 @@ extern void nilfs_dirty_inode(struct inode *);
 extern struct dentry *nilfs_get_parent(struct dentry *);
 
 /* super.c */
+extern struct inode *nilfs_alloc_inode_common(struct the_nilfs *);
 extern struct inode *nilfs_alloc_inode(struct super_block *);
 extern void nilfs_destroy_inode(struct inode *);
 extern void nilfs_error(struct super_block *, const char *, const char *, ...)
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 1feb588..1de395f 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -132,7 +132,7 @@ void nilfs_warning(struct super_block *sb, const char *function,
 
 static struct kmem_cache *nilfs_inode_cachep;
 
-struct inode *nilfs_alloc_inode(struct super_block *sb)
+struct inode *nilfs_alloc_inode_common(struct the_nilfs *nilfs)
 {
 	struct nilfs_inode_info *ii;
 
@@ -142,10 +142,15 @@ struct inode *nilfs_alloc_inode(struct super_block *sb)
 	ii->i_bh = NULL;
 	ii->i_state = 0;
 	ii->vfs_inode.i_version = 1;
-	nilfs_btnode_cache_init(&ii->i_btnode_cache);
+	nilfs_btnode_cache_init(&ii->i_btnode_cache, nilfs->ns_bdi);
 	return &ii->vfs_inode;
 }
 
+struct inode *nilfs_alloc_inode(struct super_block *sb)
+{
+	return nilfs_alloc_inode_common(NILFS_SB(sb)->s_nilfs);
+}
+
 void nilfs_destroy_inode(struct inode *inode)
 {
 	kmem_cache_free(nilfs_inode_cachep, NILFS_I(inode));
-- 
1.6.2
