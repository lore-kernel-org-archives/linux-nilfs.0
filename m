From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 06/23] nilfs2: use checkpoint tree for mount check of snapshots
Date: Tue, 14 Sep 2010 00:37:07 +0900
Message-ID: <1284392244-27100-7-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1284392244-27100-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1284392244-27100-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

This rewrites nilfs_checkpoint_is_mounted() function so that it
decides whether a checkpoint is mounted by whether the corresponding
root object is found in checkpoint tree.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/the_nilfs.c |   28 +++++++++++-----------------
 1 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index da4aa43..3bb1579 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -954,26 +954,20 @@ struct nilfs_sb_info *nilfs_find_sbinfo(struct the_nilfs *nilfs,
 int nilfs_checkpoint_is_mounted(struct the_nilfs *nilfs, __u64 cno,
 				int snapshot_mount)
 {
-	struct nilfs_sb_info *sbi;
-	int ret = 0;
+	struct nilfs_root *root;
+	int ret;
 
-	down_read(&nilfs->ns_super_sem);
-	if (cno == 0 || cno > nilfs->ns_cno)
-		goto out_unlock;
+	if (cno < 0 || cno > nilfs->ns_cno)
+		return false;
 
-	list_for_each_entry(sbi, &nilfs->ns_supers, s_list) {
-		if (sbi->s_snapshot_cno == cno &&
-		    (!snapshot_mount || nilfs_test_opt(sbi, SNAPSHOT))) {
-					/* exclude read-only mounts */
-			ret++;
-			break;
-		}
-	}
-	/* for protecting recent checkpoints */
 	if (cno >= nilfs_last_cno(nilfs))
-		ret++;
+		return true;	/* protect recent checkpoints */
 
- out_unlock:
-	up_read(&nilfs->ns_super_sem);
+	ret = false;
+	root = nilfs_lookup_root(nilfs, cno);
+	if (root) {
+		ret = true;
+		nilfs_put_root(root);
+	}
 	return ret;
 }
-- 
1.6.6.2

