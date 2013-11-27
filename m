From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC][PATCH 09/15] nilfs2: implement listxattr and getxattr
 functionality
Date: Wed, 27 Nov 2013 16:42:47 +0400
Message-ID: <1385556167.2589.75.camel@slavad-ubuntu>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=2u8obsJGPNS9uwta/FP/Io1twO1wCGRg0TM/yncLXqA=;
	b=e5uO4K0xn00JYqNVFc8B8b3D/e2j2xc1E8z8CYi59CjwITMennbbenPJXV48f5sXPZrxCQa2arTG3cio3kDPT4cF7Y23Kt11OYL9KUe9GbnTH1Qwvmuk9WJrevnBbrRk;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC][PATCH 09/15] nilfs2: implement listxattr and getxattr functionality

This patch adds functionality listxattr and getxattr operations.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/xafile.c |  167 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/xafile.h |   20 +++++++
 fs/nilfs2/xattr.c  |   64 ++++++++++++++++++++
 fs/nilfs2/xattr.h  |   44 ++++++++++++++
 4 files changed, 295 insertions(+)
 create mode 100644 fs/nilfs2/xattr.c
 create mode 100644 fs/nilfs2/xattr.h

diff --git a/fs/nilfs2/xafile.c b/fs/nilfs2/xafile.c
index 6511da7..e89e95b 100644
--- a/fs/nilfs2/xafile.c
+++ b/fs/nilfs2/xafile.c
@@ -220,6 +220,19 @@ struct nilfs_xattr_search {
 	(!IS_SEARCH_KEY_EMPTY(data) && \
 	 IS_SEARCH_RESULT_EMPTY(data))
 
+/* Map of xattr handlers */
+static const struct xattr_handler *nilfs_xattr_handler_map[] = {
+	[NILFS_USER_XATTR_ID] = &nilfs_xattr_user_handler,
+#ifdef CONFIG_NILFS2_FS_POSIX_ACL
+	[NILFS_POSIX_ACL_ACCESS_XATTR_ID] = &nilfs_xattr_acl_access_handler,
+	[NILFS_POSIX_ACL_DEFAULT_XATTR_ID] = &nilfs_xattr_acl_default_handler,
+#endif
+	[NILFS_TRUSTED_XATTR_ID] = &nilfs_xattr_trusted_handler,
+#ifdef CONFIG_NILFS2_FS_SECURITY
+	[NILFS_SECURITY_XATTR_ID] = &nilfs_xattr_security_handler,
+#endif
+};
+
 /*
  * NILFS_XAFILE_I - convert inode info into xafile inode info
  */
@@ -230,6 +243,19 @@ struct nilfs_xafile_info *NILFS_XAFILE_I(struct inode *xafile)
 }
 
 /*
+ * nilfs_xattr_handler - get xattr handler by name index
+ */
+static inline
+const struct xattr_handler *nilfs_xattr_handler(int name_index)
+{
+	const struct xattr_handler *handler = NULL;
+
+	if (name_index > 0 && name_index < ARRAY_SIZE(nilfs_xattr_handler_map))
+		handler = nilfs_xattr_handler_map[name_index];
+	return handler;
+}
+
+/*
  * nilfs_xafile_get_node - get xafile node
  * @xafile: xafile inode
  * @node_id: node number
@@ -1300,3 +1326,144 @@ void nilfs_xafile_abort_new_node(struct inode *inode,
 	nilfs_xafile_abort_node_creation(xafile, &data->node.req);
 	nilfs_xafile_abort_node_change(data);
 }
+
+/*
+ * nilfs_xattr_list_entries - list inode's xattrs from one xanode
+ * @dentry: dentry object
+ * @bh: xanode's buffer
+ * @buf: buffer for getting xattrs' list [out]
+ * @size: buffer size
+ */
+static
+int nilfs_xattr_list_entries(struct dentry *dentry, struct buffer_head *bh,
+				char *buf, size_t buf_size)
+{
+	union nilfs_xanode_header *hdr = NILFS_XANODE_HDR(BH_DATA(bh));
+	union nilfs_xattr_key *key;
+	size_t rest = buf_size;
+
+	key = NILFS_XANODE_FIRST_NOT_INDEX_KEY(hdr);
+
+	for (; !IS_END_KEY(key); key = NEXT_KEY(key, 1)) {
+		u8 name_index = NILFS_XANODE_NAME_HASH(key)->name_index;
+		const struct nilfs_xanode_entry *entry =
+					NILFS_XANODE_ENTRY(key, BH_DATA(bh));
+		const struct xattr_handler *handler =
+				nilfs_xattr_handler(name_index);
+		__u8 name_len = NILFS_XANODE_NAME_HASH(key)->name_len;
+
+		if (handler) {
+			size_t size = handler->list(dentry, buf, rest,
+						    entry->name, name_len,
+						    handler->flags);
+			if (buf) {
+				if (size > rest)
+					return -ERANGE;
+				buf += size;
+			}
+			rest -= size;
+		}
+	}
+
+	return buf_size - rest;
+}
+
+/*
+ * nilfs_xafile_listxattr - list all inode's xattrs
+ * @dentry: dentry object
+ * @buffer: buffer for getting xattrs' list [out]
+ * @size: buffer size
+ */
+ssize_t nilfs_xafile_listxattr(struct dentry *dentry, char *buffer, size_t size)
+{
+	ssize_t ret = 0, err = 0;
+	struct inode *inode = dentry->d_inode;
+	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
+	struct buffer_head *bh = NULL;
+	__u64 node = NILFS_I(inode)->i_xattr;
+
+	if (!nilfs_has_xafile(nilfs))
+		return -EOPNOTSUPP;
+
+	if (node == NILFS_INVALID_XANODE)
+		return 0;
+
+	err = nilfs_xafile_get_checked_node(inode, node, &bh);
+	if (unlikely(err))
+		goto failed_xafile_listxattr;
+
+	err = nilfs_xattr_list_entries(dentry, bh, buffer, size);
+	if (unlikely(err < 0))
+		goto cleanup_after_failure;
+	else
+		ret += err;
+
+	brelse(bh);
+	return ret;
+
+cleanup_after_failure:
+	brelse(bh);
+
+failed_xafile_listxattr:
+	return err;
+}
+
+/*
+ * nilfs_xafile_getxattr - get xattr
+ * @inode: inode pointer
+ * @name: xattr's name
+ * @value: buffer for xattr's value [out]
+ * @size: buffer size
+ */
+ssize_t nilfs_xafile_getxattr(struct inode *inode,
+				int name_index, const char *name,
+				void *value, size_t size)
+{
+	ssize_t ret, err;
+	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
+	struct nilfs_xattr_search data;
+
+	if (!nilfs_has_xafile(nilfs))
+		return -EOPNOTSUPP;
+
+	if (NILFS_I(inode)->i_xattr == NILFS_INVALID_XANODE)
+		return -ENODATA;
+
+	err = nilfs_xattr_search_init(inode, name_index, (char *)name, &data);
+	if (unlikely(err))
+		return err;
+
+	err = nilfs_xafile_find_node(inode, &data);
+	if (unlikely(err)) {
+		ret = err;
+		goto failed_xafile_getxattr;
+	}
+
+	if (!data.result.found) {
+		ret = -ENODATA;
+		goto cleanup_after_failure;
+	}
+
+	ret = NILFS_XANODE_ENTRY_SIZE(data.result.key) -
+		NILFS_XANODE_NAME_HASH(data.result.key)->name_len;
+
+	if (value) {
+		char *xattr_value;
+
+		if (ret > size) {
+			ret = -ERANGE;
+			goto cleanup_after_failure;
+		}
+
+		xattr_value = NILFS_XATTR_VALUE(data.result.entry,
+						data.result.key);
+		memcpy(value, xattr_value, ret);
+	}
+
+cleanup_after_failure:
+	brelse(NODE_BH(&data.node));
+
+failed_xafile_getxattr:
+	nilfs_xattr_search_release(&data);
+	return ret;
+}
diff --git a/fs/nilfs2/xafile.h b/fs/nilfs2/xafile.h
index 846ea3a..50c4735 100644
--- a/fs/nilfs2/xafile.h
+++ b/fs/nilfs2/xafile.h
@@ -29,6 +29,20 @@
 /* Magic number of xafile node */
 #define NILFS_XANODE_MAGIC		0x5841 /* XA */
 
+/* Name indexes */
+#define NILFS_USER_XATTR_ID			1
+#define NILFS_POSIX_ACL_ACCESS_XATTR_ID		2
+#define NILFS_POSIX_ACL_DEFAULT_XATTR_ID	3
+#define NILFS_TRUSTED_XATTR_ID			4
+#define NILFS_SECURITY_XATTR_ID			5
+#define NILFS_SYSTEM_XATTR_ID			6
+#define NILFS_RICHACL_XATTR_ID			7
+#define NILFS_XATTR_MAX_ID			255
+
+#define IS_NAME_ID_VALID(name_index) \
+	(name_index < NILFS_USER_XATTR_ID || \
+	 name_index > NILFS_RICHACL_XATTR_ID)
+
 /* Xanode types */
 #define NILFS_UNKNOWN_XANODE_TYPE		0
 /* Temporary, numbers from 1 till 6 are simply reserved */
@@ -417,6 +431,12 @@ NILFS_XANODE_LAST_ENTRY(union nilfs_xanode_header *hdr)
 #define NILFS_XATTR_VALUE(entry, key) \
 	((char *)(entry) + NILFS_XANODE_NAME_HASH(key)->name_len)
 
+extern const struct xattr_handler nilfs_xattr_user_handler;
+extern const struct xattr_handler nilfs_xattr_trusted_handler;
+extern const struct xattr_handler nilfs_xattr_acl_access_handler;
+extern const struct xattr_handler nilfs_xattr_acl_default_handler;
+extern const struct xattr_handler nilfs_xattr_security_handler;
+
 /* Xafile API */
 ssize_t nilfs_xafile_listxattr(struct dentry *dentry, char *buf, size_t size);
 ssize_t nilfs_xafile_getxattr(struct inode *inode,
diff --git a/fs/nilfs2/xattr.c b/fs/nilfs2/xattr.c
new file mode 100644
index 0000000..7be523a
--- /dev/null
+++ b/fs/nilfs2/xattr.c
@@ -0,0 +1,64 @@
+/*
+ * xattr.c - NILFS extended attributes support implementation.
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
+#include "nilfs.h"
+#include "xafile.h"
+#include "xattr.h"
+
+const struct xattr_handler *nilfs_xattr_handlers[] = {
+	&nilfs_xattr_user_handler,
+	&nilfs_xattr_trusted_handler,
+#ifdef CONFIG_NILFS2_FS_POSIX_ACL
+	&nilfs_xattr_acl_access_handler,
+	&nilfs_xattr_acl_default_handler,
+#endif
+#ifdef CONFIG_NILFS2_FS_SECURITY
+	&nilfs_xattr_security_handler,
+#endif
+	NULL
+};
+
+ssize_t nilfs_listxattr(struct dentry *dentry, char *buffer, size_t size)
+{
+	ssize_t ret;
+	struct inode *inode = dentry->d_inode;
+
+	down_read(&NILFS_I(inode)->xattr_sem);
+	ret = nilfs_xafile_listxattr(dentry, buffer, size);
+	up_read(&NILFS_I(inode)->xattr_sem);
+
+	return ret;
+}
+
+ssize_t __nilfs_getxattr(struct inode *inode,
+				int name_index, const char *name,
+				void *value, size_t size)
+{
+	ssize_t ret;
+
+	down_read(&NILFS_I(inode)->xattr_sem);
+	ret = nilfs_xafile_getxattr(inode, name_index, name, value, size);
+	up_read(&NILFS_I(inode)->xattr_sem);
+
+	return ret;
+}
diff --git a/fs/nilfs2/xattr.h b/fs/nilfs2/xattr.h
new file mode 100644
index 0000000..0736086
--- /dev/null
+++ b/fs/nilfs2/xattr.h
@@ -0,0 +1,44 @@
+/*
+ * xattr.h - NILFS extended attributes declarations.
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
+#ifndef _NILFS_XATTR_H
+#define _NILFS_XATTR_H
+
+#include <linux/xattr.h>
+
+extern const struct xattr_handler *nilfs_xattr_handlers[];
+
+ssize_t __nilfs_getxattr(struct inode *inode,
+				int name_index, const char *name,
+				void *value, size_t size);
+
+static inline ssize_t nilfs_getxattr(struct dentry *dentry,
+					int name_index, const char *name,
+					void *value, size_t size)
+{
+	return __nilfs_getxattr(dentry->d_inode, name_index, name, value, size);
+}
+
+ssize_t nilfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
+
+#endif /* _NILFS_XATTR_H */
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
