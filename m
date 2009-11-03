From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/3] nilfs2: add zero-fill for new btree node
	buffers
Date: Tue,  3 Nov 2009 13:53:38 +0900
Message-ID: <1257224019-29261-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1257224019-29261-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1257224019-29261-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
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

Adds missing initialization of newly allocated b-tree node buffers.
This avoids garbage data to be mixed in b-tree node blocks.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/btnode.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index 435864c..84c2538 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -87,6 +87,7 @@ int nilfs_btnode_submit_block(struct address_space *btnc, __u64 blocknr,
 			brelse(bh);
 			BUG();
 		}
+		memset(bh->b_data, 0, 1 << inode->i_blkbits);
 		bh->b_bdev = NILFS_I_NILFS(inode)->ns_bdev;
 		bh->b_blocknr = blocknr;
 		set_buffer_mapped(bh);
-- 
1.6.3.4
