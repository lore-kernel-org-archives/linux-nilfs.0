From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/4] nilfs-utils: fix typos in ChangeLog file
Date: Sun, 20 Apr 2014 00:14:12 +0900
Message-ID: <1397920455-373-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1397920455-373-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1397920455-373-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 ChangeLog | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/ChangeLog b/ChangeLog
index fde4126..e4082dc 100644
--- a/ChangeLog
+++ b/ChangeLog
@@ -8,12 +8,12 @@ nilfs-utils-2.2.0  Tue Apr 8, 2014 JST
 	* lib/gc.c: add optimized version of nilfs_xreclaim_segments
 	* cleanerd: use nilfs_xreclaim_segment()
 	* cleanerd: add a no_timeout flag to enable faster loop
-	* lib/nilfs.c: add suport for NILFS_IOCTL_SET_SUINFO ioctl
+	* lib/nilfs.c: add support for NILFS_IOCTL_SET_SUINFO ioctl
 	* lib/nilfs.c: add NILFS_OPT_SET_SUINFO
 	* nilfs-clean: add cmdline param min-reclaimable-blocks
 	* move generic macros into util.h
 	* fix coding style issues
-	* bump up verion of nilfs-utils written in manpages
+	* bump up version of nilfs-utils written in manpages
 
 nilfs-utils-2.1.6  Sun Jan 26, 2014 JST
 
@@ -43,7 +43,7 @@ nilfs-utils-2.1.5  Thu May 2, 2013 JST
 	* mkfs.nilfs2: erase the first and the second sectors unless boot
 	  sector exists.
 	* mkcp: add --print option.
-	* add ommitted comments for structures in nilfs2_fs.h.
+	* add omitted comments for structures in nilfs2_fs.h.
 	* add autogen script.
 	* fix missing bold font termination in nilfs.8 man page.
 	* update README file.
@@ -207,7 +207,7 @@ nilfs-utils-2.0.17  Sat Mar 13, 2010 JST
 
 nilfs-utils-2.0.16  Sat Mar 13, 2010 JST
 
-	* add pseudo mount option "-o pp=<secconds>" which sets protection
+	* add pseudo mount option "-o pp=<seconds>" which sets protection
 	  period (thanks to David Smid)
 	* fix build against newer glibc
 	* update mount.nilfs2 manpage to reflect mount option changes
@@ -258,7 +258,7 @@ nilfs-utils-2.0.12  Thu Apr  2, 2009 JST
 	* fix command line buffer overflow error for mkfs -c
 	* settle mess for bind mounts.
 	* fix a bug in device check of mount.nilfs2 which confirm device is
-	  acesssible or not.
+	  accessible or not.
 	* rewrite lscp command to interleavingly call nilfs_get_cpinfo()
 	  and list its result.
 	* rewrite lssu command to interleavingly call nilfs_get_suinfo()
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
