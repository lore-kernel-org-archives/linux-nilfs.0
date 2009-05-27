From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: [PATCH] nilfs2: enable sync_page method
Date: Wed, 27 May 2009 11:07:49 +0900 (JST)
Message-ID: <20090527.110749.105472566.ryusuke@osrg.net>
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

Hi,

Here is another patch for 2.6.31.  This will improve read performance
of nilfs.  I'll send this to linux-next and backport it to the
nilfs2-module standalone package.

Thanks,
Ryusuke Konishi
--
From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This adds a missing sync_page method which unplugs bio requests when
waiting for page locks. This will improve read performance of nilfs.

Here is a measurement result using dd command.

Without this patch:

 # mount -t nilfs2 /dev/sde1 /test
 # dd if=/test/aaa of=/dev/null bs=512k
 1024+0 records in
 1024+0 records out
 536870912 bytes (537 MB) copied, 6.00688 seconds, 89.4 MB/s

With this patch:

 # mount -t nilfs2 /dev/sde1 /test
 # dd if=/test/aaa of=/dev/null bs=512k
 1024+0 records in
 1024+0 records out
 536870912 bytes (537 MB) copied, 3.54998 seconds, 151 MB/s

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 3f70eed..f25fd4b 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -240,7 +240,7 @@ nilfs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 struct address_space_operations nilfs_aops = {
 	.writepage		= nilfs_writepage,
 	.readpage		= nilfs_readpage,
-	/* .sync_page		= nilfs_sync_page, */
+	.sync_page		= block_sync_page,
 	.writepages		= nilfs_writepages,
 	.set_page_dirty		= nilfs_set_page_dirty,
 	.readpages		= nilfs_readpages,
-- 
1.6.2
