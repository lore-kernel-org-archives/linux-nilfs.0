From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [RFC][PATCH 14/15] nilfs2: implement POSIX ACLs support
Date: Wed, 27 Nov 2013 16:43:35 +0400
Message-ID: <1385556215.2589.80.camel@slavad-ubuntu>
Reply-To: slava@dubeyko.com
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=M6WJlb80ByKalLqNf65WMMrQa4kXMg8J7yfbwQU9i8I=;
	b=FzXOD8N1eXrXSGbRM3nYgayRjgqYa/489OZwBsRtJtUs5B8OFccWlhXaEEEfxfwLo2f7Jbi81nk6I86yRJlOl1DIQeYLI3ecvGcndHV2W/3VaxtOkSgnDAZJdJ0jPnpA;
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-nilfs@vger.kernel.org

From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [RFC][PATCH 14/15] nilfs2: implement POSIX ACLs support

This patch adds functionality of POSIX ACLs support.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
CC: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/acl.c |  319 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/acl.h |   58 ++++++++++
 2 files changed, 377 insertions(+)
 create mode 100644 fs/nilfs2/acl.c
 create mode 100644 fs/nilfs2/acl.h

diff --git a/fs/nilfs2/acl.c b/fs/nilfs2/acl.c
new file mode 100644
index 0000000..95b3601
--- /dev/null
+++ b/fs/nilfs2/acl.c
@@ -0,0 +1,319 @@
+/*
+ * acl.c - NILFS ACLs support implementation.
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
+#include "nilfs.h"
+#include "xafile.h"
+#include "xattr.h"
+#include "acl.h"
+
+struct posix_acl *nilfs_get_acl(struct inode *inode, int type)
+{
+	struct posix_acl *acl;
+	char *xattr_name;
+	int name_index;
+	char *value = NULL;
+	ssize_t size;
+
+	acl = get_cached_acl(inode, type);
+	if (acl != ACL_NOT_CACHED)
+		return acl;
+
+	switch (type) {
+	case ACL_TYPE_ACCESS:
+		xattr_name = POSIX_ACL_XATTR_ACCESS;
+		name_index = NILFS_POSIX_ACL_ACCESS_XATTR_ID;
+		break;
+	case ACL_TYPE_DEFAULT:
+		xattr_name = POSIX_ACL_XATTR_DEFAULT;
+		name_index = NILFS_POSIX_ACL_DEFAULT_XATTR_ID;
+		break;
+	default:
+		return ERR_PTR(-EINVAL);
+	}
+
+	size = __nilfs_getxattr(inode, name_index, xattr_name, NULL, 0);
+
+	if (size > 0) {
+		value = kmalloc(size, GFP_KERNEL);
+		if (unlikely(!value))
+			return ERR_PTR(-ENOMEM);
+		size = __nilfs_getxattr(inode, name_index, xattr_name,
+					value, size);
+	}
+
+	if (size > 0)
+		acl = posix_acl_from_xattr(&init_user_ns, value, size);
+	else if (size == -ENODATA)
+		acl = NULL;
+	else
+		acl = ERR_PTR(size);
+
+	kfree(value);
+
+	if (!IS_ERR(acl))
+		set_cached_acl(inode, type, acl);
+
+	return acl;
+}
+
+static int nilfs_set_acl(struct inode *inode, int type, struct posix_acl *acl)
+{
+	int err;
+	int name_index;
+	char *xattr_name;
+	size_t size = 0;
+	char *value = NULL;
+	struct nilfs_transaction_info ti;
+
+	if (S_ISLNK(inode->i_mode))
+		return -EOPNOTSUPP;
+
+	switch (type) {
+	case ACL_TYPE_ACCESS:
+		name_index = NILFS_POSIX_ACL_ACCESS_XATTR_ID;
+		xattr_name = POSIX_ACL_XATTR_ACCESS;
+		if (acl) {
+			err = posix_acl_equiv_mode(acl, &inode->i_mode);
+			if (err < 0)
+				return err;
+		}
+		err = 0;
+		break;
+
+	case ACL_TYPE_DEFAULT:
+		name_index = NILFS_POSIX_ACL_DEFAULT_XATTR_ID;
+		xattr_name = POSIX_ACL_XATTR_DEFAULT;
+		if (!S_ISDIR(inode->i_mode))
+			return acl ? -EACCES : 0;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	if (acl) {
+		size = posix_acl_xattr_size(acl->a_count);
+		value = kmalloc(size, GFP_KERNEL);
+		if (!value)
+			return -ENOMEM;
+		err = posix_acl_to_xattr(&init_user_ns, acl, value, size);
+		if (err < 0)
+			goto end_set_acl;
+	}
+
+	err = nilfs_transaction_begin(inode->i_sb, &ti, 0);
+	if (unlikely(err))
+		goto end_set_acl;
+
+	err = __nilfs_setxattr(inode, name_index, xattr_name, value, size, 0);
+
+	if (!err)
+		err = nilfs_transaction_commit(inode->i_sb);
+	else
+		nilfs_transaction_abort(inode->i_sb);
+
+end_set_acl:
+	kfree(value);
+
+	if (!err)
+		set_cached_acl(inode, type, acl);
+
+	return err;
+}
+
+int nilfs_init_acl(struct inode *inode, struct inode *dir)
+{
+	int err = 0;
+	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
+	struct posix_acl *acl = NULL;
+
+	if (!nilfs_has_xafile(nilfs))
+		return -EOPNOTSUPP;
+
+	if (S_ISLNK(inode->i_mode))
+		return 0;
+
+	acl = nilfs_get_acl(dir, ACL_TYPE_DEFAULT);
+	if (IS_ERR(acl))
+		return PTR_ERR(acl);
+
+	if (acl) {
+		if (S_ISDIR(inode->i_mode)) {
+			err = nilfs_set_acl(inode, ACL_TYPE_DEFAULT, acl);
+			if (unlikely(err))
+				goto init_acl_cleanup;
+		}
+
+		err = posix_acl_create(&acl, GFP_NOFS, &inode->i_mode);
+		if (unlikely(err < 0))
+			return err;
+
+		if (err > 0)
+			err = nilfs_set_acl(inode, ACL_TYPE_ACCESS, acl);
+	} else
+		inode->i_mode &= ~current_umask();
+
+init_acl_cleanup:
+	posix_acl_release(acl);
+	return err;
+}
+
+int nilfs_acl_chmod(struct inode *inode)
+{
+	int err;
+	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
+	struct posix_acl *acl;
+
+	if (!nilfs_has_xafile(nilfs))
+		return -EOPNOTSUPP;
+
+	if (S_ISLNK(inode->i_mode))
+		return -EOPNOTSUPP;
+	acl = nilfs_get_acl(inode, ACL_TYPE_ACCESS);
+	if (IS_ERR(acl) || !acl)
+		return PTR_ERR(acl);
+	err = posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
+	if (unlikely(err))
+		return err;
+	err = nilfs_set_acl(inode, ACL_TYPE_ACCESS, acl);
+	posix_acl_release(acl);
+	return err;
+}
+
+static size_t nilfs_acl_access_listxattr(struct dentry *dentry,
+						char *list,
+						size_t list_len,
+						const char *name,
+						size_t name_len,
+						int type)
+{
+	struct the_nilfs *nilfs = dentry->d_inode->i_sb->s_fs_info;
+	const size_t size = sizeof(POSIX_ACL_XATTR_ACCESS);
+
+	if (!nilfs_has_xafile(nilfs))
+		return -EOPNOTSUPP;
+
+	if (list && size <= list_len)
+		memcpy(list, POSIX_ACL_XATTR_ACCESS, size);
+	return size;
+}
+
+static size_t nilfs_acl_default_listxattr(struct dentry *dentry,
+						char *list,
+						size_t list_len,
+						const char *name,
+						size_t name_len,
+						int type)
+{
+	struct the_nilfs *nilfs = dentry->d_inode->i_sb->s_fs_info;
+	const size_t size = sizeof(POSIX_ACL_XATTR_DEFAULT);
+
+	if (!nilfs_has_xafile(nilfs))
+		return -EOPNOTSUPP;
+
+	if (list && size <= list_len)
+		memcpy(list, POSIX_ACL_XATTR_DEFAULT, size);
+	return size;
+}
+
+static int nilfs_acl_getxattr(struct dentry *dentry,
+				const char *name,
+				void *buffer,
+				size_t size,
+				int type)
+{
+	int err = 0;
+	struct the_nilfs *nilfs = dentry->d_inode->i_sb->s_fs_info;
+	struct posix_acl *acl;
+
+	if (!nilfs_has_xafile(nilfs))
+		return -EOPNOTSUPP;
+
+	if (strcmp(name, "") != 0)
+		return -EINVAL;
+
+	acl = nilfs_get_acl(dentry->d_inode, type);
+	if (IS_ERR(acl))
+		return PTR_ERR(acl);
+	if (acl == NULL)
+		return -ENODATA;
+
+	err = posix_acl_to_xattr(&init_user_ns, acl, buffer, size);
+	posix_acl_release(acl);
+	return err;
+}
+
+static int nilfs_acl_setxattr(struct dentry *dentry,
+				const char *name,
+				const void *value,
+				size_t size,
+				int flags,
+				int type)
+{
+	int err = 0;
+	struct inode *inode = dentry->d_inode;
+	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
+	struct posix_acl *acl = NULL;
+
+	if (!nilfs_has_xafile(nilfs))
+		return -EOPNOTSUPP;
+
+	if (strcmp(name, "") != 0)
+		return -EINVAL;
+
+	if (!inode_owner_or_capable(inode))
+		return -EPERM;
+
+	if (value) {
+		acl = posix_acl_from_xattr(&init_user_ns, value, size);
+		if (IS_ERR(acl))
+			return PTR_ERR(acl);
+		else if (acl) {
+			err = posix_acl_valid(acl);
+			if (err)
+				goto end_acl_setxattr;
+		}
+	}
+
+	err = nilfs_set_acl(inode, type, acl);
+
+end_acl_setxattr:
+	posix_acl_release(acl);
+	return err;
+}
+
+const struct xattr_handler nilfs_xattr_acl_access_handler = {
+	.prefix	= POSIX_ACL_XATTR_ACCESS,
+	.flags	= ACL_TYPE_ACCESS,
+	.list	= nilfs_acl_access_listxattr,
+	.get	= nilfs_acl_getxattr,
+	.set	= nilfs_acl_setxattr,
+};
+
+const struct xattr_handler nilfs_xattr_acl_default_handler = {
+	.prefix	= POSIX_ACL_XATTR_DEFAULT,
+	.flags	= ACL_TYPE_DEFAULT,
+	.list	= nilfs_acl_default_listxattr,
+	.get	= nilfs_acl_getxattr,
+	.set	= nilfs_acl_setxattr,
+};
diff --git a/fs/nilfs2/acl.h b/fs/nilfs2/acl.h
new file mode 100644
index 0000000..d537727
--- /dev/null
+++ b/fs/nilfs2/acl.h
@@ -0,0 +1,58 @@
+/*
+ * acl.h - NILFS ACLs support declarations.
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
+#ifndef _NILFS_ACL_H
+#define _NILFS_ACL_H
+
+#include <linux/posix_acl_xattr.h>
+
+#ifdef CONFIG_NILFS2_FS_POSIX_ACL
+
+#define set_posix_acl_flag(sb) \
+	((sb)->s_flags |= MS_POSIXACL)
+
+/* acl.c */
+struct posix_acl *nilfs_get_acl(struct inode *inode, int type);
+extern int nilfs_acl_chmod(struct inode *inode);
+extern int nilfs_init_acl(struct inode *inode, struct inode *dir);
+
+#else  /* CONFIG_NILFS2_FS_POSIX_ACL */
+
+#define set_posix_acl_flag(sb) \
+	((sb)->s_flags &= ~MS_POSIXACL)
+
+#define nilfs_get_acl NULL
+
+static inline int nilfs_acl_chmod(struct inode *inode)
+{
+	return 0;
+}
+
+static inline int nilfs_init_acl(struct inode *inode, struct inode *dir)
+{
+	return 0;
+}
+
+#endif  /* CONFIG_NILFS2_FS_POSIX_ACL */
+
+#endif /* _NILFS_ACL_H */
-- 
1.7.9.5



