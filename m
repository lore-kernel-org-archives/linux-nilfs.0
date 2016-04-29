From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 04/11] nilfs2: clean up old e-mail addresses
Date: Fri, 29 Apr 2016 22:15:40 +0900
Message-ID: <1461935747-10380-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1461935747-10380-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=4v/NeTGRq1V1jUw9Qiv92QCrsZ1NxC9Ks4hw8w58qIY=;
        b=hSFTwvIJD4/pEAgfhnGwk5xbRUDfuQzleM83uHI/rbISMElb1g0nmTbHpmhmEkuOOV
         R2QcyhKrkca3+m8hcB+s/ooVG4eJqZGgkepHmjbfWUX21fGOm9/D/2N3CKprHyhIYPnD
         NR5qWpMUEWLU1x4kANylKR88AGJWKjJUOcjTZpDD4tvkCCAXR4j61FRKoH/KZckHEeZC
         kykc0bS6C1B1k3N1bPBvl0TN7SjCk8bq1M9YrY3VTTDz2pKyhDaBPwzjBjKJHOAXv4lC
         FrSvIARb62pA9HmHQ6SE5neKgZaJQ0WqcBvTCwD1Fl5F3Me6qE4ptqxOqJG12AKfaRv5
         yVPw==
In-Reply-To: <1461935747-10380-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

E-mail addresses of osrg.net domain are no longer available.  This
removes them from authorship notices and prevents reporters from being
confused.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/alloc.c         | 5 ++---
 fs/nilfs2/alloc.h         | 5 ++---
 fs/nilfs2/bmap.c          | 2 +-
 fs/nilfs2/bmap.h          | 2 +-
 fs/nilfs2/btnode.c        | 5 ++---
 fs/nilfs2/btnode.h        | 4 ++--
 fs/nilfs2/btree.c         | 2 +-
 fs/nilfs2/btree.h         | 2 +-
 fs/nilfs2/cpfile.c        | 2 +-
 fs/nilfs2/cpfile.h        | 2 +-
 fs/nilfs2/dat.c           | 2 +-
 fs/nilfs2/dat.h           | 2 +-
 fs/nilfs2/dir.c           | 2 +-
 fs/nilfs2/direct.c        | 2 +-
 fs/nilfs2/direct.h        | 2 +-
 fs/nilfs2/file.c          | 3 +--
 fs/nilfs2/gcinode.c       | 5 ++---
 fs/nilfs2/ifile.c         | 4 ++--
 fs/nilfs2/ifile.h         | 4 ++--
 fs/nilfs2/inode.c         | 2 +-
 fs/nilfs2/ioctl.c         | 2 +-
 fs/nilfs2/mdt.c           | 2 +-
 fs/nilfs2/mdt.h           | 2 +-
 fs/nilfs2/namei.c         | 3 +--
 fs/nilfs2/nilfs.h         | 3 +--
 fs/nilfs2/page.c          | 3 +--
 fs/nilfs2/page.h          | 3 +--
 fs/nilfs2/recovery.c      | 2 +-
 fs/nilfs2/segbuf.c        | 2 +-
 fs/nilfs2/segbuf.h        | 2 +-
 fs/nilfs2/segment.c       | 2 +-
 fs/nilfs2/segment.h       | 2 +-
 fs/nilfs2/sufile.c        | 4 ++--
 fs/nilfs2/sufile.h        | 2 +-
 fs/nilfs2/super.c         | 2 +-
 fs/nilfs2/the_nilfs.c     | 2 +-
 fs/nilfs2/the_nilfs.h     | 2 +-
 include/linux/nilfs2_fs.h | 3 +--
 38 files changed, 46 insertions(+), 56 deletions(-)

diff --git a/fs/nilfs2/alloc.c b/fs/nilfs2/alloc.c
index eaa0c6a..82362a5 100644
--- a/fs/nilfs2/alloc.c
+++ b/fs/nilfs2/alloc.c
@@ -13,9 +13,8 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Original code was written by Koji Sato <koji@osrg.net>.
- * Two allocators were unified by Ryusuke Konishi <ryusuke@osrg.net>,
- *                                Amagai Yoshiji <amagai@osrg.net>.
+ * Originally written by Koji Sato.
+ * Two allocators were unified by Ryusuke Konishi and Amagai Yoshiji.
  */
 
 #include <linux/types.h>
diff --git a/fs/nilfs2/alloc.h b/fs/nilfs2/alloc.h
index 62982ee..2bd567d 100644
--- a/fs/nilfs2/alloc.h
+++ b/fs/nilfs2/alloc.h
@@ -13,9 +13,8 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Original code was written by Koji Sato <koji@osrg.net>.
- * Two allocators were unified by Ryusuke Konishi <ryusuke@osrg.net>,
- *                                Amagai Yoshiji <amagai@osrg.net>.
+ * Originally written by Koji Sato.
+ * Two allocators were unified by Ryusuke Konishi and Amagai Yoshiji.
  */
 
 #ifndef _NILFS_ALLOC_H
diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
index fcd79e6..a5eab79 100644
--- a/fs/nilfs2/bmap.c
+++ b/fs/nilfs2/bmap.c
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Koji Sato <koji@osrg.net>.
+ * Written by Koji Sato.
  */
 
 #include <linux/fs.h>
diff --git a/fs/nilfs2/bmap.h b/fs/nilfs2/bmap.h
index baa6d40..c14f822 100644
--- a/fs/nilfs2/bmap.h
+++ b/fs/nilfs2/bmap.h
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Koji Sato <koji@osrg.net>.
+ * Written by Koji Sato.
  */
 
 #ifndef _NILFS_BMAP_H
diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index 55241ef..0576033 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -13,9 +13,8 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * This file was originally written by Seiji Kihara <kihara@osrg.net>
- * and fully revised by Ryusuke Konishi <ryusuke@osrg.net> for
- * stabilization and simplification.
+ * Originally written by Seiji Kihara.
+ * Fully revised by Ryusuke Konishi for stabilization and simplification.
  *
  */
 
diff --git a/fs/nilfs2/btnode.h b/fs/nilfs2/btnode.h
index 0727096..2cc1b80 100644
--- a/fs/nilfs2/btnode.h
+++ b/fs/nilfs2/btnode.h
@@ -13,8 +13,8 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Seiji Kihara <kihara@osrg.net>
- * Revised by Ryusuke Konishi <ryusuke@osrg.net>
+ * Written by Seiji Kihara.
+ * Revised by Ryusuke Konishi.
  */
 
 #ifndef _NILFS_BTNODE_H
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index cc748ff..8fc73d0 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Koji Sato <koji@osrg.net>.
+ * Written by Koji Sato.
  */
 
 #include <linux/slab.h>
diff --git a/fs/nilfs2/btree.h b/fs/nilfs2/btree.h
index 9497732..df1a25f 100644
--- a/fs/nilfs2/btree.h
+++ b/fs/nilfs2/btree.h
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Koji Sato <koji@osrg.net>.
+ * Written by Koji Sato.
  */
 
 #ifndef _NILFS_BTREE_H
diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index 15016ec..d192b48 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Koji Sato <koji@osrg.net>.
+ * Written by Koji Sato.
  */
 
 #include <linux/kernel.h>
diff --git a/fs/nilfs2/cpfile.h b/fs/nilfs2/cpfile.h
index 3dcaceb..5bdb826 100644
--- a/fs/nilfs2/cpfile.h
+++ b/fs/nilfs2/cpfile.h
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Koji Sato <koji@osrg.net>.
+ * Written by Koji Sato.
  */
 
 #ifndef _NILFS_CPFILE_H
diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index 7427c11..e92257b 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Koji Sato <koji@osrg.net>.
+ * Written by Koji Sato.
  */
 
 #include <linux/types.h>
diff --git a/fs/nilfs2/dat.h b/fs/nilfs2/dat.h
index edd0586..c7035b5 100644
--- a/fs/nilfs2/dat.h
+++ b/fs/nilfs2/dat.h
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Koji Sato <koji@osrg.net>.
+ * Written by Koji Sato.
  */
 
 #ifndef _NILFS_DAT_H
diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index 6817930..edd3ca9 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Modified for NILFS by Amagai Yoshiji <amagai@osrg.net>
+ * Modified for NILFS by Amagai Yoshiji.
  */
 /*
  *  linux/fs/ext2/dir.c
diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
index 2470022..22058d0 100644
--- a/fs/nilfs2/direct.c
+++ b/fs/nilfs2/direct.c
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Koji Sato <koji@osrg.net>.
+ * Written by Koji Sato.
  */
 
 #include <linux/errno.h>
diff --git a/fs/nilfs2/direct.h b/fs/nilfs2/direct.h
index e4eb1b7..3015a6e 100644
--- a/fs/nilfs2/direct.h
+++ b/fs/nilfs2/direct.h
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Koji Sato <koji@osrg.net>.
+ * Written by Koji Sato.
  */
 
 #ifndef _NILFS_DIRECT_H
diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index 49243ca..547381f 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -13,8 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Amagai Yoshiji <amagai@osrg.net>,
- *            Ryusuke Konishi <ryusuke@osrg.net>
+ * Written by Amagai Yoshiji and Ryusuke Konishi.
  */
 
 #include <linux/fs.h>
diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
index b032188..693aded 100644
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -13,9 +13,8 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Seiji Kihara <kihara@osrg.net>, Amagai Yoshiji <amagai@osrg.net>,
- *            and Ryusuke Konishi <ryusuke@osrg.net>.
- * Revised by Ryusuke Konishi <ryusuke@osrg.net>.
+ * Written by Seiji Kihara, Amagai Yoshiji, and Ryusuke Konishi.
+ * Revised by Ryusuke Konishi.
  *
  */
 /*
diff --git a/fs/nilfs2/ifile.c b/fs/nilfs2/ifile.c
index 06f9b5a..d9048f6 100644
--- a/fs/nilfs2/ifile.c
+++ b/fs/nilfs2/ifile.c
@@ -13,8 +13,8 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Amagai Yoshiji <amagai@osrg.net>.
- * Revised by Ryusuke Konishi <ryusuke@osrg.net>.
+ * Written by Amagai Yoshiji.
+ * Revised by Ryusuke Konishi.
  *
  */
 
diff --git a/fs/nilfs2/ifile.h b/fs/nilfs2/ifile.h
index c61637e..1b7d7af 100644
--- a/fs/nilfs2/ifile.h
+++ b/fs/nilfs2/ifile.h
@@ -13,8 +13,8 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Amagai Yoshiji <amagai@osrg.net>
- * Revised by Ryusuke Konishi <ryusuke@osrg.net>
+ * Written by Amagai Yoshiji.
+ * Revised by Ryusuke Konishi.
  *
  */
 
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 4ef5c05..3d3ff46 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Ryusuke Konishi <ryusuke@osrg.net>
+ * Written by Ryusuke Konishi.
  *
  */
 
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 4db0e5f..e865998 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Koji Sato <koji@osrg.net>.
+ * Written by Koji Sato.
  */
 
 #include <linux/fs.h>
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 0ab93bd..36fa941 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Ryusuke Konishi <ryusuke@osrg.net>
+ * Written by Ryusuke Konishi.
  */
 
 #include <linux/buffer_head.h>
diff --git a/fs/nilfs2/mdt.h b/fs/nilfs2/mdt.h
index 5fc07ec..54e3b7f 100644
--- a/fs/nilfs2/mdt.h
+++ b/fs/nilfs2/mdt.h
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Ryusuke Konishi <ryusuke@osrg.net>
+ * Written by Ryusuke Konishi.
  */
 
 #ifndef _NILFS_MDT_H
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 581e901..3cf8169 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -13,8 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Modified for NILFS by Amagai Yoshiji <amagai@osrg.net>,
- *                       Ryusuke Konishi <ryusuke@osrg.net>
+ * Modified for NILFS by Amagai Yoshiji and Ryusuke Konishi.
  */
 /*
  *  linux/fs/ext2/namei.c
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index e2089a1..fa179d4 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -13,8 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Koji Sato <koji@osrg.net>
- *            Ryusuke Konishi <ryusuke@osrg.net>
+ * Written by Koji Sato and Ryusuke Konishi.
  */
 
 #ifndef _NILFS_H
diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index b10057e..1968713 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -13,8 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Ryusuke Konishi <ryusuke@osrg.net>,
- *            Seiji Kihara <kihara@osrg.net>.
+ * Written by Ryusuke Konishi and Seiji Kihara.
  */
 
 #include <linux/pagemap.h>
diff --git a/fs/nilfs2/page.h b/fs/nilfs2/page.h
index 6df10e1..041f2dc 100644
--- a/fs/nilfs2/page.h
+++ b/fs/nilfs2/page.h
@@ -13,8 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Ryusuke Konishi <ryusuke@osrg.net>,
- *            Seiji Kihara <kihara@osrg.net>.
+ * Written by Ryusuke Konishi and Seiji Kihara.
  */
 
 #ifndef _NILFS_PAGE_H
diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index 2ae1dfc..402a45c 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Ryusuke Konishi <ryusuke@osrg.net>
+ * Written by Ryusuke Konishi.
  */
 
 #include <linux/buffer_head.h>
diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index 8aef62d..52f6a6c 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Ryusuke Konishi <ryusuke@osrg.net>
+ * Written by Ryusuke Konishi.
  *
  */
 
diff --git a/fs/nilfs2/segbuf.h b/fs/nilfs2/segbuf.h
index fa4ed03..fc3a0fe 100644
--- a/fs/nilfs2/segbuf.h
+++ b/fs/nilfs2/segbuf.h
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Ryusuke Konishi <ryusuke@osrg.net>
+ * Written by Ryusuke Konishi.
  *
  */
 #ifndef _NILFS_SEGBUF_H
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index cafb61c..ddbfb09 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Ryusuke Konishi <ryusuke@osrg.net>
+ * Written by Ryusuke Konishi.
  *
  */
 
diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
index a118eab..6cb12db 100644
--- a/fs/nilfs2/segment.h
+++ b/fs/nilfs2/segment.h
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Ryusuke Konishi <ryusuke@osrg.net>
+ * Written by Ryusuke Konishi.
  *
  */
 #ifndef _NILFS_SEGMENT_H
diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 1d60248..df439da 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -13,8 +13,8 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Koji Sato <koji@osrg.net>.
- * Revised by Ryusuke Konishi <ryusuke@osrg.net>.
+ * Written by Koji Sato.
+ * Revised by Ryusuke Konishi.
  */
 
 #include <linux/kernel.h>
diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
index c4cf47e..46e8987 100644
--- a/fs/nilfs2/sufile.h
+++ b/fs/nilfs2/sufile.h
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Koji Sato <koji@osrg.net>.
+ * Written by Koji Sato.
  */
 
 #ifndef _NILFS_SUFILE_H
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index d304faa..2ed3e40 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Ryusuke Konishi <ryusuke@osrg.net>
+ * Written by Ryusuke Konishi.
  */
 /*
  *  linux/fs/ext2/super.c
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 8e27012..ba4b818 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Ryusuke Konishi <ryusuke@osrg.net>
+ * Written by Ryusuke Konishi.
  *
  */
 
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 426e4ac..6a26293 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Ryusuke Konishi <ryusuke@osrg.net>
+ * Written by Ryusuke Konishi.
  *
  */
 
diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index 0d7f814..823d63d 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -13,8 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU Lesser General Public License for more details.
  *
- * Written by Koji Sato <koji@osrg.net>
- *            Ryusuke Konishi <ryusuke@osrg.net>
+ * Written by Koji Sato and Ryusuke Konishi.
  */
 /*
  *  linux/include/linux/ext2_fs.h
-- 
1.8.3.1

