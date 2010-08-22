From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/6] nilfs2: allow nilfs_dirty_inode to mark metadata file inodes dirty
Date: Sun, 22 Aug 2010 19:05:02 +0900
Message-ID: <1282471506-29618-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1282471506-29618-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1282471506-29618-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Nick Piggin <npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This allows sop->dirty_inode callback function (nilfs_dirty_inode) to
handle metadata file inodes.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/inode.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index eccb2f2..f1750ca 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -808,6 +808,7 @@ int nilfs_mark_inode_dirty(struct inode *inode)
 void nilfs_dirty_inode(struct inode *inode)
 {
 	struct nilfs_transaction_info ti;
+	struct nilfs_mdt_info *mdi = NILFS_MDT(inode);
 
 	if (is_bad_inode(inode)) {
 		nilfs_warning(inode->i_sb, __func__,
@@ -815,6 +816,10 @@ void nilfs_dirty_inode(struct inode *inode)
 		dump_stack();
 		return;
 	}
+	if (mdi) {
+		nilfs_mdt_mark_dirty(inode);
+		return;
+	}
 	nilfs_transaction_begin(inode->i_sb, &ti, 0);
 	nilfs_mark_inode_dirty(inode);
 	nilfs_transaction_commit(inode->i_sb); /* never fails */
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
