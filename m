From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v3 03/23] filemap: Convert
 __filemap_fdatawait_range() to use filemap_get_folios_tag()
Date: Mon, 17 Oct 2022 13:24:31 -0700
Message-ID: <20221017202451.4951-4-vishal.moola@gmail.com>
References: <20221017202451.4951-1-vishal.moola@gmail.com>
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
 bh=QZRdB+dZmNtA32T+cQHDMYonPyYz7jjivtFD0eVIJJw=; b=hn0RBoQ2LUa6kLIq+u89vVlQGA
 t12bgqGSDQu0t/9AMX8xlzipp+8mTo5h7mziJ8vs92f9iFYpFUOSaBGjOYgzxzq79gjuN/v/YRNQO
 Xn9COw73wR6lgUbZwmrkohdNXasZzFgFouaJy9yt85u8fSViDBCCzDQliwsjZdnYRUSc=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=QZRdB+dZmNtA32T+cQHDMYonPyYz7jjivtFD0eVIJJw=; b=SWtdZi/W62Frs2I+VDjT2hol6S
 a0p+KU/uro1Sj4KcYdt8Yt0gYdSLtjn/0j/zm/HgX8/brwVPi2UbNmiZSZ/sJ926kixb85DgqTash
 b8ziEAdwqBd5KV069BJV7rXhyiqhHhmQ7Kb/+ZnlkuvtRnMAVGPAS0UsBfSO2NbEvEnU=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=QZRdB+dZmNtA32T+cQHDMYonPyYz7jjivtFD0eVIJJw=;
 b=EMG8zUe6nj+OzUpxpcc6vz9egeLlNxWJFwjbuAX7cIf8UVozlJc16RJgVW6MmHr8wj
 lAYPDYX2mCzW8yaHilBBcng/MkEd3zQadtzIm4aJed/L2hmaKukav+bbHe5lJaIq8Cmg
 0jCDF+tjRM5z3mhRWX4Pz9YQeJePTcm5XXkFfwT7bZ3hhjUxBBExa8JfvRa7z2z1eEE8
 aa1Z+xdo2jBQyaNl3srNu1X1eXAZfvMUHpUQQgygrIgkLcMnTlgBOGGoIPFtqd0FKlwi
 hsEHCzW24ByTmgfjer1ioe0J81eAgCS681a1EYbjZkADJzINZruwqE0d8CSsY1eGT4Gg
 1ZFQ==
In-Reply-To: <20221017202451.4951-1-vishal.moola@gmail.com>
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

Converted function to use folios. This is in preparation for the removal
of find_get_pages_range_tag().

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 mm/filemap.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index aa6e90ab0551..d78d62a7e44a 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -503,28 +503,30 @@ static void __filemap_fdatawait_range(struct address_space *mapping,
 {
 	pgoff_t index = start_byte >> PAGE_SHIFT;
 	pgoff_t end = end_byte >> PAGE_SHIFT;
-	struct pagevec pvec;
-	int nr_pages;
+	struct folio_batch fbatch;
+	unsigned nr_folios;
 
 	if (end_byte < start_byte)
 		return;
 
-	pagevec_init(&pvec);
+	folio_batch_init(&fbatch);
+
 	while (index <= end) {
 		unsigned i;
 
-		nr_pages = pagevec_lookup_range_tag(&pvec, mapping, &index,
-				end, PAGECACHE_TAG_WRITEBACK);
-		if (!nr_pages)
+		nr_folios = filemap_get_folios_tag(mapping, &index, end,
+				PAGECACHE_TAG_WRITEBACK, &fbatch);
+
+		if (!nr_folios)
 			break;
 
-		for (i = 0; i < nr_pages; i++) {
-			struct page *page = pvec.pages[i];
+		for (i = 0; i < nr_folios; i++) {
+			struct folio *folio = fbatch.folios[i];
 
-			wait_on_page_writeback(page);
-			ClearPageError(page);
+			folio_wait_writeback(folio);
+			folio_clear_error(folio);
 		}
-		pagevec_release(&pvec);
+		folio_batch_release(&fbatch);
 		cond_resched();
 	}
 }
-- 
2.36.1
