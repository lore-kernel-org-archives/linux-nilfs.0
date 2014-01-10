From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC][STEP 1][PATCH v2 12/17] nilfs2: implement "trusted.*"
 namespace support
Date: Fri, 10 Jan 2014 16:09:35 +0400
Message-ID: <1389355775.3938.133.camel@slavad-ubuntu>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=iExK8kLOYdZBxyEGy/gACnFAb5RuxNlGaps8qvKSfMc=;
	b=PXpgVb3DXDc/FpeWvzWLM2MVWlbFQ7GnAbIcca1qfHVC/dccLJ+niU1oF+L2X0/Yp9l3O9zRfY1fF5NlS+bmyQ/HFLqmnifrVilF7ofxHHBml/P4ZUEVPzWZmA5twRRw;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC][STEP 1][PATCH v2 12/17] nilfs2: implement "trusted.*" namespace support

This patch adds functionality of "trusted.*" namespace support.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/xattr_trusted.c |  126 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 126 insertions(+)
 create mode 100644 fs/nilfs2/xattr_trusted.c

diff --git a/fs/nilfs2/xattr_trusted.c b/fs/nilfs2/xattr_trusted.c
new file mode 100644
index 0000000..e1038b6
--- /dev/null
+++ b/fs/nilfs2/xattr_trusted.c
@@ -0,0 +1,126 @@
+/*
+ * xattr_trusted.c - Handler for trusted extended attributes.
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
+static size_t nilfs_trusted_listxattr(struct dentry *dentry,
+					char *list,
+					size_t list_size,
+					const char *name,
+					size_t name_len,
+					int type)
+{
+	struct the_nilfs *nilfs = dentry->d_inode->i_sb->s_fs_info;
+	const size_t prefix_len = XATTR_TRUSTED_PREFIX_LEN;
+	const size_t total_len = prefix_len + name_len + 1;
+
+	if (!nilfs_has_xafile(nilfs))
+		return -EOPNOTSUPP;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return 0;
+
+	if (list && total_len <= list_size) {
+		memcpy(list, XATTR_TRUSTED_PREFIX, prefix_len);
+		memcpy(list+prefix_len, name, name_len);
+		list[prefix_len + name_len] = '\0';
+	}
+	return total_len;
+}
+
+static int nilfs_trusted_getxattr(struct dentry *dentry,
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
+	if ((len + XATTR_TRUSTED_PREFIX_LEN) > XATTR_NAME_MAX)
+		return -EOPNOTSUPP;
+
+	return nilfs_getxattr(dentry, NILFS_TRUSTED_XATTR_ID, name,
+				buffer, size);
+}
+
+static int nilfs_trusted_setxattr(struct dentry *dentry,
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
+	if ((len + XATTR_TRUSTED_PREFIX_LEN) > XATTR_NAME_MAX)
+		return -EOPNOTSUPP;
+
+	err = nilfs_transaction_begin(dentry->d_inode->i_sb, &ti, 0);
+	if (unlikely(err))
+		return err;
+
+	err = nilfs_setxattr(dentry, NILFS_TRUSTED_XATTR_ID, name,
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
+const struct xattr_handler nilfs_xattr_trusted_handler = {
+	.prefix	= XATTR_TRUSTED_PREFIX,
+	.list	= nilfs_trusted_listxattr,
+	.get	= nilfs_trusted_getxattr,
+	.set	= nilfs_trusted_setxattr,
+};
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
