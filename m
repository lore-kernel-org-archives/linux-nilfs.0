From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 1/2] nilfs2: fix gcc unused-but-set-variable warnings
Date: Mon, 12 Oct 2015 12:45:30 +0900
Message-ID: <1444621531-14142-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1444621531-14142-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=o8swl8gTiYXHG/RoiAzGwCa/graiUMwo9R5H3xyr0E8=;
        b=qaIZzQJzhkyhl4dCl3nPd899HXI+XuDY3dzH94VEWFc4QEshOTTg7Scp9xDTUtTXv+
         4cde3JvK/V8b6JWveLDQUlkeEBc72w+6TsjWKSuMwwDNxVUcn7Rbslt0qgB+2U4C/oND
         BNbE8wHCD5n1f6SwUQv1QfKG3MSD2WcMYba+jTATgY+XNvyLap+PrbP7KvvQ11yQHAdP
         zkIRnSVAGJ5BY/9/poKhqXApl979puYcARwhC6hrC4wrbW1JHd84P0/C4prXvBnQa/rk
         wwOpEVlESKiIdbJEJATCh7RtQvBkfsT4NtZGsm/A9DR2+UEYkjQoVYZi9jHxNR7KWS0i
         D7pg==
In-Reply-To: <1444621531-14142-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

Fix the following build warnings:

 $ make W=1
 [...]
   CC [M]  fs/nilfs2/btree.o
 fs/nilfs2/btree.c: In function 'nilfs_btree_split':
 fs/nilfs2/btree.c:923:8: warning: variable 'newptr' set but not used [-Wunused-but-set-variable]
   __u64 newptr;
         ^
 fs/nilfs2/btree.c:922:8: warning: variable 'newkey' set but not used [-Wunused-but-set-variable]
   __u64 newkey;
         ^
   CC [M]  fs/nilfs2/dat.o
 fs/nilfs2/dat.c: In function 'nilfs_dat_prepare_end':
 fs/nilfs2/dat.c:158:8: warning: variable 'start' set but not used [-Wunused-but-set-variable]
   __u64 start;
         ^
   CC [M]  fs/nilfs2/segment.o
 fs/nilfs2/segment.c: In function 'nilfs_segctor_do_immediate_flush':
 fs/nilfs2/segment.c:2433:6: warning: variable 'err' set but not used [-Wunused-but-set-variable]
   int err;
       ^
   CC [M]  fs/nilfs2/sufile.o
 fs/nilfs2/sufile.c: In function 'nilfs_sufile_alloc':
 fs/nilfs2/sufile.c:320:27: warning: variable 'ncleansegs' set but not used [-Wunused-but-set-variable]
   unsigned long nsegments, ncleansegs, nsus, cnt;
                            ^
   CC [M]  fs/nilfs2/alloc.o
 fs/nilfs2/alloc.c: In function 'nilfs_palloc_prepare_alloc_entry':
 fs/nilfs2/alloc.c:478:38: warning: variable 'groups_per_desc_block' set but not used [-Wunused-but-set-variable]
   unsigned long n, entries_per_group, groups_per_desc_block;
                                       ^

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/alloc.c   | 3 +--
 fs/nilfs2/btree.c   | 5 -----
 fs/nilfs2/dat.c     | 2 --
 fs/nilfs2/segment.c | 3 +--
 fs/nilfs2/sufile.c  | 3 +--
 5 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/fs/nilfs2/alloc.c b/fs/nilfs2/alloc.c
index 8df0f3b..dd6c142 100644
--- a/fs/nilfs2/alloc.c
+++ b/fs/nilfs2/alloc.c
@@ -475,7 +475,7 @@ int nilfs_palloc_prepare_alloc_entry(struct inode *inode,
 	void *desc_kaddr, *bitmap_kaddr;
 	unsigned long group, maxgroup, ngroups;
 	unsigned long group_offset, maxgroup_offset;
-	unsigned long n, entries_per_group, groups_per_desc_block;
+	unsigned long n, entries_per_group;
 	unsigned long i, j;
 	int pos, ret;
 
@@ -483,7 +483,6 @@ int nilfs_palloc_prepare_alloc_entry(struct inode *inode,
 	maxgroup = ngroups - 1;
 	group = nilfs_palloc_group(inode, req->pr_entry_nr, &group_offset);
 	entries_per_group = nilfs_palloc_entries_per_group(inode);
-	groups_per_desc_block = nilfs_palloc_groups_per_desc_block(inode);
 
 	for (i = 0; i < ngroups; i += n) {
 		if (group >= ngroups) {
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 919fd5b..f609a85 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -919,8 +919,6 @@ static void nilfs_btree_split(struct nilfs_bmap *btree,
 			      int level, __u64 *keyp, __u64 *ptrp)
 {
 	struct nilfs_btree_node *node, *right;
-	__u64 newkey;
-	__u64 newptr;
 	int nchildren, n, move, ncblk;
 
 	node = nilfs_btree_get_nonroot_node(path, level);
@@ -942,9 +940,6 @@ static void nilfs_btree_split(struct nilfs_bmap *btree,
 	if (!buffer_dirty(path[level].bp_sib_bh))
 		mark_buffer_dirty(path[level].bp_sib_bh);
 
-	newkey = nilfs_btree_node_get_key(right, 0);
-	newptr = path[level].bp_newreq.bpr_ptr;
-
 	if (move) {
 		path[level].bp_index -= nilfs_btree_node_get_nchildren(node);
 		nilfs_btree_node_insert(right, path[level].bp_index,
diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index 0d5fada..7dc23f1 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -155,7 +155,6 @@ void nilfs_dat_commit_start(struct inode *dat, struct nilfs_palloc_req *req,
 int nilfs_dat_prepare_end(struct inode *dat, struct nilfs_palloc_req *req)
 {
 	struct nilfs_dat_entry *entry;
-	__u64 start;
 	sector_t blocknr;
 	void *kaddr;
 	int ret;
@@ -169,7 +168,6 @@ int nilfs_dat_prepare_end(struct inode *dat, struct nilfs_palloc_req *req)
 	kaddr = kmap_atomic(req->pr_entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
 					     req->pr_entry_bh, kaddr);
-	start = le64_to_cpu(entry->de_start);
 	blocknr = le64_to_cpu(entry->de_blocknr);
 	kunmap_atomic(kaddr);
 
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index c6abbad9..11c06e9 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2430,7 +2430,6 @@ static void nilfs_segctor_thread_construct(struct nilfs_sc_info *sci, int mode)
 static void nilfs_segctor_do_immediate_flush(struct nilfs_sc_info *sci)
 {
 	int mode = 0;
-	int err;
 
 	spin_lock(&sci->sc_state_lock);
 	mode = (sci->sc_flush_request & FLUSH_DAT_BIT) ?
@@ -2438,7 +2437,7 @@ static void nilfs_segctor_do_immediate_flush(struct nilfs_sc_info *sci)
 	spin_unlock(&sci->sc_state_lock);
 
 	if (mode) {
-		err = nilfs_segctor_do_construct(sci, mode);
+		nilfs_segctor_do_construct(sci, mode);
 
 		spin_lock(&sci->sc_state_lock);
 		sci->sc_flush_request &= (mode == SC_FLUSH_FILE) ?
diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 2a869c3..08e4c63 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -317,7 +317,7 @@ int nilfs_sufile_alloc(struct inode *sufile, __u64 *segnump)
 	size_t susz = NILFS_MDT(sufile)->mi_entry_size;
 	__u64 segnum, maxsegnum, last_alloc;
 	void *kaddr;
-	unsigned long nsegments, ncleansegs, nsus, cnt;
+	unsigned long nsegments, nsus, cnt;
 	int ret, j;
 
 	down_write(&NILFS_MDT(sufile)->mi_sem);
@@ -327,7 +327,6 @@ int nilfs_sufile_alloc(struct inode *sufile, __u64 *segnump)
 		goto out_sem;
 	kaddr = kmap_atomic(header_bh->b_page);
 	header = kaddr + bh_offset(header_bh);
-	ncleansegs = le64_to_cpu(header->sh_ncleansegs);
 	last_alloc = le64_to_cpu(header->sh_last_alloc);
 	kunmap_atomic(kaddr);
 
-- 
1.8.3.1
