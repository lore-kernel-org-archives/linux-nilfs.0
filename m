From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v5 67/78] page cache: Finish XArray conversion
Date: Fri, 15 Dec 2017 14:04:39 -0800
Message-ID: <20171215220450.7899-68-willy@infradead.org>
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
 bh=tKQOl0vDgGc/1Dp8cnYTYXe0Rr75h7fPE9HnDcT2JL0=; b=QkjLK+I9vOfYl/MUPV/RUMKMQ3
 5vGMy3JJeqWvslp6XQN4E3L3j1jnaQHszR+Rhi4kSp6ltdi36XH19h4E9EtRyZRFjI+5fBv3q5hOn
 2G/LCAI+Ugo0l08KpacoLrC2JUTiZpI5zZL89yIexL2ySwcZdMfdQm9k57yd86n4PC58=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=tKQOl0vDgGc/1Dp8cnYTYXe0Rr75h7fPE9HnDcT2JL0=; b=KwQt+IWMQDNfDFRhXvOH6YsXgA
 NSFq3zCJULu9Yb9gjRfMgOrX4GCzyVbDNBnS92DIc97tfqaVWRcnZCBCbgcXqnaJFrHQnOT9fZLTc
 ppsLWJgfox5+SYdC7iaX5XpSvVKPYxanN+zBKt4Pnnb1H05C26/2PtkDILAq2c2jNMMg=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=tKQOl0vDgGc/1Dp8cnYTYXe0Rr75h7fPE9HnDcT2JL0=; b=pObaet+EKfUAVbVMRJs6A0/Eg
 OgNDMs6ijKQdhKf9Q863JRPenOoGgrIOXCglKGfegFDjfLIp0++lEx7f1vBMkeTiKX+x0C32B9YSs
 CoSz7oepK56xuopVYi+SELElrYs8nSxaZwu4azoWpYQBVziDClSO9kFsngTkxp4+Yvw3tNbvBkDr9
 /h8imuqRDS79kKUJVwhSPI93PHjBzeCcoi0veopqJUKbp3bf+UfaKczrMuXnkzfkxkcSIdo0yasmu
 aKZ94B5MQRZQ1JwOUEH/0OENaBCu04aA+yh0ldjJyerO7ORvOzO/i0HY78upg1VRTbB/KiJcQF4iF
 1tgVaOMdA==;
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

With no more radix tree API users left, we can drop the GFP flags
and use xa_init() instead of INIT_RADIX_TREE().

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/inode.c         | 2 +-
 include/linux/fs.h | 2 +-
 mm/swap_state.c    | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index c7b00573c10d..2046ff6dd1b3 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -348,7 +348,7 @@ EXPORT_SYMBOL(inc_nlink);
 void address_space_init_once(struct address_space *mapping)
 {
 	memset(mapping, 0, sizeof(*mapping));
-	INIT_RADIX_TREE(&mapping->pages, GFP_ATOMIC | __GFP_ACCOUNT);
+	xa_init(&mapping->pages);
 	init_rwsem(&mapping->i_mmap_rwsem);
 	INIT_LIST_HEAD(&mapping->private_list);
 	spin_lock_init(&mapping->private_lock);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c58bc3c619bf..b459bf4ddb62 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -410,7 +410,7 @@ int pagecache_write_end(struct file *, struct address_space *mapping,
  */
 struct address_space {
 	struct inode		*host;
-	struct radix_tree_root	pages;
+	struct xarray		pages;
 	gfp_t			gfp_mask;
 	atomic_t		i_mmap_writable;
 	struct rb_root_cached	i_mmap;
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 219e3b4f09e6..6ee5b17d7e79 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -573,7 +573,7 @@ int init_swap_address_space(unsigned int type, unsigned long nr_pages)
 		return -ENOMEM;
 	for (i = 0; i < nr; i++) {
 		space = spaces + i;
-		INIT_RADIX_TREE(&space->pages, GFP_ATOMIC|__GFP_NOWARN);
+		xa_init(&space->pages);
 		atomic_set(&space->i_mmap_writable, 0);
 		space->a_ops = &swap_aops;
 		/* swap cache doesn't use writeback related tags */
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
