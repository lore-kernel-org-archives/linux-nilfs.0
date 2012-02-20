From: Haogang Chen <haogangchen-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] FS: nilfs2: clamps ns_r_segments_percentage to [1, 99]
Date: Mon, 20 Feb 2012 16:55:30 -0500
Message-ID: <1329774930-17162-1-git-send-email-haogangchen@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=Z1QfWgibINF02xGJ0yWxgpf/XmyUOt1v4lFKPKmt0xs=;
        b=nBI1X/BHup9wS7gD1qi5uzj2+zEE+0zlL96qASgkiJkdeLcTNrYQM0GyQqoak79jc0
         bq38rj1+QQuFhm9NQCg6n32MdFx0qwk088l3fqL2rhAOI+kYhvn3Rw48/8yVGZbIJRWJ
         HJddGsdypruZDkYfYw/pMgOdesZtWyrF5bOxg=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, haogangchen-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

ns_r_segments_percentage is read from the disk. Bogus or malicious
value could cause integer overflow and potential security holes.
This patch reports error when mounting such bogus volumes.

Signed-off-by: Haogang Chen <haogangchen-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/nilfs2/the_nilfs.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index d327140..e12b47b 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -409,6 +409,12 @@ static int nilfs_store_disk_layout(struct the_nilfs *nilfs,
 	nilfs->ns_first_data_block = le64_to_cpu(sbp->s_first_data_block);
 	nilfs->ns_r_segments_percentage =
 		le32_to_cpu(sbp->s_r_segments_percentage);
+	if (nilfs->ns_r_segments_percentage < 1 ||
+		nilfs->ns_r_segments_percentage > 99) {
+		printk(KERN_ERR "NILFS: invalid reserved segments percentage.\n");
+		return -EINVAL;
+	}
+
 	nilfs_set_nsegments(nilfs, le64_to_cpu(sbp->s_nsegments));
 	nilfs->ns_crc_seed = le32_to_cpu(sbp->s_crc_seed);
 	return 0;
-- 
1.7.5.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
