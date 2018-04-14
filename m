From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v11 59/63] dax: Return fault code from
 dax_load_hole
Date: Sat, 14 Apr 2018 07:13:12 -0700
Message-ID: <20180414141316.7167-60-willy@infradead.org>
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
 bh=LykSuSt/CWwf+4GGWhfeqmkyUr1W81F3zXE08T8PYcY=; b=i3/ghvsSsbQMYpxVl5xCYUOh+G
 VuHh+4O0/t9TUJbRC76B61QxDmWhtl6fh5fJPga2a8sFFxgyD1Fr3ZAaqLWkV30PAOHjpSH64vBzf
 GMENoIBnKugLE4/S79HGc8oumHTEluCquj8kbXRwUZlFEJQTXv8enHdvIcvxGst3yb6c=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=LykSuSt/CWwf+4GGWhfeqmkyUr1W81F3zXE08T8PYcY=; b=XxT5ZA06pnVka8sV5jSRVewjsn
 RdlIm3YaC8R2M8J7bzdx2TA0PzrWv+5zG/qvJqFNI4hHF02Hj+cdDC2vYq+JF5xuJ6ZyRTe7KFdBQ
 2daWMPMgbKJmuprgvbBzO/Ia24OK7h0oHKp1MtN+nlHrPw8dcLxH/lhKkuwm4eKciKek=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=LykSuSt/CWwf+4GGWhfeqmkyUr1W81F3zXE08T8PYcY=; b=JIijM2jS1UMscg2SwUKznN7vB
 ehogHbWAezdxA6HnMpBR4BKw7LxH4FAlmce2jTu59iCLTNe+zNvkk2QIxStzkxho+2ta8TAC30avX
 K+bYZ+Z+N36n+yfI4AtNTdu83z35t1gGpfNQgGdiIqOLITQ2k8+lEqkByWhBsNjUDxbzEOaUSruNb
 +QH7RE0HFuC4AdtsQ9bVX6L2FUbQN1XOHv4SWHBUkhdZUzVHNnv4l1LEQEy1YOnD92RnGE52gI4gF
 jCHJGxWJjWGE55lhaFMN80Qti2z/uC4SoDqBHsbFelyxVuc/kiGwdUyf+I8C+e7zLcReakJS15olV
 qeYVmQWhQ==;
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

dax_load_hole was swallowing the errors from vm_insert_mixed().
Use vmf_insert_mixed() instead to get a vm_fault_t, and convert
dax_load_hole() to the vm_fault_t convention.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/dax.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index bcc3fd05ab03..44785346c02f 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -808,18 +808,19 @@ static int dax_iomap_pfn(struct iomap *iomap, loff_t pos, size_t size,
  * If this page is ever written to we will re-fault and change the mapping to
  * point to real DAX storage instead.
  */
-static int dax_load_hole(struct xa_state *xas, struct address_space *mapping,
-		void **entry, struct vm_fault *vmf)
+static vm_fault_t dax_load_hole(struct xa_state *xas,
+		struct address_space *mapping, void **entry,
+		struct vm_fault *vmf)
 {
 	struct inode *inode = mapping->host;
 	unsigned long vaddr = vmf->address;
-	int ret = VM_FAULT_NOPAGE;
+	vm_fault_t ret;
 	pfn_t pfn = pfn_to_pfn_t(my_zero_pfn(vaddr));
 
 	*entry = dax_insert_entry(xas, mapping, *entry, pfn, DAX_ZERO_PAGE,
 			false);
 
-	vm_insert_mixed(vmf->vma, vaddr, pfn);
+	ret = vmf_insert_mixed(vmf->vma, vaddr, pfn);
 	trace_dax_load_hole(inode, vmf, ret);
 	return ret;
 }
-- 
2.17.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
