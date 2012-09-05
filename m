From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 08/11] nilfs-utils: fsck: add fsck_nilfs2.h file with fsck's constant declarations
Date: Wed, 5 Sep 2012 23:15:12 +0400
Message-ID: <5EFA5FDC-B31F-48EE-A1D4-5B6D783F362E@dubeyko.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:To:Message-Id:Date:Subject:Content-Transfer-Encoding:Content-Type:From; bh=oO+umuedDoTfv2gEN/VFq0ZrqwPGcntQLXifBfWcwqA=;
	b=Ip4Nx+2XvIPY6A3Q/Y/Lv0QPnCpwSx7wzp+PKfr/9V1tPB8A+VvECCcz9IRH58kd2+3AIAax2EiYZLfC+/0+ZcmiRqahv387wY5fpKbOZURMPv/Z4bndzN78E5VQYgac;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

This patch adds fsck_nilfs2.h file with fsck's constant declarations.

With the best regards,
Vyacheslav Dubeyko.
--
From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 08/11] nilfs-utils: fsck: add fsck_nilfs2.h file with fsck's constant declarations

This patch adds fsck_nilfs2.h file with fsck's constant declarations.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
 include/fsck_nilfs2.h |  111 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 111 insertions(+), 0 deletions(-)
 create mode 100644 include/fsck_nilfs2.h

diff --git a/include/fsck_nilfs2.h b/include/fsck_nilfs2.h
new file mode 100644
index 0000000..ff68788
--- /dev/null
+++ b/include/fsck_nilfs2.h
@@ -0,0 +1,111 @@
+/*
+ * fsck_nilfs2.h - NILFS fsck declarations
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
+#ifndef FSCK_NILFS2_H
+#define FSCK_NILFS2_H
+
+/* NILFS fsck exit codes. */
+enum fsck_exit_codes {
+	RETURN_FSCK_OK			= 0,
+	RETURN_FSCK_CORRECTED		= 1,
+	RETURN_FSCK_REBOOT		= 2,
+	RETURN_FSCK_ERRORS_UNCORRECTED	= 4,
+	RETURN_FSCK_OP_ERROR		= 8,
+	RETURN_FSCK_USAGE_ERROR		= 16,
+	EXIT_LIBRARY			= 128
+}; /* enum fsck_exit_codes */
+
+/* Available modes of fsck working */
+enum available_working_mode {
+	FSCK_RO_MODE			= 0x1,
+	FSCK_RW_MODE			= 0x2,
+	FSCK_RW_POLICY_MASK		= 0x3,
+}; /* enum available_working_mode */
+
+/* Type of NILFS superblocks */
+enum superblock_type {
+	PRIMARY_SUPERBLOCK,
+	SECONDARY_SUPERBLOCK,
+	SUPERBLOCK_TYPES_NUMBER
+}; /* enum superblock_type */
+
+/* Flags define what should be checked in superblock
+   Declaration order is crucial!!! */
+#define SB_CHECK_FLAGS_MAX_NUM 33
+enum sb_check_flags {
+	CHECK_SB_MAGIC			= 1ULL << 0,
+	CHECK_SB_REV_LEVEL		= 1ULL << 1,
+/*CRITICAL*/
+	CHECK_SB_BYTES			= 1ULL << 2,
+	CHECK_SB_CRC			= 1ULL << 3,
+	CHECK_SB_BLOCK_SZ		= 1ULL << 4,
+	CHECK_SB_DEV_SZ			= 1ULL << 5,
+	CHECK_SB_BLOCKS_PER_SEG		= 1ULL << 6,
+	CHECK_SB_NSEGMENTS		= 1ULL << 7,
+	CHECK_SB_FIRST_DATA_BLOCK	= 1ULL << 8,
+	CHECK_SB_R_SEGS_PERCENT		= 1ULL << 9,
+	CHECK_SB_LAST_CNO		= 1ULL << 10,
+	CHECK_SB_LAST_PSEG		= 1ULL << 11,
+	CHECK_SB_LAST_SEQ		= 1ULL << 12,
+	CHECK_SB_FREE_BLKS		= 1ULL << 13,
+	CHECK_SB_STATE			= 1ULL << 14,
+	CHECK_SB_FIRST_INO		= 1ULL << 15,
+	CHECK_SB_INODE_SZ		= 1ULL << 16,
+	CHECK_SB_DAT_ENTRY_SZ		= 1ULL << 17,
+	CHECK_SB_CHECKPOINT_SZ		= 1ULL << 18,
+	CHECK_SB_SEG_USAGE_SZ		= 1ULL << 19,
+/*MINOR*/
+	CHECK_SB_FEATURE		= 1ULL << 20,
+	CHECK_SB_RO_FEATURE		= 1ULL << 21,
+	CHECK_SB_FLAGS			= 1ULL << 22,
+	CHECK_SB_CREATOR_OS		= 1ULL << 23,
+	CHECK_SB_DEF_RES_UID_GID	= 1ULL << 24,
+	CHECK_SB_C_INTERVAL		= 1ULL << 25,
+	CHECK_SB_C_BLOCK_MAX		= 1ULL << 26,
+/*LOOKS_LIKE_ERROR*/
+	CHECK_SB_TIMES			= 1ULL << 27,
+	CHECK_SB_MNT_COUNT		= 1ULL << 28,
+	CHECK_SB_ERRORS			= 1ULL << 29,
+	CHECK_SB_LAST_CHECK		= 1ULL << 30,
+	CHECK_SB_CLEAN_UMOUNT_FLAG	= 1ULL << 31,
+	CHECK_SB_ERRS_DETECTED_FLAG	= 1ULL << (SB_CHECK_FLAGS_MAX_NUM - 1),
+	SB_FULL_CHECK			= 0x1FFFFFFFF
+}; /* enum sb_check_flags */
+
+/* struct fsck_check
+ *
+ * Defines what should check and return errors.
+ * For every item check_mask is prepared before
+ * checking. It needs to check only items which
+ * flags were been set. If checking item is
+ * valid then proper bit is unset in errors_bitmap.
+ */
+struct fsck_check {
+	union {
+	__u64 check_mask;
+	__u64 errors_bitmap;
+	} sb[SUPERBLOCK_TYPES_NUMBER];
+}; /* struct fsck_check */
+
+#endif /* FSCK_NILFS2_H */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
