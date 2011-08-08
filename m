From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Applying nice/ionice to nilfs-cleanerd
Date: Mon, 08 Aug 2011 18:02:53 +0900 (JST)
Message-ID: <20110808.180253.112907213.ryusuke@osrg.net>
References: <28d103cbef1f8ebb3a7b458509e53c4d@mail.shatteredsilicon.net>
	<20110808.082319.114757823.ryusuke@osrg.net>
	<4E3F211E.4060806@bobich.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E3F211E.4060806-UpbECiGlrmGsTnJN9+BGXg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: gordan-UpbECiGlrmGsTnJN9+BGXg@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Mon, 08 Aug 2011 00:34:54 +0100, Gordan Bobic wrote:
> On 08/08/2011 12:23 AM, Ryusuke Konishi wrote:
> >>
> >>   Is there a way to set default nice/ionice levels for nilfs-cleanerd?
> >
> > At present, you have to manually invoke the cleanerd through the
> > nice/ionice commands or to run renice/ionice later specifying the
> > process ID of the cleanerd.
> >
> > One way to make this convenient is introducing new directives in
> > /etc/nilfs_cleanerd.conf as follows:
> >
> >   # Scheduling priority.
> >   nice 19    # niceness -20~19
> >
> >   # IO scheduling class.
> >   # Supported classes are default, idle, best-effort, and realtime.
> >   ionice_class  idle
> >
> >   # IO scheduling priority.
> >   # 0-7 is valid for best-effort and realtime classes.
> >   ionice_data   5
> >
> > Do you think these extensions make sense ?
> 
> Yes, I think those would be really handy. It would also mean that the 
> cleanerd could be scheduled to run more aggressively but at lower 
> priority, so the clean-up would be potentially more up to date while 
> having less impact on the system performance.
> 
> Gordan

Here is a patch to add nice/ionice parameters to
/etc/nilfs_cleanerd.conf.  It is made against nilfs-utils 2.1.0-rc2.

This patch only adds two new directives: nice and ionice just to make
adjustment of these scheduling priorities easy, and does not add
extended parameters like dexen is proposing.

Details may change, but anyway, I'm planning to include this type of
enhancements in the upcoming nilfs-utils 2.1.0 release.

Thanks,
Ryusuke Konishi
--
From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

nilfs_cleanerd: add nice/ionice conf directives

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 configure.ac                      |    3 +-
 man/nilfs_cleanerd.conf.5         |   20 +++++++-
 sbin/cleanerd/cldconfig.c         |   84 +++++++++++++++++++++++++++++++++++++
 sbin/cleanerd/cldconfig.h         |   16 +++++++
 sbin/cleanerd/cleanerd.c          |   70 ++++++++++++++++++++++++++++++
 sbin/cleanerd/nilfs_cleanerd.conf |   21 ++++++++-
 6 files changed, 207 insertions(+), 7 deletions(-)

diff --git a/configure.ac b/configure.ac
index d4c2ac2..e2bca8c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -61,7 +61,8 @@ AC_HEADER_SYS_WAIT
 AC_CHECK_HEADERS([fcntl.h libintl.h limits.h locale.h mntent.h paths.h \
 		  stdlib.h string.h strings.h sys/ioctl.h sys/mount.h \
 		  sys/time.h syslog.h unistd.h linux/types.h grp.h pwd.h \
-		  mntent.h semaphore.h ctype.h mqueue.h linux/magic.h])
+		  mntent.h semaphore.h ctype.h mqueue.h linux/magic.h \
+		  sys/resource.h sys/syscall.h])
 
 # Check for conditional libraries and headers.
 if test "${enable_libmount}" = "yes"; then
diff --git a/man/nilfs_cleanerd.conf.5 b/man/nilfs_cleanerd.conf.5
index 0c19370..b7a324e 100644
--- a/man/nilfs_cleanerd.conf.5
+++ b/man/nilfs_cleanerd.conf.5
@@ -12,9 +12,9 @@ reclaims disk space of the NILFS2 filesystem.  This file specifies the
 parameters related to garbage collection (GC) and behaviour of the
 daemon program.
 .PP
-The file contains keyword argument pairs or keyword-only directives,
-one per line.  Lines starting with '#' are interpreted as comments.
-The comment lines and empty lines are ignored.
+The file contains directives one per line, each of which consists of a
+keyword and its arguments.  Lines starting with '#' are interpreted as
+comments.  The comment lines and empty lines are ignored.
 .SH PARAMETERS
 The possible keywords and their meanings are as follows (keywords and
 arguments are both case-sensitive):
@@ -79,6 +79,18 @@ Specify whether to use \fBmmap\fP(2) for reading segments.  At
 present, this option is enabled if supported regardless of this
 directive.
 .TP
+.B nice
+Specify scheduling priority of the daemon. The priority value ranges
+from -20 (most favorable scheduling) to 19 (least favorable).
+.TP
+.B ionice
+Specify io-scheduling class of the daemon.  Supported classes are:
+\fBnone\fP, \fBrealtime\fP, \fBbest-effort\fP, and \fBidle\fP.  The
+\fBrealtime\fP and \fBbest-effort\fP classes can take an optional
+priority argument.  The priority argument ranges from 0 to 7, with
+lower number being higher priority.  See \fBionice\fP(1) for the
+io-scheduling classes.
+.TP
 .B log_priority
 Gives the verbosity level that is used when logging messages from
 \fBnilfs_cleanerd\fP(8).  The possible values are: \fBemerg\fP,
@@ -95,4 +107,6 @@ interval parameters in decimal fraction format.  This applies to
 .I /etc/nilfs_cleanerd.conf
 Configuration file for \fBnilfs_cleanerd\fP(8).
 .SH SEE ALSO
+.BR nice (1),
+.BR ionice (1),
 .BR nilfs_cleanerd (8).
diff --git a/sbin/cleanerd/cldconfig.c b/sbin/cleanerd/cldconfig.c
index 4682f33..3ce6474 100644
--- a/sbin/cleanerd/cldconfig.c
+++ b/sbin/cleanerd/cldconfig.c
@@ -268,6 +268,31 @@ static int nilfs_cldconfig_get_size_argument(char **tokens, size_t ntoks,
 	return 0;
 }
 
+static int nilfs_cldconfig_get_bounded_integer(char *keyword, char *arg,
+					       long minval, long maxval,
+					       int *valp)
+{
+	long num;
+	char *endptr;
+
+	errno = 0;
+	num = strtol(arg, &endptr, 10);
+	if (*endptr != '\0') {
+		syslog(LOG_WARNING, "%s: %s: not a number", keyword, arg);
+		return -1;
+	}
+	if ((num == LONG_MIN && errno == ERANGE) || num < minval) {
+		syslog(LOG_WARNING, "%s: %s: number too small", keyword, arg);
+		return -1;
+	}
+	if ((num == LONG_MAX && errno == ERANGE) || num > maxval) {
+		syslog(LOG_WARNING, "%s: %s: number too large", keyword, arg);
+		return -1;
+	}
+	*valp = num;
+	return 0;
+}
+
 static int
 nilfs_cldconfig_handle_protection_period(struct nilfs_cldconfig *config,
 					 char **tokens, size_t ntoks,
@@ -490,6 +515,54 @@ static int nilfs_cldconfig_handle_use_mmap(struct nilfs_cldconfig *config,
 	return 0;
 }
 
+static int nilfs_cldconfig_handle_nice(struct nilfs_cldconfig *config,
+				       char **tokens, size_t ntoks,
+				       struct nilfs *nilfs)
+{
+	return nilfs_cldconfig_get_bounded_integer(
+		tokens[0], tokens[1], -20, 19, &config->cf_nice);
+}
+
+static int nilfs_cldconfig_handle_ionice(struct nilfs_cldconfig *config,
+					 char **tokens, size_t ntoks,
+					 struct nilfs *nilfs)
+{
+	static const char *prio_class[] = {
+		"none", "realtime", "best-effort", "idle", NULL
+	};
+	const char **pc;
+
+	for (pc = prio_class; *pc != NULL; pc++) {
+		if (strcmp(tokens[1], *pc) == 0) {
+			int cls = pc - prio_class;
+			int ioprio = 4;
+
+			switch (cls) {
+			case NILFS_IOPRIO_CLASS_NONE:
+				ioprio = 0;
+				break;
+			case NILFS_IOPRIO_CLASS_RT:
+			case NILFS_IOPRIO_CLASS_BE:
+				if (ntoks == 3 &&
+				    nilfs_cldconfig_get_bounded_integer(
+					    tokens[0], tokens[2], 0, 7,
+					    &ioprio) < 0)
+					return -1;
+				break;
+			case NILFS_IOPRIO_CLASS_IDLE:
+				ioprio = 7;
+				break;
+			}
+			config->cf_ionice_data = ioprio;
+			config->cf_ionice_class = cls;
+			return 0;
+		}
+	}
+	
+	syslog(LOG_WARNING, "%s: unknown class: %s", tokens[0], tokens[1]);
+	return -1;
+}
+
 static const struct nilfs_cldconfig_log_priority
 nilfs_cldconfig_log_priority_table[] = {
 	{"emerg",	LOG_EMERG},
@@ -573,6 +646,14 @@ nilfs_cldconfig_keyword_table[] = {
 		nilfs_cldconfig_handle_use_mmap
 	},
 	{
+		"nice", 2, 2,
+		nilfs_cldconfig_handle_nice
+	},
+	{
+		"ionice", 2, 3,
+		nilfs_cldconfig_handle_ionice
+	},
+	{
 		"log_priority", 2, 2,
 		nilfs_cldconfig_handle_log_priority
 	},
@@ -640,6 +721,9 @@ static void nilfs_cldconfig_set_default(struct nilfs_cldconfig *config,
 	config->cf_retry_interval.tv_sec = NILFS_CLDCONFIG_RETRY_INTERVAL;
 	config->cf_retry_interval.tv_usec = 0;
 	config->cf_use_mmap = NILFS_CLDCONFIG_USE_MMAP;
+	config->cf_nice = NILFS_CLDCONFIG_NICE;
+	config->cf_ionice_class = NILFS_CLDCONFIG_IONICE_CLASS;
+	config->cf_ionice_data = NILFS_CLDCONFIG_IONICE_DATA;
 	config->cf_log_priority = NILFS_CLDCONFIG_LOG_PRIORITY;
 }
 
diff --git a/sbin/cleanerd/cldconfig.h b/sbin/cleanerd/cldconfig.h
index 349f63e..e2c9fb4 100644
--- a/sbin/cleanerd/cldconfig.h
+++ b/sbin/cleanerd/cldconfig.h
@@ -72,6 +72,13 @@ enum nilfs_size_unit {
 	NILFS_MAX_BINARY_SUFFIX = NILFS_SIZE_UNIT_EIB,
 };
 
+enum nilfs_ioprio_class {
+	NILFS_IOPRIO_CLASS_NONE,
+	NILFS_IOPRIO_CLASS_RT,
+	NILFS_IOPRIO_CLASS_BE,
+	NILFS_IOPRIO_CLASS_IDLE,
+};
+
 /**
  * struct nilfs_cldconfig - cleanerd configuration
  * @cf_selection_policy: selection policy
@@ -87,6 +94,9 @@ enum nilfs_size_unit {
  * if clean segments < min_clean_segments
  * @cf_retry_interval: retry interval
  * @cf_use_mmap: flag that indicate using mmap
+ * @cf_nice: scheduling priority
+ * @cf_ionice_class: io scheduling class
+ * @cf_ionice_data: io scheduling priority
  * @cf_log_priority: log priority level
  */
 struct nilfs_cldconfig {
@@ -101,6 +111,9 @@ struct nilfs_cldconfig {
 	struct timeval cf_mc_cleaning_interval;
 	struct timeval cf_retry_interval;
 	int cf_use_mmap;
+	int cf_nice;
+	int cf_ionice_class;
+	int cf_ionice_data;
 	int cf_log_priority;
 };
 
@@ -119,6 +132,9 @@ struct nilfs_cldconfig {
 #define NILFS_CLDCONFIG_MC_CLEANING_INTERVAL		1
 #define NILFS_CLDCONFIG_RETRY_INTERVAL			60
 #define NILFS_CLDCONFIG_USE_MMAP			1
+#define NILFS_CLDCONFIG_NICE				0
+#define NILFS_CLDCONFIG_IONICE_CLASS			0
+#define NILFS_CLDCONFIG_IONICE_DATA			4
 #define NILFS_CLDCONFIG_LOG_PRIORITY			LOG_INFO
 
 #define NILFS_CLDCONFIG_NSEGMENTS_PER_CLEAN_MAX	32
diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
index b14bec8..2a4b442 100644
--- a/sbin/cleanerd/cleanerd.c
+++ b/sbin/cleanerd/cleanerd.c
@@ -57,6 +57,14 @@
 #include <sys/time.h>
 #endif	/* HAVE_SYS_TIME */
 
+#if HAVE_SYS_RESOURCE_H
+#include <sys/resource.h>
+#endif	/* HAVE_SYS_RESOURCE */
+
+#if HAVE_SYS_SYSCALL_H
+#include <sys/syscall.h>
+#endif	/* HAVE_SYS_SYSCALL */
+
 #if HAVE_TIME_H
 #include <time.h>
 #endif	/* HAVE_TIME_H */
@@ -222,6 +230,65 @@ static void nilfs_cleanerd_usage(const char *progname)
 		progname, progname);
 }
 
+static void nilfs_cleanerd_nice(struct nilfs_cleanerd *cleanerd)
+{
+	int prio;
+
+	errno = 0;
+	prio = getpriority(PRIO_PROCESS, 0);
+	if (errno) {
+		syslog(LOG_WARNING, "cannot get scheduling priority: %m");
+	} else if (prio == cleanerd->config.cf_nice) {
+		return;
+	}
+
+	if (setpriority(PRIO_PROCESS, 0, cleanerd->config.cf_nice) < 0) {
+		syslog(LOG_WARNING, "cannot set scheduling priority: %m");
+	} else {
+		syslog(LOG_DEBUG, "changed scheduling priority to %d",
+		       cleanerd->config.cf_nice);
+	}
+}
+
+#ifndef IOPRIO_WHO_PROCESS
+#define IOPRIO_WHO_PROCESS	1
+#endif
+
+#ifndef IOPRIO_CLASS_SHIFT
+#define IOPRIO_CLASS_SHIFT	13
+#endif
+
+static void nilfs_cleanerd_ionice(struct nilfs_cleanerd *cleanerd)
+{
+	int prio, newprio, cls;
+	pid_t pid = getpid();
+
+	newprio = cleanerd->config.cf_ionice_data |
+		cleanerd->config.cf_ionice_class << IOPRIO_CLASS_SHIFT;
+
+	prio = syscall(SYS_ioprio_get, IOPRIO_WHO_PROCESS, pid);
+	if (prio == -1) {
+		syslog(LOG_WARNING, "cannot get io-scheduling priority: %m");
+	} else {
+		cls = prio >> IOPRIO_CLASS_SHIFT;
+
+		if (prio == newprio ||
+		    (cls == cleanerd->config.cf_ionice_class &&
+		     (cls == NILFS_IOPRIO_CLASS_NONE ||
+		      cls == NILFS_IOPRIO_CLASS_IDLE)))
+			return;
+	}
+
+	if (syscall(SYS_ioprio_set, IOPRIO_WHO_PROCESS, pid, newprio) < 0) {
+		syslog(LOG_WARNING, "cannot set io-scheduling priority: %m");
+	} else {
+		syslog(LOG_DEBUG, "changed io-scheduling priority: "
+		       "class=%d, data=%d",
+		       cleanerd->config.cf_ionice_class,
+		       cleanerd->config.cf_ionice_data);
+	}
+}
+
 static void nilfs_cleanerd_set_log_priority(struct nilfs_cleanerd *cleanerd)
 {
 	setlogmask(LOG_UPTO(cleanerd->config.cf_log_priority));
@@ -244,7 +311,10 @@ static int nilfs_cleanerd_config(struct nilfs_cleanerd *cleanerd,
 	else
 		nilfs_opt_clear_mmap(cleanerd->nilfs);
 #endif	/* HAVE_MMAP */
+
 	nilfs_cleanerd_set_log_priority(cleanerd);
+	nilfs_cleanerd_nice(cleanerd);
+	nilfs_cleanerd_ionice(cleanerd);
 
 	if (protection_period != ULONG_MAX) {
 		syslog(LOG_INFO, "override protection period to %lu",
diff --git a/sbin/cleanerd/nilfs_cleanerd.conf b/sbin/cleanerd/nilfs_cleanerd.conf
index 26872aa..e1cc45c 100644
--- a/sbin/cleanerd/nilfs_cleanerd.conf
+++ b/sbin/cleanerd/nilfs_cleanerd.conf
@@ -4,9 +4,9 @@
 # started.  You can force them to be reloaded by sending a HUP signal
 # to the cleaner process.
 #
-# Each parameter is declared with a keyword-value pair or a directive
-# with no argument.  Lines beginning with "#" are ignored.  For
-# details, see the man page of nilfs_cleanerd.conf(5).
+# Each parameter is declared with a keyword and its arguments.  Lines
+# beginning with "#" are ignored.  For details, see the man page of
+# nilfs_cleanerd.conf(5).
 
 # Protection period in second.
 protection_period	3600
@@ -54,6 +54,21 @@ retry_interval		60
 # Use mmap when reading segments if supported.
 use_mmap
 
+# Scheduling priority.
+# -20 (most favorable scheduling) ~ 19 (least favorable).
+nice			0
+
+# IO scheduling class and priority.
+# Supported classes are none, realtime, best-effort, and idle.  The
+# best-effort and realtime classes can take a priority argument.
+# The priority argument ranges from 0 to 7, with lower number being
+# higher priority.
+#
+# Examples:
+# ionice	idle
+# ionice 	best-effort	5
+ionice			none
+
 # Log priority.
 # Supported priorities are emerg, alert, crit, err, warning, notice, info, and
 # debug.
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
