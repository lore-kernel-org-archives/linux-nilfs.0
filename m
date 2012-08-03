From: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Subject: [PATCH v2 4/7] nilfs-utils: fsck: add several constants and
 functions declaration in nilfs.h
Date: Fri, 03 Aug 2012 07:55:04 -0600
Message-ID: <0a60edec96ddaf8ff6061b45a577b8bf@dubeyko.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Message-ID:Subject:Cc:To:From:Date:Content-Transfer-Encoding:Content-Type:MIME-Version; bh=DLhNTBVppYaj3ELRQBVGO5CpSx+qCspSQNZAJRqWHiQ=;
	b=V6IS22Ez5FsQxFzOySL1RcAXQUTjK9Q4GxQ0roljMkSF/U0h8l5vMhWr8nDRDGqiR4lT9b1s34r2a671AW5FNRA7reNQgXmesav3Rg2h9tFDlikGT59AKotKrDcE3DmJ;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

Hi,

This patch adds several constants and functions declaration in nilfs.h.

With the best regards,
Vyacheslav Dubeyko.
--
 From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 4/7] nilfs-utils: fsck: add several constants and 
functions declaration in nilfs.h

This patch adds several constants and functions declaration in nilfs.h.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
diff --git a/include/nilfs.h b/include/nilfs.h
index cdb468e..0d9af19 100644
--- a/include/nilfs.h
+++ b/include/nilfs.h
@@ -87,6 +87,16 @@ typedef __u64 sector_t;      // XXX: __u64 ??
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
  #define NILFS_FSTYPE   "nilfs2"

  #define NILFS_CNO_MIN  ((nilfs_cno_t)1)
@@ -285,6 +295,11 @@ struct nilfs_super_block *nilfs_sb_read(int 
devfd);
  int nilfs_sb_write(int devfd, struct nilfs_super_block *sbp, int 
mask);

  int nilfs_read_sb(struct nilfs *);
+int nilfs_sb_read_unchecked(int devfd,
+                               struct nilfs_super_block *sbp1,
+                               struct nilfs_super_block *sbp2);
+int nilfs_sb_is_valid(struct nilfs_super_block *sbp, int check_crc,
+                               int *err_code, int *err_severity);

  ssize_t nilfs_get_segment(struct nilfs *, unsigned long, void **);
  int nilfs_put_segment(struct nilfs *, void *);
--

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
