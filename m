From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC][STEP 1][PATCH 1/4] nilfs-utils: add xattr related declarations
Date: Fri, 10 Jan 2014 16:11:08 +0400
Message-ID: <1389355868.3938.142.camel@slavad-ubuntu>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=UzNANKMMURV/PTJmYP4hC/oFDqJByB4299VHpKgPGIQ=;
	b=TywE6vQt5w0fm5hig3DN/sp3auizPQe5zrCl/z2tzVOBdXlYlH1LdOqpD/gjR/wAQYdwu1drHKeuKh6ekUhReZuLHUUe/v8umKrqZs/QdlgyoV4VRObPDFGoJ+uwMa94;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, "Michael L. Semon" <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC][STEP 1][PATCH 1/4] nilfs-utils: add xattr related declarations

This patch adds xattr related declarations.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 include/nilfs2_fs.h |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/include/nilfs2_fs.h b/include/nilfs2_fs.h
index e674f44..fa05c05 100644
--- a/include/nilfs2_fs.h
+++ b/include/nilfs2_fs.h
@@ -92,6 +92,7 @@ struct nilfs_inode {
  * @sr_dat: DAT file inode
  * @sr_cpfile: checkpoint file inode
  * @sr_sufile: segment usage file inode
+ * @sr_xafile: extended attributes file inode
  */
 struct nilfs_super_root {
 	__le32 sr_sum;
@@ -101,6 +102,7 @@ struct nilfs_super_root {
 	struct nilfs_inode sr_dat;
 	struct nilfs_inode sr_cpfile;
 	struct nilfs_inode sr_sufile;
+	struct nilfs_inode sr_xafile;
 };
 
 #define NILFS_SR_MDT_OFFSET(inode_size, i)  \
@@ -219,10 +221,18 @@ struct nilfs_super_block {
  * If there is a bit set in the incompatible feature set that the kernel
  * doesn't know about, it should refuse to mount the filesystem.
  */
+#define NILFS_FEATURE_COMPAT_INIT_XAFILE	0x00000001ULL
+
 #define NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT	0x00000001ULL
+#define NILFS_FEATURE_COMPAT_RO_XAFILE		0x00000002ULL
+
+#define NILFS_FEATURE_COMPAT_SUPP \
+	(NILFS_FEATURE_COMPAT_INIT_XAFILE)
+
+#define NILFS_FEATURE_COMPAT_RO_SUPP	\
+	(NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT | \
+	 NILFS_FEATURE_COMPAT_RO_XAFILE)
 
-#define NILFS_FEATURE_COMPAT_SUPP	0ULL
-#define NILFS_FEATURE_COMPAT_RO_SUPP	NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT
 #define NILFS_FEATURE_INCOMPAT_SUPP	0ULL
 
 /*
@@ -240,7 +250,7 @@ struct nilfs_super_block {
 #define NILFS_SUFILE_INO	5	/* segment usage file */
 #define NILFS_IFILE_INO		6	/* ifile */
 #define NILFS_ATIME_INO		7	/* Atime file (reserved) */
-#define NILFS_XATTR_INO		8	/* Xattribute file (reserved) */
+#define NILFS_XATTR_INO		8	/* Xattribute file */
 #define NILFS_SKETCH_INO	10	/* Sketch file */
 #define NILFS_USER_INO		11	/* Fisrt user's file inode number */
 
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
