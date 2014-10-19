From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH 1/1] nilfs2: improve inode allocation
Date: Sun, 19 Oct 2014 19:17:11 +0200
Message-ID: <1413739031-13347-2-git-send-email-andreas.rohner@gmx.net>
References: <1413739031-13347-1-git-send-email-andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1413739031-13347-1-git-send-email-andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

The current inode allocation algorithm of NILFS2 does not use any
information about the previous allocation. It simply searches for a free
entry in the ifile, always starting from position 0. This patch
introduces an improved allocation scheme.

Inodes are allocated sequentially within the ifile. The current
algorithm always starts the search for a free slot at position 0,
because it has to find possible freed up slots of previously deleted
inodes. This minimizes wasted space, but has a certain cost attached to
it.

This patch introduces the field next_inode in the nilfs_ifile_info
structure, which stores the location of the most likely next free slot.
Whenever an inode is created or deleted next_inode is updated
accordingly. If an inode is deleted next_inode points to the newly
available slot. If an inode is created next_inode points to the slot
after that. Instead of starting every search for a free slot at 0, it is
started at next_inode. This way the search space is narrowed
considerably and a lot of overhead can be avoided.

Because of performance reasons the updates to next_inode are not
protected by locks. So race conditions, non-atomic updates and lost
updates are possible. This can lead to some empty slots that are
overlooked and therefore to some wasted space. But this is only
temporary, because next_inode is periodically reset to 0, to force a
full search starting from position 0.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 fs/nilfs2/ifile.c   | 31 +++++++++++++++++++++++++++++--
 fs/nilfs2/ifile.h   |  1 +
 fs/nilfs2/segment.c |  5 ++++-
 3 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/ifile.c b/fs/nilfs2/ifile.c
index 6548c78..0f27e66 100644
--- a/fs/nilfs2/ifile.c
+++ b/fs/nilfs2/ifile.c
@@ -33,10 +33,12 @@
  * struct nilfs_ifile_info - on-memory private data of ifile
  * @mi: on-memory private data of metadata file
  * @palloc_cache: persistent object allocator cache of ifile
+ * @next_inode: ino of the next likely free entry
  */
 struct nilfs_ifile_info {
 	struct nilfs_mdt_info mi;
 	struct nilfs_palloc_cache palloc_cache;
+	__u64 next_inode;
 };
 
 static inline struct nilfs_ifile_info *NILFS_IFILE_I(struct inode *ifile)
@@ -45,6 +47,26 @@ static inline struct nilfs_ifile_info *NILFS_IFILE_I(struct inode *ifile)
 }
 
 /**
+ * nilfs_ifile_next_inode_reset - set last_dir to 0
+ * @ifile: ifile inode
+ *
+ * Description: The value of next_inode will increase with every new
+ * allocation of a inode, because it is used as the starting point of the
+ * search for a free entry in the ifile. It should be reset periodically to 0
+ * (e.g.: every segctor timeout), so that previously deleted entries can be
+ * found.
+ */
+void nilfs_ifile_next_inode_reset(struct inode *ifile)
+{
+	/*
+	 * possible race condition/non atomic update
+	 * next_inode is just a hint for the next allocation so
+	 * the possible invalid values are not really harmful
+	 */
+	NILFS_IFILE_I(ifile)->next_inode = 0;
+}
+
+/**
  * nilfs_ifile_create_inode - create a new disk inode
  * @ifile: ifile inode
  * @out_ino: pointer to a variable to store inode number
@@ -68,9 +90,8 @@ int nilfs_ifile_create_inode(struct inode *ifile, ino_t *out_ino,
 	struct nilfs_palloc_req req;
 	int ret;
 
-	req.pr_entry_nr = 0;  /* 0 says find free inode from beginning of
-				 a group. dull code!! */
 	req.pr_entry_bh = NULL;
+	req.pr_entry_nr = NILFS_IFILE_I(ifile)->next_inode;
 
 	ret = nilfs_palloc_prepare_alloc_entry(ifile, &req);
 	if (!ret) {
@@ -86,6 +107,9 @@ int nilfs_ifile_create_inode(struct inode *ifile, ino_t *out_ino,
 	nilfs_palloc_commit_alloc_entry(ifile, &req);
 	mark_buffer_dirty(req.pr_entry_bh);
 	nilfs_mdt_mark_dirty(ifile);
+
+	/* see comment in nilfs_ifile_next_inode_reset() */
+	NILFS_IFILE_I(ifile)->next_inode = req.pr_entry_nr + 1;
 	*out_ino = (ino_t)req.pr_entry_nr;
 	*out_bh = req.pr_entry_bh;
 	return 0;
@@ -137,6 +161,9 @@ int nilfs_ifile_delete_inode(struct inode *ifile, ino_t ino)
 
 	nilfs_palloc_commit_free_entry(ifile, &req);
 
+	/* see comment in nilfs_ifile_next_inode_reset() */
+	if (NILFS_IFILE_I(ifile)->next_inode > req.pr_entry_nr)
+		NILFS_IFILE_I(ifile)->next_inode = req.pr_entry_nr;
 	return 0;
 }
 
diff --git a/fs/nilfs2/ifile.h b/fs/nilfs2/ifile.h
index 679674d..36edbcc 100644
--- a/fs/nilfs2/ifile.h
+++ b/fs/nilfs2/ifile.h
@@ -45,6 +45,7 @@ static inline void nilfs_ifile_unmap_inode(struct inode *ifile, ino_t ino,
 	kunmap(ibh->b_page);
 }
 
+void nilfs_ifile_next_inode_reset(struct inode *);
 int nilfs_ifile_create_inode(struct inode *, ino_t *, struct buffer_head **);
 int nilfs_ifile_delete_inode(struct inode *, ino_t);
 int nilfs_ifile_get_inode_block(struct inode *, ino_t, struct buffer_head **);
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index a1a1916..0777027 100644
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
+			nilfs_ifile_next_inode_reset(ifile);
+		}
 	}
 	goto loop;
 
-- 
2.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
