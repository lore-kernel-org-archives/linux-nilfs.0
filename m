From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v5 27/78] page cache: Convert page deletion to
 XArray
Date: Fri, 15 Dec 2017 14:03:59 -0800
Message-ID: <20171215220450.7899-28-willy@infradead.org>
References: <20171215220450.7899-1-willy@infradead.org>
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
 bh=Q69+Wj076p6U0Esf3JxjMdaU2B+mCgdgZ4c1IthPP9A=; b=jdmDQeTkEYth8u5qzvqv2+jSSd
 9qVbg7FSLQ6MF872dMfW+t9BtjevzvZjXxQxtNdYq4+Cokk/3XUeYnHnPd2FvK1tU0HDDfJ7GHUq3
 nUa6ZSDDLjZ8z/bJSCJdXe2JISe8OA2icKfc7LX1yUJmNu8pGx3lpPaULYE8RnUT8TmY=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=Q69+Wj076p6U0Esf3JxjMdaU2B+mCgdgZ4c1IthPP9A=; b=LPO12X8YkFx9WJ2jSVS7I0MN3U
 MN0QBHAl6cpNIwtoUnd7mgDY3uK7afz6cAM/vJwyPTeU7K6A0pF3bA14MCtpfojtaR3zGtKyyAObu
 93RNL+y8Y63dvWBd/inbpb99lmSk5yKkCtzfnpC76h2WSQZ4EoSPgtfP63PwLD4oqnVY=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=Q69+Wj076p6U0Esf3JxjMdaU2B+mCgdgZ4c1IthPP9A=; b=a43fBk2q7ZykHm4WWmQJd34qW
 g9D3CHCMqwbmwbGMjEfM/AhTHx68usTp7Ekh7thASyvOcQvFHK9uFempK+pC5hV4ERMs1wYnOP+wV
 NvRG6iuJiZ2D793AaD2a70JWlnQTkef8Vny72FCsXwMSaYeeGkoji2/QEazVXjiUY7dIS+tDIf0VO
 p7y5luZy/GGsWXE7SU2R/K32l/r1iW6Z558rjNtOaSIaf7Sxk6IKkUI3yJ3GkTmIG5jgVPUUQ7udT
 By9wWdE+j1ZtL+zwG00A2oi5W0cGhTkjCEhWy7BHUxg3GodtZIXrCc5R3Y9YuOsXd9r1q6kbYm3+o
 2EbPAF23g==;
In-Reply-To: <20171215220450.7899-1-willy@infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, linux-xfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-raid@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-usb@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, David Howells <dhowells@redhat.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Rehas Sachdeva <aquannie@gmail.com>, Shaohua Li <shli@kernel.org>, linux-btrfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

The code is slightly shorter and simpler.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/filemap.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 91df92f5c96d..c9bc0dee0154 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -115,27 +115,25 @@
 static void page_cache_tree_delete(struct address_space *mapping,
 				   struct page *page, void *shadow)
 {
-	int i, nr;
+	XA_STATE(xas, &mapping->pages, page->index);
+	unsigned int i, nr;
 
-	/* hugetlb pages are represented by one entry in the radix tree */
+	xas_set_update(&xas, workingset_lookup_update(mapping));
+
+	/* hugetlb pages are represented by a single entry in the xarray */
 	nr = PageHuge(page) ? 1 : hpage_nr_pages(page);
 
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(PageTail(page), page);
 	VM_BUG_ON_PAGE(nr != 1 && shadow, page);
 
-	for (i = 0; i < nr; i++) {
-		struct radix_tree_node *node;
-		void **slot;
-
-		__radix_tree_lookup(&mapping->pages, page->index + i,
-				    &node, &slot);
-
-		VM_BUG_ON_PAGE(!node && nr != 1, page);
-
-		radix_tree_clear_tags(&mapping->pages, node, slot);
-		__radix_tree_replace(&mapping->pages, node, slot, shadow,
-				workingset_lookup_update(mapping));
+	i = nr;
+repeat:
+	xas_store(&xas, shadow);
+	xas_init_tags(&xas);
+	if (--i) {
+		xas_next(&xas);
+		goto repeat;
 	}
 
 	page->mapping = NULL;
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
