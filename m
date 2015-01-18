From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/3] lib/nilfs.c: fix potential leak at nilfs_open()
Date: Mon, 19 Jan 2015 02:34:36 +0900
Message-ID: <1421602478-1896-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1421602478-1896-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=3SQjTC6Mvj1SAVQ+zAzJKyp/YnlBoHWyMgqASm4wCrA=;
        b=lFlfs47xClFL83E0rABfNZ0EPKx7ntQ0KLzaDNe40UuEq8uMX9/auTyTuz4QI9pKFZ
         7Dmn+Y0E5h3OtFbp+qPViR5dPxWYP1vY8IeuGt9lH7adaKWyEeCEpkXzdubs1AZPW9Vn
         w1Itb7lqU9GW+VWQG0tWun0CUgC0tSunoa6V1cYhuRUO2O9/Lr+wLwgrczNF9QAQfzJ0
         rtDb00d9+Ar/JwHHYkcgEKFn9p98bYYiivma9/yw0lTGniOD4OM3zrRjHaaf/UbXde93
         D/jC9ACcTVUqPZm2GuHdzlqoT4zd79aMziqA5195hhJvxkycf3YaF4Cp/LBn+6Y58yVq
         9UNg==
In-Reply-To: <1421602478-1896-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
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
