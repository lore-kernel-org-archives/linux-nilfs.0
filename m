From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v11 45/63] btrfs: Convert page cache to XArray
Date: Sat, 14 Apr 2018 07:12:58 -0700
Message-ID: <20180414141316.7167-46-willy@infradead.org>
References: <20180414141316.7167-1-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:
 To:From:Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=ZvYtzZdN72TE4ngxGdDfpHZd7z4f1CP/7rcOvgzpivk=; b=GFs0TDQWlOnjj7tVcBFFkVeUKk
 DZIth7D4TRrsOum+1A2ReX0IGz5lzoKalS/bZU/eXBSO4eZP1OuXf9Gt/MVIyKjqAXF8AJmt0ubdS
 nSc8FEPzqZVYGRaQSx/sKxydw81lv/yE4kiHNNTX0M9uUyqjvE2sDym5p3aER/ji3qzs=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=ZvYtzZdN72TE4ngxGdDfpHZd7z4f1CP/7rcOvgzpivk=; b=P0ssNXUy4nxww2ywFLGPw3Tbuq
 yoCNKWJtCr0YbidFwgb3875JBE7teuAlFV290D4CAFL7NBu2QUYF8wtWaqikdESiUJeWaqam/XWH6
 5Fb4/CZSXOY6iNvqIDoJiRP6pek37RxpoIR7x/OUa9jpeCJlgwwytaDa+hWDEJYhpO0U=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=ZvYtzZdN72TE4ngxGdDfpHZd7z4f1CP/7rcOvgzpivk=; b=oFhtYjCbG2QzUES7UtX39MFgV
 5QbI3qH8xpL1JlRCf2glQTk/egORs7eWhEvttSzcTx3pxMC3j75Wg48VSsmJdAeU5Vyfhlo7Pm2kk
 tz3+HCfn/r36bxQM/TPpeF2OXcujHexmj6nNH9QYvrXvNm+IsNqaTbvzpXzuLrU/jE6xZ5XspUPC4
 V+yMG7R/WCl13ZCDYJN5K3t8gcInxfHu33MuB3MzuoD9T4J8QL3oLOkncxE9oi4N3I25Tc4oeSr3b
 HF+wJbmHNcd+qGK6RSWSwSvHF59ayMnCEdVCplP7m7MbXKoMSrWcUB5r7SYqEamWN3yQVIUjsNmsA
 Dx/sfIYgQ==;
In-Reply-To: <20180414141316.7167-1-willy@infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, James Simmons <jsimmons@infradead.org>, Jaegeuk Kim <jaegeuk@kernel.org>, Andreas Dilger <andreas.dilger@intel.com>, Nicholas Piggin <npiggin@gmail.com>, linux-f2fs-devel@lists.sourceforge.net, Oleg Drokin <oleg.drokin@intel.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Mike Kravetz <mike.kravetz@oracle.com>

From: Matthew Wilcox <mawilcox@microsoft.com>

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Acked-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/compression.c | 4 +---
 fs/btrfs/extent_io.c   | 8 +++-----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index dfd73e7265cf..54448d5d86e8 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -444,9 +444,7 @@ static noinline int add_ra_bio_pages(struct inode *inode,
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
index 85092edb0c99..82fb72cb9118 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5176,11 +5176,9 @@ void clear_extent_buffer_dirty(struct extent_buffer *eb)
 
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
2.17.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
