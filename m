From: Hitoshi Mitake <mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH nilfs-utils v2 1/4] cleanerd: ignore nofork option
Date: Mon,  6 Jan 2014 00:52:42 +0900
Message-ID: <1388937165-32692-2-git-send-email-mitake.hitoshi@gmail.com>
References: <1388937165-32692-1-git-send-email-mitake.hitoshi@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Z/0FItbcf07sf9smXsasDQPh+q1svlmvyyeD6k/Ksg4=;
        b=Sx1Cpt+MCeD3H495ZINMYGLcoTeuVQy1YbX3AnVk5AZ8k/SLYFFHdk4h3AEk2n/PS7
         ApYfxdKNhwUnSZ4P6o7N6gp/Mcanz3bo6xIGa2eyvKUsmBUHUF8421wSyM/U+BS43TDQ
         ivaW4cVBrG5XS/zJXOyknMfEn6ZhLO4MvUGcvysOKhmmkAndrnRtJ8h5tTd2fFUHHDHm
         jHIcjW6OfUz9RuB0Cck3z0MXQON6p9lZId6ncMpdK6t40lqn0SGYz+9xHaE/VecRZbHd
         f3Iwq4XYg9CRrKFxWgsPO3MHgZXa9125+nGDkXQUGpFXL5NmRaMFXn1acE25cuHKJDgp
         Pvjw==
In-Reply-To: <1388937165-32692-1-git-send-email-mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

The nofork option aims to reduce call of fork(), but it is not
effective. This patch lets cleanerd ignore the option simply even if
it is passed.

Signed-off-by: Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 sbin/cleanerd/cleanerd.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
index e1f6a04..0b5bb70 100644
--- a/sbin/cleanerd/cleanerd.c
+++ b/sbin/cleanerd/cleanerd.c
@@ -113,7 +113,7 @@ do {						\
 const static struct option long_option[] = {
 	{"conffile", required_argument, NULL, 'c'},
 	{"help", no_argument, NULL, 'h'},
-	/* internal option for mount.nilfs2 only */
+	/* nofork option is obsolete. It does nothing even if passed */
 	{"nofork", no_argument, NULL, 'n'},
 	{"protection-period", required_argument, NULL, 'p'},
 	{"version", no_argument, NULL, 'V'},
@@ -691,20 +691,18 @@ static int oom_adjust(void)
 #define DEVNULL	"/dev/null"
 #define ROOTDIR	"/"
 
-static int daemonize(int nochdir, int noclose, int nofork)
+static int daemonize(int nochdir, int noclose)
 {
 	pid_t pid;
 
-	if (!nofork) {
-		pid = fork();
-		if (pid < 0)
-			return -1;
-		else if (pid != 0)
-			/* parent */
-			_exit(0);
-	}
+	pid = fork();
+	if (pid < 0)
+		return -1;
+	else if (pid != 0)
+		/* parent */
+		_exit(0);
 
-	/* child or nofork */
+	/* child */
 	if (setsid() < 0)
 		return -1;
 
@@ -1491,7 +1489,7 @@ int main(int argc, char *argv[])
 	char canonical[PATH_MAX + 2];
 	const char *dev, *dir;
 	char *endptr;
-	int status, nofork, c;
+	int status, c;
 #ifdef _GNU_SOURCE
 	int option_index;
 #endif	/* _GNU_SOURCE */
@@ -1499,7 +1497,6 @@ int main(int argc, char *argv[])
 	progname = (strrchr(argv[0], '/') != NULL) ?
 		strrchr(argv[0], '/') + 1 : argv[0];
 	conffile = NILFS_CLEANERD_CONFFILE;
-	nofork = 0;
 	status = 0;
 	protection_period = ULONG_MAX;
 	dev = NULL;
@@ -1520,8 +1517,7 @@ int main(int argc, char *argv[])
 			nilfs_cleanerd_usage(progname);
 			exit(0);
 		case 'n':
-			/* internal option for mount.nilfs2 only */
-			nofork = 1;
+			/* ignore nofork option, do nothing */
 			break;
 		case 'p':
 			protection_period = strtoul(optarg, &endptr, 10);
@@ -1568,7 +1564,7 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	if (daemonize(0, 0, nofork) < 0) {
+	if (daemonize(0, 0) < 0) {
 		fprintf(stderr, "%s: %s\n", progname, strerror(errno));
 		exit(1);
 	}
-- 
1.8.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
