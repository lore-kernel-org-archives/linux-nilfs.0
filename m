From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v3 01/23] pagemap: Add filemap_grab_folio()
Date: Mon, 17 Oct 2022 13:24:29 -0700
Message-ID: <20221017202451.4951-2-vishal.moola@gmail.com>
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
 bh=GbkaK1BhnmuuyeEPYHO1j/C42qAqDKaBYuSZ7EsnhRU=; b=Gpviankgu2Pge7conePEoJWyTC
 0FUJeq1gb4qDuBFLroT/eKgahScJg0ieSUUXYADRf0U2J09p9ZWZCfrlryIorH7GWhYEDhf53I0Do
 r29cQ859tMRuCb2z5X6aX3s3NpD1+3LOhEZNEYzAK7F5ku7T9fV3GZQ3c0+Tr/kAA7SA=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=GbkaK1BhnmuuyeEPYHO1j/C42qAqDKaBYuSZ7EsnhRU=; b=au7Lg5yG12pPVjGXJ0YhGGUGIT
 1uw4dTGYiXAXyFpK5K2oAVVzBktPHjKj5EUkS2oNR7gmNNv1szabp4PzlVsMthz9BqTlH1Y7XOypu
 WwTV3rLD6pLhY55kzG0cm78WJNN9H7J0ZqOdtrwbNbQYTDgY3TRsH9T5X3P/nbXOsVXg=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=GbkaK1BhnmuuyeEPYHO1j/C42qAqDKaBYuSZ7EsnhRU=;
 b=NQ3KvRSSCU8wPaTgediDqeAMel/vIah0+7k422IToZaKZI3bGfU37b14iH42kEU0X7
 Qzi6EP9hjDaf1fqg1ZQFK32c9ILuCZG+zRyKOIFQp5ZQMoB2jLD4q1Gyr0WQ8mtE2qRq
 m8TScIwF6nHJLl980ya+Sr2hxZTVlJg4LpKy1hFXQBj8kaEyxSareN0Oky9YZM7BiaNw
 2vWb6xBDZgHXAKHRWn3JDalz3e7jNZ/tPokjvwD0EzjqbULHQtABSVFlz/pa4stgqdUZ
 akBnIoIm5M5fDRlS5Fp6GmmllvS/DMn6w9C+Jv33XGjD/jl12SrDdjixrx8PhoYvdeEc
 +A9g==
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

Add function filemap_grab_folio() to grab a folio from the page cache.
This function is meant to serve as a folio replacement for
grab_cache_page, and is used to facilitate the removal of
find_get_pages_range_tag().

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 include/linux/pagemap.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index bbccb4044222..74d87e37a142 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -547,6 +547,26 @@ static inline struct folio *filemap_lock_folio(struct address_space *mapping,
 	return __filemap_get_folio(mapping, index, FGP_LOCK, 0);
 }
 
+/**
+ * filemap_grab_folio - grab a folio from the page cache
+ * @mapping: The address space to search
+ * @index: The page index
+ *
+ * Looks up the page cache entry at @mapping & @index. If no folio is found,
+ * a new folio is created. The folio is locked, marked as accessed, and
+ * returned.
+ *
+ * Return: A found or created folio. NULL if no folio is found and failed to
+ * create a folio.
+ */
+static inline struct folio *filemap_grab_folio(struct address_space *mapping,
+					pgoff_t index)
+{
+	return __filemap_get_folio(mapping, index,
+			FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
+			mapping_gfp_mask(mapping));
+}
+
 /**
  * find_get_page - find and get a page reference
  * @mapping: the address_space to search
-- 
2.36.1
