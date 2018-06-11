From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v13 02/72] dax: Fix use of zero page
Date: Mon, 11 Jun 2018 07:05:29 -0700
Message-ID: <20180611140639.17215-3-willy@infradead.org>
References: <20180611140639.17215-1-willy@infradead.org>
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
 bh=zowXtexFJYg/ibOfn7aWp3ZjHxVfIK1o3juT8iBdx8U=; b=aG7beJyDAkONzrrGcVlKWhGxiI
 +RrRpxlXouPe4Tv4kIkWOk7QIaSkwCzYQ2+Toi/AG9MeiPvpq34DzPenxd+iFoK8iEAiGIZrHo6bo
 TTP/KizdILa3fDPfht/wQkRl6mHwdNLELWIPWW9wAD1bluJAfUN05fbgbL9ukGJ12+SA=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=zowXtexFJYg/ibOfn7aWp3ZjHxVfIK1o3juT8iBdx8U=; b=GZWIAcC/n8au8Ir3/VCwsMDSgc
 asisOEb6djsUOgImFKWo7TUSLl37CKs6SUMtp4ftL37YOdXmrgtRRnTwnZgD3csCByGOCL3tSh7Ho
 rz5fmIF7+G7bSjRDuMvQ0Z1MrBrvYRlayMNMLxCsBrR81KoR1vbUqtyeeW4mojZKGFRw=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=zowXtexFJYg/ibOfn7aWp3ZjHxVfIK1o3juT8iBdx8U=; b=o60f3YJPM3L7yOUO6/Ib1B3db
 iANa5JGRqWuecuZlBRToIJqZQsHf58sm7j4OurE8YChRJMFXP5yXaUNo4kFXYz0m3pFvbJ6fq6jKK
 A/Hooqdo2Xjm20b0rjp5xm8KMsgXNRMTTjaqAqBdL7+9DdSemyOPYu1fD6pMGeZDxAD5jhtpGAUOa
 MTohMpOxRCxnYLe9+EcYRCyg453q/K+iBny8yV0WGc5EG6/giF1KmmtZf1kCy8ATB6c4+22rwppNo
 tGXQL8VaWaLHXKxhZpHByLqRQJZ8f1zCnRi79QsbEBgz6q0d/S7CtzAdZkyFuuj7hG7f/Gq8XdyQQ
 my0pkMikQ==;
In-Reply-To: <20180611140639.17215-1-willy@infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, linux-f2fs-devel@lists.sourceforge.net, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>

From: Matthew Wilcox <mawilcox@microsoft.com>

Use my_zero_pfn instead of ZERO_PAGE, and pass the vaddr to it so it
works on MIPS and s390.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/dax.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 4de11ed463ce..5e7b010738be 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1017,21 +1017,12 @@ static vm_fault_t dax_load_hole(struct address_space *mapping, void *entry,
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


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
