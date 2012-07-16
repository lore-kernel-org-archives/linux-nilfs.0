From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 2/4] NILFS2: remove references to long gone super operations
Date: Mon, 16 Jul 2012 10:05:24 +0900
Message-ID: <1342400726-30670-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1342400726-30670-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1342400726-30670-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

->delete_inode(), ->write_super_lockfs(), ->unlockfs() are gone so remove
refereces to them in the NTFS code. Noticed while cleaning up the fsfreeze
mess.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/super.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 1099a76..72b62b6 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -677,7 +677,6 @@ static const struct super_operations nilfs_sops = {
 	.destroy_inode  = nilfs_destroy_inode,
 	.dirty_inode    = nilfs_dirty_inode,
 	/* .write_inode    = nilfs_write_inode, */
-	/* .put_inode      = nilfs_put_inode, */
 	/* .drop_inode	  = nilfs_drop_inode, */
 	.evict_inode    = nilfs_evict_inode,
 	.put_super      = nilfs_put_super,
@@ -685,8 +684,6 @@ static const struct super_operations nilfs_sops = {
 	.sync_fs        = nilfs_sync_fs,
 	.freeze_fs	= nilfs_freeze,
 	.unfreeze_fs	= nilfs_unfreeze,
-	/* .write_super_lockfs */
-	/* .unlockfs */
 	.statfs         = nilfs_statfs,
 	.remount_fs     = nilfs_remount,
 	/* .umount_begin */
-- 
1.7.9.3
