From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 5/9] nilfs2: add /sys/fs/nilfs/<device>/segments group
Date: Fri, 04 Apr 2014 19:13:40 +0400
Message-ID: <1396624420.2215.38.camel@slavad-CELSIUS-H720>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:From:Subject:Message-ID; bh=EcSORaKreQdFbL3PHDl33MPD+t575DYWfyTbSSmhcb8=;
	b=r5wr6QsxDvmqzHaS2JrC9aqQWRne8XNYL5PicLsGtXzvcaX+B6suEjThAqGS6dQlz6e4W2Ib3gE8o+RTMrSVrtdd8zWX3E64111LDDaKeoFHq7F20Bb5St/HMgBTrmHw;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org

From: Vyacheslav Dubeyko <Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org>
Subject: [PATCH 5/9] nilfs2: add /sys/fs/nilfs/<device>/segments group

This patch adds creation of /sys/fs/nilfs/<device>/segments
group.

The segments group contains attributes that describe
details about volume's segments:
(1) segments_number - show number of segments on volume.
(2) blocks_per_segment - show number of blocks in segment.
(3) clean_segments - show count of clean segments.
(4) dirty_segments - show count of dirty segments.

Signed-off-by: Vyacheslav Dubeyko <Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org>
CC: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/sysfs.c |   99 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/nilfs2/sysfs.h |   14 ++++++++
 2 files changed, 112 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index 347ee80..9f6a7c8 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -122,6 +122,95 @@ void nilfs_sysfs_delete_##name##_group(struct the_nilfs *nilfs) \
 }
 
 /************************************************************************
+ *                        NILFS segments attrs                          *
+ ************************************************************************/
+
+static ssize_t
+nilfs_segments_segments_number_show(struct nilfs_segments_attr *attr,
+				     struct the_nilfs *nilfs,
+				     char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%lu\n", nilfs->ns_nsegments);
+}
+
+static ssize_t
+nilfs_segments_blocks_per_segment_show(struct nilfs_segments_attr *attr,
+					struct the_nilfs *nilfs,
+					char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%lu\n", nilfs->ns_blocks_per_segment);
+}
+
+static ssize_t
+nilfs_segments_clean_segments_show(struct nilfs_segments_attr *attr,
+				    struct the_nilfs *nilfs,
+				    char *buf)
+{
+	unsigned long ncleansegs;
+
+	down_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
+	ncleansegs = nilfs_sufile_get_ncleansegs(nilfs->ns_sufile);
+	up_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
+
+	return snprintf(buf, PAGE_SIZE, "%lu\n", ncleansegs);
+}
+
+static ssize_t
+nilfs_segments_dirty_segments_show(struct nilfs_segments_attr *attr,
+				    struct the_nilfs *nilfs,
+				    char *buf)
+{
+	struct nilfs_sustat sustat;
+	int err;
+
+	down_read(&nilfs->ns_segctor_sem);
+	err = nilfs_sufile_get_stat(nilfs->ns_sufile, &sustat);
+	up_read(&nilfs->ns_segctor_sem);
+	if (err < 0) {
+		printk(KERN_ERR "NILFS: unable to get segment stat: err=%d\n",
+			err);
+		return err;
+	}
+
+	return snprintf(buf, PAGE_SIZE, "%llu\n", sustat.ss_ndirtysegs);
+}
+
+static const char segments_readme_str[] =
+	"The segments group contains attributes that describe\n"
+	"details about volume's segments.\n\n"
+	"(1) segments_number\n\tshow number of segments on volume.\n\n"
+	"(2) blocks_per_segment\n\tshow number of blocks in segment.\n\n"
+	"(3) clean_segments\n\tshow count of clean segments.\n\n"
+	"(4) dirty_segments\n\tshow count of dirty segments.\n\n";
+
+static ssize_t
+nilfs_segments_README_show(struct nilfs_segments_attr *attr,
+			    struct the_nilfs *nilfs,
+			    char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, segments_readme_str);
+}
+
+NILFS_SEGMENTS_RO_ATTR(segments_number);
+NILFS_SEGMENTS_RO_ATTR(blocks_per_segment);
+NILFS_SEGMENTS_RO_ATTR(clean_segments);
+NILFS_SEGMENTS_RO_ATTR(dirty_segments);
+NILFS_SEGMENTS_RO_ATTR(README);
+
+static struct attribute *nilfs_segments_attrs[] = {
+	NILFS_SEGMENTS_ATTR_LIST(segments_number),
+	NILFS_SEGMENTS_ATTR_LIST(blocks_per_segment),
+	NILFS_SEGMENTS_ATTR_LIST(clean_segments),
+	NILFS_SEGMENTS_ATTR_LIST(dirty_segments),
+	NILFS_SEGMENTS_ATTR_LIST(README),
+	NULL,
+};
+
+NILFS_DEV_INT_GROUP_OPS(segments, dev);
+NILFS_DEV_INT_GROUP_TYPE(segments, dev);
+NILFS_DEV_INT_GROUP_FNS(segments, dev);
+
+/************************************************************************
  *                        NILFS segctor attrs                           *
  ************************************************************************/
 
@@ -626,10 +715,14 @@ int nilfs_sysfs_create_device_group(struct super_block *sb)
 	if (err)
 		goto free_dev_subgroups;
 
-	err = nilfs_sysfs_create_superblock_group(nilfs);
+	err = nilfs_sysfs_create_segments_group(nilfs);
 	if (err)
 		goto cleanup_dev_kobject;
 
+	err = nilfs_sysfs_create_superblock_group(nilfs);
+	if (err)
+		goto delete_segments_group;
+
 	err = nilfs_sysfs_create_segctor_group(nilfs);
 	if (err)
 		goto delete_superblock_group;
@@ -639,6 +732,9 @@ int nilfs_sysfs_create_device_group(struct super_block *sb)
 delete_superblock_group:
 	nilfs_sysfs_delete_superblock_group(nilfs);
 
+delete_segments_group:
+	nilfs_sysfs_delete_segments_group(nilfs);
+
 cleanup_dev_kobject:
 	kobject_del(&nilfs->ns_dev_kobj);
 
@@ -651,6 +747,7 @@ failed_create_device_group:
 
 void nilfs_sysfs_delete_device_group(struct the_nilfs *nilfs)
 {
+	nilfs_sysfs_delete_segments_group(nilfs);
 	nilfs_sysfs_delete_superblock_group(nilfs);
 	nilfs_sysfs_delete_segctor_group(nilfs);
 	kobject_del(&nilfs->ns_dev_kobj);
diff --git a/fs/nilfs2/sysfs.h b/fs/nilfs2/sysfs.h
index 0ed945c..66dae66 100644
--- a/fs/nilfs2/sysfs.h
+++ b/fs/nilfs2/sysfs.h
@@ -28,6 +28,8 @@
  * @sg_superblock_kobj_unregister: completion state
  * @sg_segctor_kobj: /sys/fs/nilfs/<device>/segctor
  * @sg_segctor_kobj_unregister: completion state
+ * @sg_segments_kobj: /sys/fs/nilfs/<device>/segments
+ * @sg_segments_kobj_unregister: completion state
  */
 struct nilfs_sysfs_dev_subgroups {
 	/* /sys/fs/nilfs/<device>/superblock */
@@ -37,6 +39,10 @@ struct nilfs_sysfs_dev_subgroups {
 	/* /sys/fs/nilfs/<device>/segctor */
 	struct kobject sg_segctor_kobj;
 	struct completion sg_segctor_kobj_unregister;
+
+	/* /sys/fs/nilfs/<device>/segments */
+	struct kobject sg_segments_kobj;
+	struct completion sg_segments_kobj_unregister;
 };
 
 #define NILFS_COMMON_ATTR_STRUCT(name) \
@@ -60,6 +66,7 @@ struct nilfs_##name##_attr { \
 };
 
 NILFS_DEV_ATTR_STRUCT(dev);
+NILFS_DEV_ATTR_STRUCT(segments);
 NILFS_DEV_ATTR_STRUCT(superblock);
 NILFS_DEV_ATTR_STRUCT(segctor);
 
@@ -90,6 +97,11 @@ NILFS_DEV_ATTR_STRUCT(segctor);
 #define NILFS_DEV_RW_ATTR(name) \
 	NILFS_RW_ATTR(dev, name)
 
+#define NILFS_SEGMENTS_RO_ATTR(name) \
+	NILFS_RO_ATTR(segments, name)
+#define NILFS_SEGMENTS_RW_ATTR(name) \
+	NILFS_RW_ATTR(segs_info, name)
+
 #define NILFS_SUPERBLOCK_RO_ATTR(name) \
 	NILFS_RO_ATTR(superblock, name)
 #define NILFS_SUPERBLOCK_RW_ATTR(name) \
@@ -106,6 +118,8 @@ NILFS_DEV_ATTR_STRUCT(segctor);
 	(&nilfs_feature_attr_##name.attr)
 #define NILFS_DEV_ATTR_LIST(name) \
 	(&nilfs_dev_attr_##name.attr)
+#define NILFS_SEGMENTS_ATTR_LIST(name) \
+	(&nilfs_segments_attr_##name.attr)
 #define NILFS_SUPERBLOCK_ATTR_LIST(name) \
 	(&nilfs_superblock_attr_##name.attr)
 #define NILFS_SEGCTOR_ATTR_LIST(name) \
-- 
1.7.9.5


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
