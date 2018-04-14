From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v11 37/63] shmem: Convert find_swap_entry to
 XArray
Date: Sat, 14 Apr 2018 07:12:50 -0700
Message-ID: <20180414141316.7167-38-willy@infradead.org>
References: <20180414141316.7167-1-willy@infradead.org>
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
 bh=s0hTSSuxyvXrpg9qt2Kdod8SuL3dDVn7Qs2A5bFdSs4=; b=dp4QUce6ale/H5+ZSgKjAjiFBU
 3F4iLhLVyzUkiC2H24yu7kReFWXiQipHCwcj1/XGTU6m3oDjC2wIRc8cRzzH+ol1wdZhtkc7HB/cF
 Z9keA8Gp9bKSBNoRDTFMntICTSS5APkktH5y1NU5LKm7t/9ol1Wdyj0xY6nTzG+ncMoI=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=s0hTSSuxyvXrpg9qt2Kdod8SuL3dDVn7Qs2A5bFdSs4=; b=SMj7+sgjAqE+Cppmo8IQEeG3sv
 FCQ/WoyA5o26KvHnpjWTMNObXFvGb5A1YV8oQdkg6l6KwY0Jru/AZJokxzdXjLHKjxBJWqjuoWObk
 fop5oGtq/lj/XCsv38T+En/XJAgUpOVnb6Jfdef78+JJY4tK/JJ1QYNl2frVyMvnzkeU=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=s0hTSSuxyvXrpg9qt2Kdod8SuL3dDVn7Qs2A5bFdSs4=; b=LRXvei7E2+utf39/vU37X3GtK
 M5CstlASCRf5xK9dUvY4nSNEti6BaHcrW9bbRYMrXeG3NPA8607wb5hSuBwiBVeZAcACXunLNX7Ja
 sXGcLX/wNgZLHPciP1rR39w6Op3xTIDbV7iBN6aPerBiN0nJAFvr1oGvFzspPTbNACdbt6NEe0UKW
 YixgLiBKsCT2gTD8w2VWbgwNVA5OUqzOUarBPWKsM/yemqOG17p8jzEFkbAxqWr1wyTyDm0W3GS8N
 ex4VAQT1F18OMnJAJr6URabOV8Iyd+yPg/+y01jHflYi+ZuzYpUg1aHJ9if7zOEE+OyIocw0ogRh3
 xnNnwoyfg==;
In-Reply-To: <20180414141316.7167-1-willy@infradead.org>
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
index 5b8a2d944a0c..784a49aad902 100644
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
2.17.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
