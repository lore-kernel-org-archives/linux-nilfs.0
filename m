From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH v4 62/73] dax: Convert dax_insert_pfn_mkwrite to XArray
Date: Tue,  5 Dec 2017 16:41:48 -0800
Message-ID: <20171206004159.3755-63-willy@infradead.org>
References: <20171206004159.3755-1-willy@infradead.org>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=VVIA//ksXQaHzDI5ITDwOsaHgpjYVptbGQNHsgd5c6k=; b=fJl6WN6IT3H00K/gV7RHTCZIz
        rbs3ncxP/EFGBo2ube6RNu3E1zf57xv7ZJHretzHicLNPsFftlsH0YcSEd7nZJ+nVSpdyc3SZbIuK
        J/5kTgPovSCsrojZjiqGqyjofCIqw2E95g8tg8jRFN+OIvGFx7Rnf//tb8Gv5i79uZgJltkKtJ6QY
        T398mrG+v1CB5MSer5UhfEkkIoVcSPq0phCuOeywpjdvkK82o9mXxIP7aE/9NDM0LRs45PM7PHsPT
        YRpboqyvaiecROwOCN2SoxIAQAW6uzJK52j5e8HSMgPvD7PFOljkLAiANhg2WHL2T4QwGkZQXKTvp
    
In-Reply-To: <20171206004159.3755-1-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 
Cc: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Rehas Sachdeva <aquannie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

Signed-off-by: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/dax.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 7bd94f1b61d0..619aff70583f 100644
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
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
