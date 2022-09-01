From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH 09/23] cifs: Convert wdata_alloc_and_fillpages()
 to use filemap_get_folios_tag()
Date: Thu,  1 Sep 2022 15:01:24 -0700
Message-ID: <20220901220138.182896-10-vishal.moola@gmail.com>
References: <20220901220138.182896-1-vishal.moola@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Transfer-Encoding:MIME-Version:References:
 In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=YET10ng1nR0ea8GMjh+/irz/Zcx26qfqc4LRuHlkdsg=; b=db04a/JTdhdYR+rUzrNwvIqf2Q
 shdYr0/H78hZkME8phvJ7UQMDb0OHSndZv+ddjySo7TfJw/XZsSgiU2ETpud357Frfxeekdza3Dc9
 EsDU9kFdZGskMKFEDJsp/sCcbcuu1C6r7WCVNr7duFvzVHI+wUEdqsO06Cq7wAnXyneo=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=YET10ng1nR0ea8GMjh+/irz/Zcx26qfqc4LRuHlkdsg=; b=EoJrrhsy7PzcN/00nDBgdrsWxP
 4A8gH0kWbFFALHicD64Bjh5cj9DJDYbQTfBS+7TjnuRzGXK1nGNOZ+yAxyHK4I9xRNf61QbngtSWD
 17Q95f2POq7PEb2hEsl3JGvfVVm0TXvJj+Xr3D4RFXmEvapkEQcHijTTJyVo3ueEjHKw=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
 bh=YET10ng1nR0ea8GMjh+/irz/Zcx26qfqc4LRuHlkdsg=;
 b=GtrGYdGLszgBq1fvi5V2PSfoLOXh1TNyiK0ofvUFGiVvwdQ6PkaGy3Ns4qJwLgF4b3
 aIYdrsYMX+clX1Y+yOXcuDls8w+WiavI/64KPDiJmDgxyBZ4dAulShvhPc4ENInwd3Br
 cmukOGKll48ywyFlU3xTzvvA/EhYiy85fvbJiJhltWdFBrenWV2xIc1tgrmQTV6xVFrr
 kPWQoFcSoXWz75f58hl6lYhesgfwr3gasm4nlqUw3/vIqwimOmHoTKvTQsLxit2YTq1H
 EGgbgkZ8lcymg9dX7HeYXgo7ygr9E+FPEd+ZGk8VSDrPOWMvOyx7zdOCyAyIqsvEGW5B
 7Vuw==
In-Reply-To: <20220901220138.182896-1-vishal.moola@gmail.com>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-fsdevel@vger.kernel.org
Cc: linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mm@kvack.org, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org

Convert function to use folios. This is in preparation for the removal
of find_get_pages_range_tag(). Now also supports the use of large
folios.

Since tofind might be larger than the max number of folios in a
folio_batch (15), we loop through filling in wdata->pages pulling more
batches until we either reach tofind pages or run out of folios.

This function may not return all pages in the last found folio before
tofind pages are reached.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 fs/cifs/file.c | 33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index fa738adc031f..c4da53b57369 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2517,14 +2517,41 @@ wdata_alloc_and_fillpages(pgoff_t tofind, struct address_space *mapping,
 			  unsigned int *found_pages)
 {
 	struct cifs_writedata *wdata;
-
+	struct folio_batch fbatch;
+	unsigned int i, idx, p, nr;
 	wdata = cifs_writedata_alloc((unsigned int)tofind,
 				     cifs_writev_complete);
 	if (!wdata)
 		return NULL;
 
-	*found_pages = find_get_pages_range_tag(mapping, index, end,
-				PAGECACHE_TAG_DIRTY, tofind, wdata->pages);
+	folio_batch_init(&fbatch);
+	*found_pages = 0;
+
+again:
+	nr = filemap_get_folios_tag(mapping, index, end,
+				PAGECACHE_TAG_DIRTY, &fbatch);
+	if (!nr)
+		goto out; /* No dirty pages left in the range */
+
+	for (i = 0; i < nr; i++) {
+		struct folio *folio = fbatch.folios[i];
+
+		idx = 0;
+		p = folio_nr_pages(folio);
+add_more:
+		wdata->pages[*found_pages] = folio_page(folio, idx);
+		if (++*found_pages == tofind) {
+			folio_batch_release(&fbatch);
+			goto out;
+		}
+		if (++idx < p) {
+			folio_ref_inc(folio);
+			goto add_more;
+		}
+	}
+	folio_batch_release(&fbatch);
+	goto again;
+out:
 	return wdata;
 }
 
-- 
2.36.1
