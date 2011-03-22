From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/2] nilfs-utils: use root directory instead of .nilfs
Date: Wed, 23 Mar 2011 01:53:14 +0900
Message-ID: <1300812794-7024-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1300812794-7024-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1300812794-7024-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Reinoud Zandijk <reinoud-qavaossjCcEdnm+yROfE0A@public.gmane.org>

This issues NILFS API ioctls to for root directory of filesystem
instead of the .nilfs file.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Reinoud Zandijk <reinoud-qavaossjCcEdnm+yROfE0A@public.gmane.org>
---
 include/nilfs.h |    1 -
 lib/nilfs.c     |   19 ++-----------------
 2 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/include/nilfs.h b/include/nilfs.h
index cf3bbc3..7b3ecde 100644
--- a/include/nilfs.h
+++ b/include/nilfs.h
@@ -87,7 +87,6 @@ typedef __u64 sector_t;	// XXX: __u64 ??
 typedef sector_t nilfs_blkoff_t;
 typedef __u64 nilfs_cno_t;
 
-#define NILFS_IOC	".nilfs"
 #define NILFS_FSTYPE	"nilfs2"
 
 #define NILFS_CNO_MIN	((nilfs_cno_t)1)
diff --git a/lib/nilfs.c b/lib/nilfs.c
index bc48933..be1d1a8 100644
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
@@ -316,7 +311,6 @@ struct nilfs *nilfs_open(const char *dev, const char *dir, int flags)
 {
 	struct nilfs *nilfs;
 	__u64 features;
-	int oflags;
 
 	if (!(flags & (NILFS_OPEN_RAW | NILFS_OPEN_RDONLY |
 		       NILFS_OPEN_WRONLY | NILFS_OPEN_RDWR))) {
@@ -367,16 +361,7 @@ struct nilfs *nilfs_open(const char *dev, const char *dir, int flags)
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
