From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v14 53/74] shmem: Convert
 shmem_partial_swap_usage to XArray
Date: Sat, 16 Jun 2018 19:00:31 -0700
Message-ID: <20180617020052.4759-54-willy@infradead.org>
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
 bh=cG68gKkTs5UYbRuctTjnA5DJ1Hlo3K420tinQxGQS78=; b=jSdw7qzs234vN+qWNbGATI0MCP
 pZR/sBcZNn6VG8yC34lyyC6Z32gaeeMFe4BY4o4FebzGJox7OiTe93IqYZ/VRzonOSq5Bel76BGCo
 OHuoviUmCU13iTJ2gVXac3cfjBe8clrq/kLk7zdi7RjLNjxU9E6TuNLOUfh8CVaUmd20=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=cG68gKkTs5UYbRuctTjnA5DJ1Hlo3K420tinQxGQS78=; b=h961yw1l5ws01pXy27edfJla9r
 P8QsUMwRxEuMaAjhUO9Vuklk+VlrA74oRp7vGTCpqKu4+HMHAJqcQcHztOP0zQLE+JdgBwGc7MRVN
 O8eJ3HQ3tMobC15j2UCnGtMkFYTLVTL1e1xlFr90QXvxNvrgJoYXoOVdC53lOJ+pPA3A=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=cG68gKkTs5UYbRuctTjnA5DJ1Hlo3K420tinQxGQS78=; b=c0oiJt9vr2RZyOX28lNA3rwqz
 hfl0ZlZ1FzLhhgLV2vmQ8nMAwdBeCTtb407HvZsHcqTrxzUmLBQZQOJx4krdvm2WgkVITInaNjBHY
 ERaYaqnG7/RdpnjAHCbd/CxaHCW+SVYrn+TTmqHwAFR4Fm3ABpaPnXTz23OZJC5pZmwHanqPFfcUo
 Sy821ttd2CNHL6cP8VgmTa2apeymy6o5svDu6t6LdzkzjgphePdD7GnKn7E1ZbLWs+UN0hoKbLwjz
 3J7v3MaN5L18L5SmElcIUL9730UmvnMVistmH0+Dwaq4gbFpeqjWynYFS2tjfoaKG21GwWnCQ06CE
 7FldP2KrA==;
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

Simpler code because the xarray takes care of things like the limit and
dereferencing the slot.

Signed-off-by: Matthew Wilcox <willy@infradead.org>
---
 mm/shmem.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 9dbbdd5dee30..bffb87854852 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -679,29 +679,19 @@ static int shmem_free_swap(struct address_space *mapping,
 unsigned long shmem_partial_swap_usage(struct address_space *mapping,
 						pgoff_t start, pgoff_t end)
 {
-	struct radix_tree_iter iter;
-	void __rcu **slot;
+	XA_STATE(xas, &mapping->i_pages, start);
 	struct page *page;
 	unsigned long swapped = 0;
 
 	rcu_read_lock();
-
-	radix_tree_for_each_slot(slot, &mapping->i_pages, &iter, start) {
-		if (iter.index >= end)
-			break;
-
-		page = radix_tree_deref_slot(slot);
-
-		if (radix_tree_deref_retry(page)) {
-			slot = radix_tree_iter_retry(&iter);
+	xas_for_each(&xas, page, end - 1) {
+		if (xas_retry(&xas, page))
 			continue;
-		}
-
 		if (xa_is_value(page))
 			swapped++;
 
 		if (need_resched()) {
-			slot = radix_tree_iter_resume(slot, &iter);
+			xas_pause(&xas);
 			cond_resched_rcu();
 		}
 	}
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
