From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 02/26] mpage: Convert map_buffer_to_folio() to folio_create_empty_buffers()
Date: Tue, 19 Sep 2023 05:51:11 +0100
Message-ID: <20230919045135.3635437-3-willy@infradead.org>
References: <20230919045135.3635437-1-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <reiserfs-devel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=9fxuIUmv0rn3plQF4/og445RxsuZjG3jMIUqfxIahw8=; b=BFaYsLdAmE7gx/PdwTImssQtTC
        R3BHPO08LdZ/3NOe3UnaYNyA5T+h74fBjO/dQ3DQ2k2mvGCXpO6sCdOlRDFkW2rFPLvhGxcX1cejV
        8va1HkPghMIs3g1aqcQFF22ZBkJbCakeV2qQxnwJIXoW3E8R/v87B6ybyvhgM12J+uc2R/wOoDC60
        uwar+aEergefltYvlguaRjvNidrrTrwg6LA0c68y51IHET1tQV2kWWuc586cGqR40fCw5WeFVQyYn
        QsEm7H89GPpjrRvgk67mJJYnXcqi3vp9+B/jLtlZCgtQ0/fRK38kc7800mNwfT5ZBAlnb2Rez3fwZ
        4FzLFRJg==;
In-Reply-To: <20230919045135.3635437-1-willy@infradead.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev, linux-nilfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev, reiserfs-devel@vger.kernel.org, linux-ext4@vger.kernel.org, Pankaj Raghav <p.raghav@samsung.com>

Saves a folio->page->folio conversion.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/mpage.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/mpage.c b/fs/mpage.c
index 242e213ee064..964a6efe594d 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -119,8 +119,7 @@ static void map_buffer_to_folio(struct folio *folio, struct buffer_head *bh,
 			folio_mark_uptodate(folio);
 			return;
 		}
-		create_empty_buffers(&folio->page, i_blocksize(inode), 0);
-		head = folio_buffers(folio);
+		head = folio_create_empty_buffers(folio, i_blocksize(inode), 0);
 	}
 
 	page_bh = head;
-- 
2.40.1

