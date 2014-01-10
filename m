From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC][STEP 1][PATCH v2 06/17] nilfs2: implement base functionality
 of search in xanode
Date: Fri, 10 Jan 2014 16:08:21 +0400
Message-ID: <1389355701.3938.126.camel@slavad-ubuntu>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=9mjJLzA81PhS410/rnjuFfhtV2tWyPNt69bP8SSmNvI=;
	b=aD+8P5AMvMpPsHBI3+eXuuzpge4MbjOvTr4GEPQNY+uQGHyxvefXjvVPcIQAEMF52JIQ8VW2eoeLryNuhccoXTmIuz4fs7qtujW7aO9YZUoF9D4R7kom+UBkQBJQOw5B;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC][STEP 1][PATCH v2 06/17] nilfs2: implement base functionality of search in xanode

This patch adds implementation of base functionality of searching
in xanode.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/xafile.c |  356 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 356 insertions(+)

diff --git a/fs/nilfs2/xafile.c b/fs/nilfs2/xafile.c
index c84cf90..feee18d 100644
--- a/fs/nilfs2/xafile.c
+++ b/fs/nilfs2/xafile.c
@@ -131,6 +131,93 @@ struct nilfs_xafile_info {
 };
 
 /*
+ * struct nilfs_xattr_search_key - search input
+ * @name_hash: complex hash of name
+ * @name: xattr name
+ */
+struct nilfs_xattr_search_key {
+	struct nilfs_xattr_name_hash name_hash;
+	char *name;
+};
+
+/*
+ * struct nilfs_xattr_search_result - result of a search
+ * @hdr: xanode header
+ * @key: found key
+ * @entry: found entry
+ * @found: is found entry identical to request?
+ */
+struct nilfs_xattr_search_result {
+	union nilfs_xanode_header *hdr;
+	union nilfs_xattr_key *key;
+	struct nilfs_xanode_entry *entry;
+	bool found;
+};
+
+/*
+ * struct nilfs_xafile_node - found xanode details
+ * @flags: description of a xanode state
+ * @req: xanode details
+ * @shadow_copy: copy of xanode for preliminary modification
+ */
+struct nilfs_xafile_node {
+#define NILFS_NULL_XANODE		0
+#define NILFS_RO_XANODE			1
+#define NILFS_SHADOW_XANODE		2
+#define NILFS_DIRTY_SHADOW_XANODE	3
+	int flags;
+	struct nilfs_palloc_req req;
+	char *shadow_copy;
+};
+
+#define NILFS_XANODE_DESC(ptr) \
+	((struct nilfs_xafile_node *)(ptr))
+
+#define NODE_BH(desc) \
+	(NILFS_XANODE_DESC(desc)->req.pr_entry_bh)
+#define NODE_ID(desc) \
+	(NILFS_XANODE_DESC(desc)->req.pr_entry_nr)
+
+#define IS_NODE_DESC_INVALID(node) \
+	(node == NILFS_INVALID_XANODE)
+#define IS_NULL_XANODE_DESC(desc) \
+	(NILFS_XANODE_DESC(desc)->flags == NILFS_NULL_XANODE)
+#define IS_RO_XANODE_DESC(desc) \
+	(NILFS_XANODE_DESC(desc)->flags == NILFS_RO_XANODE)
+#define IS_SHADOW_XANODE_DESC(desc) \
+	((NILFS_XANODE_DESC(desc)->flags == NILFS_SHADOW_XANODE || \
+	 NILFS_XANODE_DESC(desc)->flags == NILFS_DIRTY_SHADOW_XANODE) && \
+	 NILFS_XANODE_DESC(desc)->shadow_copy != NULL)
+#define IS_DIRTY_XANODE_DESC(desc) \
+	(NILFS_XANODE_DESC(desc)->flags == NILFS_DIRTY_SHADOW_XANODE)
+
+/*
+ * struct nilfs_xattr_search - search input and result
+ * @search: search input
+ * @result: search result
+ * @node: found node details
+ */
+struct nilfs_xattr_search {
+	struct nilfs_xattr_search_key search;
+	struct nilfs_xattr_search_result result;
+	struct nilfs_xafile_node node;
+};
+
+#define NILFS_XATTR_SEARCH(ptr) \
+	((struct nilfs_xattr_search *)(ptr))
+
+#define IS_SEARCH_KEY_EMPTY(data) \
+	(*(u64 *)(&NILFS_XATTR_SEARCH(data)->search.name_hash) == 0 && \
+	 NILFS_XATTR_SEARCH(data)->search.name == NULL)
+#define IS_SEARCH_RESULT_EMPTY(data) \
+	(NILFS_XATTR_SEARCH(data)->result.hdr == NULL && \
+	 NILFS_XATTR_SEARCH(data)->result.key == NULL && \
+	 NILFS_XATTR_SEARCH(data)->result.entry == NULL)
+#define IS_XATTR_SEARCH_INITIALIZED(data) \
+	(!IS_SEARCH_KEY_EMPTY(data) && \
+	 IS_SEARCH_RESULT_EMPTY(data))
+
+/*
  * NILFS_XAFILE_I - convert inode info into xafile inode info
  */
 static inline
@@ -363,3 +450,272 @@ int nilfs_xafile_read(struct super_block *sb, struct nilfs_inode *raw_inode,
 	iget_failed(xafile);
 	return err;
 }
+
+/*
+ * nilfs_xattr_search_init - initialize xattr search
+ * @inode: inode pointer
+ * @name_index: xattr name index
+ * @name: xattr name
+ * @xs: pointer on xattr search structure [out]
+ *
+ * The function initializes internal data for xattr search
+ * and manipulation by xanode.
+ */
+static
+int nilfs_xattr_search_init(struct inode *inode,
+				int name_index, char *name,
+				struct nilfs_xattr_search *xs)
+{
+	int err;
+
+	memset(xs, 0, sizeof(struct nilfs_xattr_search));
+
+	err = calc_name_hash(name_index, name, &xs->search.name_hash);
+	if (unlikely(err))
+		return err;
+
+	xs->search.name = name;
+	xs->result.found = false;
+	xs->node.flags = NILFS_NULL_XANODE;
+	NODE_ID(&xs->node) = NILFS_I(inode)->i_xattr;
+
+	return 0;
+}
+
+/*
+ * nilfs_xattr_search_release - cleanup operation after xattr search
+ * @xs: pointer on xattr search structure
+ */
+static
+void nilfs_xattr_search_release(struct nilfs_xattr_search *xs)
+{
+	memset(&xs->search, 0, sizeof(xs->search));
+
+	memset(&xs->result, 0, sizeof(xs->result));
+	xs->result.found = false;
+
+	xs->node.flags = NILFS_NULL_XANODE;
+	NODE_ID(&xs->node) = NILFS_INVALID_XANODE;
+	NODE_BH(&xs->node) = NULL;
+	kfree(xs->node.shadow_copy);
+	xs->node.shadow_copy = NULL;
+}
+
+/*
+ * nilfs_xafile_check_entry - check xattr entry
+ * @key: xattr's key
+ * @entry: xattr's entry
+ * @node_size: xanode size
+ */
+static inline
+int nilfs_xafile_check_entry(union nilfs_xattr_key *key,
+				struct nilfs_xanode_entry *entry,
+				size_t node_size)
+{
+	__u16 entry_offset = NILFS_XANODE_ENTRY_OFFSET(key);
+	__u16 entry_size = NILFS_XANODE_ENTRY_SIZE(key);
+	__u16 name_len = NILFS_XANODE_NAME_HASH(key)->name_len;
+
+	if ((entry_offset + entry_size) > node_size)
+		return -EIO;
+	if (entry_size < name_len)
+		return -EIO;
+	return 0;
+}
+
+/*
+ * nilfs_xafile_node_key_compare - compare xattr's and search keys
+ * @lkey: xattr's key
+ * @search: search key
+ */
+static
+int nilfs_xafile_node_key_compare(union nilfs_xattr_key *lkey,
+					struct nilfs_xattr_search_key *search)
+{
+	struct nilfs_xattr_name_hash *lhash;
+	struct nilfs_xattr_name_hash *rhash;
+
+#ifdef CONFIG_NILFS2_FS_DEBUG
+	BUG_ON(IS_END_KEY(lkey));
+#endif
+
+	lhash = NILFS_XANODE_NAME_HASH(lkey);
+	rhash = &search->name_hash;
+
+	if (lhash->name_len < rhash->name_len)
+		return -1;
+	else if (lhash->name_len > rhash->name_len)
+		return 1;
+
+	/* lhash->name_len == rhash->name_len */
+	if (lhash->name_index < rhash->name_index)
+		return -1;
+	else if (lhash->name_index > rhash->name_index)
+		return 1;
+
+	/* lhash->name_index == rhash->name_index */
+	if (lhash->first_symbol < rhash->first_symbol)
+		return -1;
+	else if (lhash->first_symbol > rhash->first_symbol)
+		return 1;
+
+	/* lhash->first_symbol == rhash->first_symbol */
+	if (lhash->last_symbol < rhash->last_symbol)
+		return -1;
+	else if (lhash->last_symbol > rhash->last_symbol)
+		return 1;
+
+	if (lhash->hash == rhash->hash)
+		return 0;
+	else if (lhash->hash < rhash->hash)
+		return -1;
+	else
+		return 1;
+}
+
+/*
+ * xafile_entry_has_requested_name - check identity of xattr and search names
+ * @name: searching name
+ * @res: found xattr's name
+ */
+static inline
+int xafile_entry_has_requested_name(const char *name,
+					struct nilfs_xattr_search_result *res)
+{
+	size_t name_len = strlen(name);
+
+	if (name_len != NILFS_XANODE_NAME_HASH(res->key)->name_len)
+		return -1;
+	return memcmp(res->entry->name, name, name_len);
+}
+
+/*
+ * is_xafile_entry_found - check that xattr is found
+ * @data: internal xattr search structure
+ */
+static
+int is_xafile_entry_found(struct nilfs_xattr_search *data)
+{
+	int cmp;
+	size_t node_size = NILFS_XANODE_SIZE;
+	int res;
+
+	if (NILFS_XANODE_ENTRIES(data->result.hdr) == 0) {
+		if (IS_END_KEY(data->result.key)) {
+			data->result.found = false;
+			return 0;
+		} else
+			BUG();
+	}
+
+#ifdef CONFIG_NILFS2_FS_DEBUG
+	BUG_ON(IS_END_KEY(data->result.key));
+#endif
+
+	data->result.entry =
+		NILFS_XANODE_ENTRY(data->result.key, data->result.hdr);
+
+	cmp = nilfs_xafile_node_key_compare(data->result.key,
+						&data->search);
+	if (cmp == 0) {
+		cmp = xafile_entry_has_requested_name(data->search.name,
+							&data->result);
+	}
+
+	if (cmp == 0) {
+		data->result.found = true;
+		res = nilfs_xafile_check_entry(data->result.key,
+						data->result.entry,
+						node_size);
+		if (res < 0)
+			printk(KERN_WARNING "NILFS: corrupted xafile entry\n");
+#ifdef CONFIG_NILFS2_FS_DEBUG
+		BUG_ON(res < 0);
+#endif
+	}
+
+	return cmp;
+}
+
+/*
+ * nilfs_xafile_find_entry - search xattr in xanode
+ * @inode: inode pointer
+ * @data: internal xattr search structure
+ */
+static
+int nilfs_xafile_find_entry(struct inode *inode,
+				struct nilfs_xattr_search *data)
+{
+	union nilfs_xattr_key *first_key = NULL;
+	size_t name_len;
+	int cmp;
+	int index, low, high;
+
+#ifdef CONFIG_NILFS2_FS_DEBUG
+	BUG_ON(!IS_XATTR_SEARCH_INITIALIZED(data));
+#endif
+
+	if (data->search.name == NULL)
+		return -EINVAL;
+
+	name_len = strlen(data->search.name);
+	data->result.found = false;
+
+	if (IS_RO_XANODE_DESC(&data->node))
+		data->result.hdr =
+			NILFS_XANODE_HDR(BH_DATA(NODE_BH(&data->node)));
+	else
+		data->result.hdr = NILFS_XANODE_HDR(data->node.shadow_copy);
+
+	data->result.key = NILFS_XANODE_LAST_NOT_INDEX_KEY(data->result.hdr);
+	cmp = is_xafile_entry_found(data);
+
+	if (cmp == 0)
+		return 0;
+	else if (cmp < 0) { /* cur_key < search_key */
+		__u32 *end_key = NILFS_XANODE_END_KEY(data->result.hdr);
+
+		data->result.key = NILFS_XANODE_KEY(end_key);
+		return -ENODATA;
+	}
+
+	data->result.key = NILFS_XANODE_FIRST_NOT_INDEX_KEY(data->result.hdr);
+	cmp = is_xafile_entry_found(data);
+
+	if (cmp == 0)
+		return 0;
+	else if (cmp > 0) /* cur_key > search_key */
+		return -ENODATA;
+
+	cmp = -1;
+	low = 0;
+	high = NILFS_XANODE_ENTRIES(data->result.hdr);
+	if (high > 0)
+		high -= 1;
+	index = 0;
+	first_key = data->result.key;
+
+	while (low <= high) {
+		index = (low + high) / 2;
+		data->result.key = NEXT_KEY(first_key, index);
+
+		cmp = is_xafile_entry_found(data);
+
+		if (cmp < 0) {
+			/* continue search in greater half */
+			low = index + 1;
+			data->result.key = NEXT_KEY(first_key, low);
+			data->result.entry =
+				NILFS_XANODE_ENTRY(data->result.key,
+							data->result.hdr);
+		} else if (cmp > 0) {
+			/* continue search in lower half */
+			high = index - 1;
+		} else {
+			/* cmp == 0 */
+			return 0;
+		}
+	}
+
+	return -ENODATA;
+}
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
