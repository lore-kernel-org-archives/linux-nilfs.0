From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: fix memory leak in
	nilfs_ioctl_clean_segments
Date: Fri, 22 May 2009 21:18:32 +0900 (JST)
Message-ID: <20090522.211832.56338321.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
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

Hi,

Kentaro Suzuki-san gave me a bug report related to the garbage
collection today.

The problem was brought by the recent bugfix patch and turned out to
be causing a new memory leak problem for linux-2.6.30-rc6 and
nilfs2-modules-2.0.13.

This is the bugfix patch against 2.6.30-rc6.  I'll send it to Linus
and backport to the module package.

Regards,
Ryusuke Konishi
--
From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This fixes a new memory leak problem in garbage collection.  The
problem was brought by the bugfix patch ("nilfs2: fix lock order
reversal in nilfs_clean_segments ioctl").

Thanks to Kentaro Suzuki for finding this problem.

Reported-by: Kentaro Suzuki <k_suzuki-/LrofYqOC75L9jVzuh4AOg@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 50ff3f2..d6759b9 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -576,7 +576,7 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
 	ret = nilfs_clean_segments(inode->i_sb, argv, kbufs);
 
  out_free:
-	while (--n > 0)
+	while (--n >= 0)
 		vfree(kbufs[n]);
 	kfree(kbufs[4]);
 	return ret;
-- 
1.6.2
