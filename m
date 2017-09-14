From: Jan Kara <jack@suse.cz>
Subject: [PATCH 09/15] nilfs2: Use pagevec_lookup_range_tag()
Date: Thu, 14 Sep 2017 15:18:13 +0200
Message-ID: <20170914131819.26266-10-jack@suse.cz>
References: <20170914131819.26266-1-jack@suse.cz>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <20170914131819.26266-1-jack@suse.cz>
Sender: ceph-devel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, Jaegeuk Kim <jaegeuk@kernel.org>, ceph-devel@vger.kernel.org, "Yan, Zheng" <zyan@redhat.com>, Ilya Dryomov <idryomov@gmail.com>, Jan Kara <jack@suse.cz>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

We want only pages from given range in
nilfs_lookup_dirty_data_buffers(). Use pagevec_lookup_range_tag()
instead of pagevec_lookup_tag() and remove unnecessary code.

CC: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
CC: linux-nilfs@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/nilfs2/segment.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 70ded52dc1dd..68e5769cef3b 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -711,18 +711,14 @@ static size_t nilfs_lookup_dirty_data_buffers(struct inode *inode,
 	pagevec_init(&pvec, 0);
  repeat:
 	if (unlikely(index > last) ||
-	    !pagevec_lookup_tag(&pvec, mapping, &index, PAGECACHE_TAG_DIRTY,
-				min_t(pgoff_t, last - index,
-				      PAGEVEC_SIZE - 1) + 1))
+	    !pagevec_lookup_range_tag(&pvec, mapping, &index, last,
+				PAGECACHE_TAG_DIRTY, PAGEVEC_SIZE))
 		return ndirties;
 
 	for (i = 0; i < pagevec_count(&pvec); i++) {
 		struct buffer_head *bh, *head;
 		struct page *page = pvec.pages[i];
 
-		if (unlikely(page->index > last))
-			break;
-
 		lock_page(page);
 		if (!page_has_buffers(page))
 			create_empty_buffers(page, i_blocksize(inode), 0);
-- 
2.12.3

