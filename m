From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v4 05/15] nilfs-utils: fsck: add fsck_nilfs2.h file with
 fsck's constant declarations
Date: Mon, 12 Nov 2012 13:35:47 +0400
Message-ID: <1352712947.2555.40.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:To:From:Subject:Message-ID; bh=gf0fBRautZFZkMMb/bP530dfWieVLAEqrHw2Uy1lS4k=;
	b=f2Kzzfm0jLGaRssS/2QqoqKzPc52eQpHbM9DGwXSFF3GM+hVl7QJdKX/YyuHCl0MLNgW8fEvopOGxR1lLXK2rx6vxap8Jns/fl6EipFp+TeoE6LpKIcrUqVyArViJk3n;
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
Subject: [PATCH v4 05/15] nilfs-utils: fsck: add fsck_nilfs2.h file with fsck's constant declarations

This patch adds fsck_nilfs2.h file with fsck's constant declarations.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
 include/fsck_nilfs2.h |  148 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 148 insertions(+)
 create mode 100644 include/fsck_nilfs2.h

diff --git a/include/fsck_nilfs2.h b/include/fsck_nilfs2.h
new file mode 100644
index 0000000..7be0413
--- /dev/null
+++ b/include/fsck_nilfs2.h
@@ -0,0 +1,148 @@
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
+/*
+ * Flags define what should be checked in superblock
+ * Declaration order is crucial!!!
+ */
+#define SB_CHECK_FLAGS_MAX_NUM 33
+enum sb_check_flags {
+/*WARNING*/
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
+	SB_FULL_CHECK			= 0x1FFFFFFFF,
+/* Mask for superblock corruption detection (CRITICAL + MINOR) */
+	SB_CORRUPTION_MASK		= 0x7FFFFFC,
+/* Flag should be set after check */
+	SB_HAS_CHECKED			= 1ULL << 63
+}; /* enum sb_check_flags */
+
+/*
+ * Flags define what should be checked in segment summary header.
+ * Declaration order is crucial!!!
+ */
+#define SS_HDR_CHECK_FLAGS_MAX 13
+enum ss_hdr_check_flags {
+/*WARNING*/
+	CHECK_SS_MAGIC			= 1UL << 0,
+	CHECK_SS_HDR_REV		= 1UL << 1,
+/*CRITICAL*/
+	CHECK_SS_DATASUM		= 1UL << 2,
+	CHECK_SS_SUMSUM			= 1UL << 3,
+	CHECK_SS_BYTES			= 1UL << 4,
+	CHECK_SS_NBLOCKS		= 1UL << 5,
+	CHECK_SS_NEXT			= 1UL << 6,
+	CHECK_SS_NFINFO			= 1UL << 7,
+	CHECK_SS_SUMBYTES		= 1UL << 8,
+/*MINOR*/
+	CHECK_SS_SEQ			= 1UL << 9,
+	CHECK_SS_FLAGS			= 1UL << 10,
+/*LOOKS_LIKE_ERROR*/
+	CHECK_SS_CREATE			= 1UL << 11,
+	CHECK_SS_CNO			= 1UL << (SS_HDR_CHECK_FLAGS_MAX - 1),
+	SS_HEADER_ONLY_CHECK		= 0x1EF3,
+/* Mask for segment summary header corruption detection */
+	SS_HDR_CORRUPTION_MASK		= 0x7FC,
+/* Flag should be set after check */
+/* |-> datasum was checked */
+	SS_DATASUM_HAS_CHECKED		= 1UL << 13,
+/* |-> sumsum was checked */
+	SS_SUMSUM_HAS_CHECKED		= 1UL << 14,
+/* |-> segment summary header was checked w/o checksums */
+	ONLY_SS_HDR_HAS_CHECKED		= 1UL << 15
+}; /* enum ss_hdr_check_flags */
+
+/*
+ * Flags define what should be checked on the volume at whole.
+ * Declaration order is crucial!!!
+ */
+enum volume_corruption_flags {
+	SB_CORRUPTION_DETECTED		= 1UL << 0,
+	SEGS_CHAIN_INCONSISTENT		= 1UL << 1,
+	SS_CORRUPTION_DETECTED		= 1UL << 2,
+}; /* enum segments_chain_check_flags */
+
+#endif /* FSCK_NILFS2_H */
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
