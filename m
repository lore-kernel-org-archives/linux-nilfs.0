From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v4 11/15] nilfs-utils: fsck: add skeleton of functionality
 for checkpoints checking
Date: Mon, 12 Nov 2012 13:37:17 +0400
Message-ID: <1352713037.2555.46.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:To:From:Subject:Message-ID; bh=Xx3SZXW/xpa2Basmkxz9AZPgKqNdqEBGtk8ZzDOXtLg=;
	b=gnAFdLPZ8uwG8NMxqdON91o7tmUwVk4adYM9KD5k/+I9hx/51XqAm7NzUn8G1+ulgs6G+HN6isoG3+i6bRq7eCe1lC830N58ZMzeUHTXW/qyInHjEmJIRN7K4tWHQhEJ;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

This patch adds skeleton of functionality for checkpoints checking.

With the best regards,
Vyacheslav Dubeyko.
--
From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v4 11/15] nilfs-utils: fsck: add skeleton of functionality for checkpoints checking

This patch adds skeleton of functionality for checkpoints checking.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
 sbin/fsck/nilfs_checkpoint.c |  154 ++++++++++++++++++++++++++++++++++++++++++
 sbin/fsck/nilfs_checkpoint.h |   50 ++++++++++++++
 2 files changed, 204 insertions(+)
 create mode 100644 sbin/fsck/nilfs_checkpoint.c
 create mode 100644 sbin/fsck/nilfs_checkpoint.h

diff --git a/sbin/fsck/nilfs_checkpoint.c b/sbin/fsck/nilfs_checkpoint.c
new file mode 100644
index 0000000..5476876
--- /dev/null
+++ b/sbin/fsck/nilfs_checkpoint.c
@@ -0,0 +1,154 @@
+/*
+ * nilfs_checkpoint.c - NILFS checkpoints and snapshots checking,
+ *                      processing and recovering operations implementation
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
+#include "nilfs_checkpoint.h"
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
+ * NAME:  first_snapshot_number (fsck.nilfs2)
+ *
+ * FUNCTION:  Get first snapshot number in the list.
+ *
+ * RETURNS:
+ * A. First snapshot number in the case of success.
+ * B. The UNDEFINED_SNAPSHOT in the case of failure.
+ */
+__u64 first_snapshot_number(void)
+{
+	/*internal_info("<%s>: %s", __func__, nilfs_message[NOT_IMPLEMENTED]);*/
+	/* <TODO: implement> */
+	return UNDEFINED_SNAPSHOT;
+} /* first_snapshot_number() */
+
+/*****************************************************************************
+ * NAME:  next_snapshot_number (fsck.nilfs2)
+ *
+ * FUNCTION:  Get next snapshot number in the list.
+ *
+ * PARAMETERS:
+ * @prev_snapshot: Number of previous snapshot in the list.
+ *
+ * RETURNS:
+ * A. Next snapshot number in the case of success.
+ * B. UNDEFINED_SNAPSHOT in the case of failure or empty list.
+ * C. Last snapshot number in the case of equality of @prev_snapshot to
+ *    last snapshot number.
+ */
+__u64 next_snapshot_number(__u64 prev_snapshot)
+{
+	if (UNDEFINED_SNAPSHOT == prev_snapshot)
+		return UNDEFINED_SNAPSHOT;
+
+	if (0 == snapshots_count())
+		return UNDEFINED_SNAPSHOT;
+
+	if (prev_snapshot == last_snapshot_number())
+		return prev_snapshot;
+
+	if (prev_snapshot > last_snapshot_number())
+		return UNDEFINED_SNAPSHOT;
+
+	/*internal_info("<%s>: %s", __func__, nilfs_message[NOT_IMPLEMENTED]);*/
+
+	/* <TODO: implement > */
+	return UNDEFINED_SNAPSHOT;
+} /* next_snapshot_number() */
+
+/*****************************************************************************
+ * NAME:  last_snapshot_number (fsck.nilfs2)
+ *
+ * FUNCTION:  Get last snapshot number in the list.
+ *
+ * RETURNS:
+ * A. First snapshot number in the case of success.
+ * B. The UNDEFINED_SNAPSHOT in the case of failure.
+ */
+__u64 last_snapshot_number(void)
+{
+	/*internal_info("<%s>: %s", __func__, nilfs_message[NOT_IMPLEMENTED]);*/
+	/* <TODO: implement > */
+	return UNDEFINED_SNAPSHOT;
+} /* last_snapshot_number() */
+
+/*****************************************************************************
+ * NAME:  snapshots_count (fsck.nilfs2)
+ *
+ * FUNCTION:  Get snapshots count in the list.
+ *
+ * RETURNS:
+ * A. Snapshots count in the list for the case of success.
+ */
+__u64 snapshots_count(void)
+{
+	/*internal_info("<%s>: %s", __func__, nilfs_message[NOT_IMPLEMENTED]);*/
+	/* <TODO: implement > */
+	return 0;
+} /* snapshots_count() */
+
+/*****************************************************************************
+ * NAME:  check_snapshot (fsck.nilfs2)
+ *
+ * FUNCTION:  It checks validity of metadata structures for snapshot number.
+ *            It means that it takes into account all changes were made
+ *            before (and inclusive) requested snapshot. This function builds
+ *            block bitmap on the basis of DAT file information. Also it builds
+ *            inode bitmap on the basis of ifile information.
+ *
+ * PARAMETERS:
+ * @snapshot: Snapshot number for check.
+ *
+ * RETURNS:
+ * NILFS_OK - Snapshot was checked successfully.
+ * %-CANNOT_CHECK_SNAPSHOT - Snapshot checking fails because of internal error.
+ * %-INVALID_PARAMETER - Input parameters are invalid.
+ */
+int check_snapshot(__u64 snapshot)
+{
+	int err = NILFS_OK;
+
+	internal_debug("begin to check snapshot: %lld.", snapshot);
+
+	/*if (UNDEFINED_SNAPSHOT == snapshot ||
+			snapshot > last_snapshot_number()) {
+		internal_debug("<%s>: %s.",
+			__func__, nilfs_message[INVALID_PARAMETER]);
+		return -INVALID_PARAMETER;
+	}*/
+
+	/*internal_info("<%s>: %s", __func__, nilfs_message[NOT_IMPLEMENTED]);*/
+
+	/* <TODO: implement> */
+	return err;
+} /* check_snapshot() */
diff --git a/sbin/fsck/nilfs_checkpoint.h b/sbin/fsck/nilfs_checkpoint.h
new file mode 100644
index 0000000..3e951ad
--- /dev/null
+++ b/sbin/fsck/nilfs_checkpoint.h
@@ -0,0 +1,50 @@
+/*
+ * nilfs_checkpoint.h - Declarations of operations for NILFS checkpoints
+ *                      and snapshots checking, processing and recovering
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
+#ifndef NILFS_CHECKPOINT_H
+#define NILFS_CHECKPOINT_H
+
+/* Get first snapshot number in the list */
+__u64 first_snapshot_number(void);
+
+/* Get next snapshot number in the list */
+__u64 next_snapshot_number(__u64 prev_snapshot);
+
+/* Get last snapshot number in the list */
+__u64 last_snapshot_number(void);
+
+/* Get snapshots count in the list */
+__u64 snapshots_count(void);
+
+/*
+ * It checks validity of metadata structures for snapshot number.
+ * It means that it takes into account all changes were made
+ * before (and inclusive) requested snapshot. This function builds
+ * block bitmap on the basis of DAT file information. Also it builds
+ * inode bitmap on the basis of ifile information.
+ */
+int check_snapshot(__u64 snapshot);
+
+#endif /* NILFS_CHECKPOINT_H */
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
