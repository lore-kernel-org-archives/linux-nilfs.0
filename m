From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: [PATCH] nilfs2: fix missing unlock in error path of
 nilfs_mdt_write_page
Date: Sun, 02 Aug 2009 22:23:05 +0900 (JST)
Message-ID: <20090802.222305.71922738.ryusuke@osrg.net>
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


I found a mutex leak while looking into a kernel oops detected in
shrink_page_list().

Here is a bugfix of the problem. I'll send it to the next -rc along
with other fixes.

Regards,
Ryusuke Konishi
--
From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

nilfs2: fix missing unlock in error path of nilfs_mdt_write_page

This adds a missing unlock of nilfs->ns_writer_mutex in
nilfs_mdt_write_page() function.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/mdt.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 3d3ddb3..2dfd477 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -412,8 +412,10 @@ nilfs_mdt_write_page(struct page *page, struct writeback_control *wbc)
 		return 0; /* Do not request flush for shadow page cache */
 	if (!sb) {
 		writer = nilfs_get_writer(NILFS_MDT(inode)->mi_nilfs);
-		if (!writer)
+		if (!writer) {
+			nilfs_put_writer(NILFS_MDT(inode)->mi_nilfs);
 			return -EROFS;
+		}
 		sb = writer->s_super;
 	}
 
-- 
1.6.3.4
