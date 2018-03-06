From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v8 55/63] btrfs: Convert page cache to XArray
Date: Tue,  6 Mar 2018 11:24:05 -0800
Message-ID: <20180306192413.5499-56-willy@infradead.org>
References: <20180306192413.5499-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=kAQ0MsAETEgPCc80Tmqgp3OKH9ML3eJpVOU3moWcVzc=; b=F95B20XFhujeZUlaxQjWuvGAT
        kgV0/EPD+GgyzISPbWA+QcutvaPAkBhX8a41zvlWF8XeVxPMt/dX2RFoh2lmzn/0ET4hkQ+Y1K6dk
        lFQAGIxUbfLNlgn8b+MJipMl3YX3e4v49cNCohtsqwYuf3ooDmwhc6rlbAXnVPYz/8MTpktkOr4iw
        PdI2UyC+nQbBL2JGkeuLcZkUfYzIUIpcVJiZs+ov2o2yRQAM0/uVCIL04/5q4Cf8oYtPiIUubEeFF
        Z8OsmH1mV2XRzgs0iyQ0YYSc0xtPrRs0PiIGuD/BLboD2aLKlxV/vX6NSnMVZdchtlqdxSpToQLGD
    
In-Reply-To: <20180306192413.5499-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/btrfs/compression.c | 4 +---
 fs/btrfs/extent_io.c   | 8 +++-----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index ad330af89eef..c2286f436571 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -457,9 +457,7 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 		if (pg_index > end_index)
 			break;
 
-		rcu_read_lock();
-		page = radix_tree_lookup(&mapping->i_pages, pg_index);
-		rcu_read_unlock();
+		page = xa_load(&mapping->i_pages, pg_index);
 		if (page && !xa_is_value(page)) {
 			misses++;
 			if (misses > 4)
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index bcc24ee5a2c9..edc472b41037 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5170,11 +5170,9 @@ void clear_extent_buffer_dirty(struct extent_buffer *eb)
 
 		clear_page_dirty_for_io(page);
 		xa_lock_irq(&page->mapping->i_pages);
-		if (!PageDirty(page)) {
-			radix_tree_tag_clear(&page->mapping->i_pages,
-						page_index(page),
-						PAGECACHE_TAG_DIRTY);
-		}
+		if (!PageDirty(page))
+			__xa_clear_tag(&page->mapping->i_pages,
+					page_index(page), PAGECACHE_TAG_DIRTY);
 		xa_unlock_irq(&page->mapping->i_pages);
 		ClearPageError(page);
 		unlock_page(page);
-- 
2.16.1

