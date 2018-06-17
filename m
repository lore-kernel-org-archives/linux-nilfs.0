From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v14 48/74] shmem: Convert shmem_confirm_swap to
 XArray
Date: Sat, 16 Jun 2018 19:00:26 -0700
Message-ID: <20180617020052.4759-49-willy@infradead.org>
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
 bh=L6O28U5bPiiNtAEzNBl43V8G8xo3oJqGs/4QpqAVQhg=; b=nDRDztqTF5fqQfL0IApxjeClHO
 QiRz4mjMpDFDRoZ1USrnGM4bVcNwl/5aoiOiXl5GvLwQTExmFTi6v8KCOlFbhLYE4+PvqkM9nd8WO
 0jOgEsuf1V3hmjoXXxRJjISw/HKaRlFJ1PCv0tmI/Qavj08mH4b9bpi0N1RvaqcjPYWI=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=L6O28U5bPiiNtAEzNBl43V8G8xo3oJqGs/4QpqAVQhg=; b=eiPDgjse/1EwduE1cdfhwyrvvC
 UcByP/wE/E+Oj57tDC1PyjHAiIu9Tk1qSmUYHBi/Fymp5YziXQKLF5I2s07l3seAu42cPB0XrhVAU
 9AER06dWSb9H7CGP851YLKbsYV4rbPfnNxh2tGY/V8fVL/tBY+nx10qOA36Jcr/i2D/8=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=L6O28U5bPiiNtAEzNBl43V8G8xo3oJqGs/4QpqAVQhg=; b=tl7JYoDThgJELlV7nSJi9IIDV
 OfbXxR9CH0fIieO+rRqBzXr7h+GVspI0Ku3Y1/zp+VlYY5EHSkg0SFcNfMnTO2vCucsZC2RcNWP4h
 OkZ+Li1NnFfvpobXmooUXkVVCYIM90Rsxs4vccWME81KDr/BWupjwTTloNIVQ7vgjMQd+kTABpbf4
 EHAqbOIIZIXfyd3PzqnkhlEzE+JGDMdHLTGzigeUGGJR0v7oMzkxd/ll4XHkQZe8Gn1zILSpQWC01
 WrRkE9Poy0DFiBl1ysSbTmWp/HZPqCaOYKbOFt1jX+Of08BVfgy0jg61pzX3j5/hRR9mlfHlPccZN
 5q+D2d6sQ==;
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

xa_load has its own RCU locking, so we can eliminate it here.

Signed-off-by: Matthew Wilcox <willy@infradead.org>
---
 mm/shmem.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 2b8720d32e7a..479e4a8e6d68 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -348,12 +348,7 @@ static int shmem_replace_entry(struct address_space *mapping,
 static bool shmem_confirm_swap(struct address_space *mapping,
 			       pgoff_t index, swp_entry_t swap)
 {
-	void *item;
-
-	rcu_read_lock();
-	item = radix_tree_lookup(&mapping->i_pages, index);
-	rcu_read_unlock();
-	return item == swp_to_radix_entry(swap);
+	return xa_load(&mapping->i_pages, index) == swp_to_radix_entry(swap);
 }
 
 /*
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
