From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: [PATCH] nilfs2-utils: cleanerd add option to override
 protection period
Date: Tue, 23 Jun 2009 02:50:59 +0900 (JST)
Message-ID: <20090623.025059.10600535.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi,

I forgot who has proposed this feature, but I believe this would be
helpful to people who uses nilfs for the root filesystem.

This adds a new option to override protection period to the cleaner
daemon.

Since the current GC tries to preserve every block changed or created
within the protection period, users often need to adjust the
protection period to make free space when they meet a disk full
condition.  However if /etc/nilfs_cleanerd.conf is in the partition,
this action is infeasible and it gets stuck.

This option helps to avoid this stalemate by overriding the protection
period with a curtailed value and making cleanerd operable promptly.

I've pushed this into the latest git.

Regards,
Ryusuke Konishi
---
 man/nilfs_cleanerd.8     |    3 +++
 sbin/cleanerd/cleanerd.c |   34 +++++++++++++++++++++++++++++-----
 2 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/man/nilfs_cleanerd.8 b/man/nilfs_cleanerd.8
index 05857bc..30794a3 100644
--- a/man/nilfs_cleanerd.8
+++ b/man/nilfs_cleanerd.8
@@ -32,6 +32,9 @@ Display help message and exit.
 .B \-n
 invoke cleanerd without forking process. This option is intended for
 internal use from \fBmount.nilfs2\fP(8).
+.TP
+.B \-p
+Override protection period with the specified number of seconds.
 .SH SIGNALS
 .B nilfs_cleanerd
 reacts to a set of signals.  You may send a signal to
diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
index 6725041..b985a71 100644
--- a/sbin/cleanerd/cleanerd.c
+++ b/sbin/cleanerd/cleanerd.c
@@ -80,21 +80,24 @@ const static struct option long_option[] = {
 	{"help", no_argument, NULL, 'h'},
 	/* internal option for mount.nilfs2 only */
 	{"nofork", no_argument, NULL, 'n'},
+	{"protection-period", required_argument, NULL, 'p'},
 	{NULL, 0, NULL, 0}
 };
 #define NILFS_CLEANERD_OPTIONS	\
 	"  -c, --conffile\tspecify configuration file\n"	\
-	"  -h, --help    \tdisplay this help and exit\n"
+	"  -h, --help    \tdisplay this help and exit\n"	\
+	"  -p, --protection-period\tspecify protection period\n"
 #else	/* !_GNU_SOURCE */
 #define NILFS_CLEANERD_OPTIONS	\
 	"  -c            \tspecify configuration file\n"	\
-	"  -h            \tdisplay this help and exit\n"
+	"  -h            \tdisplay this help and exit\n"	\
+	"  -p,           \tspecify protection period\n"
 #endif	/* _GNU_SOURCE */
 
 static struct nilfs_cleanerd *nilfs_cleanerd;
 static sigjmp_buf nilfs_cleanerd_env;
 static volatile sig_atomic_t nilfs_cleanerd_reload_config;
-
+static volatile unsigned long protection_period;
 
 static void nilfs_cleanerd_usage(const char *progname)
 {
@@ -127,6 +130,11 @@ static int nilfs_cleanerd_config(struct nilfs_cleanerd *cleanerd)
 #endif	/* HAVE_MMAP */
 	nilfs_cleanerd_set_log_priority(cleanerd);
 
+	if (protection_period != ULONG_MAX) {
+		syslog(LOG_INFO, "override protection period to %lu",
+		       protection_period);
+		cleanerd->c_config.cf_protection_period = protection_period;
+	}
 	return 0;
 }
 
@@ -1259,6 +1267,7 @@ int main(int argc, char *argv[])
 {
 	char *progname, *conffile;
 	const char *dev, *dir;
+	char *endptr;
 	int status, nofork, c;
 #ifdef _GNU_SOURCE
 	int option_index;
@@ -1269,14 +1278,15 @@ int main(int argc, char *argv[])
 	conffile = NILFS_CLEANERD_CONFFILE;
 	nofork = 0;
 	status = 0;
+	protection_period = ULONG_MAX;
 	dev = NULL;
 	dir = NULL;
 
 #ifdef _GNU_SOURCE
-	while ((c = getopt_long(argc, argv, "c:hn",
+	while ((c = getopt_long(argc, argv, "c:hnp:",
 				long_option, &option_index)) >= 0) {
 #else	/* !_GNU_SOURCE */
-	while ((c = getopt(argc, argv, "c:hn")) >= 0) {
+	while ((c = getopt(argc, argv, "c:hnp:")) >= 0) {
 #endif	/* _GNU_SOURCE */
 
 		switch (c) {
@@ -1290,6 +1300,20 @@ int main(int argc, char *argv[])
 			/* internal option for mount.nilfs2 only */
 			nofork = 1;
 			break;
+		case 'p':
+			protection_period = strtoul(optarg, &endptr, 10);
+			if (endptr == optarg || *endptr != '\0') {
+				fprintf(stderr,
+					"%s: invalid protection period: %s\n",
+					progname, optarg);
+				exit(1);
+			} else if (protection_period == ULONG_MAX &&
+				   errno == ERANGE) {
+				fprintf(stderr, "%s: too large period: %s\n",
+					progname, optarg);
+				exit(1);
+			}
+			break;
 		default:
 			nilfs_cleanerd_usage(progname);
 			exit(1);
-- 
1.6.2
