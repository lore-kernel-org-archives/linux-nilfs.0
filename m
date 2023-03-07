From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 1/7] mm: don't look at xarray value entries in split_huge_pages_in_file
Date: Tue,  7 Mar 2023 15:34:04 +0100
Message-ID: <20230307143410.28031-2-hch@lst.de>
References: <20230307143410.28031-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=DOdTgLf35ydRPhAUtTqGnhMAFPKhMEWQTwS1vfOj9sA=; b=FiHVIwcsDu+ndeHzk6EWd+nGqo
        UYlDj93dbp9kRox0m0240+2Y2+7RIaJXnC+SCRr2a1OSd5V40RhN1bHw3Kr06IvqIEC5w2Jy9NUeh
        F821dVlrNBPtovMrZbKNRp/cwgwH8s+pvTRlZZCjgNlPmX5lEHLNJDBa/AI7PNJwIJ/3sZMOHSrbG
        v5hCwOUnYfzy7fJwh7fryav1gVZNmhY5Z8Y1XZeSa37bi+2TP9IWJQTVoqyIn5zi8naX8IAv2+GTh
        kFzEHjrB0ld6bGeMFdvmFQKIZJshKy2xZWXuLIqC5Lryk5z2WRPZ8bVCqVfMEZsXGI6gtE64dYPH2
        G44UPoLw==;
In-Reply-To: <20230307143410.28031-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

split_huge_pages_in_file never wants to do anything with the special
value enties.  Switch to using filemap_get_folio to not even see them.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
---
 mm/huge_memory.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 4fc43859e59a31..62843afeb7946d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3090,11 +3090,10 @@ static int split_huge_pages_in_file(const char *file_path, pgoff_t off_start,
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
2.39.1

