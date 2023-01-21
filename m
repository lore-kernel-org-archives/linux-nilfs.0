From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 3/7] mm: use filemap_get_entry in filemap_get_incore_folio
Date: Sat, 21 Jan 2023 07:57:51 +0100
Message-ID: <20230121065755.1140136-4-hch@lst.de>
References: <20230121065755.1140136-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=g004efh7mFIQFWAsl+3c2q8E/FcH/R7MUAbwiN542N0=; b=EFQReJCGAHigmumIVdPSAnGEMd
        0BEyWnOTe6MMfLiZZZWSDU+kxTtOtBdnWxlmMO4ZVIhfVXKjivQaQoR24A6MscZ8gbOXsIN1QbDFY
        YQiGUX4r74o04uv+ms2CIVnYZd/hAbX2FbOT9TN0Sq045YI7N30YhMyQz/kHHKPeZ5O0O5DABSOTj
        o815QuZz+UAg2PTh9fDIUapX3xSlFSHFfpu2Y+3GS5lPoUXtvTXVIOWGw3Y0HjO4mgvlsIMl6Bv1E
        sQkL6QPK80o820hufzXGWywa5Xslcbu0/FrdUhfoLA4GaPF9TiVQhE7w6/kHBSsT8UG4o36gVQpWT
        HBvPxLxA==;
In-Reply-To: <20230121065755.1140136-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

filemap_get_incore_folio wants to look at the details of xa_is_value
entries, but doesn't need any of the other logic in filemap_get_folio.
Switch it to use the lower-level filemap_get_entry interface.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
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
2.39.0

