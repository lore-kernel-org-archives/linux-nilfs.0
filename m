From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/5] nilfs2: fix hang problem of log writer
	which occurs after write failures
Date: Tue,  7 Jul 2009 12:53:09 +0900
Message-ID: <1246938792-14681-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Leandro Lucarella gave me a report that nilfs gets stuck after its
write function fails.

The problem turned out to be caused by bugs which leave writeback flag
on pages.  This fixes the problem by ensuring to clear the writeback
flag in error path.

Reported-by: Leandro Lucarella <llucax-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
---
 fs/nilfs2/segment.c |   26 ++++++--------------------
 1 files changed, 6 insertions(+), 20 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index c182491..8b5e477 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1836,19 +1836,6 @@ static int nilfs_segctor_write(struct nilfs_sc_info *sci,
 	return 0;
 }
 
-static int nilfs_page_has_uncleared_buffer(struct page *page)
-{
-	struct buffer_head *head, *bh;
-
-	head = bh = page_buffers(page);
-	do {
-		if (buffer_dirty(bh) && !list_empty(&bh->b_assoc_buffers))
-			return 1;
-		bh = bh->b_this_page;
-	} while (bh != head);
-	return 0;
-}
-
 static void __nilfs_end_page_io(struct page *page, int err)
 {
 	if (!err) {
@@ -1872,12 +1859,11 @@ static void nilfs_end_page_io(struct page *page, int err)
 	if (!page)
 		return;
 
-	if (buffer_nilfs_node(page_buffers(page)) &&
-	    nilfs_page_has_uncleared_buffer(page))
-		/* For b-tree node pages, this function may be called twice
-		   or more because they might be split in a segment.
-		   This check assures that cleanup has been done for all
-		   buffers in a split btnode page. */
+	if (buffer_nilfs_node(page_buffers(page)) && !PageWriteback(page))
+		/*
+		 * For b-tree node pages, this function may be called twice
+		 * or more because they might be split in a segment.
+		 */
 		return;
 
 	__nilfs_end_page_io(page, err);
@@ -1940,7 +1926,7 @@ static void nilfs_segctor_abort_write(struct nilfs_sc_info *sci,
 			}
 			if (bh->b_page != fs_page) {
 				nilfs_end_page_io(fs_page, err);
-				if (unlikely(fs_page == failed_page))
+				if (fs_page && fs_page == failed_page)
 					goto done;
 				fs_page = bh->b_page;
 			}
-- 
1.6.3.3
