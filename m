From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 14/26] nilfs2: Remove nilfs_page_get_nth_block
Date: Tue, 19 Sep 2023 05:51:23 +0100
Message-ID: <20230919045135.3635437-15-willy@infradead.org>
References: <20230919045135.3635437-1-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=N6ovGOYS7j9q8wOyOWu2B5Uq08RUxsjTVDWIGzX0CMc=; b=gSD3y3/0A4Cql8OnDXKyDsG0Fv
        9uPTYM++ZTTpjlvVSbjwWQXbSealfQoNsXpNk2+yC1nPtlDm2XYBVpaA8ICYBxXivHGctfLVMCF/S
        H6CDp5UXLG6U9JliMb4c7sUyywozbLxXn3gdN7RlpWMgYuYvfWoka3oJzZKC9nzW4NvUylmkovvEK
        gpggozbu5Ll4n5Mq7yQkrMVUXxrEnf2CCIY/+JT/CeSHmWaBsaCYS9SG/KwfCMwEVYfosVeKkbnbY
        opkub3P2d6AHdTtVu1T+4I5q42urpgatsRyE9F/eCAGFUAE4t6ifmEG7dtjhZ4NOGLG+Lz22GVv29
        2qKJiJwA==;
In-Reply-To: <20230919045135.3635437-1-willy@infradead.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev, linux-nilfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev, reiserfs-devel@vger.kernel.org, linux-ext4@vger.kernel.org, Pankaj Raghav <p.raghav@samsung.com>

All users have now been converted to get_nth_block().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/nilfs2/page.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/nilfs2/page.h b/fs/nilfs2/page.h
index 344d71942d36..d249ea1cefff 100644
--- a/fs/nilfs2/page.h
+++ b/fs/nilfs2/page.h
@@ -52,10 +52,4 @@ unsigned long nilfs_find_uncommitted_extent(struct inode *inode,
 #define NILFS_PAGE_BUG(page, m, a...) \
 	do { nilfs_page_bug(page); BUG(); } while (0)
 
-static inline struct buffer_head *
-nilfs_page_get_nth_block(struct page *page, unsigned int count)
-{
-	return get_nth_bh(page_buffers(page), count);
-}
-
 #endif /* _NILFS_PAGE_H */
-- 
2.40.1

