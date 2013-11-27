From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC][PATCH 02/15] nilfs2: introduce xanode related declarations
Date: Wed, 27 Nov 2013 16:41:38 +0400
Message-ID: <1385556098.2589.68.camel@slavad-ubuntu>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=JXDi6XRemc1343lnBgUjz5npfZMf3Jjv0quUmPDO1rM=;
	b=i2Ej4W88NyoyYXqngHSsdCAfsRMCN36/4QN3ThUxq2BOYop7FZkSXpEJsXpBh0zyvfS7bLsCOA76ip9e7LnpueW/sVFXi9lQzdFe0mrZrB/9vXEtXRCA7phTzrY1xn0n;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC][PATCH 02/15] nilfs2: introduce xanode related declarations

This patch adds declaration of structures, macros and auxiliary
functions for xafile's xanodes.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/xafile.h |  139 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 139 insertions(+)
 create mode 100644 fs/nilfs2/xafile.h

diff --git a/fs/nilfs2/xafile.h b/fs/nilfs2/xafile.h
new file mode 100644
index 0000000..28faa1f
--- /dev/null
+++ b/fs/nilfs2/xafile.h
@@ -0,0 +1,139 @@
+/*
+ * xafile.h - NILFS extended attributes file (xafile) declarations.
+ *
+ * Copyright (C) 2005-2013 Nippon Telegraph and Telephone Corporation.
+ * Copyright (C) 2013 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
+ */
+
+#ifndef _NILFS_XAFILE_H
+#define _NILFS_XAFILE_H
+
+#include <linux/xattr.h>
+
+/* Magic number of xafile node */
+#define NILFS_XANODE_MAGIC		0x5841 /* XA */
+
+/* Xanode types */
+#define NILFS_UNKNOWN_XANODE_TYPE		0
+/* Temporary, numbers from 1 till 6 are simply reserved */
+#define NILFS_XATTR_TREE_XANODE_TYPE		7
+#define NILFS_XANODE_TYPE_MASK			0x000F
+
+/* Xanode's flags */
+#define NILFS_XANODE_CRC32_FLAG			0x0010
+#define NILFS_INDEX_XANODE_FLAG			0x0020
+#define NILFS_XANODE_FLAG_MASK			0xFFF0
+
+/*
+ * struct nilfs_tree_xanode_header - header of dedicated xanode
+ * @magic: magic number for identification
+ * @flags: xanode's flags
+ * @height: node height in the tree
+ * @log_index_keys: log2(index keys max count)
+ * @entries: count of entries in xanode
+ * @checksum: CRC32 of node
+ * @index_keys: current count of index keys
+ * @parent_node: node ID of a parent node
+ */
+struct nilfs_tree_xanode_header {
+	__le16 magic;
+	__le16 flags;
+	u8 height;
+#define NILFS_XANODE_MIN_INDEX_KEYS	4
+	u8 log_index_keys;
+	__le16 entries;
+	__le32 checksum;
+	__le32 index_keys;
+	__le64 parent_node;
+} __packed;
+
+union nilfs_xanode_header {
+	struct {
+		__le16 magic;
+		__le16 flags;
+	} __packed base_hdr;
+	struct nilfs_tree_xanode_header tree_hdr;
+};
+
+/* Xanode related declarations */
+#define BH_DATA(bh) \
+	((char *)(((struct buffer_head *)(bh))->b_data))
+#define BH_SIZE(bh) \
+	(((struct buffer_head *)(bh))->b_size)
+
+#define NILFS_XANODE_BEGIN(bh) \
+	BH_DATA(bh)
+#define NILFS_XANODE_END(bh) \
+	(BH_DATA(bh) + BH_SIZE(bh))
+#define NILFS_XANODE_HDR(hdr_ptr) \
+	((union nilfs_xanode_header *)(hdr_ptr))
+
+/* TODO: [REWORK] Temporary xanode size is fixed by 4 KB */
+#define NILFS_XANODE_SIZE			PAGE_CACHE_SIZE
+
+#define NILFS_XANODE_HDR_SIZE_MAX		32
+#define NILFS_XANODE_INDEX_KEY_SIZE_MAX		16
+#define NILFS_XANODE_LEAF_KEY_SIZE_MAX		32
+
+#define NILFS_XATTR_VALUE_LEN_MAX \
+	(NILFS_XANODE_SIZE - \
+	 (NILFS_XANODE_HDR_SIZE_MAX + \
+	  (NILFS_XANODE_MIN_INDEX_KEYS * NILFS_XANODE_INDEX_KEY_SIZE_MAX) + \
+	  NILFS_XANODE_LEAF_KEY_SIZE_MAX + \
+	  (XATTR_NAME_MAX + 1)))
+
+#define NILFS_XANODE_TYPE(hdr_ptr) \
+	(le16_to_cpu(NILFS_XANODE_HDR(hdr_ptr)->base_hdr.flags) & \
+	 NILFS_XANODE_TYPE_MASK)
+#define NILFS_XANODE_FLAGS(hdr_ptr) \
+	(le16_to_cpu(NILFS_XANODE_HDR(hdr_ptr)->base_hdr.flags) & \
+	 NILFS_XANODE_FLAG_MASK)
+#define NILFS_XANODE_SET_TYPE(type, hdr_ptr) \
+	(cpu_to_le16(NILFS_XANODE_FLAGS(hdr_ptr) | \
+	 ((u16)type & NILFS_XANODE_TYPE_MASK)))
+#define NILFS_XANODE_SET_FLAGS(flags, hdr_ptr) \
+	(cpu_to_le16((u16)flags | NILFS_XANODE_TYPE(hdr_ptr)))
+
+static inline
+size_t NILFS_XANODE_HDR_SIZE(union nilfs_xanode_header *hdr_ptr)
+{
+	switch (NILFS_XANODE_TYPE(hdr_ptr)) {
+	case NILFS_XATTR_TREE_XANODE_TYPE:
+		return sizeof(struct nilfs_tree_xanode_header);
+	};
+	BUG();
+}
+
+#define NILFS_XANODE_ENTRIES(hdr_ptr) \
+	(NILFS_XANODE_TYPE(hdr_ptr) == NILFS_XATTR_TREE_XANODE_TYPE ? \
+	 le16_to_cpu(NILFS_XANODE_HDR(hdr_ptr)->tree_hdr.entries) : \
+	 0)
+
+static inline
+void NILFS_XANODE_ADD_ENTRIES(__u16 val, union nilfs_xanode_header *hdr_ptr)
+{
+	switch (NILFS_XANODE_TYPE(hdr_ptr)) {
+	case NILFS_XATTR_TREE_XANODE_TYPE:
+		le16_add_cpu(&hdr_ptr->tree_hdr.entries, val);
+		return;
+	};
+	BUG();
+}
+
+#endif /* _NILFS_XAFILE_H */
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
