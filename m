From: Jan Kara <jack@suse.cz>
Subject: [PATCH 34/35] mm: Make find_get_entries_tag() update
 index
Date: Thu,  1 Jun 2017 11:32:44 +0200
Message-ID: <20170601093245.29238-35-jack@suse.cz>
References: <20170601093245.29238-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sourceforge.net; s=x; 
	h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From;
	bh=rYfxvilk2yKDZ2LsB/ZRO8+cWBjLSJ+mE6jEapgmpg4=; 
	b=DcgQBUe2pp5wYki8sBIEXv7PE442jfQi9eT0mU8qck3GX+panAcRqLg9KPFiw8THaWysqda6mKGYISkOxE7nUFPYtkQxDHzI8+Kr8vOJQh7suZcRJ1kM5Kbxyk8dxgrbiMGWyVDGgTcfpiXqDzR408zF37OKHpfmVHdKqYnVpYU=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x;
	h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From;
	bh=rYfxvilk2yKDZ2LsB/ZRO8+cWBjLSJ+mE6jEapgmpg4=; 
	b=FFK3Qx5AwwF5+U6H3hJ0CsXnmlWQezHPBinDfgdtONFziGJbBG+HWHKEhlQgUV1dM8Br5fUb3d7DFryDLqUFthjtqK5PCk4JeFiLjPUuxMaJjcAzOcpVhug1x84HBHRHAAqsNE6GKEBv7R6oExbWEvCYmIHK2Tiq73nd2jIFDuI=;
In-Reply-To: <20170601093245.29238-1-jack@suse.cz>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-mm@kvack.org
Cc: cluster-devel@redhat.com, linux-nilfs@vger.kernel.org, tytso@mit.edu, linux-xfs@vger.kernel.org, "Yan, Zheng" <zyan@redhat.com>, Jan Kara <jack@suse.cz>, "Darrick J . Wong" <darrick.wong@oracle.com>, Hugh Dickins <hughd@google.com>, linux-f2fs-devel@lists.sourceforge.net, David Howells <dhowells@redhat.com>, David Sterba <dsterba@suse.com>, ceph-devel@vger.kernel.org, Nadia Yvette Chambers <nyc@holomorphy.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Bob Peterson <rpeterso@redhat.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org

Make find_get_entries_tag() update 'start' to index the next page for
iteration.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c                | 3 +--
 include/linux/pagemap.h | 2 +-
 mm/filemap.c            | 8 ++++++--
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index c204445a69b0..4b295c544fd4 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -841,7 +841,7 @@ int dax_writeback_mapping_range(struct address_space *mapping,
 
 	pagevec_init(&pvec, 0);
 	while (!done) {
-		pvec.nr = find_get_entries_tag(mapping, start_index,
+		pvec.nr = find_get_entries_tag(mapping, &start_index,
 				PAGECACHE_TAG_TOWRITE, PAGEVEC_SIZE,
 				pvec.pages, indices);
 
@@ -859,7 +859,6 @@ int dax_writeback_mapping_range(struct address_space *mapping,
 			if (ret < 0)
 				goto out;
 		}
-		start_index = indices[pvec.nr - 1] + 1;
 	}
 out:
 	put_dax(dax_dev);
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index df128a56f44b..1dc7e54ec32a 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -365,7 +365,7 @@ static inline unsigned find_get_pages_tag(struct address_space *mapping,
 	return find_get_pages_range_tag(mapping, index, (pgoff_t)-1, tag,
 					nr_pages, pages);
 }
-unsigned find_get_entries_tag(struct address_space *mapping, pgoff_t start,
+unsigned find_get_entries_tag(struct address_space *mapping, pgoff_t *start,
 			int tag, unsigned int nr_entries,
 			struct page **entries, pgoff_t *indices);
 
diff --git a/mm/filemap.c b/mm/filemap.c
index e55100459710..3eb05c91c07a 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1731,7 +1731,7 @@ EXPORT_SYMBOL(find_get_pages_range_tag);
  * Like find_get_entries, except we only return entries which are tagged with
  * @tag.
  */
-unsigned find_get_entries_tag(struct address_space *mapping, pgoff_t start,
+unsigned find_get_entries_tag(struct address_space *mapping, pgoff_t *start,
 			int tag, unsigned int nr_entries,
 			struct page **entries, pgoff_t *indices)
 {
@@ -1744,7 +1744,7 @@ unsigned find_get_entries_tag(struct address_space *mapping, pgoff_t start,
 
 	rcu_read_lock();
 	radix_tree_for_each_tagged(slot, &mapping->page_tree,
-				   &iter, start, tag) {
+				   &iter, *start, tag) {
 		struct page *head, *page;
 repeat:
 		page = radix_tree_deref_slot(slot);
@@ -1786,6 +1786,10 @@ unsigned find_get_entries_tag(struct address_space *mapping, pgoff_t start,
 			break;
 	}
 	rcu_read_unlock();
+
+	if (ret)
+		*start = indices[ret - 1] + 1;
+
 	return ret;
 }
 EXPORT_SYMBOL(find_get_entries_tag);
-- 
2.12.3


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
