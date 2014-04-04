From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 7/9] nilfs2: add /sys/fs/nilfs/<device>/mounted_snapshots
 group
Date: Fri, 04 Apr 2014 19:14:15 +0400
Message-ID: <1396624455.2215.40.camel@slavad-CELSIUS-H720>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:From:Subject:Message-ID; bh=oQMvVWQddWI41bvk/LeLaKFlI5yZgymNOY1/LdPskOo=;
	b=K4MnttMl1cbntv50oaQpxffRR/Y4JuasiY5X3mczm6jzi7GqNqtl31dEZLsIrtOBAu8kuFtSi2pP4Io7t3Vctf1bC/JBKYaA3jAPkOI5ASEtntNzIcuv33/NPDmrm+xs;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org

From: Vyacheslav Dubeyko <Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org>
Subject: [PATCH 7/9] nilfs2: add /sys/fs/nilfs/<device>/mounted_snapshots group

This patch adds creation of /sys/fs/nilfs/<device>/mounted_snapshots
group.

The mounted_snapshots group contains group for every
mounted snapshot.

Signed-off-by: Vyacheslav Dubeyko <Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org>
CC: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/sysfs.c |   36 +++++++++++++++++++++++++++++++++++-
 fs/nilfs2/sysfs.h |   12 ++++++++++++
 2 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index 5583683..44fb4be 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -122,6 +122,32 @@ void nilfs_sysfs_delete_##name##_group(struct the_nilfs *nilfs) \
 }
 
 /************************************************************************
+ *                    NILFS mounted snapshots attrs                     *
+ ************************************************************************/
+
+static const char mounted_snapshots_readme_str[] =
+	"The mounted_snapshots group contains group for\n"
+	"every mounted snapshot.\n";
+
+static ssize_t
+nilfs_mounted_snapshots_README_show(struct nilfs_mounted_snapshots_attr *attr,
+				    struct the_nilfs *nilfs, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, mounted_snapshots_readme_str);
+}
+
+NILFS_MOUNTED_SNAPSHOTS_RO_ATTR(README);
+
+static struct attribute *nilfs_mounted_snapshots_attrs[] = {
+	NILFS_MOUNTED_SNAPSHOTS_ATTR_LIST(README),
+	NULL,
+};
+
+NILFS_DEV_INT_GROUP_OPS(mounted_snapshots, dev);
+NILFS_DEV_INT_GROUP_TYPE(mounted_snapshots, dev);
+NILFS_DEV_INT_GROUP_FNS(mounted_snapshots, dev);
+
+/************************************************************************
  *                      NILFS checkpoints attrs                         *
  ************************************************************************/
 
@@ -828,10 +854,14 @@ int nilfs_sysfs_create_device_group(struct super_block *sb)
 	if (err)
 		goto free_dev_subgroups;
 
-	err = nilfs_sysfs_create_checkpoints_group(nilfs);
+	err = nilfs_sysfs_create_mounted_snapshots_group(nilfs);
 	if (err)
 		goto cleanup_dev_kobject;
 
+	err = nilfs_sysfs_create_checkpoints_group(nilfs);
+	if (err)
+		goto delete_mounted_snapshots_group;
+
 	err = nilfs_sysfs_create_segments_group(nilfs);
 	if (err)
 		goto delete_checkpoints_group;
@@ -855,6 +885,9 @@ delete_segments_group:
 delete_checkpoints_group:
 	nilfs_sysfs_delete_checkpoints_group(nilfs);
 
+delete_mounted_snapshots_group:
+	nilfs_sysfs_delete_mounted_snapshots_group(nilfs);
+
 cleanup_dev_kobject:
 	kobject_del(&nilfs->ns_dev_kobj);
 
@@ -867,6 +900,7 @@ failed_create_device_group:
 
 void nilfs_sysfs_delete_device_group(struct the_nilfs *nilfs)
 {
+	nilfs_sysfs_delete_mounted_snapshots_group(nilfs);
 	nilfs_sysfs_delete_checkpoints_group(nilfs);
 	nilfs_sysfs_delete_segments_group(nilfs);
 	nilfs_sysfs_delete_superblock_group(nilfs);
diff --git a/fs/nilfs2/sysfs.h b/fs/nilfs2/sysfs.h
index 2ffaa69..f8ba9b6 100644
--- a/fs/nilfs2/sysfs.h
+++ b/fs/nilfs2/sysfs.h
@@ -28,6 +28,8 @@
  * @sg_superblock_kobj_unregister: completion state
  * @sg_segctor_kobj: /sys/fs/nilfs/<device>/segctor
  * @sg_segctor_kobj_unregister: completion state
+ * @sg_mounted_snapshots_kobj: /sys/fs/nilfs/<device>/mounted_snapshots
+ * @sg_mounted_snapshots_kobj_unregister: completion state
  * @sg_checkpoints_kobj: /sys/fs/nilfs/<device>/checkpoints
  * @sg_checkpoints_kobj_unregister: completion state
  * @sg_segments_kobj: /sys/fs/nilfs/<device>/segments
@@ -42,6 +44,10 @@ struct nilfs_sysfs_dev_subgroups {
 	struct kobject sg_segctor_kobj;
 	struct completion sg_segctor_kobj_unregister;
 
+	/* /sys/fs/nilfs/<device>/mounted_snapshots */
+	struct kobject sg_mounted_snapshots_kobj;
+	struct completion sg_mounted_snapshots_kobj_unregister;
+
 	/* /sys/fs/nilfs/<device>/checkpoints */
 	struct kobject sg_checkpoints_kobj;
 	struct completion sg_checkpoints_kobj_unregister;
@@ -73,6 +79,7 @@ struct nilfs_##name##_attr { \
 
 NILFS_DEV_ATTR_STRUCT(dev);
 NILFS_DEV_ATTR_STRUCT(segments);
+NILFS_DEV_ATTR_STRUCT(mounted_snapshots);
 NILFS_DEV_ATTR_STRUCT(checkpoints);
 NILFS_DEV_ATTR_STRUCT(superblock);
 NILFS_DEV_ATTR_STRUCT(segctor);
@@ -109,6 +116,9 @@ NILFS_DEV_ATTR_STRUCT(segctor);
 #define NILFS_SEGMENTS_RW_ATTR(name) \
 	NILFS_RW_ATTR(segs_info, name)
 
+#define NILFS_MOUNTED_SNAPSHOTS_RO_ATTR(name) \
+	NILFS_RO_ATTR(mounted_snapshots, name)
+
 #define NILFS_CHECKPOINTS_RO_ATTR(name) \
 	NILFS_RO_ATTR(checkpoints, name)
 #define NILFS_CHECKPOINTS_RW_ATTR(name) \
@@ -132,6 +142,8 @@ NILFS_DEV_ATTR_STRUCT(segctor);
 	(&nilfs_dev_attr_##name.attr)
 #define NILFS_SEGMENTS_ATTR_LIST(name) \
 	(&nilfs_segments_attr_##name.attr)
+#define NILFS_MOUNTED_SNAPSHOTS_ATTR_LIST(name) \
+	(&nilfs_mounted_snapshots_attr_##name.attr)
 #define NILFS_CHECKPOINTS_ATTR_LIST(name) \
 	(&nilfs_checkpoints_attr_##name.attr)
 #define NILFS_SUPERBLOCK_ATTR_LIST(name) \
-- 
1.7.9.5


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
