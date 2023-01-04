From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v5 09/23] cifs: Convert
 wdata_alloc_and_fillpages() to use filemap_get_folios_tag()
Date: Wed,  4 Jan 2023 13:14:34 -0800
Message-ID: <20230104211448.4804-10-vishal.moola@gmail.com>
References: <20230104211448.4804-1-vishal.moola@gmail.com>
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
 bh=o5rMPwcVI+xSSROnSv680xsAXd0L9APPXdNmyKQVwfk=; b=FYFoWV6yti9lcA8NtjfdgSOP+b
 o3O3sR7EbwLoT68U5V3lwbsy51bpuo+VW9avowOutZWFnzh6zZs1M7XQGHUUxTMqpJ0RliTdVk0Dz
 0fLox8+cfs3EoIiTix3DoZ2WCgiuhOo04oKUNU5XPNT3Fa0aTuEsKMFF5dLJ34MQaeIw=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=o5rMPwcVI+xSSROnSv680xsAXd0L9APPXdNmyKQVwfk=; b=AScqcvuZ1AwkVMqR/xK3l4K/Ok
 nq5hxYuRgo0P9KCig7oRMjqowmTPPATm6eiYYXIJXkbB+8VHRZSFY1zDLXREAgMlvzzVkyqvizjjx
 R8UtraDToQ6xVyoHXE93VK/gmWVRKMU0dwOo+Z8JwpWnWVerk1FTmfY2KpRjpRG5JtmY=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=o5rMPwcVI+xSSROnSv680xsAXd0L9APPXdNmyKQVwfk=;
 b=V1E1lT+81O0Bma5i45Jhgrf33b8ZyAtb2k6sBn232f4UkEzENvpQBKf03VCx514eGY
 A6/X8hia12tEOrxhlqm2jbfpueF7iUxDQK73Qfx/HnU0C1qeC98Y/FJf4DdEA7/pzkhJ
 0R9L0J423oCq4U1iJLCVDadB2Wt5+nvV5hLoYRWJbhwd1xBn6WpVA0bJU8YE7e7wpuN2
 7595aSPavZoug9A+uF4GQmMXauKv9jF+a45BkfZqX76YcFFkYKhW2/vAA8fJsRJSuef8
 gAsMn3ncTXpb8uuk1BimZcT4C8iNt/aS5nfn00OIYDqHLLwCBHXgWFjBa8QQEThwOWQl
 z5zg==
In-Reply-To: <20230104211448.4804-1-vishal.moola@gmail.com>
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

This is in preparation for the removal of find_get_pages_range_tag(). Now also
supports the use of large folios.

Since tofind might be larger than the max number of folios in a
folio_batch (15), we loop through filling in wdata->pages pulling more
batches until we either reach tofind pages or run out of folios.

This function may not return all pages in the last found folio before
tofind pages are reached.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 fs/cifs/file.c | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 22dfc1f8b4f1..8cdd2f67af24 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2527,14 +2527,40 @@ wdata_alloc_and_fillpages(pgoff_t tofind, struct address_space *mapping,
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
+		folio_get(folio);
+		if (++*found_pages == tofind) {
+			folio_batch_release(&fbatch);
+			goto out;
+		}
+		if (++idx < p)
+			goto add_more;
+	}
+	folio_batch_release(&fbatch);
+	goto again;
+out:
 	return wdata;
 }
 
-- 
2.38.1
