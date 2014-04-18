From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 9/9] nilfs2: integrate sysfs support into driver
Date: Fri, 18 Apr 2014 20:11:03 +0400
Message-ID: <1397837463.2178.60.camel@slavad-CELSIUS-H720>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:From:Subject:Message-ID; bh=t7TXeV1Hj5LqKnzg35N3mfBJVdcp3+cjSw+J17zQ8/A=;
	b=lTMcsUVsMpUSPdsIVTlzy8+XWA970l6iJZoTU6lHsHfklIqVTS8pSxlP3dnKQ0Dn3eUrpKQ7BNVQLpmPjPbR20PPo7UsFe+GC9rjPmUvq+1R0xDH0EHHoYewqmA1vGqQ;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org, "Michael L. Semon" <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

From: Vyacheslav Dubeyko <Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org>
Subject: [PATCH v2 9/9] nilfs2: integrate sysfs support into driver

This patch integrates creation of sysfs groups and
attributes into NILFS file system driver.

It was found the issue with nilfs_sysfs_{create/delete}_snapshot_group
functions by Michael L. Semon <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> in the first
version of the patch:

[ 4928.585682] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:579
[ 4928.585693] in_atomic(): 1, irqs_disabled(): 0, pid: 32676, name: umount.nilfs2
[ 4928.585698] 2 locks held by umount.nilfs2/32676:
[ 4928.585703]  #0:  (&type->s_umount_key#21){++++..}, at: [<790c18e2>] deactivate_super+0x37/0x58
[ 4928.585732]  #1:  (&(&nilfs->ns_cptree_lock)->rlock){+.+...}, at: [<791bf659>] nilfs_put_root+0x23/0x5a
[ 4928.585749] Preemption disabled at:[<791bf659>] nilfs_put_root+0x23/0x5a

[ 4928.585766] CPU: 0 PID: 32676 Comm: umount.nilfs2 Not tainted 3.14.0+ #2
[ 4928.585771] Hardware name: Dell Computer Corporation Dimension 2350/07W080, BIOS A01 12/17/2002
[ 4928.585777]  00000000 00000000 93cdddf8 793ff0bd c14dd780 93cdde20 7904bf38 794d5224
[ 4928.585795]  791bf659 791bf659 00007fa4 c14dda00 00000000 78025360 79552b80 93cdde68
[ 4928.585811]  7940136e 00000000 00000002 c14dd780 79552d10 c14ddc00 93cdde68 00000246
[ 4928.585828] Call Trace:
[ 4928.585842]  [<793ff0bd>] dump_stack+0x4b/0x75
[ 4928.585854]  [<7904bf38>] __might_sleep+0x111/0x16f
[ 4928.585862]  [<791bf659>] ? nilfs_put_root+0x23/0x5a
[ 4928.585870]  [<791bf659>] ? nilfs_put_root+0x23/0x5a
[ 4928.585880]  [<7940136e>] mutex_lock_nested+0x1e/0x3ad
[ 4928.585893]  [<7911186e>] ? sysfs_remove_dir+0x25/0x62
[ 4928.585901]  [<7910fdb8>] kernfs_remove+0x12/0x26
[ 4928.585908]  [<79111886>] sysfs_remove_dir+0x3d/0x62
[ 4928.585918]  [<792953bb>] kobject_del+0x13/0x38
[ 4928.585926]  [<791cabd4>] nilfs_sysfs_delete_snapshot_group+0xb/0xd
[ 4928.585934]  [<791bf660>] nilfs_put_root+0x2a/0x5a
[ 4928.585942]  [<791c3827>] nilfs_detach_log_writer+0x1ab/0x2c1
[ 4928.585953]  [<7906c283>] ? call_rcu+0x17/0x19
[ 4928.585963]  [<790d5c4b>] ? dispose_list+0x27/0x31
[ 4928.585973]  [<791b4312>] nilfs_put_super+0x13/0x68
[ 4928.585980]  [<790c1bc8>] generic_shutdown_super+0x60/0xd1
[ 4928.585988]  [<790c29dd>] kill_block_super+0x1d/0x60
[ 4928.585996]  [<790c188e>] deactivate_locked_super+0x22/0x3f
[ 4928.586096]  [<790c18e9>] deactivate_super+0x3e/0x58
[ 4928.586107]  [<790d95af>] mntput_no_expire+0xe2/0x141
[ 4928.586115]  [<790d94db>] ? mntput_no_expire+0xe/0x141
[ 4928.586123]  [<790dabed>] SyS_oldumount+0x70/0xa5
[ 4928.586131]  [<794050ff>] syscall_call+0x7/0xb

The second version of the patch fixes this issue.

Reported-by: Michael L. Semon <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Vyacheslav Dubeyko <Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org>
CC: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Tested-by: Michael L. Semon <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/nilfs2/Makefile    |    2 +-
 fs/nilfs2/nilfs.h     |    8 ++++++++
 fs/nilfs2/super.c     |    9 ++++++++-
 fs/nilfs2/the_nilfs.c |   16 +++++++++++++++-
 4 files changed, 32 insertions(+), 3 deletions(-)

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
index 8c532b2..c519927 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1452,13 +1452,19 @@ static int __init init_nilfs_fs(void)
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
@@ -1468,6 +1474,7 @@ fail:
 static void __exit exit_nilfs_fs(void)
 {
 	nilfs_destroy_cachep();
+	nilfs_sysfs_exit();
 	unregister_filesystem(&nilfs_fs_type);
 }
 
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 59d5008..9da25fe 100644
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
@@ -641,6 +642,10 @@ int init_nilfs(struct the_nilfs *nilfs, struct super_block *sb, char *data)
 	if (err)
 		goto failed_sbh;
 
+	err = nilfs_sysfs_create_device_group(sb);
+	if (err)
+		goto failed_sbh;
+
 	set_nilfs_init(nilfs);
 	err = 0;
  out:
@@ -741,12 +746,13 @@ nilfs_find_or_create_root(struct the_nilfs *nilfs, __u64 cno)
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
 
@@ -783,6 +789,12 @@ nilfs_find_or_create_root(struct the_nilfs *nilfs, __u64 cno)
 
 	spin_unlock(&nilfs->ns_cptree_lock);
 
+	err = nilfs_sysfs_create_snapshot_group(new);
+	if (err) {
+		kfree(new);
+		new = NULL;
+	}
+
 	return new;
 }
 
@@ -791,6 +803,8 @@ void nilfs_put_root(struct nilfs_root *root)
 	if (atomic_dec_and_test(&root->count)) {
 		struct the_nilfs *nilfs = root->nilfs;
 
+		nilfs_sysfs_delete_snapshot_group(root);
+
 		spin_lock(&nilfs->ns_cptree_lock);
 		rb_erase(&root->rb_node, &nilfs->ns_cptree);
 		spin_unlock(&nilfs->ns_cptree_lock);
-- 
1.7.9.5


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
