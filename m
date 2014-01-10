From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC][STEP 1][PATCH v2 01/17] nilfs2: provide initial description
 of xattrs support
Date: Fri, 10 Jan 2014 16:07:12 +0400
Message-ID: <1389355632.3938.111.camel@slavad-ubuntu>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=sacMESErbx2FFm4e4jTaBNERDnFwMqPtDZmIS/RanrA=;
	b=RAQkrS55KgV0XsOvq6JzWorRHZuTU4S/Ko0xioAo+/0QQjd4QHAlv0kFyahcpRtvVCiUPNg45iorBjlZklCkaOAYPzeK5DaBKgw8BBPG9hvhE6rKiH7OFDgw2rNTCuPU;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC][STEP 1][PATCH v2 01/17] nilfs2: provide initial description of xattrs support

This patch adds initial description of xattrs support
architecture.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/xafile.c |  116 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 116 insertions(+)
 create mode 100644 fs/nilfs2/xafile.c

diff --git a/fs/nilfs2/xafile.c b/fs/nilfs2/xafile.c
new file mode 100644
index 0000000..469b256
--- /dev/null
+++ b/fs/nilfs2/xafile.c
@@ -0,0 +1,116 @@
+/*
+ * xafile.c - NILFS extended attributes file (xafile) implementation.
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
+/*
+ *   ----------------------------------------------------------------
+ *                     HOW DOES NILFS2 KEEP XATTRs?
+ *   ----------------------------------------------------------------
+ *
+ *   Extended file attributes (xattrs) is a file system feature that
+ *   enables users to associate computer files with metadata not
+ *   interpreted by the filesystem. Any regular file or directory may
+ *   have extended attributes consisting of a name and associated data.
+ *   The name must be a null-terminated string prefixed by a namespace
+ *   identifier and a dot character. Currently, four namespaces exist:
+ *   user, trusted, security and system. The user namespace has no
+ *   restrictions with regard to naming or contents. The system namespace
+ *   is primarily used by the kernel for access control lists.
+ *   The security namespace is used by SELinux
+ *
+ *   There are two possible places of storing xattrs:
+ *   (1) inline xattr node (xanode) [OPTIONAL];
+ *   (2) xattr file (xafile).
+ *
+ *   The xafile is metadata file. It contains group descriptors block,
+ *   bitmap blocks and xanodes areas. The xafile is simply aggregate of
+ *   xanodes that can provide a xanode of some size (1KB, 2 KB or 4 KB)
+ *   by identification number (ID) or, in other words, by index.
+ *
+ *   ----------------------------------------------------------------
+ *                         XAFILE STRUCTURE
+ *   ----------------------------------------------------------------
+ *
+ *   The xafile is metadata file that, basically, has such structure:
+ *
+ *    +0                 +1       +2
+ *   +------------------+--------+------------------------------+
+ *   + Group descriptor | Bitmap |       Xanodes area           |
+ *   + block            | block  |                              |
+ *   +------------------+--------+------------------------------+
+ *
+ *   Thereby, xafile is simply aggregate of xanodes that can provide
+ *   xanode of some size (1KB, 2 KB or 4 KB) by identification
+ *   number (ID).
+ *
+ *   NILFS2 volume contains xafile if s_feature_compat_ro field of
+ *   superblock contains NILFS_FEATURE_COMPAT_RO_XAFILE flag.
+ *   The s_xafile_xanode_size field of superblock keeps value of
+ *   xanode's size in bytes which is determined during mkfs phase.
+ *
+ *   The xanodes area haven't any predetermined order of xanodes.
+ *   Simply speaking, this area is aggregation of xanodes of different trees.
+ *   Every tree begins from a xanode that keeps knowledge about other xanodes
+ *   in a tree. The i_xattr field of on-disk inode can keep
+ *   ID of xanode.
+ *
+ *   The xanode has such structure:
+ *
+ *   ----------------
+ *   |    HEADER    |
+ *   ----------------
+ *   |  INDEX KEYS  |
+ *   ----------------
+ *   |  LEAF KEYS   |
+ *   ----------------
+ *   |              |
+ *   |  FREE AREA   |
+ *   |              |
+ *   ----------------
+ *   |    ENTRIES   |
+ *   ----------------
+ *
+ *   The xanode begins with header. Initially, empty xanode
+ *   contains reserved place for 4 index keys. It is located leaf keys
+ *   after space that is reserved for index keys. Leaf keys grow
+ *   towards entries. The chain of keys is ended by termination marker
+ *   ("end key"). Entries begin from xanode end and its grow from the
+ *   end towards "end key".
+ *
+ *   ----------------------------------------------------------------
+ *                     XANODE ENTRY STRUCTURE
+ *   ----------------------------------------------------------------
+ *
+ *   The entry of xanode has purpose to store name and
+ *   binary value pair.
+ *
+ *   Structure of xanode's entry in common case:
+ *
+ *   ----------------------------------------
+ *   | name[variable_length] | binary value |
+ *   ----------------------------------------
+ *   |<----------   entry_size  ----------->|
+ *
+ *   The name hash defines length of the name. The length
+ *   of binary value is defined as difference between
+ *   entry_size and name_len.
+ */
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
