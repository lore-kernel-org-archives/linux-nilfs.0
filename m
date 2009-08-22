From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: [PATCH] nilfs2: fix ignored error code in
	__nilfs_read_inode()
Date: Sat, 22 Aug 2009 20:21:57 +0900 (JST)
Message-ID: <20090822.202157.120631059.ryusuke@osrg.net>
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
Cc: Yuri Chislov <yuri-EJC0RcYdacHR7s880joybQ@public.gmane.org>, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

Hi Yuri,

I found a bug in an inode routine when I was looking at the problem
you reported.  The attached patch is the bugfix for that.

I think this is _not_ the cause of your corruption problem.  (in
either case I will send this upstream at some time)

If you apply this, you may see "NILFS: get root inode failed" error
instead of "NILFS: corrupt root inode.".

Regards,
Ryusuke Konishi
--
From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

nilfs2: fix ignored error code in __nilfs_read_inode()

The __nilfs_read_inode function is ignoring the error code returned
from nilfs_read_inode_common(), and wrongly delivers a success code
(zero) when it escapes from the function in erroneous cases.

This adds the missing error handling.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/inode.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index fe9d8f2..807e584 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -430,7 +430,8 @@ static int __nilfs_read_inode(struct super_block *sb, unsigned long ino,
 
 	raw_inode = nilfs_ifile_map_inode(sbi->s_ifile, ino, bh);
 
-	if (nilfs_read_inode_common(inode, raw_inode))
+	err = nilfs_read_inode_common(inode, raw_inode);
+	if (err)
 		goto failed_unmap;
 
 	if (S_ISREG(inode->i_mode)) {
