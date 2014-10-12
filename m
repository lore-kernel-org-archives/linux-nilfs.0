From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH 2/2] nilfs2: improve inode allocation algorithm
Date: Sun, 12 Oct 2014 12:38:23 +0200
Message-ID: <1413110303-14246-3-git-send-email-andreas.rohner@gmx.net>
References: <1413110303-14246-1-git-send-email-andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1413110303-14246-1-git-send-email-andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

The current inode allocation algorithm of NILFS2 does not use any
information about the previous allocation or the parent directory of the
inode. It simply searches for a free entry in the ifile, always starting
from position 0. This patch introduces an improved allocation scheme.
There are no changes to the on-disk-format necessary.

First of all the algorithm distinguishes between files and directories.

File inodes start their search at the location of their parent
directory, so that they will be allocated near their parent. If the file
inode ends up on the same block as its parent, the common task of
listing the directory contents (e.g.: "ls") will be faster. Although
there is no guarantee, that any subsequent blocks after that will end up
near the block with the directory on disk, there is still a possibility
for performance improvement, because it can be expected, that subsequent
blocks are read ahead. Also the cleaner will write out blocks in
the order of their file offset, so there is an increased likelihood that
those blocks can be read in faster.

Directory inodes are allocated aligned to block boundaries and with
a certain number of empty slots following them. The empty slots
increase the likelihood, that files can be allocated in the same block
as their parent. Furthermore the alignment improves performance, because
unaligned locations do not have to be searched. The location of the last
successful allocation of a directory is stored in memory and used as a
starting point for the next allocation. This value is periodically reset
to 0 to allow the algorithm to find previously deleted slots.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 fs/nilfs2/ifile.c   | 63 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 fs/nilfs2/ifile.h   |  6 +++--
 fs/nilfs2/inode.c   |  6 +++--
 fs/nilfs2/segment.c |  5 ++++-
 4 files changed, 69 insertions(+), 11 deletions(-)

diff --git a/fs/nilfs2/ifile.c b/fs/nilfs2/ifile.c
index 6548c78..9fc83ce 100644
--- a/fs/nilfs2/ifile.c
+++ b/fs/nilfs2/ifile.c
@@ -33,20 +33,49 @@
  * struct nilfs_ifile_info - on-memory private data of ifile
  * @mi: on-memory private data of metadata file
  * @palloc_cache: persistent object allocator cache of ifile
+ * @last_dir: ino of the last directory allocated
  */
 struct nilfs_ifile_info {
 	struct nilfs_mdt_info mi;
 	struct nilfs_palloc_cache palloc_cache;
+	__u64 last_dir;
 };
 
 static inline struct nilfs_ifile_info *NILFS_IFILE_I(struct inode *ifile)
 {
 	return (struct nilfs_ifile_info *)NILFS_MDT(ifile);
 }
+/**
+ * nilfs_ifile_last_dir_reset - set last_dir to 0
+ * @ifile: ifile inode
+ *
+ * Description: The value of last_dir will increase with every new
+ * allocation of a directory, because it is used as the starting point of the
+ * search for a free entry in the ifile. It should be reset periodically to 0
+ * (e.g.: every segctor timeout), so that previously deleted entries can be
+ * found.
+ */
+void nilfs_ifile_last_dir_reset(struct inode *ifile)
+{
+	NILFS_IFILE_I(ifile)->last_dir = 0;
+}
+
+/**
+ * nilfs_ifile_inodes_per_block - get number of inodes in a block
+ * @ifile: ifile inode
+ *
+ * Return Value: The number of inodes that fit into a file system block.
+ */
+static inline int nilfs_ifile_inodes_per_block(struct inode *ifile)
+{
+	return (1 << ifile->i_blkbits) / sizeof(struct nilfs_inode);
+}
 
 /**
  * nilfs_ifile_create_inode - create a new disk inode
  * @ifile: ifile inode
+ * @parent: inode number of the parent directory
+ * @mode: inode type of the newly created inode
  * @out_ino: pointer to a variable to store inode number
  * @out_bh: buffer_head contains newly allocated disk inode
  *
@@ -62,17 +91,29 @@ static inline struct nilfs_ifile_info *NILFS_IFILE_I(struct inode *ifile)
  *
  * %-ENOSPC - No inode left.
  */
-int nilfs_ifile_create_inode(struct inode *ifile, ino_t *out_ino,
+int nilfs_ifile_create_inode(struct inode *ifile, ino_t parent,
+			     umode_t mode, ino_t *out_ino,
 			     struct buffer_head **out_bh)
 {
 	struct nilfs_palloc_req req;
-	int ret;
+	int ret, ipb = nilfs_ifile_inodes_per_block(ifile);
 
-	req.pr_entry_nr = 0;  /* 0 says find free inode from beginning of
-				 a group. dull code!! */
 	req.pr_entry_bh = NULL;
 
-	ret = nilfs_palloc_prepare_alloc_entry(ifile, &req);
+	if (S_ISDIR(mode)) {
+		req.pr_entry_nr = NILFS_IFILE_I(ifile)->last_dir;
+		ret = __nilfs_palloc_prepare_alloc_entry(ifile, &req, ipb,
+				nilfs_palloc_entries_per_group(ifile) >> 2);
+		if (unlikely(ret == -ENOSPC)) {
+			/* fallback to normal allocation */
+			req.pr_entry_nr = 0;
+			ret = nilfs_palloc_prepare_alloc_entry(ifile, &req);
+		}
+	} else {
+		req.pr_entry_nr = parent + 1;
+		ret = nilfs_palloc_prepare_alloc_entry(ifile, &req);
+	}
+
 	if (!ret) {
 		ret = nilfs_palloc_get_entry_block(ifile, req.pr_entry_nr, 1,
 						   &req.pr_entry_bh);
@@ -86,6 +127,13 @@ int nilfs_ifile_create_inode(struct inode *ifile, ino_t *out_ino,
 	nilfs_palloc_commit_alloc_entry(ifile, &req);
 	mark_buffer_dirty(req.pr_entry_bh);
 	nilfs_mdt_mark_dirty(ifile);
+	/*
+	 * possible race condition/non atomic update
+	 * last_dir is just a hint for the next allocation so
+	 * the possible invalid values are not really harmful
+	 */
+	if (S_ISDIR(mode))
+		NILFS_IFILE_I(ifile)->last_dir = req.pr_entry_nr + ipb;
 	*out_ino = (ino_t)req.pr_entry_nr;
 	*out_bh = req.pr_entry_bh;
 	return 0;
@@ -95,6 +143,7 @@ int nilfs_ifile_create_inode(struct inode *ifile, ino_t *out_ino,
  * nilfs_ifile_delete_inode - delete a disk inode
  * @ifile: ifile inode
  * @ino: inode number
+ * @mode: inode type of the deleted inode
  *
  * Return Value: On success, 0 is returned. On error, one of the following
  * negative error codes is returned.
@@ -105,7 +154,7 @@ int nilfs_ifile_create_inode(struct inode *ifile, ino_t *out_ino,
  *
  * %-ENOENT - The inode number @ino have not been allocated.
  */
-int nilfs_ifile_delete_inode(struct inode *ifile, ino_t ino)
+int nilfs_ifile_delete_inode(struct inode *ifile, ino_t ino, umode_t mode)
 {
 	struct nilfs_palloc_req req = {
 		.pr_entry_nr = ino, .pr_entry_bh = NULL
@@ -137,6 +186,8 @@ int nilfs_ifile_delete_inode(struct inode *ifile, ino_t ino)
 
 	nilfs_palloc_commit_free_entry(ifile, &req);
 
+	if (S_ISDIR(mode))
+		NILFS_IFILE_I(ifile)->last_dir = req.pr_entry_nr;
 	return 0;
 }
 
diff --git a/fs/nilfs2/ifile.h b/fs/nilfs2/ifile.h
index 679674d..81432a4 100644
--- a/fs/nilfs2/ifile.h
+++ b/fs/nilfs2/ifile.h
@@ -45,8 +45,10 @@ static inline void nilfs_ifile_unmap_inode(struct inode *ifile, ino_t ino,
 	kunmap(ibh->b_page);
 }
 
-int nilfs_ifile_create_inode(struct inode *, ino_t *, struct buffer_head **);
-int nilfs_ifile_delete_inode(struct inode *, ino_t);
+void nilfs_ifile_last_dir_reset(struct inode *);
+int nilfs_ifile_create_inode(struct inode *, ino_t, umode_t, ino_t *,
+			     struct buffer_head **);
+int nilfs_ifile_delete_inode(struct inode *, ino_t, umode_t);
 int nilfs_ifile_get_inode_block(struct inode *, ino_t, struct buffer_head **);
 
 int nilfs_ifile_count_free_inodes(struct inode *, u64 *, u64 *);
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index d071e7f..206d861f 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -370,7 +370,8 @@ struct inode *nilfs_new_inode(struct inode *dir, umode_t mode)
 	ii->i_state = 1 << NILFS_I_NEW;
 	ii->i_root = root;
 
-	err = nilfs_ifile_create_inode(root->ifile, &ino, &ii->i_bh);
+	err = nilfs_ifile_create_inode(root->ifile, dir->i_ino, mode,
+				       &ino, &ii->i_bh);
 	if (unlikely(err))
 		goto failed_ifile_create_inode;
 	/* reference count of i_bh inherits from nilfs_mdt_read_block() */
@@ -803,7 +804,8 @@ void nilfs_evict_inode(struct inode *inode)
 	nilfs_mark_inode_dirty(inode);
 	clear_inode(inode);
 
-	ret = nilfs_ifile_delete_inode(ii->i_root->ifile, inode->i_ino);
+	ret = nilfs_ifile_delete_inode(ii->i_root->ifile, inode->i_ino,
+				       inode->i_mode);
 	if (!ret)
 		atomic64_dec(&ii->i_root->inodes_count);
 
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index a1a1916..0caffb7 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2447,6 +2447,7 @@ static int nilfs_segctor_thread(void *arg)
 {
 	struct nilfs_sc_info *sci = (struct nilfs_sc_info *)arg;
 	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
+	struct inode *ifile = sci->sc_root->ifile;
 	int timeout = 0;
 
 	sci->sc_timer.data = (unsigned long)current;
@@ -2510,8 +2511,10 @@ static int nilfs_segctor_thread(void *arg)
 		timeout = ((sci->sc_state & NILFS_SEGCTOR_COMMIT) &&
 			   time_after_eq(jiffies, sci->sc_timer.expires));
 
-		if (nilfs_sb_dirty(nilfs) && nilfs_sb_need_update(nilfs))
+		if (nilfs_sb_dirty(nilfs) && nilfs_sb_need_update(nilfs)) {
 			set_nilfs_discontinued(nilfs);
+			nilfs_ifile_last_dir_reset(ifile);
+		}
 	}
 	goto loop;
 
-- 
2.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
