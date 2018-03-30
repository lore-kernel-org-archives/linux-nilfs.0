From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v10 41/62] shmem: Convert shmem_free_swap to
 XArray
Date: Thu, 29 Mar 2018 20:42:24 -0700
Message-ID: <20180330034245.10462-42-willy@infradead.org>
References: <20180330034245.10462-1-willy@infradead.org>
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
 bh=6fFncBlYfUDhmzuZeZK3KuMK/lY6uFNf2oLLOyM7w1U=; b=Fs4WQPNaLU6Mgeuf3WE9luxtSJ
 oCqJK73Aare/H2We30E1a964XUjun+bYxZFomT1uKRTco2nuYlx4rOA91hJAqIvtv/coClzkbXXYe
 miqI+R23bN/5/BVS4uAGn4d9RBhpIwGe+SChP0zgnoyBNUuGnshQZ0nIoGh3bQvQ1k5Q=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=6fFncBlYfUDhmzuZeZK3KuMK/lY6uFNf2oLLOyM7w1U=; b=AhWmrJwsF936Acr646Libgp2sZ
 C5+7WGBtks03FnYW0LS2TtVmEsKGF3cmIZNp9eZIhPvrc5/Ty+6IMU+hFHqhDuTXAArkw96r4UtIx
 lG985DSjnuR+VR9WYaDb4VkZXu/rZL6JtxQZR1XUVHNOC+CBlYIuPPDTngTYRXnrbBlA=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=6fFncBlYfUDhmzuZeZK3KuMK/lY6uFNf2oLLOyM7w1U=; b=rJQj5iJteaHaIMwW1o1cXFxWE
 Y3iPgloSjvbe22XO8tf/QkmQu1uBdpD4jmdfT2HUMoXiSMENyzW79OAXx4VwkhJY3e5sJk0aeaRJS
 ZPLG12iKjIbVY0aOyRvfcv/iGCsPhq5vWLsaZKStoA8QvMDWb9MB7f3NSmXtnPeUbeitCjbPIK5q0
 llaVpD6suvQkfzoOVqTLhTTb9N9yUXhKfb0XAO1PZAbeGIWpez+ZpD7OW68EbiMgXnQqGuDRn4P9/
 BvoUR+Ql4HIcm9X25bk6155M7vKekUSMxRTZac+VBlyh8ONBjDqNjgWAGAFlooL3nyRwCqZ0RI9E8
 lkyb1RoRA==;
In-Reply-To: <20180330034245.10462-1-willy@infradead.org>
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

This is a perfect use for xa_cmpxchg().  Note the use of 0 for GFP
flags; we won't be allocating memory.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/shmem.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index aa7e92b24c19..be8c6d43b4aa 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -644,16 +644,13 @@ static void shmem_delete_from_page_cache(struct page *page, void *radswap)
 }
 
 /*
- * Remove swap entry from radix tree, free the swap and its page cache.
+ * Remove swap entry from page cache, free the swap and its page cache.
  */
 static int shmem_free_swap(struct address_space *mapping,
 			   pgoff_t index, void *radswap)
 {
-	void *old;
+	void *old = xa_cmpxchg(&mapping->i_pages, index, radswap, NULL, 0);
 
-	xa_lock_irq(&mapping->i_pages);
-	old = radix_tree_delete_item(&mapping->i_pages, index, radswap);
-	xa_unlock_irq(&mapping->i_pages);
 	if (old != radswap)
 		return -ENOENT;
 	free_swap_and_cache(radix_to_swp_entry(radswap));
-- 
2.16.2


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
