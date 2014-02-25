From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs-utils: update nilfs project site
Date: Tue, 25 Feb 2014 22:46:10 +0900
Message-ID: <1393335970-12540-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

We moved nilfs project site to nilfs.sourceforge.net from
www.nilfs.org.  This updates the site information written in man
pages.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 man/chcp.8           |    2 +-
 man/dumpseg.8        |    2 +-
 man/lscp.1           |    2 +-
 man/lssu.1           |    2 +-
 man/mkcp.8           |    2 +-
 man/mkfs.nilfs2.8    |    2 +-
 man/mount.nilfs2.8   |    2 +-
 man/nilfs-clean.8    |    2 +-
 man/nilfs-resize.8   |    2 +-
 man/nilfs-tune.8     |    2 +-
 man/nilfs.8          |    2 +-
 man/nilfs_cleanerd.8 |    2 +-
 man/rmcp.8           |    2 +-
 man/umount.nilfs2.8  |    2 +-
 14 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/man/chcp.8 b/man/chcp.8
index 55d22f4..4969aed 100644
--- a/man/chcp.8
+++ b/man/chcp.8
@@ -31,7 +31,7 @@ Koji Sato
 .SH AVAILABILITY
 .B chcp
 is part of the nilfs-utils package and is available from
-http://www.nilfs.org.
+http://nilfs.sourceforge.net.
 .SH SEE ALSO
 .BR nilfs (8),
 .BR lscp (1),
diff --git a/man/dumpseg.8 b/man/dumpseg.8
index a18cd98..912bd7a 100644
--- a/man/dumpseg.8
+++ b/man/dumpseg.8
@@ -91,7 +91,7 @@ Koji Sato
 .SH AVAILABILITY
 .B dumpseg
 is part of the nilfs-utils package and is available from
-http://www.nilfs.org.
+http://nilfs.sourceforge.net.
 .SH SEE ALSO
 .BR nilfs (8),
 .BR lssu (1).
diff --git a/man/lscp.1 b/man/lscp.1
index 1435a8e..4d25ccf 100644
--- a/man/lscp.1
+++ b/man/lscp.1
@@ -85,7 +85,7 @@ Koji Sato
 .SH AVAILABILITY
 .B lscp
 is part of the nilfs-utils package and is available from
-http://www.nilfs.org.
+http://nilfs.sourceforge.net.
 .SH SEE ALSO
 .BR nilfs (8),
 .BR mkcp (8),
diff --git a/man/lssu.1 b/man/lssu.1
index 9694b44..01d8a93 100644
--- a/man/lssu.1
+++ b/man/lssu.1
@@ -89,7 +89,7 @@ Koji Sato
 .SH AVAILABILITY
 .B lssu
 is part of the nilfs-utils package and is available from
-http://www.nilfs.org.
+http://nilfs.sourceforge.net.
 .SH SEE ALSO
 .BR nilfs (8),
 .BR dumpseg (8).
diff --git a/man/mkcp.8 b/man/mkcp.8
index 164a924..ab48dc0 100644
--- a/man/mkcp.8
+++ b/man/mkcp.8
@@ -33,7 +33,7 @@ Koji Sato
 .SH AVAILABILITY
 .B mkcp
 is part of the nilfs-utils package and is available from
-http://www.nilfs.org.
+http://nilfs.sourceforge.net.
 .SH SEE ALSO
 .BR nilfs (8),
 .BR lscp (1),
diff --git a/man/mkfs.nilfs2.8 b/man/mkfs.nilfs2.8
index a42d5b4..e9c44e3 100644
--- a/man/mkfs.nilfs2.8
+++ b/man/mkfs.nilfs2.8
@@ -189,7 +189,7 @@ has been written by Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>.
 .SH AVAILABILITY
 .B mkfs.nilfs2
 is part of the nilfs-utils package and is available from
-http://www.nilfs.org.
+http://nilfs.sourceforge.net.
 .SH SEE ALSO
 .BR nilfs (8),
 .BR mkfs (8),
diff --git a/man/mount.nilfs2.8 b/man/mount.nilfs2.8
index 4872c68..453b241 100644
--- a/man/mount.nilfs2.8
+++ b/man/mount.nilfs2.8
@@ -188,7 +188,7 @@ based on the mount program included in the util-linux package.
 .SH AVAILABILITY
 .B mount.nilfs2
 is part of the nilfs-utils package and is available from
-http://www.nilfs.org.
+http://nilfs.sourceforge.net.
 .SH SEE ALSO
 .BR nilfs (8),
 .BR mount (8),
diff --git a/man/nilfs-clean.8 b/man/nilfs-clean.8
index f952558..c8c0d22 100644
--- a/man/nilfs-clean.8
+++ b/man/nilfs-clean.8
@@ -84,7 +84,7 @@ Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
 .SH AVAILABILITY
 .B nilfs-clean
 is part of the nilfs-utils package and is available from
-http://www.nilfs.org.
+http://nilfs.sourceforge.net.
 .SH SEE ALSO
 .BR nilfs (8),
 .BR nilfs_cleanerd (8).
diff --git a/man/nilfs-resize.8 b/man/nilfs-resize.8
index c728fcf..3453b79 100644
--- a/man/nilfs-resize.8
+++ b/man/nilfs-resize.8
@@ -56,7 +56,7 @@ Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
 .SH AVAILABILITY
 .B nilfs-resize
 is part of the nilfs-utils package and is available from
-http://www.nilfs.org.
+http://nilfs.sourceforge.net.
 .SH SEE ALSO
 .BR nilfs (8),
 .BR nilfs-tune (8),
diff --git a/man/nilfs-tune.8 b/man/nilfs-tune.8
index 47dc1b3..16f3ac1 100644
--- a/man/nilfs-tune.8
+++ b/man/nilfs-tune.8
@@ -65,7 +65,7 @@ Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
 .SH AVAILABILITY
 .B nilfs-tune
 is part of the nilfs-utils package and is available from
-http://www.nilfs.org.
+http://nilfs.sourceforge.net.
 .SH SEE ALSO
 .BR nilfs (8),
 .BR lscp (1),
diff --git a/man/nilfs.8 b/man/nilfs.8
index cb4eddc..21b6d1b 100644
--- a/man/nilfs.8
+++ b/man/nilfs.8
@@ -121,4 +121,4 @@ was developed by NILFS development team.
 .BR lssu (1),
 .BR dumpseg (8)
 .sp
-http://www.nilfs.org/
+http://nilfs.sourceforge.net/
diff --git a/man/nilfs_cleanerd.8 b/man/nilfs_cleanerd.8
index fd1c48a..1c0aecc 100644
--- a/man/nilfs_cleanerd.8
+++ b/man/nilfs_cleanerd.8
@@ -76,7 +76,7 @@ Koji Sato
 .SH AVAILABILITY
 .B nilfs_cleanerd
 is part of the nilfs-utils package and available from
-http://www.nilfs.org.
+http://nilfs.sourceforge.net.
 .SH SEE ALSO
 .BR nilfs (8),
 .BR mount.nilfs2 (8),
diff --git a/man/rmcp.8 b/man/rmcp.8
index 64af29e..fde3b09 100644
--- a/man/rmcp.8
+++ b/man/rmcp.8
@@ -50,7 +50,7 @@ Koji Sato, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>.
 .SH AVAILABILITY
 .B rmcp
 is part of the nilfs-utils package and is available from
-http://www.nilfs.org.
+http://nilfs.sourceforge.net.
 .SH SEE ALSO
 .BR nilfs (8),
 .BR lscp (1),
diff --git a/man/umount.nilfs2.8 b/man/umount.nilfs2.8
index 93f027a..24f636c 100644
--- a/man/umount.nilfs2.8
+++ b/man/umount.nilfs2.8
@@ -52,7 +52,7 @@ based on the umount program included in the util-linux package.
 .SH AVAILABILITY
 .B umount.nilfs2
 is part of the nilfs-utils package and is available from
-http://www.nilfs.org.
+http://nilfs.sourceforge.net.
 .SH SEE ALSO
 .BR nilfs (8),
 .BR umount (8),
-- 
1.7.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
