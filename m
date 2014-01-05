From: Hitoshi Mitake <mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH nilfs-utils v2 2/4] cleanerd: call _exit(2) twice for ensuring not being a session leader
Date: Mon,  6 Jan 2014 00:52:43 +0900
Message-ID: <1388937165-32692-3-git-send-email-mitake.hitoshi@gmail.com>
References: <1388937165-32692-1-git-send-email-mitake.hitoshi@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TSinxzTXrMgLddCFKTFmiNxk94gIMQYk2kC7pyRdGrE=;
        b=kvPa6348zSy+BhJtsYE9nTidQfHek2rDTrhGnn2rfeXI+C0JbhnP3sm1/ZtSjWQRTM
         XZk5nXBoDzZnzC8pSQKdSOK3PPrRS7FzlmF8jYv/DowtXJtyDaHxt9PXcx97oMIHVYmR
         XhDDeCrzA29x0A8ACtwjSXX8sVC4ACJ4+gL8HW7sV1Yjn/9ZaldVp8gjnPTJ5N1hr75t
         vDiHowaDfhPFHvInvsEOYPVfRgH7G+pW9PnNQb/z2yakbGLwZZG2VmVEhGfvsQCIp+XI
         BOczKDUQLvcbsqQSbwYAo8ChQb1yA+PVHF0fNc/U22QSdr4WKt6WDRD616JkwMFnNRjr
         pU/g==
In-Reply-To: <1388937165-32692-1-git-send-email-mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Current daemonize() function of cleanerd call _exit(2) only once during its
process of becoming a daemon process. But in the linux environment, a daemon
should call _exit(2) twice for ensuring not being a session leader. If a
process don't do that, unexpected SIGHUP can be sent to the process (though it
happens rarely). The signal would be confusing event for cleanerd of nilfs. This
patch removes this potential problem.

Signed-off-by: Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 sbin/cleanerd/cleanerd.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
index 0b5bb70..86dfcf7 100644
--- a/sbin/cleanerd/cleanerd.c
+++ b/sbin/cleanerd/cleanerd.c
@@ -708,6 +708,14 @@ static int daemonize(int nochdir, int noclose)
 
 	/* umask(0); */
 
+	/* for ensuring I'm not a session leader */
+	pid = fork();
+	if (pid < 0)
+		return -1;
+	else if (pid != 0)
+		/* parent */
+		_exit(0);
+
 	if (!nochdir && (chdir(ROOTDIR) < 0))
 		return -1;
 
-- 
1.8.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
