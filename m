From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [RFC][PATCH 13/15] nilfs2: implement "security.*" namespace support
Date: Wed, 27 Nov 2013 16:43:25 +0400
Message-ID: <1385556205.2589.79.camel@slavad-ubuntu>
Reply-To: slava@dubeyko.com
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=+cagOkeskdtm5vKpRkuf+I5MztIgIt6u/CGIFutkEsw=;
	b=GCTh3016WTWBCa63KBHNhAM9D4rJ7uyZpX/Fb27KTggto06RyWitXh0FFmdzIi5EFA6419E0tBB/GhCEpqjS+rM+ipcJyIbO1P4dZrinNNaeGrleVMsUMUJApoPojs3N;
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-nilfs@vger.kernel.org

From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [RFC][PATCH 13/15] nilfs2: implement "security.*" namespace support

This patch adds functionality of "security.*" namespace support.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
CC: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/xattr.h          |   19 +++++
 fs/nilfs2/xattr_security.c |  190 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 209 insertions(+)
 create mode 100644 fs/nilfs2/xattr_security.c

diff --git a/fs/nilfs2/xattr.h b/fs/nilfs2/xattr.h
index 104a60d..1958d76 100644
--- a/fs/nilfs2/xattr.h
+++ b/fs/nilfs2/xattr.h
@@ -56,4 +56,23 @@ static inline int nilfs_setxattr(struct dentry *dentry,
 ssize_t nilfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
 int nilfs_xattr_delete_inode(struct inode *inode);
 
+#ifdef CONFIG_NILFS2_FS_SECURITY
+int nilfs_init_security(struct inode *inode, struct inode *dir,
+			const struct qstr *qstr);
+int nilfs_init_inode_security(struct inode *inode, struct inode *dir,
+				const struct qstr *qstr);
+#else
+static inline int nilfs_init_security(struct inode *inode, struct inode *dir,
+					const struct qstr *qstr)
+{
+	return 0;
+}
+static inline int nilfs_init_inode_security(struct inode *inode,
+						struct inode *dir,
+						const struct qstr *qstr)
+{
+	return 0;
+}
+#endif /* CONFIG_NILFS2_FS_SECURITY */
+
 #endif /* _NILFS_XATTR_H */
diff --git a/fs/nilfs2/xattr_security.c b/fs/nilfs2/xattr_security.c
new file mode 100644
index 0000000..892d522
--- /dev/null
+++ b/fs/nilfs2/xattr_security.c
@@ -0,0 +1,190 @@
+/*
+ * xattr_security.c - Handler for storing security labels as extended attributes
+ *
+ * Copyright (C) 2005-2013 Nippon Telegraph and Telephone Corporation.
+ * Copyright (C) 2013 Vyacheslav Dubeyko <slava@dubeyko.com>
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
+ * Written by Vyacheslav Dubeyko <slava@dubeyko.com>
+ */
+
+#include <linux/security.h>
+
+#include "nilfs.h"
+#include "xafile.h"
+#include "xattr.h"
+#include "acl.h"
+
+static size_t nilfs_security_listxattr(struct dentry *dentry,
+					char *list,
+					size_t list_size,
+					const char *name,
+					size_t name_len,
+					int type)
+{
+	struct the_nilfs *nilfs = dentry->d_inode->i_sb->s_fs_info;
+	const size_t prefix_len = XATTR_SECURITY_PREFIX_LEN;
+	const size_t total_len = prefix_len + name_len + 1;
+
+	if (!nilfs_has_xafile(nilfs))
+		return -EOPNOTSUPP;
+
+	if (list && total_len <= list_size) {
+		memcpy(list, XATTR_SECURITY_PREFIX, prefix_len);
+		memcpy(list+prefix_len, name, name_len);
+		list[prefix_len + name_len] = '\0';
+	}
+	return total_len;
+}
+
+static int nilfs_security_getxattr(struct dentry *dentry,
+					const char *name,
+					void *buffer,
+					size_t size,
+					int type)
+{
+	struct the_nilfs *nilfs = dentry->d_inode->i_sb->s_fs_info;
+	size_t len;
+
+	if (!nilfs_has_xafile(nilfs))
+		return -EOPNOTSUPP;
+
+	if (name == NULL)
+		return -EINVAL;
+
+	if (strcmp(name, "") == 0)
+		return -EINVAL;
+
+	len = strlen(name);
+
+	if ((len + XATTR_SECURITY_PREFIX_LEN) > XATTR_NAME_MAX)
+		return -EOPNOTSUPP;
+
+	return nilfs_getxattr(dentry, NILFS_SECURITY_XATTR_ID, name,
+				buffer, size);
+}
+
+static int nilfs_security_setxattr(struct dentry *dentry,
+					const char *name,
+					const void *value,
+					size_t size,
+					int flags,
+					int type)
+{
+	struct the_nilfs *nilfs = dentry->d_inode->i_sb->s_fs_info;
+	size_t len;
+	struct nilfs_transaction_info ti;
+	int err;
+
+	if (!nilfs_has_xafile(nilfs))
+		return -EOPNOTSUPP;
+
+	if (name == NULL)
+		return -EINVAL;
+
+	if (strcmp(name, "") == 0)
+		return -EINVAL;
+
+	len = strlen(name);
+
+	if ((len + XATTR_SECURITY_PREFIX_LEN) > XATTR_NAME_MAX)
+		return -EOPNOTSUPP;
+
+	err = nilfs_transaction_begin(dentry->d_inode->i_sb, &ti, 0);
+	if (unlikely(err))
+		return err;
+
+	err = nilfs_setxattr(dentry, NILFS_SECURITY_XATTR_ID, name,
+				value, size, flags);
+
+	if (!err)
+		err = nilfs_transaction_commit(dentry->d_inode->i_sb);
+	else
+		nilfs_transaction_abort(dentry->d_inode->i_sb);
+
+	return err;
+}
+
+static int nilfs_initxattrs(struct inode *inode,
+				const struct xattr *xattr_array,
+				void *fs_info)
+{
+	const struct xattr *xattr;
+	struct nilfs_transaction_info ti;
+	int err = 0;
+
+	err = nilfs_transaction_begin(inode->i_sb, &ti, 0);
+	if (unlikely(err))
+		return err;
+
+	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
+		size_t name_len;
+
+		name_len = strlen(xattr->name);
+
+		if (name_len == 0)
+			continue;
+
+		if (name_len + XATTR_SECURITY_PREFIX_LEN > XATTR_NAME_MAX) {
+			err = -EOPNOTSUPP;
+			goto failed_initxattrs;
+		}
+
+		err = __nilfs_setxattr(inode, NILFS_SECURITY_XATTR_ID,
+					xattr->name, xattr->value,
+					xattr->value_len, 0);
+		if (err)
+			goto failed_initxattrs;
+	}
+
+	err = nilfs_transaction_commit(inode->i_sb);
+	return err;
+
+failed_initxattrs:
+	nilfs_transaction_abort(inode->i_sb);
+	return err;
+}
+
+int nilfs_init_security(struct inode *inode,
+				struct inode *dir,
+				const struct qstr *qstr)
+{
+	return security_inode_init_security(inode, dir, qstr,
+						&nilfs_initxattrs, NULL);
+}
+
+int nilfs_init_inode_security(struct inode *inode,
+				struct inode *dir,
+				const struct qstr *qstr)
+{
+	int err;
+	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
+
+	if (!nilfs_has_xafile(nilfs))
+		return 0;
+
+	err = nilfs_init_acl(inode, dir);
+	if (!err)
+		err = nilfs_init_security(inode, dir, qstr);
+	return err;
+}
+
+const struct xattr_handler nilfs_xattr_security_handler = {
+	.prefix	= XATTR_SECURITY_PREFIX,
+	.list	= nilfs_security_listxattr,
+	.get	= nilfs_security_getxattr,
+	.set	= nilfs_security_setxattr,
+};
-- 
1.7.9.5



