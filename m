From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 12/17] nilfs2: remove bmap pointer operations
Date: Mon, 25 May 2009 19:18:16 +0900
Message-ID: <1243246701-5193-13-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1243246701-5193-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1243246701-5193-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
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

Previously, the bmap codes of nilfs used three types of function
tables.  The abuse of indirect function calls decreased source
readability and suffered many indirect jumps which would confuse
branch prediction of processors.

This eliminates one type of the function tables,
nilfs_bmap_ptr_operations, which was used to dispatch low level
pointer operations of the nilfs bmap.

This adds a new integer variable "b_ptr_type" to nilfs_bmap struct,
and uses the value to select the pointer operations.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/bmap.c   |  181 +++++++++++++++-------------------------------------
 fs/nilfs2/bmap.h   |  110 ++++++++++++++++++++++---------
 fs/nilfs2/btree.c  |  100 +++++++++++++----------------
 fs/nilfs2/direct.c |   30 +++------
 4 files changed, 187 insertions(+), 234 deletions(-)

diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
index de67d2a..51824c7 100644
--- a/fs/nilfs2/bmap.c
+++ b/fs/nilfs2/bmap.c
@@ -31,21 +31,26 @@
 #include "dat.h"
 #include "alloc.h"
 
+static struct inode *nilfs_bmap_get_dat(const struct nilfs_bmap *bmap)
+{
+	return nilfs_dat_inode(NILFS_I_NILFS(bmap->b_inode));
+}
+
 int nilfs_bmap_lookup_at_level(struct nilfs_bmap *bmap, __u64 key, int level,
 			       __u64 *ptrp)
 {
-	__u64 ptr;
+	sector_t blocknr;
 	int ret;
 
 	down_read(&bmap->b_sem);
 	ret = bmap->b_ops->bop_lookup(bmap, key, level, ptrp);
 	if (ret < 0)
 		goto out;
-	if (bmap->b_pops->bpop_translate != NULL) {
-		ret = bmap->b_pops->bpop_translate(bmap, *ptrp, &ptr);
-		if (ret < 0)
-			goto out;
-		*ptrp = ptr;
+	if (NILFS_BMAP_USE_VBN(bmap)) {
+		ret = nilfs_dat_translate(nilfs_bmap_get_dat(bmap), *ptrp,
+					  &blocknr);
+		if (!ret)
+			*ptrp = blocknr;
 	}
 
  out:
@@ -442,11 +447,6 @@ __u64 nilfs_bmap_find_target_seq(const struct nilfs_bmap *bmap, __u64 key)
 		return NILFS_BMAP_INVALID_PTR;
 }
 
-static struct inode *nilfs_bmap_get_dat(const struct nilfs_bmap *bmap)
-{
-	return nilfs_dat_inode(NILFS_I_NILFS(bmap->b_inode));
-}
-
 #define NILFS_BMAP_GROUP_DIV	8
 __u64 nilfs_bmap_find_target_in_group(const struct nilfs_bmap *bmap)
 {
@@ -459,20 +459,20 @@ __u64 nilfs_bmap_find_target_in_group(const struct nilfs_bmap *bmap)
 		(entries_per_group / NILFS_BMAP_GROUP_DIV);
 }
 
-static int nilfs_bmap_prepare_alloc_v(struct nilfs_bmap *bmap,
-				      union nilfs_bmap_ptr_req *req)
+int nilfs_bmap_prepare_alloc_v(struct nilfs_bmap *bmap,
+				 union nilfs_bmap_ptr_req *req)
 {
 	return nilfs_dat_prepare_alloc(nilfs_bmap_get_dat(bmap), &req->bpr_req);
 }
 
-static void nilfs_bmap_commit_alloc_v(struct nilfs_bmap *bmap,
-				      union nilfs_bmap_ptr_req *req)
+void nilfs_bmap_commit_alloc_v(struct nilfs_bmap *bmap,
+				 union nilfs_bmap_ptr_req *req)
 {
 	nilfs_dat_commit_alloc(nilfs_bmap_get_dat(bmap), &req->bpr_req);
 }
 
-static void nilfs_bmap_abort_alloc_v(struct nilfs_bmap *bmap,
-				     union nilfs_bmap_ptr_req *req)
+void nilfs_bmap_abort_alloc_v(struct nilfs_bmap *bmap,
+			      union nilfs_bmap_ptr_req *req)
 {
 	nilfs_dat_abort_alloc(nilfs_bmap_get_dat(bmap), &req->bpr_req);
 }
@@ -489,26 +489,21 @@ int nilfs_bmap_start_v(struct nilfs_bmap *bmap, union nilfs_bmap_ptr_req *req,
 	return ret;
 }
 
-static int nilfs_bmap_prepare_end_v(struct nilfs_bmap *bmap,
-				    union nilfs_bmap_ptr_req *req)
+int nilfs_bmap_prepare_end_v(struct nilfs_bmap *bmap,
+			     union nilfs_bmap_ptr_req *req)
 {
 	return nilfs_dat_prepare_end(nilfs_bmap_get_dat(bmap), &req->bpr_req);
 }
 
-static void nilfs_bmap_commit_end_v(struct nilfs_bmap *bmap,
-				    union nilfs_bmap_ptr_req *req)
-{
-	nilfs_dat_commit_end(nilfs_bmap_get_dat(bmap), &req->bpr_req, 0);
-}
-
-static void nilfs_bmap_commit_end_vmdt(struct nilfs_bmap *bmap,
-				       union nilfs_bmap_ptr_req *req)
+void nilfs_bmap_commit_end_v(struct nilfs_bmap *bmap,
+			     union nilfs_bmap_ptr_req *req)
 {
-	nilfs_dat_commit_end(nilfs_bmap_get_dat(bmap), &req->bpr_req, 1);
+	nilfs_dat_commit_end(nilfs_bmap_get_dat(bmap), &req->bpr_req,
+			     bmap->b_ptr_type == NILFS_BMAP_PTR_VS);
 }
 
-static void nilfs_bmap_abort_end_v(struct nilfs_bmap *bmap,
-				   union nilfs_bmap_ptr_req *req)
+void nilfs_bmap_abort_end_v(struct nilfs_bmap *bmap,
+			    union nilfs_bmap_ptr_req *req)
 {
 	nilfs_dat_abort_end(nilfs_bmap_get_dat(bmap), &req->bpr_req);
 }
@@ -524,116 +519,44 @@ int nilfs_bmap_mark_dirty(const struct nilfs_bmap *bmap, __u64 vblocknr)
 	return nilfs_dat_mark_dirty(nilfs_bmap_get_dat(bmap), vblocknr);
 }
 
-int nilfs_bmap_prepare_update(struct nilfs_bmap *bmap,
-			      union nilfs_bmap_ptr_req *oldreq,
-			      union nilfs_bmap_ptr_req *newreq)
+int nilfs_bmap_prepare_update_v(struct nilfs_bmap *bmap,
+				union nilfs_bmap_ptr_req *oldreq,
+				union nilfs_bmap_ptr_req *newreq)
 {
+	struct inode *dat = nilfs_bmap_get_dat(bmap);
 	int ret;
 
-	ret = bmap->b_pops->bpop_prepare_end_ptr(bmap, oldreq);
+	ret = nilfs_dat_prepare_end(dat, &oldreq->bpr_req);
 	if (ret < 0)
 		return ret;
-	ret = bmap->b_pops->bpop_prepare_alloc_ptr(bmap, newreq);
+	ret = nilfs_dat_prepare_alloc(dat, &newreq->bpr_req);
 	if (ret < 0)
-		bmap->b_pops->bpop_abort_end_ptr(bmap, oldreq);
+		nilfs_dat_abort_end(dat, &oldreq->bpr_req);
 
 	return ret;
 }
 
-void nilfs_bmap_commit_update(struct nilfs_bmap *bmap,
-			      union nilfs_bmap_ptr_req *oldreq,
-			      union nilfs_bmap_ptr_req *newreq)
-{
-	bmap->b_pops->bpop_commit_end_ptr(bmap, oldreq);
-	bmap->b_pops->bpop_commit_alloc_ptr(bmap, newreq);
-}
-
-void nilfs_bmap_abort_update(struct nilfs_bmap *bmap,
-			     union nilfs_bmap_ptr_req *oldreq,
-			     union nilfs_bmap_ptr_req *newreq)
-{
-	bmap->b_pops->bpop_abort_end_ptr(bmap, oldreq);
-	bmap->b_pops->bpop_abort_alloc_ptr(bmap, newreq);
-}
-
-static int nilfs_bmap_translate_v(const struct nilfs_bmap *bmap, __u64 ptr,
-				  __u64 *ptrp)
+void nilfs_bmap_commit_update_v(struct nilfs_bmap *bmap,
+				union nilfs_bmap_ptr_req *oldreq,
+				union nilfs_bmap_ptr_req *newreq)
 {
-	sector_t blocknr;
-	int ret;
-
-	ret = nilfs_dat_translate(nilfs_bmap_get_dat(bmap), ptr, &blocknr);
-	if (ret < 0)
-		return ret;
-	if (ptrp != NULL)
-		*ptrp = blocknr;
-	return 0;
-}
+	struct inode *dat = nilfs_bmap_get_dat(bmap);
 
-static int nilfs_bmap_prepare_alloc_p(struct nilfs_bmap *bmap,
-				      union nilfs_bmap_ptr_req *req)
-{
-	/* ignore target ptr */
-	req->bpr_ptr = bmap->b_last_allocated_ptr++;
-	return 0;
+	nilfs_dat_commit_end(dat, &oldreq->bpr_req,
+			     bmap->b_ptr_type == NILFS_BMAP_PTR_VS);
+	nilfs_dat_commit_alloc(dat, &newreq->bpr_req);
 }
 
-static void nilfs_bmap_commit_alloc_p(struct nilfs_bmap *bmap,
-				      union nilfs_bmap_ptr_req *req)
+void nilfs_bmap_abort_update_v(struct nilfs_bmap *bmap,
+			       union nilfs_bmap_ptr_req *oldreq,
+			       union nilfs_bmap_ptr_req *newreq)
 {
-	/* do nothing */
-}
+	struct inode *dat = nilfs_bmap_get_dat(bmap);
 
-static void nilfs_bmap_abort_alloc_p(struct nilfs_bmap *bmap,
-				     union nilfs_bmap_ptr_req *req)
-{
-	bmap->b_last_allocated_ptr--;
+	nilfs_dat_abort_end(dat, &oldreq->bpr_req);
+	nilfs_dat_abort_alloc(dat, &newreq->bpr_req);
 }
 
-static const struct nilfs_bmap_ptr_operations nilfs_bmap_ptr_ops_v = {
-	.bpop_prepare_alloc_ptr	=	nilfs_bmap_prepare_alloc_v,
-	.bpop_commit_alloc_ptr	=	nilfs_bmap_commit_alloc_v,
-	.bpop_abort_alloc_ptr	=	nilfs_bmap_abort_alloc_v,
-	.bpop_prepare_end_ptr	=	nilfs_bmap_prepare_end_v,
-	.bpop_commit_end_ptr	=	nilfs_bmap_commit_end_v,
-	.bpop_abort_end_ptr	=	nilfs_bmap_abort_end_v,
-
-	.bpop_translate		=	nilfs_bmap_translate_v,
-};
-
-static const struct nilfs_bmap_ptr_operations nilfs_bmap_ptr_ops_vmdt = {
-	.bpop_prepare_alloc_ptr	=	nilfs_bmap_prepare_alloc_v,
-	.bpop_commit_alloc_ptr	=	nilfs_bmap_commit_alloc_v,
-	.bpop_abort_alloc_ptr	=	nilfs_bmap_abort_alloc_v,
-	.bpop_prepare_end_ptr	=	nilfs_bmap_prepare_end_v,
-	.bpop_commit_end_ptr	=	nilfs_bmap_commit_end_vmdt,
-	.bpop_abort_end_ptr	=	nilfs_bmap_abort_end_v,
-
-	.bpop_translate		=	nilfs_bmap_translate_v,
-};
-
-static const struct nilfs_bmap_ptr_operations nilfs_bmap_ptr_ops_p = {
-	.bpop_prepare_alloc_ptr	=	nilfs_bmap_prepare_alloc_p,
-	.bpop_commit_alloc_ptr	=	nilfs_bmap_commit_alloc_p,
-	.bpop_abort_alloc_ptr	=	nilfs_bmap_abort_alloc_p,
-	.bpop_prepare_end_ptr	=	NULL,
-	.bpop_commit_end_ptr	=	NULL,
-	.bpop_abort_end_ptr	=	NULL,
-
-	.bpop_translate		=	NULL,
-};
-
-static const struct nilfs_bmap_ptr_operations nilfs_bmap_ptr_ops_gc = {
-	.bpop_prepare_alloc_ptr	=	NULL,
-	.bpop_commit_alloc_ptr	=	NULL,
-	.bpop_abort_alloc_ptr	=	NULL,
-	.bpop_prepare_end_ptr	=	NULL,
-	.bpop_commit_end_ptr	=	NULL,
-	.bpop_abort_end_ptr	=	NULL,
-
-	.bpop_translate		=	NULL,
-};
-
 static struct lock_class_key nilfs_bmap_dat_lock_key;
 
 /**
@@ -660,20 +583,20 @@ int nilfs_bmap_read(struct nilfs_bmap *bmap, struct nilfs_inode *raw_inode)
 	bmap->b_inode = &NILFS_BMAP_I(bmap)->vfs_inode;
 	switch (bmap->b_inode->i_ino) {
 	case NILFS_DAT_INO:
-		bmap->b_pops = &nilfs_bmap_ptr_ops_p;
-		bmap->b_last_allocated_key = 0;	/* XXX: use macro */
+		bmap->b_ptr_type = NILFS_BMAP_PTR_P;
+		bmap->b_last_allocated_key = 0;
 		bmap->b_last_allocated_ptr = NILFS_BMAP_NEW_PTR_INIT;
 		lockdep_set_class(&bmap->b_sem, &nilfs_bmap_dat_lock_key);
 		break;
 	case NILFS_CPFILE_INO:
 	case NILFS_SUFILE_INO:
-		bmap->b_pops = &nilfs_bmap_ptr_ops_vmdt;
-		bmap->b_last_allocated_key = 0;	/* XXX: use macro */
+		bmap->b_ptr_type = NILFS_BMAP_PTR_VS;
+		bmap->b_last_allocated_key = 0;
 		bmap->b_last_allocated_ptr = NILFS_BMAP_INVALID_PTR;
 		break;
 	default:
-		bmap->b_pops = &nilfs_bmap_ptr_ops_v;
-		bmap->b_last_allocated_key = 0;	/* XXX: use macro */
+		bmap->b_ptr_type = NILFS_BMAP_PTR_VM;
+		bmap->b_last_allocated_key = 0;
 		bmap->b_last_allocated_ptr = NILFS_BMAP_INVALID_PTR;
 		break;
 	}
@@ -705,7 +628,7 @@ void nilfs_bmap_init_gc(struct nilfs_bmap *bmap)
 	memset(&bmap->b_u, 0, NILFS_BMAP_SIZE);
 	init_rwsem(&bmap->b_sem);
 	bmap->b_inode = &NILFS_BMAP_I(bmap)->vfs_inode;
-	bmap->b_pops = &nilfs_bmap_ptr_ops_gc;
+	bmap->b_ptr_type = NILFS_BMAP_PTR_U;
 	bmap->b_last_allocated_key = 0;
 	bmap->b_last_allocated_ptr = NILFS_BMAP_INVALID_PTR;
 	bmap->b_state = 0;
diff --git a/fs/nilfs2/bmap.h b/fs/nilfs2/bmap.h
index 28c77bb..47f5b74 100644
--- a/fs/nilfs2/bmap.h
+++ b/fs/nilfs2/bmap.h
@@ -86,27 +86,6 @@ struct nilfs_bmap_operations {
 };
 
 
-/**
- * struct nilfs_bmap_ptr_operations - bmap ptr operation table
- */
-struct nilfs_bmap_ptr_operations {
-	int (*bpop_prepare_alloc_ptr)(struct nilfs_bmap *,
-				      union nilfs_bmap_ptr_req *);
-	void (*bpop_commit_alloc_ptr)(struct nilfs_bmap *,
-				      union nilfs_bmap_ptr_req *);
-	void (*bpop_abort_alloc_ptr)(struct nilfs_bmap *,
-				     union nilfs_bmap_ptr_req *);
-	int (*bpop_prepare_end_ptr)(struct nilfs_bmap *,
-				    union nilfs_bmap_ptr_req *);
-	void (*bpop_commit_end_ptr)(struct nilfs_bmap *,
-				    union nilfs_bmap_ptr_req *);
-	void (*bpop_abort_end_ptr)(struct nilfs_bmap *,
-				   union nilfs_bmap_ptr_req *);
-
-	int (*bpop_translate)(const struct nilfs_bmap *, __u64, __u64 *);
-};
-
-
 #define NILFS_BMAP_SIZE		(NILFS_INODE_BMAP_SIZE * sizeof(__le64))
 #define NILFS_BMAP_KEY_BIT	(sizeof(unsigned long) * 8 /* CHAR_BIT */)
 #define NILFS_BMAP_NEW_PTR_INIT	\
@@ -124,9 +103,9 @@ static inline int nilfs_bmap_is_new_ptr(unsigned long ptr)
  * @b_sem: semaphore
  * @b_inode: owner of bmap
  * @b_ops: bmap operation table
- * @b_pops: bmap ptr operation table
  * @b_last_allocated_key: last allocated key for data block
  * @b_last_allocated_ptr: last allocated ptr for data block
+ * @b_ptr_type: pointer type
  * @b_state: state
  */
 struct nilfs_bmap {
@@ -137,12 +116,22 @@ struct nilfs_bmap {
 	struct rw_semaphore b_sem;
 	struct inode *b_inode;
 	const struct nilfs_bmap_operations *b_ops;
-	const struct nilfs_bmap_ptr_operations *b_pops;
 	__u64 b_last_allocated_key;
 	__u64 b_last_allocated_ptr;
+	int b_ptr_type;
 	int b_state;
 };
 
+/* pointer type */
+#define NILFS_BMAP_PTR_P	0	/* physical block number (i.e. LBN) */
+#define NILFS_BMAP_PTR_VS	1	/* virtual block number (single
+					   version) */
+#define NILFS_BMAP_PTR_VM	2	/* virtual block number (has multiple
+					   versions) */
+#define NILFS_BMAP_PTR_U	(-1)	/* never perform pointer operations */
+
+#define NILFS_BMAP_USE_VBN(bmap)	((bmap)->b_ptr_type > 0)
+
 /* state */
 #define NILFS_BMAP_DIRTY	0x00000001
 
@@ -171,6 +160,63 @@ void nilfs_bmap_commit_gcdat(struct nilfs_bmap *, struct nilfs_bmap *);
 /*
  * Internal use only
  */
+int nilfs_bmap_prepare_alloc_v(struct nilfs_bmap *,
+			       union nilfs_bmap_ptr_req *);
+void nilfs_bmap_commit_alloc_v(struct nilfs_bmap *,
+			       union nilfs_bmap_ptr_req *);
+void nilfs_bmap_abort_alloc_v(struct nilfs_bmap *,
+			      union nilfs_bmap_ptr_req *);
+
+static inline int nilfs_bmap_prepare_alloc_ptr(struct nilfs_bmap *bmap,
+					       union nilfs_bmap_ptr_req *req)
+{
+	if (NILFS_BMAP_USE_VBN(bmap))
+		return nilfs_bmap_prepare_alloc_v(bmap, req);
+	/* ignore target ptr */
+	req->bpr_ptr = bmap->b_last_allocated_ptr++;
+	return 0;
+}
+
+static inline void nilfs_bmap_commit_alloc_ptr(struct nilfs_bmap *bmap,
+					       union nilfs_bmap_ptr_req *req)
+{
+	if (NILFS_BMAP_USE_VBN(bmap))
+		nilfs_bmap_commit_alloc_v(bmap, req);
+}
+
+static inline void nilfs_bmap_abort_alloc_ptr(struct nilfs_bmap *bmap,
+					      union nilfs_bmap_ptr_req *req)
+{
+	if (NILFS_BMAP_USE_VBN(bmap))
+		nilfs_bmap_abort_alloc_v(bmap, req);
+	else
+		bmap->b_last_allocated_ptr--;
+}
+
+int nilfs_bmap_prepare_end_v(struct nilfs_bmap *, union nilfs_bmap_ptr_req *);
+void nilfs_bmap_commit_end_v(struct nilfs_bmap *, union nilfs_bmap_ptr_req *);
+void nilfs_bmap_abort_end_v(struct nilfs_bmap *, union nilfs_bmap_ptr_req *);
+
+static inline int nilfs_bmap_prepare_end_ptr(struct nilfs_bmap *bmap,
+					     union nilfs_bmap_ptr_req *req)
+{
+	return NILFS_BMAP_USE_VBN(bmap) ?
+		nilfs_bmap_prepare_end_v(bmap, req) : 0;
+}
+
+static inline void nilfs_bmap_commit_end_ptr(struct nilfs_bmap *bmap,
+					     union nilfs_bmap_ptr_req *req)
+{
+	if (NILFS_BMAP_USE_VBN(bmap))
+		nilfs_bmap_commit_end_v(bmap, req);
+}
+
+static inline void nilfs_bmap_abort_end_ptr(struct nilfs_bmap *bmap,
+					    union nilfs_bmap_ptr_req *req)
+{
+	if (NILFS_BMAP_USE_VBN(bmap))
+		nilfs_bmap_abort_end_v(bmap, req);
+}
 
 int nilfs_bmap_start_v(struct nilfs_bmap *, union nilfs_bmap_ptr_req *,
 		       sector_t);
@@ -184,15 +230,15 @@ __u64 nilfs_bmap_data_get_key(const struct nilfs_bmap *,
 __u64 nilfs_bmap_find_target_seq(const struct nilfs_bmap *, __u64);
 __u64 nilfs_bmap_find_target_in_group(const struct nilfs_bmap *);
 
-int nilfs_bmap_prepare_update(struct nilfs_bmap *,
-			      union nilfs_bmap_ptr_req *,
-			      union nilfs_bmap_ptr_req *);
-void nilfs_bmap_commit_update(struct nilfs_bmap *,
-			      union nilfs_bmap_ptr_req *,
-			      union nilfs_bmap_ptr_req *);
-void nilfs_bmap_abort_update(struct nilfs_bmap *,
-			     union nilfs_bmap_ptr_req *,
-			     union nilfs_bmap_ptr_req *);
+int nilfs_bmap_prepare_update_v(struct nilfs_bmap *,
+				union nilfs_bmap_ptr_req *,
+				union nilfs_bmap_ptr_req *);
+void nilfs_bmap_commit_update_v(struct nilfs_bmap *,
+				union nilfs_bmap_ptr_req *,
+				union nilfs_bmap_ptr_req *);
+void nilfs_bmap_abort_update_v(struct nilfs_bmap *,
+			       union nilfs_bmap_ptr_req *,
+			       union nilfs_bmap_ptr_req *);
 
 void nilfs_bmap_add_blocks(const struct nilfs_bmap *, int);
 void nilfs_bmap_sub_blocks(const struct nilfs_bmap *, int);
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index f5a0ec6..20e3fd0 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -917,8 +917,8 @@ static int nilfs_btree_prepare_insert(struct nilfs_btree *btree,
 		path[level].bp_newreq.bpr_ptr =
 			btree->bt_ops->btop_find_target(btree, path, key);
 
-	ret = btree->bt_bmap.b_pops->bpop_prepare_alloc_ptr(
-		&btree->bt_bmap, &path[level].bp_newreq);
+	ret = nilfs_bmap_prepare_alloc_ptr(&btree->bt_bmap,
+					   &path[level].bp_newreq);
 	if (ret < 0)
 		goto err_out_data;
 
@@ -976,8 +976,8 @@ static int nilfs_btree_prepare_insert(struct nilfs_btree *btree,
 		/* split */
 		path[level].bp_newreq.bpr_ptr =
 			path[level - 1].bp_newreq.bpr_ptr + 1;
-		ret = btree->bt_bmap.b_pops->bpop_prepare_alloc_ptr(
-			&btree->bt_bmap, &path[level].bp_newreq);
+		ret = nilfs_bmap_prepare_alloc_ptr(&btree->bt_bmap,
+						   &path[level].bp_newreq);
 		if (ret < 0)
 			goto err_out_child_node;
 		ret = nilfs_btree_get_new_block(btree,
@@ -1008,8 +1008,8 @@ static int nilfs_btree_prepare_insert(struct nilfs_btree *btree,
 
 	/* grow */
 	path[level].bp_newreq.bpr_ptr = path[level - 1].bp_newreq.bpr_ptr + 1;
-	ret = btree->bt_bmap.b_pops->bpop_prepare_alloc_ptr(
-		&btree->bt_bmap, &path[level].bp_newreq);
+	ret = nilfs_bmap_prepare_alloc_ptr(&btree->bt_bmap,
+					   &path[level].bp_newreq);
 	if (ret < 0)
 		goto err_out_child_node;
 	ret = nilfs_btree_get_new_block(btree, path[level].bp_newreq.bpr_ptr,
@@ -1037,18 +1037,16 @@ static int nilfs_btree_prepare_insert(struct nilfs_btree *btree,
 
 	/* error */
  err_out_curr_node:
-	btree->bt_bmap.b_pops->bpop_abort_alloc_ptr(&btree->bt_bmap,
-						    &path[level].bp_newreq);
+	nilfs_bmap_abort_alloc_ptr(&btree->bt_bmap, &path[level].bp_newreq);
  err_out_child_node:
 	for (level--; level > NILFS_BTREE_LEVEL_DATA; level--) {
 		nilfs_btnode_delete(path[level].bp_sib_bh);
-		btree->bt_bmap.b_pops->bpop_abort_alloc_ptr(
-			&btree->bt_bmap, &path[level].bp_newreq);
+		nilfs_bmap_abort_alloc_ptr(&btree->bt_bmap,
+					   &path[level].bp_newreq);
 
 	}
 
-	btree->bt_bmap.b_pops->bpop_abort_alloc_ptr(&btree->bt_bmap,
-						       &path[level].bp_newreq);
+	nilfs_bmap_abort_alloc_ptr(&btree->bt_bmap, &path[level].bp_newreq);
  err_out_data:
 	*levelp = level;
 	stats->bs_nblocks = 0;
@@ -1067,8 +1065,8 @@ static void nilfs_btree_commit_insert(struct nilfs_btree *btree,
 		btree->bt_ops->btop_set_target(btree, key, ptr);
 
 	for (level = NILFS_BTREE_LEVEL_NODE_MIN; level <= maxlevel; level++) {
-		btree->bt_bmap.b_pops->bpop_commit_alloc_ptr(
-			&btree->bt_bmap, &path[level - 1].bp_newreq);
+		nilfs_bmap_commit_alloc_ptr(&btree->bt_bmap,
+					    &path[level - 1].bp_newreq);
 		path[level].bp_op(btree, path, level, &key, &ptr);
 	}
 
@@ -1312,12 +1310,10 @@ static int nilfs_btree_prepare_delete(struct nilfs_btree *btree,
 		path[level].bp_oldreq.bpr_ptr =
 			nilfs_btree_node_get_ptr(btree, node,
 						 path[level].bp_index);
-		if (btree->bt_bmap.b_pops->bpop_prepare_end_ptr != NULL) {
-			ret = btree->bt_bmap.b_pops->bpop_prepare_end_ptr(
-				&btree->bt_bmap, &path[level].bp_oldreq);
-			if (ret < 0)
-				goto err_out_child_node;
-		}
+		ret = nilfs_bmap_prepare_end_ptr(&btree->bt_bmap,
+						 &path[level].bp_oldreq);
+		if (ret < 0)
+			goto err_out_child_node;
 
 		if (nilfs_btree_node_get_nchildren(btree, node) >
 		    nilfs_btree_node_nchildren_min(btree, node)) {
@@ -1391,12 +1387,12 @@ static int nilfs_btree_prepare_delete(struct nilfs_btree *btree,
 	node = nilfs_btree_get_root(btree);
 	path[level].bp_oldreq.bpr_ptr =
 		nilfs_btree_node_get_ptr(btree, node, path[level].bp_index);
-	if (btree->bt_bmap.b_pops->bpop_prepare_end_ptr != NULL) {
-		ret = btree->bt_bmap.b_pops->bpop_prepare_end_ptr(
-			&btree->bt_bmap, &path[level].bp_oldreq);
-		if (ret < 0)
-			goto err_out_child_node;
-	}
+
+	ret = nilfs_bmap_prepare_end_ptr(&btree->bt_bmap,
+					 &path[level].bp_oldreq);
+	if (ret < 0)
+		goto err_out_child_node;
+
 	/* child of the root node is deleted */
 	path[level].bp_op = nilfs_btree_do_delete;
 	stats->bs_nblocks++;
@@ -1408,15 +1404,12 @@ static int nilfs_btree_prepare_delete(struct nilfs_btree *btree,
 
 	/* error */
  err_out_curr_node:
-	if (btree->bt_bmap.b_pops->bpop_abort_end_ptr != NULL)
-		btree->bt_bmap.b_pops->bpop_abort_end_ptr(
-			&btree->bt_bmap, &path[level].bp_oldreq);
+	nilfs_bmap_abort_end_ptr(&btree->bt_bmap, &path[level].bp_oldreq);
  err_out_child_node:
 	for (level--; level >= NILFS_BTREE_LEVEL_NODE_MIN; level--) {
 		brelse(path[level].bp_sib_bh);
-		if (btree->bt_bmap.b_pops->bpop_abort_end_ptr != NULL)
-			btree->bt_bmap.b_pops->bpop_abort_end_ptr(
-				&btree->bt_bmap, &path[level].bp_oldreq);
+		nilfs_bmap_abort_end_ptr(&btree->bt_bmap,
+					 &path[level].bp_oldreq);
 	}
 	*levelp = level;
 	stats->bs_nblocks = 0;
@@ -1430,9 +1423,8 @@ static void nilfs_btree_commit_delete(struct nilfs_btree *btree,
 	int level;
 
 	for (level = NILFS_BTREE_LEVEL_NODE_MIN; level <= maxlevel; level++) {
-		if (btree->bt_bmap.b_pops->bpop_commit_end_ptr != NULL)
-			btree->bt_bmap.b_pops->bpop_commit_end_ptr(
-				&btree->bt_bmap, &path[level].bp_oldreq);
+		nilfs_bmap_commit_end_ptr(&btree->bt_bmap,
+					  &path[level].bp_oldreq);
 		path[level].bp_op(btree, path, level, NULL, NULL);
 	}
 
@@ -1597,7 +1589,7 @@ nilfs_btree_prepare_convert_and_insert(struct nilfs_bmap *bmap, __u64 key,
 	if (btree->bt_ops->btop_find_target != NULL)
 		dreq->bpr_ptr
 			= btree->bt_ops->btop_find_target(btree, NULL, key);
-	ret = bmap->b_pops->bpop_prepare_alloc_ptr(bmap, dreq);
+	ret = nilfs_bmap_prepare_alloc_ptr(bmap, dreq);
 	if (ret < 0)
 		return ret;
 
@@ -1605,7 +1597,7 @@ nilfs_btree_prepare_convert_and_insert(struct nilfs_bmap *bmap, __u64 key,
 	stats->bs_nblocks++;
 	if (nreq != NULL) {
 		nreq->bpr_ptr = dreq->bpr_ptr + 1;
-		ret = bmap->b_pops->bpop_prepare_alloc_ptr(bmap, nreq);
+		ret = nilfs_bmap_prepare_alloc_ptr(bmap, nreq);
 		if (ret < 0)
 			goto err_out_dreq;
 
@@ -1622,9 +1614,9 @@ nilfs_btree_prepare_convert_and_insert(struct nilfs_bmap *bmap, __u64 key,
 
 	/* error */
  err_out_nreq:
-	bmap->b_pops->bpop_abort_alloc_ptr(bmap, nreq);
+	nilfs_bmap_abort_alloc_ptr(bmap, nreq);
  err_out_dreq:
-	bmap->b_pops->bpop_abort_alloc_ptr(bmap, dreq);
+	nilfs_bmap_abort_alloc_ptr(bmap, dreq);
 	stats->bs_nblocks = 0;
 	return ret;
 
@@ -1654,8 +1646,8 @@ nilfs_btree_commit_convert_and_insert(struct nilfs_bmap *bmap,
 	btree = (struct nilfs_btree *)bmap;
 	nilfs_btree_init(bmap);
 	if (nreq != NULL) {
-		bmap->b_pops->bpop_commit_alloc_ptr(bmap, dreq);
-		bmap->b_pops->bpop_commit_alloc_ptr(bmap, nreq);
+		nilfs_bmap_commit_alloc_ptr(bmap, dreq);
+		nilfs_bmap_commit_alloc_ptr(bmap, nreq);
 
 		/* create child node at level 1 */
 		lock_buffer(bh);
@@ -1677,7 +1669,7 @@ nilfs_btree_commit_convert_and_insert(struct nilfs_bmap *bmap,
 		nilfs_btree_node_init(btree, node, NILFS_BTREE_NODE_ROOT,
 				      2, 1, &keys[0], &tmpptr);
 	} else {
-		bmap->b_pops->bpop_commit_alloc_ptr(bmap, dreq);
+		nilfs_bmap_commit_alloc_ptr(bmap, dreq);
 
 		/* create root node at level 1 */
 		node = nilfs_btree_get_root(btree);
@@ -1758,9 +1750,9 @@ static int nilfs_btree_prepare_update_v(struct nilfs_btree *btree,
 		nilfs_btree_node_get_ptr(btree, parent,
 					 path[level + 1].bp_index);
 	path[level].bp_newreq.bpr_ptr = path[level].bp_oldreq.bpr_ptr + 1;
-	ret = nilfs_bmap_prepare_update(&btree->bt_bmap,
-					&path[level].bp_oldreq,
-					&path[level].bp_newreq);
+	ret = nilfs_bmap_prepare_update_v(&btree->bt_bmap,
+					  &path[level].bp_oldreq,
+					  &path[level].bp_newreq);
 	if (ret < 0)
 		return ret;
 
@@ -1772,9 +1764,9 @@ static int nilfs_btree_prepare_update_v(struct nilfs_btree *btree,
 			&NILFS_BMAP_I(&btree->bt_bmap)->i_btnode_cache,
 			&path[level].bp_ctxt);
 		if (ret < 0) {
-			nilfs_bmap_abort_update(&btree->bt_bmap,
-						&path[level].bp_oldreq,
-						&path[level].bp_newreq);
+			nilfs_bmap_abort_update_v(&btree->bt_bmap,
+						  &path[level].bp_oldreq,
+						  &path[level].bp_newreq);
 			return ret;
 		}
 	}
@@ -1788,9 +1780,9 @@ static void nilfs_btree_commit_update_v(struct nilfs_btree *btree,
 {
 	struct nilfs_btree_node *parent;
 
-	nilfs_bmap_commit_update(&btree->bt_bmap,
-				 &path[level].bp_oldreq,
-				 &path[level].bp_newreq);
+	nilfs_bmap_commit_update_v(&btree->bt_bmap,
+				   &path[level].bp_oldreq,
+				   &path[level].bp_newreq);
 
 	if (buffer_nilfs_node(path[level].bp_bh)) {
 		nilfs_btnode_commit_change_key(
@@ -1809,9 +1801,9 @@ static void nilfs_btree_abort_update_v(struct nilfs_btree *btree,
 				       struct nilfs_btree_path *path,
 				       int level)
 {
-	nilfs_bmap_abort_update(&btree->bt_bmap,
-				&path[level].bp_oldreq,
-				&path[level].bp_newreq);
+	nilfs_bmap_abort_update_v(&btree->bt_bmap,
+				  &path[level].bp_oldreq,
+				  &path[level].bp_newreq);
 	if (buffer_nilfs_node(path[level].bp_bh))
 		nilfs_btnode_abort_change_key(
 			&NILFS_BMAP_I(&btree->bt_bmap)->i_btnode_cache,
diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
index 8e8095c..2a546c8 100644
--- a/fs/nilfs2/direct.c
+++ b/fs/nilfs2/direct.c
@@ -92,8 +92,7 @@ static int nilfs_direct_prepare_insert(struct nilfs_direct *direct,
 
 	if (direct->d_ops->dop_find_target != NULL)
 		req->bpr_ptr = direct->d_ops->dop_find_target(direct, key);
-	ret = direct->d_bmap.b_pops->bpop_prepare_alloc_ptr(&direct->d_bmap,
-							       req);
+	ret = nilfs_bmap_prepare_alloc_ptr(&direct->d_bmap, req);
 	if (ret < 0)
 		return ret;
 
@@ -111,7 +110,7 @@ static void nilfs_direct_commit_insert(struct nilfs_direct *direct,
 	bh = (struct buffer_head *)((unsigned long)ptr);
 	set_buffer_nilfs_volatile(bh);
 
-	direct->d_bmap.b_pops->bpop_commit_alloc_ptr(&direct->d_bmap, req);
+	nilfs_bmap_commit_alloc_ptr(&direct->d_bmap, req);
 	nilfs_direct_set_ptr(direct, key, req->bpr_ptr);
 
 	if (!nilfs_bmap_dirty(&direct->d_bmap))
@@ -150,25 +149,18 @@ static int nilfs_direct_prepare_delete(struct nilfs_direct *direct,
 {
 	int ret;
 
-	if (direct->d_bmap.b_pops->bpop_prepare_end_ptr != NULL) {
-		req->bpr_ptr = nilfs_direct_get_ptr(direct, key);
-		ret = direct->d_bmap.b_pops->bpop_prepare_end_ptr(
-			&direct->d_bmap, req);
-		if (ret < 0)
-			return ret;
-	}
-
-	stats->bs_nblocks = 1;
-	return 0;
+	req->bpr_ptr = nilfs_direct_get_ptr(direct, key);
+	ret = nilfs_bmap_prepare_end_ptr(&direct->d_bmap, req);
+	if (!ret)
+		stats->bs_nblocks = 1;
+	return ret;
 }
 
 static void nilfs_direct_commit_delete(struct nilfs_direct *direct,
 				       union nilfs_bmap_ptr_req *req,
 				       __u64 key)
 {
-	if (direct->d_bmap.b_pops->bpop_commit_end_ptr != NULL)
-		direct->d_bmap.b_pops->bpop_commit_end_ptr(
-			&direct->d_bmap, req);
+	nilfs_bmap_commit_end_ptr(&direct->d_bmap, req);
 	nilfs_direct_set_ptr(direct, key, NILFS_BMAP_INVALID_PTR);
 }
 
@@ -289,11 +281,11 @@ static int nilfs_direct_propagate_v(struct nilfs_direct *direct,
 	if (!buffer_nilfs_volatile(bh)) {
 		oldreq.bpr_ptr = ptr;
 		newreq.bpr_ptr = ptr;
-		ret = nilfs_bmap_prepare_update(&direct->d_bmap, &oldreq,
-						&newreq);
+		ret = nilfs_bmap_prepare_update_v(&direct->d_bmap, &oldreq,
+						  &newreq);
 		if (ret < 0)
 			return ret;
-		nilfs_bmap_commit_update(&direct->d_bmap, &oldreq, &newreq);
+		nilfs_bmap_commit_update_v(&direct->d_bmap, &oldreq, &newreq);
 		set_buffer_nilfs_volatile(bh);
 		nilfs_direct_set_ptr(direct, key, newreq.bpr_ptr);
 	} else
-- 
1.6.2
