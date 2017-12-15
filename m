From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v5 46/78] shmem: Convert shmem_wait_for_pins to
 XArray
Date: Fri, 15 Dec 2017 14:04:18 -0800
Message-ID: <20171215220450.7899-47-willy@infradead.org>
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
 bh=tm395P+07Nr+JL+jzuW6+85raWyo2+0xXriULUgqQxI=; b=cyV/K8pMGfsh0boqxGodXYfMNK
 mKmVz2G8IuPFrqHD9GhvrWZP1lsFnx4h6NReZW8rerVom6775PwY7CymMsVukvG3tZcJmv34mlELJ
 bxPMbiE3m7TCe5ia0bTXWc9mvjhjQcs7CrYu79vTikC0r2fCciSEyK0C50s5JSlznUvI=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=tm395P+07Nr+JL+jzuW6+85raWyo2+0xXriULUgqQxI=; b=RGGuanJ8dl6eNwESroaQwTmgZ2
 IWPpb91vlTo/HQqNV4W27iRqAxbvp00H8aouS3hxESxjOcZmRk7ngnsGMXxYbEiBq+HwnwGR5Chbs
 2LGwHHqwXYpcuf2FWz55RTBiZbIzyJQ+UJHX/Coht8IcNRJ/ERGBF2IHuHke2IbjPAHQ=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=tm395P+07Nr+JL+jzuW6+85raWyo2+0xXriULUgqQxI=; b=YreIEwZpTzh3tEArKjiSAvhWi
 SjKFoMtRlvKyd/MhJ7uZa3nINYqGIjqQ9brH8ju/QHslt164D+0NEyM7dhviq+oh7hZrJewWHqfJO
 +DxssnPugxTlvQkLGruY9WilHsXhmBohEv1qvCTCSn9u57EH7qxYFmeRV0zFC2wmD4Tqzfp4o2qmF
 gYslVsXGBK7khTWHFlavlPxCn/aw40zG8PnsEh6EQYf+sTF5CAxmixm1Y8etoY7IZXu0DtU03p600
 WIsPLMtvl+dpbwhdu1aWpGdbxaYp4E8JnNsg4NXwHUMMGCdKVh0U0BZZWxuzdHlz+aYyhRkuN2xyl
 VF6/JX6/w==;
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

As with shmem_tag_pins(), hold the lock around the entire loop instead
of acquiring & dropping it for each entry we're going to untag.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/shmem.c | 59 ++++++++++++++++++++++++-----------------------------------
 1 file changed, 24 insertions(+), 35 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 2f41c7ceea18..e4a2eb1336be 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2636,9 +2636,7 @@ static void shmem_tag_pins(struct address_space *mapping)
  */
 static int shmem_wait_for_pins(struct address_space *mapping)
 {
-	struct radix_tree_iter iter;
-	void **slot;
-	pgoff_t start;
+	XA_STATE(xas, &mapping->pages, 0);
 	struct page *page;
 	int error, scan;
 
@@ -2646,7 +2644,9 @@ static int shmem_wait_for_pins(struct address_space *mapping)
 
 	error = 0;
 	for (scan = 0; scan <= LAST_SCAN; scan++) {
-		if (!radix_tree_tagged(&mapping->pages, SHMEM_TAG_PINNED))
+		unsigned int tagged = 0;
+
+		if (!xas_tagged(&xas, SHMEM_TAG_PINNED))
 			break;
 
 		if (!scan)
@@ -2654,45 +2654,34 @@ static int shmem_wait_for_pins(struct address_space *mapping)
 		else if (schedule_timeout_killable((HZ << scan) / 200))
 			scan = LAST_SCAN;
 
-		start = 0;
-		rcu_read_lock();
-		radix_tree_for_each_tagged(slot, &mapping->pages, &iter,
-					   start, SHMEM_TAG_PINNED) {
-
-			page = radix_tree_deref_slot(slot);
-			if (radix_tree_exception(page)) {
-				if (radix_tree_deref_retry(page)) {
-					slot = radix_tree_iter_retry(&iter);
-					continue;
-				}
-
-				page = NULL;
-			}
-
-			if (page &&
-			    page_count(page) - page_mapcount(page) != 1) {
-				if (scan < LAST_SCAN)
-					goto continue_resched;
-
+		xas_set(&xas, 0);
+		xas_lock_irq(&xas);
+		xas_for_each_tag(&xas, page, ULONG_MAX, SHMEM_TAG_PINNED) {
+			bool clear = true;
+			if (xa_is_value(page))
+				continue;
+			if (page_count(page) - page_mapcount(page) != 1) {
 				/*
 				 * On the last scan, we clean up all those tags
 				 * we inserted; but make a note that we still
 				 * found pages pinned.
 				 */
-				error = -EBUSY;
+				if (scan == LAST_SCAN)
+					error = -EBUSY;
+				else
+					clear = false;
 			}
+			if (clear)
+				xas_clear_tag(&xas, SHMEM_TAG_PINNED);
+			if (++tagged % XA_CHECK_SCHED)
+				continue;
 
-			xa_lock_irq(&mapping->pages);
-			radix_tree_tag_clear(&mapping->pages,
-					     iter.index, SHMEM_TAG_PINNED);
-			xa_unlock_irq(&mapping->pages);
-continue_resched:
-			if (need_resched()) {
-				slot = radix_tree_iter_resume(slot, &iter);
-				cond_resched_rcu();
-			}
+			xas_pause(&xas);
+			xas_unlock_irq(&xas);
+			cond_resched();
+			xas_lock_irq(&xas);
 		}
-		rcu_read_unlock();
+		xas_unlock_irq(&xas);
 	}
 
 	return error;
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
