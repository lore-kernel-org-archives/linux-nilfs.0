From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v14 52/74] shmem: Convert shmem_free_swap to
 XArray
Date: Sat, 16 Jun 2018 19:00:30 -0700
Message-ID: <20180617020052.4759-53-willy@infradead.org>
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
 bh=jlPJjd97phkgtLpaFqwtKpwhcV6aMOInwpP/oXccAJE=; b=KyBhXfRq7zR3ZrSrkLkUEF3TIL
 B5BVzN8e1wzyxXVsSsD6fj8hkPLgJPHIEIRWnJeDAGHXtpn7+f9NkbT2t3rO+naMIHqUdRy3TH5VW
 YpEpu1gE3CkpNBf60r7SHqZ/RbxUrbLkYPpnXdfbJIpiEKt9WsKEuPXQlWOMIF4SAnzg=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=jlPJjd97phkgtLpaFqwtKpwhcV6aMOInwpP/oXccAJE=; b=R79wAR5qjkM3LOquJ/gT+F3Y/X
 L5EljWB79ojHZMg2rGzGW7uWD6RSOMbCmuyAdr+Wd0MZz8YbmGrp9RpK5wftWos177f4/7Fre9fup
 T59/bUCgJa5CjJmO+pHLqeasGC8Q90u4vRGxTZvneiOkgxcHgQpUv4UOJIpsYeg4HNTs=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=jlPJjd97phkgtLpaFqwtKpwhcV6aMOInwpP/oXccAJE=; b=hWK1Br71IXraKoB6WwcincedS
 yWb6z9VzFKd2qCNUwYvcUCz/ZkBSH3pTmCnZcM8VhWwzsurZVKs/y2ioqp/4693fTfYXgfz+vx944
 NsdOdcv1YLUgbu+EArt8hB3HROEw8AxJYF6mGcNneDhanlqjsiXRiE2OlmSZQ0pwAj0XqLys/X3Nr
 tKf7bEjnqsaTxWaNYMRXXWoJz3BSU4R8+p3JPT/Z7eMsY9lV/N0jg0rwr4DQ8aMW7ByQeQF63ysQn
 7qnYe+4ERWy1PNu7PqKEeli0cpvPhFfeHduHsbbrR99rf86PZNRIUfNNETuJb7IaIR4DuBEKt+9Wq
 BXCNe+gLg==;
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

Since we are conditionally storing NULL in the XArray, we do not need
to allocate memory and the GFP flags will be unused.

Signed-off-by: Matthew Wilcox <willy@infradead.org>
---
 mm/shmem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 09452ca79220..9dbbdd5dee30 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -653,7 +653,7 @@ static void shmem_delete_from_page_cache(struct page *page, void *radswap)
 }
 
 /*
- * Remove swap entry from radix tree, free the swap and its page cache.
+ * Remove swap entry from page cache, free the swap and its page cache.
  */
 static int shmem_free_swap(struct address_space *mapping,
 			   pgoff_t index, void *radswap)
@@ -661,7 +661,7 @@ static int shmem_free_swap(struct address_space *mapping,
 	void *old;
 
 	xa_lock_irq(&mapping->i_pages);
-	old = radix_tree_delete_item(&mapping->i_pages, index, radswap);
+	old = __xa_cmpxchg(&mapping->i_pages, index, radswap, NULL, 0);
 	xa_unlock_irq(&mapping->i_pages);
 	if (old != radswap)
 		return -ENOENT;
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
