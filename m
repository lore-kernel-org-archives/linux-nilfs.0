From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH v2 1/3] lib/nilfs.c: fix potential leak at nilfs_open()
Date: Mon, 19 Jan 2015 03:02:51 +0900
Message-ID: <1421604173-3397-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1421604173-3397-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=3SQjTC6Mvj1SAVQ+zAzJKyp/YnlBoHWyMgqASm4wCrA=;
        b=pgnOpYRfhMvljv8Cpn9OpBq+SRbLpPbU4/TtQRU0f0XfJpDQFOG73Elbc6AiCAbV1J
         DiWN+25EJdGHrS+N+YQbhOVRtsWwS7Y2soCng8y3AXBYLcfatmzJWl2N4FTzaOxP7xfI
         vhXRh4qJjjNSAvLau6YgXWm2vb1so3hzbRHpHLhs26lKs9Q5hnj3A4O8vKJaYyd804Vo
         kz+kpq0rN928ghlADJqLEo4ADvOmoF49NKZ8WeBJCM5LRNK6XsjjuXNNS6ksEYtWtAZu
         SXmllJbyFymhOy7Ik/mkEYNveVi5JZjuN7cROp94LSC4pGTcwDDcznTE9/hfjRoK+kN6
         Mz+g==
In-Reply-To: <1421604173-3397-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

nilfs_open() can exit without closing nilfs->n_devfd and freeing
nilfs->n_dev and nilfs->n_sb if it first initializes a nilfs object in
the code path for NILFS_OPEN_RAW mode and then escapes through
out_nilfs label.  This fixes the leak issue.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 lib/nilfs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/lib/nilfs.c b/lib/nilfs.c
index 65bf7d5..52ddee9 100644
--- a/lib/nilfs.c
+++ b/lib/nilfs.c
@@ -411,9 +411,9 @@ struct nilfs *nilfs_open(const char *dev, const char *dir, int flags)
 	    (NILFS_OPEN_RDONLY | NILFS_OPEN_WRONLY | NILFS_OPEN_RDWR)) {
 		if (nilfs_find_fs(nilfs, dev, dir, MNTOPT_RW) < 0) {
 			if (!(flags & NILFS_OPEN_RDONLY))
-				goto out_nilfs;
+				goto out_fd;
 			if (nilfs_find_fs(nilfs, dev, dir, MNTOPT_RO) < 0)
-				goto out_nilfs;
+				goto out_fd;
 		}
 		nilfs->n_iocfd = open(nilfs->n_ioc, O_RDONLY);
 		if (nilfs->n_iocfd < 0)
@@ -442,7 +442,6 @@ out_fd:
 	if (nilfs->n_sb != NULL)
 		free(nilfs->n_sb);
 
-out_nilfs:
 	free(nilfs);
 	return NULL;
 }
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
