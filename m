From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/9] mm: use filemap_get_entry in
 filemap_get_incore_folio
Date: Wed, 18 Jan 2023 10:43:23 +0100
Message-ID: <20230118094329.9553-4-hch@lst.de>
References: <20230118094329.9553-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cluster-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674035043;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=1tivNYnlYVjl+dCfTLCmKC5DzLdFgx18xVeklobnFOc=;
	b=IL+rb1h0XKLsdnkH2sTlq0g/zB4rFdt0VAmGj3cB/I6nMBmnea6j3YXy/G8K6DPZv9ZmvI
	vEVFvoH6JD96fwnwGIBfJtHVZV7VZYF8V8fiDkLZFv67A7DNOC5oyjtS1oQb+3YEz+H3Km
	AKpCT64bxRRy8m96rkvWmirLHaw4lMg=
In-Reply-To: <20230118094329.9553-1-hch@lst.de>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/cluster-devel>, 
 <mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/cluster-devel/>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/cluster-devel>,
 <mailto:cluster-devel-request@redhat.com?subject=subscribe>
Errors-To: cluster-devel-bounces@redhat.com
Sender: "Cluster-devel" <cluster-devel-bounces@redhat.com>
Content-Type: text/plain; charset="us-ascii"; x-default="true"
To: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>
Cc: linux-xfs@vger.kernel.org, linux-nilfs@vger.kernel.org, cluster-devel@redhat.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org

filemap_get_incore_folio wants to look at the details of xa_is_value
entries, but doesn't need any of the other logic in filemap_get_folio.
Switch it to use the lower-level filemap_get_entry interface.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/swap_state.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index cb9aaa00951d99..c39ea34bc4fc10 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -380,7 +380,7 @@ struct folio *filemap_get_incore_folio(struct address_space *mapping,
 {
 	swp_entry_t swp;
 	struct swap_info_struct *si;
-	struct folio *folio = __filemap_get_folio(mapping, index, FGP_ENTRY, 0);
+	struct folio *folio = filemap_get_entry(mapping, index);
 
 	if (!xa_is_value(folio))
 		goto out;
-- 
2.39.0

