From: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH 09/10] shmem: Convert shmem_unlock_mapping() to use filemap_get_folios()
Date: Sun,  5 Jun 2022 20:38:53 +0100
Message-ID: <20220605193854.2371230-10-willy@infradead.org>
References: <20220605193854.2371230-1-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=nZd7FdfhHHpfkPZj2gtn0+UCb6ZHZaprTIaRzyl1jXk=; b=uFlx6IYCw7cKUMv6UFQU0NiN2j
        iQ24sV1L+N0JJ+PYt+whKlcyMvxX397wDiXAeuW16ipXpv7uj75S+ifah7UED1rGBmJ6INgUn0EaP
        +9Vs3ySStr9qIgZ0zF6RDK7wq0A7Z8UrY0v2gbCiqtYZYhxFzeNL/2ggxHjmv6qm+147lvrX2dSYA
        KrGPUqo5c0kBsr1HE5k1I7rfjNq5kWWJNZbU41W0uuZJbmiuIPzLxEOUcBBG4y5IcjIH3D5ekaRwS
        R4P3XSnF1YkMw+gsOSK1a5dkmx/misM3DKGpZBhb7qWzj2lws1FAo2SU2BuaoFyWnchKohsh2xIzm
        dolxg0Dg==;
In-Reply-To: <20220605193854.2371230-1-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This is a straightforward conversion.

Signed-off-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
---
 mm/shmem.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 60fdfc0208fd..313ae7df59d8 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -867,18 +867,17 @@ unsigned long shmem_swap_usage(struct vm_area_struct *vma)
  */
 void shmem_unlock_mapping(struct address_space *mapping)
 {
-	struct pagevec pvec;
+	struct folio_batch fbatch;
 	pgoff_t index = 0;
 
-	pagevec_init(&pvec);
+	folio_batch_init(&fbatch);
 	/*
 	 * Minor point, but we might as well stop if someone else SHM_LOCKs it.
 	 */
-	while (!mapping_unevictable(mapping)) {
-		if (!pagevec_lookup(&pvec, mapping, &index))
-			break;
-		check_move_unevictable_pages(&pvec);
-		pagevec_release(&pvec);
+	while (!mapping_unevictable(mapping) &&
+	       filemap_get_folios(mapping, &index, ~0UL, &fbatch)) {
+		check_move_unevictable_folios(&fbatch);
+		folio_batch_release(&fbatch);
 		cond_resched();
 	}
 }
-- 
2.35.1

