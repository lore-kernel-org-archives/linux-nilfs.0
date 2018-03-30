From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v10 38/62] shmem: Convert find_swap_entry to
 XArray
Date: Thu, 29 Mar 2018 20:42:21 -0700
Message-ID: <20180330034245.10462-39-willy@infradead.org>
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
 bh=zxVstPpHa1Zn7/x3atR9gybEhOMIyTX0pi/dIzQZEuw=; b=DFhDtl/7ZkPbk8t9hZNSotXvMR
 CoDXxlo5YqgMUKAA/Fr+71C/sk/R8/fQZirLrA4cLUeecryaWGml1OxWXxwhgU8dsbACmhvheCLXr
 MVY2YTF1D0/zhsaO7XN2dsFPjTaxzc5WGg6BFoc5sUGGanPoQcxjQX1ZFnVWGIZXQO6g=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=zxVstPpHa1Zn7/x3atR9gybEhOMIyTX0pi/dIzQZEuw=; b=JZk+iG/8hZQ0u1PkQgGwrEZXiT
 FM0t9t+UM2qmx6yVa7mCZJTvRBDDurYKUHiM8//GsolEkxgLSsZ6BcJlMQrZuQz6Dt2TUvKidJqeG
 PVquWOKwEoxRc0cbWnabbnjTPy3bQYI94QiAGZ2AkS1gu53ziuwvM8d6bJZxhZpRicaA=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=zxVstPpHa1Zn7/x3atR9gybEhOMIyTX0pi/dIzQZEuw=; b=UEiWGxTXpOjHWBI1X6bbuv92U
 tbSuccRsV4LJN1txNwhc25lPiCrT6HYPvvHHiOYUqWBWnZnGNR9MkElpfDjqoQkVhm1FRmUbr2tU1
 bj4Uo+D4WKe9HuCjyPVE3vMtihXaf8fIAbVGIXzoSnuEfRO5B6vj3XOKSHTcGD36bW6UhfhOsDjSb
 m7nOCHLfW7h/CYlgZ5mGYHkc7DGokn9jSx9HjNdHBS+ibQjJ+6942z7lkCP+WGrtvyxAPyNUlGWfB
 k5WhjkLemui80/HrPWaUZyCFkKaZxmYnlELqgLBPboWKtzb3JIx+XWwDTiZDWR0PMfWZUHZ648Or8
 97K0XRT8A==;
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

This is a 1:1 conversion.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/shmem.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 4b66bcedd21c..c77b41d06528 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1085,28 +1085,27 @@ static void shmem_evict_inode(struct inode *inode)
 	clear_inode(inode);
 }
 
-static unsigned long find_swap_entry(struct radix_tree_root *root, void *item)
+static unsigned long find_swap_entry(struct xarray *xa, void *item)
 {
-	struct radix_tree_iter iter;
-	void **slot;
-	unsigned long found = -1;
+	XA_STATE(xas, xa, 0);
 	unsigned int checked = 0;
+	void *entry;
 
 	rcu_read_lock();
-	radix_tree_for_each_slot(slot, root, &iter, 0) {
-		if (*slot == item) {
-			found = iter.index;
+	xas_for_each(&xas, entry, ULONG_MAX) {
+		if (xas_retry(&xas, entry))
+			continue;
+		if (entry == item)
 			break;
-		}
 		checked++;
-		if ((checked % 4096) != 0)
+		if ((checked % XA_CHECK_SCHED) != 0)
 			continue;
-		slot = radix_tree_iter_resume(slot, &iter);
+		xas_pause(&xas);
 		cond_resched_rcu();
 	}
-
 	rcu_read_unlock();
-	return found;
+
+	return xas_invalid(&xas) ? -1 : xas.xa_index;
 }
 
 /*
-- 
2.16.2


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
