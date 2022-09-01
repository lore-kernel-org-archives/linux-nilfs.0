From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH 22/23] nilfs2: Convert nilfs_clear_dirty_pages()
 to use filemap_get_folios_tag()
Date: Thu,  1 Sep 2022 15:01:37 -0700
Message-ID: <20220901220138.182896-23-vishal.moola@gmail.com>
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
 bh=6jEJW/hdf8NlYILH28nH262i/WrC/eObbm9U3wHW7N0=; b=UUbdfF3F5vKhAQdNFfupWuw6b6
 /gmGfu/DHZC92+Z4x/F38QdcdfrQppK9JTyyYnvr2Olpw4xm7Tb5u27L0ReNglsrFHx8C9rXrf6qD
 dQDZJf7c5xaVZr5Oab9YnS1NaBg3P4Cyu/W6OPU65CEPJaKwSWxtBT7ojWl29nd3RGGk=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=6jEJW/hdf8NlYILH28nH262i/WrC/eObbm9U3wHW7N0=; b=Wy7nkqQj0wa0qFVGCcgHeT8El7
 mQOZhZsdsBAatfF1txIGp40TG58etzVbmgxmSHX3DQh/QDLQwYqH8OfkmgZF++LC2GvoVELddPcEu
 nIlBYhi27MlW7xW1lP0WNcknPufwi+70eHjRLiwvFzdRn2I01zdTrnx8XNNBPAt06ip0=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
 bh=6jEJW/hdf8NlYILH28nH262i/WrC/eObbm9U3wHW7N0=;
 b=N9gi0ek73D6+Ob4gJQTCenTIizkASUjD+NGWnY0SxFC164jHY2z+KDjngS5u8a5ea1
 pTnBRJWlclL9jxrutcaq59svND4AAi3Mu6zjZ5R0ZdTzg7WkwILrexZuQIgRHx4yncJe
 OCQ0GP35CE39948Jkx+DdsWr/hVemLW0aPd8pHpB8mjZW2hr0avHI7FZaniFXz2bEU5c
 8rj/3cGG0sHkP+Xg1vHbPyhxWGLC3ZGSwUXEq4Bo3qDVM63ON1NgwYw3KkUKbds8fRoP
 Z5oZrMmJFM7HBd6JNC8OlP+eYzpgfFP4AsKvNF+23CtWe3kx/Wqjrlwut0YprghhKCzN
 8ZkA==
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

Convert function to use folios throughout. This is in preparation for
the removal of find_get_pages_range_tag().

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 fs/nilfs2/page.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 5c96084e829f..b66f4e988016 100644
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
