From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 10/10] nilfs-utils: remove unnecessary externs
Date: Fri, 14 Feb 2014 03:24:10 +0900
Message-ID: <1392315850-29149-11-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

 WARNING: externs should be avoided in .c files
 #102: FILE: mkfs/mkfs.c:102:
 +extern char *optarg;

 WARNING: externs should be avoided in .c files
 #103: FILE: mkfs/mkfs.c:103:
 +extern int optind;

 WARNING: externs should be avoided in .c files
 #106: FILE: mount/mount.nilfs2.c:106:
 +extern char *optarg;

 WARNING: externs should be avoided in .c files
 #107: FILE: mount/mount.nilfs2.c:107:
 +extern int optind;

 WARNING: externs should be avoided in .c files
 #104: FILE: mount/umount.nilfs2.c:104:
 +extern char *optarg;

 WARNING: externs should be avoided in .c files
 #105: FILE: mount/umount.nilfs2.c:105:
 +extern int optind;

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 sbin/mkfs/mkfs.c           |    3 ---
 sbin/mount/mount.nilfs2.c  |    3 ---
 sbin/mount/umount.nilfs2.c |    3 ---
 3 files changed, 9 deletions(-)

diff --git a/sbin/mkfs/mkfs.c b/sbin/mkfs/mkfs.c
index d17dabe..c122375 100644
--- a/sbin/mkfs/mkfs.c
+++ b/sbin/mkfs/mkfs.c
@@ -99,9 +99,6 @@ static const char badblocks[] = "/sbin/" BADBLOCKS_NAME;
 /*
  * Command interface primitives
  */
-extern char *optarg;
-extern int optind;
-
 char *progname = "mkfs.nilfs2";
 
 /* Options */
diff --git a/sbin/mount/mount.nilfs2.c b/sbin/mount/mount.nilfs2.c
index c20b298..72aa07a 100644
--- a/sbin/mount/mount.nilfs2.c
+++ b/sbin/mount/mount.nilfs2.c
@@ -103,9 +103,6 @@ static int devro;
 static int fake;
 
 /* global variables */
-extern char *optarg;
-extern int optind;
-
 const char fstype[] = NILFS2_FS_NAME;
 char *progname = "mount." NILFS2_FS_NAME;
 
diff --git a/sbin/mount/umount.nilfs2.c b/sbin/mount/umount.nilfs2.c
index 756dbe8..1fc17d3 100644
--- a/sbin/mount/umount.nilfs2.c
+++ b/sbin/mount/umount.nilfs2.c
@@ -101,9 +101,6 @@ int readonly;
 int readwrite;
 static int nomtab;
 
-extern char *optarg;
-extern int optind;
-
 const char fstype[] = NILFS2_FS_NAME;
 char *progname = "umount." NILFS2_FS_NAME;
 
-- 
1.7.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
