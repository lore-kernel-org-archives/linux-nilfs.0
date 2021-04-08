From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] fs/nilfs2: fix misspellings using codespell tool
Date: Thu,  8 Apr 2021 15:41:27 +0900
Message-ID: <1617864087-8198-1-git-send-email-konishi.ryusuke@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=+ayU6agm7dGKxsfyYagzLZgme/BHOALbAfqPjDZCbBw=;
        b=vAVpeboIaVj2cKD6E6KjWY8OSGsnPhEhHGcYumoLuTOn3iSK2tiN1BVRK9n+UcAjEQ
         V/2YS0KKJHLO6ldmMhaO4xGtk/zC+xsbnaTTyAxAPM20av8lHgHtg6FkoK3tiuMHR3zS
         recp7/ZsujPEiC/XjjWLaW9rz5yyxYJG0Y1Ck4mxw8xrOIQtNksKJAcpM9hyHcfsOXKp
         MkWBE6Suh48QLwXE422ZXDYz2Xxuy11AV6SmCh/GRbGiJT3rVdZWHKwQ8vhnSEwMHwCO
         urMt36limi5izOZgpMEKreGZ5sLIIkormtt49in2boHYz8R8hYSo0d0Ge2qxyaSQuiLs
         L3Eg==
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

From: Liu xuzhi <liu.xuzhi-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

Two typos are found out by codespell tool \
in 2217th and 2254th lines of segment.c:

$ codespell ./fs/nilfs2/
./segment.c:2217 :retured  ==> returned
./segment.c:2254: retured  ==> returned

Fix two typos found by codespell.

Signed-off-by: Liu xuzhi <liu.xuzhi-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/nilfs2/segment.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index cd4da9535aed..686c8ee7b29c 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2214,7 +2214,7 @@ static void nilfs_segctor_wakeup(struct nilfs_sc_info *sci, int err)
  * nilfs_construct_segment - construct a logical segment
  * @sb: super block
  *
- * Return Value: On success, 0 is retured. On errors, one of the following
+ * Return Value: On success, 0 is returned. On errors, one of the following
  * negative error code is returned.
  *
  * %-EROFS - Read only filesystem.
@@ -2251,7 +2251,7 @@ int nilfs_construct_segment(struct super_block *sb)
  * @start: start byte offset
  * @end: end byte offset (inclusive)
  *
- * Return Value: On success, 0 is retured. On errors, one of the following
+ * Return Value: On success, 0 is returned. On errors, one of the following
  * negative error code is returned.
  *
  * %-EROFS - Read only filesystem.
-- 
1.8.3.1

