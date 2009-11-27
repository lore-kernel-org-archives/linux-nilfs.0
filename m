From: David Smid <david-0RIiUExYzkzCfDggNXIi3w@public.gmane.org>
Subject: pp (protection period) mount option
Date: Fri, 27 Nov 2009 15:21:06 +0100
Message-ID: <4B0FE052.70307@unity-linux.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070908080900010200080706"
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

This is a multi-part message in MIME format.
--------------070908080900010200080706
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit

Hi,

I have two nilfs2 partitions and want to set different protection period for
each of them. I know nilfs_cleanerd has an option -p which allows to override
the protection period but using it would require to mount both partitions and
launch their cleaner daemons manually or within a script.
Since I want to use fstab I had to implement this option as a mount.nilfs2 extra
option.

Not much was done to the kernel module: it just had to accept 'pp=' as a valid
mount option.
mount.nilfs2 was modified to parse this option and its value and to pass it to
nilfs_cleanerd command line.

See the patches.


Regards,

David Smid

--------------070908080900010200080706
Content-Type: text/x-patch;
 name="nilfs-2.0.18_mount_pp_opt.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nilfs-2.0.18_mount_pp_opt.patch"

--- fs/super.c.mount_p_opt	2009-11-22 05:03:04.000000000 +0100
+++ fs/super.c	2009-11-26 16:38:26.000000000 +0100
@@ -650,7 +650,8 @@
 enum {
 	Opt_err_cont, Opt_err_panic, Opt_err_ro,
 	Opt_barrier, Opt_snapshot, Opt_order,
-	Opt_err,
+	Opt_protperiod,
+	Opt_err, 
 };
 
 static match_table_t tokens = {
@@ -660,6 +661,7 @@
 	{Opt_barrier, "barrier=%s"},
 	{Opt_snapshot, "cp=%u"},
 	{Opt_order, "order=%s"},
+	{Opt_protperiod, "pp=%s"},
 	{Opt_err, NULL}
 };
 
@@ -728,6 +730,10 @@
 			sbi->s_snapshot_cno = option;
 			nilfs_set_opt(sbi, SNAPSHOT);
 			break;
+		case Opt_protperiod:
+			if (match_int(&args[0], &option) || option <= 0)
+				return 0;
+			break;
 		default:
 			printk(KERN_ERR
 			       "NILFS: Unrecognized mount option \"%s\"\n", p);

--------------070908080900010200080706
Content-Type: text/x-patch;
 name="nilfs-utils-2.0.14_mount_pp_opt.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nilfs-utils-2.0.14_mount_pp_opt.patch"

--- sbin/mount/mount.nilfs2.h.mount_p_opt	2009-11-26 08:04:17.000000000 +0100
+++ sbin/mount/mount.nilfs2.h	2009-11-26 17:23:13.000000000 +0100
@@ -13,6 +13,7 @@
 #define NILFS2_FS_NAME		"nilfs2"
 #define CLEANERD_NAME		"nilfs_cleanerd"
 #define PIDOPT_NAME		"gcpid"
+#define PPOPT_NAME		"pp"
 
 #define CLEANERD_WAIT_RETRY_COUNT	3
 #define CLEANERD_WAIT_RETRY_INTERVAL	2  /* in seconds */
--- sbin/mount/mount.nilfs2.c.mount_p_opt	2009-07-19 16:53:00.000000000 +0200
+++ sbin/mount/mount.nilfs2.c	2009-11-26 17:36:08.000000000 +0100
@@ -71,6 +71,10 @@
 const char gcpid_opt_fmt[] = PIDOPT_NAME "=%d";
 typedef int gcpid_opt_t;
 
+const char pp_opt_fmt[] = PPOPT_NAME "=%d";
+const char pp_val_fmt[] = "%d";
+typedef int pp_opt_t;
+
 struct mount_options {
 	char *fstype;
 	char *opts;
@@ -408,6 +412,9 @@
 do_mount_one(struct nilfs_mount_info *mi, const struct mount_options *mo)
 {
 	int res, errsv;
+	int ppval;
+	char ppstrval[20];
+	char *pp;
 
 	res = mount(mi->device, mi->mntdir, fstype, mo->flags & ~MS_NOSYS,
 		    mo->extra_opts);
@@ -429,7 +436,13 @@
 		goto out;
 	if (check_mtab()) {
 		/* Restarting cleaner daemon */
-		if (start_cleanerd(mi->device, mi->mntdir, &mi->gcpid) == 0) {
+		if (find_opt(mo->extra_opts, pp_opt_fmt, &ppval) >= 0) {
+			snprintf(ppstrval, 19, pp_opt_fmt, ppval);
+			pp = ppstrval;
+		}
+		else
+			pp = NULL;
+		if (start_cleanerd(mi->device, mi->mntdir, pp, &mi->gcpid) == 0) {
 			if (verbose)
 				printf(_("%s: restarted %s\n"),
 				       progname, CLEANERD_NAME);
@@ -452,6 +465,9 @@
 	pid_t pid = (mi->type == RW2RW_REMOUNT) ? mi->gcpid : 0;
 	char *exopts;
 	int rungc;
+	int ppval;
+	char ppstrval[20];
+	char *pp;
 
 	rungc = !(mo->flags & MS_RDONLY) && !(mo->flags & MS_BIND) &&
 		(mi->type != RW2RW_REMOUNT || mi->gcpid == 0);
@@ -461,7 +477,14 @@
 		return;
 	}
 	if (rungc) {
-		if (start_cleanerd(mi->device, mi->mntdir, &pid) < 0)
+		if (find_opt(mo->extra_opts, pp_opt_fmt, &ppval) >= 0) {
+			snprintf(ppstrval, 19, pp_val_fmt, ppval);
+			pp = ppstrval;
+		}
+		else
+			pp = NULL;
+
+		if (start_cleanerd(mi->device, mi->mntdir, pp, &pid) < 0)
 			error(_("%s aborted"), CLEANERD_NAME);
 		else if (verbose)
 			printf(_("%s: started %s\n"), progname, CLEANERD_NAME);
@@ -470,7 +493,6 @@
 	exopts = fix_extra_opts_string(mo->extra_opts, pid);
 	mi->optstr = fix_opts_string(((mo->flags & ~MS_NOMTAB) | MS_NETDEV),
 				     exopts, NULL);
-		
 	update_mtab_entry(mi->device, mi->mntdir, fstype, mi->optstr, 0, 0,
 			  !mi->mounted);
 	my_free(exopts);
--- sbin/mount/umount.nilfs2.c.mount_p_opt	2009-07-19 16:53:00.000000000 +0200
+++ sbin/mount/umount.nilfs2.c	2009-11-26 17:39:03.000000000 +0100
@@ -69,6 +69,10 @@
 const char gcpid_opt_fmt[] = PIDOPT_NAME "=%d";
 typedef int gcpid_opt_t;
 
+const char pp_opt_fmt[] = PPOPT_NAME "=%d";
+const char pp_val_fmt[] = "%d";
+typedef int pp_opt_t;
+
 struct umount_options {
 	int flags;
 	int force;
@@ -317,6 +321,9 @@
 	int res, alive = 0;
 	const char *loopdev;
 	pid_t pid;
+	int ppval;
+	char ppstrval[20];
+	char *pp;
 
 	if (streq (node, "/") || streq (node, "root"))
 		nomtab++;
@@ -349,7 +356,14 @@
 				      progname, spec);
 			}
 		} else if (alive && !check_cleanerd(spec, pid)) {
-			if (start_cleanerd(spec, node, &pid) == 0) {
+			if (find_opt(mc->m.mnt_opts, pp_opt_fmt, &ppval) >= 0) {
+				snprintf(ppstrval, 19, pp_val_fmt, ppval);
+				pp = ppstrval;
+			}
+			else
+				pp = NULL;
+
+			if (start_cleanerd(spec, node, pp, &pid) == 0) {
 				if (verbose)
 					printf(_("%s: restarted %s(pid=%d)\n"),
 					       progname, CLEANERD_NAME,
--- sbin/mount/cleaner_ctl.c.mount_p_opt	2009-07-19 16:53:00.000000000 +0200
+++ sbin/mount/cleaner_ctl.c	2009-11-26 08:03:35.000000000 +0100
@@ -45,6 +45,7 @@
 
 const char cleanerd[] = "/sbin/" CLEANERD_NAME;
 const char cleanerd_nofork_opt[] = "-n";
+const char cleanerd_protperiod_opt[] = "-p";
 
 extern char *progname;
 
@@ -54,7 +55,7 @@
 	return (kill(pid, 0) == 0);
 }
 
-int start_cleanerd(const char *device, const char *mntdir, pid_t *ppid)
+int start_cleanerd(const char *device, const char *mntdir, const char *protperiod, pid_t *ppid)
 {
 	const char *dargs[5];
 	struct stat statbuf;
@@ -80,6 +81,10 @@
 		}
 		dargs[i++] = cleanerd;
 		dargs[i++] = cleanerd_nofork_opt;
+		if (protperiod != NULL && strlen(protperiod) > 0) {
+			dargs[i++] = cleanerd_protperiod_opt;
+			dargs[i++] = protperiod;
+		}
 		dargs[i++] = device;
 		dargs[i++] = mntdir;
 		dargs[i] = NULL;
--- sbin/mount/mount.nilfs2.h.mount_p_opt	2009-11-26 17:41:12.000000000 +0100
+++ sbin/mount/mount.nilfs2.h	2009-11-26 17:43:47.000000000 +0100
@@ -19,7 +19,7 @@
 #define CLEANERD_WAIT_RETRY_INTERVAL	2  /* in seconds */
 
 
-extern int start_cleanerd(const char *, const char *, pid_t *);
+extern int start_cleanerd(const char *, const char *, const char *, pid_t *);
 extern int stop_cleanerd(const char *, pid_t);
 extern int check_cleanerd(const char *, pid_t);
 

--------------070908080900010200080706
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--------------070908080900010200080706--
