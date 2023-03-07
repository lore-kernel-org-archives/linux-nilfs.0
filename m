From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/7] mm: use filemap_get_entry in filemap_get_incore_folio
Date: Tue,  7 Mar 2023 15:34:06 +0100
Message-ID: <20230307143410.28031-4-hch@lst.de>
References: <20230307143410.28031-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-ext4-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=0QDOxt5UTDuXwd9eSSfTb8LOZ6EOp08Qp0KnyyGFYvY=; b=Ewqcz1NIcrOOM4jhZZlvKn0d0e
        y6reZtACgWFMEvT+ijOMaIzX+TC5bX5mrJCNYGjXwD6Z8EumLiyP/TLmElhtRkZIRDuwdbSqsXXzW
        iri9slVa0Jr076D9/NKXLL37Ii4vP/W6Hko57y1GNx8+3alavJBF3ZWs8Jslgens9l6njm1JAweLW
        nbQfZUDLlZxpt2dFOyAkxAcRicOsz76Eq0a8O29/EA/VBKjoWvqPtVSJn92qJ0aUjH2ZqPFQMXAiN
        C7pc2BzItSIoHAH6nLPg1YrVWmxdNr8GgFYZg3XLfphn/mpefqNG+XhXSmqpzEHF2Ol+0HqxN1M6G
        miu6jK6g==;
In-Reply-To: <20230307143410.28031-1-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>
Cc: linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, cluster-devel@redhat.com, linux-mm@kvack.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nilfs@vger.kernel.org

filemap_get_incore_folio wants to look at the details of xa_is_value
entries, but doesn't need any of the other logic in filemap_get_folio.
Switch it to use the lower-level filemap_get_entry interface.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/swap_state.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 7a003d8abb37bc..92234f4b51d29a 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -386,7 +386,7 @@ struct folio *filemap_get_incore_folio(struct address_space *mapping,
 {
 	swp_entry_t swp;
 	struct swap_info_struct *si;
-	struct folio *folio = __filemap_get_folio(mapping, index, FGP_ENTRY, 0);
+	struct folio *folio = filemap_get_entry(mapping, index);
 
 	if (!xa_is_value(folio))
 		goto out;
-- 
2.39.1

