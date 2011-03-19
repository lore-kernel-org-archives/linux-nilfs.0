From: Nicolas Kaiser <nikai@nikai.net>
Subject: [PATCH] nilfs2: merge list_del()/list_add_tail() to
 list_move_tail()
Date: Sat, 19 Mar 2011 16:45:30 +0100
Message-ID: <20110319164530.6cc75cb2@absol.kitzblitz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org

Merge list_del() + list_add_tail() to list_move_tail().

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 fs/nilfs2/inode.c   |    3 +--
 fs/nilfs2/segment.c |    6 ++----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index d5625be..84f1b76 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -873,8 +873,7 @@ int nilfs_set_file_dirty(struct inode *inode, unsigned nr_dirty)
 			return -EINVAL; /* NILFS_I_DIRTY may remain for
 					   freeing inode */
 		}
-		list_del(&ii->i_dirty);
-		list_add_tail(&ii->i_dirty, &nilfs->ns_dirty_files);
+		list_move_tail(&ii->i_dirty, &nilfs->ns_dirty_files);
 		set_bit(NILFS_I_QUEUED, &ii->i_state);
 	}
 	spin_unlock(&nilfs->ns_inode_lock);
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index afe4f21..5deeadd 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1991,8 +1991,7 @@ static int nilfs_segctor_collect_dirty_files(struct nilfs_sc_info *sci,
 
 		clear_bit(NILFS_I_QUEUED, &ii->i_state);
 		set_bit(NILFS_I_BUSY, &ii->i_state);
-		list_del(&ii->i_dirty);
-		list_add_tail(&ii->i_dirty, &sci->sc_dirty_files);
+		list_move_tail(&ii->i_dirty, &sci->sc_dirty_files);
 	}
 	spin_unlock(&nilfs->ns_inode_lock);
 
@@ -2014,8 +2013,7 @@ static void nilfs_segctor_drop_written_files(struct nilfs_sc_info *sci,
 		clear_bit(NILFS_I_BUSY, &ii->i_state);
 		brelse(ii->i_bh);
 		ii->i_bh = NULL;
-		list_del(&ii->i_dirty);
-		list_add_tail(&ii->i_dirty, &ti->ti_garbage);
+		list_move_tail(&ii->i_dirty, &ti->ti_garbage);
 	}
 	spin_unlock(&nilfs->ns_inode_lock);
 }
-- 
1.7.3.4
