From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v4 05/23] afs: Convert
 afs_writepages_region() to use filemap_get_folios_tag()
Date: Wed,  2 Nov 2022 09:10:13 -0700
Message-ID: <20221102161031.5820-6-vishal.moola@gmail.com>
References: <20221102161031.5820-1-vishal.moola@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cluster-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667405482;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=YTHpQKfAdnCJ3tKTn7AZCAQU2IaISjA9jjwi546elPg=;
	b=EetyJnsREqbec4cZonLX3gck6iSgBWmtjoDRSV72I+rOcPgVb+lqFCuzb2Nck2pfA4GS7n
	C6/B5JgrcNCwu3Ux66e9eY29QqKq57DDckQgoM+4FsfgkJyk3PzGzfjgnkmWQq+OqqtOro
	UmJuVGP+8eRD/Jsd813HgvdCsU/7UfU=
In-Reply-To: <20221102161031.5820-1-vishal.moola@gmail.com>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/cluster-devel>, 
 <mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/cluster-devel/>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/cluster-devel>,
 <mailto:cluster-devel-request@redhat.com?subject=subscribe>
Errors-To: cluster-devel-bounces@redhat.com
Sender: "Cluster-devel" <cluster-devel-bounces@redhat.com>
Content-Type: text/plain; charset="us-ascii"; x-default="true"
To: linux-fsdevel@vger.kernel.org
Cc: linux-cifs@vger.kernel.org, David Howells <dhowells@redhat.com>, linux-nilfs@vger.kernel.org, "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mm@kvack.org, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org

Convert to use folios throughout. This function is in preparation to
remove find_get_pages_range_tag().

Also modified this function to write the whole batch one at a time,
rather than calling for a new set every single write.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Tested-by: David Howells <dhowells@redhat.com>
---
 fs/afs/write.c | 114 +++++++++++++++++++++++++------------------------
 1 file changed, 59 insertions(+), 55 deletions(-)

diff --git a/fs/afs/write.c b/fs/afs/write.c
index 9ebdd36eaf2f..c17dbd82a38c 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -699,82 +699,86 @@ static int afs_writepages_region(struct address_space *mapping,
 				 loff_t start, loff_t end, loff_t *_next)
 {
 	struct folio *folio;
-	struct page *head_page;
+	struct folio_batch fbatch;
 	ssize_t ret;
+	unsigned int i;
 	int n, skips = 0;
 
 	_enter("%llx,%llx,", start, end);
+	folio_batch_init(&fbatch);
 
 	do {
 		pgoff_t index = start / PAGE_SIZE;
 
-		n = find_get_pages_range_tag(mapping, &index, end / PAGE_SIZE,
-					     PAGECACHE_TAG_DIRTY, 1, &head_page);
+		n = filemap_get_folios_tag(mapping, &index, end / PAGE_SIZE,
+					PAGECACHE_TAG_DIRTY, &fbatch);
+
 		if (!n)
 			break;
+		for (i = 0; i < n; i++) {
+			folio = fbatch.folios[i];
+			start = folio_pos(folio); /* May regress with THPs */
 
-		folio = page_folio(head_page);
-		start = folio_pos(folio); /* May regress with THPs */
-
-		_debug("wback %lx", folio_index(folio));
+			_debug("wback %lx", folio_index(folio));
 
-		/* At this point we hold neither the i_pages lock nor the
-		 * page lock: the page may be truncated or invalidated
-		 * (changing page->mapping to NULL), or even swizzled
-		 * back from swapper_space to tmpfs file mapping
-		 */
-		if (wbc->sync_mode != WB_SYNC_NONE) {
-			ret = folio_lock_killable(folio);
-			if (ret < 0) {
-				folio_put(folio);
-				return ret;
-			}
-		} else {
-			if (!folio_trylock(folio)) {
-				folio_put(folio);
-				return 0;
+			/* At this point we hold neither the i_pages lock nor the
+			 * page lock: the page may be truncated or invalidated
+			 * (changing page->mapping to NULL), or even swizzled
+			 * back from swapper_space to tmpfs file mapping
+			 */
+			if (wbc->sync_mode != WB_SYNC_NONE) {
+				ret = folio_lock_killable(folio);
+				if (ret < 0) {
+					folio_batch_release(&fbatch);
+					return ret;
+				}
+			} else {
+				if (!folio_trylock(folio))
+					continue;
 			}
-		}
 
-		if (folio_mapping(folio) != mapping ||
-		    !folio_test_dirty(folio)) {
-			start += folio_size(folio);
-			folio_unlock(folio);
-			folio_put(folio);
-			continue;
-		}
+			if (folio->mapping != mapping ||
+			    !folio_test_dirty(folio)) {
+				start += folio_size(folio);
+				folio_unlock(folio);
+				continue;
+			}
 
-		if (folio_test_writeback(folio) ||
-		    folio_test_fscache(folio)) {
-			folio_unlock(folio);
-			if (wbc->sync_mode != WB_SYNC_NONE) {
-				folio_wait_writeback(folio);
+			if (folio_test_writeback(folio) ||
+			    folio_test_fscache(folio)) {
+				folio_unlock(folio);
+				if (wbc->sync_mode != WB_SYNC_NONE) {
+					folio_wait_writeback(folio);
 #ifdef CONFIG_AFS_FSCACHE
-				folio_wait_fscache(folio);
+					folio_wait_fscache(folio);
 #endif
-			} else {
-				start += folio_size(folio);
+				} else {
+					start += folio_size(folio);
+				}
+				if (wbc->sync_mode == WB_SYNC_NONE) {
+					if (skips >= 5 || need_resched()) {
+						*_next = start;
+						_leave(" = 0 [%llx]", *_next);
+						return 0;
+					}
+					skips++;
+				}
+				continue;
 			}
-			folio_put(folio);
-			if (wbc->sync_mode == WB_SYNC_NONE) {
-				if (skips >= 5 || need_resched())
-					break;
-				skips++;
+
+			if (!folio_clear_dirty_for_io(folio))
+				BUG();
+			ret = afs_write_back_from_locked_folio(mapping, wbc,
+					folio, start, end);
+			if (ret < 0) {
+				_leave(" = %zd", ret);
+				folio_batch_release(&fbatch);
+				return ret;
 			}
-			continue;
-		}
 
-		if (!folio_clear_dirty_for_io(folio))
-			BUG();
-		ret = afs_write_back_from_locked_folio(mapping, wbc, folio, start, end);
-		folio_put(folio);
-		if (ret < 0) {
-			_leave(" = %zd", ret);
-			return ret;
+			start += ret;
 		}
-
-		start += ret;
-
+		folio_batch_release(&fbatch);
 		cond_resched();
 	} while (wbc->nr_to_write > 0);
 
-- 
2.38.1

