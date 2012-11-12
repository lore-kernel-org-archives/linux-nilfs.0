From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v4 08/15] nilfs-utils: fsck: add fsck internal declarations
Date: Mon, 12 Nov 2012 13:36:35 +0400
Message-ID: <1352712995.2555.43.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:To:From:Subject:Message-ID; bh=oy7TnJ0Pv0pj12lB2TWaEwKdqm7DtC7xKuTiQfDPSqI=;
	b=PAPwc0k3j7mzshcGyqHQ6hmN3IP++6F/rP3aIgU70ro7uP6hQ7ZfYdqAiz+UDGdzdivBqfDTo3i+s2YvHcLjquRojRZashlehXzNgHFYQTFg/DvhGl0JKYfs9t8egDK4;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

This patch adds fsck_common.h file with fsck internal declarations.

With the best regards,
Vyacheslav Dubeyko.
--
From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v4 08/15] nilfs-utils: fsck: add fsck internal declarations

This patch adds fsck_common.h file with fsck internal declarations.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
 sbin/fsck/fsck_common.h |  119 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 119 insertions(+)
 create mode 100644 sbin/fsck/fsck_common.h

diff --git a/sbin/fsck/fsck_common.h b/sbin/fsck/fsck_common.h
new file mode 100644
index 0000000..679bf7a
--- /dev/null
+++ b/sbin/fsck/fsck_common.h
@@ -0,0 +1,119 @@
+/*
+ * fsck_common.h - NILFS fsck application-related declarations
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
+#ifndef FSCK_COMMON_H
+#define FSCK_COMMON_H
+
+#include "nilfs.h"
+#include "nilfs_messages.h"
+#include "fsck_nilfs2.h"
+
+#define FSCK_VERSION "v.0.04-under-development"
+
+#define UNDEFINED_SNAPSHOT -1
+
+/*
+ * struct nilfs_segment_reference
+ *
+ * Item of array that defines references of segments
+ * on each other in sequence.
+ *
+ * @prev_seg: previous segment number.
+ * @next_seg: next segment number.
+ * @seg_seq_id: segment sequence number.
+ * @logs_count: count of logs in segment
+ *
+ */
+struct nilfs_segment_reference {
+	__u64 prev_seg;
+	__u64 next_seg;
+	__u64 seg_seq_id;
+	__u32 logs_count;
+}; /* struct nilfs_segment_reference */
+
+/*
+ * struct log_check
+ */
+struct log_check {
+	union {
+		__u16 check_mask;
+		__u16 errs_bmp;
+	} ss_hdr;
+}; /* struct log_check */
+
+/*
+ * struct segment_check
+ */
+struct segment_check {
+	struct log_check *logs;
+	__u32 logs_count;
+}; /* struct segment_check */
+
+/*
+ * struct fsck_check
+ *
+ * Defines what should check and return errors.
+ * For every item check_mask is prepared before
+ * checking. It needs to check only items which
+ * flags were been set. If checking item is
+ * valid then proper bit is unset in errors_bitmap.
+ */
+struct fsck_check {
+/* Volume at whole section */
+	union {
+		__u64 check_mask;
+		__u64 errs_bmp;
+	} volume;
+/* Superblock section */
+	union {
+		__u64 check_mask;
+		__u64 errs_bmp;
+	} sb[SUPERBLOCK_TYPES_NUMBER];
+/* Segments section */
+	struct segment_check *segments;
+	__u64 segs_count;
+}; /* struct fsck_check */
+
+/* libmountchk function */
+extern int check_mount(const char *device);
+
+/* Current mode of fsck working */
+extern int fsck_work_mode;
+
+/* Defines what should check and keeps errors */
+extern struct fsck_check detected_err_db;
+
+/* Array of pointers on NILFS volume's superblocks */
+extern struct nilfs_super_block *superblocks[SUPERBLOCK_TYPES_NUMBER];
+
+/* NILFS object for library API accessing */
+extern struct nilfs *nilfs_object_ptr;
+
+/* Pointer on segment references array */
+extern struct nilfs_segment_reference *seg_refs_array_ptr;
+
+/* Pointer on segments bitmap */
+extern int *segments_bitmap_ptr;
+
+#endif /* FSCK_COMMON_H */
-- 
1.7.9.5


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
