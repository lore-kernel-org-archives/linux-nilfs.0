From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 9/9] nilfs2: integrate sysfs support into driver
Date: Fri, 04 Apr 2014 19:14:49 +0400
Message-ID: <1396624489.2215.42.camel@slavad-CELSIUS-H720>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:From:Subject:Message-ID; bh=7U+CAq6ilCD5WEdAyrt7TvtzunJbC34G/siWEfbzhsg=;
	b=eRD8r+UeqMNuNU4JimDo+TbTkOwCgsyBqMfW8FBMmcgAX6Bho9R8sePrk4OoihxJRDud7OCCB5xU5vkVBqerR+MfwpXQl/60v34yvzjcBh1F/nWkhFxBT8XuGfPpeSgj;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org

From: Vyacheslav Dubeyko <Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org>
Subject: [PATCH 9/9] nilfs2: integrate sysfs support into driver

This patch integrates creation of sysfs groups and
attributes into NILFS file system driver.

Signed-off-by: Vyacheslav Dubeyko <Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org>
CC: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/Makefile    |    2 +-
 fs/nilfs2/nilfs.h     |    8 ++++++++
 fs/nilfs2/super.c     |    9 ++++++++-
 fs/nilfs2/the_nilfs.c |   15 ++++++++++++++-
 4 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/Makefile b/fs/nilfs2/Makefile
index 85c9873..fc603e0 100644
--- a/fs/nilfs2/Makefile
+++ b/fs/nilfs2/Makefile
@@ -2,4 +2,4 @@ obj-$(CONFIG_NILFS2_FS) += nilfs2.o
 nilfs2-y := inode.o file.o dir.o super.o namei.o page.o mdt.o \
 	btnode.o bmap.o btree.o direct.o dat.o recovery.o \
 	the_nilfs.o segbuf.o segment.o cpfile.o sufile.o \
-	ifile.o alloc.o gcinode.o ioctl.o
+	ifile.o alloc.o gcinode.o ioctl.o sysfs.o
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 9bc72de..0696161 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -320,6 +320,14 @@ int nilfs_gccache_wait_and_mark_dirty(struct buffer_head *);
 int nilfs_init_gcinode(struct inode *inode);
 void nilfs_remove_all_gcinodes(struct the_nilfs *nilfs);
 
+/* sysfs.c */
+int __init nilfs_sysfs_init(void);
+void nilfs_sysfs_exit(void);
+int nilfs_sysfs_create_device_group(struct super_block *);
+void nilfs_sysfs_delete_device_group(struct the_nilfs *);
+int nilfs_sysfs_create_snapshot_group(struct nilfs_root *);
+void nilfs_sysfs_delete_snapshot_group(struct nilfs_root *);
+
 /*
  * Inodes and files operations
  */
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 7ac2a12..4f72848 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1451,13 +1451,19 @@ static int __init init_nilfs_fs(void)
 	if (err)
 		goto fail;
 
-	err = register_filesystem(&nilfs_fs_type);
+	err = nilfs_sysfs_init();
 	if (err)
 		goto free_cachep;
 
+	err = register_filesystem(&nilfs_fs_type);
+	if (err)
+		goto deinit_sysfs_entry;
+
 	printk(KERN_INFO "NILFS version 2 loaded\n");
 	return 0;
 
+deinit_sysfs_entry:
+	nilfs_sysfs_exit();
 free_cachep:
 	nilfs_destroy_cachep();
 fail:
@@ -1467,6 +1473,7 @@ fail:
 static void __exit exit_nilfs_fs(void)
 {
 	nilfs_destroy_cachep();
+	nilfs_sysfs_exit();
 	unregister_filesystem(&nilfs_fs_type);
 }
 
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 475b8b9..cae1822 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -98,6 +98,7 @@ void destroy_nilfs(struct the_nilfs *nilfs)
 {
 	might_sleep();
 	if (nilfs_init(nilfs)) {
+		nilfs_sysfs_delete_device_group(nilfs);
 		brelse(nilfs->ns_sbh[0]);
 		brelse(nilfs->ns_sbh[1]);
 	}
@@ -631,6 +632,10 @@ int init_nilfs(struct the_nilfs *nilfs, struct super_block *sb, char *data)
 	if (err)
 		goto failed_sbh;
 
+	err = nilfs_sysfs_create_device_group(sb);
+	if (err)
+		goto failed_sbh;
+
 	set_nilfs_init(nilfs);
 	err = 0;
  out:
@@ -731,12 +736,13 @@ nilfs_find_or_create_root(struct the_nilfs *nilfs, __u64 cno)
 {
 	struct rb_node **p, *parent;
 	struct nilfs_root *root, *new;
+	int err;
 
 	root = nilfs_lookup_root(nilfs, cno);
 	if (root)
 		return root;
 
-	new = kmalloc(sizeof(*root), GFP_KERNEL);
+	new = kzalloc(sizeof(*root), GFP_KERNEL);
 	if (!new)
 		return NULL;
 
@@ -771,6 +777,12 @@ nilfs_find_or_create_root(struct the_nilfs *nilfs, __u64 cno)
 	rb_link_node(&new->rb_node, parent, p);
 	rb_insert_color(&new->rb_node, &nilfs->ns_cptree);
 
+	err = nilfs_sysfs_create_snapshot_group(new);
+	if (err) {
+		kfree(new);
+		new = NULL;
+	}
+
 	spin_unlock(&nilfs->ns_cptree_lock);
 
 	return new;
@@ -782,6 +794,7 @@ void nilfs_put_root(struct nilfs_root *root)
 		struct the_nilfs *nilfs = root->nilfs;
 
 		spin_lock(&nilfs->ns_cptree_lock);
+		nilfs_sysfs_delete_snapshot_group(root);
 		rb_erase(&root->rb_node, &nilfs->ns_cptree);
 		spin_unlock(&nilfs->ns_cptree_lock);
 		if (root->ifile)
-- 
1.7.9.5


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
