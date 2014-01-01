From: Hitoshi Mitake <mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH nilfs-utils 2/2] cleanerd: adjust the OOM killer
Date: Wed,  1 Jan 2014 16:30:49 +0900
Message-ID: <1388561449-13980-3-git-send-email-mitake.hitoshi@gmail.com>
References: <1388561449-13980-1-git-send-email-mitake.hitoshi@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pGj7W58nDnrnO41rBYmiTQunK+pCh33Nul/iojqNLNk=;
        b=Vs/L1524Mspx+m5I6LfTalUHkcPuMe7sev/4R6FRgEzVxT7H0GdvSZ5+8YBaAIPxWY
         5K+8kby09+CaxgangswncIcQjwvkaO67sKlvy9nenMAI95ofvxByzYj8Q81Wb/gf8kZU
         FeFWTEFcLbZbpHCHXeam4s4rNPezPxOo50t1IQ7bZCgh7k0PVLyBvOBB0pYdJZgpuDu5
         W/AFwtTThM7FnUxzfozpZmEM/0udGC2Oejgp9jEDOenYAV5p6lo5gtNLCyv9BFbZSqX3
         WQ7FEPb3vlXTDV27AfN4dAsM/u3Dpel/OecnyeuZLsP/40v/KUpqZodzWL9hH+5fr5lt
         bNsQ==
In-Reply-To: <1388561449-13980-1-git-send-email-mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

cleanerd is a very important process in a system which uses nilfs. So it should
adjust the OOM killer for reducing possibility of the killing as much as
possible.

Signed-off-by: Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 sbin/cleanerd/cleanerd.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
index edfa083..3494a9a 100644
--- a/sbin/cleanerd/cleanerd.c
+++ b/sbin/cleanerd/cleanerd.c
@@ -654,6 +654,40 @@ nilfs_cleanerd_select_segments(struct nilfs_cleanerd *cleanerd,
 	return nssegs;
 }
 
+static int oom_adjust(void)
+{
+	int fd, err;
+	const char *path, *score;
+	struct stat st;
+
+	/* Avoid oom-killer */
+	path = "/proc/self/oom_score_adj";
+	score = "-1000\n";
+
+	if (stat(path, &st)) {
+		/* oom_score_adj cannot be used, try oom_adj */
+		path = "/proc/self/oom_adj";
+		score = "-17\n";
+	}
+
+	fd = open(path, O_WRONLY);
+	if (fd < 0) {
+		fprintf(stderr, "can't adjust oom-killer's pardon %s, %m\n",
+			path);
+		return errno;
+	}
+
+	err = write(fd, score, strlen(score));
+	if (err < 0) {
+		fprintf(stderr, "can't adjust oom-killer's pardon %s, %m\n",
+			path);
+		close(fd);
+		return errno;
+	}
+	close(fd);
+	return 0;
+}
+
 #define DEVNULL	"/dev/null"
 #define ROOTDIR	"/"
 
@@ -1549,6 +1583,11 @@ int main(int argc, char *argv[])
 		exit(1);
 	}
 
+	if (oom_adjust() < 0) {
+		fprintf(stderr, "adjusting the OOM killer falied: %m\n");
+		exit(1);
+	}
+
 	openlog(progname, LOG_PID, LOG_DAEMON);
 	syslog(LOG_INFO, "start");
 
-- 
1.8.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
