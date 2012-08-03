From: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Subject: [PATCH v2 6/7] nilfs-utils: fsck: add =?UTF-8?Q?nilfs=5Fsb=5Fread?=
 =?UTF-8?Q?=5Funchecked=28=29=20and=20modify=20nilfs=5Fsb=5Fis=5Fvalid=28?=
 =?UTF-8?Q?=29=20functions?=
Date: Fri, 03 Aug 2012 07:58:06 -0600
Message-ID: <269e65cd4f887193113917900f2417a7@dubeyko.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Message-ID:Subject:Cc:To:From:Date:Content-Transfer-Encoding:Content-Type:MIME-Version; bh=XxpcQ4jwXRspikmgv3gP9WuSKPHPHGCyFY+kcCVXOaY=;
	b=QB6ChdiIa6AoX9EMGPG7eWtX9zWYaXk004PQiqpNLYwcFudHsKBZnwJg9bNTgyaP/WJDGds3IMqlFCjVdjkhJaEYvq4brp577JcfautPvT/jTC2tIxCEpfA2I94vcSwo;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

Hi,

This patch adds nilfs_sb_read_unchecked() function for reading 
superblocks without checking. Moreover, it modifies nilfs_sb_is_valid() 
function with the purpose of making full superblock check in the future.

With the best regards,
Vyacheslav Dubeyko.
--
 From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 6/7] nilfs-utils: fsck: add 
nilfs_sb_read_unchecked() and modify nilfs_sb_is_valid() functions

This patch adds nilfs_sb_read_unchecked() function for reading 
superblocks without checking. Moreover, it modifies nilfs_sb_is_valid() 
function with the purpose of making full superblock check in the future.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
diff --git a/lib/sb.c b/lib/sb.c
index 94bccaf..15190ca 100644
--- a/lib/sb.c
+++ b/lib/sb.c
@@ -30,6 +30,8 @@
  #include <stdlib.h>
  #endif	/* HAVE_STDLIB_H */

+#include <stddef.h>
+
  #if HAVE_STRING_H
  #include <string.h>
  #endif	/* HAVE_STRING_H */
@@ -63,6 +65,7 @@
  #include <errno.h>
  #include <assert.h>
  #include "nilfs.h"
+#include "fsck_messages.h"

  #define NILFS_MAX_SB_SIZE	1024

@@ -81,20 +84,143 @@ static __u32 nilfs_sb_check_sum(struct 
nilfs_super_block *sbp)
  	return crc;
  }

-static int nilfs_sb_is_valid(struct nilfs_super_block *sbp, int 
check_crc)
+/*
+ * nilfs_sb_is_valid - Check that superblock is valid.
+ * @sbp: pointer on superblock.
+ * @check_crc: is it necessary to check CRC?
+ * @err_code: pointer on returned error code.
+ *
+ * Return value:
+ * NILFS_TRUE - superblock is valid.
+ * NILFS_FALSE - superblock is in corrupted state.
+ *
+ * In the case of valid pointer the err_code can contain:
+ * 0 - no errors were detected.
+ * INVALID_NILFS_SIGNATURE - superblock contains invalid signature.
+ * INVALID_SB_SIZE - superblock contains incorrect size in bytes.
+ * UNSUPPORTED_SB_REV - unsupported revision of NILFS superblock.
+ * INVALID_CRC - Invalid checksum of superblock was detected.
+ */
+int nilfs_sb_is_valid(struct nilfs_super_block *sbp,
+				int check_crc,
+				int *err_code,
+				int *err_severity)
  {
+	__u16 sb_size;
  	__u32 crc;
+	int err = 0;
+	int is_sb_ok = NILFS_TRUE;
+	int severity = FS_INFO;
+
+	/* <TODO: need to implement full check> */
+
+	/* Check magic */
+	if (le16_to_cpu(sbp->s_magic) != NILFS_SUPER_MAGIC) {
+		is_sb_ok = NILFS_FALSE;
+		err = INVALID_NILFS_SIGNATURE;
+		severity = FS_WARNING;
+		goto end_check;
+	}

-	if (le16_to_cpu(sbp->s_magic) != NILFS_SUPER_MAGIC)
-		return 0;
-	if (le16_to_cpu(sbp->s_bytes) > NILFS_MAX_SB_SIZE)
-		return 0;
-	if (!check_crc)
-		return 1;
+	/* Check s_bytes: size of superblock excluding s_reserved */
+	sb_size = le16_to_cpu(sbp->s_bytes);
+	if (sb_size > sizeof(struct nilfs_super_block)) {
+		is_sb_ok = NILFS_FALSE;
+		err = INVALID_SB_SIZE;
+		severity = FS_CRITICAL_ERROR;
+		goto end_check;
+	} else if (sb_size <
+			offsetof(struct nilfs_super_block, s_reserved)) {
+		is_sb_ok = NILFS_FALSE;
+		err = INVALID_SB_SIZE;
+		severity = FS_CRITICAL_ERROR;
+		goto end_check;
+	} else if (sb_size >
+			offsetof(struct nilfs_super_block, s_reserved)) {
+		is_sb_ok = NILFS_FALSE;
+		err = UNSUPPORTED_SB_REV;
+		severity = FS_WARNING;
+		goto end_check;
+	}

-	crc = nilfs_sb_check_sum(sbp);
+	/* Check CRC of superblock */
+	if (check_crc) {
+		crc = nilfs_sb_check_sum(sbp);
+		is_sb_ok = (crc == le32_to_cpu(sbp->s_sum));
+		if (NILFS_FALSE == is_sb_ok) {
+			err = INVALID_CRC;
+			severity = FS_CRITICAL_ERROR;
+			goto end_check;
+		}
+	}

-	return crc == le32_to_cpu(sbp->s_sum);
+	/* Check revision level */
+	/* <TODO: implement> */
+	/* Check s_feature_compat: compatible feature set */
+	/* <TODO: implement> */
+	/* Check s_feature_compat_ro: read-only compatible feature set */
+	/* <TODO: implement> */
+	/* Check s_feature_incompat: incompatible feature set */
+	/* <TODO: implement> */
+	/* Check s_flags: file system independent flags */
+	/* <TODO: implement> */
+	/* Check s_log_block_size: block size */
+	/* <TODO: implement> */
+	/* Check s_dev_size: block device size in bytes */
+	/* <TODO: implement> */
+	/* Check s_blocks_per_segment: number of blocks per full segment */
+	/* <TODO: implement> */
+	/* Check s_nsegments: number of segments in file system */
+	/* <TODO: implement> */
+	/* Check s_first_data_block */
+	/* <TODO: implement> */
+	/* Check s_r_segments_percentage */
+	/* <TODO: implement> */
+	/* Check s_last_cno: last checkpoint number */
+	/* <TODO: implement> */
+	/* Check s_last_pseg: start block of latest segment */
+	/* <TODO: implement> */
+	/* Check s_last_seq: segment that was written last */
+	/* <TODO: implement> */
+	/* Preliminary check s_free_blocks_count */
+	/* <TODO: implement> */
+	/* Check s_ctime, s_mtime, s_wtime */
+	/* <TODO: implement> */
+	/* Check s_mnt_count and s_max_mnt_count */
+	/* <TODO: implement> */
+	/* Check s_state: file system states */
+	/* <TODO: implement> */
+	/* Check s_errors */
+	/* <TODO: implement> */
+	/* Check s_lastcheck and s_checkinterval */
+	/* <TODO: implement> */
+	/* Check s_creator_os */
+	/* <TODO: implement> */
+	/* Check s_def_resuid and s_def_resgid */
+	/* <TODO: implement> */
+	/* Check s_first_ino: first user's file inode number */
+	/* <TODO: implement> */
+	/* Check s_inode_size */
+	/* <TODO: implement> */
+	/* Check s_dat_entry_size */
+	/* <TODO: implement> */
+	/* Check s_checkpoint_size */
+	/* <TODO: implement> */
+	/* Check s_segment_usage_size */
+	/* <TODO: implement> */
+	/* Check s_c_interval: commit interval of segment */
+	/* <TODO: implement> */
+	/* Check s_c_block_max: number of blocks to create segment */
+	/* <TODO: implement> */
+
+end_check:
+	if (err_code)
+		(*err_code) = err;
+
+	if (err_severity)
+		(*err_severity) = severity;
+
+	return is_sb_ok;
  }

  static int __nilfs_sb_read(int devfd, struct nilfs_super_block **sbp,
@@ -112,7 +238,7 @@ static int __nilfs_sb_read(int devfd, struct 
nilfs_super_block **sbp,

  	if (lseek(devfd, NILFS_SB_OFFSET_BYTES, SEEK_SET) < 0 ||
  	    read(devfd, sbp[0], NILFS_MAX_SB_SIZE) < 0 ||
-	    !nilfs_sb_is_valid(sbp[0], 0)) {
+	    !nilfs_sb_is_valid(sbp[0], 0, NULL, NULL)) {
  		free(sbp[0]);
  		sbp[0] = NULL;
  	}
@@ -125,7 +251,7 @@ static int __nilfs_sb_read(int devfd, struct 
nilfs_super_block **sbp,

  	if (lseek(devfd, sb2_offset, SEEK_SET) < 0 ||
  	    read(devfd, sbp[1], NILFS_MAX_SB_SIZE) < 0 ||
-	    !nilfs_sb_is_valid(sbp[1], 0))
+	    !nilfs_sb_is_valid(sbp[1], 0, NULL, NULL))
  		goto sb2_failed;

  	if (sb2_offset <
@@ -169,6 +295,55 @@ struct nilfs_super_block *nilfs_sb_read(int devfd)
  	return sbp[0];
  }

+/*
+ * nilfs_sb_read_unchecked - Read superblocks without check.
+ * @devfd: file descriptor of opened device.
+ * @sbp1: pointer on first superblock (can be NULL).
+ * @sbp2: pointer on second superblock (can be NULL).
+ *
+ * Return value:
+ * 0 - no errors were detected.
+ * %-CANNOT_READ_SUPERBLOCK - cannot read superblock from disk.
+ * %-INVALID_SB_OFFSET - superblock offset has invalid value.
+ */
+int nilfs_sb_read_unchecked(int devfd,
+				struct nilfs_super_block *sbp1,
+				struct nilfs_super_block *sbp2)
+{
+	__u64 devsize, sb2_offset;
+	__u16 sb_size = sizeof(struct nilfs_super_block);
+
+	if (sbp1 == NULL && sbp2 == NULL)
+		return 0;
+
+	if (ioctl(devfd, BLKGETSIZE64, &devsize) != 0)
+		goto failed_read;
+
+	if (sbp1) {
+		if (lseek(devfd, NILFS_SB_OFFSET_BYTES, SEEK_SET) < 0 ||
+				read(devfd, sbp1, sb_size) < 0)
+			goto failed_read;
+	}
+
+	if (sbp2) {
+		sb2_offset = NILFS_SB2_OFFSET_BYTES(devsize);
+		if (sb2_offset <= (NILFS_SB_OFFSET_BYTES + sb_size))
+			goto invalid_sb_offset;
+
+		if (lseek(devfd, sb2_offset, SEEK_SET) < 0 ||
+				read(devfd, sbp2, sb_size) < 0)
+			goto failed_read;
+	}
+
+	return 0;
+
+invalid_sb_offset:
+	return -INVALID_SB_OFFSET;
+
+failed_read:
+	return -CANNOT_READ_SUPERBLOCK;
+}
+
  int nilfs_sb_write(int devfd, struct nilfs_super_block *sbp, int mask)
  {
  	__u64 offsets[2];
--

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
