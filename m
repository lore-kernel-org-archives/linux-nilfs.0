From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v11 34/63] pagevec: Use xa_tag_t
Date: Sat, 14 Apr 2018 07:12:47 -0700
Message-ID: <20180414141316.7167-35-willy@infradead.org>
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
 bh=WoWJfaKk1wyLX/iEsFqkbIBHobfAceZTFHiy1XjQQpk=; b=fKvR0/zWPxO2ZTgI5lAE+sDUWW
 3Pvr3AWe1zVsf3CbN90fJpOlEO/KmvYQxsYBsaonIaTmgaaOC9GlrHfbdJbNDxwW3jwDncdI2My0R
 7E8u+XkFi8zWdQYFJg2OdroPIXq2ZBAHuh+jyaYixUcNNBjHyheFlQmvJCgLjLpDYKMs=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=WoWJfaKk1wyLX/iEsFqkbIBHobfAceZTFHiy1XjQQpk=; b=XowD/1fxJe9NqXk/i9ynZyhgA8
 P3i19mwShZcyhF9D7TiX3tby2huXDlW7FAJsrqdSn9xwrDx3FGdfJApCFSRbiEE3GmlmMNKctzpXY
 gYP5MO1qbZsNny951ahu/nCqbAxFEXKdfAtkutJ91Lx60O9OvdAV9VINK+Tj8oyM2svY=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=WoWJfaKk1wyLX/iEsFqkbIBHobfAceZTFHiy1XjQQpk=; b=Gy0Hxv/54UbWhkyygAfF2EbDn
 fytFyEIUs2ckpVyMilHJPXJtKapsgMvFxRqZBz8RF5hLSs2D2igCna7ydBynAoF86IwGn2OsehQfC
 H+1hkyos2Ni4Uspcp02+viPj7d9Mt0uLeus+rRK1v2+bhTOVyuHPAWtJHYP4JN+gNgtHqrojhaw0Y
 gplFGYWksMs+34nPQIANQcdSU8r1i7WJDkxM8k1hf+UM8bqnIfOMFsqdownodiI9OyusHoymLiP7a
 f4c4kDQKNaca9uM6TNig6C2Y5xTRIe0MqsbrNq1aU1CyFVGAYdELU99CO7VE67mKCpXCzu3H7xjC3
 LeBaUn9vw==;
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

Removes sparse warnings.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/btrfs/extent_io.c    | 4 ++--
 fs/ext4/inode.c         | 2 +-
 fs/f2fs/data.c          | 2 +-
 fs/gfs2/aops.c          | 2 +-
 include/linux/pagevec.h | 8 +++++---
 mm/swap.c               | 4 ++--
 6 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index e99b329002cf..85092edb0c99 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3795,7 +3795,7 @@ int btree_write_cache_pages(struct address_space *mapping,
 	pgoff_t index;
 	pgoff_t end;		/* Inclusive */
 	int scanned = 0;
-	int tag;
+	xa_tag_t tag;
 
 	pagevec_init(&pvec);
 	if (wbc->range_cyclic) {
@@ -3920,7 +3920,7 @@ static int extent_write_cache_pages(struct address_space *mapping,
 	pgoff_t done_index;
 	int range_whole = 0;
 	int scanned = 0;
-	int tag;
+	xa_tag_t tag;
 
 	/*
 	 * We have to hold onto the inode so that ordered extents can do their
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 37a2f7a2b66a..6c071d63e5f1 100644
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
index 02237d4d91f5..d836bfc160f1 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1874,7 +1874,7 @@ static int f2fs_write_cache_pages(struct address_space *mapping,
 	pgoff_t last_idx = ULONG_MAX;
 	int cycled;
 	int range_whole = 0;
-	int tag;
+	xa_tag_t tag;
 
 	pagevec_init(&pvec);
 
diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index f58716567972..8376d1358379 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -371,7 +371,7 @@ static int gfs2_write_cache_jdata(struct address_space *mapping,
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
index 79ded98f8c7a..5a217947802c 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -1001,7 +1001,7 @@ EXPORT_SYMBOL(pagevec_lookup_range);
 
 unsigned pagevec_lookup_range_tag(struct pagevec *pvec,
 		struct address_space *mapping, pgoff_t *index, pgoff_t end,
-		int tag)
+		xa_tag_t tag)
 {
 	pvec->nr = find_get_pages_range_tag(mapping, index, end, tag,
 					PAGEVEC_SIZE, pvec->pages);
@@ -1011,7 +1011,7 @@ EXPORT_SYMBOL(pagevec_lookup_range_tag);
 
 unsigned pagevec_lookup_range_nr_tag(struct pagevec *pvec,
 		struct address_space *mapping, pgoff_t *index, pgoff_t end,
-		int tag, unsigned max_pages)
+		xa_tag_t tag, unsigned max_pages)
 {
 	pvec->nr = find_get_pages_range_tag(mapping, index, end, tag,
 		min_t(unsigned int, max_pages, PAGEVEC_SIZE), pvec->pages);
-- 
2.17.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
