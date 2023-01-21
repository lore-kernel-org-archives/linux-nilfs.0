From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/7] mm: don't look at xarray value entries in split_huge_pages_in_file
Date: Sat, 21 Jan 2023 07:57:49 +0100
Message-ID: <20230121065755.1140136-2-hch@lst.de>
References: <20230121065755.1140136-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=B8D0bWeotdFdx7oIYHTSXz6cye3hjLZS5m2/hvamHXo=; b=SDkUBU1WsXxnF7FBjrDRJ4xZZ8
        TP3/Mu5FLI87eWKaj4CbwLn/sCwMzyOAC/rrj97FZ/LQomNPWkqgUgmWd/7kDho1tK5yhdhyfsyRQ
        bIT6z4zRDSoyIta29wHgJFACKI7JJfa2HvSBLOuGiYOCdn0yoQrEQ/qMjGro/wX78HdLrvaIa+sn4
        1340LweDytR9Qfhq4madCwpHeJ2oRGbLCDV5eEv/JIHKlFKiqC1gpvhXYQ6PrfYFg4gBpcUMsT9Tr
        UJLgfO+msrUhr9nmvs+j0mVysX5SCFr897BNqOhJ+cYqiRwv4bOlm3DNEF20F9fUO/dtZoZFLisPN
        TxKzpxzA==;
In-Reply-To: <20230121065755.1140136-1-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>
Cc: linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, cluster-devel@redhat.com, linux-mm@kvack.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nilfs@vger.kernel.org

split_huge_pages_in_file never wants to do anything with the special
value enties.  Switch to using filemap_get_folio to not even see them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/huge_memory.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1d6977dc6b31ba..a2830019aaa017 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3100,11 +3100,10 @@ static int split_huge_pages_in_file(const char *file_path, pgoff_t off_start,
 	mapping = candidate->f_mapping;
 
 	for (index = off_start; index < off_end; index += nr_pages) {
-		struct folio *folio = __filemap_get_folio(mapping, index,
-						FGP_ENTRY, 0);
+		struct folio *folio = filemap_get_folio(mapping, index);
 
 		nr_pages = 1;
-		if (xa_is_value(folio) || !folio)
+		if (!folio)
 			continue;
 
 		if (!folio_test_large(folio))
-- 
2.39.0

