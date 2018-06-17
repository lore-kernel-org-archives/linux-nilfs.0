From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v14 45/74] mm: Convert is_page_cache_freeable to
 XArray
Date: Sat, 16 Jun 2018 19:00:23 -0700
Message-ID: <20180617020052.4759-46-willy@infradead.org>
References: <20180617020052.4759-1-willy@infradead.org>
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
 bh=QGWajXY6YcCVi/fqymIb3c788sAMALnbzKJrf6tBoCc=; b=fYc/HtWVauMuw/DckHDbKcJio1
 tEckuXtThQLs0MqSePxuJNyh3w2IPCyIIPKoSdYBMx/Hvw2md4xU7BnPUzUZNBeVhxJGrTekd4Hau
 3m2K9X4l4rZzk24fzcTfcbdeJ2JYiRG4quaxpfxIsjVQbOFXYKw1gAXrNeVRHGglqJd8=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=QGWajXY6YcCVi/fqymIb3c788sAMALnbzKJrf6tBoCc=; b=ZMKYIM1jaJlMtF0h0eXC8vfClG
 HkgMbGh4QWj1nAzpfKTwCJgmGDC17nOgm6Q9u6PBNNzekMu1UOH4zCtsFt3VaTC6393TK/SEwIyek
 FldBgV60D5Llz/c0oiA6Qc7VJGsU4zbrgDwl8yuXNOdBs9800ANUkLRhVljEJOz9zk20=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=QGWajXY6YcCVi/fqymIb3c788sAMALnbzKJrf6tBoCc=; b=SgMqnn/8xfz2IiRU7lHnx/TBQ
 aMfcp0dcLWY+F41KJ9xNXcl1kVHMcfojiyv+6mfWW+nsqMK1cJmfmtywd8rZN6kbXZqOzrTNRgLbn
 IKdpY99/3Bcwf4wIluHRrERHG/bvPiBcKAH6QinISQUF0FAM0DMybtSx4WvKotbChxSzbiNfq3PTi
 VFgg4eUMGRdQs3NjKJnoStI5jRB7D3/nrEFx8tFWIwZhyMd2IOTFvjN2UJhGb1b2x0NFwNeGCntMx
 PeAAkzImw2KNN5zdCmvdMwwSGXv6dibwUL/4qjfWLtHB35ute1Z8LY3HSnUF59S/c3g54vG3B++7W
 DGGYIMFFA==;
In-Reply-To: <20180617020052.4759-1-willy@infradead.org>
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
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Matthew Wilcox <willy@infradead.org>, linux-f2fs-devel@lists.sourceforge.net, Nicholas Piggin <npiggin@gmail.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>

This is just a variable rename and comment change.

Signed-off-by: Matthew Wilcox <willy@infradead.org>
---
 mm/vmscan.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0448b1b366d9..575747728ee6 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -572,12 +572,12 @@ static inline int is_page_cache_freeable(struct page *page)
 {
 	/*
 	 * A freeable page cache page is referenced only by the caller
-	 * that isolated the page, the page cache radix tree and
-	 * optional buffer heads at page->private.
+	 * that isolated the page, the page cache and optional buffer
+	 * heads at page->private.
 	 */
-	int radix_pins = PageTransHuge(page) && PageSwapCache(page) ?
+	int page_cache_pins = PageTransHuge(page) && PageSwapCache(page) ?
 		HPAGE_PMD_NR : 1;
-	return page_count(page) - page_has_private(page) == 1 + radix_pins;
+	return page_count(page) - page_has_private(page) == 1 + page_cache_pins;
 }
 
 static int may_write_to_inode(struct inode *inode, struct scan_control *sc)
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
