From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/6] nilfs2: fix discrepancy in use of static specifier
Date: Sun, 14 Mar 2010 11:28:34 +0900
Message-ID: <1268533719-19454-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1268533719-19454-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1268533719-19454-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Two segbuf functions, nilfs_segbuf_write and nilfs_segbuf_wait, are
declared with the static storage class specifier, but their
implementations are not.

This fixes the discrepancy.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/segbuf.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index ab56fe4..68b08f2 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -470,8 +470,8 @@ static int nilfs_segbuf_submit_bh(struct nilfs_segment_buffer *segbuf,
  *
  * %-ENOMEM - Insufficient memory available.
  */
-int nilfs_segbuf_write(struct nilfs_segment_buffer *segbuf,
-		       struct the_nilfs *nilfs)
+static int nilfs_segbuf_write(struct nilfs_segment_buffer *segbuf,
+			      struct the_nilfs *nilfs)
 {
 	struct nilfs_write_info wi;
 	struct buffer_head *bh;
@@ -514,7 +514,7 @@ int nilfs_segbuf_write(struct nilfs_segment_buffer *segbuf,
  *
  * %-EIO - I/O error
  */
-int nilfs_segbuf_wait(struct nilfs_segment_buffer *segbuf)
+static int nilfs_segbuf_wait(struct nilfs_segment_buffer *segbuf)
 {
 	int err = 0;
 
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
