From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 02/10] nilfs-utils: insert backslash between lines splitting quoted string
Date: Fri, 14 Feb 2014 03:24:02 +0900
Message-ID: <1392315850-29149-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1392315850-29149-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1392315850-29149-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Fix the following checkpatch warnings:

 WARNING: quoted string split across lines
 #97: FILE: lscp.c:97:
 +       printf("                 CNO        DATE     TIME  MODE  FLG     %s"
 +              "       ICNT\n",

 WARNING: quoted string split across lines
 #257: FILE: cleaner_ctl.c:257:
 +                                    _("Error: no valid nilfs mountpoint "
 +                                      "found."));

 WARNING: quoted string split across lines
 #308: FILE: cleaner_ctl.c:308:
 +                                    _("Error: cannot create receive queue: "
 +                                      "%s."),

 WARNING: quoted string split across lines
 #338: FILE: cleaner_ctl.c:338:
 +                                            _("Error: cannot open cleaner on "
 +                                              "%s: %s."),

 WARNING: quoted string split across lines
 #290: FILE: cleaner_exec.c:290:
 +       nilfs_cleaner_printf(_("cleanerd (pid=%ld) still exists on %d. "
 +                              "waiting."),

 WARNING: quoted string split across lines
 #380: FILE: cleanerd/cleanerd.c:380:
 +               syslog(LOG_ERR, "failed to create checkpoint number converter "
 +                      ": %m");

 WARNING: quoted string split across lines
 #1397: FILE: cleanerd/cleanerd.c:1397:
 +               syslog(LOG_ERR, "cannot convert protection time to checkpoint "
 +                      "number: %m");

 WARNING: quoted string split across lines
 #730: FILE: mkfs/mkfs.c:730:
 +                       perr("Error: %s is currently mounted. "
 +                            "You cannot make a filesystem on this device.",

 WARNING: quoted string split across lines
 #772: FILE: mkfs/mkfs.c:772:
 +                               pinfo("WARNING: Device %s appears to contain "
 +                                       "an existing %s superblock.",

 WARNING: quoted string split across lines
 #777: FILE: mkfs/mkfs.c:777:
 +                               pinfo("WARNING: Device %s appears to contain "
 +                                       "an partition table (%s).",

 WARNING: quoted string split across lines
 #782: FILE: mkfs/mkfs.c:782:
 +                                       pinfo("Device %s appears to contain "
 +                                               "something weird.", device);

 WARNING: quoted string split across lines
 #860: FILE: mkfs/mkfs.c:860:
 +               perr("Internal error: illegal disk buffer access "
 +                    "(blocknr=%llu)", blocknr);

 WARNING: quoted string split across lines
 #946: FILE: mkfs/mkfs.c:946:
 +                               pinfo("Discard succeeded and will return 0s "
 +                                     " - skip wiping");

 WARNING: quoted string split across lines
 #206: FILE: mount/fstab.c:206:
 +                       printf (_("mount: could not open %s - "
 +                                 "using %s instead\n"),

 WARNING: quoted string split across lines
 #434: FILE: mount/fstab.c:434:
 +               die (EX_FILEIO, _("can't create lock file %s: %s "
 +                                                 "(use -n flag to override)"),

 WARNING: quoted string split across lines
 #460: FILE: mount/fstab.c:460:
 +                       die (EX_FILEIO, _("can't link lock file %s: %s "
 +                            "(use -n flag to override)"),

 WARNING: quoted string split across lines
 #476: FILE: mount/fstab.c:476:
 +                       die (EX_FILEIO, _("can't open lock file %s: %s "
 +                            "(use -n flag to override)"),

 WARNING: quoted string split across lines
 #430: FILE: mount/mount.nilfs2.c:430:
 +               error(_("%s: the device already has a rw-mount on %s."
 +                       "\n\t\tmultiple rw-mount is not allowed."),

 WARNING: quoted string split across lines
 #446: FILE: mount/mount.nilfs2.c:446:
 +                       error(_("%s: remount failed due to %s shutdown "
 +                               "failure"), progname, NILFS_CLEANERD_NAME);

 WARNING: quoted string split across lines
 #301: FILE: mount/mount_libmount.c:301:
 +               error(_("%s: the device already has a rw-mount on %s."
 +                       "\n\t\tmultiple rw-mount is not allowed."),

 WARNING: quoted string split across lines
 #324: FILE: mount/mount_libmount.c:324:
 +                       error(_("%s: different mount point (%s). "
 +                               "remount failed."),

 WARNING: quoted string split across lines
 #334: FILE: mount/mount_libmount.c:334:
 +                               error(_("%s: remount failed due to %s "
 +                                       "shutdown failure"), progname,

 WARNING: quoted string split across lines
 #182: FILE: mount/mount_mntent.c:182:
 +                               fprintf(stderr, _("[mntent]: warning: no final "
 +                                       "newline at the end of %s\n"),

 WARNING: quoted string split across lines
 #466: FILE: nilfs-clean/nilfs-clean.c:466:
 +                               myprintf(_("Error: invalid protection period: "
 +                                          "%s\n"), optarg);

 WARNING: quoted string split across lines
 #353: FILE: nilfs-resize/nilfs-resize.c:353:
 +               myprintf("Error: the filesystem does not have enough free "
 +                        "space.\n"

 WARNING: quoted string split across lines
 #362: FILE: nilfs-resize/nilfs-resize.c:362:
 +               myprintf("%llu free segments (%llu bytes) will be left "
 +                        "after shrinkage.\n", nsegs, nbytes);

 WARNING: quoted string split across lines
 #393: FILE: nilfs-resize/nilfs-resize.c:393:
 +                       myprintf("Error: operation failed during searching "
 +                                "movable segments: %s\n", strerror(errno));

 WARNING: quoted string split across lines
 #430: FILE: nilfs-resize/nilfs-resize.c:430:
 +                       myprintf("Error: operation failed during searching "
 +                                "latest segment: %s\n", strerror(errno));

 WARNING: quoted string split across lines
 #468: FILE: nilfs-resize/nilfs-resize.c:468:
 +                       myprintf("Error: operation failed during searching "
 +                                "active segments: %s\n", strerror(errno));

 WARNING: quoted string split across lines
 #499: FILE: nilfs-resize/nilfs-resize.c:499:
 +                       myprintf("Error: operation failed during searching "
 +                                "in-use segments: %s\n", strerror(errno));

 WARNING: quoted string split across lines
 #529: FILE: nilfs-resize/nilfs-resize.c:529:
 +                       myprintf("Error: operation failed during counting "
 +                                "in-use segments: %s\n", strerror(errno));

 WARNING: quoted string split across lines
 #725: FILE: nilfs-resize/nilfs-resize.c:725:
 +                       myprintf("Error: Failed to move active segments -- "
 +                                "give up.\n");

 WARNING: quoted string split across lines
 #752: FILE: nilfs-resize/nilfs-resize.c:752:
 +               myprintf("Error: Confused. Number of segments became larger "
 +                        "than requested size.\n");

 WARNING: quoted string split across lines
 #798: FILE: nilfs-resize/nilfs-resize.c:798:
 +                       myprintf("Error: operation failed during moving "
 +                                "in-use segments: %s\n", strerror(errno));

 WARNING: quoted string split across lines
 #866: FILE: nilfs-resize/nilfs-resize.c:866:
 +               myprintf("%llu segments will be truncated from "
 +                        "segnum %llu.\n",

 WARNING: quoted string split across lines
 #873: FILE: nilfs-resize/nilfs-resize.c:873:
 +               myprintf("Error: Confused. Number of segments "
 +                        "became larger than requested size:\n"

 WARNING: quoted string split across lines
 #888: FILE: nilfs-resize/nilfs-resize.c:888:
 +                       myprintf("       This kernel does not support the "
 +                                "set allocation range API.\n");

 WARNING: quoted string split across lines
 #940: FILE: nilfs-resize/nilfs-resize.c:940:
 +                       myprintf("In-use segment found again. "
 +                                "will retry moving them.. (retry = %d)\n",

 WARNING: quoted string split across lines
 #1175: FILE: nilfs-resize/nilfs-resize.c:1175:
 +                       myprintf("Error: size larger than partition "
 +                                "size (%llu bytes).\n", devsize);

 WARNING: quoted string split across lines
 #1190: FILE: nilfs-resize/nilfs-resize.c:1190:
 +                       myprintf("size %llu is not alinged to sector "
 +                                "size. truncated to %llu.\n",

 WARNING: quoted string split across lines
 #1201: FILE: nilfs-resize/nilfs-resize.c:1201:
 +               myprintf("Error: %s is not currently mounted. Offline resising"
 +                        "\n"

 WARNING: quoted string split across lines
 #288: FILE: nilfs-tune/nilfs-tune.c:288:
 +       sprintf(buf, "%02x%02x%02x%02x-%02x%02x-%02x%02x-"
 +               "%02x%02x-%02x%02x%02x%02x%02x%02x", uuid[0], uuid[1],

 WARNING: quoted string split across lines
 #527: FILE: nilfs-tune/nilfs-tune.c:527:
 +               fprintf(stderr, "Warning: %s: unknown incompatible "
 +                       "features: 0x%llx\n", device, features);

 WARNING: quoted string split across lines
 #533: FILE: nilfs-tune/nilfs-tune.c:533:
 +               fprintf(stderr, "Warning: %s: unknown read-only compatible "
 +                       "features: 0x%llx\n", device, features);

 WARNING: quoted string split across lines
 #591: FILE: nilfs-tune/nilfs-tune.c:591:
 +               fprintf(stderr, "ERROR: %s is currently mounted.  "
 +                       "Aborting execution.\n"

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 bin/lscp.c                       |    2 +-
 lib/cleaner_ctl.c                |   12 ++++-----
 lib/cleaner_exec.c               |    2 +-
 sbin/cleanerd/cleanerd.c         |    7 ++---
 sbin/mkfs/mkfs.c                 |   22 ++++++++--------
 sbin/mount/fstab.c               |   15 ++++++-----
 sbin/mount/mount.nilfs2.c        |    4 +--
 sbin/mount/mount_libmount.c      |    6 ++---
 sbin/mount/mount_mntent.c        |    3 ++-
 sbin/nilfs-clean/nilfs-clean.c   |    4 +--
 sbin/nilfs-resize/nilfs-resize.c |   52 +++++++++++++++++++-------------------
 sbin/nilfs-tune/nilfs-tune.c     |   20 +++++++--------
 12 files changed, 76 insertions(+), 73 deletions(-)

diff --git a/bin/lscp.c b/bin/lscp.c
index c0a1b99..6ddd003 100644
--- a/bin/lscp.c
+++ b/bin/lscp.c
@@ -93,7 +93,7 @@ static int show_all = 0;
 
 static void lscp_print_header(void)
 {
-	printf("                 CNO        DATE     TIME  MODE  FLG     %s"
+	printf("                 CNO        DATE     TIME  MODE  FLG     %s" \
 	       "       ICNT\n",
 	       show_block_count ? " BLKCNT" : "NBLKINC");
 }
diff --git a/lib/cleaner_ctl.c b/lib/cleaner_ctl.c
index ae36c8b..fa41ac1 100644
--- a/lib/cleaner_ctl.c
+++ b/lib/cleaner_ctl.c
@@ -253,7 +253,7 @@ static int nilfs_cleaner_find_fs(struct nilfs_cleaner *cleaner,
 	}
 	if (nfound == 0) {
 		nilfs_cleaner_logger(LOG_ERR,
-				     _("Error: no valid nilfs mountpoint "
+				     _("Error: no valid nilfs mountpoint " \
 				       "found."));
 		goto abort;
 	}
@@ -304,7 +304,7 @@ static int nilfs_cleaner_open_queue(struct nilfs_cleaner *cleaner)
 				 &attr);
 	if (cleaner->recvq < 0) {
 		nilfs_cleaner_logger(LOG_ERR,
-				     _("Error: cannot create receive queue: "
+				     _("Error: cannot create receive queue: " \
 				       "%s."),
 				     strerror(errno));
 		free(cleaner->recvq_name);
@@ -333,10 +333,10 @@ static int nilfs_cleaner_open_queue(struct nilfs_cleaner *cleaner)
 					     _("No cleaner found on %s."),
 					     cleaner->device);
 		} else {
-			nilfs_cleaner_logger(LOG_ERR,
-					     _("Error: cannot open cleaner on "
-					       "%s: %s."),
-					     cleaner->device, strerror(errno));
+			nilfs_cleaner_logger(
+				LOG_ERR,
+				_("Error: cannot open cleaner on %s: %s."),
+				cleaner->device, strerror(errno));
 		}
 		goto abort;
 	}
diff --git a/lib/cleaner_exec.c b/lib/cleaner_exec.c
index 5a5dd8f..689880e 100644
--- a/lib/cleaner_exec.c
+++ b/lib/cleaner_exec.c
@@ -286,7 +286,7 @@ static int nilfs_wait_cleanerd(const char *device, pid_t pid)
 		recalc_backoff_time(&waittime);
 	}
 
-	nilfs_cleaner_printf(_("cleanerd (pid=%ld) still exists on %d. "
+	nilfs_cleaner_printf(_("cleanerd (pid=%ld) still exists on %d. " \
 			       "waiting."),
 			     (long)pid, device);
 	nilfs_cleaner_flush();
diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
index f3f2acd..1f21f06 100644
--- a/sbin/cleanerd/cleanerd.c
+++ b/sbin/cleanerd/cleanerd.c
@@ -376,8 +376,8 @@ nilfs_cleanerd_create(const char *dev, const char *dir, const char *conffile)
 
 	cleanerd->cnoconv = nilfs_cnoconv_create(cleanerd->nilfs);
 	if (cleanerd->cnoconv == NULL) {
-		syslog(LOG_ERR, "failed to create checkpoint number converter "
-		       ": %m");
+		syslog(LOG_ERR,
+		       "failed to create checkpoint number converter: %m");
 		goto out_nilfs;
 	}
 
@@ -1393,7 +1393,8 @@ static int nilfs_cleanerd_clean_segments(struct nilfs_cleanerd *cleanerd,
 	ret = nilfs_cnoconv_time2cno(cleanerd->cnoconv, prottime,
 				     &params.protcno);
 	if (ret < 0) {
-		syslog(LOG_ERR, "cannot convert protection time to checkpoint "
+		syslog(LOG_ERR,
+		       "cannot convert protection time to checkpoint " \
 		       "number: %m");
 		goto out;
 	}
diff --git a/sbin/mkfs/mkfs.c b/sbin/mkfs/mkfs.c
index bed7818..4d6c375 100644
--- a/sbin/mkfs/mkfs.c
+++ b/sbin/mkfs/mkfs.c
@@ -726,7 +726,7 @@ static void check_mount(int fd, const char *device)
 		if (strncmp(strtok(line, " "), device, strlen(device)) == 0) {
 			fclose(fp);
 			close(fd);
-			perr("Error: %s is currently mounted. "
+			perr("Error: %s is currently mounted. " \
 			     "You cannot make a filesystem on this device.",
 			     device);
 		}
@@ -768,18 +768,18 @@ static void check_safety_of_device_overwrite(int fd, const char *device)
 
 			if (!blkid_probe_lookup_value(pr, "TYPE",
 							&type, NULL)) {
-				pinfo("WARNING: Device %s appears to contain "
-					"an existing %s superblock.",
-					device, type);
+				pinfo("WARNING: Device %s appears to contain" \
+				      " an existing %s superblock.",
+				      device, type);
 			} else if (!blkid_probe_lookup_value(pr, "PTTYPE",
 								&type, NULL)) {
-				pinfo("WARNING: Device %s appears to contain "
-					"an partition table (%s).",
-					device, type);
+				pinfo("WARNING: Device %s appears to contain" \
+				      " an partition table (%s).",
+				      device, type);
 			} else {
 				if (quiet == 0) {
-					pinfo("Device %s appears to contain "
-						"something weird.", device);
+					pinfo("Device %s appears to contain" \
+					      " something weird.", device);
 				}
 				goto end_check;
 			}
@@ -856,7 +856,7 @@ static void init_disk_buffer(long max_blocks)
 static void *map_disk_buffer(blocknr_t blocknr, int clear_flag)
 {
 	if (blocknr >= disk_buffer_size)
-		perr("Internal error: illegal disk buffer access "
+		perr("Internal error: illegal disk buffer access " \
 		     "(blocknr=%llu)", blocknr);
 
 	if (!disk_buffer[blocknr]) {
@@ -942,7 +942,7 @@ static int erase_disk(int fd, struct nilfs_disk_info *di)
 		ret = nilfs_mkfs_discard_range(fd, start, end - start);
 		if (!ret && nilfs_mkfs_discard_zeroes_data(fd)) {
 			if (verbose)
-				pinfo("Discard succeeded and will return 0s "
+				pinfo("Discard succeeded and will return 0s " \
 				      " - skip wiping");
 			goto out;
 		}
diff --git a/sbin/mount/fstab.c b/sbin/mount/fstab.c
index c17f1ee..194f000 100644
--- a/sbin/mount/fstab.c
+++ b/sbin/mount/fstab.c
@@ -202,7 +202,7 @@ read_mounttable() {
 			return;
 		}
 		if (verbose)
-			printf (_("mount: could not open %s - "
+			printf (_("mount: could not open %s - " \
 				  "using %s instead\n"),
 				_PATH_MOUNTED, _PATH_PROC_MOUNTS);
 	}
@@ -430,8 +430,8 @@ lock_mtab (void) {
 		   and we cannot create it. Read-only filesystem?
 		   Too many files open in the system?
 		   Filesystem full? */
-		die (EX_FILEIO, _("can't create lock file %s: %s "
-						  "(use -n flag to override)"),
+		die (EX_FILEIO, _("can't create lock file %s: %s " \
+				  "(use -n flag to override)"),
 			 linktargetfile, strerror (errsv));
 	}
 	close(i);
@@ -456,7 +456,7 @@ lock_mtab (void) {
 
 		if (j < 0 && errsv != EEXIST) {
 			(void) unlink(linktargetfile);
-			die (EX_FILEIO, _("can't link lock file %s: %s "
+			die (EX_FILEIO, _("can't link lock file %s: %s " \
 			     "(use -n flag to override)"),
 			     _PATH_MOUNTED_LOCK, strerror (errsv));
 		}
@@ -472,7 +472,7 @@ lock_mtab (void) {
 				continue;
 			}
 			(void) unlink(linktargetfile);
-			die (EX_FILEIO, _("can't open lock file %s: %s "
+			die (EX_FILEIO, _("can't open lock file %s: %s " \
 			     "(use -n flag to override)"),
 			     _PATH_MOUNTED_LOCK, strerror (errsv));
 		}
@@ -510,8 +510,9 @@ lock_mtab (void) {
 				nanosleep(&waittime, NULL);
 			} else {
 				(void) unlink(linktargetfile);
-				die (EX_FILEIO, _("Cannot create link %s\n"
-						  "Perhaps there is a stale lock file?\n"),
+				die (EX_FILEIO,
+				     _("Cannot create link %s\n"	\
+				       "Perhaps there is a stale lock file?\n"),
 					 _PATH_MOUNTED_LOCK);
 			}
 			close(lockfile_fd);
diff --git a/sbin/mount/mount.nilfs2.c b/sbin/mount/mount.nilfs2.c
index e1d32a2..4bc45ad 100644
--- a/sbin/mount/mount.nilfs2.c
+++ b/sbin/mount/mount.nilfs2.c
@@ -426,7 +426,7 @@ prepare_mount(struct nilfs_mount_info *mi, const struct mount_options *mo)
 
 	switch (mo->flags & (MS_RDONLY | MS_REMOUNT)) {
 	case 0: /* overlapping rw-mount */
-		error(_("%s: the device already has a rw-mount on %s."
+		error(_("%s: the device already has a rw-mount on %s." \
 			"\n\t\tmultiple rw-mount is not allowed."),
 		      progname, mc->m.mnt_dir);
 		goto failed;
@@ -442,7 +442,7 @@ prepare_mount(struct nilfs_mount_info *mi, const struct mount_options *mo)
 		pid = 0;
 		if (find_opt(mc->m.mnt_opts, gcpid_opt_fmt, &pid) >= 0 &&
 		    nilfs_shutdown_cleanerd(mi->device, (pid_t)pid) < 0) {
-			error(_("%s: remount failed due to %s shutdown "
+			error(_("%s: remount failed due to %s shutdown " \
 				"failure"), progname, NILFS_CLEANERD_NAME);
 			goto failed;
 		}
diff --git a/sbin/mount/mount_libmount.c b/sbin/mount/mount_libmount.c
index 1a579df..c7e7e25 100644
--- a/sbin/mount/mount_libmount.c
+++ b/sbin/mount/mount_libmount.c
@@ -297,7 +297,7 @@ static int nilfs_prepare_mount(struct nilfs_mount_info *mi)
 
 	switch (mi->mflags & (MS_RDONLY | MS_REMOUNT)) {
 	case 0: /* overlapping rw-mount */
-		error(_("%s: the device already has a rw-mount on %s."
+		error(_("%s: the device already has a rw-mount on %s." \
 			"\n\t\tmultiple rw-mount is not allowed."),
 		      progname, mnt_fs_get_target(fs));
 		goto failed;
@@ -320,7 +320,7 @@ static int nilfs_prepare_mount(struct nilfs_mount_info *mi)
 
 		if (!mnt_fs_match_target(fs, mnt_context_get_target(cxt),
 					 mnt_table_get_cache(mtab))) {
-			error(_("%s: different mount point (%s). "
+			error(_("%s: different mount point (%s). " \
 				"remount failed."),
 			      progname, mnt_context_get_target(cxt));
 			goto failed;
@@ -330,7 +330,7 @@ static int nilfs_prepare_mount(struct nilfs_mount_info *mi)
 			res = nilfs_shutdown_cleanerd(
 				mnt_fs_get_source(fs), mi->old_attrs.gcpid);
 			if (res < 0) {
-				error(_("%s: remount failed due to %s "
+				error(_("%s: remount failed due to %s " \
 					"shutdown failure"), progname,
 				      NILFS_CLEANERD_NAME);
 				goto failed;
diff --git a/sbin/mount/mount_mntent.c b/sbin/mount/mount_mntent.c
index 459cb54..d4d02f5 100644
--- a/sbin/mount/mount_mntent.c
+++ b/sbin/mount/mount_mntent.c
@@ -178,7 +178,8 @@ my_getmntent (mntFILE *mfp) {
 			/* Missing final newline?  Otherwise extremely */
 			/* long line - assume file was corrupted */
 			if (feof(mfp->mntent_fp)) {
-				fprintf(stderr, _("[mntent]: warning: no final "
+				fprintf(stderr,
+					_("[mntent]: warning: no final " \
 					"newline at the end of %s\n"),
 					mfp->mntent_file);
 				s = index (buf, 0);
diff --git a/sbin/nilfs-clean/nilfs-clean.c b/sbin/nilfs-clean/nilfs-clean.c
index de44c11..0f011bd 100644
--- a/sbin/nilfs-clean/nilfs-clean.c
+++ b/sbin/nilfs-clean/nilfs-clean.c
@@ -462,8 +462,8 @@ static void nilfs_clean_parse_options(int argc, char *argv[])
 				myprintf(_("Error: too large period: %s\n"),
 					 optarg);
 			} else {
-				myprintf(_("Error: invalid protection period: "
-					   "%s\n"), optarg);
+				myprintf(_("Error: invalid protection " \
+					   "period: %s\n"), optarg);
 			}
 			exit(EXIT_FAILURE);
 		case 'q':
diff --git a/sbin/nilfs-resize/nilfs-resize.c b/sbin/nilfs-resize/nilfs-resize.c
index a228c29..0c5aca2 100644
--- a/sbin/nilfs-resize/nilfs-resize.c
+++ b/sbin/nilfs-resize/nilfs-resize.c
@@ -349,16 +349,16 @@ static int nilfs_resize_check_free_space(struct nilfs *nilfs, __u64 newnsegs)
 		nsegs = (sustat.ss_nsegs - newnsegs) - sustat.ss_ncleansegs
 			+ nrsvsegs;
 		nbytes  = (nsegs * blocks_per_segment) << blocksize_bits;
-		myprintf("Error: the filesystem does not have enough free "
-			 "space.\n"
-			 "       At least %llu more segments (%llu bytes) "
+		myprintf("Error: the filesystem does not have enough free " \
+			 "space.\n" \
+			 "       At least %llu more segments (%llu bytes) " \
 			 "are required.\n", nsegs, nbytes);
 		return -1;
 	} else if (verbose) {
 		nsegs = sustat.ss_ncleansegs - (sustat.ss_nsegs - newnsegs)
 			- nrsvsegs;
 		nbytes  = (nsegs * blocks_per_segment) << blocksize_bits;
-		myprintf("%llu free segments (%llu bytes) will be left "
+		myprintf("%llu free segments (%llu bytes) will be left " \
 			 "after shrinkage.\n", nsegs, nbytes);
 	}
 	return 0;
@@ -389,7 +389,7 @@ nilfs_resize_find_movable_segments(struct nilfs *nilfs, __u64 start,
 		count = min_t(unsigned long, rest, NILFS_RESIZE_NSUINFO);
 		nsi = nilfs_get_suinfo(nilfs, segnum, suinfo, count);
 		if (nsi < 0) {
-			myprintf("Error: operation failed during searching "
+			myprintf("Error: operation failed during searching " \
 				 "movable segments: %s\n", strerror(errno));
 			return -1;
 		}
@@ -426,7 +426,7 @@ nilfs_resize_get_latest_segment(struct nilfs *nilfs, __u64 start, __u64 end,
 			      NILFS_RESIZE_NSUINFO);
 		nsi = nilfs_get_suinfo(nilfs, segnum, suinfo, count);
 		if (nsi < 0) {
-			myprintf("Error: operation failed during searching "
+			myprintf("Error: operation failed during searching " \
 				 "latest segment: %s\n", strerror(errno));
 			return -1;
 		}
@@ -464,7 +464,7 @@ nilfs_resize_find_active_segments(struct nilfs *nilfs, __u64 start, __u64 end,
 		count = min_t(unsigned long, rest, NILFS_RESIZE_NSUINFO);
 		nsi = nilfs_get_suinfo(nilfs, segnum, suinfo, count);
 		if (nsi < 0) {
-			myprintf("Error: operation failed during searching "
+			myprintf("Error: operation failed during searching " \
 				 "active segments: %s\n", strerror(errno));
 			return -1;
 		}
@@ -495,7 +495,7 @@ nilfs_resize_find_inuse_segments(struct nilfs *nilfs, __u64 start, __u64 end,
 		count = min_t(unsigned long, rest, NILFS_RESIZE_NSUINFO);
 		nsi = nilfs_get_suinfo(nilfs, segnum, suinfo, count);
 		if (nsi < 0) {
-			myprintf("Error: operation failed during searching "
+			myprintf("Error: operation failed during searching " \
 				 "in-use segments: %s\n", strerror(errno));
 			return -1;
 		}
@@ -525,7 +525,7 @@ nilfs_resize_count_inuse_segments(struct nilfs *nilfs, __u64 start, __u64 end)
 		count = min_t(unsigned long, rest, NILFS_RESIZE_NSUINFO);
 		nsi = nilfs_get_suinfo(nilfs, segnum, suinfo, count);
 		if (nsi < 0) {
-			myprintf("Error: operation failed during counting "
+			myprintf("Error: operation failed during counting " \
 				 "in-use segments: %s\n", strerror(errno));
 			return -1;
 		}
@@ -721,12 +721,12 @@ static int nilfs_resize_move_out_active_segments(struct nilfs *nilfs,
 			break;
 
 		if (retrycnt >= 6) {
-			myprintf("Error: Failed to move active segments -- "
+			myprintf("Error: Failed to move active segments -- " \
 				 "give up.\n");
 			return -1;
 		}
 		if (verbose && !retrycnt) {
-			myprintf("Active segments are found in the range.\n"
+			myprintf("Active segments are found in the range.\n" \
 				 "Trying to move them.\n");
 		}
 		if (nilfs_resize_reclaim_nibble(
@@ -748,7 +748,7 @@ static int nilfs_resize_reclaim_range(struct nilfs *nilfs, __u64 newnsegs)
 		return -1;
 
 	if (newnsegs > sustat.ss_nsegs) {
-		myprintf("Error: Confused. Number of segments became larger "
+		myprintf("Error: Confused. Number of segments became larger " \
 			 "than requested size.\n");
 		return -1;
 	}
@@ -794,7 +794,7 @@ static int nilfs_resize_reclaim_range(struct nilfs *nilfs, __u64 newnsegs)
 		nmoved = nilfs_resize_move_segments(
 			nilfs, segnums, nfound, &reason);
 		if (nmoved < 0) {
-			myprintf("Error: operation failed during moving "
+			myprintf("Error: operation failed during moving " \
 				 "in-use segments: %s\n", strerror(errno));
 			goto out;
 		}
@@ -854,7 +854,7 @@ static int nilfs_shrink_online(struct nilfs *nilfs, const char *device,
 	newsb2off = NILFS_SB2_OFFSET_BYTES(newsize);
 	newnsegs = (newsb2off >> blocksize_bits) / blocks_per_segment;
 
-	myprintf("Partition size = %llu bytes.\n"
+	myprintf("Partition size = %llu bytes.\n" \
 		 "Shrink the filesystem size from %llu bytes to %llu bytes.\n",
 		 devsize, fs_devsize, newsize);
 
@@ -862,15 +862,15 @@ static int nilfs_shrink_online(struct nilfs *nilfs, const char *device,
 		goto out;
 
 	if (newnsegs < sustat.ss_nsegs) {
-		myprintf("%llu segments will be truncated from "
+		myprintf("%llu segments will be truncated from " \
 			 "segnum %llu.\n",
 			 (unsigned long long)sustat.ss_nsegs - newnsegs,
 			 (unsigned long long)newnsegs);
 	} else if (newnsegs == sustat.ss_nsegs) {
 		myprintf("No segments will be truncated.\n");
 	} else {
-		myprintf("Error: Confused. Number of segments "
-			 "became larger than requested size:\n"
+		myprintf("Error: Confused. Number of segments " \
+			 "became larger than requested size:\n" \
 			 "  old-nsegs=%llu new-nsegs=%llu\n",
 			 (unsigned long long)sustat.ss_nsegs,
 			 (unsigned long long)newnsegs);
@@ -884,7 +884,7 @@ static int nilfs_shrink_online(struct nilfs *nilfs, const char *device,
 		myprintf("Error: failed to limit allocation range: %s\n",
 			 strerror(errno));
 		if (errno == ENOTTY) {
-			myprintf("       This kernel does not support the "
+			myprintf("       This kernel does not support the " \
 				 "set allocation range API.\n");
 		}
 		goto out;
@@ -936,7 +936,7 @@ static int nilfs_shrink_online(struct nilfs *nilfs, const char *device,
 			goto restore_alloc_range;
 
 		if (verbose) {
-			myprintf("In-use segment found again. "
+			myprintf("In-use segment found again. " \
 				 "will retry moving them.. (retry = %d)\n",
 				 retry + 1);
 		}
@@ -957,8 +957,8 @@ static int nilfs_extend_online(struct nilfs *nilfs, const char *device,
 	int status = EXIT_FAILURE;
 	sigset_t sigset;
 
-	myprintf("Partition size = %llu bytes.\n"
-		 "Extend the filesystem size from %llu bytes to %llu "
+	myprintf("Partition size = %llu bytes.\n" \
+		 "Extend the filesystem size from %llu bytes to %llu " \
 		 "bytes.\n", devsize, fs_devsize, newsize);
 	if (!assume_yes && nilfs_resize_prompt(newsize) < 0)
 		goto out;
@@ -998,7 +998,7 @@ static int nilfs_resize_online(const char *device, unsigned long long newsize)
 	nilfs_resize_update_super(sb);
 
 	if (newsize == fs_devsize) {
-		myprintf("No need to resize the filesystem on %s.\n"
+		myprintf("No need to resize the filesystem on %s.\n" \
 			 "It already fits the device.\n", device);
 		status = EXIT_SUCCESS;
 		goto out_unlock;
@@ -1171,7 +1171,7 @@ int main(int argc, char *argv[])
 			goto out;
 		}
 		if (size > devsize) {
-			myprintf("Error: size larger than partition "
+			myprintf("Error: size larger than partition " \
 				 "size (%llu bytes).\n", devsize);
 			goto out;
 		}
@@ -1186,7 +1186,7 @@ int main(int argc, char *argv[])
 			unsigned long long size2;
 
 			size2 = size & ~(sector_size - 1);
-			myprintf("size %llu is not alinged to sector "
+			myprintf("size %llu is not alinged to sector " \
 				 "size. truncated to %llu.\n",
 				 size, size2);
 			size = size2;
@@ -1197,8 +1197,8 @@ int main(int argc, char *argv[])
 
 
 	if (check_mount(device) == 0) {
-		myprintf("Error: %s is not currently mounted. Offline resising"
-			 "\n"
+		myprintf("Error: %s is not currently mounted. Offline " \
+			 "resizing\n" \
 			 "       is not supported at present.\n", device);
 		goto out;
 	} else {
diff --git a/sbin/nilfs-tune/nilfs-tune.c b/sbin/nilfs-tune/nilfs-tune.c
index e651d2c..60f1d39 100644
--- a/sbin/nilfs-tune/nilfs-tune.c
+++ b/sbin/nilfs-tune/nilfs-tune.c
@@ -77,8 +77,8 @@ struct nilfs_tune_options {
 
 static void nilfs_tune_usage(void)
 {
-	printf("Usage: nilfs-tune [-h] [-l] [-i interval] [-L volume_name]\n"
-	       "                  [-m block_max] [-O [^]feature[,...]]\n"
+	printf("Usage: nilfs-tune [-h] [-l] [-i interval] [-L volume_name]\n" \
+	       "                  [-m block_max] [-O [^]feature[,...]]\n" \
 	       "                  [-U UUID] device\n");
 }
 
@@ -284,7 +284,7 @@ static const char *uuid_string(const unsigned char *uuid)
 {
 	static char buf[256];
 
-	sprintf(buf, "%02x%02x%02x%02x-%02x%02x-%02x%02x-"
+	sprintf(buf, "%02x%02x%02x%02x-%02x%02x-%02x%02x-" \
 		"%02x%02x-%02x%02x%02x%02x%02x%02x", uuid[0], uuid[1],
 		uuid[2], uuid[3], uuid[4], uuid[5], uuid[6], uuid[7],
 		uuid[8], uuid[9], uuid[10], uuid[11], uuid[12],
@@ -523,13 +523,13 @@ static int modify_nilfs(const char *device, struct nilfs_tune_options *opts)
 
 	features = le64_to_cpu(sbp->s_feature_incompat);
 	if (features & ~NILFS_FEATURE_INCOMPAT_SUPP)
-		fprintf(stderr, "Warning: %s: unknown incompatible "
+		fprintf(stderr, "Warning: %s: unknown incompatible " \
 			"features: 0x%llx\n", device, features);
 
 	features = le64_to_cpu(sbp->s_feature_compat_ro);
 	if (opts->flags == O_RDWR &&
 	    (features & ~NILFS_FEATURE_COMPAT_RO_SUPP))
-		fprintf(stderr, "Warning: %s: unknown read-only compatible "
+		fprintf(stderr, "Warning: %s: unknown read-only compatible " \
 			"features: 0x%llx\n", device, features);
 
 	if (opts->mask & NILFS_SB_LABEL)
@@ -587,11 +587,11 @@ int main(int argc, char *argv[])
 	}
 
 	if (!opts.force && opts.flags == O_RDWR && (check_mount(device) < 0)) {
-		fprintf(stderr, "ERROR: %s is currently mounted.  "
-			"Aborting execution.\n"
-			"Running nilfs-tune on a mounted file system "
-			"may cause SEVERE damage.\n"
-			"You can use the \"-f\" option to force this "
+		fprintf(stderr, "ERROR: %s is currently mounted.  "	\
+			"Aborting execution.\n"				\
+			"Running nilfs-tune on a mounted file system "	\
+			"may cause SEVERE damage.\n"			\
+			"You can use the \"-f\" option to force this "	\
 			"operation.\n",
 			device);
 		exit(EXIT_SUCCESS);
-- 
1.7.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
