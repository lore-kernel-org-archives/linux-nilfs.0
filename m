From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [RFC][PATCH 11/15] nilfs2: implement "user.*" namespace support
Date: Wed, 27 Nov 2013 16:43:08 +0400
Message-ID: <1385556188.2589.77.camel@slavad-ubuntu>
Reply-To: slava@dubeyko.com
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=vnrG4nmUi6LlI0Bx5Q4/rQnewJ7ho4DtASKLsI4HK2E=;
	b=Ha9KVp2BE15YHEtsfoR0pmMw6dT9N4h7zD+aXVCjm7t9pIz3P/OlmLQZbNEcf73QQ2J+Ni6iLyLFgZPiVuqHiXXtKvQL/z0852u7GDLP3aFEUMNrl3mARr3UcAzlzfk2;
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-nilfs@vger.kernel.org

From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [RFC][PATCH 11/15] nilfs2: implement "user.*" namespace support

This patch adds functionality of "user.*" namespace support.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
CC: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/xattr_user.c |  123 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 123 insertions(+)
 create mode 100644 fs/nilfs2/xattr_user.c

diff --git a/fs/nilfs2/xattr_user.c b/fs/nilfs2/xattr_user.c
new file mode 100644
index 0000000..b1841db
--- /dev/null
+++ b/fs/nilfs2/xattr_user.c
@@ -0,0 +1,123 @@
+/*
+ * xattr_user.c - Handler for extended user attributes.
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
+
+static size_t nilfs_user_listxattr(struct dentry *dentry,
+					char *list,
+					size_t list_size,
+					const char *name,
+					size_t name_len,
+					int type)
+{
+	struct the_nilfs *nilfs = dentry->d_inode->i_sb->s_fs_info;
+	const size_t prefix_len = XATTR_USER_PREFIX_LEN;
+	const size_t total_len = prefix_len + name_len + 1;
+
+	if (!nilfs_has_xafile(nilfs))
+		return -EOPNOTSUPP;
+
+	if (list && total_len <= list_size) {
+		memcpy(list, XATTR_USER_PREFIX, prefix_len);
+		memcpy(list+prefix_len, name, name_len);
+		list[prefix_len + name_len] = '\0';
+	}
+	return total_len;
+}
+
+static int nilfs_user_getxattr(struct dentry *dentry,
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
+	if ((len + XATTR_USER_PREFIX_LEN) > XATTR_NAME_MAX)
+		return -EOPNOTSUPP;
+
+	return nilfs_getxattr(dentry, NILFS_USER_XATTR_ID, name,
+				buffer, size);
+}
+
+static int nilfs_user_setxattr(struct dentry *dentry,
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
+	if ((len + XATTR_USER_PREFIX_LEN) > XATTR_NAME_MAX)
+		return -EOPNOTSUPP;
+
+	err = nilfs_transaction_begin(dentry->d_inode->i_sb, &ti, 0);
+	if (unlikely(err))
+		return err;
+
+	err = nilfs_setxattr(dentry, NILFS_USER_XATTR_ID, name,
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
+const struct xattr_handler nilfs_xattr_user_handler = {
+	.prefix	= XATTR_USER_PREFIX,
+	.list	= nilfs_user_listxattr,
+	.get	= nilfs_user_getxattr,
+	.set	= nilfs_user_setxattr,
+};
-- 
1.7.9.5



