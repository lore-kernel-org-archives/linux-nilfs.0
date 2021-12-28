From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] nilfs2: remove redundant pointer sbufs
Date: Wed, 29 Dec 2021 02:27:56 +0900
Message-ID: <1640712476-15136-1-git-send-email-konishi.ryusuke@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=iK3TYSqepfTI2FEHIHzErbmP5hk0m9mmdnNtxXuTqFc=;
        b=JWsZh1bsuFqCG3YghtU1JwycqrojJy7elCAvbaFmncbhbSf8Ij5Dxg2C2g9rrE6r89
         zh9toGN/Pxxan9okNXvstE7ST5BolB7YTqgoL1AKnh/tCJ6rTMwqFib6nFRkPZRdqlWe
         EDidt3b67Gr37u/5luHlEys8s66OJ7BnomQBQEMf7mCpLLreJzEo6JZc2nj4fLe7zzUa
         cTd5ugiNtD9Qz6MCRsb/gopCh8q+HONTWAqcPlC6sEQSfHCaEhXBUWfgkiYNHTD/YOKJ
         gFihT+KXLdjq4WDzo/YTIG2pm7Zdj3s8dhKsiH3ICX2JmKmKfR/6HS2esNWAqu2lkQQ5
         VbJw==
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

From: Colin Ian King <colin.i.king-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Pointer sbufs is being assigned a value but it's not being used
later on. The pointer is redundant and can be removed. Cleans up
scan-build static analysis warning:

fs/nilfs2/page.c:203:8: warning: Although the value stored to 'sbufs'
is used in the enclosing expression, the value is never actually read
from 'sbufs' [deadcode.DeadStores]
        sbh = sbufs = page_buffers(src);

Link: https://lkml.kernel.org/r/20211211180955.550380-1-colin.i.king-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Signed-off-by: Colin Ian King <colin.i.king-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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
1.8.3.1

