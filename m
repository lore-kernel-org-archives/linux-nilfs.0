From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] libnilfs: set errno when device doesn't contain valid NILFS data
Date: Sat, 23 Aug 2014 16:12:18 +0900
Message-ID: <1408777938-29425-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=1VKyFkFfJkJe6c2nUtfyNB1speDPF+tSYdv3CjbvDec=;
        b=EeZ44jH4rKxhfMoDgK3VuficwaGAMRgaGG9eTUnjl5/HFjKpyTtC7XIKWL7lbY6hT6
         pZtu+t1YZFgQuyCpb+fsZn/KWA1Rkixch1MndS3sebGs6TyR428jiq89YsAojN8uwPD0
         UYo/S0Pe9kju1TLkpq5mnpydJ/+bWMMqAvIzGdr6rsTh4dqbH0U3mtnA3zd+eI3cmI8R
         ONl99+U0t+u6bdiAopZ+xI3V2UtHTJubHS/lfVjTshxmTl9IGnX89qOnQTarK7Rcr2PQ
         3O5Z7b+WuVxHWG6DsW9qxBv3n3GcD2viffax+yvM/ChhLNAGX5KcEYOCboZYqlAQCIGU
         v0yQ==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Fix the bug that no error number is set to errno variable if the
specified device doesn't contain a valid nilfs file system, which
causes caller programs to output successful message wrongly.  Three
functions, nilfs_open(), nilfs_sb_read() and nilfs_sb_write() have
this flaw.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 lib/sb.c |   55 +++++++++++++++++++++++++++++++++----------------------
 1 file changed, 33 insertions(+), 22 deletions(-)

diff --git a/lib/sb.c b/lib/sb.c
index 94bccaf..44453bb 100644
--- a/lib/sb.c
+++ b/lib/sb.c
@@ -97,10 +97,20 @@ static int nilfs_sb_is_valid(struct nilfs_super_block *sbp, int check_crc)
 	return crc == le32_to_cpu(sbp->s_sum);
 }
 
+static int nilfs_sb2_offset_is_too_small(struct nilfs_super_block *sbp,
+					 __u64 sb2_offset)
+{
+	return sb2_offset < ((le64_to_cpu(sbp->s_nsegments) *
+			      le32_to_cpu(sbp->s_blocks_per_segment)) <<
+			     (le32_to_cpu(sbp->s_log_block_size) +
+			      NILFS_SB_BLOCK_SIZE_SHIFT));
+}
+
 static int __nilfs_sb_read(int devfd, struct nilfs_super_block **sbp,
 			   __u64 *offsets)
 {
 	__u64 devsize, sb2_offset;
+	int invalid_fs = 0;
 
 	sbp[0] = malloc(NILFS_MAX_SB_SIZE);
 	sbp[1] = malloc(NILFS_MAX_SB_SIZE);
@@ -110,34 +120,40 @@ static int __nilfs_sb_read(int devfd, struct nilfs_super_block **sbp,
 	if (ioctl(devfd, BLKGETSIZE64, &devsize) != 0)
 		goto failed;
 
-	if (lseek(devfd, NILFS_SB_OFFSET_BYTES, SEEK_SET) < 0 ||
-	    read(devfd, sbp[0], NILFS_MAX_SB_SIZE) < 0 ||
-	    !nilfs_sb_is_valid(sbp[0], 0)) {
-		free(sbp[0]);
-		sbp[0] = NULL;
+	if (lseek(devfd, NILFS_SB_OFFSET_BYTES, SEEK_SET) >= 0 &&
+	    read(devfd, sbp[0], NILFS_MAX_SB_SIZE) >= 0) {
+		if (nilfs_sb_is_valid(sbp[0], 0))
+			goto sb1_ok;
+		invalid_fs = 1;
 	}
 
+	free(sbp[0]);
+	sbp[0] = NULL;
+sb1_ok:
+
 	sb2_offset = NILFS_SB2_OFFSET_BYTES(devsize);
 	if (offsets) {
 		offsets[0] = NILFS_SB_OFFSET_BYTES;
 		offsets[1] = sb2_offset;
 	}
 
-	if (lseek(devfd, sb2_offset, SEEK_SET) < 0 ||
-	    read(devfd, sbp[1], NILFS_MAX_SB_SIZE) < 0 ||
-	    !nilfs_sb_is_valid(sbp[1], 0))
-		goto sb2_failed;
+	if (lseek(devfd, sb2_offset, SEEK_SET) >= 0 &&
+	    read(devfd, sbp[1], NILFS_MAX_SB_SIZE) >= 0) {
+		if (nilfs_sb_is_valid(sbp[1], 0) &&
+		    !nilfs_sb2_offset_is_too_small(sbp[1], sb2_offset))
+			goto sb2_ok;
+		invalid_fs = 1;
+	}
 
-	if (sb2_offset <
-	    (le64_to_cpu(sbp[1]->s_nsegments) *
-	     le32_to_cpu(sbp[1]->s_blocks_per_segment)) <<
-	    (le32_to_cpu(sbp[1]->s_log_block_size) +
-	     NILFS_SB_BLOCK_SIZE_SHIFT))
-		goto sb2_failed;
+	free(sbp[1]);
+	sbp[1] = NULL;
+sb2_ok:
 
- sb2_done:
-	if (!sbp[0] && !sbp[1])
+	if (!sbp[0] && !sbp[1]) {
+		if (invalid_fs)
+			errno = EINVAL;
 		goto failed;
+	}
 
 	return 0;
 
@@ -145,11 +161,6 @@ static int __nilfs_sb_read(int devfd, struct nilfs_super_block **sbp,
 	free(sbp[0]);  /* free(NULL) is just ignored */
 	free(sbp[1]);
 	return -1;
-
- sb2_failed:
-	free(sbp[1]);
-	sbp[1] = NULL;
-	goto sb2_done;
 }
 
 struct nilfs_super_block *nilfs_sb_read(int devfd)
-- 
1.7.9.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
