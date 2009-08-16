From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 5/7] nilfs2: add update functions of virtual
	block address to dat
Date: Sun, 16 Aug 2009 15:51:08 +0900
Message-ID: <1250405470-23326-6-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1250405470-23326-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1250405470-23326-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This is a preparation for the successive cleanup ("nilfs2: allow btree
to directly call dat operations").

This adds functions bundling a few operations to change an entry of
virtual block address on the dat file.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/bmap.c |   27 +++++++--------------------
 fs/nilfs2/dat.c  |   31 +++++++++++++++++++++++++++++++
 fs/nilfs2/dat.h  |    6 ++++++
 3 files changed, 44 insertions(+), 20 deletions(-)

diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
index 99d58a0..13e95a9 100644
--- a/fs/nilfs2/bmap.c
+++ b/fs/nilfs2/bmap.c
@@ -533,38 +533,25 @@ int nilfs_bmap_prepare_update_v(struct nilfs_bmap *bmap,
 				union nilfs_bmap_ptr_req *oldreq,
 				union nilfs_bmap_ptr_req *newreq)
 {
-	struct inode *dat = nilfs_bmap_get_dat(bmap);
-	int ret;
-
-	ret = nilfs_dat_prepare_end(dat, &oldreq->bpr_req);
-	if (ret < 0)
-		return ret;
-	ret = nilfs_dat_prepare_alloc(dat, &newreq->bpr_req);
-	if (ret < 0)
-		nilfs_dat_abort_end(dat, &oldreq->bpr_req);
-
-	return ret;
+	return nilfs_dat_prepare_update(nilfs_bmap_get_dat(bmap),
+					&oldreq->bpr_req, &newreq->bpr_req);
 }
 
 void nilfs_bmap_commit_update_v(struct nilfs_bmap *bmap,
 				union nilfs_bmap_ptr_req *oldreq,
 				union nilfs_bmap_ptr_req *newreq)
 {
-	struct inode *dat = nilfs_bmap_get_dat(bmap);
-
-	nilfs_dat_commit_end(dat, &oldreq->bpr_req,
-			     bmap->b_ptr_type == NILFS_BMAP_PTR_VS);
-	nilfs_dat_commit_alloc(dat, &newreq->bpr_req);
+	nilfs_dat_commit_update(nilfs_bmap_get_dat(bmap),
+				&oldreq->bpr_req, &newreq->bpr_req,
+				bmap->b_ptr_type == NILFS_BMAP_PTR_VS);
 }
 
 void nilfs_bmap_abort_update_v(struct nilfs_bmap *bmap,
 			       union nilfs_bmap_ptr_req *oldreq,
 			       union nilfs_bmap_ptr_req *newreq)
 {
-	struct inode *dat = nilfs_bmap_get_dat(bmap);
-
-	nilfs_dat_abort_end(dat, &oldreq->bpr_req);
-	nilfs_dat_abort_alloc(dat, &newreq->bpr_req);
+	nilfs_dat_abort_update(nilfs_bmap_get_dat(bmap),
+			       &oldreq->bpr_req, &newreq->bpr_req);
 }
 
 static struct lock_class_key nilfs_bmap_dat_lock_key;
diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index 1cfcc1a..1ff8e15 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -211,6 +211,37 @@ void nilfs_dat_abort_end(struct inode *dat, struct nilfs_palloc_req *req)
 	nilfs_dat_abort_entry(dat, req);
 }
 
+int nilfs_dat_prepare_update(struct inode *dat,
+			     struct nilfs_palloc_req *oldreq,
+			     struct nilfs_palloc_req *newreq)
+{
+	int ret;
+
+	ret = nilfs_dat_prepare_end(dat, oldreq);
+	if (!ret) {
+		ret = nilfs_dat_prepare_alloc(dat, newreq);
+		if (ret < 0)
+			nilfs_dat_abort_end(dat, oldreq);
+	}
+	return ret;
+}
+
+void nilfs_dat_commit_update(struct inode *dat,
+			     struct nilfs_palloc_req *oldreq,
+			     struct nilfs_palloc_req *newreq, int dead)
+{
+	nilfs_dat_commit_end(dat, oldreq, dead);
+	nilfs_dat_commit_alloc(dat, newreq);
+}
+
+void nilfs_dat_abort_update(struct inode *dat,
+			    struct nilfs_palloc_req *oldreq,
+			    struct nilfs_palloc_req *newreq)
+{
+	nilfs_dat_abort_end(dat, oldreq);
+	nilfs_dat_abort_alloc(dat, newreq);
+}
+
 /**
  * nilfs_dat_mark_dirty -
  * @dat: DAT file inode
diff --git a/fs/nilfs2/dat.h b/fs/nilfs2/dat.h
index 91dc337..406070d 100644
--- a/fs/nilfs2/dat.h
+++ b/fs/nilfs2/dat.h
@@ -41,6 +41,12 @@ void nilfs_dat_commit_start(struct inode *, struct nilfs_palloc_req *,
 int nilfs_dat_prepare_end(struct inode *, struct nilfs_palloc_req *);
 void nilfs_dat_commit_end(struct inode *, struct nilfs_palloc_req *, int);
 void nilfs_dat_abort_end(struct inode *, struct nilfs_palloc_req *);
+int nilfs_dat_prepare_update(struct inode *, struct nilfs_palloc_req *,
+			     struct nilfs_palloc_req *);
+void nilfs_dat_commit_update(struct inode *, struct nilfs_palloc_req *,
+			     struct nilfs_palloc_req *, int);
+void nilfs_dat_abort_update(struct inode *, struct nilfs_palloc_req *,
+			    struct nilfs_palloc_req *);
 
 int nilfs_dat_mark_dirty(struct inode *, __u64);
 int nilfs_dat_freev(struct inode *, __u64 *, size_t);
-- 
1.6.3.4
