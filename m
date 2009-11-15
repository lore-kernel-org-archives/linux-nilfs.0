From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 01/23] nilfs2: remove buffer locking in
	nilfs_mark_inode_dirty
Date: Sun, 15 Nov 2009 21:46:39 +0900
Message-ID: <1258289221-3827-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1258289221-3827-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1258289221-3827-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
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

This lock is eliminable because inodes on the buffer can be updated
independently.  Although a log writer also fills in bmap data on the
on-disk inodes, this update is exclusively done by a log writer lock.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/inode.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 2a0a5a3..412b25a 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -525,7 +525,6 @@ void nilfs_update_inode(struct inode *inode, struct buffer_head *ibh)
 
 	raw_inode = nilfs_ifile_map_inode(sbi->s_ifile, ino, ibh);
 
-	/* The buffer is guarded with lock_buffer() by the caller */
 	if (test_and_clear_bit(NILFS_I_NEW, &ii->i_state))
 		memset(raw_inode, 0, NILFS_MDT(sbi->s_ifile)->mi_entry_size);
 	set_bit(NILFS_I_INODE_DIRTY, &ii->i_state);
@@ -745,9 +744,7 @@ int nilfs_mark_inode_dirty(struct inode *inode)
 			      "failed to reget inode block.\n");
 		return err;
 	}
-	lock_buffer(ibh);
 	nilfs_update_inode(inode, ibh);
-	unlock_buffer(ibh);
 	nilfs_mdt_mark_buffer_dirty(ibh);
 	nilfs_mdt_mark_dirty(sbi->s_ifile);
 	brelse(ibh);
-- 
1.6.3.4
