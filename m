From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: [PATCH] nilfs2: fix missing initialization of
 i_dir_start_lookup member
Date: Mon, 28 Sep 2009 15:03:08 +0900 (JST)
Message-ID: <20090928.150308.76966672.ryusuke@osrg.net>
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
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

This corrects another missing initialization bug found in on-memory
inode objects.  Fortunately, this does not cause crucial failures.
I'll send this upstream along with the previous fix.

Thanks,
Ryusuke Konishi
--
From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

nilfs2: fix missing initialization of i_dir_start_lookup member

The i_dir_start_lookup field in nilfs_inode_info objects should be
cleared when the objects are allocated, but the the initialization was
missing in case of reading from disk.  This adds the initialization.

Since the variable just gives a start page on directory lookups, the
bug was nonfatal until now.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/inode.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 2d2c501..5040220 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -400,6 +400,7 @@ int nilfs_read_inode_common(struct inode *inode,
 	ii->i_dir_acl = S_ISREG(inode->i_mode) ?
 		0 : le32_to_cpu(raw_inode->i_dir_acl);
 #endif
+	ii->i_dir_start_lookup = 0;
 	ii->i_cno = 0;
 	inode->i_generation = le32_to_cpu(raw_inode->i_generation);
