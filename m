From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC][PATCH 07/15] nilfs2: implement functionality of xanode's
 checking
Date: Wed, 27 Nov 2013 16:42:27 +0400
Message-ID: <1385556147.2589.73.camel@slavad-ubuntu>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=8CQLAcgJmKk902dOOrcD1YLZVUC4SMGhV7b1kl1Y3Co=;
	b=kOcppuV6goMMGxleLpe7ZwpttNOTes4e7XVTLrl++hG8tiG8a0sAeOc3MUUPpXFZgG31Xyrqz8NYYHm1/7mUjwc6dNqWzpLreQVhBS9+1Hx19Rbl+A1pQQ38e/D2lP0U;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC][PATCH 07/15] nilfs2: implement functionality of xanode's checking

This patch adds functionality of xanode checking.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/xafile.c |  310 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 310 insertions(+)

diff --git a/fs/nilfs2/xafile.c b/fs/nilfs2/xafile.c
index e3c27d1..1c95fb2 100644
--- a/fs/nilfs2/xafile.c
+++ b/fs/nilfs2/xafile.c
@@ -21,6 +21,9 @@
  * Written by Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
  */
 
+#include <linux/crc32.h>
+#include <linux/jhash.h>
+
 #include "nilfs.h"
 #include "alloc.h"
 #include "mdt.h"
@@ -452,6 +455,81 @@ int nilfs_xafile_read(struct super_block *sb, struct nilfs_inode *raw_inode,
 }
 
 /*
+ * calc_name_hash - calculate complex name hash
+ * @name_index: name index
+ * @name: xattr name
+ * @name_hash: calculated complex name hash [out]
+ */
+static
+int calc_name_hash(int name_index, const char *name,
+			struct nilfs_xattr_name_hash *name_hash)
+{
+	size_t name_len;
+
+#ifdef CONFIG_NILFS2_FS_DEBUG
+	BUG_ON(name_index < NILFS_USER_XATTR_ID ||
+		name_index > NILFS_XATTR_MAX_ID);
+	BUG_ON(!name || !name_hash);
+#endif
+
+	name_len = strlen(name);
+
+	if (name_len > XATTR_NAME_MAX) {
+		printk(KERN_ERR "NILFS: xattr name too long\n");
+		return -EINVAL;
+	}
+
+	if (name_len == 0) {
+		printk(KERN_WARNING "NILFS warning: empty name hash\n");
+		memset(name_hash, 0, sizeof(*name_hash));
+		return 0;
+	}
+
+	name_hash->name_len = (u8)name_len;
+	name_hash->name_index = (u8)name_index;
+
+	name_hash->first_symbol = *(const u8 *)(name);
+	name_hash->last_symbol = *(const u8 *)(name + name_len - 1);
+
+	name_hash->hash = cpu_to_le32(jhash(name, name_len, 0));
+
+	return 0;
+}
+
+/*
+ * calc_value_hash - calculate complex value hash
+ * @value: xattr value
+ * @len: value size
+ * @val_hash: calculated complex value hash [out]
+ */
+/*static
+int calc_value_hash(const char *value, __u16 len,
+			struct nilfs_xattr_value_hash *val_hash)
+{
+#ifdef CONFIG_NILFS2_FS_DEBUG
+	BUG_ON(!value || !val_hash);
+#endif
+
+	if (len > NILFS_XATTR_VALUE_LEN_MAX) {
+		printk(KERN_ERR "NILFS: xattr value too big\n");
+		return -EINVAL;
+	}
+
+	if (len == 0) {
+		printk(KERN_WARNING "NILFS warning: empty value hash\n");
+		memset(val_hash, 0, sizeof(*val_hash));
+		return 0;
+	}
+
+	val_hash->value_len = cpu_to_le16(len);
+	val_hash->first_byte = *(const u8 *)(value);
+	val_hash->last_byte = *(const u8 *)(value + len - 1);
+	val_hash->hash = cpu_to_le32(jhash(value, len, 0));
+
+	return 0;
+}*/
+
+/*
  * nilfs_xattr_search_init - initialize xattr search
  * @inode: inode pointer
  * @name_index: xattr name index
@@ -504,6 +582,192 @@ void nilfs_xattr_search_release(struct nilfs_xattr_search *xs)
 }
 
 /*
+ * nilfs_xafile_node_crc32 - calculate xanode checksum
+ * @inode: inode pointer
+ * @node_ptr: pointer on xanode's begin
+ * @node_size: size of xanode
+ * @node: xanode number (index in xafile)
+ */
+static
+__le32 nilfs_xafile_node_crc32(struct inode *inode,
+				char *node_ptr, size_t node_size,
+				__u64 node)
+{
+	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
+	union nilfs_xanode_header *hdr = NILFS_XANODE_HDR(node_ptr);
+	__u32 csum;
+	__le32 save_csum;
+	__le64 blk = cpu_to_le64(node);
+
+	save_csum = hdr->tree_hdr.checksum;
+	hdr->tree_hdr.checksum = 0;
+
+	csum = crc32_le(nilfs->ns_crc_seed, (__u8 *)&blk, sizeof(blk));
+	csum = crc32_le(csum, (__u8 *)node_ptr, node_size);
+
+	hdr->tree_hdr.checksum = save_csum;
+
+	return cpu_to_le32(csum);
+}
+
+/*
+ * is_xanode_checksum_valid - check xanode checksum
+ * @inode: inode pointer
+ * @node_ptr: pointer on xanode's begin
+ * @node_size: size of xanode
+ * @node: xanode number (index in xafile)
+ */
+static inline
+bool is_xanode_checksum_valid(struct inode *inode, char *node_ptr,
+				size_t node_size, __u64 node)
+{
+	union nilfs_xanode_header *hdr = NILFS_XANODE_HDR(node_ptr);
+
+	if (!(NILFS_XANODE_FLAGS(hdr) & NILFS_XANODE_CRC32_FLAG))
+		return true;
+
+	if (hdr->tree_hdr.checksum !=
+	    nilfs_xafile_node_crc32(inode, node_ptr, node_size, node))
+		return false;
+
+	return true;
+}
+
+/*
+ * nilfs_xafile_node_check_entries - check xanode's xattrs
+ * @node_ptr: pointer on xanode's begin
+ * @node_size: size of xanode
+ */
+static
+int nilfs_xafile_node_check_entries(char *node_ptr, size_t node_size)
+{
+	union nilfs_xanode_header *hdr;
+	union nilfs_xattr_key *key = NULL;
+	__u32 *end_key;
+	char *entry;
+	__u16 entries;
+	int entry_index;
+	__u32 entry_size;
+
+	hdr = NILFS_XANODE_HDR(node_ptr);
+	entries = NILFS_XANODE_ENTRIES(hdr);
+
+	if (entries == 0)
+		return 0;
+
+	end_key = NILFS_XANODE_END_KEY(hdr);
+	key = NILFS_XANODE_LAST_NOT_INDEX_KEY(hdr);
+	entry = (char *)NILFS_XANODE_LAST_ENTRY(hdr);
+	entry_index = entries - 1;
+
+	for (; entry_index >= 0; entry_index--, key = PREV_KEY(key, 1)) {
+		if (IS_END_KEY(key))
+			return -EIO;
+
+		if ((char *)NILFS_XANODE_ENTRY(key, node_ptr) != entry)
+			return -EIO;
+
+		entry_size = le16_to_cpu(key->leaf_key.entry_size);
+		if (((char *)entry + entry_size) > (node_ptr + node_size))
+			return -EIO;
+
+		if ((char *)entry < (char *)(end_key + 1))
+			return -EIO;
+
+		entry = (char *)entry + entry_size;
+	}
+
+	if (!IS_END_KEY(key))
+		return -EIO;
+
+	return 0;
+}
+
+/*
+ * __nilfs_xafile_check_node - check xanode's xattrs and checksum
+ * @inode: inode pointer
+ * @node_ptr: pointer on xanode's begin
+ * @node_size: size of xanode
+ * @node: xanode number (index in xafile)
+ */
+static
+int __nilfs_xafile_check_node(struct inode *inode, char *node_ptr,
+				size_t node_size, __u64 node)
+{
+	union nilfs_xanode_header *hdr = NILFS_XANODE_HDR(node_ptr);
+	bool is_crc32_valid;
+
+	if (hdr->base_hdr.magic != cpu_to_le16(NILFS_XANODE_MAGIC))
+		return -EIO;
+
+	if (node_size != NILFS_XANODE_SIZE)
+		return -EIO;
+
+	is_crc32_valid = is_xanode_checksum_valid(inode, node_ptr,
+						  node_size, node);
+	if (!is_crc32_valid)
+		return -EIO;
+
+	return nilfs_xafile_node_check_entries(node_ptr, node_size);
+}
+
+/*
+ * nilfs_xafile_check_node - check xanode and mark buffer as checked
+ * @inode: inode pointer
+ * @node: xanode number (index in xafile)
+ * @bh: xanode's buffer
+ */
+static inline
+int nilfs_xafile_check_node(struct inode *inode, __u64 node,
+				struct buffer_head *bh)
+{
+	int err;
+
+	if (buffer_nilfs_checked(bh))
+		return 0;
+
+	err = __nilfs_xafile_check_node(inode, BH_DATA(bh),
+					BH_SIZE(bh), node);
+	if (likely(!err))
+		set_buffer_nilfs_checked(bh);
+
+	return err;
+}
+
+/*
+ * nilfs_xafile_get_checked_node - get xanode and check it
+ * @inode: inode pointer
+ * @node: xanode number (index in xafile)
+ * @bh: xanode's buffer [out]
+ */
+static
+int nilfs_xafile_get_checked_node(struct inode *inode, __u64 node,
+					struct buffer_head **bh)
+{
+	int err;
+	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
+	struct inode *xafile = nilfs->ns_xafile;
+
+	err = nilfs_xafile_get_node(xafile, node, bh);
+	if (unlikely(err)) {
+		printk(KERN_ERR "NILFS: can't get xafile node %llu\n", node);
+		return -ENODATA;
+	}
+
+	lock_buffer(*bh);
+	err = nilfs_xafile_check_node(inode, node, *bh);
+	unlock_buffer(*bh);
+
+	if (unlikely(err)) {
+		printk(KERN_ERR "NILFS: corrupted xafile node %llu\n", node);
+		brelse(*bh);
+		return err;
+	}
+
+	return 0;
+}
+
+/*
  * nilfs_xafile_check_entry - check xattr entry
  * @key: xattr's key
  * @entry: xattr's entry
@@ -721,3 +985,49 @@ int nilfs_xafile_find_entry(struct inode *inode,
 
 	return -ENODATA;
 }
+
+/*
+ * nilfs_xafile_find_node - search xanode that contains xattr
+ * @inode: inode pointer
+ * @data: internal xattr search structure
+ */
+static
+int nilfs_xafile_find_node(struct inode *inode,
+				struct nilfs_xattr_search *data)
+{
+	int err = 0;
+	__u64 node;
+
+#ifdef CONFIG_NILFS2_FS_DEBUG
+	BUG_ON(!IS_NULL_XANODE_DESC(&data->node) &&
+		!IS_RO_XANODE_DESC(&data->node));
+#endif
+
+	if (IS_SEARCH_KEY_EMPTY(data))
+		return -EINVAL;
+
+	if (IS_NODE_DESC_INVALID(NODE_ID(&data->node)))
+		return -ENODATA;
+
+	if (IS_RO_XANODE_DESC(&data->node)) {
+		if (IS_SEARCH_RESULT_EMPTY(data))
+			goto start_entry_search;
+		else
+			BUG();
+	}
+
+	node = NODE_ID(&data->node);
+
+	err = nilfs_xafile_get_checked_node(inode, node,
+						&NODE_BH(&data->node));
+	if (unlikely(err))
+		goto failed_find_node;
+
+	data->node.flags = NILFS_RO_XANODE;
+
+start_entry_search:
+	err = nilfs_xafile_find_entry(inode, data);
+
+failed_find_node:
+	return err;
+}
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
