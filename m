From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v5 62/78] dax: Convert dax_writeback_one to XArray
Date: Fri, 15 Dec 2017 14:04:34 -0800
Message-ID: <20171215220450.7899-63-willy@infradead.org>
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
 bh=ehQmXzOud9JZwlbl8LBPddx5wQCRUgUygA98ecRbjis=; b=eh9notBXGDJ1Ob2LVsKLRpOHq8
 E29Di/+GhDgkHwrj+QJo3GSx4ofJ1aQILh2mRkxGkF+bNo/LtAdJd3fB+u1moPATorKjuVyVrV21f
 vrrqACSiFSnJzK6MrANZHriVr2jRV98aRBD6k6NYs276B/s3sVwXRKc/okuf1mSwfh2Q=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=ehQmXzOud9JZwlbl8LBPddx5wQCRUgUygA98ecRbjis=; b=elE4tSG5r9/LAMvA971Jy0ij7f
 JXiZs6msZI+B3YWWuGxvqokmwFPurNi2u3olS/hZ4y9bO91/y4+Ty6m36dwmAj/V075ZdGvsyKHN4
 jFIwV8Rzadk27UOSlz+vj5lKnYG3HcZ/DO06gupDlEoRoqpvOdwUB/LPpvNEiqQVCi+o=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=ehQmXzOud9JZwlbl8LBPddx5wQCRUgUygA98ecRbjis=; b=rpiYXiGh4dbbLeDDdfVeFzt6s
 WNzB17wkpsrsdhuuPCjZZlbtygSvXMFKgX5mqB0twPLyp0kDtjPdgmWuaks5A0awZnHkC8ZfLZAPA
 8mZwaq8vhOYqowt+07rtPzrPdUpTmE1Aj8ueS/4dIkne9Y5Y/n+uz+BAbKJSEQMndhZ2G33JZH3ED
 8uTN30c2ecwpQLR68j1igxkqVfkObPR+MCqMgL/91bWQrxGBecT9MR3l/c/36WHARw70xpkKqXCp4
 UgNq3NIU60JFNrmM1JPj21YAu/l+W22M0dDzWtMlUGINCMEMXffqAHUPrdARtX5FyMlLdEwUyvkSE
 WSGSb3q9A==;
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

Likewise easy

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/dax.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index d3894c15609a..d6dd779e1b46 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -633,8 +633,7 @@ static int dax_writeback_one(struct block_device *bdev,
 		struct dax_device *dax_dev, struct address_space *mapping,
 		pgoff_t index, void *entry)
 {
-	struct radix_tree_root *pages = &mapping->pages;
-	XA_STATE(xas, pages, index);
+	XA_STATE(xas, &mapping->pages, index);
 	void *entry2, *kaddr;
 	long ret = 0, id;
 	sector_t sector;
@@ -649,7 +648,7 @@ static int dax_writeback_one(struct block_device *bdev,
 	if (WARN_ON(!xa_is_value(entry)))
 		return -EIO;
 
-	xa_lock_irq(&mapping->pages);
+	xas_lock_irq(&xas);
 	entry2 = get_unlocked_mapping_entry(&xas);
 	/* Entry got punched out / reallocated? */
 	if (!entry2 || WARN_ON_ONCE(!xa_is_value(entry2)))
@@ -668,7 +667,7 @@ static int dax_writeback_one(struct block_device *bdev,
 	}
 
 	/* Another fsync thread may have already written back this entry */
-	if (!radix_tree_tag_get(pages, index, PAGECACHE_TAG_TOWRITE))
+	if (!xas_get_tag(&xas, PAGECACHE_TAG_TOWRITE))
 		goto put_unlocked;
 	/* Lock the entry to serialize with page faults */
 	entry = lock_slot(&xas);
@@ -679,8 +678,8 @@ static int dax_writeback_one(struct block_device *bdev,
 	 * at the entry only under xa_lock and once they do that they will
 	 * see the entry locked and wait for it to unlock.
 	 */
-	radix_tree_tag_clear(pages, index, PAGECACHE_TAG_TOWRITE);
-	xa_unlock_irq(&mapping->pages);
+	xas_clear_tag(&xas, PAGECACHE_TAG_TOWRITE);
+	xas_unlock_irq(&xas);
 
 	/*
 	 * Even if dax_writeback_mapping_range() was given a wbc->range_start
@@ -718,9 +717,7 @@ static int dax_writeback_one(struct block_device *bdev,
 	 * the pfn mappings are writeprotected and fault waits for mapping
 	 * entry lock.
 	 */
-	xa_lock_irq(&mapping->pages);
-	radix_tree_tag_clear(pages, index, PAGECACHE_TAG_DIRTY);
-	xa_unlock_irq(&mapping->pages);
+	xa_clear_tag(&mapping->pages, index, PAGECACHE_TAG_DIRTY);
 	trace_dax_writeback_one(mapping->host, index, size >> PAGE_SHIFT);
  dax_unlock:
 	dax_read_unlock(id);
@@ -729,7 +726,7 @@ static int dax_writeback_one(struct block_device *bdev,
 
  put_unlocked:
 	put_unlocked_mapping_entry(&xas, entry2);
-	xa_unlock_irq(&mapping->pages);
+	xas_unlock_irq(&xas);
 	return ret;
 }
 
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
