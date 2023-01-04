From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v5 01/23] pagemap: Add filemap_grab_folio()
Date: Wed,  4 Jan 2023 13:14:26 -0800
Message-ID: <20230104211448.4804-2-vishal.moola@gmail.com>
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
 bh=Yo+m9KCho02Llmwjmz5bDSbKVzw32DqjrZ5KrSHhgyc=; b=IXgHWiFeSbC2X1bajUWKZFogMP
 6AGjk8MjQXDu8Dm10qeXDS17L9Gh+7mlaA2jgyQHpJuauIBoXaLwogFEkS2TC85BnfZET/VFjdKBZ
 8NN/0ti+6IJJAdl3QeGEvTFgEoV8oGIK9ywfSYRWEAzShDKGSAZnMrcat9PV5N/AvZmg=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=Yo+m9KCho02Llmwjmz5bDSbKVzw32DqjrZ5KrSHhgyc=; b=meCC3o1Lws8nQ0VNeYdsAQ2qRp
 YN9Q5QM2ipi6rREzx4rOBbrKCIZdIKFVd0+B2qk2naTuRhHBfLeoVoFh0ieMk5TyDtobF48Nr2Q9z
 ouzTRQwIt3ARO0t6r89tyQ+Rn23gFseASqhzhAgH2HPVUznhVCqtwR2YhqOX3MJtY3DI=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=Yo+m9KCho02Llmwjmz5bDSbKVzw32DqjrZ5KrSHhgyc=;
 b=bjZkMxIPNZ3wmKI3QGSepT81I5OzcwJOIb/dnupKeJzgemoOZcjM4yfreHA+pwVbeP
 HOd/bgUCet0z9B/XX2tfep3wWWWYLyeCIHFa1NDUjFWQdX5A572uwUJHv92lvCUSn0jH
 nDD1ayF0cF1sYXZY6D7okVUr906wpDImdUvSkzV/8th2CAYrKdz3orCKBweWTHnMlK4j
 8Q9LXTwaogmTrXs5Gj4PAGJAZD90/jRoTwO/o58iZ0J59ckgaPVRY99HTFyy5G/KNc7Q
 k+iq8jJPMbsMV3H/So6AzW1W8RbB4qBsSsxHHBAFfFQVhi108BAllJmmP6SyPMsZeGbG
 6mUA==
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
Cc: linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mm@kvack.org, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org

Add function filemap_grab_folio() to grab a folio from the page cache.
This function is meant to serve as a folio replacement for
grab_cache_page, and is used to facilitate the removal of
find_get_pages_range_tag().

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/pagemap.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 29e1f9e76eb6..468183be67be 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -546,6 +546,26 @@ static inline struct folio *filemap_lock_folio(struct address_space *mapping,
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
2.38.1
