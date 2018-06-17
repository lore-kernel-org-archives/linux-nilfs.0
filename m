From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v14 03/74] dax: Fix use of zero page
Date: Sat, 16 Jun 2018 18:59:41 -0700
Message-ID: <20180617020052.4759-4-willy@infradead.org>
References: <20180617020052.4759-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=yNFVHUulQCNDiyqX2nmhpxJWZEpVPHmMj67swxyAnJQ=; b=p1mzyKvwWeQapKax5CKf3LvCP
        4eroi3VUBIYJzvh/2C7YcZhZS3IGQOZ535q+XmMw2paYiFmrUjrHUZ66FKXsM5V0bF2jtaaI5dTal
        UhAqB86xX+PMvfMkrNROSJM61+f9QkUxJih6mgEK3Du5gTU91WQI8K1/22voLwtWMrF6OlqKTsk8Q
        N4ClQFEKoWBR8PL4CCm+TVLzVDAoCjmwcsczHrvkdxImX+gKXYufVh3YbWplnS7Hiqolh9U1Qsq+n
        xaTY2LKVKQiyzm2tdfZs5z/P/epnVihk3OF9zl1x3AxD2p9TuhgKQSs12vb1/jivP8HYnIaiq/zGg
    
In-Reply-To: <20180617020052.4759-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Nicholas Piggin <npiggin@gmail.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>, linux-f2fs-devel@lists.sourceforge.net

Use my_zero_pfn instead of ZERO_PAGE, and pass the vaddr to it so it
works on MIPS and s390.

Signed-off-by: Matthew Wilcox <willy@infradead.org>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/dax.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 467601a134bc..c7917b46a75b 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1093,21 +1093,12 @@ static vm_fault_t dax_load_hole(struct address_space *mapping, void *entry,
 {
 	struct inode *inode = mapping->host;
 	unsigned long vaddr = vmf->address;
-	vm_fault_t ret = VM_FAULT_NOPAGE;
-	struct page *zero_page;
-	pfn_t pfn;
-
-	zero_page = ZERO_PAGE(0);
-	if (unlikely(!zero_page)) {
-		ret = VM_FAULT_OOM;
-		goto out;
-	}
+	pfn_t pfn = pfn_to_pfn_t(my_zero_pfn(vaddr));
+	vm_fault_t ret;
 
-	pfn = page_to_pfn_t(zero_page);
 	dax_insert_mapping_entry(mapping, vmf, entry, pfn, RADIX_DAX_ZERO_PAGE,
 			false);
 	ret = vmf_insert_mixed(vmf->vma, vaddr, pfn);
-out:
 	trace_dax_load_hole(inode, vmf, ret);
 	return ret;
 }
-- 
2.17.1

