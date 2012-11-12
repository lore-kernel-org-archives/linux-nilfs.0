From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v4 13/15] nilfs-utils: fsck: add skeleton of functionality
 for volume checking on final phase
Date: Mon, 12 Nov 2012 13:37:45 +0400
Message-ID: <1352713065.2555.48.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:To:From:Subject:Message-ID; bh=Nfo2egFulJGCYN4bT9D64e6rggTQqUONZ44dTHsv8oE=;
	b=sJPNVZMApAjOyJkGC6YAafJJaf3ZlRRhsSDeiFcTfnNzWaCmf3U1cfeuz5ykW84HQbADhqWYvHAIoKKV/NVL82zennOEs7Q+gmrs4BDetkYLJBj0TZlKkbCVXwvyyPdd;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

This patch adds skeleton of functionality for volume checking on final phase.

With the best regards,
Vyacheslav Dubeyko.
--
From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v4 13/15] nilfs-utils: fsck: add skeleton of functionality for volume checking on final phase

This patch adds skeleton of functionality for volume checking on final phase.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
 sbin/fsck/nilfs_volume_check.c |   71 ++++++++++++++++++++++++++++++++++++++++
 sbin/fsck/nilfs_volume_check.h |   45 +++++++++++++++++++++++++
 2 files changed, 116 insertions(+)
 create mode 100644 sbin/fsck/nilfs_volume_check.c
 create mode 100644 sbin/fsck/nilfs_volume_check.h

diff --git a/sbin/fsck/nilfs_volume_check.c b/sbin/fsck/nilfs_volume_check.c
new file mode 100644
index 0000000..229ed94
--- /dev/null
+++ b/sbin/fsck/nilfs_volume_check.c
@@ -0,0 +1,71 @@
+/*
+ * nilfs_volume_check.c - Implementation of operations for NILFS volume
+ *                        complex checking on the final phases
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
+#include "nilfs_volume_check.h"
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
+ * NAME:  compare_fs_hierarchy_and_snapshot_check (fsck.nilfs2)
+ *
+ * FUNCTION:  It needs to compare:
+ *            1. Block bitmaps:
+ *              1.A. Block bitmap builds on the basis of DAT file info.
+ *              1.B. Block bitmap builds on the basis of inodes info.
+ *            2. Block bitmap and array of used blocks in segments (sufile).
+ *            3. Inode bitmaps:
+ *              3.A. Inode bitmap builds on the basis of ifile.
+ *              3.B. Inode bitmap builds on the basis of hierarchy
+ *                   tree traversing.
+ *            4. Checkpoint and Snapshot bitmaps:
+ *              4.A. Checkpoint bitmap builds on the basis of array of
+ *                   checkpoints in cpfile.
+ *              4.B. Snapshot bitmap builds on the basis of snapshot list
+ *                   in cpfile.
+ *
+ * RETURNS:
+ * NILFS_OK - Comparizon of FS hierarchy and snapshot ends with success.
+ * %-CANNOT_CHECK_BY_COMPARE - Checking by different bitmaps comparison fails.
+ */
+int compare_fs_hierarchy_and_snapshot_check(void)
+{
+	int err = NILFS_OK;
+
+	internal_debug("%s", "check by means bipmaps comparing.");
+
+	/*internal_info("<%s>: %s", __func__, nilfs_message[NOT_IMPLEMENTED]);*/
+
+	/* <TODO: implement> */
+	return err;
+} /* compare_fs_hierarchy_and_snapshot_check */
diff --git a/sbin/fsck/nilfs_volume_check.h b/sbin/fsck/nilfs_volume_check.h
new file mode 100644
index 0000000..e896ef7
--- /dev/null
+++ b/sbin/fsck/nilfs_volume_check.h
@@ -0,0 +1,45 @@
+/*
+ * nilfs_volume_check.h - Declarations of operations for NILFS volume
+ *                        complex checking on the final phases
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
+#ifndef NILFS_VOLUME_CHECK_H
+#define NILFS_VOLUME_CHECK_H
+
+/*
+ * It needs to compare:
+ * 1. Block bitmaps:
+ *    1.A. Block bitmap builds on the basis of DAT file info.
+ *    1.B. Block bitmap builds on the basis of inodes info.
+ * 2. Block bitmap and array of used blocks in segments (sufile).
+ * 3. Inode bitmaps:
+ *    3.A. Inode bitmap builds on the basis of ifile.
+ *    3.B. Inode bitmap builds on the basis of hierarchy tree traversing.
+ * 4. Checkpoint and Snapshot bitmaps:
+ *    4.A. Checkpoint bitmap builds on the basis of array of checkpoints
+ *         in cpfile.
+ *    4.B. Snapshot bitmap builds on the basis of snapshot list in cpfile.
+ */
+int compare_fs_hierarchy_and_snapshot_check(void);
+
+#endif /* NILFS_VOLUME_CHECK_H */
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
