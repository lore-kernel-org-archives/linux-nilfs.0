From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 03/10] nilfs-utils: do not indent labels
Date: Fri, 14 Feb 2014 03:24:03 +0900
Message-ID: <1392315850-29149-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1392315850-29149-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1392315850-29149-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Fix the following checkpatch warnings:

 WARNING: labels should not be indented
 #218: FILE: lssu.c:218:
 +               skip_scan:

 WARNING: labels should not be indented
 #1565: FILE: cleanerd/cleanerd.c:1565:
 +       sleep:

 WARNING: labels should not be indented
 #58: FILE: mount/mount_mntent.c:58:
 +       next:

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 bin/lssu.c                |    2 +-
 sbin/cleanerd/cleanerd.c  |    2 +-
 sbin/mount/mount_mntent.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/bin/lssu.c b/bin/lssu.c
index add7252..d19f7ba 100644
--- a/bin/lssu.c
+++ b/bin/lssu.c
@@ -215,7 +215,7 @@ static ssize_t lssu_print_suinfo(struct nilfs *nilfs, __u64 segnum,
 				exit(1);
 			}
 
-		skip_scan:
+skip_scan:
 			printf(lssu_format[disp_mode].body,
 			       (unsigned long long)segnum,
 			       timebuf,
diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
index 1f21f06..17de87b 100644
--- a/sbin/cleanerd/cleanerd.c
+++ b/sbin/cleanerd/cleanerd.c
@@ -1562,7 +1562,7 @@ static int nilfs_cleanerd_clean_loop(struct nilfs_cleanerd *cleanerd)
 		if (ret < 0)
 			return -1;
 
-	sleep:
+sleep:
 		if (sigprocmask(SIG_UNBLOCK, &sigset, NULL) < 0) {
 			syslog(LOG_ERR, "cannot set signal mask: %m");
 			return -1;
diff --git a/sbin/mount/mount_mntent.c b/sbin/mount/mount_mntent.c
index d4d02f5..ad05183 100644
--- a/sbin/mount/mount_mntent.c
+++ b/sbin/mount/mount_mntent.c
@@ -55,7 +55,7 @@ mangle(const char *s) {
 		*sp++ = *s;
 		if (*s == 0)
 			break;
-	next:
+next:
 		s++;
 	}
 	return ss;
-- 
1.7.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
