From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v11 41/63] shmem: Convert
 shmem_partial_swap_usage to XArray
Date: Sat, 14 Apr 2018 07:12:54 -0700
Message-ID: <20180414141316.7167-42-willy@infradead.org>
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
 bh=FrdJTSGDGYtOBv5wMLBdDSGoaZDilxISk17xdYOfK/0=; b=NboAL04T56RU2FNL60mngE0bVv
 SkcGMDpmb1a32z8Of/4YmCN9OV4y1KAAYiqc19m8EH8pAs0A4AIQsjY4FRSCR9imPCzl4HRVmnyrD
 zUsx1uvG/Dx94EMkKKN3eGqgmQadIRZqR+TWg+OyUXwETbQR9oKk9UlQnz17IVRCPeP0=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=FrdJTSGDGYtOBv5wMLBdDSGoaZDilxISk17xdYOfK/0=; b=IVBjpPW0Ex2snnSWkS6mk5vCT5
 FHnnVATFAmDRjdUVIAzPUeLmUbK69ZuKLejXXHfOik/2qtzQBfjknXlsHf7d/PhD+NcoAuo0sjjUl
 TfIYeL+H/eYbPDZZzEtIy7f9JsJfOtLX8tejNcKp248hNBzn1+HxUlajUEWG4txzmzUI=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=FrdJTSGDGYtOBv5wMLBdDSGoaZDilxISk17xdYOfK/0=; b=djPZgFjlKvFPdprV+WGFsEFwZ
 H6yMx30AScf+uTz9imzhp1AIwuOTqAhTp7fCMwrPa71iAK2VaWCJEcHUTQ+cJ4dV8GxdQG9Gt8hv/
 hlx/5UMuzOhmPchrEsh2EWRM5j5jHtQEFksmN0DrkzU3iy0ExC9jjgPPIGD1lP/f5XNEdpH8TiPWT
 51MZpaFw8G6VIQ4Thj0F78Te7pmZENAG5ib0uYKWh+nQzwZY+RIjt+6RwKSpj+5NNoW4dqP9ZOga6
 8/IEH1fN/cR2mSADjgQrHV5Ch/Tnp07suwgxeErppHtCdTmZAlmwgNVGf9QRfLWh2Yg3AjRBchkRg
 ihJMD/3aw==;
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

Simpler code because the xarray takes care of things like the limit and
dereferencing the slot.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/shmem.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 0ead678725c4..e1a0d1c7513e 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -667,29 +667,19 @@ static int shmem_free_swap(struct address_space *mapping,
 unsigned long shmem_partial_swap_usage(struct address_space *mapping,
 						pgoff_t start, pgoff_t end)
 {
-	struct radix_tree_iter iter;
-	void **slot;
+	XA_STATE(xas, &mapping->i_pages, start);
 	struct page *page;
 	unsigned long swapped = 0;
 
 	rcu_read_lock();
-
-	radix_tree_for_each_slot(slot, &mapping->i_pages, &iter, start) {
-		if (iter.index >= end)
-			break;
-
-		page = radix_tree_deref_slot(slot);
-
-		if (radix_tree_deref_retry(page)) {
-			slot = radix_tree_iter_retry(&iter);
+	xas_for_each(&xas, page, end - 1) {
+		if (xas_retry(&xas, page))
 			continue;
-		}
-
 		if (xa_is_value(page))
 			swapped++;
 
 		if (need_resched()) {
-			slot = radix_tree_iter_resume(slot, &iter);
+			xas_pause(&xas);
 			cond_resched_rcu();
 		}
 	}
-- 
2.17.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
