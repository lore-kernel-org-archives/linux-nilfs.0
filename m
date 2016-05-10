From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 1/7] nilfs2: do not emit extra newline on nilfs_warning() and nilfs_error()
Date: Tue, 10 May 2016 22:24:25 +0900
Message-ID: <1462886671-3521-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1462886671-3521-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=FLbARtD0ydvIMgJ1ZW/8ypTRkMedYVovU9vuv3AJPco=;
        b=DLShA6CEL1Zm1LyapDupKtEKHBTX2DlejxDZUf9BFgnTF88aR1JPBLK5HoNkjthbsE
         9D+wfwDZY+iIzG8YkUnCLL28qzsX8BM+Kp2rMXP4jCf3aEiwiblPIbAJjUzr7ZfJMB7J
         M5k7XSo8HRB0twVwZY54pyqBq8ctH4d+w+2zlsZ8shqYq9h7a/HCWrt+ytytYyDBqXtI
         TBfkgTFVjzdkvcbmYEJ1NKFK9KyNflioEPFBj+E/lTBm2WIk8ROINb+XEwpi7fgJ1bfZ
         6bFoZ5hhDuIPC9TkXAM8zpQ831BQ3Yo227XVDqhljriTs+kHnEW9q8im+XwqZHX09/Zh
         BPkw==
In-Reply-To: <1462886671-3521-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

This updates call sites of nilfs_warning() and nilfs_error() so that
they don't add a duplicate newline.  These output functions are
already designed to add a trailing newline to the message.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/alloc.c   | 10 +++++-----
 fs/nilfs2/bmap.c    |  2 +-
 fs/nilfs2/dir.c     |  4 ++--
 fs/nilfs2/inode.c   |  6 +++---
 fs/nilfs2/namei.c   |  2 +-
 fs/nilfs2/segment.c |  8 ++++----
 6 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/nilfs2/alloc.c b/fs/nilfs2/alloc.c
index 82362a5..bdd5ac5 100644
--- a/fs/nilfs2/alloc.c
+++ b/fs/nilfs2/alloc.c
@@ -619,7 +619,7 @@ void nilfs_palloc_commit_free_entry(struct inode *inode,
 
 	if (!nilfs_clear_bit_atomic(lock, group_offset, bitmap))
 		nilfs_warning(inode->i_sb, __func__,
-			      "entry number %llu already freed: ino=%lu\n",
+			      "entry number %llu already freed: ino=%lu",
 			      (unsigned long long)req->pr_entry_nr,
 			      (unsigned long)inode->i_ino);
 	else
@@ -660,7 +660,7 @@ void nilfs_palloc_abort_alloc_entry(struct inode *inode,
 
 	if (!nilfs_clear_bit_atomic(lock, group_offset, bitmap))
 		nilfs_warning(inode->i_sb, __func__,
-			      "entry number %llu already freed: ino=%lu\n",
+			      "entry number %llu already freed: ino=%lu",
 			      (unsigned long long)req->pr_entry_nr,
 			      (unsigned long)inode->i_ino);
 	else
@@ -769,7 +769,7 @@ int nilfs_palloc_freev(struct inode *inode, __u64 *entry_nrs, size_t nitems)
 			if (!nilfs_clear_bit_atomic(lock, group_offset,
 						    bitmap)) {
 				nilfs_warning(inode->i_sb, __func__,
-					      "entry number %llu already freed: ino=%lu\n",
+					      "entry number %llu already freed: ino=%lu",
 					      (unsigned long long)entry_nrs[j],
 					      (unsigned long)inode->i_ino);
 			} else {
@@ -814,7 +814,7 @@ int nilfs_palloc_freev(struct inode *inode, __u64 *entry_nrs, size_t nitems)
 							      last_nrs[k]);
 			if (ret && ret != -ENOENT) {
 				nilfs_warning(inode->i_sb, __func__,
-					      "failed to delete block of entry %llu: ino=%lu, err=%d\n",
+					      "failed to delete block of entry %llu: ino=%lu, err=%d",
 					      (unsigned long long)last_nrs[k],
 					      (unsigned long)inode->i_ino, ret);
 			}
@@ -833,7 +833,7 @@ int nilfs_palloc_freev(struct inode *inode, __u64 *entry_nrs, size_t nitems)
 			ret = nilfs_palloc_delete_bitmap_block(inode, group);
 			if (ret && ret != -ENOENT) {
 				nilfs_warning(inode->i_sb, __func__,
-					      "failed to delete bitmap block of group %lu: ino=%lu, err=%d\n",
+					      "failed to delete bitmap block of group %lu: ino=%lu, err=%d",
 					      group,
 					      (unsigned long)inode->i_ino, ret);
 			}
diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
index a5eab79..4976fe3 100644
--- a/fs/nilfs2/bmap.c
+++ b/fs/nilfs2/bmap.c
@@ -42,7 +42,7 @@ static int nilfs_bmap_convert_error(struct nilfs_bmap *bmap,
 
 	if (err == -EINVAL) {
 		nilfs_error(inode->i_sb, fname,
-			    "broken bmap (inode number=%lu)\n", inode->i_ino);
+			    "broken bmap (inode number=%lu)", inode->i_ino);
 		err = -EIO;
 	}
 	return err;
diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index 6ac166e..d6ed340 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -628,8 +628,8 @@ int nilfs_empty_dir(struct inode *inode)
 		while ((char *)de <= kaddr) {
 			if (de->rec_len == 0) {
 				nilfs_error(inode->i_sb, __func__,
-					    "zero-length directory entry "
-					    "(kaddr=%p, de=%p)\n", kaddr, de);
+					    "zero-length directory entry (kaddr=%p, de=%p)",
+					    kaddr, de);
 				goto not_empty;
 			}
 			if (de->inode != 0) {
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index bdd11c6..9bbd9d2 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -921,7 +921,7 @@ int nilfs_set_file_dirty(struct inode *inode, unsigned nr_dirty)
 			/* This will happen when somebody is freeing
 			   this inode. */
 			nilfs_warning(inode->i_sb, __func__,
-				      "cannot get inode (ino=%lu)\n",
+				      "cannot get inode (ino=%lu)",
 				      inode->i_ino);
 			spin_unlock(&nilfs->ns_inode_lock);
 			return -EINVAL; /* NILFS_I_DIRTY may remain for
@@ -942,7 +942,7 @@ int __nilfs_mark_inode_dirty(struct inode *inode, int flags)
 	err = nilfs_load_inode_block(inode, &ibh);
 	if (unlikely(err)) {
 		nilfs_warning(inode->i_sb, __func__,
-			      "failed to reget inode block.\n");
+			      "failed to reget inode block.");
 		return err;
 	}
 	nilfs_update_inode(inode, ibh, flags);
@@ -969,7 +969,7 @@ void nilfs_dirty_inode(struct inode *inode, int flags)
 
 	if (is_bad_inode(inode)) {
 		nilfs_warning(inode->i_sb, __func__,
-			      "tried to mark bad_inode dirty. ignored.\n");
+			      "tried to mark bad_inode dirty. ignored.");
 		dump_stack();
 		return;
 	}
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index e5bed2d..00a3282 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -284,7 +284,7 @@ static int nilfs_do_unlink(struct inode *dir, struct dentry *dentry)
 
 	if (!inode->i_nlink) {
 		nilfs_warning(inode->i_sb, __func__,
-			      "deleting nonexistent file (%lu), %d\n",
+			      "deleting nonexistent file (%lu), %d",
 			      inode->i_ino, inode->i_nlink);
 		set_nlink(inode, 1);
 	}
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 69e9ea8..a6ef1eb 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1938,7 +1938,7 @@ static int nilfs_segctor_collect_dirty_files(struct nilfs_sc_info *sci,
 				ifile, ii->vfs_inode.i_ino, &ibh);
 			if (unlikely(err)) {
 				nilfs_warning(sci->sc_super, __func__,
-					      "failed to get inode block.\n");
+					      "failed to get inode block.");
 				return err;
 			}
 			mark_buffer_dirty(ibh);
@@ -2724,13 +2724,13 @@ static void nilfs_segctor_destroy(struct nilfs_sc_info *sci)
 
 	if (!list_empty(&sci->sc_dirty_files)) {
 		nilfs_warning(sci->sc_super, __func__,
-			      "dirty file(s) after the final construction\n");
+			      "dirty file(s) after the final construction");
 		nilfs_dispose_list(nilfs, &sci->sc_dirty_files, 1);
 	}
 
 	if (!list_empty(&sci->sc_iput_queue)) {
 		nilfs_warning(sci->sc_super, __func__,
-			      "iput queue is not empty\n");
+			      "iput queue is not empty");
 		nilfs_dispose_list(nilfs, &sci->sc_iput_queue, 1);
 	}
 
@@ -2807,7 +2807,7 @@ void nilfs_detach_log_writer(struct super_block *sb)
 	if (!list_empty(&nilfs->ns_dirty_files)) {
 		list_splice_init(&nilfs->ns_dirty_files, &garbage_list);
 		nilfs_warning(sb, __func__,
-			      "Hit dirty file after stopped log writer\n");
+			      "Hit dirty file after stopped log writer");
 	}
 	spin_unlock(&nilfs->ns_inode_lock);
 	up_write(&nilfs->ns_segctor_sem);
-- 
1.8.3.1

