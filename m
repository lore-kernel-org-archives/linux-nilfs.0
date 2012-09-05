From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 02/11] nilfs-utils: fsck: add necessary constants and function declarations
Date: Wed, 5 Sep 2012 23:13:53 +0400
Message-ID: <7F85CABD-AFE7-4603-A70F-B68F9CC8D323@dubeyko.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:To:Message-Id:Date:Subject:Content-Transfer-Encoding:Content-Type:From; bh=I48kb/HGTT/ohUHMNfH4i35hnHf8TPnA73uS0Uf8rS8=;
	b=U3DSfdvPrrlqoNaOM3fl46e/5CJVNvc0x9uZIkzeEoSJGL4H56rE44Aa5rfXsQkqy+ENAkKEYbJp3JH6qltZ0qYL9y61T18HD/aEcCSUbOZ2VHtz750h3yTD9ZHC6O5b;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

This patch adds several additional constants, function declarations and move useful macro from mkfs.c file into nilfs.h.

With the best regards,
Vyacheslav Dubeyko.
--
From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 02/11] nilfs-utils: fsck: add necessary constants and function declarations

This patch adds several additional constants, function declarations and move useful macro from mkfs.c file into nilfs.h.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
 include/nilfs.h     |   17 +++++++++++++++++
 include/nilfs2_fs.h |    5 +++++
 sbin/mkfs/mkfs.c    |    1 -
 3 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/include/nilfs.h b/include/nilfs.h
index cdb468e..6a697fa 100644
--- a/include/nilfs.h
+++ b/include/nilfs.h
@@ -87,6 +87,16 @@ typedef __u64 sector_t;	// XXX: __u64 ??
 typedef sector_t nilfs_blkoff_t;
 typedef __u64 nilfs_cno_t;
 
+#ifndef NILFS_FALSE
+#      define  NILFS_FALSE   (0)
+#endif
+
+#ifndef NILFS_TRUE
+#      define  NILFS_TRUE    (1)
+#endif
+
+#define DEFAULT_SECTOR_SIZE 512
+
 #define NILFS_FSTYPE	"nilfs2"
 
 #define NILFS_CNO_MIN	((nilfs_cno_t)1)
@@ -98,6 +108,8 @@ typedef __u64 nilfs_cno_t;
 #define NILFS_SB_COMMIT_INTERVAL	0x4000
 #define NILFS_SB_BLOCK_MAX		0x8000
 
+#define ROUNDUP_DIV(n, m)   (((n) - 1) / (m) + 1)
+
 /**
  * struct nilfs - nilfs object
  * @n_sb: superblock
@@ -285,6 +297,11 @@ struct nilfs_super_block *nilfs_sb_read(int devfd);
 int nilfs_sb_write(int devfd, struct nilfs_super_block *sbp, int mask);
 
 int nilfs_read_sb(struct nilfs *);
+int nilfs_sb_read_unchecked(int devfd,
+				struct nilfs_super_block **sbp);
+int nilfs_sb_is_valid(int devfd,
+			struct nilfs_super_block *sbp,
+			__u64 *check_mask);
 
 ssize_t nilfs_get_segment(struct nilfs *, unsigned long, void **);
 int nilfs_put_segment(struct nilfs *, void *);
diff --git a/include/nilfs2_fs.h b/include/nilfs2_fs.h
index e674f44..30b6703 100644
--- a/include/nilfs2_fs.h
+++ b/include/nilfs2_fs.h
@@ -124,6 +124,11 @@ struct nilfs_super_root {
 #define NILFS_RESIZE_FS			0x0004	/* Resize required */
 
 /*
+ * Behavior when detecting errors flags
+ */
+#define NILFS_ERRORS_CONTINUE		1	/* Continue execution */
+
+/*
  * Mount flags (sbi->s_mount_opt)
  */
 #define NILFS_MOUNT_ERROR_MODE		0x0070  /* Error mode mask */
diff --git a/sbin/mkfs/mkfs.c b/sbin/mkfs/mkfs.c
index fde1c76..50c5451 100644
--- a/sbin/mkfs/mkfs.c
+++ b/sbin/mkfs/mkfs.c
@@ -81,7 +81,6 @@
 typedef __u64  blocknr_t;
 
 #define BUG_ON(x)	   assert(!(x))
-#define ROUNDUP_DIV(n,m)   (((n) - 1) / (m) + 1)
 #define max_t(type,x,y) \
 	({ type __x = (x); type __y = (y); __x > __y ? __x : __y; })
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
