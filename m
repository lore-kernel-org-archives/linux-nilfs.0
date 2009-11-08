From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/2] nilfs2: fix missing cleanup of gc cache
	on error cases
Date: Sun,  8 Nov 2009 16:15:52 +0900
Message-ID: <1257664552-6234-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1257664552-6234-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1257664552-6234-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
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
Cc: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>, Markus Trippelsdorf <markus-xp2qqqlHh3xzoYq+O6RWwA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This fixes an -rc1 regression brought by the commit:
1cf58fa840472ec7df6bf2312885949ebb308853 ("nilfs2: shorten freeze
period due to GC in write operation v3").

Although the patch moved out a function call of
nilfs_ioctl_move_blocks() to nilfs_ioctl_clean_segments() from
nilfs_ioctl_prepare_clean_segments(), it didn't move corresponding
cleanup job needed for the error case.

This will move the missing cleanup job to the destination function.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
---
 fs/nilfs2/ioctl.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 89dd73e..d24057d 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -467,7 +467,6 @@ int nilfs_ioctl_prepare_clean_segments(struct the_nilfs *nilfs,
 	return 0;
 
  failed:
-	nilfs_remove_all_gcinode(nilfs);
 	printk(KERN_ERR "NILFS: GC failed during preparation: %s: err=%d\n",
 	       msg, ret);
 	return ret;
@@ -556,6 +555,8 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
 	else
 		ret = nilfs_clean_segments(inode->i_sb, argv, kbufs);
 
+	if (ret < 0)
+		nilfs_remove_all_gcinode(nilfs);
 	clear_nilfs_gc_running(nilfs);
 
  out_free:
-- 
1.6.3.4
