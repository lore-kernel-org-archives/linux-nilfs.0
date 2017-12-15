From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v5 54/78] fs: Convert writeback to XArray
Date: Fri, 15 Dec 2017 14:04:26 -0800
Message-ID: <20171215220450.7899-55-willy@infradead.org>
References: <20171215220450.7899-1-willy@infradead.org>
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
 bh=ocf6wl8zYKtw5m0lmpIHnD421UfKbAxeuZFBoq38Wv8=; b=PzAYvINoV//FWkWwfFWI4aTWNJ
 Z70BhZIsF4jYsyc/7XTizfc6AGQl3JFiMA1drNmui1jIX7JFxgROaZ9h56br1n0rfihSJlB+NXXxt
 j8g/EmI44P4iMD3QlCfDlRppm3f3p78/y1Lx1og3RA5lkfzXu9DXTWDELM8b/sbbYVAg=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=ocf6wl8zYKtw5m0lmpIHnD421UfKbAxeuZFBoq38Wv8=; b=nSfH0SczXIsU2yt4X31v4pQNB3
 BNPzeIUl52+OUNjncWlNT3gRzBUY6suVW84ctfBR2h/kYPmZJ3chJNkZnPr6r0p5Q2XHMKK45P/Wz
 0D4XMuNwOUqm5jT/sumJ5VTdxEWGELs7JgyrghN8OmhN/0b/IZ1j/AobB7c0y92Sb9HA=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=ocf6wl8zYKtw5m0lmpIHnD421UfKbAxeuZFBoq38Wv8=; b=aIwszvi9uPzx44st4Du5jlBCM
 EZCjQGEDbgVJWIMUMo9PElqeSMoOGJv9dvRyoiiKKVwbLylsusGEE76b0AYduQ1T48zumcwMWthIJ
 bOMaHtwyPYze+Edvnjk48j7NAt+BLJoDvX6M657c2zIDuNUw2H4aTxr+cgnqcS58l79S3CdurGAcn
 PtMbPimNq3Ia2Bude1SVFH3uNBYAT384NJP77FE6vLcIu/a4ubQ4fbPu1qHosQsivkYd3pdqQfKSM
 /ZB1YlkjpJl6lYi2rFv+wzZAsck4B+Pyo/NW16B0I1yerW8y54rpFfxaTCvure16ZDjNjj6mVScVP
 pEVvXdZ3w==;
In-Reply-To: <20171215220450.7899-1-willy@infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, linux-xfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-raid@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-usb@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, David Howells <dhowells@redhat.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Rehas Sachdeva <aquannie@gmail.com>, Shaohua Li <shli@kernel.org>, linux-btrfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

A couple of short loops.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/fs-writeback.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index e2c1ca667d9a..897a89489fe9 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -339,9 +339,9 @@ static void inode_switch_wbs_work_fn(struct work_struct *work)
 	struct address_space *mapping = inode->i_mapping;
 	struct bdi_writeback *old_wb = inode->i_wb;
 	struct bdi_writeback *new_wb = isw->new_wb;
-	struct radix_tree_iter iter;
+	XA_STATE(xas, &mapping->pages, 0);
+	struct page *page;
 	bool switched = false;
-	void **slot;
 
 	/*
 	 * By the time control reaches here, RCU grace period has passed
@@ -375,25 +375,18 @@ static void inode_switch_wbs_work_fn(struct work_struct *work)
 	 * to possibly dirty pages while PAGECACHE_TAG_WRITEBACK points to
 	 * pages actually under writeback.
 	 */
-	radix_tree_for_each_tagged(slot, &mapping->pages, &iter, 0,
-				   PAGECACHE_TAG_DIRTY) {
-		struct page *page = radix_tree_deref_slot_protected(slot,
-						&mapping->pages.xa_lock);
-		if (likely(page) && PageDirty(page)) {
+	xas_for_each_tag(&xas, page, ULONG_MAX, PAGECACHE_TAG_DIRTY) {
+		if (PageDirty(page)) {
 			dec_wb_stat(old_wb, WB_RECLAIMABLE);
 			inc_wb_stat(new_wb, WB_RECLAIMABLE);
 		}
 	}
 
-	radix_tree_for_each_tagged(slot, &mapping->pages, &iter, 0,
-				   PAGECACHE_TAG_WRITEBACK) {
-		struct page *page = radix_tree_deref_slot_protected(slot,
-						&mapping->pages.xa_lock);
-		if (likely(page)) {
-			WARN_ON_ONCE(!PageWriteback(page));
-			dec_wb_stat(old_wb, WB_WRITEBACK);
-			inc_wb_stat(new_wb, WB_WRITEBACK);
-		}
+	xas_set(&xas, 0);
+	xas_for_each_tag(&xas, page, ULONG_MAX, PAGECACHE_TAG_WRITEBACK) {
+		WARN_ON_ONCE(!PageWriteback(page));
+		dec_wb_stat(old_wb, WB_WRITEBACK);
+		inc_wb_stat(new_wb, WB_WRITEBACK);
 	}
 
 	wb_get(new_wb);
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
