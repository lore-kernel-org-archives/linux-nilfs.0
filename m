From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v4 51/73] btrfs: Convert page cache to XArray
Date: Tue,  5 Dec 2017 16:41:37 -0800
Message-ID: <20171206004159.3755-52-willy@infradead.org>
References: <20171206004159.3755-1-willy@infradead.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
	Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=aZQQeya/5yeMcoU9tOJOCt/Xand1m1fAUXYdyYt6N9w=; b=V8bke0VkDuZRGFPWlxP7BaGvf
	4cQqlk3EjHA9QVUIgP3MwUn9qZ1BISZiMwlsX/C+7TtYUWJMxUIh0yqi8SnpQ/Ts7f0vGppOPHxl3
	m1otulPYRCA62D3naAr2H6SEp516LJUpNx7U8PHM0ea3+tiWvF4d/4p0UuNDtJkV2I5f6JbPILpXM
	5iye5cybgBzub1uFnhYEO9arRA9bHzfeAPBs0un/vrB7n8Ll4rR7Xdk2oumwluxoeS5+EA1XmYM/K
	loEBWDrL/p3Cc3rAsZez8j/lCoFlMpF/ppA394EbW/vmyVaJ4Z9VpN91by3dJfgrrztxkOgfylb/M
	xqUEiGUhQ==;
In-Reply-To: <20171206004159.3755-1-willy@infradead.org>
Sender: owner-linux-mm@kvack.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/btrfs/compression.c | 4 +---
 fs/btrfs/extent_io.c   | 6 ++----
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index e687d06cd97c..4174b166e235 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -449,9 +449,7 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 		if (pg_index > end_index)
 			break;
 
-		rcu_read_lock();
-		page = radix_tree_lookup(&mapping->pages, pg_index);
-		rcu_read_unlock();
+		page = xa_load(&mapping->pages, pg_index);
 		if (page && !xa_is_value(page)) {
 			misses++;
 			if (misses > 4)
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b8b5b4562d50..96328c3a548e 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5197,11 +5197,9 @@ void clear_extent_buffer_dirty(struct extent_buffer *eb)
 
 		clear_page_dirty_for_io(page);
 		xa_lock_irq(&page->mapping->pages);
-		if (!PageDirty(page)) {
-			radix_tree_tag_clear(&page->mapping->pages,
-						page_index(page),
+		if (!PageDirty(page))
+			__xa_clear_tag(&page->mapping->pages, page_index(page),
 						PAGECACHE_TAG_DIRTY);
-		}
 		xa_unlock_irq(&page->mapping->pages);
 		ClearPageError(page);
 		unlock_page(page);
-- 
2.15.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
