From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] mm/fs: Remove redundant code
Date: Mon,  7 Feb 2022 18:37:38 +0800
Message-ID: <20220207103738.103661-1-jiapeng.chong@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: konishi.ryusuke@gmail.com
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, Jiapeng Chong <jiapeng.chong@linux.alibaba.com>, Abaci Robot <abaci@linux.alibaba.com>

Clean up the following smatch warning:

fs/nilfs2/segbuf.c:358 nilfs_segbuf_submit_bio() warn: ignoring
unreachable code.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 fs/nilfs2/segbuf.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index 9e5dd6324ea1..50d7e2e4daed 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -341,7 +341,6 @@ static int nilfs_segbuf_submit_bio(struct nilfs_segment_buffer *segbuf,
 				   int mode_flags)
 {
 	struct bio *bio = wi->bio;
-	int err;
 
 	bio->bi_end_io = nilfs_end_bio_write;
 	bio->bi_private = segbuf;
@@ -354,9 +353,6 @@ static int nilfs_segbuf_submit_bio(struct nilfs_segment_buffer *segbuf,
 	wi->nr_vecs = min(wi->max_pages, wi->rest_blocks);
 	wi->start = wi->end;
 	return 0;
-
-	wi->bio = NULL;
-	return err;
 }
 
 static void nilfs_segbuf_prepare_write(struct nilfs_segment_buffer *segbuf,
-- 
2.20.1.7.g153144c

