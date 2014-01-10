From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC][STEP 1][PATCH v2 08/17] nilfs2: implement
 prepare-(commit|abort) pair of xanode change functionality
Date: Fri, 10 Jan 2014 16:08:48 +0400
Message-ID: <1389355728.3938.129.camel@slavad-ubuntu>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=CrLUVFMV4Aqk36BJOJ56Zpp1DKzR1j/lv25CDMq9CvA=;
	b=jqko3uS+2D7P3ykm60otGNZ2cZm2+Hr2DeCtxwDUgXiYO/hJ8yvMR5S8qrtsR0TevqJRG/rwUNFbrDnh2TT+cpwuqp9iZcbfeDY3mTJcru97Mvz6Cj9rPJkMqsPQ0T/8;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC][STEP 1][PATCH v2 08/17] nilfs2: implement prepare-(commit|abort) pair of xanode change functionality

This patch adds functionality of new xanode initialization, preparation
for modification and commit/abort at the end of modification operation.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/xafile.c |  269 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 269 insertions(+)

diff --git a/fs/nilfs2/xafile.c b/fs/nilfs2/xafile.c
index 03641df..73904c1 100644
--- a/fs/nilfs2/xafile.c
+++ b/fs/nilfs2/xafile.c
@@ -1029,3 +1029,272 @@ start_entry_search:
 failed_find_node:
 	return err;
 }
+
+/*
+ * __nilfs_xafile_node_init - initialize newly created xanode in memory
+ * @inode: inode pointer
+ * @node_type: xanode type
+ * @buf: xanode's buffer in memory
+ * @buf_size: buffer size
+ */
+static
+void __nilfs_xafile_node_init(struct inode *inode,
+				int node_type,
+				void *buf, size_t buf_size)
+{
+	union nilfs_xanode_header *hdr = NILFS_XANODE_HDR(buf);
+
+#ifdef CONFIG_NILFS2_FS_DEBUG
+	BUG_ON(node_type > NILFS_XATTR_TREE_XANODE_TYPE);
+#endif
+
+	switch (node_type) {
+	case NILFS_XATTR_TREE_XANODE_TYPE:
+		hdr->tree_hdr.magic = cpu_to_le16(NILFS_XANODE_MAGIC);
+		hdr->tree_hdr.flags = NILFS_XANODE_SET_TYPE(node_type, hdr);
+		hdr->tree_hdr.flags =
+			NILFS_XANODE_SET_FLAGS(NILFS_XANODE_CRC32_FLAG, hdr);
+		hdr->tree_hdr.height = 0;
+		hdr->tree_hdr.log_index_keys =
+				ilog2(NILFS_XANODE_MIN_INDEX_KEYS);
+		hdr->tree_hdr.entries = 0;
+		hdr->tree_hdr.checksum = 0;
+		hdr->tree_hdr.index_keys = 0;
+		hdr->tree_hdr.parent_node = cpu_to_le64(NILFS_INVALID_XANODE);
+		break;
+
+	default:
+		BUG();
+	};
+}
+
+/*
+ * nilfs_xafile_node_init - initialize new xanode and mark buffer dirty
+ * @inode: inode pointer
+ * @node: xanode number (index in xafile)
+ * @node_type: xanode type
+ * @bh: xanode buffer
+ */
+/*static
+void nilfs_xafile_node_init(struct inode *inode, __u64 node,
+				int node_type, struct buffer_head *bh)
+{
+	__nilfs_xafile_node_init(inode, node_type, BH_DATA(bh), BH_SIZE(bh));
+
+	switch(node_type) {
+	case NILFS_XATTR_TREE_XANODE_TYPE:
+		NILFS_XANODE_HDR(BH_DATA(bh))->tree_hdr.checksum =
+			nilfs_xafile_node_crc32(inode, BH_DATA(bh),
+						BH_SIZE(bh), node);
+		break;
+
+	default:
+		BUG();
+	};
+
+	mark_buffer_dirty(bh);
+}*/
+
+/*
+ * nilfs_xafile_prepare_new_node - prepare new xanode for shadow modifications
+ * @inode: inode pointer
+ * @new_node: prepared internal xattr search structure [out]
+ */
+static
+int nilfs_xafile_prepare_new_node(struct inode *inode,
+					struct nilfs_xattr_search *new_node)
+{
+	int err;
+	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
+	struct inode *xafile = nilfs->ns_xafile;
+	union nilfs_xanode_header *hdr;
+	char *buf;
+
+#ifdef CONFIG_NILFS2_FS_DEBUG
+	BUG_ON(!IS_SEARCH_RESULT_EMPTY(new_node));
+#endif
+
+	err = nilfs_xafile_prepare_node_creation(xafile, &new_node->node.req);
+	if (unlikely(err)) {
+		printk(KERN_ERR "NILFS: can't prepare new xafile node\n");
+		return err;
+	}
+
+	buf = kzalloc(BH_SIZE(NODE_BH(&new_node->node)), GFP_NOFS);
+	if (!buf) {
+		nilfs_xafile_abort_node_creation(xafile, &new_node->node.req);
+		return -ENOMEM;
+	}
+
+	/* TODO: [REWORK] it is used tree type temporary */
+	__nilfs_xafile_node_init(inode, NILFS_XATTR_TREE_XANODE_TYPE,
+				 buf, BH_SIZE(NODE_BH(&new_node->node)));
+
+	hdr = NILFS_XANODE_HDR(buf);
+	new_node->result.hdr = hdr;
+	new_node->result.key = NILFS_XANODE_FIRST_NOT_INDEX_KEY(hdr);
+	new_node->result.entry = NULL;
+	new_node->result.found = false;
+
+	new_node->node.flags = NILFS_DIRTY_SHADOW_XANODE;
+	new_node->node.shadow_copy = buf;
+
+	set_buffer_nilfs_volatile(NODE_BH(&new_node->node));
+
+	return 0;
+}
+
+/*
+ * nilfs_xafile_prepare_node_for_change - prepare xanode for shadow changes
+ * @inode: inode pointer
+ * @data: internal xattr search structure
+ */
+static
+int nilfs_xafile_prepare_node_for_change(struct inode *inode,
+					 struct nilfs_xattr_search *data)
+{
+	int err;
+	char *buf;
+	size_t node_size;
+	union nilfs_xanode_header *hdr;
+
+#ifdef CONFIG_NILFS2_FS_DEBUG
+	BUG_ON(data->node.shadow_copy);
+#endif
+
+	node_size = BH_SIZE(NODE_BH(&data->node));
+
+	buf = kmalloc(node_size, GFP_NOFS);
+	if (!buf) {
+		err = -ENOMEM;
+		goto cleanup_after_failure;
+	}
+
+	memcpy(buf, BH_DATA(NODE_BH(&data->node)), node_size);
+	data->node.flags = NILFS_SHADOW_XANODE;
+	data->node.shadow_copy = buf;
+
+	hdr = NILFS_XANODE_HDR(buf);
+
+	if (IS_SEARCH_KEY_EMPTY(data)) {
+		data->result.hdr = hdr;
+		data->result.key = NILFS_XANODE_FIRST_NOT_INDEX_KEY(hdr);
+		data->result.entry = NULL;
+		data->result.found = false;
+	} else if (IS_SEARCH_RESULT_EMPTY(data)) {
+		err = nilfs_xafile_find_entry(inode, data);
+		if (unlikely(err && err != -ENODATA))
+			goto cleanup_after_failure;
+	}
+
+	set_buffer_nilfs_volatile(NODE_BH(&data->node));
+
+	return 0;
+
+cleanup_after_failure:
+	nilfs_xattr_search_release(data);
+	return err;
+}
+
+/*
+ * nilfs_xafile_commit_changed_node - commit xanode's shadow changes
+ * @inode: inode pointer
+ * @data: internal xattr search structure
+ */
+static
+void nilfs_xafile_commit_changed_node(struct inode *inode,
+					struct nilfs_xattr_search *data)
+{
+	int err;
+	union nilfs_xanode_header *hdr;
+	struct buffer_head *bh;
+	size_t node_size;
+	__u64 node;
+
+#ifdef CONFIG_NILFS2_FS_DEBUG
+	BUG_ON(IS_SEARCH_RESULT_EMPTY(data));
+	BUG_ON(!data->node.shadow_copy);
+	BUG_ON(!buffer_nilfs_volatile(NODE_BH(&data->node)));
+#endif
+
+	hdr = data->result.hdr;
+	bh = NODE_BH(&data->node);
+	clear_buffer_nilfs_checked(bh);
+	node_size = BH_SIZE(NODE_BH(&data->node));
+	node = NODE_ID(&data->node);
+
+	/* TODO: [REWORK] temporary only tree xanode is used */
+	hdr->tree_hdr.checksum = nilfs_xafile_node_crc32(inode, (char *)hdr,
+							 node_size, node);
+
+	lock_buffer(bh);
+	memcpy(BH_DATA(bh), hdr, node_size);
+	unlock_buffer(bh);
+
+	err = nilfs_xafile_check_node(inode, node, bh);
+	if (unlikely(err))
+		printk(KERN_WARNING "NILFS: xanode is corrupted\n");
+#ifdef CONFIG_NILFS2_FS_DEBUG
+	BUG_ON(unlikely(err));
+#endif
+
+	mark_buffer_dirty(bh);
+	clear_buffer_nilfs_volatile(bh);
+	nilfs_mark_inode_dirty(inode);
+
+	kfree(data->node.shadow_copy);
+	data->node.shadow_copy = NULL;
+	data->node.flags = NILFS_RO_XANODE;
+}
+
+/*
+ * nilfs_xafile_commit_new_node - commit new xanode's shadow changes
+ * @inode: inode pointer
+ * @data: internal xattr search structure
+ */
+static
+void nilfs_xafile_commit_new_node(struct inode *inode,
+				  struct nilfs_xattr_search *data)
+{
+	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
+	struct inode *xafile = nilfs->ns_xafile;
+	struct buffer_head *bh;
+
+#ifdef CONFIG_NILFS2_FS_DEBUG
+	BUG_ON(!data->node.shadow_copy);
+#endif
+
+	bh = NODE_BH(&data->node);
+
+	nilfs_xafile_commit_changed_node(inode, data);
+	nilfs_xafile_commit_node_creation(xafile, &data->node.req);
+}
+
+/*
+ * nilfs_xafile_abort_node_change - abort xanode's shadow changes
+ * @data: internal xattr search structure
+ */
+static inline
+void nilfs_xafile_abort_node_change(struct nilfs_xattr_search *data)
+{
+	if (data && NODE_BH(&data->node))
+		clear_buffer_nilfs_volatile(NODE_BH(&data->node));
+	if (data)
+		nilfs_xattr_search_release(data);
+}
+
+/*
+ * nilfs_xafile_abort_new_node - complete abort xanode creation
+ * @inode: inode pointer
+ * @data: internal xattr search structure
+ */
+static inline
+void nilfs_xafile_abort_new_node(struct inode *inode,
+				 struct nilfs_xattr_search *data)
+{
+	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
+	struct inode *xafile = nilfs->ns_xafile;
+
+	nilfs_xafile_abort_node_creation(xafile, &data->node.req);
+	nilfs_xafile_abort_node_change(data);
+}
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
