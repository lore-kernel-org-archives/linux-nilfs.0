From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v14 65/74] dax: Convert dax_layout_busy_page to
 XArray
Date: Sat, 16 Jun 2018 19:00:43 -0700
Message-ID: <20180617020052.4759-66-willy@infradead.org>
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
 bh=tEOFzlT+od5bOh/ypS1B0w/JWs8F+t7+Bb3rIKpKXVE=; b=T4ONSrQ3NBQ/6CGrBqUNojeIwz
 xTVWP1RGVPnRhFTL9dJ8RgtN5zfjbedbVWGD4b/M2EvnyH9trC0zhMU6x0ver0ZuzWDWk4O6tntdr
 DaxE/lkSUBiOJeEOYXI05iEjfFrlL+mhrH5gCcad4WaLJ758TpIaca5aX6cB5RsmvjJs=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=tEOFzlT+od5bOh/ypS1B0w/JWs8F+t7+Bb3rIKpKXVE=; b=cpap2enAlhi+va7kJR874IYjh1
 9t+K3XUYLs0MbRf1z5tOQ3Bb3xG3Ek9maG+MdnVOWC4EUl0hIGYkFXHaZsKdF8umhP1IiNb/zXRTh
 N6yxNAVDB4eCBMv4mkuWTfzTAtgb8yNuNkYeqP2wxihcijf2nTY3JTwiM3FBNNkaMXn0=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=tEOFzlT+od5bOh/ypS1B0w/JWs8F+t7+Bb3rIKpKXVE=; b=ekXbeFxcrWCKvvU7zDX+ol38A
 43Vty+N9h9n1RbL4ER3Q/jb6kwujjlJHYpCpdPn5B3WypBVhOWL8tXiycJtM+OZb5xo/M2/DqX220
 sWc0nLMkzFG/VPkuCxy8afGjp90uN18FEy5nRfbcCksC5hv38VuMbm2R+PUdAGbf/GTX54h3XmPmE
 4CiiLUtYjWBuDBz4MLwwuI+Jk8LXEsF2g7PjxZ1bGWCHkPeHnmrnK7HbH14z81GDsi0FmGOfoAmkU
 vhm9hD9ANSvnO9vdJ2pUoqjUzv2KP5vwzfYW/+wFvOgjFhBAge/7aqbMtibL5Sk9O0Q7ak/ZMPPlZ
 cCQPQ2LKA==;
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

Instead of using a pagevec, just use the XArray iterators.  Add a
conditional rescheduling point which probably should have been there in
the original.

Signed-off-by: Matthew Wilcox <willy@infradead.org>
---
 fs/dax.c | 57 +++++++++++++++++++++-----------------------------------
 1 file changed, 21 insertions(+), 36 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 71181f4bb1d3..7b80b17cba50 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -697,11 +697,10 @@ static void *grab_mapping_entry(struct address_space *mapping, pgoff_t index,
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
@@ -712,13 +711,9 @@ struct page *dax_layout_busy_page(struct address_space *mapping)
 	if (!dax_mapping(mapping) || !mapping_mapped(mapping))
 		return NULL;
 
-	pagevec_init(&pvec);
-	index = 0;
-	end = -1;
-
 	/*
 	 * If we race get_user_pages_fast() here either we'll see the
-	 * elevated page count in the pagevec_lookup and wait, or
+	 * elevated page count in the iteration and wait, or
 	 * get_user_pages_fast() will see that the page it took a reference
 	 * against is no longer mapped in the page tables and bail to the
 	 * get_user_pages() slow path.  The slow path is protected by
@@ -730,36 +725,26 @@ struct page *dax_layout_busy_page(struct address_space *mapping)
 	 */
 	unmap_mapping_range(mapping, 0, 0, 1);
 
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
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
