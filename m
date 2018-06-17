From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v14 49/74] shmem: Convert find_swap_entry to
 XArray
Date: Sat, 16 Jun 2018 19:00:27 -0700
Message-ID: <20180617020052.4759-50-willy@infradead.org>
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
 bh=UL7Dd8P+07FgmPfVgBxdWbMx7UGqU9gll23MkeO9Cj4=; b=Pj5PBh3rfVZ0gzhs6iQl53GjIC
 1Km6TNt0GMNLUPkU/XNHS0EePKLlPiJuTeJpMeC4jx+0hEYn1OkgpsUdtfmeH+y/ox3lA833Ag02C
 Wc5oQ7TI6i1MD6i+2W+nyVyB6da+ZC/k2Lmnzm5f1m9tTk9Zokah33o/lBDaYrLupiL0=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=UL7Dd8P+07FgmPfVgBxdWbMx7UGqU9gll23MkeO9Cj4=; b=cE5b59gkggB3rglZXNOcBoWYQW
 EYJPtmtVeDuS43+obrM/opidYh0+JBv+uAj4/3FEZNdK5JRy3iaRFlchgJsHsQYI1Uy5FhUjv30A/
 +HoCbv9gEKhFIT2tSfx9Owz/aHpiF/HI49RMh3yOTC4FeEBECWrwl/kQHWGiZE+zK4+I=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=UL7Dd8P+07FgmPfVgBxdWbMx7UGqU9gll23MkeO9Cj4=; b=ObeYbgFHW40CIoI9Iay9YDcWB
 R1kLjrm1K4zSgLFf60/M+hfgncpEpteXsSNjqaVrhSZvqoTB2A0s+iXwQq1cN9GVs5+sRvopf5eMH
 B703/nXeYHsQFY6Lkn2WXqx3JncFQC1iCAFeZHlG+RkpUFWs9kAyLv24VPpLXF9tyOdje0VuVPW2B
 o1I2d7ZOtcKOHNlNKbd0UjtCs+Gz4jQ23VF2GTFIX0G3jFkRjv1Jvo6LOmX9tm/xmecUSqeyfjHqz
 mz5vLYkpNOs+kyQZv7ToapcRmRYgjsF7lWY8j6fbwTiEXriorLtlJkugjjUMNw/rNpYoPWNDZoxe3
 g/CiG4N/A==;
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

This is a 1:1 conversion.

Signed-off-by: Matthew Wilcox <willy@infradead.org>
---
 mm/shmem.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 479e4a8e6d68..983a27656e2e 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1099,34 +1099,27 @@ static void shmem_evict_inode(struct inode *inode)
 	clear_inode(inode);
 }
 
-static unsigned long find_swap_entry(struct radix_tree_root *root, void *item)
+static unsigned long find_swap_entry(struct xarray *xa, void *item)
 {
-	struct radix_tree_iter iter;
-	void __rcu **slot;
-	unsigned long found = -1;
+	XA_STATE(xas, xa, 0);
 	unsigned int checked = 0;
+	void *entry;
 
 	rcu_read_lock();
-	radix_tree_for_each_slot(slot, root, &iter, 0) {
-		void *entry = radix_tree_deref_slot(slot);
-
-		if (radix_tree_deref_retry(entry)) {
-			slot = radix_tree_iter_retry(&iter);
+	xas_for_each(&xas, entry, ULONG_MAX) {
+		if (xas_retry(&xas, entry))
 			continue;
-		}
-		if (entry == item) {
-			found = iter.index;
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
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
