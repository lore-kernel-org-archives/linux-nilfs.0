From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v10 53/62] dax: dax_insert_mapping_entry always
 succeeds
Date: Thu, 29 Mar 2018 20:42:36 -0700
Message-ID: <20180330034245.10462-54-willy@infradead.org>
References: <20180330034245.10462-1-willy@infradead.org>
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
 bh=2RxoRv1Fhn0WQ8po9Y9ZZ/QqeY3lj+T+WBBCzPUIJDI=; b=IWTWcH227fGAlZhxY46FEScDBs
 6amYoc0ld3fYsuEafW6+BEByS/e5CaLfuIYgh5fbIPCnIh78iL9uKizIxTnDanTB007zfuMQ/75Rl
 QK9LeHQe8wVBvW9e4TAt5Y6cBSKmpB+lxlW9U/79WfwcG3KacR93sKJi3ogibx/3oh3Q=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=2RxoRv1Fhn0WQ8po9Y9ZZ/QqeY3lj+T+WBBCzPUIJDI=; b=m+LYAZP9ryOKjXHMHDYP+wCJ9T
 5NFem1pEMCO6WnuQziyQ9A9sHWu9+6gYOfe9w0x7AJ7M7DYv5WjFSKbVBBnoCWUsJiCJKp+GP6kLK
 J/lTVk671Zv3xiRalK5sovdpqZNrIn5l9A2O0ssSQ+M6SxPqlvRqcXokZGERNRh3Ep1U=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=2RxoRv1Fhn0WQ8po9Y9ZZ/QqeY3lj+T+WBBCzPUIJDI=; b=Tn9l2i3f5Y1tUGy6dKeC5ye93
 RI1Xlc05hhfpMBQDFkt9J3AtJQtArupXh9JMJCNpHnXZq0WMDSriYdEzLwCDUOTPabxgHQmCAAzq+
 2QIUI2Jcdyf+DuGRz8EDG3XSW1wdebSpmBZuOfOyHj+I4cmLXBnnoOE5rxOq2i7ZKXUnX/gzf4r2d
 OGI14iL/CTlCaVloTKhMabNWeGzGFQ6iZAWtRp/uU8DLHJ2VNmPLr6JwlWDcfO4ayAmbZlJ6AY0jp
 /siX1FAFyXh19QXm0GOzjdDbdifTDOPHCU35P2+GyoRJU+/FC4qymGSM6wn9omH9uCtj9SlQWgNqz
 CMZOmyj8Q==;
In-Reply-To: <20180330034245.10462-1-willy@infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, James Simmons <jsimmons@infradead.org>, Jaegeuk Kim <jaegeuk@kernel.org>, Andreas Dilger <andreas.dilger@intel.com>, Nicholas Piggin <npiggin@gmail.com>, linux-f2fs-devel@lists.sourceforge.net, Oleg Drokin <oleg.drokin@intel.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Mike Kravetz <mike.kravetz@oracle.com>

From: Matthew Wilcox <mawilcox@microsoft.com>

It does not return an error, so we don't need to check the return value
for IS_ERR().

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/dax.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 371d50a1c14e..3bd9f624c1f8 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -994,18 +994,12 @@ static int dax_load_hole(struct address_space *mapping, void *entry,
 	struct inode *inode = mapping->host;
 	unsigned long vaddr = vmf->address;
 	int ret = VM_FAULT_NOPAGE;
-	void *entry2;
 	pfn_t pfn = pfn_to_pfn_t(my_zero_pfn(vaddr));
 
-	entry2 = dax_insert_mapping_entry(mapping, vmf, entry, pfn,
+	dax_insert_mapping_entry(mapping, vmf, entry, pfn,
 			DAX_ZERO_PAGE, false);
-	if (IS_ERR(entry2)) {
-		ret = VM_FAULT_SIGBUS;
-		goto out;
-	}
 
 	vm_insert_mixed(vmf->vma, vaddr, pfn);
-out:
 	trace_dax_load_hole(inode, vmf, ret);
 	return ret;
 }
@@ -1315,10 +1309,6 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 
 		entry = dax_insert_mapping_entry(mapping, vmf, entry, pfn,
 						 0, write && !sync);
-		if (IS_ERR(entry)) {
-			error = PTR_ERR(entry);
-			goto error_finish_iomap;
-		}
 
 		/*
 		 * If we are doing synchronous page fault and inode needs fsync,
@@ -1402,8 +1392,6 @@ static int dax_pmd_load_hole(struct vm_fault *vmf, struct iomap *iomap,
 	pfn = page_to_pfn_t(zero_page);
 	ret = dax_insert_mapping_entry(mapping, vmf, entry, pfn,
 			DAX_PMD | DAX_ZERO_PAGE, false);
-	if (IS_ERR(ret))
-		goto fallback;
 
 	ptl = pmd_lock(vmf->vma->vm_mm, vmf->pmd);
 	if (!pmd_none(*(vmf->pmd))) {
@@ -1525,8 +1513,6 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 
 		entry = dax_insert_mapping_entry(mapping, vmf, entry, pfn,
 						DAX_PMD, write && !sync);
-		if (IS_ERR(entry))
-			goto finish_iomap;
 
 		/*
 		 * If we are doing synchronous page fault and inode needs fsync,
-- 
2.16.2


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
