From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 07/10] nilfs-utils: remove spaces between function name and open parenthesis
Date: Fri, 14 Feb 2014 03:24:07 +0900
Message-ID: <1392315850-29149-8-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

Fix the following checkpatch warnings and errors:

 WARNING: space prohibited between function name and open parenthesis '('
 #23: FILE: nls.h:23:
 +# define _(Text) gettext (Text)

 ERROR: Macros with complex values should be enclosed in parenthesis
 #23: FILE: nls.h:23:
 +# define _(Text) gettext (Text)

 WARNING: space prohibited between function name and open parenthesis '('
 #25: FILE: nls.h:25:
 +#  define N_(String) gettext_noop (String)

 ERROR: Macros with complex values should be enclosed in parenthesis
 #25: FILE: nls.h:25:
 +#  define N_(String) gettext_noop (String)

 WARNING: space prohibited between function name and open parenthesis '('
 #49: FILE: mount/fstab.c:49:
 +#define streq(s, t)    (strcmp ((s), (t)) == 0)

 WARNING: externs should be avoided in .c files
 #51: FILE: mount/fstab.c:51:
 +extern int verbose;

 WARNING: space prohibited between function name and open parenthesis '('
 #173: FILE: mount/fstab.c:173:
 +                     fnam, strerror (errsv));

 WARNING: space prohibited between function name and open parenthesis '('
 #194: FILE: mount/fstab.c:194:
 +       mfp = my_setmntent (fnam, "r");

 WARNING: space prohibited between function name and open parenthesis '('
 #198: FILE: mount/fstab.c:198:
 +               mfp = my_setmntent (fnam, "r");

 WARNING: space prohibited between function name and open parenthesis '('
 #201: FILE: mount/fstab.c:201:
 +                             _PATH_MOUNTED, strerror (errsv));

 WARNING: space prohibited between function name and open parenthesis '('
 #205: FILE: mount/fstab.c:205:
 +                       printf (_("mount: could not open %s - " \

 WARNING: space prohibited between function name and open parenthesis '('
 #222: FILE: mount/fstab.c:222:
 +       mfp = my_setmntent (fnam, "r");

 WARNING: space prohibited between function name and open parenthesis '('
 #226: FILE: mount/fstab.c:226:
 +                     _PATH_MNTTAB, strerror (errsv));

 WARNING: space prohibited between function name and open parenthesis '('
 #235: FILE: mount/fstab.c:235:
 +getmntfile (const char *name) {

 WARNING: space prohibited between function name and open parenthesis '('
 #251: FILE: mount/fstab.c:251:
 +getmntdirbackward (const char *name, struct mntentchn *mcprev) {

 WARNING: space prohibited between function name and open parenthesis '('
 #268: FILE: mount/fstab.c:268:
 +getmntdevbackward (const char *name, struct mntentchn *mcprev) {

 WARNING: space prohibited between function name and open parenthesis '('
 #298: FILE: mount/fstab.c:298:
 +getmntoptfile (const char *file) {

 WARNING: space prohibited between function name and open parenthesis '('
 #337: FILE: mount/fstab.c:337:
 +handler (int sig) {

 WARNING: space prohibited between function name and open parenthesis '('
 #342: FILE: mount/fstab.c:342:
 +setlkw_timeout (int sig) {

 WARNING: space prohibited between function name and open parenthesis '('
 #348: FILE: mount/fstab.c:348:
 +unlock_mtab (void) {

 WARNING: space prohibited between function name and open parenthesis '('
 #352: FILE: mount/fstab.c:352:
 +               unlink (_PATH_MOUNTED_LOCK);

 WARNING: space prohibited between function name and open parenthesis '('
 #399: FILE: mount/fstab.c:399:
 +lock_mtab (void) {

 WARNING: space prohibited between function name and open parenthesis '('
 #411: FILE: mount/fstab.c:411:
 +               sigfillset (&sa.sa_mask);

 WARNING: space prohibited between function name and open parenthesis '('
 #413: FILE: mount/fstab.c:413:
 +               while (sigismember (&sa.sa_mask, ++sig) != -1

 WARNING: space prohibited between function name and open parenthesis '('
 #419: FILE: mount/fstab.c:419:
 +                       sigaction (sig, &sa, (struct sigaction *) 0);

 WARNING: space prohibited between function name and open parenthesis '('
 #424: FILE: mount/fstab.c:424:
 +       sprintf(linktargetfile, MOUNTLOCK_LINKTARGET, getpid ());

 WARNING: space prohibited between function name and open parenthesis '('
 #426: FILE: mount/fstab.c:426:
 +       i = open (linktargetfile, O_WRONLY|O_CREAT, S_IRUSR|S_IWUSR);

 WARNING: space prohibited between function name and open parenthesis '('
 #433: FILE: mount/fstab.c:433:
 +               die (EX_FILEIO, _("can't create lock file %s: %s " \

 WARNING: space prohibited between function name and open parenthesis '('
 #435: FILE: mount/fstab.c:435:
 +                        linktargetfile, strerror (errsv));

 WARNING: space prohibited between function name and open parenthesis '('
 #459: FILE: mount/fstab.c:459:
 +                       die (EX_FILEIO, _("can't link lock file %s: %s " \

 WARNING: space prohibited between function name and open parenthesis '('
 #461: FILE: mount/fstab.c:461:
 +                            _PATH_MOUNTED_LOCK, strerror (errsv));

 WARNING: space prohibited between function name and open parenthesis '('
 #464: FILE: mount/fstab.c:464:
 +               lockfile_fd = open (_PATH_MOUNTED_LOCK, O_WRONLY);

 WARNING: space prohibited between function name and open parenthesis '('
 #475: FILE: mount/fstab.c:475:
 +                       die (EX_FILEIO, _("can't open lock file %s: %s " \

 WARNING: space prohibited between function name and open parenthesis '('
 #477: FILE: mount/fstab.c:477:
 +                            _PATH_MOUNTED_LOCK, strerror (errsv));

 WARNING: space prohibited between function name and open parenthesis '('
 #487: FILE: mount/fstab.c:487:
 +                       if (fcntl (lockfile_fd, F_SETLK, &flock) == -1) {

 WARNING: space prohibited between function name and open parenthesis '('
 #491: FILE: mount/fstab.c:491:
 +                                          _PATH_MOUNTED_LOCK, strerror (errsv));

 WARNING: space prohibited between function name and open parenthesis '('
 #501: FILE: mount/fstab.c:501:
 +                               if (fcntl (lockfile_fd, F_SETLKW, &flock) == -1) {

 WARNING: space prohibited between function name and open parenthesis '('
 #504: FILE: mount/fstab.c:504:
 +                                       die (EX_FILEIO, _("can't lock lock file %s: %s"),

 WARNING: space prohibited between function name and open parenthesis '('
 #506: FILE: mount/fstab.c:506:
 +                                            _("timed out") : strerror (errsv));

 WARNING: space prohibited between function name and open parenthesis '('
 #513: FILE: mount/fstab.c:513:
 +                               die (EX_FILEIO,

 WARNING: space prohibited between function name and open parenthesis '('
 #534: FILE: mount/fstab.c:534:
 +update_mtab (const char *dir, struct my_mntent *instead) {

 WARNING: space prohibited between function name and open parenthesis '('
 #554: FILE: mount/fstab.c:554:
 +               error (_("cannot open %s (%s) - mtab not updated"),

 WARNING: space prohibited between function name and open parenthesis '('
 #555: FILE: mount/fstab.c:555:
 +                      fnam, strerror (errsv));

 WARNING: space prohibited between function name and open parenthesis '('
 #600: FILE: mount/fstab.c:600:
 +       mftmp = my_setmntent (_PATH_MOUNTED_TMP, "w");

 WARNING: space prohibited between function name and open parenthesis '('
 #603: FILE: mount/fstab.c:603:
 +               error (_("cannot open %s (%s) - mtab not updated"),

 WARNING: space prohibited between function name and open parenthesis '('
 #604: FILE: mount/fstab.c:604:
 +                      _PATH_MOUNTED_TMP, strerror (errsv));

 WARNING: space prohibited between function name and open parenthesis '('
 #612: FILE: mount/fstab.c:612:
 +                       die (EX_FILEIO, _("error writing %s: %s"),

 WARNING: space prohibited between function name and open parenthesis '('
 #613: FILE: mount/fstab.c:613:
 +                            _PATH_MOUNTED_TMP, strerror (errsv));

 WARNING: space prohibited between function name and open parenthesis '('
 #631: FILE: mount/fstab.c:631:
 +                       _PATH_MOUNTED_TMP, strerror (errsv));

 WARNING: space prohibited between function name and open parenthesis '('
 #643: FILE: mount/fstab.c:643:
 +                       fprintf (stderr, _("error changing owner of %s: %s\n"),

 WARNING: space prohibited between function name and open parenthesis '('
 #649: FILE: mount/fstab.c:649:
 +       my_endmntent (mftmp);

 WARNING: space prohibited between function name and open parenthesis '('
 #652: FILE: mount/fstab.c:652:
 +       if (rename (_PATH_MOUNTED_TMP, _PATH_MOUNTED) < 0) {

 WARNING: space prohibited between function name and open parenthesis '('
 #144: FILE: mount/mount.nilfs2.c:144:
 +static void print_one (const struct my_mntent *me)

 WARNING: space prohibited between function name and open parenthesis '('
 #148: FILE: mount/mount.nilfs2.c:148:
 +       printf ("%s on %s", me->mnt_fsname, me->mnt_dir);

 WARNING: space prohibited between function name and open parenthesis '('
 #150: FILE: mount/mount.nilfs2.c:150:
 +               printf (" type %s", me->mnt_type);

 WARNING: space prohibited between function name and open parenthesis '('
 #152: FILE: mount/mount.nilfs2.c:152:
 +               printf (" (%s)", me->mnt_opts);

 WARNING: space prohibited between function name and open parenthesis '('
 #158: FILE: mount/mount.nilfs2.c:158:
 +                       printf (" [%s]", label);

 WARNING: space prohibited between function name and open parenthesis '('
 #163: FILE: mount/mount.nilfs2.c:163:
 +       printf ("\n");

 WARNING: space prohibited between function name and open parenthesis '('
 #308: FILE: mount/mount.nilfs2.c:308:
 +       mnt.mnt_fsname = canonicalize (spec);

 WARNING: space prohibited between function name and open parenthesis '('
 #309: FILE: mount/mount.nilfs2.c:309:
 +       mnt.mnt_dir = canonicalize (node);

 WARNING: space prohibited between function name and open parenthesis '('
 #318: FILE: mount/mount.nilfs2.c:318:
 +               print_one (&mnt);

 WARNING: space prohibited between function name and open parenthesis '('
 #321: FILE: mount/mount.nilfs2.c:321:
 +               update_mtab (mnt.mnt_dir, &mnt);

 WARNING: space prohibited between function name and open parenthesis '('
 #332: FILE: mount/mount.nilfs2.c:332:
 +                       if ((my_addmntent (mfp, &mnt)) == 1) {

 WARNING: space prohibited between function name and open parenthesis '('
 #112: FILE: mount/mount_mntent.c:112:
 +my_setmntent (const char *file, char *mode) {

 WARNING: space prohibited between function name and open parenthesis '('
 #126: FILE: mount/mount_mntent.c:126:
 +my_endmntent (mntFILE *mfp) {

 WARNING: space prohibited between function name and open parenthesis '('
 #137: FILE: mount/mount_mntent.c:137:
 +my_addmntent (mntFILE *mfp, struct my_mntent *mnt) {

 WARNING: space prohibited between function name and open parenthesis '('
 #141: FILE: mount/mount_mntent.c:141:
 +       if (fseek (mfp->mntent_fp, 0, SEEK_END))

 WARNING: space prohibited between function name and open parenthesis '('
 #149: FILE: mount/mount_mntent.c:149:
 +       res = fprintf (mfp->mntent_fp, "%s %s %s %s %d %d\n",

 WARNING: space prohibited between function name and open parenthesis '('
 #161: FILE: mount/mount_mntent.c:161:
 +my_getmntent (mntFILE *mfp) {

 WARNING: space prohibited between function name and open parenthesis '('
 #172: FILE: mount/mount_mntent.c:172:
 +               if (fgets (buf, sizeof(buf), mfp->mntent_fp) == NULL)

 WARNING: space prohibited between function name and open parenthesis '('
 #176: FILE: mount/mount_mntent.c:176:
 +               s = index (buf, '\n');

 WARNING: space prohibited between function name and open parenthesis '('
 #185: FILE: mount/mount_mntent.c:185:
 +                               s = index (buf, 0);

 WARNING: space prohibited between function name and open parenthesis '('
 #197: FILE: mount/mount_opts.c:197:
 +               die (EX_USAGE, _("%s: improperly quoted option string '%s'"),

 WARNING: space prohibited between function name and open parenthesis '('
 #253: FILE: mount/mount_opts.c:253:
 +               if (streq (opt, om->opt)) {

 WARNING: space prohibited between function name and open parenthesis '('
 #40: FILE: mount/sundries.c:40:
 +xstrndup (const char *s, int n) {

 WARNING: space prohibited between function name and open parenthesis '('
 #44: FILE: mount/sundries.c:44:
 +         die (EX_SOFTWARE, _("bug in xstrndup call"));

 WARNING: space prohibited between function name and open parenthesis '('
 #55: FILE: mount/sundries.c:55:
 +xstrconcat3 (char *s, const char *t, const char *u) {

 WARNING: space prohibited between function name and open parenthesis '('
 #77: FILE: mount/sundries.c:77:
 +xstrconcat4 (char *s, const char *t, const char *u, const char *v) {

 WARNING: space prohibited between function name and open parenthesis '('
 #104: FILE: mount/sundries.c:104:
 +block_signals (int how) {

 WARNING: space prohibited between function name and open parenthesis '('
 #107: FILE: mount/sundries.c:107:
 +     sigfillset (&sigs);

 WARNING: space prohibited between function name and open parenthesis '('
 #110: FILE: mount/sundries.c:110:
 +     sigprocmask (how, &sigs, (sigset_t *) 0);

 WARNING: space prohibited between function name and open parenthesis '('
 #118: FILE: mount/sundries.c:118:
 +error (const char *fmt, ...) {

 WARNING: space prohibited between function name and open parenthesis '('
 #123: FILE: mount/sundries.c:123:
 +     va_start (args, fmt);

 WARNING: space prohibited between function name and open parenthesis '('
 #124: FILE: mount/sundries.c:124:
 +     vfprintf (stderr, fmt, args);

 WARNING: space prohibited between function name and open parenthesis '('
 #125: FILE: mount/sundries.c:125:
 +     va_end (args);

 WARNING: space prohibited between function name and open parenthesis '('
 #134: FILE: mount/sundries.c:134:
 +matching_type (const char *type, const char *types) {

 WARNING: space prohibited between function name and open parenthesis '('
 #139: FILE: mount/sundries.c:139:
 +     if (streq (type, MNTTYPE_SWAP))

 WARNING: space prohibited between function name and open parenthesis '('
 #209: FILE: mount/sundries.c:209:
 +matching_opts (const char *options, const char *test_opts) {

 WARNING: space prohibited between function name and open parenthesis '('
 #220: FILE: mount/sundries.c:220:
 +          die (EX_SYSERR, _("not enough memory"));

 WARNING: space prohibited between function name and open parenthesis '('
 #244: FILE: mount/sundries.c:244:
 +canonicalize (const char *path) {

 WARNING: space prohibited between function name and open parenthesis '('
 #256: FILE: mount/sundries.c:256:
 +       if (myrealpath (path, canonical, PATH_MAX+1))

 WARNING: space prohibited between function name and open parenthesis '('
 #282: FILE: mount/umount.nilfs2.c:282:
 +                     device, strerror (errsv));

 WARNING: space prohibited between function name and open parenthesis '('
 #285: FILE: mount/umount.nilfs2.c:285:
 +       if (ioctl (fd, LOOP_CLR_FD, 0) < 0) {

 WARNING: space prohibited between function name and open parenthesis '('
 #286: FILE: mount/umount.nilfs2.c:286:
 +               perror ("ioctl: LOOP_CLR_FD");

 WARNING: space prohibited between function name and open parenthesis '('
 #289: FILE: mount/umount.nilfs2.c:289:
 +       close (fd);

 WARNING: space prohibited between function name and open parenthesis '('
 #388: FILE: mount/umount.nilfs2.c:388:
 +       if (streq (node, "/") || streq (node, "root"))

 WARNING: space prohibited between function name and open parenthesis '('
 #388: FILE: mount/umount.nilfs2.c:388:
 +       if (streq (node, "/") || streq (node, "root"))

 WARNING: space prohibited between function name and open parenthesis '('
 #462: FILE: mount/umount.nilfs2.c:462:
 +                       for (optl = strtok (optl, ","); optl;

 WARNING: space prohibited between function name and open parenthesis '('
 #463: FILE: mount/umount.nilfs2.c:463:
 +                            optl = strtok (NULL, ",")) {

 WARNING: space prohibited between function name and open parenthesis '('
 #50: FILE: mount/xmalloc.c:50:
 +xmalloc (size_t size) {

 WARNING: space prohibited between function name and open parenthesis '('
 #63: FILE: mount/xmalloc.c:63:
 +xrealloc (void *p, size_t size) {

 WARNING: space prohibited between function name and open parenthesis '('
 #73: FILE: mount/xmalloc.c:73:
 +xstrdup (const char *s) {

 WARNING: space prohibited between function name and open parenthesis '('
 #19: FILE: mount/fstab.h:19:
 +struct mntentchn *mtab_head (void);

 WARNING: space prohibited between function name and open parenthesis '('
 #20: FILE: mount/fstab.h:20:
 +struct mntentchn *getmntfile (const char *name);

 WARNING: space prohibited between function name and open parenthesis '('
 #21: FILE: mount/fstab.h:21:
 +struct mntentchn *getmntoptfile (const char *file);

 WARNING: space prohibited between function name and open parenthesis '('
 #22: FILE: mount/fstab.h:22:
 +struct mntentchn *getmntdirbackward (const char *dir, struct mntentchn *mc);

 WARNING: space prohibited between function name and open parenthesis '('
 #23: FILE: mount/fstab.h:23:
 +struct mntentchn *getmntdevbackward (const char *dev, struct mntentchn *mc);

 WARNING: space prohibited between function name and open parenthesis '('
 #25: FILE: mount/fstab.h:25:
 +struct mntentchn *fstab_head (void);

 WARNING: space prohibited between function name and open parenthesis '('
 #26: FILE: mount/fstab.h:26:
 +struct mntentchn *getfsfile (const char *file);

 WARNING: space prohibited between function name and open parenthesis '('
 #27: FILE: mount/fstab.h:27:
 +struct mntentchn *getfsspec (const char *spec);

 WARNING: space prohibited between function name and open parenthesis '('
 #28: FILE: mount/fstab.h:28:
 +struct mntentchn *getfsspecfile (const char *spec, const char *file);

 WARNING: space prohibited between function name and open parenthesis '('
 #29: FILE: mount/fstab.h:29:
 +struct mntentchn *getfsuuidspec (const char *uuid);

 WARNING: space prohibited between function name and open parenthesis '('
 #30: FILE: mount/fstab.h:30:
 +struct mntentchn *getfsvolspec (const char *label);

 WARNING: space prohibited between function name and open parenthesis '('
 #32: FILE: mount/fstab.h:32:
 +void lock_mtab (void);

 WARNING: space prohibited between function name and open parenthesis '('
 #33: FILE: mount/fstab.h:33:
 +void unlock_mtab (void);

 WARNING: space prohibited between function name and open parenthesis '('
 #34: FILE: mount/fstab.h:34:
 +void update_mtab (const char *special, struct my_mntent *with);

 WARNING: space prohibited between function name and open parenthesis '('
 #28: FILE: mount/mount_mntent.h:28:
 +mntFILE *my_setmntent (const char *file, char *mode);

 WARNING: space prohibited between function name and open parenthesis '('
 #29: FILE: mount/mount_mntent.h:29:
 +void my_endmntent (mntFILE *mfp);

 WARNING: space prohibited between function name and open parenthesis '('
 #30: FILE: mount/mount_mntent.h:30:
 +int my_addmntent (mntFILE *mfp, struct my_mntent *mnt);

 WARNING: space prohibited between function name and open parenthesis '('
 #31: FILE: mount/mount_mntent.h:31:
 +struct my_mntent *my_getmntent (mntFILE *mfp);

 WARNING: space prohibited between function name and open parenthesis '('
 #24: FILE: mount/sundries.h:24:
 +#define streq(s, t)    (strcmp ((s), (t)) == 0)

 WARNING: space prohibited between function name and open parenthesis '('
 #27: FILE: mount/sundries.h:27:
 +void block_signals (int how);

 WARNING: space prohibited between function name and open parenthesis '('
 #28: FILE: mount/sundries.h:28:
 +char *canonicalize (const char *path);

 WARNING: space prohibited between function name and open parenthesis '('
 #29: FILE: mount/sundries.h:29:
 +void error (const char *fmt, ...);

 WARNING: space prohibited between function name and open parenthesis '('
 #30: FILE: mount/sundries.h:30:
 +int matching_type (const char *type, const char *types);

 WARNING: space prohibited between function name and open parenthesis '('
 #31: FILE: mount/sundries.h:31:
 +int matching_opts (const char *options, const char *test_opts);

 WARNING: space prohibited between function name and open parenthesis '('
 #32: FILE: mount/sundries.h:32:
 +void *xmalloc (size_t size);

 WARNING: space prohibited between function name and open parenthesis '('
 #33: FILE: mount/sundries.h:33:
 +char *xstrdup (const char *s);

 WARNING: space prohibited between function name and open parenthesis '('
 #34: FILE: mount/sundries.h:34:
 +char *xstrndup (const char *s, int n);

 WARNING: space prohibited between function name and open parenthesis '('
 #35: FILE: mount/sundries.h:35:
 +char *xstrconcat3 (char *, const char *, const char *);

 WARNING: space prohibited between function name and open parenthesis '('
 #36: FILE: mount/sundries.h:36:
 +char *xstrconcat4 (char *, const char *, const char *, const char *);

 WARNING: space prohibited between function name and open parenthesis '('
 #38: FILE: mount/sundries.h:38:
 +void die (int errcode, const char *fmt, ...);

 WARNING: space prohibited between function name and open parenthesis '('
 #41: FILE: mount/sundries.h:41:
 +int nfsmount (const char *spec, const char *node, int *flags,

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 include/nls.h              |    4 +-
 sbin/mount/fstab.c         |  132 ++++++++++++++++++++++----------------------
 sbin/mount/fstab.h         |   28 +++++-----
 sbin/mount/mount.nilfs2.c  |   22 ++++----
 sbin/mount/mount_mntent.c  |   32 +++++------
 sbin/mount/mount_mntent.h  |    8 +--
 sbin/mount/mount_opts.c    |    6 +-
 sbin/mount/sundries.c      |   50 ++++++++---------
 sbin/mount/sundries.h      |   30 +++++-----
 sbin/mount/umount.nilfs2.c |   14 ++---
 sbin/mount/xmalloc.c       |   12 ++--
 11 files changed, 170 insertions(+), 168 deletions(-)

diff --git a/include/nls.h b/include/nls.h
index 0b47b7f..6ae0a02 100644
--- a/include/nls.h
+++ b/include/nls.h
@@ -20,9 +20,9 @@
 
 #if defined MAY_ENABLE_NLS && !defined DISABLE_NLS
 # include <libintl.h>
-# define _(Text) gettext (Text)
+# define _(Text) gettext(Text)
 # ifdef gettext_noop
-#  define N_(String) gettext_noop (String)
+#  define N_(String) gettext_noop(String)
 # else
 #  define N_(String) (String)
 # endif
diff --git a/sbin/mount/fstab.c b/sbin/mount/fstab.c
index b9feb7c..b0addbe 100644
--- a/sbin/mount/fstab.c
+++ b/sbin/mount/fstab.c
@@ -46,7 +46,7 @@
 #include "pathnames.h"
 #include "nls.h"
 
-#define streq(s, t)	(strcmp ((s), (t)) == 0)
+#define streq(s, t)	(strcmp((s), (t)) == 0)
 
 extern int verbose;
 
@@ -170,7 +170,7 @@ read_mntentchn(mntFILE *mfp, const char *fnam, struct mntentchn *mc0) {
 	if (ferror(mfp->mntent_fp)) {
 		int errsv = errno;
 		error(_("warning: error reading %s: %s"),
-		      fnam, strerror (errsv));
+		      fnam, strerror(errsv));
 		mc0->nxt = mc0->prev = NULL;
 	}
 	my_endmntent(mfp);
@@ -191,20 +191,20 @@ read_mounttable() {
 	mc->nxt = mc->prev = NULL;
 
 	fnam = _PATH_MOUNTED;
-	mfp = my_setmntent (fnam, "r");
+	mfp = my_setmntent(fnam, "r");
 	if (mfp == NULL || mfp->mntent_fp == NULL) {
 		int errsv = errno;
 		fnam = _PATH_PROC_MOUNTS;
-		mfp = my_setmntent (fnam, "r");
+		mfp = my_setmntent(fnam, "r");
 		if (mfp == NULL || mfp->mntent_fp == NULL) {
 			error(_("warning: can't open %s: %s"),
-			      _PATH_MOUNTED, strerror (errsv));
+			      _PATH_MOUNTED, strerror(errsv));
 			return;
 		}
 		if (verbose)
-			printf (_("mount: could not open %s - " \
-				  "using %s instead\n"),
-				_PATH_MOUNTED, _PATH_PROC_MOUNTS);
+			printf(_("mount: could not open %s - " \
+				 "using %s instead\n"),
+			       _PATH_MOUNTED, _PATH_PROC_MOUNTS);
 	}
 	read_mntentchn(mfp, fnam, mc);
 }
@@ -219,11 +219,11 @@ read_fstab() {
 	mc->nxt = mc->prev = NULL;
 
 	fnam = _PATH_MNTTAB;
-	mfp = my_setmntent (fnam, "r");
+	mfp = my_setmntent(fnam, "r");
 	if (mfp == NULL || mfp->mntent_fp == NULL) {
 		int errsv = errno;
 		error(_("warning: can't open %s: %s"),
-		      _PATH_MNTTAB, strerror (errsv));
+		      _PATH_MNTTAB, strerror(errsv));
 		return;
 	}
 	read_mntentchn(mfp, fnam, mc);
@@ -231,8 +231,8 @@ read_fstab() {
 
 
 /* Given the name NAME, try to find it in mtab.  */
-struct mntentchn *
-getmntfile (const char *name) {
+struct mntentchn *getmntfile(const char *name)
+{
 	struct mntentchn *mc, *mc0;
 
 	mc0 = mtab_head();
@@ -247,8 +247,8 @@ getmntfile (const char *name) {
  * Given the directory name NAME, and the place MCPREV we found it last time,
  * try to find more occurrences.
  */
-struct mntentchn *
-getmntdirbackward (const char *name, struct mntentchn *mcprev) {
+struct mntentchn *getmntdirbackward(const char *name, struct mntentchn *mcprev)
+{
 	struct mntentchn *mc, *mc0;
 
 	mc0 = mtab_head();
@@ -264,8 +264,8 @@ getmntdirbackward (const char *name, struct mntentchn *mcprev) {
  * Given the device name NAME, and the place MCPREV we found it last time,
  * try to find more occurrences.
  */
-struct mntentchn *
-getmntdevbackward (const char *name, struct mntentchn *mcprev) {
+struct mntentchn *getmntdevbackward(const char *name, struct mntentchn *mcprev)
+{
 	struct mntentchn *mc, *mc0;
 
 	mc0 = mtab_head();
@@ -294,8 +294,8 @@ is_mounted_once(const char *name) {
 }
 
 /* Given the name FILE, try to find the option "loop=FILE" in mtab.  */
-struct mntentchn *
-getmntoptfile (const char *file) {
+struct mntentchn *getmntoptfile(const char *file)
+{
 	struct mntentchn *mc, *mc0;
 	const char *opts, *s;
 	int l;
@@ -333,23 +333,23 @@ static int signals_have_been_setup;
 /* Ensure that the lock is released if we are interrupted.  */
 extern char *strsignal(int sig);	/* not always in <string.h> */
 
-static void
-handler (int sig) {
+static void handler(int sig)
+{
 	die(EX_USER, "%s", strsignal(sig));
 }
 
-static void
-setlkw_timeout (int sig) {
+static void setlkw_timeout(int sig)
+{
 	/* nothing, fcntl will fail anyway */
 }
 
 /* Remove lock file.  */
-void
-unlock_mtab (void) {
+void unlock_mtab(void)
+{
 	if (we_created_lockfile) {
 		close(lockfile_fd);
 		lockfile_fd = -1;
-		unlink (_PATH_MOUNTED_LOCK);
+		unlink(_PATH_MOUNTED_LOCK);
 		we_created_lockfile = 0;
 	}
 }
@@ -395,8 +395,8 @@ unlock_mtab (void) {
 /* sleep time (in microseconds, max=999999) between attempts */
 #define MOUNTLOCK_WAITTIME		5000
 
-void
-lock_mtab (void) {
+void lock_mtab(void)
+{
 	int i;
 	struct timespec waittime;
 	struct timeval maxtime;
@@ -408,31 +408,31 @@ lock_mtab (void) {
 
 		sa.sa_handler = handler;
 		sa.sa_flags = 0;
-		sigfillset (&sa.sa_mask);
+		sigfillset(&sa.sa_mask);
 
-		while (sigismember (&sa.sa_mask, ++sig) != -1
+		while (sigismember(&sa.sa_mask, ++sig) != -1
 		       && sig != SIGCHLD) {
 			if (sig == SIGALRM)
 				sa.sa_handler = setlkw_timeout;
 			else
 				sa.sa_handler = handler;
-			sigaction (sig, &sa, (struct sigaction *) 0);
+			sigaction(sig, &sa, (struct sigaction *) 0);
 		}
 		signals_have_been_setup = 1;
 	}
 
-	sprintf(linktargetfile, MOUNTLOCK_LINKTARGET, getpid ());
+	sprintf(linktargetfile, MOUNTLOCK_LINKTARGET, getpid());
 
-	i = open (linktargetfile, O_WRONLY|O_CREAT, S_IRUSR|S_IWUSR);
+	i = open(linktargetfile, O_WRONLY|O_CREAT, S_IRUSR|S_IWUSR);
 	if (i < 0) {
 		int errsv = errno;
 		/* linktargetfile does not exist (as a file)
 		   and we cannot create it. Read-only filesystem?
 		   Too many files open in the system?
 		   Filesystem full? */
-		die (EX_FILEIO, _("can't create lock file %s: %s " \
-				  "(use -n flag to override)"),
-			 linktargetfile, strerror (errsv));
+		die(EX_FILEIO, _("can't create lock file %s: %s " \
+				 "(use -n flag to override)"),
+			 linktargetfile, strerror(errsv));
 	}
 	close(i);
 
@@ -456,12 +456,12 @@ lock_mtab (void) {
 
 		if (j < 0 && errsv != EEXIST) {
 			(void) unlink(linktargetfile);
-			die (EX_FILEIO, _("can't link lock file %s: %s " \
-			     "(use -n flag to override)"),
-			     _PATH_MOUNTED_LOCK, strerror (errsv));
+			die(EX_FILEIO, _("can't link lock file %s: %s " \
+					 "(use -n flag to override)"),
+			    _PATH_MOUNTED_LOCK, strerror(errsv));
 		}
 
-		lockfile_fd = open (_PATH_MOUNTED_LOCK, O_WRONLY);
+		lockfile_fd = open(_PATH_MOUNTED_LOCK, O_WRONLY);
 
 		if (lockfile_fd < 0) {
 			/* Strange... Maybe the file was just deleted? */
@@ -472,9 +472,9 @@ lock_mtab (void) {
 				continue;
 			}
 			(void) unlink(linktargetfile);
-			die (EX_FILEIO, _("can't open lock file %s: %s " \
-			     "(use -n flag to override)"),
-			     _PATH_MOUNTED_LOCK, strerror (errsv));
+			die(EX_FILEIO, _("can't open lock file %s: %s " \
+					 "(use -n flag to override)"),
+			    _PATH_MOUNTED_LOCK, strerror(errsv));
 		}
 
 		flock.l_type = F_WRLCK;
@@ -484,11 +484,11 @@ lock_mtab (void) {
 
 		if (j == 0) {
 			/* We made the link. Now claim the lock. */
-			if (fcntl (lockfile_fd, F_SETLK, &flock) == -1) {
+			if (fcntl(lockfile_fd, F_SETLK, &flock) == -1) {
 				if (verbose) {
 				    int errsv = errno;
 				    printf(_("Can't lock lock file %s: %s\n"),
-					   _PATH_MOUNTED_LOCK, strerror (errsv));
+					   _PATH_MOUNTED_LOCK, strerror(errsv));
 				}
 				/* proceed, since it was us who created the lockfile anyway */
 			}
@@ -498,22 +498,24 @@ lock_mtab (void) {
 			gettimeofday(&now, NULL);
 			if (now.tv_sec < maxtime.tv_sec) {
 				alarm(maxtime.tv_sec - now.tv_sec);
-				if (fcntl (lockfile_fd, F_SETLKW, &flock) == -1) {
+				if (fcntl(lockfile_fd, F_SETLKW, &flock) == -1) {
 					int errsv = errno;
 					(void) unlink(linktargetfile);
-					die (EX_FILEIO, _("can't lock lock file %s: %s"),
-					     _PATH_MOUNTED_LOCK, (errno == EINTR) ?
-					     _("timed out") : strerror (errsv));
+					die(EX_FILEIO,
+					    _("can't lock lock file %s: %s"),
+					    _PATH_MOUNTED_LOCK,
+					    (errno == EINTR) ?
+					    _("timed out") : strerror(errsv));
 				}
 				alarm(0);
 
 				nanosleep(&waittime, NULL);
 			} else {
 				(void) unlink(linktargetfile);
-				die (EX_FILEIO,
-				     _("Cannot create link %s\n"	\
-				       "Perhaps there is a stale lock file?\n"),
-					 _PATH_MOUNTED_LOCK);
+				die(EX_FILEIO,
+				    _("Cannot create link %s\n"		\
+				      "Perhaps there is a stale lock file?\n"),
+				    _PATH_MOUNTED_LOCK);
 			}
 			close(lockfile_fd);
 		}
@@ -530,8 +532,8 @@ lock_mtab (void) {
  *    the values given in INSTEAD.]
  */
 
-void
-update_mtab (const char *dir, struct my_mntent *instead) {
+void update_mtab(const char *dir, struct my_mntent *instead)
+{
 	mntFILE *mfp, *mftmp;
 	const char *fnam = _PATH_MOUNTED;
 	struct mntentchn mtabhead;	/* dummy */
@@ -551,8 +553,8 @@ update_mtab (const char *dir, struct my_mntent *instead) {
 	mfp = my_setmntent(fnam, "r");
 	if (mfp == NULL || mfp->mntent_fp == NULL) {
 		int errsv = errno;
-		error (_("cannot open %s (%s) - mtab not updated"),
-		       fnam, strerror (errsv));
+		error(_("cannot open %s (%s) - mtab not updated"),
+		      fnam, strerror(errsv));
 		goto leave;
 	}
 
@@ -597,11 +599,11 @@ update_mtab (const char *dir, struct my_mntent *instead) {
 	}
 
 	/* write chain to mtemp */
-	mftmp = my_setmntent (_PATH_MOUNTED_TMP, "w");
+	mftmp = my_setmntent(_PATH_MOUNTED_TMP, "w");
 	if (mftmp == NULL || mftmp->mntent_fp == NULL) {
 		int errsv = errno;
-		error (_("cannot open %s (%s) - mtab not updated"),
-		       _PATH_MOUNTED_TMP, strerror (errsv));
+		error(_("cannot open %s (%s) - mtab not updated"),
+		      _PATH_MOUNTED_TMP, strerror(errsv));
 		discard_mntentchn(mc0);
 		goto leave;
 	}
@@ -609,8 +611,8 @@ update_mtab (const char *dir, struct my_mntent *instead) {
 	for (mc = mc0->nxt; mc && mc != mc0; mc = mc->nxt) {
 		if (my_addmntent(mftmp, &(mc->m)) == 1) {
 			int errsv = errno;
-			die (EX_FILEIO, _("error writing %s: %s"),
-			     _PATH_MOUNTED_TMP, strerror (errsv));
+			die(EX_FILEIO, _("error writing %s: %s"),
+			    _PATH_MOUNTED_TMP, strerror(errsv));
 		}
 	}
 
@@ -628,7 +630,7 @@ update_mtab (const char *dir, struct my_mntent *instead) {
 	if (fchmod(fd, S_IRUSR|S_IWUSR|S_IRGRP|S_IROTH) < 0) {
 		int errsv = errno;
 		fprintf(stderr, _("error changing mode of %s: %s\n"),
-			_PATH_MOUNTED_TMP, strerror (errsv));
+			_PATH_MOUNTED_TMP, strerror(errsv));
 		goto leave;
 	}
 
@@ -640,16 +642,16 @@ update_mtab (const char *dir, struct my_mntent *instead) {
 	if (stat(_PATH_MOUNTED, &sbuf) == 0) {
 		if (fchown(fd, sbuf.st_uid, sbuf.st_gid) < 0) {
 			int errsv = errno;
-			fprintf (stderr, _("error changing owner of %s: %s\n"),
+			fprintf(stderr, _("error changing owner of %s: %s\n"),
 				_PATH_MOUNTED_TMP, strerror(errsv));
 			goto leave;
 		}
 	}
 
-	my_endmntent (mftmp);
+	my_endmntent(mftmp);
 
 	/* rename mtemp to mtab */
-	if (rename (_PATH_MOUNTED_TMP, _PATH_MOUNTED) < 0) {
+	if (rename(_PATH_MOUNTED_TMP, _PATH_MOUNTED) < 0) {
 		int errsv = errno;
 		fprintf(stderr, _("can't rename %s to %s: %s\n"),
 			_PATH_MOUNTED_TMP, _PATH_MOUNTED, strerror(errsv));
diff --git a/sbin/mount/fstab.h b/sbin/mount/fstab.h
index 600ab4f..46a65a2 100644
--- a/sbin/mount/fstab.h
+++ b/sbin/mount/fstab.h
@@ -16,19 +16,19 @@ struct mntentchn {
 	struct my_mntent m;
 };
 
-struct mntentchn *mtab_head (void);
-struct mntentchn *getmntfile (const char *name);
-struct mntentchn *getmntoptfile (const char *file);
-struct mntentchn *getmntdirbackward (const char *dir, struct mntentchn *mc);
-struct mntentchn *getmntdevbackward (const char *dev, struct mntentchn *mc);
+struct mntentchn *mtab_head(void);
+struct mntentchn *getmntfile(const char *name);
+struct mntentchn *getmntoptfile(const char *file);
+struct mntentchn *getmntdirbackward(const char *dir, struct mntentchn *mc);
+struct mntentchn *getmntdevbackward(const char *dev, struct mntentchn *mc);
 
-struct mntentchn *fstab_head (void);
-struct mntentchn *getfsfile (const char *file);
-struct mntentchn *getfsspec (const char *spec);
-struct mntentchn *getfsspecfile (const char *spec, const char *file);
-struct mntentchn *getfsuuidspec (const char *uuid);
-struct mntentchn *getfsvolspec (const char *label);
+struct mntentchn *fstab_head(void);
+struct mntentchn *getfsfile(const char *file);
+struct mntentchn *getfsspec(const char *spec);
+struct mntentchn *getfsspecfile(const char *spec, const char *file);
+struct mntentchn *getfsuuidspec(const char *uuid);
+struct mntentchn *getfsvolspec(const char *label);
 
-void lock_mtab (void);
-void unlock_mtab (void);
-void update_mtab (const char *special, struct my_mntent *with);
+void lock_mtab(void);
+void unlock_mtab(void);
+void update_mtab(const char *special, struct my_mntent *with);
diff --git a/sbin/mount/mount.nilfs2.c b/sbin/mount/mount.nilfs2.c
index 0588add..c20b298 100644
--- a/sbin/mount/mount.nilfs2.c
+++ b/sbin/mount/mount.nilfs2.c
@@ -141,26 +141,26 @@ static void nilfs_mount_logger(int priority, const char *fmt, ...)
 }
 
 /* Report on a single mount.  */
-static void print_one (const struct my_mntent *me)
+static void print_one(const struct my_mntent *me)
 {
 	if (mount_quiet)
 		return;
-	printf ("%s on %s", me->mnt_fsname, me->mnt_dir);
+	printf("%s on %s", me->mnt_fsname, me->mnt_dir);
 	if (me->mnt_type != NULL && *(me->mnt_type) != '\0')
-		printf (" type %s", me->mnt_type);
+		printf(" type %s", me->mnt_type);
 	if (me->mnt_opts != NULL)
-		printf (" (%s)", me->mnt_opts);
+		printf(" (%s)", me->mnt_opts);
 #if 0  /* XXX: volume label */
 	if (list_with_volumelabel) {
 		const char *label;
 		label = mount_get_volume_label_by_spec(me->mnt_fsname);
 		if (label) {
-			printf (" [%s]", label);
+			printf(" [%s]", label);
 			/* free(label); */
 		}
 	}
 #endif
-	printf ("\n");
+	printf("\n");
 }
 
 /*
@@ -305,8 +305,8 @@ update_mtab_entry(const char *spec, const char *node, const char *type,
 {
 	struct my_mntent mnt;
 
-	mnt.mnt_fsname = canonicalize (spec);
-	mnt.mnt_dir = canonicalize (node);
+	mnt.mnt_fsname = canonicalize(spec);
+	mnt.mnt_dir = canonicalize(node);
 	mnt.mnt_type = xstrdup(type);
 	mnt.mnt_opts = xstrdup(opts);
 	mnt.mnt_freq = freq;
@@ -315,10 +315,10 @@ update_mtab_entry(const char *spec, const char *node, const char *type,
 	/* We get chatty now rather than after the update to mtab since the
 	   mount succeeded, even if the write to /etc/mtab should fail.  */
 	if (verbose)
-		print_one (&mnt);
+		print_one(&mnt);
 
 	if (!addnew)
-		update_mtab (mnt.mnt_dir, &mnt);
+		update_mtab(mnt.mnt_dir, &mnt);
 	else {
 		mntFILE *mfp;
 
@@ -329,7 +329,7 @@ update_mtab_entry(const char *spec, const char *node, const char *type,
 			error(_("%s: can't open %s, %s"),
 			      progname, _PATH_MOUNTED, strerror(errsv));
 		} else {
-			if ((my_addmntent (mfp, &mnt)) == 1) {
+			if ((my_addmntent(mfp, &mnt)) == 1) {
 				int errsv = errno;
 				error(_("%s: error writing %s, %s"),
 				      progname, _PATH_MOUNTED, strerror(errsv));
diff --git a/sbin/mount/mount_mntent.c b/sbin/mount/mount_mntent.c
index ea44d0c..f7a7349 100644
--- a/sbin/mount/mount_mntent.c
+++ b/sbin/mount/mount_mntent.c
@@ -61,8 +61,8 @@ next:
 	return ss;
 }
 
-static int
-is_space_or_tab (char c) {
+static int is_space_or_tab(char c)
+{
 	return c == ' ' || c == '\t';
 }
 
@@ -108,8 +108,8 @@ unmangle(char *s) {
  *  for /proc/mounts.)
  */
 
-mntFILE *
-my_setmntent (const char *file, char *mode) {
+mntFILE *my_setmntent(const char *file, char *mode)
+{
 	mntFILE *mfp = xmalloc(sizeof(*mfp));
 	mode_t old_umask = umask(077);
 
@@ -122,8 +122,8 @@ my_setmntent (const char *file, char *mode) {
 	return mfp;
 }
 
-void
-my_endmntent (mntFILE *mfp) {
+void my_endmntent(mntFILE *mfp)
+{
 	if (mfp) {
 		if (mfp->mntent_fp)
 			fclose(mfp->mntent_fp);
@@ -133,12 +133,12 @@ my_endmntent (mntFILE *mfp) {
 	}
 }
 
-int
-my_addmntent (mntFILE *mfp, struct my_mntent *mnt) {
+int my_addmntent(mntFILE *mfp, struct my_mntent *mnt)
+{
 	char *m1, *m2, *m3, *m4;
 	int res;
 
-	if (fseek (mfp->mntent_fp, 0, SEEK_END))
+	if (fseek(mfp->mntent_fp, 0, SEEK_END))
 		return 1;			/* failure */
 
 	m1 = mangle(mnt->mnt_fsname);
@@ -146,8 +146,8 @@ my_addmntent (mntFILE *mfp, struct my_mntent *mnt) {
 	m3 = mangle(mnt->mnt_type);
 	m4 = mangle(mnt->mnt_opts);
 
-	res = fprintf (mfp->mntent_fp, "%s %s %s %s %d %d\n",
-		       m1, m2, m3, m4, mnt->mnt_freq, mnt->mnt_passno);
+	res = fprintf(mfp->mntent_fp, "%s %s %s %s %d %d\n",
+		      m1, m2, m3, m4, mnt->mnt_freq, mnt->mnt_passno);
 
 	free(m1);
 	free(m2);
@@ -157,8 +157,8 @@ my_addmntent (mntFILE *mfp, struct my_mntent *mnt) {
 }
 
 /* Read the next entry from the file fp. Stop reading at an incorrect entry. */
-struct my_mntent *
-my_getmntent (mntFILE *mfp) {
+struct my_mntent *my_getmntent(mntFILE *mfp)
+{
 	static char buf[4096];
 	static struct my_mntent me;
 	char *s;
@@ -169,11 +169,11 @@ my_getmntent (mntFILE *mfp) {
 
 	/* read the next non-blank non-comment line */
 	do {
-		if (fgets (buf, sizeof(buf), mfp->mntent_fp) == NULL)
+		if (fgets(buf, sizeof(buf), mfp->mntent_fp) == NULL)
 			return NULL;
 
 		mfp->mntent_lineno++;
-		s = index (buf, '\n');
+		s = index(buf, '\n');
 		if (s == NULL) {
 			/* Missing final newline?  Otherwise extremely */
 			/* long line - assume file was corrupted */
@@ -182,7 +182,7 @@ my_getmntent (mntFILE *mfp) {
 					_("[mntent]: warning: no final " \
 					"newline at the end of %s\n"),
 					mfp->mntent_file);
-				s = index (buf, 0);
+				s = index(buf, 0);
 			} else {
 				mfp->mntent_errs = 1;
 				goto err;
diff --git a/sbin/mount/mount_mntent.h b/sbin/mount/mount_mntent.h
index f859664..4f09ebb 100644
--- a/sbin/mount/mount_mntent.h
+++ b/sbin/mount/mount_mntent.h
@@ -25,9 +25,9 @@ typedef struct mntFILEstruct {
 	int mntent_softerrs;
 } mntFILE;
 
-mntFILE *my_setmntent (const char *file, char *mode);
-void my_endmntent (mntFILE *mfp);
-int my_addmntent (mntFILE *mfp, struct my_mntent *mnt);
-struct my_mntent *my_getmntent (mntFILE *mfp);
+mntFILE *my_setmntent(const char *file, char *mode);
+void my_endmntent(mntFILE *mfp);
+int my_addmntent(mntFILE *mfp, struct my_mntent *mnt);
+struct my_mntent *my_getmntent(mntFILE *mfp);
 
 #endif /* MOUNT_MNTENT_H */
diff --git a/sbin/mount/mount_opts.c b/sbin/mount/mount_opts.c
index 4b712b2..274eb4b 100644
--- a/sbin/mount/mount_opts.c
+++ b/sbin/mount/mount_opts.c
@@ -194,8 +194,8 @@ strip_quotes(char *str)
 
 	end = strrchr(str, '"');
 	if (end == NULL || end == str)
-		die (EX_USAGE, _("%s: improperly quoted option string '%s'"),
-		     progname, str);
+		die(EX_USAGE, _("%s: improperly quoted option string '%s'"),
+		    progname, str);
 
 	*end = '\0';
 	return str+1;
@@ -250,7 +250,7 @@ parse_opt(char *opt, int *mask, char **extra_opts)
 	const struct opt_map *om;
 
 	for (om = opt_map; om->opt != NULL; om++)
-		if (streq (opt, om->opt)) {
+		if (streq(opt, om->opt)) {
 			if (om->inv)
 				*mask &= ~om->mask;
 			else
diff --git a/sbin/mount/sundries.c b/sbin/mount/sundries.c
index 5c3a100..3c22106 100644
--- a/sbin/mount/sundries.c
+++ b/sbin/mount/sundries.c
@@ -36,12 +36,12 @@
 #include "xmalloc.h"
 #include "nls.h"
 
-char *
-xstrndup (const char *s, int n) {
+char *xstrndup(const char *s, int n)
+{
      char *t;
 
      if (s == NULL)
-	  die (EX_SOFTWARE, _("bug in xstrndup call"));
+	  die(EX_SOFTWARE, _("bug in xstrndup call"));
 
      t = xmalloc(n+1);
      strncpy(t, s, n);
@@ -51,8 +51,8 @@ xstrndup (const char *s, int n) {
 }
 
 /* reallocates its first arg - typical use: s = xstrconcat3(s,t,u); */
-char *
-xstrconcat3 (char *s, const char *t, const char *u) {
+char *xstrconcat3(char *s, const char *t, const char *u)
+{
      size_t len = 0;
 
      len = (s ? strlen(s) : 0) + (t ? strlen(t) : 0) + (u ? strlen(u) : 0);
@@ -73,8 +73,8 @@ xstrconcat3 (char *s, const char *t, const char *u) {
 }
 
 /* frees its first arg - typical use: s = xstrconcat4(s,t,u,v); */
-char *
-xstrconcat4 (char *s, const char *t, const char *u, const char *v) {
+char *xstrconcat4(char *s, const char *t, const char *u, const char *v)
+{
      size_t len = 0;
 
      len = (s ? strlen(s) : 0) + (t ? strlen(t) : 0) +
@@ -100,29 +100,29 @@ xstrconcat4 (char *s, const char *t, const char *u, const char *v) {
 }
 
 /* Call this with SIG_BLOCK to block and SIG_UNBLOCK to unblock.  */
-void
-block_signals (int how) {
+void block_signals(int how)
+{
      sigset_t sigs;
 
-     sigfillset (&sigs);
+     sigfillset(&sigs);
      sigdelset(&sigs, SIGTRAP);
      sigdelset(&sigs, SIGSEGV);
-     sigprocmask (how, &sigs, (sigset_t *) 0);
+     sigprocmask(how, &sigs, (sigset_t *) 0);
 }
 
 
 /* Non-fatal error.  Print message and return.  */
 /* (print the message in a single printf, in an attempt
     to avoid mixing output of several threads) */
-void
-error (const char *fmt, ...) {
+void error(const char *fmt, ...)
+{
      va_list args;
 
      if (mount_quiet)
 	  return;
-     va_start (args, fmt);
-     vfprintf (stderr, fmt, args);
-     va_end (args);
+     va_start(args, fmt);
+     vfprintf(stderr, fmt, args);
+     va_end(args);
      fputc('\n', stderr);
 }
 
@@ -130,13 +130,13 @@ error (const char *fmt, ...) {
    except that swap types always return false. */
 /* Accept nonfs,proc,devpts and nonfs,noproc,nodevpts
    with the same meaning. */
-int
-matching_type (const char *type, const char *types) {
+int matching_type(const char *type, const char *types)
+{
      int no;			/* negated types list */
      int len;
      const char *p;
 
-     if (streq (type, MNTTYPE_SWAP))
+     if (streq(type, MNTTYPE_SWAP))
 	  return 0;
      if (types == NULL)
 	  return 1;
@@ -205,8 +205,8 @@ check_option(const char *haystack, const char *needle) {
  * Unlike fs type matching, nonetdev,user and nonetdev,nouser have
  * DIFFERENT meanings; each option is matched explicitly as specified.
  */
-int
-matching_opts (const char *options, const char *test_opts) {
+int matching_opts(const char *options, const char *test_opts)
+{
      const char *p, *r;
      char *q;
      int len, this_len;
@@ -217,7 +217,7 @@ matching_opts (const char *options, const char *test_opts) {
      len = strlen(test_opts);
      q = alloca(len+1);
      if (q == NULL)
-          die (EX_SYSERR, _("not enough memory"));
+          die(EX_SYSERR, _("not enough memory"));
 
      for (p = test_opts; p < test_opts+len; p++) {
 	  r = strchr(p, ',');
@@ -240,8 +240,8 @@ matching_opts (const char *options, const char *test_opts) {
    canonicalize ("/dev/fd0/.") returns "/dev/fd0" even though ``/dev/fd0/.''
    is not a legal pathname for ``/dev/fd0''.  Anything we cannot parse
    we return unmodified.   */
-char *
-canonicalize (const char *path) {
+char *canonicalize(const char *path)
+{
 	char canonical[PATH_MAX+2];
 
 	if (path == NULL)
@@ -253,7 +253,7 @@ canonicalize (const char *path) {
 	    streq(path, "devpts"))
 		return xstrdup(path);
 #endif
-	if (myrealpath (path, canonical, PATH_MAX+1))
+	if (myrealpath(path, canonical, PATH_MAX+1))
 		return xstrdup(canonical);
 
 	return xstrdup(path);
diff --git a/sbin/mount/sundries.h b/sbin/mount/sundries.h
index df462ee..b3064a7 100644
--- a/sbin/mount/sundries.h
+++ b/sbin/mount/sundries.h
@@ -21,25 +21,25 @@
 
 extern int mount_quiet;
 
-#define streq(s, t)	(strcmp ((s), (t)) == 0)
+#define streq(s, t)	(strcmp((s), (t)) == 0)
 
 /* Functions in sundries.c that are used in mount.c and umount.c  */
-void block_signals (int how);
-char *canonicalize (const char *path);
-void error (const char *fmt, ...);
-int matching_type (const char *type, const char *types);
-int matching_opts (const char *options, const char *test_opts);
-void *xmalloc (size_t size);
-char *xstrdup (const char *s);
-char *xstrndup (const char *s, int n);
-char *xstrconcat3 (char *, const char *, const char *);
-char *xstrconcat4 (char *, const char *, const char *, const char *);
-
-void die (int errcode, const char *fmt, ...);
+void block_signals(int how);
+char *canonicalize(const char *path);
+void error(const char *fmt, ...);
+int matching_type(const char *type, const char *types);
+int matching_opts(const char *options, const char *test_opts);
+void *xmalloc(size_t size);
+char *xstrdup(const char *s);
+char *xstrndup(const char *s, int n);
+char *xstrconcat3(char *, const char *, const char *);
+char *xstrconcat4(char *, const char *, const char *, const char *);
+
+void die(int errcode, const char *fmt, ...);
 
 #ifdef HAVE_NFS
-int nfsmount (const char *spec, const char *node, int *flags,
-	      char **orig_opts, char **opt_args, int *version, int running_bg);
+int nfsmount(const char *spec, const char *node, int *flags,
+	     char **orig_opts, char **opt_args, int *version, int running_bg);
 #endif
 
 /* exit status - bits below are ORed */
diff --git a/sbin/mount/umount.nilfs2.c b/sbin/mount/umount.nilfs2.c
index 8947ddb..756dbe8 100644
--- a/sbin/mount/umount.nilfs2.c
+++ b/sbin/mount/umount.nilfs2.c
@@ -279,14 +279,14 @@ static int del_loop(const char *device)
 	if (fd < 0) {
 		int errsv = errno;
 		error(_("loop: can't delete device %s: %s\n"),
-		      device, strerror (errsv));
+		      device, strerror(errsv));
 		return 1;
 	}
-	if (ioctl (fd, LOOP_CLR_FD, 0) < 0) {
-		perror ("ioctl: LOOP_CLR_FD");
+	if (ioctl(fd, LOOP_CLR_FD, 0) < 0) {
+		perror("ioctl: LOOP_CLR_FD");
 		return 1;
 	}
-	close (fd);
+	close(fd);
 	if (verbose > 1)
 		printf(_("del_loop(%s): success\n"), device);
 	return 0;
@@ -385,7 +385,7 @@ umount_one(const char *spec, const char *node, const char *type,
 	pid_t pid;
 	pp_opt_t prot_period;
 
-	if (streq (node, "/") || streq (node, "root"))
+	if (streq(node, "/") || streq(node, "root"))
 		nomtab++;
 
 	if (mc) {
@@ -459,8 +459,8 @@ umount_one(const char *spec, const char *node, const char *type,
 
 			/* new style mtab line? */
 			optl = mc->m.mnt_opts ? xstrdup(mc->m.mnt_opts) : "";
-			for (optl = strtok (optl, ","); optl;
-			     optl = strtok (NULL, ",")) {
+			for (optl = strtok(optl, ","); optl;
+			     optl = strtok(NULL, ",")) {
 				if (!strncmp(optl, "loop=", 5)) {
 					loopdev = optl+5;
 					goto gotloop;
diff --git a/sbin/mount/xmalloc.c b/sbin/mount/xmalloc.c
index 60ee375..69b3966 100644
--- a/sbin/mount/xmalloc.c
+++ b/sbin/mount/xmalloc.c
@@ -46,8 +46,8 @@ die_if_null(void *t) {
 		die(EX_SYSERR, _("not enough memory"));
 }
 
-void *
-xmalloc (size_t size) {
+void *xmalloc(size_t size)
+{
 	void *t;
 
 	if (size == 0)
@@ -59,8 +59,8 @@ xmalloc (size_t size) {
 	return t;
 }
 
-void *
-xrealloc (void *p, size_t size) {
+void *xrealloc(void *p, size_t size)
+{
 	void *t;
 
 	t = realloc(p, size);
@@ -69,8 +69,8 @@ xrealloc (void *p, size_t size) {
 	return t;
 }
 
-char *
-xstrdup (const char *s) {
+char *xstrdup(const char *s)
+{
 	char *t;
 
 	if (s == NULL)
-- 
1.7.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
