From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: cleanerd segfault
Date: Thu, 05 Feb 2009 18:19:04 +0900 (JST)
Message-ID: <20090205.181904.55833415.ryusuke@osrg.net>
References: <lB4DD31fNVpx.grrKfnNr@mail.prnet.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <lB4DD31fNVpx.grrKfnNr-GG6YVgmNXeLOQU1ULcgDhA@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org

On Thu,  5 Feb 2009 08:52:32 +0100, admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org wrote:
> I can confirm that it is also reproducable on a newly created nilfs2
> populated with some files.

All right.
Could you try the following patch against nilfs2-utils ?

This makes cleanerd which can dump backtrace to /var/log/segv_xxx.

To enable the feature, you need gdb and a 'backtrace' script
available on http://samba.org/ftp/unpacked/junkcode/segv_handler/


Regards,
Ryusuke

--
diff --git a/sbin/cleanerd/Makefile.am b/sbin/cleanerd/Makefile.am
index e6b2553..488518e 100644
--- a/sbin/cleanerd/Makefile.am
+++ b/sbin/cleanerd/Makefile.am
@@ -8,7 +8,7 @@ sbin_PROGRAMS = nilfs_cleanerd
 
 nilfs_cleanerd_SOURCES = cleanerd.c cldconfig.c vector.c \
 	cleanerd.h cldconfig.h vector.h
-nilfs_cleanerd_CFLAGS = -Wall
+nilfs_cleanerd_CFLAGS = -Wall -g
 nilfs_cleanerd_CPPFLAGS = -I$(top_srcdir)/include \
 	-DSYSCONFDIR=\"$(sysconfdir)\" -D_GNU_SOURCE
 nilfs_cleanerd_LDADD = $(top_builddir)/lib/libnilfs.la
diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
index cae22be..5f67e51 100644
--- a/sbin/cleanerd/cleanerd.c
+++ b/sbin/cleanerd/cleanerd.c
@@ -829,6 +829,46 @@ static int set_sighup_handler(void)
 	return sigaction(SIGHUP, &act, NULL);
 }
 
+/*
+ * The following part is based on segv_handler by Andrew Tridgell
+ * found at http://samba.org/ftp/unpacked/junkcode/segv_handler/
+ *
+ * To enable this feature, install gdb and 'backtrace' script available
+ * on the above site.
+ */
+static RETSIGTYPE handle_segv(int signum)
+{
+	char cmd[100];
+	char progname[100];
+	char *p;
+	int n;
+
+	n = readlink("/proc/self/exe",progname,sizeof(progname));
+	progname[n] = 0;
+
+	p = strrchr(progname, '/');
+	*p = 0;
+	
+	snprintf(cmd, sizeof(cmd),
+		 "backtrace %d > /var/log/segv_%s.%d.out 2>&1", 
+		 (int)getpid(), p+1, (int)getpid());
+	system(cmd);
+	signal(signum, SIG_DFL);
+}
+
+static int set_segv_handler(void)
+{
+	struct sigaction act;
+
+	act.sa_handler = handle_segv;
+	sigfillset(&act.sa_mask);
+	act.sa_flags = 0;
+	return sigaction(SIGSEGV, &act, NULL) || sigaction(SIGBUS, &act, NULL);
+}
+/*
+ * End of segv_handler
+ */
+
 #define timeval_to_timespec(tv, ts)		\
 do {						\
 	(ts)->tv_sec = (tv)->tv_sec;		\
@@ -859,6 +899,10 @@ static int nilfs_cleanerd_clean_loop(struct nilfs_cleanerd *cleanerd)
 		syslog(LOG_ERR, "cannot set SIGHUP signal handler: %m");
 		return -1;
 	}
+	if (set_segv_handler() < 0) {
+		syslog(LOG_ERR, "cannot set SIGSEGV signal handler: %m");
+		return -1;
+	}
 
 	nilfs_cleanerd_reload_config = 0;
 
-- 
1.5.6.5
