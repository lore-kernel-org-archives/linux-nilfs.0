From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v5 63/78] dax: Convert dax_insert_pfn_mkwrite to
 XArray
Date: Fri, 15 Dec 2017 14:04:35 -0800
Message-ID: <20171215220450.7899-64-willy@infradead.org>
References: <20171215220450.7899-1-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:
 To:From:Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=PY9fMkZ30w/J7QLqcoNp+sl7TgC2W4QfPSzGutHlCgM=; b=LGMUSHgxNDV6v0Nppw4oOlmW9y
 TY8ycBQuQwuYbDise8i2CTHgK0GEcG9sfyd88U3hYz6p0dsoh0KnjNNRZVrnp6kuPFyPdmWNBaOl9
 pTVTYitZYjZ5pQGmzXsLNJ+yDBIvt+xJB9qcvBYL7s1QDX/jRO99Un/n0+QRzd3jYQj4=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=PY9fMkZ30w/J7QLqcoNp+sl7TgC2W4QfPSzGutHlCgM=; b=eknQVK+BwwTXT/KYbgMKu4pF1Y
 xH526tmqTR9LauTaxSzK1Xv+ipklQE3XqL7G8nElCN3c5m1Ae1HEIm1sup+5eMfAoCI1zH+XrHgPx
 WjyOiFXlJJUOp+ntUpCxL3nSrjx0mMuW3Ev1n5Ap6ypOSzj+tA+/WE5x+j/QR2MyPLVs=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=PY9fMkZ30w/J7QLqcoNp+sl7TgC2W4QfPSzGutHlCgM=; b=N9DGDqi/ctkdMBkjbhz64a2tB
 JfCbYsHjLTw89lLQlDtHejIpoD38tav67w5KWu5TTbjLGU6IJnfh/+jBKrKr6NVuGwlNaU8XRMgpM
 roDCf6tBZWHf5Rf0A2vrxGw5ISQDyXeUK2wj9T89CENu6DT2rzRCi3GSoWzzERI2TXLzNDsb0VrFB
 Db3Mm+/99YPuUfgRWAXusS1wxYNI0esPBqluqySrTLBdvhnZycA2WwnioiBUAfKteEZb7ybeRx6Ft
 9gyMHlSqndFR1YJGZtno/clKetyRFUHchs9Yofb/maeNF6xZRq2eaigUQvy9VWBNRDOfJu8VPxE0E
 PR34vlvhw==;
In-Reply-To: <20171215220450.7899-1-willy@infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, linux-xfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-raid@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-usb@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, David Howells <dhowells@redhat.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Rehas Sachdeva <aquannie@gmail.com>, Shaohua Li <shli@kernel.org>, linux-btrfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/dax.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index d6dd779e1b46..9cfd4fcc0b0d 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1498,21 +1498,21 @@ static int dax_insert_pfn_mkwrite(struct vm_fault *vmf,
 	void *entry;
 	int vmf_ret, error;
 
-	xa_lock_irq(&mapping->pages);
+	xas_lock_irq(&xas);
 	entry = get_unlocked_mapping_entry(&xas);
 	/* Did we race with someone splitting entry or so? */
 	if (!entry ||
 	    (pe_size == PE_SIZE_PTE && !dax_is_pte_entry(entry)) ||
 	    (pe_size == PE_SIZE_PMD && !dax_is_pmd_entry(entry))) {
 		put_unlocked_mapping_entry(&xas, entry);
-		xa_unlock_irq(&mapping->pages);
+		xas_unlock_irq(&xas);
 		trace_dax_insert_pfn_mkwrite_no_entry(mapping->host, vmf,
 						      VM_FAULT_NOPAGE);
 		return VM_FAULT_NOPAGE;
 	}
-	radix_tree_tag_set(&mapping->pages, index, PAGECACHE_TAG_DIRTY);
+	xas_set_tag(&xas, PAGECACHE_TAG_DIRTY);
 	entry = lock_slot(&xas);
-	xa_unlock_irq(&mapping->pages);
+	xas_unlock_irq(&xas);
 	switch (pe_size) {
 	case PE_SIZE_PTE:
 		error = vm_insert_mixed_mkwrite(vmf->vma, vmf->address, pfn);
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
