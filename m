From: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH 06/26] gfs2: Convert gfs2_getbuf() to folios
Date: Tue, 19 Sep 2023 05:51:15 +0100
Message-ID: <20230919045135.3635437-7-willy@infradead.org>
References: <20230919045135.3635437-1-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Ep+lGsUKoAhhoh5nGmL8xgZABVJF/mpZxcy36ZruWb4=; b=vO2K2Tuq7037t/0SesH2/eziLu
        uGH3UQu9Fsa0K4dMxv47uzoehSSSinC5hHRPGn+VDixAIjWRl7cGFUZwQyqJ0vU0j7uyl8x/5e+7d
        HTnxD3dLkPXF4HOflRIvlUWmcokgH+8dyPLQNdjk8Cl5+/M/yowY8QNR6iTF3x5QifEEoj1NEak2c
        fW/XqatqLhBbMt0z6EAtOlTX+Z84OqHdI0w1fZteN1M6ef0ieY5VxQ0OQxJZDrtY+lurvOz29QP+D
        nhrlu1hlV4oGDhpa2RLzPVGI2JLoB913W/Dv1lR39wR1vhJ3++10FdRa3hEWuSym2k7XLX2xdwMxP
        iqgFku+A==;
In-Reply-To: <20230919045135.3635437-1-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gfs2-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ntfs-dev-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, ntfs3-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, ocfs2-devel-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, reiserfs-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pankaj Raghav <p.raghav-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

Remove several folio->page->folio conversions.  Also use __GFP_NOFAIL
instead of calling yield() and the new get_nth_bh().

Signed-off-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
---
 fs/gfs2/meta_io.c | 39 +++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index 924361fa510b..f1fac1b45059 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -115,7 +115,7 @@ struct buffer_head *gfs2_getbuf(struct gfs2_glock *gl, u64 blkno, int create)
 {
 	struct address_space *mapping = gfs2_glock2aspace(gl);
 	struct gfs2_sbd *sdp = gl->gl_name.ln_sbd;
-	struct page *page;
+	struct folio *folio;
 	struct buffer_head *bh;
 	unsigned int shift;
 	unsigned long index;
@@ -129,36 +129,31 @@ struct buffer_head *gfs2_getbuf(struct gfs2_glock *gl, u64 blkno, int create)
 	bufnum = blkno - (index << shift);  /* block buf index within page */
 
 	if (create) {
-		for (;;) {
-			page = grab_cache_page(mapping, index);
-			if (page)
-				break;
-			yield();
-		}
-		if (!page_has_buffers(page))
-			create_empty_buffers(page, sdp->sd_sb.sb_bsize, 0);
+		folio = __filemap_get_folio(mapping, index,
+				FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
+				mapping_gfp_mask(mapping) | __GFP_NOFAIL);
+		bh = folio_buffers(folio);
+		if (!bh)
+			bh = folio_create_empty_buffers(folio,
+				sdp->sd_sb.sb_bsize, 0);
 	} else {
-		page = find_get_page_flags(mapping, index,
-						FGP_LOCK|FGP_ACCESSED);
-		if (!page)
+		folio = __filemap_get_folio(mapping, index,
+				FGP_LOCK | FGP_ACCESSED, 0);
+		if (IS_ERR(folio))
 			return NULL;
-		if (!page_has_buffers(page)) {
-			bh = NULL;
-			goto out_unlock;
-		}
+		bh = folio_buffers(folio);
 	}
 
-	/* Locate header for our buffer within our page */
-	for (bh = page_buffers(page); bufnum--; bh = bh->b_this_page)
-		/* Do nothing */;
-	get_bh(bh);
+	if (!bh)
+		goto out_unlock;
 
+	bh = get_nth_bh(bh, bufnum);
 	if (!buffer_mapped(bh))
 		map_bh(bh, sdp->sd_vfs, blkno);
 
 out_unlock:
-	unlock_page(page);
-	put_page(page);
+	folio_unlock(folio);
+	folio_put(folio);
 
 	return bh;
 }
-- 
2.40.1

