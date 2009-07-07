From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 5/5] nilfs2: fix disorder in cp count on error
	during deleting checkpoints
Date: Tue,  7 Jul 2009 12:53:12 +0900
Message-ID: <1246938792-14681-6-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1246938792-14681-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1246938792-14681-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
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
Cc: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

From: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

This fixes a bug that checkpoint count gets wrong on errors when
deleting a series of checkpoints.

The count error is persistent since the checkpoint count is stored on
disk.  Some userland programs refer to the count via ioctl, and this
bugfix is needed to prevent malfunction of such programs.

Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
---
 fs/nilfs2/cpfile.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index 7d49813..aec942c 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -307,7 +307,7 @@ int nilfs_cpfile_delete_checkpoints(struct inode *cpfile,
 		ret = nilfs_cpfile_get_checkpoint_block(cpfile, cno, 0, &cp_bh);
 		if (ret < 0) {
 			if (ret != -ENOENT)
-				goto out_header;
+				break;
 			/* skip hole */
 			ret = 0;
 			continue;
@@ -340,7 +340,7 @@ int nilfs_cpfile_delete_checkpoints(struct inode *cpfile,
 					continue;
 				printk(KERN_ERR "%s: cannot delete block\n",
 				       __func__);
-				goto out_header;
+				break;
 			}
 		}
 
@@ -358,7 +358,6 @@ int nilfs_cpfile_delete_checkpoints(struct inode *cpfile,
 		kunmap_atomic(kaddr, KM_USER0);
 	}
 
- out_header:
 	brelse(header_bh);
 
  out_sem:
-- 
1.6.3.3
