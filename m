From: Hitoshi Mitake <mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH nilfs-utils 1/2] cleanerd: call _exit(2) twice for ensuring not being a session leader
Date: Wed,  1 Jan 2014 16:30:48 +0900
Message-ID: <1388561449-13980-2-git-send-email-mitake.hitoshi@gmail.com>
References: <1388561449-13980-1-git-send-email-mitake.hitoshi@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WXTafjic2XcX8cU+AA5BJFokN4DD+ld2zh6RAyCtkdc=;
        b=DRAArqmPO6D305DaG7VaWMKScdWVFGNBgtjgjZXJIyPjMpmhxferHAKUMNsbroE8Zy
         5VHcF995+FUp5fL3qFudrMDxNpFX4ClGYanuz9RSILQJqfP53nf73UMpvhgH/L7B1SIL
         Lnha4Wux3KbnQFtJC7AA/5OaXf/f+H6lTYSkNq/8l9gbfOHsq9c8BD7QytMyQSLtObp8
         +GfvDn5DmzBWe0o4cKOPu2NtBqSbMozh/ere8+wQvTW1kmGhudSpgufnwZ5l0kX/jJpL
         oV2NT2k559+/7CS3W9PJ9Wa197dvBJWchtO5Szfb878rSt3QMgUYG9hpWl66uLkMiGrv
         2ktg==
In-Reply-To: <1388561449-13980-1-git-send-email-mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Current daemonize() function of cleanerd call _exit(2) only once during its
process of becoming a daemon process. But in the linux environment, a daemon
process should call _exit(2) twice for ensuring not being a session leader. If a
process don't do that, unexpected SIGHUP can be sent to the process (though it
happens rarely). The signal would be confusing event for cleanerd of nilfs. This
patch removes this potential problem.

Signed-off-by: Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 sbin/cleanerd/cleanerd.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
index 26067bd..edfa083 100644
--- a/sbin/cleanerd/cleanerd.c
+++ b/sbin/cleanerd/cleanerd.c
@@ -676,6 +676,16 @@ static int daemonize(int nochdir, int noclose, int nofork)
 
 	/* umask(0); */
 
+	/* for ensuring I'm not a session leader */
+	if (!nofork) {
+		pid = fork();
+		if (pid < 0)
+			return -1;
+		else if (pid != 0)
+			/* parent */
+			_exit(0);
+	}
+
 	if (!nochdir && (chdir(ROOTDIR) < 0))
 		return -1;
 
-- 
1.8.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
