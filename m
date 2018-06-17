From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v14 57/74] btrfs: Convert page cache to XArray
Date: Sat, 16 Jun 2018 19:00:35 -0700
Message-ID: <20180617020052.4759-58-willy@infradead.org>
References: <20180617020052.4759-1-willy@infradead.org>
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
 bh=yhxlc91nQ8tv5+dbe3KldhL1aWJiFQRriK/2+uk71C4=; b=OItu4gWMPx9TW23+4yz1bdPDLo
 g3c2m7fO2RiY4gJIpuG9L/uyYXU1KjCDTX1g9RdxrnRVV3ZdmUCMp8SZRn8q4JvyI9DTgy8TCzN5w
 +b6cfTsDccpSYEBK5UoTNLFSflDPL3rUOibYB/uI//ADKLWzzjxBEEfqHxvvsaoEaQyg=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=yhxlc91nQ8tv5+dbe3KldhL1aWJiFQRriK/2+uk71C4=; b=cBlucK4yMxOXjSfvTLvpEMXlUP
 v6IdZNya1nZb8KZPoUwfTns4451ivhOY8DOFNtGlWc5rgF8imBITuSd3Y2N8VCzlbs3ra2xaOk2ez
 7CY8GrcPLndpchD70i47IwqjLICPMDRRXnugMMS80q1PqcgqM0DtXcix0x7V2n0zx7Nw=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=yhxlc91nQ8tv5+dbe3KldhL1aWJiFQRriK/2+uk71C4=; b=ATucbrbfwI0IsSz7beDJkwGfs
 aQC8Jv/mKj1RIou0S87kzCtyg9yAbWH0XE7KCCgysQll2lwI9+wCSQKsw+EucYOoyNi/eW/aAtKjH
 wmtGkLAfSA07OTdtqYdVft/K3GIIZFFql5OZ1/wmIo8gjVlE1MBTDH052+4mxJ1M7mgkxLWN9OQji
 KBOZGbZfrYuF7m211usY/1URfkjUmgyS8oNF7Zt2iWa8/Gg6on77Jg/CmHSi9aTRkzTZfd0hJmURi
 o34d10EALJHLzKsTEgSFB6UqTPpiEGlBDk6ww5mOR3P9zIzgmbmQsnturAFQrOZyG63E/Ag9C7PHz
 iuT4FWvpQ==;
In-Reply-To: <20180617020052.4759-1-willy@infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Matthew Wilcox <willy@infradead.org>, linux-f2fs-devel@lists.sourceforge.net, Nicholas Piggin <npiggin@gmail.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>

Signed-off-by: Matthew Wilcox <willy@infradead.org>
Acked-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/compression.c | 4 +---
 fs/btrfs/extent_io.c   | 8 +++-----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 8db29f791984..1d051d841cb7 100644
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
index ac105d97dd81..e97aec67f52d 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5169,11 +5169,9 @@ void clear_extent_buffer_dirty(struct extent_buffer *eb)
 
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
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
