From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v14 46/74] pagevec: Use xa_tag_t
Date: Sat, 16 Jun 2018 19:00:24 -0700
Message-ID: <20180617020052.4759-47-willy@infradead.org>
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
 bh=Jma1TiXYXgzbd/mOR5mS37ALLbcKLGTSgi/PIzREx/M=; b=G8OPdnzT/ukJpWrK7rG9mHPjfm
 r0dEhJm+jd6B8nDumKte3Ya8WhEN+2k3iM8jsK5dZ5AbOYSOpA3NsrIHjme6CDa9a1SC37CsGt7dm
 z2J9MZ3GHp5c5RBTgClPpEUNHK8DoBv1JkZAttFgPwflpBlDZm64X8cxwBhXqYt/xsSg=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=Jma1TiXYXgzbd/mOR5mS37ALLbcKLGTSgi/PIzREx/M=; b=FlIbHRS3m8AYrXqWbj6NmEE0Yl
 q+GATbEtx80lsLgariPSQfv0btqEph3RD76KiLHZpOR/3oNOumaTTOw6LLcZAX8Lqxs8UVhAq5jBt
 mG4h5nk/y453oJ9fPJXc9FU2gnpHWYo6iII+dFCepUrXEBurxut+DCQ949EXnQ6UiHkU=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=Jma1TiXYXgzbd/mOR5mS37ALLbcKLGTSgi/PIzREx/M=; b=fwWZtttCxY+0MmbUgv/KTnqSz
 2QxR9WoCQwWJjtieIzUFai9TwYYAJpBFStnrHWuq9wrjhOy/zirnUHLes7qf7jj+ljtnxorPvz5Am
 YHaBRaeZk8nTfE9bXmAtmAYd4ZXBkTDraDqN/2m1QFHX8leQhEzitQwUeVij6Jbk5OHiHtoTT9TAt
 0NQbeAkf7oRDz89TaaYgkNLafY7lj7wA6X2C7/W4KZTnWsIO0mwBYgcofzH1E+FdpZUKcKBbB1LRt
 bJFhOejTG3H7M0nWxZgz/VghNiH+UINRZDcNCLZJ2PWtbxpP77y2e7iXse8ORK3/AYogrMqNBaqWl
 eOYDnzEpw==;
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

Removes sparse warnings.

Signed-off-by: Matthew Wilcox <willy@infradead.org>
---
 fs/btrfs/extent_io.c    | 4 ++--
 fs/ext4/inode.c         | 2 +-
 fs/f2fs/data.c          | 2 +-
 fs/gfs2/aops.c          | 2 +-
 include/linux/pagevec.h | 8 +++++---
 mm/swap.c               | 4 ++--
 6 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index cce6087d6880..ac105d97dd81 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3792,7 +3792,7 @@ int btree_write_cache_pages(struct address_space *mapping,
 	pgoff_t index;
 	pgoff_t end;		/* Inclusive */
 	int scanned = 0;
-	int tag;
+	xa_tag_t tag;
 
 	pagevec_init(&pvec);
 	if (wbc->range_cyclic) {
@@ -3917,7 +3917,7 @@ static int extent_write_cache_pages(struct address_space *mapping,
 	pgoff_t done_index;
 	int range_whole = 0;
 	int scanned = 0;
-	int tag;
+	xa_tag_t tag;
 
 	/*
 	 * We have to hold onto the inode so that ordered extents can do their
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 38214c05f204..e6c433527dce 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2615,7 +2615,7 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
 	long left = mpd->wbc->nr_to_write;
 	pgoff_t index = mpd->first_page;
 	pgoff_t end = mpd->last_page;
-	int tag;
+	xa_tag_t tag;
 	int i, err = 0;
 	int blkbits = mpd->inode->i_blkbits;
 	ext4_lblk_t lblk;
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 8f931d699287..e5c0b1e74ce6 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1942,7 +1942,7 @@ static int f2fs_write_cache_pages(struct address_space *mapping,
 	pgoff_t last_idx = ULONG_MAX;
 	int cycled;
 	int range_whole = 0;
-	int tag;
+	xa_tag_t tag;
 
 	pagevec_init(&pvec);
 
diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 35f5ee23566d..b8609bb1e2e0 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -370,7 +370,7 @@ static int gfs2_write_cache_jdata(struct address_space *mapping,
 	pgoff_t done_index;
 	int cycled;
 	int range_whole = 0;
-	int tag;
+	xa_tag_t tag;
 
 	pagevec_init(&pvec);
 	if (wbc->range_cyclic) {
diff --git a/include/linux/pagevec.h b/include/linux/pagevec.h
index 6dc456ac6136..955bd6425903 100644
--- a/include/linux/pagevec.h
+++ b/include/linux/pagevec.h
@@ -9,6 +9,8 @@
 #ifndef _LINUX_PAGEVEC_H
 #define _LINUX_PAGEVEC_H
 
+#include <linux/xarray.h>
+
 /* 15 pointers + header align the pagevec structure to a power of two */
 #define PAGEVEC_SIZE	15
 
@@ -40,12 +42,12 @@ static inline unsigned pagevec_lookup(struct pagevec *pvec,
 
 unsigned pagevec_lookup_range_tag(struct pagevec *pvec,
 		struct address_space *mapping, pgoff_t *index, pgoff_t end,
-		int tag);
+		xa_tag_t tag);
 unsigned pagevec_lookup_range_nr_tag(struct pagevec *pvec,
 		struct address_space *mapping, pgoff_t *index, pgoff_t end,
-		int tag, unsigned max_pages);
+		xa_tag_t tag, unsigned max_pages);
 static inline unsigned pagevec_lookup_tag(struct pagevec *pvec,
-		struct address_space *mapping, pgoff_t *index, int tag)
+		struct address_space *mapping, pgoff_t *index, xa_tag_t tag)
 {
 	return pagevec_lookup_range_tag(pvec, mapping, index, (pgoff_t)-1, tag);
 }
diff --git a/mm/swap.c b/mm/swap.c
index 4c5c7fcc6e46..a7ff602213a9 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -1002,7 +1002,7 @@ EXPORT_SYMBOL(pagevec_lookup_range);
 
 unsigned pagevec_lookup_range_tag(struct pagevec *pvec,
 		struct address_space *mapping, pgoff_t *index, pgoff_t end,
-		int tag)
+		xa_tag_t tag)
 {
 	pvec->nr = find_get_pages_range_tag(mapping, index, end, tag,
 					PAGEVEC_SIZE, pvec->pages);
@@ -1012,7 +1012,7 @@ EXPORT_SYMBOL(pagevec_lookup_range_tag);
 
 unsigned pagevec_lookup_range_nr_tag(struct pagevec *pvec,
 		struct address_space *mapping, pgoff_t *index, pgoff_t end,
-		int tag, unsigned max_pages)
+		xa_tag_t tag, unsigned max_pages)
 {
 	pvec->nr = find_get_pages_range_tag(mapping, index, end, tag,
 		min_t(unsigned int, max_pages, PAGEVEC_SIZE), pvec->pages);
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
