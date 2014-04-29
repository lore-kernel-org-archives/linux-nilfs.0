From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 1/9] nilfs2: add /sys/fs/nilfs2/features group
Date: Tue, 29 Apr 2014 19:17:35 +0400
Message-ID: <1398784655.2185.67.camel@slavad-CELSIUS-H720>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:From:Subject:Message-ID; bh=jaf6GfzJgplGvwadGhHFW3vJigmYWq09r9j9irstzDE=;
	b=d8KDwTynV3cSQ9Nk4dteln8uxCflS++ankMSaD2F20cSx2uZYqldGj5PtRE0Pvs76SmvhDWbMC6+dQm+xoLf07hR4EBV+xmu7m6Uq5wzsBZ3F/nHTUy6MADIMfFJl1OJ;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org, "Michael L. Semon" <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

From: Vyacheslav Dubeyko <Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org>
Subject: [PATCH v3 1/9] nilfs2: add /sys/fs/nilfs2/features group

This patch adds code of creation /sys/fs/nilfs2 group and
/sys/fs/nilfs2/features group.

The features group contains attributes that describe NILFS
file system driver features:
(1) revision - show current revision of NILFS file system driver.

There are two formats of timestamp output - seconds and
human-readable format. Every showed timestamp has two sysfs
files (time-<xxx> and time-<xxx>-secs). One sysfs file
(time-<xxx>) shows time in human-readable format. Another
sysfs file (time-<xxx>-secs) shows time in seconds.

It was reported by Michael L. Semon <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> that
timestamp output in human-readable format should be changed
from "2014-4-12 14:5:38" to "2014-04-12 14:05:38". Second
version of the patch fixes this issue.

Reported-by: Michael L. Semon <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Vyacheslav Dubeyko <Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org>
CC: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 Documentation/ABI/testing/sysfs-fs-nilfs2 |   16 ++++
 fs/nilfs2/sysfs.c                         |  121 +++++++++++++++++++++++++++++
 fs/nilfs2/sysfs.h                         |   59 ++++++++++++++
 3 files changed, 196 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-fs-nilfs2
 create mode 100644 fs/nilfs2/sysfs.c
 create mode 100644 fs/nilfs2/sysfs.h

diff --git a/Documentation/ABI/testing/sysfs-fs-nilfs2 b/Documentation/ABI/testing/sysfs-fs-nilfs2
new file mode 100644
index 0000000..2e2a6df
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-fs-nilfs2
@@ -0,0 +1,16 @@
+
+What:		/sys/fs/nilfs2/features/revision
+Date:		April 2014
+KernelVersion:	3.15
+Contact:	"Vyacheslav Dubeyko" <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
+Description:
+		Show current revision of NILFS file system driver.
+		This value informs about file system revision that
+		driver is ready to support.
+
+What:		/sys/fs/nilfs2/features/README
+Date:		April 2014
+KernelVersion:	3.15
+Contact:	"Vyacheslav Dubeyko" <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
+Description:
+		Describe attributes of /sys/fs/nilfs2/features group.
diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
new file mode 100644
index 0000000..8d025b7
--- /dev/null
+++ b/fs/nilfs2/sysfs.c
@@ -0,0 +1,121 @@
+/*
+ * sysfs.c - sysfs support implementation.
+ *
+ * Copyright (C) 2005-2014 Nippon Telegraph and Telephone Corporation.
+ * Copyright (C) 2014 HGST, Inc., a Western Digital Company.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * Written by Vyacheslav Dubeyko <Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org>
+ */
+
+#include <linux/kobject.h>
+
+#include "nilfs.h"
+#include "mdt.h"
+#include "sufile.h"
+#include "cpfile.h"
+#include "sysfs.h"
+
+/* /sys/fs/<nilfs>/ */
+static struct kset *nilfs_kset;
+
+#define NILFS_SHOW_TIME(time_t_val, buf) ({ \
+		struct tm res; \
+		int count = 0; \
+		time_to_tm(time_t_val, 0, &res); \
+		res.tm_year += 1900; \
+		res.tm_mon += 1; \
+		count = scnprintf(buf, PAGE_SIZE, \
+				    "%ld-%.2d-%.2d %.2d:%.2d:%.2d\n", \
+				    res.tm_year, res.tm_mon, res.tm_mday, \
+				    res.tm_hour, res.tm_min, res.tm_sec);\
+		count; \
+})
+
+/************************************************************************
+ *                        NILFS feature attrs                           *
+ ************************************************************************/
+
+static ssize_t nilfs_feature_revision_show(struct kobject *kobj,
+					    struct attribute *attr, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d.%d\n",
+			NILFS_CURRENT_REV, NILFS_MINOR_REV);
+}
+
+static const char features_readme_str[] =
+	"The features group contains attributes that describe NILFS file\n"
+	"system driver features.\n\n"
+	"(1) revision\n\tshow current revision of NILFS file system driver.\n";
+
+static ssize_t nilfs_feature_README_show(struct kobject *kobj,
+					 struct attribute *attr,
+					 char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, features_readme_str);
+}
+
+NILFS_FEATURE_RO_ATTR(revision);
+NILFS_FEATURE_RO_ATTR(README);
+
+static struct attribute *nilfs_feature_attrs[] = {
+	NILFS_FEATURE_ATTR_LIST(revision),
+	NILFS_FEATURE_ATTR_LIST(README),
+	NULL,
+};
+
+static const struct attribute_group nilfs_feature_attr_group = {
+	.name = "features",
+	.attrs = nilfs_feature_attrs,
+};
+
+int __init nilfs_sysfs_init(void)
+{
+	char *name = "nilfs\0\0";
+	int len;
+	int err;
+
+	len = snprintf(name + strlen(name), 2, "%d", NILFS_CURRENT_REV);
+	if (len != 1) {
+		err = -EINVAL;
+		goto failed_sysfs_init;
+	}
+
+	nilfs_kset = kset_create_and_add(name, NULL, fs_kobj);
+	if (!nilfs_kset) {
+		err = -ENOMEM;
+		printk(KERN_ERR "NILFS: unable to create sysfs entry: err %d\n",
+			err);
+		goto failed_sysfs_init;
+	}
+
+	err = sysfs_create_group(&nilfs_kset->kobj, &nilfs_feature_attr_group);
+	if (unlikely(err)) {
+		printk(KERN_ERR "NILFS: unable to create feature group: err %d\n",
+			err);
+		goto cleanup_sysfs_init;
+	}
+
+	return 0;
+
+cleanup_sysfs_init:
+	kset_unregister(nilfs_kset);
+
+failed_sysfs_init:
+	return err;
+}
+
+void nilfs_sysfs_exit(void)
+{
+	sysfs_remove_group(&nilfs_kset->kobj, &nilfs_feature_attr_group);
+	kset_unregister(nilfs_kset);
+}
diff --git a/fs/nilfs2/sysfs.h b/fs/nilfs2/sysfs.h
new file mode 100644
index 0000000..b3ba2e4
--- /dev/null
+++ b/fs/nilfs2/sysfs.h
@@ -0,0 +1,59 @@
+/*
+ * sysfs.h - sysfs support declarations.
+ *
+ * Copyright (C) 2005-2014 Nippon Telegraph and Telephone Corporation.
+ * Copyright (C) 2014 HGST, Inc., a Western Digital Company.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * Written by Vyacheslav Dubeyko <Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org>
+ */
+
+#ifndef _NILFS_SYSFS_H
+#define _NILFS_SYSFS_H
+
+#include <linux/sysfs.h>
+
+#define NILFS_COMMON_ATTR_STRUCT(name) \
+struct nilfs_##name##_attr { \
+	struct attribute attr; \
+	ssize_t (*show)(struct kobject *, struct attribute *, \
+			char *); \
+	ssize_t (*store)(struct kobject *, struct attribute *, \
+			 const char *, size_t); \
+};
+
+NILFS_COMMON_ATTR_STRUCT(feature);
+
+#define NILFS_ATTR(type, name, mode, show, store) \
+	static struct nilfs_##type##_attr nilfs_##type##_attr_##name = \
+		__ATTR(name, mode, show, store)
+
+#define NILFS_INFO_ATTR(type, name) \
+	NILFS_ATTR(type, name, 0444, NULL, NULL)
+#define NILFS_RO_ATTR(type, name) \
+	NILFS_ATTR(type, name, 0444, nilfs_##type##_##name##_show, NULL)
+#define NILFS_RW_ATTR(type, name) \
+	NILFS_ATTR(type, name, 0644, \
+		    nilfs_##type##_##name##_show, \
+		    nilfs_##type##_##name##_store)
+
+#define NILFS_FEATURE_INFO_ATTR(name) \
+	NILFS_INFO_ATTR(feature, name)
+#define NILFS_FEATURE_RO_ATTR(name) \
+	NILFS_RO_ATTR(feature, name)
+#define NILFS_FEATURE_RW_ATTR(name) \
+	NILFS_RW_ATTR(feature, name)
+
+#define NILFS_FEATURE_ATTR_LIST(name) \
+	(&nilfs_feature_attr_##name.attr)
+
+#endif /* _NILFS_SYSFS_H */
-- 
1.7.9.5


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
