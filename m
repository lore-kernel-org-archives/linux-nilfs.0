From: Colin Ian King <colin.i.king@gmail.com>
Subject: [PATCH] nilfs2: remove redundant pointer sbufs
Date: Sat, 11 Dec 2021 18:09:55 +0000
Message-ID: <20211211180955.550380-1-colin.i.king@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zA92V1btmrTrQKYhZyZjsNIHT2URvEbAj4KA4p/lKAY=;
        b=TSvkTe2LbjI08HFOsXQoUB44oUbVFIbH8+rZ8sj176haMNUQuvdORHM/2G9niiMIqM
         lhfDm0VOHIQ9hnZvat3NTIw8AM6qSUGFnU7D+iZWNdumFncXmrJ1kOPId/OeUqxK+kYs
         uq0oMVW1dWSCA3vvffKxV/Aam3WOQdrhXeLz+Wg6FfCKWB/Jr7WV3eSSA6FDp/TTkydq
         tXP28aSP2ScgT4d/KuHMGL2COCHfpaAUVhFNG/eG9/W2/b1nWheliIl07ZqlamO5B0HI
         sjLGnKD+fvW8eoy3eH0Yw57bg7p9W5U+40+wxirgxGKPqH43g6OemiEZTCPiN1jsmWFQ
         UrNg==
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>, linux-nilfs@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

Pointer sbufs is being assigned a value but it's not being used
later on. The pointer is redundant and can be removed. Cleans up
scan-build static analysis warning:

fs/nilfs2/page.c:203:8: warning: Although the value stored to 'sbufs'
is used in the enclosing expression, the value is never actually read
from 'sbufs' [deadcode.DeadStores]
        sbh = sbufs = page_buffers(src);

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 fs/nilfs2/page.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index bc3e2cd4117f..063dd16d75b5 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -195,12 +195,12 @@ void nilfs_page_bug(struct page *page)
  */
 static void nilfs_copy_page(struct page *dst, struct page *src, int copy_dirty)
 {
-	struct buffer_head *dbh, *dbufs, *sbh, *sbufs;
+	struct buffer_head *dbh, *dbufs, *sbh;
 	unsigned long mask = NILFS_BUFFER_INHERENT_BITS;
 
 	BUG_ON(PageWriteback(dst));
 
-	sbh = sbufs = page_buffers(src);
+	sbh = page_buffers(src);
 	if (!page_has_buffers(dst))
 		create_empty_buffers(dst, sbh->b_size, 0);
 
-- 
2.33.1

