From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/3] nilfs2: add feature set fields to super block
Date: Tue, 20 Jul 2010 02:44:51 +0900
Message-ID: <1279561492-6899-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1279561492-6899-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1279561492-6899-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

This adds three new fields to nilfs_super_block structure, compatible
feature set, readonly-compatible feature set, and incompatible feature
set in order to prepare for future disk format modifications.

The role of these fields conforms to those of ext3 or other
filesystems.  Most important flags are the incompatible feature set;
it is used to refuse to mount the filesystem which sets an
incompatible feature the kernel doesn't know about.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 include/linux/nilfs2_fs.h |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index cc3465e..7dd4cd4 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -212,7 +212,10 @@ struct nilfs_super_block {
 /*F8*/	__le32  s_c_interval;           /* Commit interval of segment */
 	__le32  s_c_block_max;          /* Threshold of data amount for
 					   the segment construction */
-	__u32	s_reserved[192];	/* padding to the end of the block */
+/*100*/	__le64  s_feature_compat;	/* Compatible feature set */
+	__le64  s_feature_compat_ro;	/* Read-only compatible feature set */
+	__le64  s_feature_incompat;	/* Incompatible feature set */
+	__u32	s_reserved[186];	/* padding to the end of the block */
 };
 
 /*
@@ -228,6 +231,16 @@ struct nilfs_super_block {
 #define NILFS_MINOR_REV		0	/* minor revision */
 
 /*
+ * Feature set definitions
+ *
+ * If there is a bit set in the incompatible feature set that the kernel
+ * doesn't know about, it should refuse to mount the filesystem.
+ */
+#define NILFS_FEATURE_COMPAT_SUPP	0ULL
+#define NILFS_FEATURE_COMPAT_RO_SUPP	0ULL
+#define NILFS_FEATURE_INCOMPAT_SUPP	0ULL
+
+/*
  * Bytes count of super_block for CRC-calculation
  */
 #define NILFS_SB_BYTES  \
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
