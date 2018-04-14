From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v11 52/63] dax: dax_insert_mapping_entry always
 succeeds
Date: Sat, 14 Apr 2018 07:13:05 -0700
Message-ID: <20180414141316.7167-53-willy@infradead.org>
References: <20180414141316.7167-1-willy@infradead.org>
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
 bh=gD3e4IXF+CbNHUlFmvkrg0YaE8l/vd5NzMmLl0Pt7j8=; b=PsZP/wNbfA/sDqX/ZIjACkoEYn
 nn/iFA+sSydQcEaLtomRYpikgnNV5bA07sF7VCzQtPQZf+NN+10NvMW6U6Jjg1x6GKzKX1bzoPrQW
 Akbilgi9/TWpp2IsE2nEsB879YUSx2T2cgISxCDldMr74jWXYw559Z2EL1xTbOq4NBtk=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=gD3e4IXF+CbNHUlFmvkrg0YaE8l/vd5NzMmLl0Pt7j8=; b=DJL8vbV8I6iKxrLSOsJ+m/u7Xl
 vh4ijU8EQ/DUonpY/6U+c/dbWsoAF/NinDIHwOALiMFFW0DVjLcaGsYyR52qF9NdPIDF5+P0EzDJS
 AJmlwtnTV8/THuN08GDPYl+sn5K6zj/pPoLpqN77sErVYOiVFku6hPO0qULLCj9Db15w=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=gD3e4IXF+CbNHUlFmvkrg0YaE8l/vd5NzMmLl0Pt7j8=; b=FATEBd5lRoZseslOac0BIa1lj
 uMhnVprWIodhq7jeeR1B7tmpTConahXRE+ksFqSCIAD1qjX8NmN+ugdgUwXEa/iVEaneAbg5G3W4Z
 XInL9B5mvza04cBoiz6AfHPXs8h6EHUwUPdMQVqvVw7tq8DI4AT7iTsiue7ls0ckBGvHDHUTeRNeJ
 yww6+K7c9bGaJDMJqqMBnK8lnUqXhbCb7XNm8rfesVJNmMM4gztf95BgaFRb67wL2V7M8jRBpaYY2
 qJmLuY+x3RO7u03wIFna5VtA0C8tU5QZzPu7UVH2YFyZyuGG0Yla6+p+ZBQE0BnFXFJnd/K8jOE6A
 STXzM9LAA==;
In-Reply-To: <20180414141316.7167-1-willy@infradead.org>
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
index b0efb0a9604a..c6086e7566c3 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -909,18 +909,12 @@ static int dax_load_hole(struct address_space *mapping, void *entry,
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
@@ -1230,10 +1224,6 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 
 		entry = dax_insert_mapping_entry(mapping, vmf, entry, pfn,
 						 0, write && !sync);
-		if (IS_ERR(entry)) {
-			error = PTR_ERR(entry);
-			goto error_finish_iomap;
-		}
 
 		/*
 		 * If we are doing synchronous page fault and inode needs fsync,
@@ -1317,8 +1307,6 @@ static int dax_pmd_load_hole(struct vm_fault *vmf, struct iomap *iomap,
 	pfn = page_to_pfn_t(zero_page);
 	ret = dax_insert_mapping_entry(mapping, vmf, entry, pfn,
 			DAX_PMD | DAX_ZERO_PAGE, false);
-	if (IS_ERR(ret))
-		goto fallback;
 
 	ptl = pmd_lock(vmf->vma->vm_mm, vmf->pmd);
 	if (!pmd_none(*(vmf->pmd))) {
@@ -1440,8 +1428,6 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 
 		entry = dax_insert_mapping_entry(mapping, vmf, entry, pfn,
 						DAX_PMD, write && !sync);
-		if (IS_ERR(entry))
-			goto finish_iomap;
 
 		/*
 		 * If we are doing synchronous page fault and inode needs fsync,
-- 
2.17.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
