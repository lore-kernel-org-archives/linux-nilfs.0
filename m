From: Hitoshi Mitake <mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH nilfs-utils v2 3/4] mount: don't pass -n option to cleanerd
Date: Mon,  6 Jan 2014 00:52:44 +0900
Message-ID: <1388937165-32692-4-git-send-email-mitake.hitoshi@gmail.com>
References: <1388937165-32692-1-git-send-email-mitake.hitoshi@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cY49NUmiq8YXy//OnMh4mTDXR4qQ0VN+py8fDOcAkPw=;
        b=d3vIuw5s3BYnLwnbYHRyPzdyck/4bQaPMhxBP0PB1oPrJCg9kgRTScs50c6scOKySI
         R4FHJ+Q2jC1aP0Qg7S5yYtnGdstsHzpds4Lw0yQtcRGzftAyq1FIBSQfD31FcHdlPpE/
         0gRis07beD9PR1VpU7P9Pnx1tXDWuU2CeBVYO5OG4BHYKhsnslvJL4/DB6v0r4jIzYOz
         Wq6AOr/1doR/8Ya9UPAkhKV3KALn+ALqzzpMG3yvQa1AWjfK/Y+lOkDoglMzcPRwoqZJ
         ZVspeZy/bgt0Tf2Xa3kOj/rzCjwDws6I52RPgjyM4mMeqkO6z6Y7hIjcX8J9m8DHoeMF
         OtOw==
In-Reply-To: <1388937165-32692-1-git-send-email-mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This patch lets mount.nilfs2 not pass the -n option to cleanerd,
because it is obsoleted.

Signed-off-by: Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 lib/cleaner_exec.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/lib/cleaner_exec.c b/lib/cleaner_exec.c
index 299451c..edc55e3 100644
--- a/lib/cleaner_exec.c
+++ b/lib/cleaner_exec.c
@@ -75,7 +75,6 @@
 #define WAIT_CLEANERD_RETRY_TIMEOUT	8	/* in seconds */
 
 static const char cleanerd[] = "/sbin/" NILFS_CLEANERD_NAME;
-static const char cleanerd_nofork_opt[] = "-n";
 static const char cleanerd_protperiod_opt[] = "-p";
 
 static void default_logger(int priority, const char *fmt, ...)
@@ -118,7 +117,7 @@ static inline int process_is_alive(pid_t pid)
 int nilfs_launch_cleanerd(const char *device, const char *mntdir,
 			  unsigned long protperiod, pid_t *ppid)
 {
-	const char *dargs[7];
+	const char *dargs[6];
 	struct stat statbuf;
 	sigset_t sigs;
 	int i = 0;
@@ -146,7 +145,6 @@ int nilfs_launch_cleanerd(const char *device, const char *mntdir,
 			exit(1);
 		}
 		dargs[i++] = cleanerd;
-		dargs[i++] = cleanerd_nofork_opt;
 		if (protperiod != ULONG_MAX) {
 			dargs[i++] = cleanerd_protperiod_opt;
 			snprintf(buf, sizeof(buf), "%lu", protperiod);
-- 
1.8.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
