From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v11 54/63] dax: Hash on XArray instead of mapping
Date: Sat, 14 Apr 2018 07:13:07 -0700
Message-ID: <20180414141316.7167-55-willy@infradead.org>
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
 bh=h5o/kccxQztvFvzALyRXJP+yHPrheSEUnj6Pp1janoA=; b=K0dx4269pHFKrMJMYnqPt2xP1z
 HdsG/1Onmo9UY/M3vE25tMpVaCreT/tqdqK7OUOGmKlyc5TFmu4XsiqfU8ZHp4psc7t1EwsD7mMv2
 NSx/wAZS6lb8d/Tzfzzr67kfdUKvvYqSz3GlpmcQ4okjBu3K12ieFHSEcPHceiMs7j5c=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=h5o/kccxQztvFvzALyRXJP+yHPrheSEUnj6Pp1janoA=; b=dwLJc7Zgw0L6vwqjjlZMMYTetn
 8G6nY7KXleb71x54d1q2lYwYT8xJNOT4vEltaHnOBf4ugaUzijf/RCYprpSYlKP/kq2gfknOgQwMH
 teJVDqMLVpLrgj0aaMvibjWzsn7uoJjhNHBU9qOnDdaunUfMMQEeQSk+2jsCV7dw3mvA=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=h5o/kccxQztvFvzALyRXJP+yHPrheSEUnj6Pp1janoA=; b=iHBNJsqjvZV1TVfexta7vq1rH
 64SjiC0iVGD0DbfHpFrlRG4sn7tsjYl0PhJhcuUu6QXJZS30YKslYU5X0kGCpPFOEfEAtSrr+omyU
 cPzjS/PwHcdmRZFCEjGyL/CW5nQMGNZQm6bcqdXjPOpDWYeeDUAXEkiXPqV3JF8Dn3aNtWYXw1Njl
 04kaFFXd3nvSgOd6+fTMa71tnq01tHo3ZWmmrQpJyoDREMwrvmKORVqpKQ7gRT69pHssh7wnn8pij
 sSvaERCJC2HA4fLTYTnQtoVTLpq8vzHkpnYbYh5kuuTYUXC6kqswGwdlUk8GiRqjOh5IeQQT+Qcex
 2BpurgDPQ==;
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

Since the XArray is embedded in the struct address_space, this contains
exactly as much entropy as the address of the mapping.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/dax.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index f2d1ac92466d..af669ca5020a 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -116,7 +116,7 @@ static int dax_is_empty_entry(void *entry)
  * DAX page cache entry locking
  */
 struct exceptional_entry_key {
-	struct address_space *mapping;
+	struct xarray *xa;
 	pgoff_t entry_start;
 };
 
@@ -125,7 +125,7 @@ struct wait_exceptional_entry_queue {
 	struct exceptional_entry_key key;
 };
 
-static wait_queue_head_t *dax_entry_waitqueue(struct address_space *mapping,
+static wait_queue_head_t *dax_entry_waitqueue(struct xarray *xa,
 		pgoff_t index, void *entry, struct exceptional_entry_key *key)
 {
 	unsigned long hash;
@@ -138,21 +138,21 @@ static wait_queue_head_t *dax_entry_waitqueue(struct address_space *mapping,
 	if (dax_is_pmd_entry(entry))
 		index &= ~PG_PMD_COLOUR;
 
-	key->mapping = mapping;
+	key->xa = xa;
 	key->entry_start = index;
 
-	hash = hash_long((unsigned long)mapping ^ index, DAX_WAIT_TABLE_BITS);
+	hash = hash_long((unsigned long)xa ^ index, DAX_WAIT_TABLE_BITS);
 	return wait_table + hash;
 }
 
-static int wake_exceptional_entry_func(wait_queue_entry_t *wait, unsigned int mode,
-				       int sync, void *keyp)
+static int wake_exceptional_entry_func(wait_queue_entry_t *wait,
+		unsigned int mode, int sync, void *keyp)
 {
 	struct exceptional_entry_key *key = keyp;
 	struct wait_exceptional_entry_queue *ewait =
 		container_of(wait, struct wait_exceptional_entry_queue, wait);
 
-	if (key->mapping != ewait->key.mapping ||
+	if (key->xa != ewait->key.xa ||
 	    key->entry_start != ewait->key.entry_start)
 		return 0;
 	return autoremove_wake_function(wait, mode, sync, NULL);
@@ -163,13 +163,13 @@ static int wake_exceptional_entry_func(wait_queue_entry_t *wait, unsigned int mo
  * The important information it's conveying is whether the entry at
  * this index used to be a PMD entry.
  */
-static void dax_wake_mapping_entry_waiter(struct address_space *mapping,
+static void dax_wake_mapping_entry_waiter(struct xarray *xa,
 		pgoff_t index, void *entry, bool wake_all)
 {
 	struct exceptional_entry_key key;
 	wait_queue_head_t *wq;
 
-	wq = dax_entry_waitqueue(mapping, index, entry, &key);
+	wq = dax_entry_waitqueue(xa, index, entry, &key);
 
 	/*
 	 * Checking for locked entry and prepare_to_wait_exclusive() happens
@@ -246,7 +246,8 @@ static void *get_unlocked_mapping_entry(struct address_space *mapping,
 			return entry;
 		}
 
-		wq = dax_entry_waitqueue(mapping, index, entry, &ewait.key);
+		wq = dax_entry_waitqueue(&mapping->i_pages, index, entry,
+				&ewait.key);
 		prepare_to_wait_exclusive(wq, &ewait.wait,
 					  TASK_UNINTERRUPTIBLE);
 		xa_unlock_irq(&mapping->i_pages);
@@ -270,7 +271,7 @@ static void dax_unlock_mapping_entry(struct address_space *mapping,
 	}
 	unlock_slot(mapping, slot);
 	xa_unlock_irq(&mapping->i_pages);
-	dax_wake_mapping_entry_waiter(mapping, index, entry, false);
+	dax_wake_mapping_entry_waiter(&mapping->i_pages, index, entry, false);
 }
 
 static void put_locked_mapping_entry(struct address_space *mapping,
@@ -290,7 +291,7 @@ static void put_unlocked_mapping_entry(struct address_space *mapping,
 		return;
 
 	/* We have to wake up next waiter for the page cache entry lock */
-	dax_wake_mapping_entry_waiter(mapping, index, entry, false);
+	dax_wake_mapping_entry_waiter(&mapping->i_pages, index, entry, false);
 }
 
 static unsigned long dax_entry_size(void *entry)
@@ -458,8 +459,8 @@ static void *grab_mapping_entry(struct address_space *mapping, pgoff_t index,
 			dax_disassociate_entry(entry, mapping, false);
 			radix_tree_delete(&mapping->i_pages, index);
 			mapping->nrexceptional--;
-			dax_wake_mapping_entry_waiter(mapping, index, entry,
-					true);
+			dax_wake_mapping_entry_waiter(&mapping->i_pages,
+					index, entry, true);
 		}
 
 		entry = dax_mk_locked(0, size_flag | DAX_EMPTY);
-- 
2.17.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
