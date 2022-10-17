From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v3 22/23] nilfs2: Convert
 nilfs_clear_dirty_pages() to use filemap_get_folios_tag()
Date: Mon, 17 Oct 2022 13:24:50 -0700
Message-ID: <20221017202451.4951-23-vishal.moola@gmail.com>
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
 bh=vEJiD15A68fC6SKwYs5XNRqfHJAp+vmoTIHZ0Wq7X1E=; b=dVnRxyAcMLaUy+636kugVoqCuw
 s+f1GePxsqyooCMnc1LVPtK8M2zgdVJxzEnWK10NaRl1+K9+lvHvLFqND+ypLIq3VS00pJ0zLyIvS
 I4CRzgG3Jo12OgBGgY37Kz1pqX7fAhETgiqM0bZLTNjB/02BEHtcD/Jc7JHKkPNfBLTo=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=vEJiD15A68fC6SKwYs5XNRqfHJAp+vmoTIHZ0Wq7X1E=; b=RnH1/phCNfGpcH0s9xF7OYkCNK
 QNMEta9QzsfVZU9M2AlyGoPBWCOXIukzmIAy4Kx4ekrIMzvXDOoHplpu1t9zdiQxkMJfr0XQgiFM0
 xQUMUFp7Y592q02KDgKlxC3gi9NZDiV58qXTfIzxxJUAHC2yEPv4qHQ2hKG4vu3liHt8=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=vEJiD15A68fC6SKwYs5XNRqfHJAp+vmoTIHZ0Wq7X1E=;
 b=HuFrfcPO7PV53ayIMggGbnfzpHoeRQFhEFVQOHPc6PzciA7uBE16kgNsOTzTc1N9dJ
 2hSJwfj31GhqB57Dr9/JR3txjsKxYKd0DISzk5VV/d3E3Vvva9/OdBLRndwoGjHrDXuK
 3qY8DRPEAXcVMt/sdZ/bgfMCfvzda7cDqa8pI+Md0v4rCay9b1P1aDFJ+wuv/xkwhjDh
 0KtsJUtybAp1KLL3S4A3UmyZmXQ8CTdDX6Bkp+k+AXUIgWAtr3eIZaG4Vz97JDWv8G7t
 DfxB/Jkfg4jPAEaUIknmd3fhww6CnCHqRF/goZ5vhsIyCSXiY5Ug+9SlNiOQCIqmtJWg
 3FVg==
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
Cc: linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mm@kvack.org, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org

Convert function to use folios throughout. This is in preparation for
the removal of find_get_pages_range_tag().

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/page.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index d921542a9593..41ccd43cd979 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -358,22 +358,22 @@ void nilfs_copy_back_pages(struct address_space *dmap,
  */
 void nilfs_clear_dirty_pages(struct address_space *mapping, bool silent)
 {
-	struct pagevec pvec;
+	struct folio_batch fbatch;
 	unsigned int i;
 	pgoff_t index = 0;
 
-	pagevec_init(&pvec);
+	folio_batch_init(&fbatch);
 
-	while (pagevec_lookup_tag(&pvec, mapping, &index,
-					PAGECACHE_TAG_DIRTY)) {
-		for (i = 0; i < pagevec_count(&pvec); i++) {
-			struct page *page = pvec.pages[i];
+	while (filemap_get_folios_tag(mapping, &index, (pgoff_t)-1,
+				PAGECACHE_TAG_DIRTY, &fbatch)) {
+		for (i = 0; i < folio_batch_count(&fbatch); i++) {
+			struct folio *folio = fbatch.folios[i];
 
-			lock_page(page);
-			nilfs_clear_dirty_page(page, silent);
-			unlock_page(page);
+			folio_lock(folio);
+			nilfs_clear_dirty_page(&folio->page, silent);
+			folio_unlock(folio);
 		}
-		pagevec_release(&pvec);
+		folio_batch_release(&fbatch);
 		cond_resched();
 	}
 }
-- 
2.36.1
