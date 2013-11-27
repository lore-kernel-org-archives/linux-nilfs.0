From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC][PATCH 04/15] nilfs2: introduce xanode's entry related
 declarations
Date: Wed, 27 Nov 2013 16:41:59 +0400
Message-ID: <1385556119.2589.70.camel@slavad-ubuntu>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=Mc+auoG5TCki8rMA6tr247MF21DVxifO7JRTLMb7LWI=;
	b=VYKYibGTn3osBEJQVOhcDL00OYyns9bqVxqPhOJUeiOrFAbi06jzqYwEyt1dDXw9VtOj/itQnL+7LH/c6F55c8aRatMRmeS4F//qrwV7M4ajBpIDz3nEBNOKOqXpC2eY;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC][PATCH 04/15] nilfs2: introduce xanode's entry related declarations

This patch adds declaration of structures, macros and auxiliary
functions for xanode's entries processing.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/xafile.h |   97 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 97 insertions(+)

diff --git a/fs/nilfs2/xafile.h b/fs/nilfs2/xafile.h
index 34e4bb9..cee7b03 100644
--- a/fs/nilfs2/xafile.h
+++ b/fs/nilfs2/xafile.h
@@ -147,6 +147,20 @@ union nilfs_xattr_key {
 	nilfs_xattr_leaf_key leaf_key;
 };
 
+/*
+ * struct nilfs_xanode_entry - xanode's entry
+ * @name: xattr's name
+ * @value: xattr's value
+ * @value_hash: complex hash of xattr's value
+ */
+struct nilfs_xanode_entry {
+	union {
+		char name[0];
+		char value[0];
+		struct nilfs_xattr_value_hash value_hash;
+	} __packed;
+} __packed;
+
 /* Xanode related declarations */
 #define BH_DATA(bh) \
 	((char *)(((struct buffer_head *)(bh))->b_data))
@@ -320,4 +334,87 @@ NILFS_XANODE_LAST_NOT_INDEX_KEY(union nilfs_xanode_header *hdr_ptr)
 	BUG();
 }
 
+/* Entry related declarations */
+#define NILFS_XANODE_ENTRY_PTR(ptr) ((struct nilfs_xanode_entry *)(ptr))
+
+static inline
+__u16 NILFS_XANODE_ENTRY_OFFSET(union nilfs_xattr_key *key)
+{
+	if (IS_END_KEY(key))
+		return 0;
+
+	switch (NILFS_XANODE_KEY_TYPE(key)) {
+	case NILFS_XATTR_TREE_LEAF_KEY_TYPE:
+		return le16_to_cpu(key->leaf_key.entry_offset);
+	};
+	BUG();
+}
+
+static inline
+void NILFS_XANODE_ADD_ENTRY_OFFSET(__u16 val, union nilfs_xattr_key *key)
+{
+	switch (NILFS_XANODE_KEY_TYPE(key)) {
+	case NILFS_XATTR_TREE_LEAF_KEY_TYPE:
+		le16_add_cpu(&key->leaf_key.entry_offset, val);
+		return;
+	};
+	BUG();
+}
+
+#define NILFS_XATTR_ENTRY_OFFSET(hdr_ptr, entry_ptr) \
+	((char *)hdr_ptr + NILFS_XANODE_SIZE - (char *)entry_ptr)
+
+static inline
+__u16 NILFS_XANODE_ENTRY_SIZE(union nilfs_xattr_key *key)
+{
+	if (IS_END_KEY(key))
+		return 0;
+
+	switch (NILFS_XANODE_KEY_TYPE(key)) {
+	case NILFS_XATTR_TREE_LEAF_KEY_TYPE:
+		return le16_to_cpu(key->leaf_key.entry_size);
+	};
+	BUG();
+}
+
+#define NILFS_XATTR_ENTRY_SIZE(name, value_size) \
+	(strlen((const char *)(name)) + value_size)
+
+static inline
+struct nilfs_xattr_name_hash *NILFS_XANODE_NAME_HASH(union nilfs_xattr_key *key)
+{
+	switch (NILFS_XANODE_KEY_TYPE(key)) {
+	case NILFS_XATTR_TREE_LEAF_KEY_TYPE:
+		return &key->leaf_key.name_hash;
+	};
+	BUG();
+}
+
+#define NILFS_XANODE_ENTRY(key, hdr_ptr) \
+	(NILFS_XANODE_ENTRY_PTR((char *)(hdr_ptr) + \
+	 NILFS_XANODE_SIZE - NILFS_XANODE_ENTRY_OFFSET(key)))
+
+static inline
+struct nilfs_xanode_entry *
+NILFS_XANODE_LAST_ENTRY(union nilfs_xanode_header *hdr)
+{
+	switch (NILFS_XANODE_TYPE(hdr)) {
+	case NILFS_XATTR_TREE_XANODE_TYPE: {
+			nilfs_xattr_leaf_key *key;
+
+			key = NILFS_XANODE_LAST_LEAF_KEY(hdr);
+			if (IS_END_KEY(key))
+				return NILFS_XANODE_ENTRY_PTR((char *)(hdr) +
+							     NILFS_XANODE_SIZE);
+			else
+				return NILFS_XANODE_ENTRY(NILFS_XANODE_KEY(key),
+							  hdr);
+		}
+	};
+	BUG();
+}
+
+#define NILFS_XATTR_VALUE(entry, key) \
+	((char *)(entry) + NILFS_XANODE_NAME_HASH(key)->name_len)
+
 #endif /* _NILFS_XAFILE_H */
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
