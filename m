From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] nilfs2: fix shift-out-of-bounds due to too large exponent of block size
Date: Thu, 27 Oct 2022 13:43:06 +0900
Message-ID: <20221027044306.42774-3-konishi.ryusuke@gmail.com>
References: <20221027044306.42774-1-konishi.ryusuke@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1CCq70oXkrOiZ0hlpxTV/q9jKiiD+wVtMgJ5m746aQw=;
        b=Bk2VwBCDAGpwDYoxWcNk9af9n73eL1AzE9BSZtwllbt6iQ8p+FCHrlVcX6+1SIwlAv
         Qa1IFccARwZpVs+bV/LsCNIxrwHlveo6uIjDw2nbgIdlOuAA/tLwlFi40nI5uFwPVLcq
         rrFG3Mi5nhlaGCampV85QqYQpVoNNqtg56DiyPlG/9QUUBeC1sy3X0QVSdwAeBSjQTRU
         tUEMkmsIdyLMOE5BpeESBB36Lk6dU/VU+4hpfHXt1TkdJD3aCWKw1Hln98M8isg9t8G2
         7RM7HAAMXBCmdZP6ZzprLnCA3K9/+j/tOEDaAfzmIs4dDsv7oCUHdFN1W51eQE1dd17+
         vwVA==
In-Reply-To: <20221027044306.42774-1-konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, syzbot <syzbot+e91619dd4c11c4960706-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

If field s_log_block_size of superblock data is corrupted and too
large, init_nilfs() and load_nilfs() still can trigger a
shift-out-of-bounds warning followed by a kernel panic (if
panic_on_warn is set):

 shift exponent 38973 is too large for 32-bit type 'int'
 Call Trace:
  <TASK>
  dump_stack_lvl+0xcd/0x134
  ubsan_epilogue+0xb/0x50
  __ubsan_handle_shift_out_of_bounds.cold.12+0x17b/0x1f5
  init_nilfs.cold.11+0x18/0x1d [nilfs2]
  nilfs_mount+0x9b5/0x12b0 [nilfs2]
  ...

This fixes the issue by adding and using a new helper function for
getting block size with sanity check.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Tested-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/nilfs2/the_nilfs.c | 42 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 38 insertions(+), 4 deletions(-)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index d588816fdf2f..20ff02b4ef5d 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -193,6 +193,34 @@ static int nilfs_store_log_cursor(struct the_nilfs *nilfs,
 	return ret;
 }
 
+/**
+ * nilfs_get_blocksize - get block size from raw superblock data
+ * @sb: super block instance
+ * @sbp: superblock raw data buffer
+ * @blocksize: place to store block size
+ *
+ * nilfs_get_blocksize() calculates the block size from the block size
+ * exponent information written in @sbp and stores it in @blocksize,
+ * or aborts with an error message if it's too large.
+ *
+ * Return Value: On success, 0 is returned. If the block size is too
+ * large, -EINVAL is returned.
+ */
+static int nilfs_get_blocksize(struct super_block *sb,
+			       struct nilfs_super_block *sbp, int *blocksize)
+{
+	unsigned int shift_bits = le32_to_cpu(sbp->s_log_block_size);
+
+	if (unlikely(shift_bits >
+		     ilog2(NILFS_MAX_BLOCK_SIZE) - BLOCK_SIZE_BITS)) {
+		nilfs_err(sb, "too large filesystem blocksize: 2 ^ %u KiB",
+			  shift_bits);
+		return -EINVAL;
+	}
+	*blocksize = BLOCK_SIZE << shift_bits;
+	return 0;
+}
+
 /**
  * load_nilfs - load and recover the nilfs
  * @nilfs: the_nilfs structure to be released
@@ -246,11 +274,15 @@ int load_nilfs(struct the_nilfs *nilfs, struct super_block *sb)
 		nilfs->ns_sbwtime = le64_to_cpu(sbp[0]->s_wtime);
 
 		/* verify consistency between two super blocks */
-		blocksize = BLOCK_SIZE << le32_to_cpu(sbp[0]->s_log_block_size);
+		err = nilfs_get_blocksize(sb, sbp[0], &blocksize);
+		if (err)
+			goto scan_error;
+
 		if (blocksize != nilfs->ns_blocksize) {
 			nilfs_warn(sb,
 				   "blocksize differs between two super blocks (%d != %d)",
 				   blocksize, nilfs->ns_blocksize);
+			err = -EINVAL;
 			goto scan_error;
 		}
 
@@ -609,9 +641,11 @@ int init_nilfs(struct the_nilfs *nilfs, struct super_block *sb, char *data)
 	if (err)
 		goto failed_sbh;
 
-	blocksize = BLOCK_SIZE << le32_to_cpu(sbp->s_log_block_size);
-	if (blocksize < NILFS_MIN_BLOCK_SIZE ||
-	    blocksize > NILFS_MAX_BLOCK_SIZE) {
+	err = nilfs_get_blocksize(sb, sbp, &blocksize);
+	if (err)
+		goto failed_sbh;
+
+	if (blocksize < NILFS_MIN_BLOCK_SIZE) {
 		nilfs_err(sb,
 			  "couldn't mount because of unsupported filesystem blocksize %d",
 			  blocksize);
-- 
2.34.1

