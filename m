From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v11 39/63] shmem: Convert shmem_alloc_hugepage to
 XArray
Date: Sat, 14 Apr 2018 07:12:52 -0700
Message-ID: <20180414141316.7167-40-willy@infradead.org>
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
 bh=Zs5aTwmvm2PODrufCBHHeizYU+0FPGF7eS2t8j2yoAA=; b=FbSj12T/I/I4PGqthL22Op2kqO
 5AfJSzgSbWA2td3+IJm72JGjnmcXfsOJtB2v6IxMi2O+Sfj4pPoMTBY93YV5QeAOzaf0DsWOWRXfr
 dWo5paspn8yvyhFEJs/cD1xKUINvqPg2/lTMeqT4BOJZiP5lVYmckInhi8sD1Hs/Gn4s=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=Zs5aTwmvm2PODrufCBHHeizYU+0FPGF7eS2t8j2yoAA=; b=hsXz3AJ9Q8N1tFh9SVcTL57Wi1
 i2DGDj/etGt+pnbucInwF5/jIuVL8PWUs3wx6GZQpRmY6DevfY+/jJrRRLduaoTL/ARzJihDmmvCG
 qcUbMmy2Wa7a/g4PBxS77s/rvbdzsKZjJEzf6SKqT4M0Z1jw0ETbqusNvGU3VBu6s5ho=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=Zs5aTwmvm2PODrufCBHHeizYU+0FPGF7eS2t8j2yoAA=; b=pm9C8JoANIubDn1W0uuF4p5vH
 7esHMIDDCH2MKhGV2oH8eiUXgKz4RJIZ8tPkkk29D2P7g6LzeT54XgU7IMlo76RWGCt/sInCBRCCG
 bvj+1wUjhbq1EvbAfbPK3kPx3sXMYQ5ypVwiEZ3sYISq9qOicZDNiPjrm3cdXa49cewatJvVODN+/
 XqcPtg3gl2yuAwunRXosWRULoJgmrvNUqLV6hJhNt82Ko3tP9b24YL8ixDsh8V543vrp3b3iukhFD
 cTDFdKaiiW5p6ogoX6XgOsYRVQwBPn7PnwEFiFNGPTcnPdMTuy7unz4RZOM+DC+de4P0B16LFilEf
 zeF7DX0Qg==;
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

xa_find() is a slightly easier API to use than
radix_tree_gang_lookup_slot() because it contains its own RCU locking.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/shmem.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 8d24d59b0e67..985c5cdec7f7 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1425,23 +1425,17 @@ static struct page *shmem_alloc_hugepage(gfp_t gfp,
 		struct shmem_inode_info *info, pgoff_t index)
 {
 	struct vm_area_struct pvma;
-	struct inode *inode = &info->vfs_inode;
-	struct address_space *mapping = inode->i_mapping;
-	pgoff_t idx, hindex;
-	void __rcu **results;
+	struct address_space *mapping = info->vfs_inode.i_mapping;
+	pgoff_t hindex;
 	struct page *page;
 
 	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGE_PAGECACHE))
 		return NULL;
 
 	hindex = round_down(index, HPAGE_PMD_NR);
-	rcu_read_lock();
-	if (radix_tree_gang_lookup_slot(&mapping->i_pages, &results, &idx,
-				hindex, 1) && idx < hindex + HPAGE_PMD_NR) {
-		rcu_read_unlock();
+	if (xa_find(&mapping->i_pages, &hindex, hindex + HPAGE_PMD_NR - 1,
+								XA_PRESENT))
 		return NULL;
-	}
-	rcu_read_unlock();
 
 	shmem_pseudo_vma_init(&pvma, info, hindex);
 	page = alloc_pages_vma(gfp | __GFP_COMP | __GFP_NORETRY | __GFP_NOWARN,
-- 
2.17.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
