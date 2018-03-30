From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v10 57/62] dax: Convert dax_layout_busy_page to
 XArray
Date: Thu, 29 Mar 2018 20:42:40 -0700
Message-ID: <20180330034245.10462-58-willy@infradead.org>
References: <20180330034245.10462-1-willy@infradead.org>
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
 bh=xakyJ7OF+7ISAZKtOMVXLKjGBAJle+bq5l+U39LJfF0=; b=d+JWv+kAa7Wds0iJYQjMisWrY7
 yjLxAtt0UGLpU+Gko5e5CaUscF5k5lpJmdv9bCvr+xz+CkMBfZU+BWiGN9kHtmSSGbkydeH608vPB
 eNyDoL816+r2gNl2qdc1qu1DRtB6WqHOayYSthaG8Mqwk/iNDOTNesmOADDLSF4F+yzg=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=xakyJ7OF+7ISAZKtOMVXLKjGBAJle+bq5l+U39LJfF0=; b=jFNvh0M7qNRQbGR0Ou4ETxYlwn
 g1p0fKMwrjB2diLHNF3yTjGlHqI22OUKHQX4oFTdnrttfqPCBzPHTlmjvledb4PTgfvOCTf48FIBZ
 kw1UamO7yhxSxHpVzAvcwb4J+SfqDAm+YjhiGscEssdM1D2iigjpkgPgs7O3p2vmQOvo=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=xakyJ7OF+7ISAZKtOMVXLKjGBAJle+bq5l+U39LJfF0=; b=ZPo6QOly7f/KYux5s0dEFmP44
 FKysEja6oYw7FhBfZncC4IiDa2rnOrgpXBnRL5ip1lJ6GXIF+inKQgk4tvVQ0goLyr0GVEckXxnuH
 ubnJUQK2Wt3wuHv0RtqeFGfEDNU6xw19nYHg3VM9Z+UMgtt9yVwYjRHBpaSZZSirV5MQF0Q5VRE34
 mPT3VssqqKTuCjOEGtnquASI4/cvb/ZS2DCI/Kouf8amvRqHya0mFZDR7yd4MAxTWT1vXiB0+axG2
 9Z1fVJ3Y2BK9ZgCEoel5FS6yHLB6Hrl4sEb0Yq8CI4hdq68ZL5T8Sc2vBPRrk3VKdJnwqAsD0/VBZ
 AkBimZShQ==;
In-Reply-To: <20180330034245.10462-1-willy@infradead.org>
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

Instead of using a pagevec, just use the XArray iterators.  Add a
conditional rescheduling point which probably should have been there in
the original.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/dax.c | 54 ++++++++++++++++++++----------------------------------
 1 file changed, 20 insertions(+), 34 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 54ec283f5031..825bf153f499 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -607,11 +607,10 @@ static void *grab_mapping_entry(struct address_space *mapping, pgoff_t index,
  */
 struct page *dax_layout_busy_page(struct address_space *mapping)
 {
-	pgoff_t	indices[PAGEVEC_SIZE];
+	XA_STATE(xas, &mapping->i_pages, 0);
+	void *entry;
+	unsigned int scanned = 0;
 	struct page *page = NULL;
-	struct pagevec pvec;
-	pgoff_t	index, end;
-	unsigned i;
 
 	/*
 	 * In the 'limited' case get_user_pages() for dax is disabled.
@@ -622,9 +621,6 @@ struct page *dax_layout_busy_page(struct address_space *mapping)
 	if (!dax_mapping(mapping) || !mapping_mapped(mapping))
 		return NULL;
 
-	pagevec_init(&pvec);
-	index = 0;
-	end = -1;
 	/*
 	 * Flush dax_layout_lock() sections to ensure all possible page
 	 * references have been taken, or otherwise arrange for faults
@@ -634,36 +630,26 @@ struct page *dax_layout_busy_page(struct address_space *mapping)
 	unmap_mapping_range(mapping, 0, 0, 1);
 	synchronize_rcu();
 
-	while (index < end && pagevec_lookup_entries(&pvec, mapping, index,
-				min(end - index, (pgoff_t)PAGEVEC_SIZE),
-				indices)) {
-		for (i = 0; i < pagevec_count(&pvec); i++) {
-			struct page *pvec_ent = pvec.pages[i];
-			void *entry;
-
-			index = indices[i];
-			if (index >= end)
-				break;
-
-			if (!xa_is_value(pvec_ent))
-				continue;
-
-			xa_lock_irq(&mapping->i_pages);
-			entry = get_unlocked_mapping_entry(mapping, index, NULL);
-			if (entry)
-				page = dax_busy_page(entry);
-			put_unlocked_mapping_entry(mapping, index, entry);
-			xa_unlock_irq(&mapping->i_pages);
-			if (page)
-				break;
-		}
-		pagevec_remove_exceptionals(&pvec);
-		pagevec_release(&pvec);
-		index++;
-
+	xas_lock_irq(&xas);
+	xas_for_each(&xas, entry, ULONG_MAX) {
+		if (!xa_is_value(entry))
+			continue;
+		if (unlikely(dax_is_locked(entry)))
+			entry = get_unlocked_entry(&xas);
+		if (entry)
+			page = dax_busy_page(entry);
+		put_unlocked_entry(&xas, entry);
 		if (page)
 			break;
+		if (++scanned % XA_CHECK_SCHED)
+			continue;
+
+		xas_pause(&xas);
+		xas_unlock_irq(&xas);
+		cond_resched();
+		xas_lock_irq(&xas);
 	}
+	xas_unlock_irq(&xas);
 	return page;
 }
 EXPORT_SYMBOL_GPL(dax_layout_busy_page);
-- 
2.16.2


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
