From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v4 12/15] nilfs-utils: fsck: add skeleton of functionality
 for file system hierarchy checking
Date: Mon, 12 Nov 2012 13:37:28 +0400
Message-ID: <1352713048.2555.47.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:To:From:Subject:Message-ID; bh=SFefIGEqdAOmEbuLBRX6+QAL5pxz/JxWryETGyf8uMc=;
	b=a/Qlouyxc7gtLcPq+WA1ZEJZznq0KSuHWbHrArS06IiUxjMml/mFFDrDNQ6pGrkjrHNp8UYJTukChHEfkgLcE0mkDlAefXch11hmBh++u7z+MjoolixyCrA3xNAlnDZM;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

This patch adds skeleton of functionality for file system hierarchy checking.

With the best regards,
Vyacheslav Dubeyko.
--
From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v4 12/15] nilfs-utils: fsck: add skeleton of functionality for file system hierarchy checking

This patch adds skeleton of functionality for file system hierarchy checking.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
 sbin/fsck/nilfs_fs_hierarchy.c |   73 ++++++++++++++++++++++++++++++++++++++++
 sbin/fsck/nilfs_fs_hierarchy.h |   38 +++++++++++++++++++++
 2 files changed, 111 insertions(+)
 create mode 100644 sbin/fsck/nilfs_fs_hierarchy.c
 create mode 100644 sbin/fsck/nilfs_fs_hierarchy.h

diff --git a/sbin/fsck/nilfs_fs_hierarchy.c b/sbin/fsck/nilfs_fs_hierarchy.c
new file mode 100644
index 0000000..02570c1
--- /dev/null
+++ b/sbin/fsck/nilfs_fs_hierarchy.c
@@ -0,0 +1,73 @@
+/*
+ * nilfs_fs_hierarchy.c - NILFS file system hierarchy checking, processing
+ *                        and recovering operations implementation
+ *
+ * Copyright (C) 2012 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
+ *
+ * This file is part of NILFS.
+ *
+ * NILFS is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * NILFS is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with NILFS; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
+ */
+
+#include "fsck_common.h"
+#include "fsck_raw_ops.h"
+
+#include "nilfs_fs_hierarchy.h"
+
+/*****************************************************************************
+ * FUNCTIONS DECLARATION
+ *****************************************************************************/
+
+/*****************************************************************************
+ * IMPLEMENTATION SECTION
+ *****************************************************************************/
+
+/*****************************************************************************
+ * NAME:  fs_hierarchy_check_for_snapshot (fsck.nilfs2)
+ *
+ * FUNCTION:  It checks validity of file system hierarchy for snapshot number.
+ *            It means that it takes into account all changes were made
+ *            before (and inclusive) requested snapshot. This function builds
+ *            block bitmap on the basis of inodes info. Also it builds
+ *            inode bitmap on the basis of hierarchy tree traversing.
+ *
+ * PARAMETERS:
+ * @snapshot: Snapshot number for check.
+ *
+ * RETURNS:
+ * NILFS_OK - File system hierarchy was checked successfully.
+ * %-CANNOT_CHECK_FS_HIERARCHY - FS hierarchy checking fails.
+ * %-INVALID_PARAMETER - Input parameters are invalid.
+ */
+int fs_hierarchy_check_for_snapshot(__u64 snapshot)
+{
+	int err = NILFS_OK;
+
+	internal_debug("begin to check fs hierarchy: %lld.", snapshot);
+
+	/*if (UNDEFINED_SNAPSHOT == snapshot ||
+			snapshot > last_snapshot_number()) {
+		internal_debug("%s",
+			nilfs_message[INVALID_PARAMETER]);
+		return -INVALID_PARAMETER;
+	}*/
+
+	/*internal_info("<%s>: %s", __func__, nilfs_message[NOT_IMPLEMENTED]);*/
+
+	/* <TODO: implement> */
+	return err;
+} /* fs_hierarchy_check_for_snapshot() */
diff --git a/sbin/fsck/nilfs_fs_hierarchy.h b/sbin/fsck/nilfs_fs_hierarchy.h
new file mode 100644
index 0000000..e7f1370
--- /dev/null
+++ b/sbin/fsck/nilfs_fs_hierarchy.h
@@ -0,0 +1,38 @@
+/*
+ * nilfs_fs_hierarchy.h - Declarations of operations for NILFS file system
+ *                        hierarchy checking, processing and recovering
+ *
+ * Copyright (C) 2012 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
+ *
+ * This file is part of NILFS.
+ *
+ * NILFS is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * NILFS is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with NILFS; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
+ */
+
+#ifndef NILFS_FS_HIERARCHY_H
+#define NILFS_FS_HIERARCHY_H
+
+/*
+ * It checks validity of file system hierarchy for snapshot number.
+ * It means that it takes into account all changes were made
+ * before (and inclusive) requested snapshot. This function builds
+ * block bitmap on the basis of inodes info. Also it builds
+ * inode bitmap on the basis of hierarchy tree traversing.
+ */
+int fs_hierarchy_check_for_snapshot(__u64 snapshot);
+
+#endif /* NILFS_FS_HIERARCHY_H */
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
