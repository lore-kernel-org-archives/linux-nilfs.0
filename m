From: Xi Wang <xi.wang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] nilfs2: avoid overflowing segment numbers in nilfs_ioctl_clean_segments()
Date: Fri,  3 Feb 2012 10:26:07 -0500
Message-ID: <1328282767-13158-1-git-send-email-xi.wang@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=ncqyt2Uqa9Sx7n9I8kEUR8obhXvv+mWRZ2vDGoetrWI=;
        b=cMg2TnPH7hKP8xaTqS+3sgksjBFzC6bBdYyS1TRpP0Q1iEdRtwuPV9+O7tl2vDbxr8
         UYGMN8jZ+qsiCCwPZY0bXoIi9YD8wz49dx9Lu4F6TGSNRlTZbqLso2S4pRP6b2RytZJ9
         RTOG4CjpHjf2R1o8j6IutREWPHvmwX2el4NpQ=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KONISHI Ryusuke <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Xi Wang <xi.wang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Haogang Chen <haogangchen-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

nsegs is read from userspace.  Limit its value and avoid overflowing
nsegs * sizeof(__u64) in the subsequent call to memdup_user().

This patch complements 481fe17e973fb97aa3edf17c69557afe88d8334f.

Signed-off-by: Xi Wang <xi.wang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Haogang Chen <haogangchen-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
---
 fs/nilfs2/ioctl.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 8866496..2a70fce 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -603,6 +603,8 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
 	nsegs = argv[4].v_nmembs;
 	if (argv[4].v_size != argsz[4])
 		goto out;
+	if (nsegs > UINT_MAX / sizeof(__u64))
+		goto out;
 
 	/*
 	 * argv[4] points to segment numbers this ioctl cleans.  We
-- 
1.7.5.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
