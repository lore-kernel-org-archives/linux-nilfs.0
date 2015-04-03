From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] lib/nilfs: add missing initialization of nilfs->n_opts
Date: Fri,  3 Apr 2015 22:40:52 +0900
Message-ID: <1428068452-5895-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=ltd3meApdzGV12sdWxs5efL+RVI8CRrypVwXpYHzOEI=;
        b=Im6t2knKRONm/G+ptxqmLGkn/dKHMR9VmrN9LRRjAaJ4kIXzJ2MACDMhG/NOKdWGKn
         e4LhT6v/Ph0b0JXmx04+L2OP/WXqQt5BjowO9xWC6gOsWGJiMRb3siVrWXoL2T32Wxsp
         AJ2OLpwcCkdtCyy4Cgd9Qv7RzOs45hMMEKtcz69zVdq414M48uWGdnVXRpwKXdxvHDlY
         SeawbNLfcDQtURtRHm4/4m1/u90pXbC/G94jFGdM7v27mQvT1nYi4/QY5mmfjckyIuCR
         Q0SkYwIHy3E6IYshcacuOxCniOyk2LpUJpommxtFcVeYxI+oBxe+LkCn3HAoiCNB5L9z
         WH6g==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Options of lib/nilfs is stored in n_opts member of nilfs object.  This
variable is not initialized in the current implementation of
nilfs_open API.  Thus, it can cause indeterminate behavior.

This issue is originally pointed out by Andreas Rohner in his rfc
patch titled "nilfs-utils: add support for tracking live blocks".

This fixes it separately.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 lib/nilfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/nilfs.c b/lib/nilfs.c
index 30db654..1d18ffc 100644
--- a/lib/nilfs.c
+++ b/lib/nilfs.c
@@ -381,6 +381,7 @@ struct nilfs *nilfs_open(const char *dev, const char *dir, int flags)
 	nilfs->n_iocfd = -1;
 	nilfs->n_dev = NULL;
 	nilfs->n_ioc = NULL;
+	nilfs->n_opts = 0;
 	nilfs->n_mincno = NILFS_CNO_MIN;
 	memset(nilfs->n_sems, 0, sizeof(nilfs->n_sems));
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
