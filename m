From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 4/4] nilfs2: improve execution time of NILFS_IOCTL_GET_CPINFO ioctl
Date: Sun, 22 Feb 2015 21:34:10 +0900
Message-ID: <1424608450-32240-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1424608450-32240-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=9LSHAfbea41sXF7SnjpY44XTEfjmL/3KUuQSvVrm0Kg=;
        b=lJGXw04xYTEemjcYcvv2yHLyAhhh2FfeIoQFJNXR12GEJ1OFhtVJRAD1jfC1zXKL5g
         HwwB9nwcaRnJeEGPeqU3Tdpx66KXFz+JZehBVImH9BJf0KFaRzv79vUJ9+voTWxwnicM
         5JqfMfe/VH9tj16CMGiy4tLkjg4gSYgBMaZzdjP8oAuIdkiW/ixkM+dO8NjMOd2sqAkb
         gqs4v6MLVTzRfAzD40pSYET74VvHM1dPP62CBm/hOlLHXbavMGO0C7dncaDrAWe16NYP
         eeR3cMB8QVRNInOHZ39daRCojnMukU2jj7UIFod22Z/A4cruNZxX/j8qcGbu52YEmYeR
         7/eA==
In-Reply-To: <1424608450-32240-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

The older a filesystem gets, the slower lscp command becomes.  This is
because nilfs_cpfile_do_get_cpinfo() function meets more hole blocks
as the start offset of valid checkpoint numbers gets bigger.

This reduces the overhead by skipping hole blocks efficiently with
nilfs_mdt_find_block() helper.

A measurement result of this patch is as follows:

Before:
$ time lscp
                 CNO        DATE     TIME  MODE  FLG      BLKCNT       ICNT
             5769303  2015-02-22 19:31:33   cp    -          108          1
             5769304  2015-02-22 19:38:54   cp    -          108          1

real    0m0.182s
user    0m0.003s
sys     0m0.180s

After:
$ time lscp
                 CNO        DATE     TIME  MODE  FLG      BLKCNT       ICNT
             5769303  2015-02-22 19:31:33   cp    -          108          1
             5769304  2015-02-22 19:38:54   cp    -          108          1

real    0m0.003s
user    0m0.001s
sys     0m0.002s

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/cpfile.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 52 insertions(+), 6 deletions(-)

diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index 0d58075..b6596ca 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -53,6 +53,13 @@ nilfs_cpfile_get_offset(const struct inode *cpfile, __u64 cno)
 	return do_div(tcno, nilfs_cpfile_checkpoints_per_block(cpfile));
 }
 
+static __u64 nilfs_cpfile_first_checkpoint_in_block(const struct inode *cpfile,
+						    unsigned long blkoff)
+{
+	return (__u64)nilfs_cpfile_checkpoints_per_block(cpfile) * blkoff
+		+ 1 - NILFS_MDT(cpfile)->mi_first_entry_offset;
+}
+
 static unsigned long
 nilfs_cpfile_checkpoints_in_block(const struct inode *cpfile,
 				  __u64 curr,
@@ -146,6 +153,44 @@ static inline int nilfs_cpfile_get_checkpoint_block(struct inode *cpfile,
 				   create, nilfs_cpfile_block_init, bhp);
 }
 
+/**
+ * nilfs_cpfile_find_checkpoint_block - find and get a buffer on cpfile
+ * @cpfile: inode of cpfile
+ * @start_cno: start checkpoint number (inclusive)
+ * @end_cno: end checkpoint number (inclusive)
+ * @cnop: place to store the next checkpoint number
+ * @bhp: place to store a pointer to buffer_head struct
+ *
+ * Return Value: On success, it returns 0. On error, the following negative
+ * error code is returned.
+ *
+ * %-ENOMEM - Insufficient memory available.
+ *
+ * %-EIO - I/O error
+ *
+ * %-ENOENT - no block exists in the range.
+ */
+static int nilfs_cpfile_find_checkpoint_block(struct inode *cpfile,
+					      __u64 start_cno, __u64 end_cno,
+					      __u64 *cnop,
+					      struct buffer_head **bhp)
+{
+	unsigned long start, end, blkoff;
+	int ret;
+
+	if (unlikely(start_cno > end_cno))
+		return -ENOENT;
+
+	start = nilfs_cpfile_get_blkoff(cpfile, start_cno);
+	end = nilfs_cpfile_get_blkoff(cpfile, end_cno);
+
+	ret = nilfs_mdt_find_block(cpfile, start, end, &blkoff, bhp);
+	if (!ret)
+		*cnop = (blkoff == start) ? start_cno :
+			nilfs_cpfile_first_checkpoint_in_block(cpfile, blkoff);
+	return ret;
+}
+
 static inline int nilfs_cpfile_delete_checkpoint_block(struct inode *cpfile,
 						       __u64 cno)
 {
@@ -403,14 +448,15 @@ static ssize_t nilfs_cpfile_do_get_cpinfo(struct inode *cpfile, __u64 *cnop,
 		return -ENOENT; /* checkpoint number 0 is invalid */
 	down_read(&NILFS_MDT(cpfile)->mi_sem);
 
-	for (n = 0; cno < cur_cno && n < nci; cno += ncps) {
-		ncps = nilfs_cpfile_checkpoints_in_block(cpfile, cno, cur_cno);
-		ret = nilfs_cpfile_get_checkpoint_block(cpfile, cno, 0, &bh);
+	for (n = 0; n < nci; cno += ncps) {
+		ret = nilfs_cpfile_find_checkpoint_block(
+			cpfile, cno, cur_cno - 1, &cno, &bh);
 		if (ret < 0) {
-			if (ret != -ENOENT)
-				goto out;
-			continue; /* skip hole */
+			if (likely(ret == -ENOENT))
+				break;
+			goto out;
 		}
+		ncps = nilfs_cpfile_checkpoints_in_block(cpfile, cno, cur_cno);
 
 		kaddr = kmap_atomic(bh->b_page);
 		cp = nilfs_cpfile_block_get_checkpoint(cpfile, cno, bh, kaddr);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
