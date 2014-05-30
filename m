From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v4 6/9] nilfs2: add /sys/fs/nilfs2/<device>/checkpoints group
Date: Fri, 30 May 2014 17:18:57 +0400
Message-ID: <1401455937.2537.48.camel@slavad-ubuntu-14.04>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Content-Transfer-Encoding:Mime-Version:Content-Type:Date:Cc:To:From:Subject:Message-ID; bh=irsH3u1Jt0nPik7kcPbfwZgQNTYnYjxmWR8+t3Wdxfc=;
	b=c2ctUn5Cv92BdGQypIfTIti+3d3C6EVZZUCvGaJpvn0u9Pox5C0/Bpdb/Nx54ZN+paQ/Zlsv3U8th4hPqzc1Q4u+tcwknMfqHvhpVktVAaYry5WVzLqYohidcZOB9AUk;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org, "Michael L. Semon" <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

From: Vyacheslav Dubeyko <Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org>
Subject: [PATCH v4 6/9] nilfs2: add /sys/fs/nilfs2/<device>/checkpoints group

This patch adds creation of /sys/fs/nilfs2/<device>/checkpoints
group.

The checkpoints group contains attributes that describe
details about volume's checkpoints:
(1) checkpoints_number - show number of checkpoints on volume.
(2) snapshots_number - show number of snapshots on volume.
(3) last_seg_checkpoint - show checkpoint number of the latest segment.
(4) next_checkpoint - show next checkpoint number.

Signed-off-by: Vyacheslav Dubeyko <Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org>
CC: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
CC: Michael L. Semon <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Documentation/ABI/testing/sysfs-fs-nilfs2 |   31 ++++++++
 fs/nilfs2/sysfs.c                         |  123 ++++++++++++++++++++++++++++-
 fs/nilfs2/sysfs.h                         |   14 ++++
 3 files changed, 167 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-fs-nilfs2 b/Documentation/ABI/testing/sysfs-fs-nilfs2
index d39e076..7b820d6 100644
--- a/Documentation/ABI/testing/sysfs-fs-nilfs2
+++ b/Documentation/ABI/testing/sysfs-fs-nilfs2
@@ -210,3 +210,34 @@ Contact:	"Vyacheslav Dubeyko" <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
 Description:
 		Describe attributes of /sys/fs/nilfs2/<device>/segments
 		group.
+
+What:		/sys/fs/nilfs2/<device>/checkpoints/checkpoints_number
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
+Description:
+		Show number of checkpoints on volume.
+
+What:		/sys/fs/nilfs2/<device>/checkpoints/snapshots_number
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
+Description:
+		Show number of snapshots on volume.
+
+What:		/sys/fs/nilfs2/<device>/checkpoints/last_seg_checkpoint
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
+Description:
+		Show checkpoint number of the latest segment.
+
+What:		/sys/fs/nilfs2/<device>/checkpoints/next_checkpoint
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
+Description:
+		Show next checkpoint number.
+
+What:		/sys/fs/nilfs2/<device>/checkpoints/README
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
+Description:
+		Describe attributes of /sys/fs/nilfs2/<device>/checkpoints
+		group.
diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index fe8e141..5cc735f 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -112,6 +112,119 @@ void nilfs_sysfs_delete_##name##_group(struct the_nilfs *nilfs) \
 }
 
 /************************************************************************
+ *                      NILFS checkpoints attrs                         *
+ ************************************************************************/
+
+static ssize_t
+nilfs_checkpoints_checkpoints_number_show(struct nilfs_checkpoints_attr *attr,
+					    struct the_nilfs *nilfs,
+					    char *buf)
+{
+	__u64 ncheckpoints;
+	struct nilfs_cpstat cpstat;
+	int err;
+
+	down_read(&nilfs->ns_segctor_sem);
+	err = nilfs_cpfile_get_stat(nilfs->ns_cpfile, &cpstat);
+	up_read(&nilfs->ns_segctor_sem);
+	if (err < 0) {
+		printk(KERN_ERR "NILFS: unable to get checkpoint stat: err=%d\n",
+			err);
+		return err;
+	}
+
+	ncheckpoints = cpstat.cs_ncps;
+
+	return snprintf(buf, PAGE_SIZE, "%llu\n", ncheckpoints);
+}
+
+static ssize_t
+nilfs_checkpoints_snapshots_number_show(struct nilfs_checkpoints_attr *attr,
+					struct the_nilfs *nilfs,
+					char *buf)
+{
+	__u64 nsnapshots;
+	struct nilfs_cpstat cpstat;
+	int err;
+
+	down_read(&nilfs->ns_segctor_sem);
+	err = nilfs_cpfile_get_stat(nilfs->ns_cpfile, &cpstat);
+	up_read(&nilfs->ns_segctor_sem);
+	if (err < 0) {
+		printk(KERN_ERR "NILFS: unable to get checkpoint stat: err=%d\n",
+			err);
+		return err;
+	}
+
+	nsnapshots = cpstat.cs_nsss;
+
+	return snprintf(buf, PAGE_SIZE, "%llu\n", nsnapshots);
+}
+
+static ssize_t
+nilfs_checkpoints_last_seg_checkpoint_show(struct nilfs_checkpoints_attr *attr,
+					    struct the_nilfs *nilfs,
+					    char *buf)
+{
+	__u64 last_cno;
+
+	spin_lock(&nilfs->ns_last_segment_lock);
+	last_cno = nilfs->ns_last_cno;
+	spin_unlock(&nilfs->ns_last_segment_lock);
+
+	return snprintf(buf, PAGE_SIZE, "%llu\n", last_cno);
+}
+
+static ssize_t
+nilfs_checkpoints_next_checkpoint_show(struct nilfs_checkpoints_attr *attr,
+					struct the_nilfs *nilfs,
+					char *buf)
+{
+	__u64 cno;
+
+	down_read(&nilfs->ns_sem);
+	cno = nilfs->ns_cno;
+	up_read(&nilfs->ns_sem);
+
+	return snprintf(buf, PAGE_SIZE, "%llu\n", cno);
+}
+
+static const char checkpoints_readme_str[] =
+	"The checkpoints group contains attributes that describe\n"
+	"details about volume's checkpoints.\n\n"
+	"(1) checkpoints_number\n\tshow number of checkpoints on volume.\n\n"
+	"(2) snapshots_number\n\tshow number of snapshots on volume.\n\n"
+	"(3) last_seg_checkpoint\n"
+	"\tshow checkpoint number of the latest segment.\n\n"
+	"(4) next_checkpoint\n\tshow next checkpoint number.\n\n";
+
+static ssize_t
+nilfs_checkpoints_README_show(struct nilfs_checkpoints_attr *attr,
+				struct the_nilfs *nilfs, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, checkpoints_readme_str);
+}
+
+NILFS_CHECKPOINTS_RO_ATTR(checkpoints_number);
+NILFS_CHECKPOINTS_RO_ATTR(snapshots_number);
+NILFS_CHECKPOINTS_RO_ATTR(last_seg_checkpoint);
+NILFS_CHECKPOINTS_RO_ATTR(next_checkpoint);
+NILFS_CHECKPOINTS_RO_ATTR(README);
+
+static struct attribute *nilfs_checkpoints_attrs[] = {
+	NILFS_CHECKPOINTS_ATTR_LIST(checkpoints_number),
+	NILFS_CHECKPOINTS_ATTR_LIST(snapshots_number),
+	NILFS_CHECKPOINTS_ATTR_LIST(last_seg_checkpoint),
+	NILFS_CHECKPOINTS_ATTR_LIST(next_checkpoint),
+	NILFS_CHECKPOINTS_ATTR_LIST(README),
+	NULL,
+};
+
+NILFS_DEV_INT_GROUP_OPS(checkpoints, dev);
+NILFS_DEV_INT_GROUP_TYPE(checkpoints, dev);
+NILFS_DEV_INT_GROUP_FNS(checkpoints, dev);
+
+/************************************************************************
  *                        NILFS segments attrs                          *
  ************************************************************************/
 
@@ -753,10 +866,14 @@ int nilfs_sysfs_create_device_group(struct super_block *sb)
 	if (err)
 		goto free_dev_subgroups;
 
-	err = nilfs_sysfs_create_segments_group(nilfs);
+	err = nilfs_sysfs_create_checkpoints_group(nilfs);
 	if (err)
 		goto cleanup_dev_kobject;
 
+	err = nilfs_sysfs_create_segments_group(nilfs);
+	if (err)
+		goto delete_checkpoints_group;
+
 	err = nilfs_sysfs_create_superblock_group(nilfs);
 	if (err)
 		goto delete_segments_group;
@@ -773,6 +890,9 @@ delete_superblock_group:
 delete_segments_group:
 	nilfs_sysfs_delete_segments_group(nilfs);
 
+delete_checkpoints_group:
+	nilfs_sysfs_delete_checkpoints_group(nilfs);
+
 cleanup_dev_kobject:
 	kobject_del(&nilfs->ns_dev_kobj);
 
@@ -785,6 +905,7 @@ failed_create_device_group:
 
 void nilfs_sysfs_delete_device_group(struct the_nilfs *nilfs)
 {
+	nilfs_sysfs_delete_checkpoints_group(nilfs);
 	nilfs_sysfs_delete_segments_group(nilfs);
 	nilfs_sysfs_delete_superblock_group(nilfs);
 	nilfs_sysfs_delete_segctor_group(nilfs);
diff --git a/fs/nilfs2/sysfs.h b/fs/nilfs2/sysfs.h
index 228bdd1..62f0a0d 100644
--- a/fs/nilfs2/sysfs.h
+++ b/fs/nilfs2/sysfs.h
@@ -30,6 +30,8 @@
  * @sg_superblock_kobj_unregister: completion state
  * @sg_segctor_kobj: /sys/fs/<nilfs>/<device>/segctor
  * @sg_segctor_kobj_unregister: completion state
+ * @sg_checkpoints_kobj: /sys/fs/<nilfs>/<device>/checkpoints
+ * @sg_checkpoints_kobj_unregister: completion state
  * @sg_segments_kobj: /sys/fs/<nilfs>/<device>/segments
  * @sg_segments_kobj_unregister: completion state
  */
@@ -42,6 +44,10 @@ struct nilfs_sysfs_dev_subgroups {
 	struct kobject sg_segctor_kobj;
 	struct completion sg_segctor_kobj_unregister;
 
+	/* /sys/fs/<nilfs>/<device>/checkpoints */
+	struct kobject sg_checkpoints_kobj;
+	struct completion sg_checkpoints_kobj_unregister;
+
 	/* /sys/fs/<nilfs>/<device>/segments */
 	struct kobject sg_segments_kobj;
 	struct completion sg_segments_kobj_unregister;
@@ -69,6 +75,7 @@ struct nilfs_##name##_attr { \
 
 NILFS_DEV_ATTR_STRUCT(dev);
 NILFS_DEV_ATTR_STRUCT(segments);
+NILFS_DEV_ATTR_STRUCT(checkpoints);
 NILFS_DEV_ATTR_STRUCT(superblock);
 NILFS_DEV_ATTR_STRUCT(segctor);
 
@@ -104,6 +111,11 @@ NILFS_DEV_ATTR_STRUCT(segctor);
 #define NILFS_SEGMENTS_RW_ATTR(name) \
 	NILFS_RW_ATTR(segs_info, name)
 
+#define NILFS_CHECKPOINTS_RO_ATTR(name) \
+	NILFS_RO_ATTR(checkpoints, name)
+#define NILFS_CHECKPOINTS_RW_ATTR(name) \
+	NILFS_RW_ATTR(checkpoints, name)
+
 #define NILFS_SUPERBLOCK_RO_ATTR(name) \
 	NILFS_RO_ATTR(superblock, name)
 #define NILFS_SUPERBLOCK_RW_ATTR(name) \
@@ -122,6 +134,8 @@ NILFS_DEV_ATTR_STRUCT(segctor);
 	(&nilfs_dev_attr_##name.attr)
 #define NILFS_SEGMENTS_ATTR_LIST(name) \
 	(&nilfs_segments_attr_##name.attr)
+#define NILFS_CHECKPOINTS_ATTR_LIST(name) \
+	(&nilfs_checkpoints_attr_##name.attr)
 #define NILFS_SUPERBLOCK_ATTR_LIST(name) \
 	(&nilfs_superblock_attr_##name.attr)
 #define NILFS_SEGCTOR_ATTR_LIST(name) \
-- 
1.7.9.5


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
