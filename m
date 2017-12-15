From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v5 52/78] btrfs: Convert page cache to XArray
Date: Fri, 15 Dec 2017 14:04:24 -0800
Message-ID: <20171215220450.7899-53-willy@infradead.org>
References: <20171215220450.7899-1-willy@infradead.org>
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
 bh=rB/9t7LpOsmVd4X3ijI5CeNPcYs8VhDGc9cOiAuygfo=; b=Piuw0vK+tsRUzoFnIiD1ti3aSO
 KV0sj23W9/VlQezNFMSB1+FB8O4PAfRTdzZRORkm25BN0sw5k0ieBLWFhsfykGm+I3I8Gu67Byyvh
 +L3lq9g+rplOsxsyZDr/SnEJb526b30VlTb92TRidS3DdD9ncKe40r47mtAYBcAFHgRs=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=rB/9t7LpOsmVd4X3ijI5CeNPcYs8VhDGc9cOiAuygfo=; b=cevJMEU97U3KQr/qV9FbuWcKII
 Vinf4tJpPZpbu/HLGxo6FJ4jas7nnX4CYBJfLjmajtcnqNSzFNovYq+9bT9x1e34gi3p/fe/uuo+e
 2cCxyuEtuwgJveHvtWzx/4d2qI1xIiCzu39zOdf9qKrkknrMr1rqEw+/Jw2td82gCUG8=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=rB/9t7LpOsmVd4X3ijI5CeNPcYs8VhDGc9cOiAuygfo=; b=jvDAo1xHWJ58vgP0ZX4iYTup/
 a1ViwFiwEDBrvt9jC4AEBkA3omhdzA5dYF23DL8sBYZupU29kXb6hnVcITFdSVcEKHhBOIKpL+FPW
 0409dSh/dKQU2e7jPHuwCI7FEqedDvoYDKwv8p19c6H+Cem9yCCrQ8gV8wabSGSrTrbahPStyONXe
 ESuJVSWSx6CRKng5Z283LifXX7Hq332z+UNy8VhXd1oxPoey4zm93oAZ9mvIyjT2ui2VKFOIaemNP
 JVpGJgDya8nppPYJdaC2R3xIYrbuVu7D62FMdOcp5wLIstajrJUHKAfme0nS/umy7K5ssotrRIdo/
 +/3LxkK7w==;
In-Reply-To: <20171215220450.7899-1-willy@infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, linux-xfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-raid@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-usb@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, David Howells <dhowells@redhat.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Rehas Sachdeva <aquannie@gmail.com>, Shaohua Li <shli@kernel.org>, linux-btrfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/btrfs/compression.c | 4 +---
 fs/btrfs/extent_io.c   | 6 ++----
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index e687d06cd97c..4174b166e235 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -449,9 +449,7 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 		if (pg_index > end_index)
 			break;
 
-		rcu_read_lock();
-		page = radix_tree_lookup(&mapping->pages, pg_index);
-		rcu_read_unlock();
+		page = xa_load(&mapping->pages, pg_index);
 		if (page && !xa_is_value(page)) {
 			misses++;
 			if (misses > 4)
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 4301cbf4e31f..fd5e9d887328 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5197,11 +5197,9 @@ void clear_extent_buffer_dirty(struct extent_buffer *eb)
 
 		clear_page_dirty_for_io(page);
 		xa_lock_irq(&page->mapping->pages);
-		if (!PageDirty(page)) {
-			radix_tree_tag_clear(&page->mapping->pages,
-						page_index(page),
+		if (!PageDirty(page))
+			__xa_clear_tag(&page->mapping->pages, page_index(page),
 						PAGECACHE_TAG_DIRTY);
-		}
 		xa_unlock_irq(&page->mapping->pages);
 		ClearPageError(page);
 		unlock_page(page);
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
