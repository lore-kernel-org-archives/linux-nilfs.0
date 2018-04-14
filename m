From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v11 29/63] mm: Convert __do_page_cache_readahead
 to XArray
Date: Sat, 14 Apr 2018 07:12:42 -0700
Message-ID: <20180414141316.7167-30-willy@infradead.org>
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
 bh=m69AnburJMDp0saJO8vz/YDQV3lsLgqic5Z6yOQi4B4=; b=EUJvYBgTLDCbEpmtLVdqHkHGN5
 EuFNIKxL0tUpiFjykLVqC0rAfQs+kVMnUPD8Eydxi2d5LdQi4UuzXvBicC9iIIc0rrGIKXBulctks
 KhIjuYUSV7eQ9UkZLBLAKucSIoFO3F4p01aiS47w+ZzqQZ4C/BNDmLh1U5QlK76Q/gVM=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=m69AnburJMDp0saJO8vz/YDQV3lsLgqic5Z6yOQi4B4=; b=Eq9Ej3JShjaz1HxgKlu4sj3C+7
 wl6/a+3Ybn4PAdnuCmEW//VHEp+XerckISqJmd98+UnaUKHCpqEus5ndo9jphKRmXdMTNGqqC9XCX
 MZt7u63MeIpkqaIbC0YFxxX+9qcWFvRs46df1F28KX7VkazCcQBrnsFA7p+Hrb6aJEYg=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=m69AnburJMDp0saJO8vz/YDQV3lsLgqic5Z6yOQi4B4=; b=dSSH7SGGo4lN7sdIAEx+lhfff
 HbpOu2FJnoaxp9UH5J8xUPxqnXtlqtQzVuPKXfik88vs02WinqXo3V7t7wL0nSS0Hr9fhutZZVAuV
 tSM2rFYKvPwxe6CYojJ3vEi8CEmeTLr5cCzvlnGRiBujjsish2T2jk/jai+v1SxVHakLmgXLz/Ptx
 QIO9NxXuqmTnhGFL8ZosCQk6CzkyPjxbyIGD47fdl/BFLYPpZWhTDH+k7RnCOJE7DmboC54DS+1BK
 huOQVUC2ASzCqqWP1/F2WiyljgC8mZEczY2ACOJsgolG/h21s4A/aCYypfYgbZRjJepWw8wHLRPW/
 XHjVIoWYg==;
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
2.17.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
