From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v10 52/62] dax: Fix use of zero page
Date: Thu, 29 Mar 2018 20:42:35 -0700
Message-ID: <20180330034245.10462-53-willy@infradead.org>
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
 bh=aH6CYkBFbEmdokS9BSeZj1QdQGdPwjoJG+bafqlngJo=; b=BuVkv6P7/TCuj72VT1gUd/N6Mc
 5MlB/cYdtnwtt5o4vPkPVLjL1dUUBw+ID5nJNCm+uYl1VsXr8x/dQJeM0axzGDAojBI1j8wT5QJdQ
 EQvpAy6hdq78QOx3nkeg0lAaV1ZcyhbhB3Rgow0vGdP8epdxN+j6rg+o3sLkZnDqleZk=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=aH6CYkBFbEmdokS9BSeZj1QdQGdPwjoJG+bafqlngJo=; b=Xh9TdLT18GRo3XAeYnqkY+KGst
 1JgIiwu3W7w/myEqYE5uICIqzNTRuZ8PbnAEPArI1h5XqKUsM3t1tg2BIiz2NpFRw6nFRLqxLHayo
 YzfOC8p0umcUWF5SEKtZVVblMX0d397+AR8AU8UV61RRTB1EBOrcVTzG7Enxjeu2Jvb4=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=aH6CYkBFbEmdokS9BSeZj1QdQGdPwjoJG+bafqlngJo=; b=ARaZ9kgWGWDYjijGCjRAwq/St
 3zX4g+RKEOxmvu7yScsBM41VEhbhYkO4d9hEgUyAPCBQTh3z382lY/EAcNqVZVOarBbw3j02vhjRk
 wfURjQ4hknRNAK9jmktLKTNHZ+0BYL0At6mHiFOBW1YSGbXYdTvH9BlS5hhdAGJ6D+HSEarX+SGez
 531/Oec02oHFtBotPyuXtkGRthFkM8meNwbKiOuYYRzimbnOoqEjvkWcrb93xSpRCuG6Y+KobeVQg
 FT7AfI5+i+os9L8/juQC5u8DCQbZQLy61O2K0Vg2hxeJMsvDmMSeHou4eSA77WBVP9Un143y7/E82
 ri9EOdq5A==;
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

Use my_zero_pfn instead of ZERO_PAGE, and pass the vaddr to it so it
works on MIPS and s390.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/dax.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index de40ecc9bfd6..371d50a1c14e 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -994,17 +994,9 @@ static int dax_load_hole(struct address_space *mapping, void *entry,
 	struct inode *inode = mapping->host;
 	unsigned long vaddr = vmf->address;
 	int ret = VM_FAULT_NOPAGE;
-	struct page *zero_page;
 	void *entry2;
-	pfn_t pfn;
-
-	zero_page = ZERO_PAGE(0);
-	if (unlikely(!zero_page)) {
-		ret = VM_FAULT_OOM;
-		goto out;
-	}
+	pfn_t pfn = pfn_to_pfn_t(my_zero_pfn(vaddr));
 
-	pfn = page_to_pfn_t(zero_page);
 	entry2 = dax_insert_mapping_entry(mapping, vmf, entry, pfn,
 			DAX_ZERO_PAGE, false);
 	if (IS_ERR(entry2)) {
-- 
2.16.2


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
