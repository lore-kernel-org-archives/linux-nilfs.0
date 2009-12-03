From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: pp (protection period) mount option
Date: Fri, 04 Dec 2009 02:22:52 +0900 (JST)
Message-ID: <20091204.022252.102285051.ryusuke@osrg.net>
References: <20091202.004422.69931110.ryusuke@osrg.net>
	<20091202.010205.38314732.ryusuke@osrg.net>
	<4B16A1CA.9050608@unity-linux.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <4B16A1CA.9050608-0RIiUExYzkzCfDggNXIi3w@public.gmane.org>
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
To: david-0RIiUExYzkzCfDggNXIi3w@public.gmane.org
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi,
On Wed, 02 Dec 2009 18:20:10 +0100, David Smid <david-0RIiUExYzkzCfDggNXIi3w@public.gmane.org> wrote:
> Ryusuke Konishi napsal(a):
> > On Wed, 02 Dec 2009 00:44:22 +0900 (JST), Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:
> >> Hi,
> >> On Sat, 28 Nov 2009 22:16:31 +0100, David Smid <david-0RIiUExYzkzCfDggNXIi3w@public.gmane.org>
> >> wrote:
> >>> Thanks you for your valuable comments.
> >>>
> >>> You are right, of course. No kernel code changes are needed.
> >>> Here is my take #2.
> >>>
> >>> David
> >> Thank you, David.  I reviewed the patch in detail, and no worrisome
> >> point found.
> >>
> >> During tests, I noticed that remount doesn't work for this option:
> >>
> >>   For instance, after doing
> >>   # mount -t nilfs2 -o pp=600 /dev/sdb1 /test
> >>   # mount -t nilfs2 -o remount,pp=400 /dev/sdb1 /test
> > 
> > Ryusuke
> 
> Good point, remount should definitely work because it is quite useful to change
> pp on the fly.
> 
> This patch should work.
> 
> David

Thank you for revising the patch.  I reviewed the code anew.

I will comment inline.

> --- sbin/mount/mount.nilfs2.h.mount_pp_opt	2009-07-19 16:53:00.000000000 +0200
> +++ sbin/mount/mount.nilfs2.h	2009-12-02 10:27:26.000000000 +0100
> @@ -13,12 +13,13 @@
>  #define NILFS2_FS_NAME		"nilfs2"
>  #define CLEANERD_NAME		"nilfs_cleanerd"
>  #define PIDOPT_NAME		"gcpid"
> +#define PPOPT_NAME		"pp"
> 
>  #define CLEANERD_WAIT_RETRY_COUNT	3
>  #define CLEANERD_WAIT_RETRY_INTERVAL	2  /* in seconds */
> 
> 
> -extern int start_cleanerd(const char *, const char *, pid_t *);
> +extern int start_cleanerd(const char *, const char *, unsigned long, pid_t *);
>  extern int stop_cleanerd(const char *, pid_t);
>  extern int check_cleanerd(const char *, pid_t);
> 
> --- sbin/mount/cleaner_ctl.c.mount_pp_opt	2009-07-19 16:53:00.000000000 +0200
> +++ sbin/mount/cleaner_ctl.c	2009-12-02 18:16:16.000000000 +0100
> @@ -45,6 +45,7 @@
> 
>  const char cleanerd[] = "/sbin/" CLEANERD_NAME;
>  const char cleanerd_nofork_opt[] = "-n";
> +const char cleanerd_protperiod_opt[] = "-p";
> 
>  extern char *progname;
> 
> @@ -54,12 +55,14 @@
>  	return (kill(pid, 0) == 0);
>  }
> 
> -int start_cleanerd(const char *device, const char *mntdir, pid_t *ppid)
> +int start_cleanerd(const char *device, const char *mntdir,
> +		   unsigned long protperiod, pid_t *ppid)
>  {
> -	const char *dargs[5];
> +	const char *dargs[7];
>  	struct stat statbuf;
>  	int i = 0;
>  	int res;
> +	char buf[256];
> 
>  	if (stat(cleanerd, &statbuf) != 0) {
>  		error(_("Warning: %s not found"), CLEANERD_NAME);
> @@ -80,6 +83,11 @@
>  		}
>  		dargs[i++] = cleanerd;
>  		dargs[i++] = cleanerd_nofork_opt;
> +		if (protperiod != ULONG_MAX) {
> +			dargs[i++] = cleanerd_protperiod_opt;
> +			snprintf(buf, sizeof(buf), "%lu", protperiod);
> +			dargs[i++] = buf;
> +		}
>  		dargs[i++] = device;
>  		dargs[i++] = mntdir;
>  		dargs[i] = NULL;
> --- sbin/mount/umount.nilfs2.c.mount_pp_opt	2009-07-19 16:53:00.000000000 +0200
> +++ sbin/mount/umount.nilfs2.c	2009-12-02 18:15:37.000000000 +0100
> @@ -69,6 +69,9 @@
>  const char gcpid_opt_fmt[] = PIDOPT_NAME "=%d";
>  typedef int gcpid_opt_t;
> 
> +const char pp_opt_fmt[] = PPOPT_NAME "=%lu";
> +typedef unsigned long pp_opt_t;
> +
>  struct umount_options {
>  	int flags;
>  	int force;
> @@ -317,6 +320,7 @@
>  	int res, alive = 0;
>  	const char *loopdev;
>  	pid_t pid;
> +	pp_opt_t prot_period;
> 
>  	if (streq (node, "/") || streq (node, "root"))
>  		nomtab++;
> @@ -349,7 +353,11 @@
>  				      progname, spec);
>  			}
>  		} else if (alive && !check_cleanerd(spec, pid)) {
> -			if (start_cleanerd(spec, node, &pid) == 0) {
> +			if (find_opt(mc->m.mnt_opts, pp_opt_fmt, &prot_period)
> +			    < 0)
> +				prot_period = ULONG_MAX;
> +
> +			if (start_cleanerd(spec, node, prot_period, &pid) == 0) {
>  				if (verbose)
>  					printf(_("%s: restarted %s(pid=%d)\n"),
>  					       progname, CLEANERD_NAME,
> --- sbin/mount/mount.nilfs2.c.mount_pp_opt	2009-07-19 16:53:00.000000000 +0200
> +++ sbin/mount/mount.nilfs2.c	2009-12-02 18:14:50.000000000 +0100
> @@ -71,6 +71,9 @@
>  const char gcpid_opt_fmt[] = PIDOPT_NAME "=%d";
>  typedef int gcpid_opt_t;
> 
> +const char pp_opt_fmt[] = PPOPT_NAME "=%lu";
> +typedef unsigned long pp_opt_t;
> +
>  struct mount_options {
>  	char *fstype;
>  	char *opts;
> @@ -225,16 +228,43 @@
>  	*opts = newopts;
>  }
> 
> -static char *fix_extra_opts_string(const char *extra_opts, pid_t gcpid)
> +static void update_pp_opt(char **opts, pp_opt_t protection_period)
> +{
> +	char buf[256], *newopts;
> +	pp_opt_t oldpp;
> +
> +	*buf = 0;
> +	if (protection_period != ULONG_MAX) {
> +		snprintf(buf, sizeof(buf), pp_opt_fmt, protection_period);
> +	}

In case of the kernel code, these braces (i.e '{' and '}') are removed
because it's a single statement.  (for your information.  This is not
important.)

> +	newopts = change_opt(*opts, pp_opt_fmt, &oldpp, buf);
> +	my_free(*opts);
> +	*opts = newopts;
> +}
> +
> +static char *fix_extra_opts_string(const char *extra_opts, pid_t gcpid,
> +				   pp_opt_t protection_period)
>  {
>  	char buf[256];
>  	gcpid_opt_t id;
> +	pp_opt_t pp;
> +	char *tmpres;
> +	char *res;
> 
>  	buf[0] = '\0';
>  	if (gcpid)
>  		snprintf(buf, sizeof(buf), gcpid_opt_fmt, (int)gcpid);
>  	/* The gcpid option will be removed if gcpid == 0 */
> -	return change_opt(extra_opts, gcpid_opt_fmt, &id, buf);
> +	tmpres = change_opt(extra_opts, gcpid_opt_fmt, &id, buf);
> +	
> +	buf[0] = '\0';
> +	if (protection_period != ULONG_MAX)
> +		snprintf(buf, sizeof(buf), pp_opt_fmt, protection_period);
> +	/* The pp option will be removed if pp == ULONG_MAX */
> +	res = change_opt(tmpres, pp_opt_fmt, &pp, buf);
> +
> +	my_free(tmpres);
> +	return res;
>  }
> 
>  /*
> @@ -312,6 +342,7 @@
>  	pid_t gcpid;
>  	int type;
>  	int mounted;
> +	pp_opt_t protperiod;
>  };
> 
>  static int check_mtab(void)
> @@ -348,6 +379,7 @@
>  {
>  	struct mntentchn *mc;
>  	gcpid_opt_t pid;
> +	pp_opt_t prot_period;
>  	int res = -1;
> 
>  	if (!(mo->flags & MS_REMOUNT) && mounted(NULL, mi->mntdir)) {
> @@ -359,6 +391,9 @@
>  	mi->gcpid = 0;
>  	mi->optstr = NULL;
>  	mi->mounted = mounted(mi->device, mi->mntdir);
> +	mi->protperiod = ULONG_MAX;

> +	if (find_opt(mo->extra_opts, pp_opt_fmt, &prot_period) >= 0)
> +		mi->protperiod = prot_period;

These two lines should be removed because prepare_mount() is the
function to find an existing mount and extract its options from mtab.
mo->extra_opts has new mount options.

Please see the code I add below.
 
>  	if (mo->flags & MS_BIND)
>  		return 0;
> @@ -375,15 +410,13 @@
>  		goto failed;
>  	case MS_RDONLY: /* ro-mount (a rw-mount exists) */
>  		break;
> -	case MS_REMOUNT: /* rw->rw remount */
> -		if (check_remount_dir(mc, mi->mntdir) < 0)
> -			goto failed;
> -		if (find_opt(mc->m.mnt_opts, gcpid_opt_fmt, &pid) >= 0)
> -			mi->gcpid = pid;
> -		mi->optstr = xstrdup(mc->m.mnt_opts); /* previous opts */
> -		mi->type = RW2RW_REMOUNT;
> -		break;
> -	case MS_RDONLY | MS_REMOUNT:  /* rw->ro remount */
> +	case MS_REMOUNT | MS_RDONLY: /* rw->ro remount */
> +		mi->type = RW2RO_REMOUNT;
> +		mi->protperiod = ULONG_MAX;
> +		/* fallthrough */
> +	case MS_REMOUNT:
> +		if (!(mo->flags & MS_RDONLY))
> +			mi->type = RW2RW_REMOUNT; /* rw->rw remount */			
Trailing space chars. should be removed.
>  		if (check_remount_dir(mc, mi->mntdir) < 0)
>  			goto failed;

Here, can get the existing pp value:

		prot_period = ULONG_MAX;
		if (find_opt(mc->m.mnt_opts, pp_opt_fmt, &prot_period) >= 0)
			mi->protperiod = prot_period;

This previous value is used in do_mount_one(), for example, when
remount fails and it restarts cleanerd.

>  		pid = 0;
> @@ -395,7 +428,6 @@
>  		}
>  		mi->gcpid = pid;
>  		mi->optstr = xstrdup(mc->m.mnt_opts); /* previous opts */
> -		mi->type = RW2RO_REMOUNT;
>  		break;
>  	}
> 
> @@ -408,9 +440,13 @@
>  do_mount_one(struct nilfs_mount_info *mi, const struct mount_options *mo)
>  {
>  	int res, errsv;
> +	char *exopts;
> +	pp_opt_t prot_period;
> +
> +	exopts = change_opt(mo->extra_opts, pp_opt_fmt, &prot_period, "");
> 
>  	res = mount(mi->device, mi->mntdir, fstype, mo->flags & ~MS_NOSYS,
> -		    mo->extra_opts);
> +		    exopts);
>  	if (!res)
>  		goto out;
> 
> @@ -425,15 +461,19 @@
>  		      progname, mi->device, mi->mntdir, strerror(errsv));
>  		break;
>  	}
> -	if (mi->type != RW2RO_REMOUNT)
> +	if (mi->type != RW2RO_REMOUNT && mi->type != RW2RW_REMOUNT)
>  		goto out;
> +	/* Cleaner daemon was stopped and it needs to run */
> +	/* because filesystem is still mounted */
>  	if (check_mtab()) {
>  		/* Restarting cleaner daemon */
> -		if (start_cleanerd(mi->device, mi->mntdir, &mi->gcpid) == 0) {
> +		if (start_cleanerd(mi->device, mi->mntdir, mi->protperiod,
> +				   &mi->gcpid) == 0) {
>  			if (verbose)
>  				printf(_("%s: restarted %s\n"),
>  				       progname, CLEANERD_NAME);
>  			update_gcpid_opt(&mi->optstr, mi->gcpid);
> +			update_pp_opt(&mi->optstr, mi->protperiod);

This update_pp_opt() is redundant because this is an error path and
the pp option should keep the previous value.  On the other hand,
update_gcpid_opt() is necessary since GC pid is always changed after
the restart.

>  			update_mtab_entry(mi->device, mi->mntdir, fstype,
>  					  mi->optstr, 0, 0, !mi->mounted);
>  		} else {
> @@ -443,31 +483,39 @@
>  	} else
>  		printf(_("%s not restarted\n"), CLEANERD_NAME);
>   out:
> +	my_free(exopts);
>  	return res;
>  }
> 
>  static void update_mount_state(struct nilfs_mount_info *mi,
>  			       const struct mount_options *mo)
>  {
> -	pid_t pid = (mi->type == RW2RW_REMOUNT) ? mi->gcpid : 0;
> +	pid_t pid = fake ? mi->gcpid : 0;

Right.  The old gcpid will break except for the fake mode.

>  	char *exopts;
>  	int rungc;
> 

> +	if (mo->flags & MS_RDONLY)
> +		mi->protperiod = ULONG_MAX;
> +

New pp option can be parsed here.

	if ((mo->flags & MS_RDONLY) || (mo->flags & MS_BIND) ||
	    find_opt(mo->extra_opts, pp_opt_fmt, &prot_period) < 0)
		mi->protperiod = ULONG_MAX;
	else
		mi->protperiod = prot_period;

Note that we don't invoke cleanerd for a bind mount.

>  	rungc = !(mo->flags & MS_RDONLY) && !(mo->flags & MS_BIND) &&
> -		(mi->type != RW2RW_REMOUNT || mi->gcpid == 0);
> +		(pid == 0);
>  	if (!check_mtab()) {
>  		if (rungc)
>  			printf(_("%s not started\n"), CLEANERD_NAME);
>  		return;
>  	}
>  	if (rungc) {
> -		if (start_cleanerd(mi->device, mi->mntdir, &pid) < 0)
> +		if (start_cleanerd(mi->device, mi->mntdir, mi->protperiod,
> +				   &pid) < 0)
>  			error(_("%s aborted"), CLEANERD_NAME);
>  		else if (verbose)
>  			printf(_("%s: started %s\n"), progname, CLEANERD_NAME);
> -	}
> +	} else
> +		if (!fake)
> +			pid = 0;
> +	
>  	my_free(mi->optstr);
> -	exopts = fix_extra_opts_string(mo->extra_opts, pid);
> +	exopts = fix_extra_opts_string(mo->extra_opts, pid, mi->protperiod);
>  	mi->optstr = fix_opts_string(((mo->flags & ~MS_NOMTAB) | MS_NETDEV),
>  				     exopts, NULL);
>  		
> --- man/mount.nilfs2.8.mount_pp_opt	2009-07-19 16:53:00.000000000 +0200
> +++ man/mount.nilfs2.8	2009-12-02 10:27:26.000000000 +0100
> @@ -103,6 +103,12 @@
>  remount the file system read-only, or panic and halt the system.)  The
>  default is continue.
>  .TP
> +.BR pp=\fP\fIprotection-period\fP
> +Specify the \fIprotection-period\fP for the cleaner daemon (in
> +seconds). nilfs_cleanerd never deletes recent checkpoints whose
> +elapsed time from its creation is smaller than
> +\fIprotection-period\fP.
> +.TP
>  .BR order=relaxed " / " order=strict
>  Specify order semantics for file data.  Metadata is always written to
>  follow the POSIX semantics about the order of filesystem operations.


Thanks,
Ryusuke Konishi
