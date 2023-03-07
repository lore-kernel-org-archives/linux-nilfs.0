From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/7] shmem: open code the page cache lookup in shmem_get_folio_gfp
Date: Tue,  7 Mar 2023 15:34:08 +0100
Message-ID: <20230307143410.28031-6-hch@lst.de>
References: <20230307143410.28031-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=J8Wv/S8hZkGarl/vdU2yd/Mb7/z5z/afVPXh/Kxsm98=; b=H2ObeCoc8auj571tf6mE3PvlmW
        v7uz73zg80LebWXfbeT9jKI8uO4ZQk1c4nZSObeX4GMQXRAW3FIpO72F09zQcUyW9Gu/2P1tdR+93
        1ESO4LKLuRhumNB1tdml7A9Nnd6uEgRxdBI/hG8RiWADv0eU5nGp1VbWcLp6oTNnvpbxT4mVH3iFp
        Vu595d8mCCTWXMGmmbZSMKqXizM5d2t1yV7AbxlbetK8PLWqpk1IXX4tDAaPIaXksi91tbkhJDk2o
        37ihKioXLopdZ7z4w4ynbc2Hxi+aX5ZhXuesV+yV9p0Y8XOV7y5NhsvKVCLkkYlfDjbFgNm+L1+eP
        SLSenIbA==;
In-Reply-To: <20230307143410.28031-1-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>
Cc: linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, cluster-devel@redhat.com, linux-mm@kvack.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nilfs@vger.kernel.org

Use the very low level filemap_get_entry helper to look up the
entry in the xarray, and then:

 - don't bother locking the folio if only doing a userfault notification
 - open code locking the page and checking for truncation in a related
   code block

This will allow to eventually remove the FGP_ENTRY flag.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/shmem.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 3705437c5757ba..714ff3fb02a938 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1856,12 +1856,10 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 	sbinfo = SHMEM_SB(inode->i_sb);
 	charge_mm = vma ? vma->vm_mm : NULL;
 
-	folio = __filemap_get_folio(mapping, index, FGP_ENTRY | FGP_LOCK, 0);
+	folio = filemap_get_entry(mapping, index);
 	if (folio && vma && userfaultfd_minor(vma)) {
-		if (!xa_is_value(folio)) {
-			folio_unlock(folio);
+		if (!xa_is_value(folio))
 			folio_put(folio);
-		}
 		*fault_type = handle_userfault(vmf, VM_UFFD_MINOR);
 		return 0;
 	}
@@ -1877,6 +1875,14 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 	}
 
 	if (folio) {
+		folio_lock(folio);
+
+		/* Has the page been truncated? */
+		if (unlikely(folio->mapping != mapping)) {
+			folio_unlock(folio);
+			folio_put(folio);
+			goto repeat;
+		}
 		if (sgp == SGP_WRITE)
 			folio_mark_accessed(folio);
 		if (folio_test_uptodate(folio))
-- 
2.39.1

