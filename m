From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Problem report: cannot run nilfs_cleanerd on full filesystem
Date: Tue, 22 Mar 2011 00:07:02 +0900 (JST)
Message-ID: <20110322.000702.112911778.ryusuke@osrg.net>
References: <20110320125040.GA735@heethoofdje.13thmonkey.org>
	<20110321.200706.260176646.ryusuke@osrg.net>
	<201103211300.50177.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201103211300.50177.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 21 Mar 2011 13:00:47 +0100, dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi,
> 
> 
> On Monday 21 of March 2011 12:07:06 you wrote:
> > The ".nilfs" file is used for two purposes:
> > 
> >  1) As the file on which the nilfs library issues ioctls.
> > 
> >  2) For advisory locks (i.e. fcntl(F_GETLK/F_SETLK/FSETLKW)).  This
> >     works as a mutex between the cleaner and other nilfs-tools.
> > 
> > Note that the nilfs2 kernel code never uses the .nilfs file; it's just
> > a regular file for nilfs2.
> > 
> > As for the item (1), we can use the root directory of each filesystem
> > instead.  And for (2), a Posix semaphore or other lock primitives may
> > be available.
> 
> 
> I tried but failed; it seems Linux doesn't allow opening directory O_RDWR or 
> O_WRONLY. And a modyfying ioctl() on directory opened O_RDONLY also returned 
> some error, I think it was EBADF. I did not dig any further, so I dunno if 
> that's done by kernel's general code or NILFS' ioctl() handler.

Actually we can issue ioctls even for modyfying ioctls with the
following patch.

But, the advisory lock fails for write locks (F_WRLCK) since the file
descriptor is opened O_RDONLY, and fcntl returns EBADF in that case.
Cleneard and modifying commands are using this type of lock.

So, we can remove .nilfs if we replace the advisory lock with an
alternative way.

Also, we can make .nilfs immutable on the latest kernel in which nilfs
supported lsattr and chattr:

 # chattr +i .nilfs
 # rm .nilfs
 rm: cannot remove `.nilfs': Operation not permitted

This could be another work around though I don't prefer it.

Thanks,
Ryusuke Konishi
--
From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

nilfs-utils: use root directory instead of .nilfs

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 include/nilfs.h |    1 -
 lib/nilfs.c     |   19 ++-----------------
 2 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/include/nilfs.h b/include/nilfs.h
index af2584e..0485648 100644
--- a/include/nilfs.h
+++ b/include/nilfs.h
@@ -86,7 +86,6 @@ typedef __u64 sector_t;	// XXX: __u64 ??
 typedef sector_t nilfs_blkoff_t;
 typedef __u64 nilfs_cno_t;
 
-#define NILFS_IOC	".nilfs"
 #define NILFS_FSTYPE	"nilfs2"
 
 #define NILFS_CNO_MIN	((nilfs_cno_t)1)
diff --git a/lib/nilfs.c b/lib/nilfs.c
index 3ba5571..ff1c689 100644
--- a/lib/nilfs.c
+++ b/lib/nilfs.c
@@ -144,7 +144,6 @@ static int nilfs_find_fs(struct nilfs *nilfs, const char *dev, const char *dir,
 {
 	FILE *fp;
 	char line[LINE_MAX], *mntent[NMNTFLDS];
-	size_t len;
 	int ret, n;
 	char canonical[PATH_MAX + 2];
 	char *cdev = NULL, *cdir = NULL;
@@ -196,16 +195,12 @@ static int nilfs_find_fs(struct nilfs *nilfs, const char *dev, const char *dir,
 			nilfs->n_dev = strdup(mntent[MNTFLD_FS]);
 			if (nilfs->n_dev == NULL)
 				goto failed_proc_mounts;
-			len = strlen(mntent[MNTFLD_DIR]) +
-				strlen(NILFS_IOC) + 2;
-			nilfs->n_ioc = malloc(sizeof(char) * len);
+			nilfs->n_ioc = strdup(mntent[MNTFLD_DIR]);
 			if (nilfs->n_ioc == NULL) {
 				free(nilfs->n_dev);
 				nilfs->n_dev = NULL;
 				goto failed_proc_mounts;
 			}
-			snprintf(nilfs->n_ioc, len, "%s/%s",
-				 mntent[MNTFLD_DIR], NILFS_IOC);
 			ret = 0;
 			break;
 		}
@@ -280,7 +275,6 @@ struct nilfs *nilfs_open(const char *dev, const char *dir, int flags)
 {
 	struct nilfs *nilfs;
 	__u64 features;
-	int oflags;
 
 	if (!(flags & (NILFS_OPEN_RAW | NILFS_OPEN_RDONLY |
 		       NILFS_OPEN_WRONLY | NILFS_OPEN_RDWR))) {
@@ -330,16 +324,7 @@ struct nilfs *nilfs_open(const char *dev, const char *dir, int flags)
 			if (nilfs_find_fs(nilfs, dev, dir, MNTOPT_RO) < 0)
 				goto out_nilfs;
 		}
-		oflags = O_CREAT;
-		if (flags & NILFS_OPEN_RDONLY)
-			oflags |= O_RDONLY;
-		else if (flags & NILFS_OPEN_WRONLY)
-			oflags |= O_WRONLY;
-		else if (flags & NILFS_OPEN_RDWR)
-			oflags |= O_RDWR;
-		nilfs->n_iocfd = open(nilfs->n_ioc, oflags,
-				      S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP |
-				      S_IROTH | S_IWOTH);
+		nilfs->n_iocfd = open(nilfs->n_ioc, O_RDONLY);
 		if (nilfs->n_iocfd < 0)
 			goto out_fd;
 	}
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
