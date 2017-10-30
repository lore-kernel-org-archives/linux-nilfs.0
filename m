From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 3/4] nilfs2: align block comments of nilfs_sufile_truncate_range() at *
Date: Mon, 30 Oct 2017 21:52:14 +0900
Message-ID: <1509367935-3086-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1509367935-3086-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=r9Goxbd/3+q7QaEygW6p03/HXIt+wLRq7HrmfK8W54k=;
        b=NUwp/Qn6Xx52Wv+yQv9sVctUv56ci8a0fJSfhRrwIlyNNm8kZmgOnkcj5VtF8GzX0I
         GFlnz//goT7uA4iOa/tY6m8RKSZ5yMHTH+tlY8/hE7TsHUcr0VzIM6EDe30CBGeZr6DQ
         AxAlfWtxXrwH9Z+hUk4s8OpAGnK1EKtKsvsM1SlRyJpQC+eLfn1TmYMDi/X74Oft8VBy
         K/bM5hZYi/KS/4bGXf4Vjb5hhOaqkggl9rgtAFLz4rUaUGJLU+H5QMYl+wjUCeV/6yfI
         bGWbZWbIZV+lYfwsGfGxKIEIn5rgQOCJpaD5Wmxzx7trhU0ZI4jQG2nNehaFHmf3zyFB
         xl2g==
In-Reply-To: <1509367935-3086-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Fix the following checkpatch warning:

 WARNING: Block comments should align the * on each line
 #633: FILE: sufile.c:633:
 +/**
 +  * nilfs_sufile_truncate_range - truncate range of segment array

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/sufile.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 1541a1e..1341a41 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -630,22 +630,22 @@ void nilfs_sufile_do_set_error(struct inode *sufile, __u64 segnum,
 }
 
 /**
-  * nilfs_sufile_truncate_range - truncate range of segment array
-  * @sufile: inode of segment usage file
-  * @start: start segment number (inclusive)
-  * @end: end segment number (inclusive)
-  *
-  * Return Value: On success, 0 is returned.  On error, one of the
-  * following negative error codes is returned.
-  *
-  * %-EIO - I/O error.
-  *
-  * %-ENOMEM - Insufficient amount of memory available.
-  *
-  * %-EINVAL - Invalid number of segments specified
-  *
-  * %-EBUSY - Dirty or active segments are present in the range
-  */
+ * nilfs_sufile_truncate_range - truncate range of segment array
+ * @sufile: inode of segment usage file
+ * @start: start segment number (inclusive)
+ * @end: end segment number (inclusive)
+ *
+ * Return Value: On success, 0 is returned.  On error, one of the
+ * following negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ *
+ * %-EINVAL - Invalid number of segments specified
+ *
+ * %-EBUSY - Dirty or active segments are present in the range
+ */
 static int nilfs_sufile_truncate_range(struct inode *sufile,
 				       __u64 start, __u64 end)
 {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
