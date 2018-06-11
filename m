From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v13 39/72] mm: Convert __do_page_cache_readahead
 to XArray
Date: Mon, 11 Jun 2018 07:06:06 -0700
Message-ID: <20180611140639.17215-40-willy@infradead.org>
References: <20180611140639.17215-1-willy@infradead.org>
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
 bh=MujQtudD6HapXlrwSi8huMmGpeKkjTkBkrUZuiJikXE=; b=arBlaYcW/2kTUnwurM3HbOy5Oz
 d7+KJ9s7lZZq7KvwXTTFr0xMvOf0FiOzreeWWN8oMNViuDv1rvfu1nKbzrt5cGoLM29aMYMjwkVVz
 jntVE/lEQRDd41hOHHzevesc3yD+IzEp4k/L/Cqq7ghTm5E0ftlnUKETBSyG9kztwLI4=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=MujQtudD6HapXlrwSi8huMmGpeKkjTkBkrUZuiJikXE=; b=jNFINzltgdxi8dF3PdWdpx0lqS
 SRNYN3lmBI8wsCxVAyMwYHxYjp++XRol1LcNpXlYqCqQYPn1OLwLHNtkhcEv0lDuAONogfdoVQt2f
 mRbouGqbZbd4L2TP/JTWGJ98n5dkBzEyPm1+jQZlkk8rx+Ij/phZxYbNS39fMtfWvoaw=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=MujQtudD6HapXlrwSi8huMmGpeKkjTkBkrUZuiJikXE=; b=oeORb1zkr0yVfKJawkiF8tapz
 AP283ohq5CrZArgIGTWnvMCIr8sfI3jNzzfxmmQ9fD+AbFJKaKb8ZREua/EzVkPyErflY/DfaReCs
 rgzrDHCyo4jU+nseYGNF7ybp3CxQkfWrN6PXsONZYBtGv8e616D9KXlg3kBWPtEorGlakzOd4wRkb
 UAy70hJFoIYsui4qBhNL9KnBopPmd+zunjg7yYGCietgss5AcobvIiEGOO0tziaAa6SdDPdELVPOM
 rQwtM+v7XaDX5tLNQnBOE+uaDpRWkxq1PffuCjrgUjHazMoPA9DC+YDW/yyrsJRQ00p5kWB6wu9qU
 UM1uOmuIA==;
In-Reply-To: <20180611140639.17215-1-willy@infradead.org>
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
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, linux-f2fs-devel@lists.sourceforge.net, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>

From: Matthew Wilcox <mawilcox@microsoft.com>

This one is trivial.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/readahead.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index 59998ca31f2a..07f9734dc79f 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -174,9 +174,7 @@ unsigned int __do_page_cache_readahead(struct address_space *mapping,
 		if (page_offset > end_index)
 			break;
 
-		rcu_read_lock();
-		page = radix_tree_lookup(&mapping->i_pages, page_offset);
-		rcu_read_unlock();
+		page = xa_load(&mapping->i_pages, page_offset);
 		if (page && !xa_is_value(page)) {
 			/*
 			 * Page already present?  Kick off the current batch of
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
