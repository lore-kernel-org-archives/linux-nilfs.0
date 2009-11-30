From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/6] nilfs2: use list_splice_tail or
	list_splice_tail_init
Date: Mon, 30 Nov 2009 22:30:40 +0900
Message-ID: <1259587845-3436-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1259587845-3436-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1259587845-3436-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
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

This applies list_splice_tail (or list_splice_tail_init) operation
instead of list_splice (or list_splice_init, respectively) to append a
new list to tail of an existing list.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/btree.c    |    2 +-
 fs/nilfs2/recovery.c |    2 +-
 fs/nilfs2/segment.c  |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 139b113..7cdd98b 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -2018,7 +2018,7 @@ static void nilfs_btree_lookup_dirty_buffers(struct nilfs_bmap *bmap,
 	for (level = NILFS_BTREE_LEVEL_NODE_MIN;
 	     level < NILFS_BTREE_LEVEL_MAX;
 	     level++)
-		list_splice(&lists[level], listp->prev);
+		list_splice_tail(&lists[level], listp);
 }
 
 static int nilfs_btree_assign_p(struct nilfs_btree *btree,
diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index 6d5412e..c9c96c7 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -925,7 +925,7 @@ int nilfs_search_super_root(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi,
 
  super_root_found:
 	/* Updating pointers relating to the latest checkpoint */
-	list_splice(&segments, ri->ri_used_segments.prev);
+	list_splice_tail(&segments, &ri->ri_used_segments);
 	nilfs->ns_last_pseg = sr_pseg_start;
 	nilfs->ns_last_seq = nilfs->ns_seg_seq;
 	nilfs->ns_last_cno = ri->ri_cno;
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 097f9c4..79acf4d 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1363,7 +1363,7 @@ static int nilfs_segctor_extend_segments(struct nilfs_sc_info *sci,
 		list_add_tail(&segbuf->sb_list, &list);
 		prev = segbuf;
 	}
-	list_splice(&list, sci->sc_segbufs.prev);
+	list_splice_tail(&list, &sci->sc_segbufs);
 	return 0;
 
  failed_segbuf:
@@ -2532,7 +2532,7 @@ int nilfs_clean_segments(struct super_block *sb, struct nilfs_argv *argv,
 
 	sci->sc_freesegs = kbufs[4];
 	sci->sc_nfreesegs = argv[4].v_nmembs;
-	list_splice_init(&nilfs->ns_gc_inodes, sci->sc_gc_inodes.prev);
+	list_splice_tail_init(&nilfs->ns_gc_inodes, &sci->sc_gc_inodes);
 
 	for (;;) {
 		nilfs_segctor_accept(sci, &req);
-- 
1.6.3.4
