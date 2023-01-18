From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/9] mm: don't look at xarray value entries
 in split_huge_pages_in_file
Date: Wed, 18 Jan 2023 10:43:21 +0100
Message-ID: <20230118094329.9553-2-hch@lst.de>
References: <20230118094329.9553-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cluster-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674035034;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=MhCSeZxb0+ckteL2o3EcN0B0EMYZcaQYxCAND8YfTVw=;
	b=dq8R0U6nyZq/Lgj33uWQo1lGmQF4GW7Eys5uQEILbk+/Es2OEnlepWkzN3NmufvIMh6RA3
	aaEziAK2cYAO5bGdQvzXDzojtthIFE1HAcDGSEKl40qAB3U0xyaWm+V9FKSixzPFAFYoKB
	JLKjCPNAsunWijIbTLTgtylAcsIrgEI=
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

split_huge_pages_in_file never wants to do anything with the special
value enties.  Switch to using filemap_get_folio to not even see them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
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

