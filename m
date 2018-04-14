From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v11 23/63] page cache: Convert
 filemap_range_has_page to XArray
Date: Sat, 14 Apr 2018 07:12:36 -0700
Message-ID: <20180414141316.7167-24-willy@infradead.org>
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
 bh=UCapYsmRXk4fY2P03sxiTRKQhWeTVypTBTD8XEnqgLM=; b=N/gyU35l9gJufZuGxhodv1uJBl
 DROXSUNo/zVrDeXY2l2+Ie7oImpn7/L0tkFdWm9Kj71jGeT7SGsT4AN8tUUqr6U0hzu7OwFQXub8w
 Oyz8feaIPaDgrXypafCIfX3Jk56LuTRoiJT8Z3vGllVuebjq+sjOsGUnwrNzpPM3fxLU=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=UCapYsmRXk4fY2P03sxiTRKQhWeTVypTBTD8XEnqgLM=; b=aJAqCrDSK9y6Fq1yNhPRz3k+ad
 R8oUxfQUZaoZjcD6/EX+19PSaT8/Iu74xxafRZ3g15ZEJx2yaavuchyrq/oLAa69UO1Vyj9Ii4kNF
 MGaq57jQOcV/5eAjKCBmTcddYn0sVZi0fg8B4ZWUKlpsPSkdZ2suwM+YGOFu2japbfVg=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=UCapYsmRXk4fY2P03sxiTRKQhWeTVypTBTD8XEnqgLM=; b=qJMYDhjtTBbftXdBbihNVRQwn
 ws6Xmj5ZrpQrajFlnN18nl3TQCCDQlM0pBi+7fghNHLsnGTSD0meJBjNTCB/OwxLhwOLxY8oYWa8p
 DPsBptdlCJgsIdAL9p8pdgOyq3FO89WMsKUWMt0TFAN5UmvQteXI152j1cbJotnHFfdUG5zalsPRz
 1WctS2Rqr2TW37dwMh5BqLeTlS1T7ouVzprV1ci+0Aqs/Es4fbbpnY6MRUsAsBD+4ajW0eK3v0w+2
 kkVQU24DJBaGgKw1BIjZJ11Y6E6QqDqK6gz7bcjkebx54Xe68Rub6DDYVhy2MdsA2HSWCWPRkfRd/
 dzIt8jNYQ==;
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

Instead of calling find_get_pages_range() and putting any reference,
use xas_find() to iterate over any entries in the range, skipping the
shadow/swap entries.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/filemap.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index bf231ebadb86..b260c83751b8 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -458,20 +458,30 @@ EXPORT_SYMBOL(filemap_flush);
 bool filemap_range_has_page(struct address_space *mapping,
 			   loff_t start_byte, loff_t end_byte)
 {
-	pgoff_t index = start_byte >> PAGE_SHIFT;
-	pgoff_t end = end_byte >> PAGE_SHIFT;
 	struct page *page;
+	XA_STATE(xas, &mapping->i_pages, start_byte >> PAGE_SHIFT);
+	pgoff_t max = end_byte >> PAGE_SHIFT;
 
 	if (end_byte < start_byte)
 		return false;
 
-	if (mapping->nrpages == 0)
-		return false;
+	rcu_read_lock();
+	do {
+		page = xas_find(&xas, max);
+		if (xas_retry(&xas, page))
+			continue;
+		/* Shadow entries don't count */
+		if (xa_is_value(page))
+			continue;
+		/*
+		 * We don't need to try to pin this page; we're about to
+		 * release the RCU lock anyway.  It is enough to know that
+		 * there was a page here recently.
+		 */
+	} while (0);
+	rcu_read_unlock();
 
-	if (!find_get_pages_range(mapping, &index, end, 1, &page))
-		return false;
-	put_page(page);
-	return true;
+	return page != NULL;
 }
 EXPORT_SYMBOL(filemap_range_has_page);
 
-- 
2.17.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
