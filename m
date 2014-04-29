From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 8/9] nilfs2: add
 /sys/fs/nilfs2/<device>/mounted_snapshots/<snapshot> group
Date: Tue, 29 Apr 2014 19:20:45 +0400
Message-ID: <1398784845.2185.74.camel@slavad-CELSIUS-H720>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:From:Subject:Message-ID; bh=d4krfZAkF9tXLnXhe1Ueayh8JN2kTDJnkeijV8W/aEc=;
	b=Lerdv03P9fzcZWAJFbJ3l4yYKtaopfJpsxO2XDivCSLOmGCnJpVUkaTJJ4QvG1W2SR7sYFKMW//rBQ4sLxZMg9l/S46d/vLOIK+mlLSF11GyDxl3CzifCC+ToQWNopqL;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org, "Michael L. Semon" <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

From: Vyacheslav Dubeyko <Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org>
Subject: [PATCH v3 8/9] nilfs2: add /sys/fs/nilfs2/<device>/mounted_snapshots/<snapshot> group

This patch adds creation of <snapshot> group for every mounted
snapshot in /sys/fs/nilfs2/<device>/mounted_snapshots group.

The group contains details about mounted snapshot:
(1) inodes_count - show number of inodes for snapshot.
(2) blocks_count - show number of blocks for snapshot.

Signed-off-by: Vyacheslav Dubeyko <Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org>
CC: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
CC: Michael L. Semon <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Documentation/ABI/testing/sysfs-fs-nilfs2 |   22 ++++++
 fs/nilfs2/sysfs.c                         |  118 +++++++++++++++++++++++++++++
 fs/nilfs2/sysfs.h                         |   20 +++++
 fs/nilfs2/the_nilfs.h                     |    6 ++
 4 files changed, 166 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-fs-nilfs2 b/Documentation/ABI/testing/sysfs-fs-nilfs2
index db3cf80..aac5a2b 100644
--- a/Documentation/ABI/testing/sysfs-fs-nilfs2
+++ b/Documentation/ABI/testing/sysfs-fs-nilfs2
@@ -287,3 +287,25 @@ Contact:	"Vyacheslav Dubeyko" <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
 Description:
 		Describe content of /sys/fs/nilfs2/<device>/mounted_snapshots
 		group.
+
+What:		/sys/fs/nilfs2/<device>/mounted_snapshots/<id>/inodes_count
+Date:		April 2014
+KernelVersion:	3.15
+Contact:	"Vyacheslav Dubeyko" <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
+Description:
+		Show number of inodes for snapshot.
+
+What:		/sys/fs/nilfs2/<device>/mounted_snapshots/<id>/blocks_count
+Date:		April 2014
+KernelVersion:	3.15
+Contact:	"Vyacheslav Dubeyko" <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
+Description:
+		Show number of blocks for snapshot.
+
+What:		/sys/fs/nilfs2/<device>/mounted_snapshots/<id>/README
+Date:		April 2014
+KernelVersion:	3.15
+Contact:	"Vyacheslav Dubeyko" <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
+Description:
+		Describe attributes of /sys/fs/nilfs2/<device>/mounted_snapshots/<id>
+		group.
diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index 3de3b30..c3a7ef1 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -112,6 +112,124 @@ void nilfs_sysfs_delete_##name##_group(struct the_nilfs *nilfs) \
 }
 
 /************************************************************************
+ *                        NILFS snapshot attrs                          *
+ ************************************************************************/
+
+static ssize_t
+nilfs_snapshot_inodes_count_show(struct nilfs_snapshot_attr *attr,
+				 struct nilfs_root *root, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%llu\n",
+			(unsigned long long)atomic64_read(&root->inodes_count));
+}
+
+static ssize_t
+nilfs_snapshot_blocks_count_show(struct nilfs_snapshot_attr *attr,
+				 struct nilfs_root *root, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%llu\n",
+			(unsigned long long)atomic64_read(&root->blocks_count));
+}
+
+static const char snapshot_readme_str[] =
+	"The group contains details about mounted snapshot.\n\n"
+	"(1) inodes_count\n\tshow number of inodes for snapshot.\n\n"
+	"(2) blocks_count\n\tshow number of blocks for snapshot.\n\n";
+
+static ssize_t
+nilfs_snapshot_README_show(struct nilfs_snapshot_attr *attr,
+			    struct nilfs_root *root, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, snapshot_readme_str);
+}
+
+NILFS_SNAPSHOT_RO_ATTR(inodes_count);
+NILFS_SNAPSHOT_RO_ATTR(blocks_count);
+NILFS_SNAPSHOT_RO_ATTR(README);
+
+static struct attribute *nilfs_snapshot_attrs[] = {
+	NILFS_SNAPSHOT_ATTR_LIST(inodes_count),
+	NILFS_SNAPSHOT_ATTR_LIST(blocks_count),
+	NILFS_SNAPSHOT_ATTR_LIST(README),
+	NULL,
+};
+
+static ssize_t nilfs_snapshot_attr_show(struct kobject *kobj,
+					struct attribute *attr, char *buf)
+{
+	struct nilfs_root *root =
+			container_of(kobj, struct nilfs_root, snapshot_kobj);
+	struct nilfs_snapshot_attr *a =
+			container_of(attr, struct nilfs_snapshot_attr, attr);
+
+	return a->show ? a->show(a, root, buf) : 0;
+}
+
+static ssize_t nilfs_snapshot_attr_store(struct kobject *kobj,
+					 struct attribute *attr,
+					 const char *buf, size_t len)
+{
+	struct nilfs_root *root =
+			container_of(kobj, struct nilfs_root, snapshot_kobj);
+	struct nilfs_snapshot_attr *a =
+			container_of(attr, struct nilfs_snapshot_attr, attr);
+
+	return a->store ? a->store(a, root, buf, len) : 0;
+}
+
+static void nilfs_snapshot_attr_release(struct kobject *kobj)
+{
+	struct nilfs_root *root = container_of(kobj, struct nilfs_root,
+						snapshot_kobj);
+	complete(&root->snapshot_kobj_unregister);
+}
+
+static const struct sysfs_ops nilfs_snapshot_attr_ops = {
+	.show	= nilfs_snapshot_attr_show,
+	.store	= nilfs_snapshot_attr_store,
+};
+
+static struct kobj_type nilfs_snapshot_ktype = {
+	.default_attrs	= nilfs_snapshot_attrs,
+	.sysfs_ops	= &nilfs_snapshot_attr_ops,
+	.release	= nilfs_snapshot_attr_release,
+};
+
+int nilfs_sysfs_create_snapshot_group(struct nilfs_root *root)
+{
+	struct the_nilfs *nilfs;
+	struct kobject *parent;
+	int err;
+
+	nilfs = root->nilfs;
+	parent = &nilfs->ns_dev_subgroups->sg_mounted_snapshots_kobj;
+	root->snapshot_kobj.kset = nilfs_kset;
+	init_completion(&root->snapshot_kobj_unregister);
+
+	if (root->cno == NILFS_CPTREE_CURRENT_CNO) {
+		err = kobject_init_and_add(&root->snapshot_kobj,
+					    &nilfs_snapshot_ktype,
+					    &nilfs->ns_dev_kobj,
+					    "current_checkpoint");
+	} else {
+		err = kobject_init_and_add(&root->snapshot_kobj,
+					    &nilfs_snapshot_ktype,
+					    parent,
+					    "%llu", root->cno);
+	}
+
+	if (err)
+		return err;
+
+	return 0;
+}
+
+void nilfs_sysfs_delete_snapshot_group(struct nilfs_root *root)
+{
+	kobject_del(&root->snapshot_kobj);
+}
+
+/************************************************************************
  *                    NILFS mounted snapshots attrs                     *
  ************************************************************************/
 
diff --git a/fs/nilfs2/sysfs.h b/fs/nilfs2/sysfs.h
index b10830d..3b3d7c4 100644
--- a/fs/nilfs2/sysfs.h
+++ b/fs/nilfs2/sysfs.h
@@ -84,6 +84,17 @@ NILFS_DEV_ATTR_STRUCT(checkpoints);
 NILFS_DEV_ATTR_STRUCT(superblock);
 NILFS_DEV_ATTR_STRUCT(segctor);
 
+#define NILFS_CP_ATTR_STRUCT(name) \
+struct nilfs_##name##_attr { \
+	struct attribute attr; \
+	ssize_t (*show)(struct nilfs_##name##_attr *, struct nilfs_root *, \
+			char *); \
+	ssize_t (*store)(struct nilfs_##name##_attr *, struct nilfs_root *, \
+			 const char *, size_t); \
+};
+
+NILFS_CP_ATTR_STRUCT(snapshot);
+
 #define NILFS_ATTR(type, name, mode, show, store) \
 	static struct nilfs_##type##_attr nilfs_##type##_attr_##name = \
 		__ATTR(name, mode, show, store)
@@ -124,6 +135,13 @@ NILFS_DEV_ATTR_STRUCT(segctor);
 #define NILFS_CHECKPOINTS_RW_ATTR(name) \
 	NILFS_RW_ATTR(checkpoints, name)
 
+#define NILFS_SNAPSHOT_INFO_ATTR(name) \
+	NILFS_INFO_ATTR(snapshot, name)
+#define NILFS_SNAPSHOT_RO_ATTR(name) \
+	NILFS_RO_ATTR(snapshot, name)
+#define NILFS_SNAPSHOT_RW_ATTR(name) \
+	NILFS_RW_ATTR(snapshot, name)
+
 #define NILFS_SUPERBLOCK_RO_ATTR(name) \
 	NILFS_RO_ATTR(superblock, name)
 #define NILFS_SUPERBLOCK_RW_ATTR(name) \
@@ -146,6 +164,8 @@ NILFS_DEV_ATTR_STRUCT(segctor);
 	(&nilfs_mounted_snapshots_attr_##name.attr)
 #define NILFS_CHECKPOINTS_ATTR_LIST(name) \
 	(&nilfs_checkpoints_attr_##name.attr)
+#define NILFS_SNAPSHOT_ATTR_LIST(name) \
+	(&nilfs_snapshot_attr_##name.attr)
 #define NILFS_SUPERBLOCK_ATTR_LIST(name) \
 	(&nilfs_superblock_attr_##name.attr)
 #define NILFS_SEGCTOR_ATTR_LIST(name) \
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 7fe8223..d01ead1 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -243,6 +243,8 @@ THE_NILFS_FNS(SB_DIRTY, sb_dirty)
  * @ifile: inode file
  * @inodes_count: number of inodes
  * @blocks_count: number of blocks
+ * @snapshot_kobj: /sys/fs/<nilfs>/<device>/mounted_snapshots/<snapshot>
+ * @snapshot_kobj_unregister: completion state for kernel object
  */
 struct nilfs_root {
 	__u64 cno;
@@ -254,6 +256,10 @@ struct nilfs_root {
 
 	atomic64_t inodes_count;
 	atomic64_t blocks_count;
+
+	/* /sys/fs/<nilfs>/<device>/mounted_snapshots/<snapshot> */
+	struct kobject snapshot_kobj;
+	struct completion snapshot_kobj_unregister;
 };
 
 /* Special checkpoint number */
-- 
1.7.9.5


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
