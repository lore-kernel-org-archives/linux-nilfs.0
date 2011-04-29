From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs_cleanerd: make gc safe for duplicate invocation
Date: Fri, 29 Apr 2011 12:24:28 +0900
Message-ID: <1304047468-1250-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This enlarges the region that a garbage collection lock protects so
that read/write phases of GC do not interleave.

This makes gc safe even if two or more cleaner daemons are
accidentally invoked and they run in parallel.

Duplicate invocation of cleaner is avoidable by introducing another
lock primitive, but we don't choose that way now for simplicity.

Reported-by: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reported-by: Ivan Telichko <itelichko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 sbin/cleanerd/cleanerd.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
index b0a77fe..303c265 100644
--- a/sbin/cleanerd/cleanerd.c
+++ b/sbin/cleanerd/cleanerd.c
@@ -945,20 +945,20 @@ static ssize_t nilfs_cleanerd_clean_segments(struct nilfs_cleanerd *cleanerd,
 	    vblocknrv == NULL)
 		goto out_vec;
 
+	ret = nilfs_lock_cleaner(cleanerd->c_nilfs);
+	if (ret < 0)
+		goto out_vec;
+
 	n = nilfs_cleanerd_acc_blocks(cleanerd, sustat, segnums, nsegs,
 				      vdescv, bdescv);
 	if (n <= 0) {
 		ret = n;
-		goto out_vec;
+		goto out_lock;
 	}
 
 	ret = nilfs_cleanerd_get_vdesc(cleanerd, vdescv);
 	if (ret < 0)
-		goto out_vec;
-
-	ret = nilfs_lock_cleaner(cleanerd->c_nilfs);
-	if (ret < 0)
-		goto out_vec;
+		goto out_lock;
 
 	ret = nilfs_cleanerd_update_prottime(cleanerd, prottime);
 	if (ret < 0)
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
