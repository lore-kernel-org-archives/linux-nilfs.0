From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v10 30/62] mm: Convert __do_page_cache_readahead
 to XArray
Date: Thu, 29 Mar 2018 20:42:13 -0700
Message-ID: <20180330034245.10462-31-willy@infradead.org>
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
 bh=AMhH+5KkWNPBMUNg7Nyd5ZCPALfjtwH4e2koahTgv9k=; b=TNX3L6SJLWMphytGisphlJS+bh
 O01Sp9/DM7bOi36WjyKOXmUT7oTWg2ha0hUNlxToOeLCJiq3Kx14hGvlClrf8zuPv/nqxOHGcPxPm
 m9/7M1KS7RwhzXzJB6efQUs2+w/xkxPqJOuEJA4j3bjyBoQUTz29Va3cBJXSge0IavHc=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=AMhH+5KkWNPBMUNg7Nyd5ZCPALfjtwH4e2koahTgv9k=; b=FxmmIOenuOkRIAZwfIRw3i7Rmb
 836G/hlBUBOErCtqh7SrXqd5VJ9aw0ZrxyIH/vLUhCc6wL6zRDpTEaakUB19dBbl7ljH10t8Qh6rT
 prIx6kMXPEaVbibPDo2ZDzmFFNI4BcSwOkPqGT0koBUQTPbz5LsI4knAOTTwS1gP01ew=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=AMhH+5KkWNPBMUNg7Nyd5ZCPALfjtwH4e2koahTgv9k=; b=hPVsxP8tVZllG149V8VacPHcK
 AoedxPrcnZSwqD18sTnj9dD+vsAfwNmrT2OJU41VWBFkccQaBr1Wgv0xHQXudLcgSUHKEtsAHeQ80
 J4q0EWMBi4QrvTP7xqSzwrusiRejPRVTD2R8N22bKstFbFcnqsc0ZFK4rZbh3YvLMUzT3Cz2ZknOp
 vHcluppcutMUa5PWKGfc9CIih0jLmAf9gM9XGxWyyimkvtNHXLXlnLKPXF+ZcXf90LPOP05K87x+X
 ujMLhh/9Lk4YriHkDnJF/A8K6j8JgRf2OuSQ+ovZf9Tc+qzC+AIlEA5TzA4fhtnzrHkvU4j8y8baI
 /COa3Be0Q==;
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

This one is trivial.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/readahead.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index c7ddcf60ac6d..50910c27b372 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -174,9 +174,7 @@ int __do_page_cache_readahead(struct address_space *mapping, struct file *filp,
 		if (page_offset > end_index)
 			break;
 
-		rcu_read_lock();
-		page = radix_tree_lookup(&mapping->i_pages, page_offset);
-		rcu_read_unlock();
+		page = xa_load(&mapping->i_pages, page_offset);
 		if (page && !xa_is_value(page))
 			continue;
 
-- 
2.16.2


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
