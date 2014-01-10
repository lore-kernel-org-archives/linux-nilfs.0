From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC][STEP 1][PATCH v2 03/17] nilfs2: introduce xanode's key
 related declarations
Date: Fri, 10 Jan 2014 16:07:41 +0400
Message-ID: <1389355661.3938.123.camel@slavad-ubuntu>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=xGfxc4fyuDjbjl4gegtYheqKAzen9hbOYAvOHWSslAQ=;
	b=lY/s75W8+vAWQ1aK+w74NwAAygBqkFjDeT5rnaGFOVBY0ZoqyibLyf/gYOASMNhgy4I6zJxBF+bGCmj2Ywp4jzr2KZjCBhSNFi3UB0qZx4TJ3n01GoQvgIxpDDbnaU2y;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC][STEP 1][PATCH v2 03/17] nilfs2: introduce xanode's key related declarations

This patch adds declaration of structures, macros and auxiliary
functions for xanode's keys processing.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/xafile.h |  184 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 184 insertions(+)

diff --git a/fs/nilfs2/xafile.h b/fs/nilfs2/xafile.h
index 28faa1f..34e4bb9 100644
--- a/fs/nilfs2/xafile.h
+++ b/fs/nilfs2/xafile.h
@@ -71,6 +71,82 @@ union nilfs_xanode_header {
 	struct nilfs_tree_xanode_header tree_hdr;
 };
 
+/* Key types */
+#define NILFS_UNKNOWN_KEY_TYPE			0
+/* Temporary, numbers from 1 till 4 are simply reserved */
+#define NILFS_XATTR_TREE_INDEX_KEY_TYPE		5
+#define NILFS_XATTR_TREE_LEAF_KEY_TYPE		6
+#define NILFS_XATTR_KEY_TYPE_MASK		0xF
+
+/* Key's flags*/
+#define NILFS_XATTR_KEY_FLAG_MASK		0xFFF0
+
+/*
+ * struct nilfs_xattr_name_hash - complex hash of xattr's name
+ * @name_len: length of the name
+ * @name_index: index of prefix of xattr's name
+ * @first_symbol: first symbol after first full stop
+ * @last_symbol: last symbol of xattr's name
+ * @hash: calculated hash of xattr's name (for example, jhash)
+ */
+struct nilfs_xattr_name_hash {
+	u8 name_len;
+	u8 name_index;
+	u8 first_symbol;
+	u8 last_symbol;
+	__le32 hash;
+} __packed;
+
+/*
+ * struct nilfs_xattr_value_hash - complex hash of xattr's value
+ * @value_len: length of the value
+ * @first_byte: first byte of value
+ * @last_byte: last byte of value
+ * @hash: calculated hash of xattr's value (for example, jhash)
+ */
+struct nilfs_xattr_value_hash {
+	__le16 value_len;
+	u8 first_byte;
+	u8 last_byte;
+	__le32 hash;
+} __packed;
+
+/*
+ * struct nilfs_xattr_common_key - common xattr key for xanode
+ * @flags: key's flags
+ * @entry_offset: entry offset inside the node
+ * @name_hash: complex hash of xattr's name
+ * @entry_size: size of entry in bytes
+ * @padding: padding field
+ */
+struct nilfs_xattr_common_key {
+	__le16 flags;
+	__le16 entry_offset;
+	struct nilfs_xattr_name_hash name_hash;
+	__le16 entry_size;
+	__le16 padding;
+} __packed;
+
+/*
+ * struct nilfs_xattr_index_key - xattr index key
+ * @name_hash: complex hash of xattr's name
+ * @leaf: leaf node ID
+ */
+struct nilfs_xattr_index_key {
+	struct nilfs_xattr_name_hash name_hash;
+	__le64 leaf;
+} __packed;
+
+/*
+ * struct nilfs_xattr_leaf_key - xattr leaf key
+ */
+typedef struct nilfs_xattr_common_key nilfs_xattr_leaf_key;
+
+union nilfs_xattr_key {
+	__le16 flags;
+	nilfs_xattr_leaf_key leaf_key;
+};
+
 /* Xanode related declarations */
 #define BH_DATA(bh) \
 	((char *)(((struct buffer_head *)(bh))->b_data))
@@ -136,4 +212,112 @@ void NILFS_XANODE_ADD_ENTRIES(__u16 val, union nilfs_xanode_header *hdr_ptr)
 	BUG();
 }
 
+/* Key related declarations*/
+#define NILFS_XANODE_KEY(ptr) \
+	((union nilfs_xattr_key *)(ptr))
+#define NILFS_XANODE_KEY_TYPE(key) \
+	(le16_to_cpu(NILFS_XANODE_KEY(key)->flags) & \
+	 NILFS_XATTR_KEY_TYPE_MASK)
+#define NILFS_XANODE_KEY_FLAGS(key) \
+	(le16_to_cpu(NILFS_XANODE_KEY(key)->flags) & \
+	 NILFS_XATTR_KEY_FLAG_MASK)
+#define NILFS_XANODE_KEY_SET_TYPE(type, key) \
+	(NILFS_XANODE_KEY(key)->flags = \
+	 cpu_to_le16(NILFS_XANODE_KEY_FLAGS(key) | \
+	 ((u16)type & NILFS_XATTR_KEY_TYPE_MASK)))
+#define NILFS_XANODE_KEY_SET_FLAGS(flags, key) \
+	(NILFS_XANODE_KEY(key)->flags = \
+	 cpu_to_le16((u16)flags & NILFS_XANODE_KEY_TYPE(key)))
+
+#define NILFS_XANODE_END_KEY(hdr_ptr) \
+	((__u32 *)((char *)(hdr_ptr) + \
+	 NILFS_XANODE_HDR_SIZE(hdr_ptr) + \
+	 NILFS_XANODE_INDEX_KEYS_SIZE(hdr_ptr) + \
+	 (NILFS_XANODE_NOT_INDEX_KEY_SIZE(hdr_ptr) * \
+	 NILFS_XANODE_ENTRIES(hdr_ptr))))
+
+#define NILFS_XANODE_END_KEY_VALUE	0
+#define NILFS_XANODE_END_KEY_SIZE	sizeof(__u32)
+#define IS_END_KEY(key) (*(__u32 *)(key) == NILFS_XANODE_END_KEY_VALUE)
+
+#define NILFS_XANODE_INDEX_KEY(ptr) \
+	((struct nilfs_xattr_index_key *)(ptr))
+#define NILFS_XANODE_LEAF_KEY(ptr) \
+	((nilfs_xattr_leaf_key *)(ptr))
+
+static inline
+union nilfs_xattr_key *NEXT_KEY(union nilfs_xattr_key *key, int count)
+{
+	switch (NILFS_XANODE_KEY_TYPE(key)) {
+	case NILFS_XATTR_TREE_LEAF_KEY_TYPE:
+		return NILFS_XANODE_KEY(NILFS_XANODE_LEAF_KEY(key) + count);
+	};
+	BUG();
+}
+
+static inline
+union nilfs_xattr_key *PREV_KEY(union nilfs_xattr_key *key, int count)
+{
+	switch (NILFS_XANODE_KEY_TYPE(key)) {
+	case NILFS_XATTR_TREE_LEAF_KEY_TYPE:
+		return NILFS_XANODE_KEY(NILFS_XANODE_LEAF_KEY(key) - count);
+	};
+	BUG();
+}
+
+#define NILFS_XANODE_INDEX_KEYS_SIZE(hdr_ptr) \
+	(NILFS_XANODE_HDR(hdr_ptr)->tree_hdr.log_index_keys == 0 ? 0 : \
+	 ((1 << NILFS_XANODE_HDR(hdr_ptr)->tree_hdr.log_index_keys) * \
+	 sizeof(struct nilfs_xattr_index_key)))
+
+static inline
+size_t NILFS_XANODE_NOT_INDEX_KEY_SIZE(union nilfs_xanode_header *hdr_ptr)
+{
+	switch (NILFS_XANODE_TYPE(hdr_ptr)) {
+	case NILFS_XATTR_TREE_XANODE_TYPE:
+		return sizeof(nilfs_xattr_leaf_key);
+	};
+	BUG();
+}
+
+#define NILFS_XANODE_FIRST_INDEX_KEY(hdr_ptr) \
+	(NILFS_XANODE_INDEX_KEY((char *)(hdr_ptr) + \
+	 NILFS_XANODE_HDR_SIZE(hdr_ptr)))
+#define NILFS_XANODE_FIRST_LEAF_KEY(hdr_ptr) \
+	(NILFS_XANODE_LEAF_KEY((char *)NILFS_XANODE_FIRST_INDEX_KEY(hdr_ptr) + \
+	 NILFS_XANODE_INDEX_KEYS_SIZE(hdr_ptr)))
+
+static inline
+nilfs_xattr_leaf_key *
+NILFS_XANODE_LAST_LEAF_KEY(union nilfs_xanode_header *hdr_ptr)
+{
+	if (NILFS_XANODE_ENTRIES(hdr_ptr) == 0)
+		return NILFS_XANODE_LEAF_KEY(NILFS_XANODE_END_KEY(hdr_ptr));
+
+	return NILFS_XANODE_FIRST_LEAF_KEY(hdr_ptr) +
+		(NILFS_XANODE_ENTRIES(hdr_ptr) - 1);
+}
+
+static inline
+union nilfs_xattr_key *
+NILFS_XANODE_FIRST_NOT_INDEX_KEY(union nilfs_xanode_header *hdr_ptr)
+{
+	switch (NILFS_XANODE_TYPE(hdr_ptr)) {
+	case NILFS_XATTR_TREE_XANODE_TYPE:
+		return NILFS_XANODE_KEY(NILFS_XANODE_FIRST_LEAF_KEY(hdr_ptr));
+	};
+	BUG();
+}
+
+static inline
+union nilfs_xattr_key *
+NILFS_XANODE_LAST_NOT_INDEX_KEY(union nilfs_xanode_header *hdr_ptr)
+{
+	switch (NILFS_XANODE_TYPE(hdr_ptr)) {
+	case NILFS_XATTR_TREE_XANODE_TYPE:
+		return NILFS_XANODE_KEY(NILFS_XANODE_LAST_LEAF_KEY(hdr_ptr));
+	};
+	BUG();
+}
+
 #endif /* _NILFS_XAFILE_H */
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
