From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v2] nilfs_cleanerd: make gc safe for duplicate
 invocation
Date: Fri, 29 Apr 2011 18:08:46 +0900 (JST)
Message-ID: <20110429.180846.27796830.ryusuke@osrg.net>
References: <1304065125-9532-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1304065125-9532-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 29 Apr 2011 17:18:45 +0900, Ryusuke Konishi wrote:
> This enlarges the region that a garbage collection lock protects so
> that indivisible steps of garbage collection do not interleave.
> Target segments are selected outside the critical section, so this
> also reexamines the selected segments after having acquired the lock.
> 
> This makes gc safe even if two or more cleaner daemons are
> accidentally invoked and they run in parallel.
> 
> Reported-by: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Reported-by: Ivan Telichko <itelichko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This patch does not apply as is to nilfs-utils 2.0.21 and prior
versions.

Here is a modified patch for them.

Ryusuke Konishi
--
From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

nilfs_cleanerd: make gc safe for duplicate invocation

This enlarges the region that a garbage collection lock protects so
that indivisible steps of garbage collection do not interleave.
Target segments are selected outside the critical section, so this
also reexamines the selected segments after having acquired the lock.

This makes gc safe even if two or more cleaner daemons are
accidentally invoked and they run in parallel.

[modified for nilfs-utils 2.0.21 and prior versions]

Reported-by: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reported-by: Ivan Telichko <itelichko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 sbin/cleanerd/cleanerd.c |   34 +++++++++++++++++++++++++---------
 1 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
index 1f03cfb..2875f2e 100644
--- a/sbin/cleanerd/cleanerd.c
+++ b/sbin/cleanerd/cleanerd.c
@@ -241,6 +241,12 @@ static int nilfs_comp_segimp(const void *elem1, const void *elem2)
 	return (segimp1->si_segnum < segimp2->si_segnum) ? -1 : 1;
 }
 
+static int nilfs_suinfo_reclaimable(const struct nilfs_suinfo *si)
+{
+	return nilfs_suinfo_dirty(si) &&
+		!nilfs_suinfo_active(si) && !nilfs_suinfo_error(si);
+}
+
 #define NILFS_CLEANERD_NSUINFO	512
 #define NILFS_CLEANERD_NULLTIME (~(__u64)0)
 
@@ -300,9 +306,7 @@ nilfs_cleanerd_select_segments(struct nilfs_cleanerd *cleanerd,
 			goto out;
 		}
 		for (i = 0; i < n; i++) {
-			if (nilfs_suinfo_dirty(&si[i]) &&
-			    !nilfs_suinfo_active(&si[i]) &&
-			    !nilfs_suinfo_error(&si[i]) &&
+			if (nilfs_suinfo_reclaimable(&si[i]) &&
 			    ((imp = (*config->cf_selection_policy.p_importance)(&si[i])) < thr)) {
 				if (si[i].sui_lastmod < oldest)
 					oldest = si[i].sui_lastmod;
@@ -547,6 +551,18 @@ static ssize_t nilfs_cleanerd_acc_blocks(struct nilfs_cleanerd *cleanerd,
 	while (i < n) {
 		if (nilfs_get_suinfo(nilfs, segnums[i], &si, 1) < 0)
 			return -1;
+
+		if (!nilfs_suinfo_reclaimable(&si)) {
+			/*
+			 * Recheck status of the segment and drop it
+			 * if not reclaimable.  This prevents the
+			 * target segments from being cleaned twice or
+			 * more by duplicate cleaner daemons.
+			 */
+			n = nilfs_deselect_segment(segnums, n, i);
+			continue;
+		}
+
 		if (nilfs_get_segment(nilfs, segnums[i], &segment) < 0)
 			return -1;
 
@@ -943,20 +959,20 @@ static ssize_t nilfs_cleanerd_clean_segments(struct nilfs_cleanerd *cleanerd,
 	    vblocknrv == NULL)
 		goto out_vec;
 
+	ret = nilfs_lock_write(cleanerd->c_nilfs);
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
-	ret = nilfs_lock_write(cleanerd->c_nilfs);
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
