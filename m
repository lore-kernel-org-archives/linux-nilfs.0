From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [RFC][PATCH 10/15] nilfs2: implement setxattr and removexattr
 functionality
Date: Wed, 27 Nov 2013 16:42:57 +0400
Message-ID: <1385556177.2589.76.camel@slavad-ubuntu>
Reply-To: slava@dubeyko.com
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=JvpG3q1SDvzBBcTamqq7A+76VcgUWKJnccUSHGCYPt8=;
	b=RF/eLZ/BiUgi0VFBd5bA1RvvI0hzm8MEEE3U90N0Ox8CtUodntkHWMJk9QUnUvqA0UyB93d02hDueaupfcZOPcEpsQYDnRoeZFMl+Vf0sWu/cM7TlUO0+2hAfoS3w/QT;
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-nilfs@vger.kernel.org

From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [RFC][PATCH 10/15] nilfs2: implement setxattr and removexattr functionality

This patch adds functionality of setxattr and removexattr operations.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
CC: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/xafile.c |  598 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/xattr.c  |   26 +++
 fs/nilfs2/xattr.h  |   15 ++
 3 files changed, 639 insertions(+)

diff --git a/fs/nilfs2/xafile.c b/fs/nilfs2/xafile.c
index e89e95b..dcc524f 100644
--- a/fs/nilfs2/xafile.c
+++ b/fs/nilfs2/xafile.c
@@ -1059,6 +1059,65 @@ failed_find_node:
 }
 
 /*
+ * is_value_size_valid - check that xattr can be stored in xanode
+ * @xafile: xafile's inode
+ * @node: pointer on xanode's begin
+ * @name: xattr name
+ * @value_size: xattr's value size
+ */
+static inline
+bool is_value_size_valid(struct inode *xafile, char *node,
+				char *name, size_t value_size)
+{
+	return value_size <=
+		(NILFS_XAFILE_I(xafile)->mi.mi_entry_size -
+		(NILFS_XANODE_HDR_SIZE(NILFS_XANODE_HDR(node)) +
+		NILFS_XANODE_NOT_INDEX_KEY_SIZE(NILFS_XANODE_HDR(node)) +
+		NILFS_XANODE_END_KEY_SIZE +
+		strlen(name) +
+		value_size));
+}
+
+/*
+ * __can_insert_entries - check that entries can be stored in xanode
+ * @node_ptr: pointer on xanode's begin
+ * @entries_count: count of xattrs
+ * @entries_size: size of entries in bytes
+ */
+static inline
+bool __can_insert_entries(char *node_ptr,
+				int entries_count, size_t entries_size)
+{
+	union nilfs_xanode_header *hdr = NILFS_XANODE_HDR(node_ptr);
+	char *begin_free_area = NULL;
+	char *end_free_area = NULL;
+
+	begin_free_area = (char *)NILFS_XANODE_END_KEY(hdr);
+	begin_free_area +=
+		(entries_count * NILFS_XANODE_NOT_INDEX_KEY_SIZE(hdr));
+	begin_free_area += NILFS_XANODE_END_KEY_SIZE;
+
+	end_free_area = (char*)NILFS_XANODE_LAST_ENTRY(hdr);
+	end_free_area -= entries_size;
+
+	return begin_free_area <= end_free_area;
+}
+
+/*
+ * can_insert_entry - check opportunity to insert xattr
+ * @node_ptr: pointer on xanode's begin
+ * @name: xattr's name
+ * @value_size: xattr's value size
+ */
+static inline
+bool can_insert_entry(char *node_ptr, char *name, size_t value_size)
+{
+	u16 entry_size = NILFS_XATTR_ENTRY_SIZE(name, value_size);
+
+	return __can_insert_entries(node_ptr, 1, entry_size);
+}
+
+/*
  * __nilfs_xafile_node_init - initialize newly created xanode in memory
  * @inode: inode pointer
  * @node_type: xanode type
@@ -1328,6 +1387,431 @@ void nilfs_xafile_abort_new_node(struct inode *inode,
 }
 
 /*
+ * nilfs_xafile_set_entry_for_key - add xattr as last entry by key
+ * @inode: inode pointer
+ * @name_index: xattr's name index
+ * @name: xattr's name
+ * @value: xattr's value
+ * @value_size: xattr's value size
+ * @node_ptr: pointer on xanode's begin
+ * @key: xanode's key
+ * @entry: xanode's entry
+ */
+static
+int nilfs_xafile_set_entry_for_key(struct inode *inode,
+					int name_index,
+					const char *name,
+					const void *value,
+					size_t value_size,
+					char *node_ptr,
+					union nilfs_xattr_key *key,
+					struct nilfs_xanode_entry *entry)
+{
+	int err;
+	union nilfs_xanode_header *hdr = NILFS_XANODE_HDR(node_ptr);
+	ptrdiff_t entry_offset = NILFS_XATTR_ENTRY_OFFSET(node_ptr, entry);
+	__u32 entry_size = NILFS_XATTR_ENTRY_SIZE(name, value_size);
+	__u16 name_len = strlen(name);
+	__u32 *end_key;
+
+	/* TODO: entry can have different structure */
+
+	/* insert entry */
+	memcpy(entry->name, name, name_len);
+	memcpy(entry->name + name_len, value, value_size);
+
+	/* insert key */
+	switch (NILFS_XANODE_TYPE(node_ptr)) {
+	case NILFS_XATTR_TREE_XANODE_TYPE:
+		NILFS_XANODE_KEY_SET_TYPE(NILFS_XATTR_TREE_LEAF_KEY_TYPE, key);
+
+		err = calc_name_hash(name_index, name,
+					&key->leaf_key.name_hash);
+		if (unlikely(err))
+			return err;
+
+		key->leaf_key.entry_offset = cpu_to_le16(entry_offset);
+		key->leaf_key.entry_size = cpu_to_le16(entry_size);
+		break;
+
+	default:
+		BUG();
+	};
+
+	NILFS_XANODE_ADD_ENTRIES(1, hdr);
+	end_key = NILFS_XANODE_END_KEY(hdr);
+	*end_key = NILFS_XANODE_END_KEY_VALUE;
+
+	return 0;
+}
+
+/*
+ * nilfs_xafile_insert_entry_for_key - insert xattr in xanode by key
+ * @inode: inode pointer
+ * @name_index: xattr's name index
+ * @name: xattr's name
+ * @value: xattr's value
+ * @value_size: xattr's value size
+ * @node_ptr: pointer on xanode's begin
+ * @key: xanode's key
+ */
+static
+int nilfs_xafile_insert_entry_for_key(struct inode *inode,
+					int name_index,
+					const char *name,
+					const void *value,
+					size_t value_size,
+					char *node_ptr,
+					union nilfs_xattr_key *key)
+{
+	int err;
+	__u32 entry_size;
+	union nilfs_xattr_key *last_key;
+	char *old_last_entry_ptr;
+	char *new_last_entry_ptr;
+	__u32 shifted_entries_size;
+	char *end_key;
+	char *old_key_ptr = (char *)key;
+	char *new_key_ptr;
+	ptrdiff_t shifted_keys_size;
+	struct nilfs_xanode_entry *inserted;
+	union nilfs_xattr_key *cur_key;
+	union nilfs_xanode_header *hdr = NILFS_XANODE_HDR(node_ptr);
+
+#ifdef CONFIG_NILFS2_FS_DEBUG
+	BUG_ON(IS_END_KEY(key));
+#endif
+
+	entry_size = NILFS_XATTR_ENTRY_SIZE(name, value_size);
+	last_key = NILFS_XANODE_LAST_NOT_INDEX_KEY(hdr);
+
+#ifdef CONFIG_NILFS2_FS_DEBUG
+	BUG_ON(IS_END_KEY(last_key));
+#endif
+
+	old_last_entry_ptr = (char *)NILFS_XANODE_LAST_ENTRY(hdr);
+	new_last_entry_ptr = old_last_entry_ptr - entry_size;
+	shifted_entries_size = (NILFS_XANODE_ENTRY_OFFSET(last_key) -
+				NILFS_XANODE_ENTRY_OFFSET(key)) +
+				NILFS_XANODE_ENTRY_SIZE(key);
+	end_key = (char *)NILFS_XANODE_END_KEY(hdr);
+	new_key_ptr = old_key_ptr + NILFS_XANODE_NOT_INDEX_KEY_SIZE(hdr);
+	shifted_keys_size = (end_key - old_key_ptr) + NILFS_XANODE_END_KEY_SIZE;
+	inserted = (struct nilfs_xanode_entry *)(new_last_entry_ptr +
+						 shifted_entries_size);
+
+	/* shift entries */
+	memmove(new_last_entry_ptr,
+		old_last_entry_ptr, shifted_entries_size);
+
+	/* shift keys */
+	memmove(new_key_ptr, old_key_ptr, shifted_keys_size);
+
+	/* correct shifted keys */
+	cur_key = NILFS_XANODE_KEY(new_key_ptr);
+	for (; !IS_END_KEY(cur_key); cur_key = NEXT_KEY(cur_key, 1))
+		NILFS_XANODE_ADD_ENTRY_OFFSET(entry_size, cur_key);
+
+	err = nilfs_xafile_set_entry_for_key(inode,
+						name_index, name,
+						value, value_size,
+						node_ptr, key, inserted);
+
+	return err;
+}
+
+/*
+ * nilfs_xafile_node_insert_entry - insert xattr in xanode
+ * @inode: inode pointer
+ * @data: internal xattr search structure
+ * @value: xattr's value
+ * @size: xattr's value size
+ */
+static
+int nilfs_xafile_node_insert_entry(struct inode *inode,
+					struct nilfs_xattr_search *data,
+					const void *value,
+					size_t size)
+{
+	int err;
+	union nilfs_xanode_header *hdr;
+	struct nilfs_xanode_entry *inserted = NULL;
+	__u32 entry_size;
+	u8 name_index;
+	char *name;
+
+#ifdef CONFIG_NILFS2_FS_DEBUG
+	BUG_ON(!IS_SHADOW_XANODE_DESC(&data->node));
+#endif
+
+	hdr = data->result.hdr;
+
+	if (!can_insert_entry((char *)hdr, data->search.name, size))
+		return -ENOSPC;
+
+	/* TODO: entry size can be calculated on different basis */
+	entry_size = NILFS_XATTR_ENTRY_SIZE(data->search.name, size);
+
+	name_index = data->search.name_hash.name_index;
+	name = data->search.name;
+
+	if (IS_END_KEY(data->result.key)) {
+		char *old_ptr = (char *)NILFS_XANODE_LAST_ENTRY(hdr);
+
+		/* add entry */
+		inserted = (struct nilfs_xanode_entry *)(old_ptr - entry_size);
+		err = nilfs_xafile_set_entry_for_key(inode, name_index, name,
+							value, size,
+							(char *)hdr,
+							data->result.key,
+							inserted);
+		if (unlikely(err))
+			return err;
+	} else {
+		/* insert entry */
+		err = nilfs_xafile_insert_entry_for_key(inode, name_index, name,
+							value, size,
+							(char *)hdr,
+							data->result.key);
+		if (unlikely(err))
+			return err;
+	}
+
+	return 0;
+}
+
+/*
+ * nilfs_xafile_node_delete_entries - delete xattrs from xanode
+ * @inode: inode pointer
+ * @data: internal xattr search structure
+ * @entries_count: deleted xattrs count
+ */
+static
+int nilfs_xafile_node_delete_entries(struct inode *inode,
+					struct nilfs_xattr_search *data,
+					int entries_count)
+{
+	int err;
+	union nilfs_xanode_header *hdr;
+	size_t node_size;
+	size_t key_size;
+	union nilfs_xattr_key *cur_key;
+	union nilfs_xattr_key *last_key;
+	union nilfs_xattr_key *last_del_key;
+	union nilfs_xattr_key *first_shift_key;
+	__u32 *end_key;
+	char *cur_entry;
+	char *last_entry;
+	__u32 removed_keys_size;
+	__u32 removed_entries_size;
+
+#ifdef CONFIG_NILFS2_FS_DEBUG
+	BUG_ON(IS_SEARCH_KEY_EMPTY(data));
+	BUG_ON(IS_SEARCH_RESULT_EMPTY(data));
+	BUG_ON(!IS_SHADOW_XANODE_DESC(&data->node));
+#endif
+
+	if (!data->result.found)
+		return -EINVAL;
+
+	cur_key = data->result.key;
+	cur_entry = (char *)data->result.entry;
+
+	if (IS_END_KEY(cur_key)) {
+		printk(KERN_WARNING "NILFS warning: can't delete xattr\n");
+		return -ENOENT;
+	}
+
+	hdr = data->result.hdr;
+	node_size = NILFS_XANODE_SIZE;
+	end_key = NILFS_XANODE_END_KEY(hdr);
+	key_size = NILFS_XANODE_NOT_INDEX_KEY_SIZE(hdr);
+	removed_keys_size = entries_count * key_size;
+
+	if (((char *)cur_key + removed_keys_size) > (char *)end_key)
+		return -EINVAL;
+
+	err = nilfs_xafile_node_check_entries((char *)hdr, node_size);
+	if (unlikely(err < 0))
+		return err;
+
+	last_key = NILFS_XANODE_LAST_NOT_INDEX_KEY(hdr);
+	last_entry = (char *)NILFS_XANODE_LAST_ENTRY(hdr);
+	first_shift_key = NILFS_XANODE_KEY((char *)cur_key + removed_keys_size);
+	last_del_key = NILFS_XANODE_KEY((char *)first_shift_key - key_size);
+
+	removed_entries_size = NILFS_XANODE_ENTRY_OFFSET(cur_key);
+	removed_entries_size -= NILFS_XANODE_ENTRY_OFFSET(last_del_key);
+	removed_entries_size += NILFS_XANODE_ENTRY_SIZE(last_del_key);
+
+	/* shift entries */
+	if (last_entry == (char *)cur_entry) {
+		size_t entry_size = NILFS_XANODE_ENTRY_SIZE(cur_key);
+
+		memset((char *)data->result.entry, 0, entry_size);
+	} else {
+		char *new_last_entry;
+		__u32 shifted_size;
+
+		new_last_entry = last_entry + removed_entries_size;
+		shifted_size = NILFS_XANODE_ENTRY_OFFSET(last_key);
+		shifted_size -= NILFS_XANODE_ENTRY_OFFSET(cur_key);
+		memmove(new_last_entry, last_entry, shifted_size);
+	}
+
+	/* shift keys */
+	if (last_key == cur_key)
+		memset(last_key, 0, key_size);
+	else {
+		char *old_key;
+		char *new_key;
+
+		new_key = (char *)cur_key;
+		old_key = (char *)first_shift_key;
+
+		if (IS_END_KEY(old_key))
+			memset(new_key, 0, old_key - new_key);
+		else {
+			ptrdiff_t shifted_size;
+
+			shifted_size = (char *)end_key - old_key;
+			shifted_size += NILFS_XANODE_END_KEY_SIZE;
+			memmove(new_key, old_key, shifted_size);
+		}
+	}
+
+	/* correct shifted keys */
+	for (; !IS_END_KEY(cur_key); cur_key = NEXT_KEY(cur_key, 1)) {
+		NILFS_XANODE_ADD_ENTRY_OFFSET(-1 * removed_entries_size,
+						cur_key);
+	}
+
+	NILFS_XANODE_ADD_ENTRIES(-1 * entries_count, hdr);
+	return 0;
+}
+
+/*
+ * nilfs_xafile_node_delete_entry - delete one xattr from xanode
+ * @inode: inode pointer
+ * @data: internal xattr search structure
+ */
+static inline
+int nilfs_xafile_node_delete_entry(struct inode *inode,
+					struct nilfs_xattr_search *data)
+{
+	return nilfs_xafile_node_delete_entries(inode, data, 1);
+}
+
+/*
+ * nilfs_xafile_set_entry - set xattr by shadow change and commit
+ * @inode: inode pointer
+ * @data: internal xattr search structure
+ * @value: xattr's value
+ * @size: xattr's value size
+ */
+static
+int nilfs_xafile_set_entry(struct inode *inode,
+				struct nilfs_xattr_search *data,
+				const void *value,
+				size_t size)
+{
+	int err = 0;
+	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
+	struct inode *xafile = nilfs->ns_xafile;
+	bool can_insert = false;
+
+	if (!value)
+		return -EINVAL;
+	if (!is_value_size_valid(xafile, BH_DATA(NODE_BH(&data->node)),
+					data->search.name, size))
+		return -ENOSPC;
+	if (IS_SEARCH_RESULT_EMPTY(data)) {
+		printk(KERN_ERR "NILFS: inconsistent xattr search\n");
+		return -EINVAL;
+	}
+
+	err = nilfs_xafile_prepare_node_for_change(inode, data);
+	if (unlikely(err))
+		goto set_entry_cleanup;
+
+	if (data->result.found) {
+		err = nilfs_xafile_node_delete_entry(inode, data);
+		if (unlikely(err))
+			goto set_entry_cleanup;
+	}
+
+	can_insert = can_insert_entry((char *)data->result.hdr,
+					data->search.name, size);
+
+	if (can_insert) {
+		err = nilfs_xafile_node_insert_entry(inode, data, value, size);
+		if (unlikely(err))
+			goto set_entry_cleanup;
+
+		nilfs_xafile_commit_changed_node(inode, data);
+	} else {
+		err = -ENOSPC;
+		goto set_entry_cleanup;
+	}
+
+	return 0;
+
+set_entry_cleanup:
+	nilfs_xafile_abort_node_change(data);
+	return err;
+}
+
+/*
+ * nilfs_xafile_delete_entry - delete xattr by shadow change and commit
+ * @inode: inode pointer
+ * @data: internal xattr search structure
+ */
+static
+int nilfs_xafile_delete_entry(struct inode *inode,
+				struct nilfs_xattr_search *data)
+{
+	int err = 0;
+	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
+	struct inode *xafile = nilfs->ns_xafile;
+
+	if (IS_SEARCH_RESULT_EMPTY(data)) {
+		printk(KERN_ERR "NILFS: inconsistent xattr search\n");
+		return -EINVAL;
+	}
+
+	err = nilfs_xafile_prepare_node_for_change(inode, data);
+	if (unlikely(err))
+		goto delete_entry_cleanup;
+
+	err = nilfs_xafile_node_delete_entry(inode, data);
+	if (unlikely(err))
+		goto delete_entry_cleanup;
+
+	if (NILFS_XANODE_ENTRIES(data->result.hdr) == 0) {
+		err = nilfs_xafile_prepare_node_deletion(xafile,
+							 &data->node.req);
+		if (unlikely(err))
+			goto delete_entry_cleanup;
+
+		if (NILFS_I(inode)->i_xattr == NODE_ID(&data->node)) {
+			NILFS_I(inode)->i_xattr = NILFS_INVALID_XANODE;
+			nilfs_mark_inode_dirty(inode);
+		}
+
+		nilfs_xafile_commit_node_deletion(xafile, &data->node.req);
+	}
+
+	nilfs_xafile_commit_changed_node(inode, data);
+
+	return 0;
+
+delete_entry_cleanup:
+	nilfs_xafile_abort_node_change(data);
+
+	return err;
+}
+
+/*
  * nilfs_xattr_list_entries - list inode's xattrs from one xanode
  * @dentry: dentry object
  * @bh: xanode's buffer
@@ -1467,3 +1951,117 @@ failed_xafile_getxattr:
 	nilfs_xattr_search_release(&data);
 	return ret;
 }
+
+/*
+ * nilfs_xafile_setxattr - set/delete xattr
+ * @inode: inode pointer
+ * @name_index: name index of xattr
+ * @name: xattr's name
+ * @value: pointer on xattr's value
+ * @size: xattr's value size
+ * @flags: operation flags
+ */
+int nilfs_xafile_setxattr(struct inode *inode,
+				int name_index, const char *name,
+				const void *value, size_t size, int flags)
+{
+	int err = 0;
+	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
+	struct nilfs_xattr_search data;
+
+	if (!nilfs_has_xafile(nilfs))
+		return -EOPNOTSUPP;
+
+	if (!name)
+		return -EINVAL;
+	if (strlen(name) > XATTR_NAME_MAX)
+		return -ERANGE;
+
+	err = nilfs_xattr_search_init(inode, name_index, (char *)name, &data);
+	if (unlikely(err))
+		return err;
+
+	if (IS_NODE_DESC_INVALID(NODE_ID(&data.node))) {
+		err = nilfs_xafile_prepare_new_node(inode, &data);
+		if (unlikely(err)) {
+			nilfs_xafile_abort_new_node(inode, &data);
+			goto failed_xafile_setxattr;
+		}
+
+		nilfs_xafile_commit_new_node(inode, &data);
+
+		NILFS_I(inode)->i_xattr = NODE_ID(&data.node);
+		nilfs_mark_inode_dirty(inode);
+	} else
+		err = nilfs_xafile_find_node(inode, &data);
+
+	if (unlikely(err && err != -ENODATA))
+		goto failed_xafile_setxattr;
+	else if (!data.result.found) {
+		err = -ENODATA;
+		if (flags & XATTR_REPLACE)
+			goto cleanup;
+		err = 0;
+		if (!value)
+			goto cleanup;
+	} else {
+		err = -EEXIST;
+		if (flags & XATTR_CREATE)
+			goto cleanup;
+	}
+
+	if (flags & XATTR_REPLACE) {
+		if (!value) {
+			err = nilfs_xafile_delete_entry(inode, &data);
+			if (unlikely(err))
+				goto cleanup;
+		} else {
+			err = nilfs_xafile_set_entry(inode, &data, value, size);
+			if (unlikely(err))
+				goto cleanup;
+		}
+	} else {
+		err = nilfs_xafile_set_entry(inode, &data, value, size);
+		if (unlikely(err))
+			goto cleanup;
+	}
+
+cleanup:
+	brelse(NODE_BH(&data.node));
+
+failed_xafile_setxattr:
+	nilfs_xattr_search_release(&data);
+	return err;
+}
+
+/*
+ * nilfs_xafile_delete_inode - delete all xattrs during inode eviction
+ * @inode: inode pointer
+ */
+int nilfs_xafile_delete_inode(struct inode *inode)
+{
+	int err;
+	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
+	struct inode *xafile = nilfs->ns_xafile;
+	__u64 node = NILFS_I(inode)->i_xattr;
+	struct nilfs_palloc_req req = {0};
+
+	if (!nilfs_has_xafile(nilfs))
+		return 0;
+
+	if (node == NILFS_INVALID_XANODE)
+		return 0;
+
+	req.pr_entry_nr = node;
+
+	err = nilfs_xafile_prepare_node_deletion(xafile, &req);
+	if (unlikely(err)) {
+		printk(KERN_ERR "NILFS: can't delete xanode %llu\n",
+			node);
+		return err;
+	}
+
+	nilfs_xafile_commit_node_deletion(xafile, &req);
+
+	return 0;
+}
diff --git a/fs/nilfs2/xattr.c b/fs/nilfs2/xattr.c
index 7be523a..2e2f5f5 100644
--- a/fs/nilfs2/xattr.c
+++ b/fs/nilfs2/xattr.c
@@ -62,3 +62,29 @@ ssize_t __nilfs_getxattr(struct inode *inode,
 
 	return ret;
 }
+
+int __nilfs_setxattr(struct inode *inode,
+			int name_index, const char *name,
+			const void *value, size_t size,
+			int flags)
+{
+	int err;
+
+	down_write(&NILFS_I(inode)->xattr_sem);
+	err = nilfs_xafile_setxattr(inode, name_index, name,
+					value, size, flags);
+	up_write(&NILFS_I(inode)->xattr_sem);
+
+	return err;
+}
+
+int nilfs_xattr_delete_inode(struct inode *inode)
+{
+	int err;
+
+	down_write(&NILFS_I(inode)->xattr_sem);
+	err = nilfs_xafile_delete_inode(inode);
+	up_write(&NILFS_I(inode)->xattr_sem);
+
+	return err;
+}
diff --git a/fs/nilfs2/xattr.h b/fs/nilfs2/xattr.h
index 0736086..104a60d 100644
--- a/fs/nilfs2/xattr.h
+++ b/fs/nilfs2/xattr.h
@@ -39,6 +39,21 @@ static inline ssize_t nilfs_getxattr(struct dentry *dentry,
 	return __nilfs_getxattr(dentry->d_inode, name_index, name, value, size);
 }
 
+int __nilfs_setxattr(struct inode *inode,
+			int name_index, const char *name,
+			const void *value, size_t size, int flags);
+
+static inline int nilfs_setxattr(struct dentry *dentry,
+					int name_index, const char *name,
+					const void *value, size_t size,
+					int flags)
+{
+	return __nilfs_setxattr(dentry->d_inode,
+					name_index, name,
+					value, size, flags);
+}
+
 ssize_t nilfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
+int nilfs_xattr_delete_inode(struct inode *inode);
 
 #endif /* _NILFS_XATTR_H */
-- 
1.7.9.5



