From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v5 49/78] shmem: Convert shmem_free_swap to XArray
Date: Fri, 15 Dec 2017 14:04:21 -0800
Message-ID: <20171215220450.7899-50-willy@infradead.org>
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
 bh=xBhPUIl9cv3Z/oFe2KVJVIer6tyvBPl3fPwZBjuWuVE=; b=O8UDArcW3GB0d393mh8pH2Wllo
 J9LRg7DruXUwolCrWf4Wg6HI56EBy22KGe27zbg6h5j90ZIRVBPdJB15RztUtDooytwjt+pqeTg9H
 wt9OiRcpdDe5BhCnwf8osXbDoCNfSYfp1BDoTTlLQdFPqFjjCWJMSRW6mzc7rU7OMG6Y=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=xBhPUIl9cv3Z/oFe2KVJVIer6tyvBPl3fPwZBjuWuVE=; b=JES2Q6I1uimrotthsZ0MeiBK24
 UwpyPVKmBaLBMIVhc/oC5SwuuZWxEjpiL1ZUembSeDnFQOguy0GlRmf7ZE5CGW7E9tsn61OnVY9ns
 IVu3u/W/QqFIuwdHClsysrch3y1EooDt4MyTRsJIXW2SfLgh0/fYbAKlNJZJEdlTnJ7I=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=xBhPUIl9cv3Z/oFe2KVJVIer6tyvBPl3fPwZBjuWuVE=; b=FQTMu7gahXwoPMGHenIWnKIK/
 3AzjPYPFu3bhUolwu17CPnr2NrBNrZyA2SJcYdWFcIBTnAWDr7UpZ/Ee7xl2MA+PL8yL5ss5YJwhf
 EqpJhROOw5TtIc1SHoADcJJJXUPJclMfTuExZcuaFGlKTvSf7mzyp6z++L8Icl7KS5s8o0AK0KnH8
 XLO87AAGf8OvBRa1mqU1Apx3rnIMelXz+qC49P8DVuNoQirXduzR+VdsIq/6zibzc/TrnJWjpmH3L
 6TKGmM+57O3sXB+xrc2kp1LEIQaXvFmGbx2th4YArVpEy7DCpjOjeBKyINIQNuJN+r/1C3u0Rp+1l
 PTZQTmTFA==;
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

This is a perfect use for xa_cmpxchg().  Note the use of 0 for GFP
flags; we won't be allocating memory.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/shmem.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index bd66bbd40499..dd663341e01e 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -635,16 +635,13 @@ static void shmem_delete_from_page_cache(struct page *page, void *radswap)
 }
 
 /*
- * Remove swap entry from radix tree, free the swap and its page cache.
+ * Remove swap entry from page cache, free the swap and its page cache.
  */
 static int shmem_free_swap(struct address_space *mapping,
 			   pgoff_t index, void *radswap)
 {
-	void *old;
+	void *old = xa_cmpxchg(&mapping->pages, index, radswap, NULL, 0);
 
-	xa_lock_irq(&mapping->pages);
-	old = radix_tree_delete_item(&mapping->pages, index, radswap);
-	xa_unlock_irq(&mapping->pages);
 	if (old != radswap)
 		return -ENOENT;
 	free_swap_and_cache(radix_to_swp_entry(radswap));
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
