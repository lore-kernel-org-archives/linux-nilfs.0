From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/2] nilfs-utils: use posix semaphore for making fs-operation exclusive
Date: Wed, 23 Mar 2011 01:53:13 +0900
Message-ID: <1300812794-7024-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1300812794-7024-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1300812794-7024-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>, dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Reinoud Zandijk <reinoud-qavaossjCcEdnm+yROfE0A@public.gmane.org>

From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>

This uses posix named semaphores instead of advisory lock of fcntl to
implement mutex between nilfs tools and the cleaner daemon.  With this
change, the .nilfs file will be no longer required for the locking
purpose.

Signed-off-by: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Reinoud Zandijk <reinoud-qavaossjCcEdnm+yROfE0A@public.gmane.org>
---
 bin/Makefile.am             |    9 +------
 bin/chcp.c                  |    6 ++--
 bin/mkcp.c                  |    6 ++--
 configure.ac                |    7 +++++-
 include/nilfs.h             |   38 +++++++++++++++------------------
 lib/Makefile.am             |    6 ++--
 lib/nilfs.c                 |   49 +++++++++++++++++++++++++++++++++++++++++-
 sbin/cleanerd/Makefile.am   |    4 +-
 sbin/cleanerd/cleanerd.c    |    7 +++--
 sbin/nilfs-tune/Makefile.am |    4 +-
 10 files changed, 89 insertions(+), 47 deletions(-)

diff --git a/bin/Makefile.am b/bin/Makefile.am
index 6516ede..98fa83a 100644
--- a/bin/Makefile.am
+++ b/bin/Makefile.am
@@ -1,24 +1,19 @@
 ## Makefile.am
 
-AM_CFLAGS = -Wall
+AM_CFLAGS = -Wall -pthread
 AM_CPPFLAGS = -I$(top_srcdir)/include
+LDADD = $(top_builddir)/lib/libnilfs.la -lpthread
 
 bin_PROGRAMS = chcp dumpseg lscp lssu mkcp rmcp
 
 chcp_SOURCES = chcp.c
-chcp_LDADD = $(top_builddir)/lib/libnilfs.la
 
 dumpseg_SOURCES = dumpseg.c
-dumpseg_LDADD = $(top_builddir)/lib/libnilfs.la
 
 lscp_SOURCES = lscp.c
-lscp_LDADD = $(top_builddir)/lib/libnilfs.la
 
 lssu_SOURCES = lssu.c
-lssu_LDADD = $(top_builddir)/lib/libnilfs.la
 
 mkcp_SOURCES = mkcp.c
-mkcp_LDADD = $(top_builddir)/lib/libnilfs.la
 
 rmcp_SOURCES = rmcp.c
-rmcp_LDADD = $(top_builddir)/lib/libnilfs.la
diff --git a/bin/chcp.c b/bin/chcp.c
index a66e437..ef50159 100644
--- a/bin/chcp.c
+++ b/bin/chcp.c
@@ -137,7 +137,7 @@ int main(int argc, char *argv[])
 		exit(1);
 	}
 
-	nilfs = nilfs_open(dev, NULL, NILFS_OPEN_RDWR);
+	nilfs = nilfs_open(dev, NULL, NILFS_OPEN_RDWR | NILFS_OPEN_GCLK);
 	if (nilfs == NULL) {
 		fprintf(stderr, "%s: %s: cannot open NILFS\n", progname, dev);
 		exit(1);
@@ -145,7 +145,7 @@ int main(int argc, char *argv[])
 
 	status = 0;
 
-	if (nilfs_lock_write(nilfs) < 0) {
+	if (nilfs_lock_cleaner(nilfs) < 0) {
 		fprintf(stderr, "%s: cannot lock NILFS\n", progname);
 		status = 1;
 		goto out;
@@ -177,7 +177,7 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	nilfs_unlock_write(nilfs);
+	nilfs_unlock_cleaner(nilfs);
 
  out:
 	nilfs_close(nilfs);
diff --git a/bin/mkcp.c b/bin/mkcp.c
index 716b809..2965e40 100644
--- a/bin/mkcp.c
+++ b/bin/mkcp.c
@@ -115,7 +115,7 @@ int main(int argc, char *argv[])
 	else
 		dev = argv[optind];
 
-	nilfs = nilfs_open(dev, NULL, NILFS_OPEN_RDWR);
+	nilfs = nilfs_open(dev, NULL, NILFS_OPEN_RDWR | NILFS_OPEN_GCLK);
 	if (nilfs == NULL) {
 		fprintf(stderr, "%s: %s: cannot open NILFS\n", progname, dev);
 		exit(1);
@@ -128,7 +128,7 @@ int main(int argc, char *argv[])
 		goto out;
 	}
 	if (ss) {
-		if (nilfs_lock_write(nilfs) < 0) {
+		if (nilfs_lock_cleaner(nilfs) < 0) {
 			fprintf(stderr, "%s: %s\n", progname, strerror(errno));
 			status = 1;
 			goto out;
@@ -137,7 +137,7 @@ int main(int argc, char *argv[])
 			fprintf(stderr, "%s: %s\n", progname, strerror(errno));
 			status = 1;
 		}
-		if (nilfs_unlock_write(nilfs) < 0) {
+		if (nilfs_unlock_cleaner(nilfs) < 0) {
 			fprintf(stderr, "%s: %s\n", progname, strerror(errno));
 			status = 1;
 		}
diff --git a/configure.ac b/configure.ac
index 4c5e603..9bfc8f0 100644
--- a/configure.ac
+++ b/configure.ac
@@ -33,13 +33,18 @@ AC_CHECK_LIB([uuid], [uuid_generate],
 	  [Define to 1 if you have the `uuid' library (-luuid).])],
 	[AC_MSG_ERROR([UUID library not found])])
 
+AC_CHECK_LIB([pthread],[sem_open],
+	[AC_DEFINE([HAVE_LIBPTHREAD], 1,
+	  [Define to 1 if you have the `pthread' library (-lpthread).])],
+	[AC_MSG_ERROR([pthread library not found])])
+
 # Checks for header files.
 AC_HEADER_STDC
 AC_HEADER_SYS_WAIT
 AC_CHECK_HEADERS([fcntl.h libintl.h limits.h locale.h mntent.h paths.h \
 		  stdlib.h string.h strings.h sys/ioctl.h sys/mount.h \
 		  sys/time.h syslog.h unistd.h linux/types.h grp.h pwd.h \
-		  mntent.h])
+		  mntent.h semaphore.h])
 
 # Checks for typedefs, structures, and compiler characteristics.
 AC_C_CONST
diff --git a/include/nilfs.h b/include/nilfs.h
index af2584e..cf3bbc3 100644
--- a/include/nilfs.h
+++ b/include/nilfs.h
@@ -31,6 +31,7 @@
 #include <fcntl.h>
 #include <time.h>
 #include <sys/ioctl.h>
+#include <semaphore.h>
 #include <linux/types.h>
 #include <endian.h>
 #include <byteswap.h>
@@ -106,6 +107,8 @@ typedef __u64 nilfs_cno_t;
  * @n_iocfd: file descriptor of ioctl file
  * @n_opts: options
  * @n_mincno: the minimum of valid checkpoint numbers
+ * @n_sems: array of semaphores
+ *     sems[0] protects garbage collection process
  */
 struct nilfs {
 	struct nilfs_super_block *n_sb;
@@ -116,12 +119,14 @@ struct nilfs {
 	int n_iocfd;
 	int n_opts;
 	nilfs_cno_t n_mincno;
+	sem_t *n_sems[1];
 };
 
-#define NILFS_OPEN_RAW		0x01
-#define NILFS_OPEN_RDONLY	0x02
-#define NILFS_OPEN_WRONLY	0x04
-#define NILFS_OPEN_RDWR		0x08
+#define NILFS_OPEN_RAW		0x0001	/* Open RAW device */
+#define NILFS_OPEN_RDONLY	0x0002	/* Open NILFS API in read only mode */
+#define NILFS_OPEN_WRONLY	0x0004	/* Open NILFS API in write only mode */
+#define NILFS_OPEN_RDWR		0x0008	/* Open NILFS API in read/write mode */
+#define NILFS_OPEN_GCLK		0x1000	/* Open GC lock primitive */
 
 #define NILFS_OPT_MMAP	0x01
 
@@ -140,31 +145,22 @@ int nilfs_parse_cno_range(const char *, nilfs_cno_t *, nilfs_cno_t *, int);
 
 struct nilfs_super_block *nilfs_get_sb(struct nilfs *);
 
-static inline int nilfs_lock(struct nilfs *nilfs, int cmd, int type,
-			     off_t start, int whence, off_t len)
-{
-	struct flock flock;
-
-	flock.l_type = type;
-	flock.l_start = start;
-	flock.l_whence = whence;
-	flock.l_len = len;
-	return fcntl(nilfs->n_iocfd, cmd, &flock);
-}
 
-#define NILFS_LOCK_FNS(name, type)					\
+#define NILFS_LOCK_FNS(name, index)					\
 static inline int nilfs_lock_##name(struct nilfs *nilfs)		\
 {									\
-	return nilfs_lock(nilfs, F_SETLKW, type, 0, SEEK_SET, 1);	\
+	return sem_wait(nilfs->n_sems[index]);				\
+}									\
+static inline int nilfs_trylock_##name(struct nilfs *nilfs)		\
+{									\
+	return sem_trywait(nilfs->n_sems[index]);			\
 }									\
 static inline int nilfs_unlock_##name(struct nilfs *nilfs)		\
 {									\
-	return nilfs_lock(nilfs, F_SETLK, F_UNLCK, 0, SEEK_SET, 1);	\
+	return sem_post(nilfs->n_sems[index]);				\
 }
 
-NILFS_LOCK_FNS(read, F_RDLCK)
-NILFS_LOCK_FNS(write, F_WRLCK)
-
+NILFS_LOCK_FNS(cleaner, 0)
 
 /**
  * struct nilfs_psegment - partial segment iterator
diff --git a/lib/Makefile.am b/lib/Makefile.am
index 2dd5491..7bfcc39 100644
--- a/lib/Makefile.am
+++ b/lib/Makefile.am
@@ -9,12 +9,12 @@ lib_LTLIBRARIES = libnilfs.la
 noinst_LTLIBRARIES = libnilfsmisc.la
 
 libnilfsmisc_la_SOURCES = crc32.c realpath.c
-libnilfsmisc_la_CFLAGS = -Wall -fPIC
+libnilfsmisc_la_CFLAGS = -Wall -fPIC -pthread
 libnilfsmisc_la_CPPFLAGS = -I$(top_srcdir)/include
-libnilfsmisc_la_LDFLAGS = -static
+libnilfsmisc_la_LDFLAGS = -static -lpthread
 
 libnilfs_la_SOURCES = nilfs.c sb.c cno.c $(COMMONSOURCES)
 libnilfs_la_CFLAGS = -Wall
 libnilfs_la_CPPFLAGS = -I$(top_srcdir)/include
 libnilfs_la_LDFLAGS = -version-info $(VERSIONINFO)
-libnilfs_la_LIBADD = libnilfsmisc.la
+libnilfs_la_LIBADD = libnilfsmisc.la -lpthread
diff --git a/lib/nilfs.c b/lib/nilfs.c
index 3ba5571..bc48933 100644
--- a/lib/nilfs.c
+++ b/lib/nilfs.c
@@ -270,6 +270,42 @@ int nilfs_opt_test_mmap(struct nilfs *nilfs)
 	return !!(nilfs->n_opts & NILFS_OPT_MMAP);
 }
 
+static int nilfs_open_sem(struct nilfs *nilfs)
+{
+	char semnambuf[NAME_MAX - 4];
+	struct stat stbuf;
+	int devnum;
+	int ret;
+
+	ret = stat(nilfs->n_dev, &stbuf);
+	if (ret < 0)
+		return -1;
+
+	if (S_ISBLK(stbuf.st_mode)) {
+		ret = snprintf(semnambuf, sizeof(semnambuf),
+			       "/nilfs-cleaner-%lu", stbuf.st_rdev);
+	} else if (S_ISREG(stbuf.st_mode) || S_ISDIR(stbuf.st_mode)) {
+		ret = snprintf(semnambuf, sizeof(semnambuf),
+			       "/nilfs-cleaner-%lu-%lu",
+			       stbuf.st_dev, stbuf.st_ino);
+	} else {
+		errno = EINVAL;
+		return -1;
+	}
+
+	if (ret < 0)
+		return -1;
+
+	assert(ret < sizeof(semnambuf));
+
+	nilfs->n_sems[0] = sem_open(semnambuf, O_CREAT, S_IRWXU, 1);
+	if (nilfs->n_sems[0] == SEM_FAILED) {
+		nilfs->n_sems[0] = NULL;
+		return -1;
+	}
+	return 0;
+}
+
 /**
  * nilfs_open - create a NILFS object
  * @dev: device
@@ -298,6 +334,7 @@ struct nilfs *nilfs_open(const char *dev, const char *dir, int flags)
 	nilfs->n_dev = NULL;
 	nilfs->n_ioc = NULL;
 	nilfs->n_mincno = NILFS_CNO_MIN;
+	memset(nilfs->n_sems, 0, sizeof(nilfs->n_sems));
 
 	if (flags & NILFS_OPEN_RAW) {
 		if (dev == NULL) {
@@ -344,11 +381,17 @@ struct nilfs *nilfs_open(const char *dev, const char *dir, int flags)
 			goto out_fd;
 	}
 
+	if (flags & NILFS_OPEN_GCLK) {
+		/* Initialize cleaner semaphore */
+		if (nilfs_open_sem(nilfs) < 0)
+			goto out_fd;
+	}
+
 	/* success */
 	return nilfs;
 
 	/* error */
- out_fd:
+out_fd:
 	if (nilfs->n_devfd >= 0)
 		close(nilfs->n_devfd);
 	if (nilfs->n_iocfd >= 0)
@@ -360,7 +403,7 @@ struct nilfs *nilfs_open(const char *dev, const char *dir, int flags)
 	if (nilfs->n_sb != NULL)
 		free(nilfs->n_sb);
 
- out_nilfs:
+out_nilfs:
 	free(nilfs);
 	return NULL;
 }
@@ -371,6 +414,8 @@ struct nilfs *nilfs_open(const char *dev, const char *dir, int flags)
  */
 void nilfs_close(struct nilfs *nilfs)
 {
+	if (nilfs->n_sems[0] != NULL)
+		sem_close(nilfs->n_sems[0]);
 	if (nilfs->n_devfd >= 0)
 		close(nilfs->n_devfd);
 	if (nilfs->n_iocfd >= 0)
diff --git a/sbin/cleanerd/Makefile.am b/sbin/cleanerd/Makefile.am
index 34e48c5..d72483a 100644
--- a/sbin/cleanerd/Makefile.am
+++ b/sbin/cleanerd/Makefile.am
@@ -1,12 +1,12 @@
 ## Makefile.am
 
 sbin_PROGRAMS = nilfs_cleanerd
+LDADD = $(top_builddir)/lib/libnilfs.la -lpthread
 
 nilfs_cleanerd_SOURCES = cleanerd.c cldconfig.c vector.c \
 	cleanerd.h cldconfig.h vector.h
-nilfs_cleanerd_CFLAGS = -Wall
+nilfs_cleanerd_CFLAGS = -Wall -pthread
 nilfs_cleanerd_CPPFLAGS = -I$(top_srcdir)/include \
 	-DSYSCONFDIR=\"$(sysconfdir)\"
-nilfs_cleanerd_LDADD = $(top_builddir)/lib/libnilfs.la
 
 dist_sysconf_DATA = nilfs_cleanerd.conf
diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
index d717079..b0a77fe 100644
--- a/sbin/cleanerd/cleanerd.c
+++ b/sbin/cleanerd/cleanerd.c
@@ -194,7 +194,8 @@ nilfs_cleanerd_create(const char *dev, const char *dir, const char *conffile)
 	memset(cleanerd, 0, sizeof(*cleanerd));
 
 	cleanerd->c_nilfs = nilfs_open(dev, dir,
-				       NILFS_OPEN_RAW | NILFS_OPEN_RDWR);
+				       NILFS_OPEN_RAW | NILFS_OPEN_RDWR |
+				       NILFS_OPEN_GCLK);
 	if (cleanerd->c_nilfs == NULL) {
 		syslog(LOG_ERR, "cannot open nilfs on %s: %s", dev,
 		       strerror(errno));
@@ -955,7 +956,7 @@ static ssize_t nilfs_cleanerd_clean_segments(struct nilfs_cleanerd *cleanerd,
 	if (ret < 0)
 		goto out_vec;
 
-	ret = nilfs_lock_write(cleanerd->c_nilfs);
+	ret = nilfs_lock_cleaner(cleanerd->c_nilfs);
 	if (ret < 0)
 		goto out_vec;
 
@@ -1002,7 +1003,7 @@ static ssize_t nilfs_cleanerd_clean_segments(struct nilfs_cleanerd *cleanerd,
 	}
 
  out_lock:
-	if (nilfs_unlock_write(cleanerd->c_nilfs) < 0)
+	if (nilfs_unlock_cleaner(cleanerd->c_nilfs) < 0)
 		ret = -1;
 
  out_vec:
diff --git a/sbin/nilfs-tune/Makefile.am b/sbin/nilfs-tune/Makefile.am
index e29ba2e..270dd7b 100644
--- a/sbin/nilfs-tune/Makefile.am
+++ b/sbin/nilfs-tune/Makefile.am
@@ -1,9 +1,9 @@
 ## Makefile.am
 
-AM_CFLAGS = -Wall
+AM_CFLAGS = -Wall -pthread
 AM_CPPFLAGS = -I$(top_srcdir)/include
+LDADD = $(top_builddir)/lib/libnilfs.la -lpthread
 
 sbin_PROGRAMS = nilfs-tune
 
 nilfs_tune_SOURCES = nilfs-tune.c
-nilfs_tune_LDADD = $(top_builddir)/lib/libnilfs.la
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
