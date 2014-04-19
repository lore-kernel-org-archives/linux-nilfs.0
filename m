From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 3/4] nilfs-utils: fix typos in messages
Date: Sun, 20 Apr 2014 00:14:14 +0900
Message-ID: <1397920455-373-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1397920455-373-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1397920455-373-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Fix typos in messages of nilfs-resize command, lssu command, and
libnilfsgc.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 bin/lssu.c                       | 2 +-
 lib/gc.c                         | 2 +-
 sbin/nilfs-resize/nilfs-resize.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/bin/lssu.c b/bin/lssu.c
index 5f501b1..ebbd926 100644
--- a/bin/lssu.c
+++ b/bin/lssu.c
@@ -290,7 +290,7 @@ static int lssu_get_protcno(struct nilfs *nilfs,
 	ret = nilfs_cnoconv_time2cno(cnoconv, *prottimep, protcnop);
 	if (ret < 0) {
 		fprintf(stderr,
-			"%s: cannot convert protectoin time to checkpoint "
+			"%s: cannot convert protection time to checkpoint "
 			"number: %m\n",
 			progname);
 	}
diff --git a/lib/gc.c b/lib/gc.c
index 453acf2..bb644c4 100644
--- a/lib/gc.c
+++ b/lib/gc.c
@@ -360,7 +360,7 @@ static ssize_t nilfs_get_snapshot(struct nilfs *nilfs, nilfs_cno_t **ssp)
 				nilfs_gc_logger
 					(LOG_ERR,
 					 "broken snapshot information. "
-					 "snapshot numbers apeared in a "
+					 "snapshot numbers appeared in a "
 					 "non-ascending order: %llu >= %llu",
 					 (unsigned long long)prev,
 					 (unsigned long long)ss[i + j]);
diff --git a/sbin/nilfs-resize/nilfs-resize.c b/sbin/nilfs-resize/nilfs-resize.c
index c7ed910..d605e59 100644
--- a/sbin/nilfs-resize/nilfs-resize.c
+++ b/sbin/nilfs-resize/nilfs-resize.c
@@ -1186,7 +1186,7 @@ int main(int argc, char *argv[])
 			unsigned long long size2;
 
 			size2 = size & ~(sector_size - 1);
-			myprintf("size %llu is not alinged to sector " \
+			myprintf("size %llu is not aligned to sector " \
 				 "size. truncated to %llu.\n",
 				 size, size2);
 			size = size2;
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
