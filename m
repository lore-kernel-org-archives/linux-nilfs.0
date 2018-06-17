From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v14 63/74] dax: Hash on XArray instead of mapping
Date: Sat, 16 Jun 2018 19:00:41 -0700
Message-ID: <20180617020052.4759-64-willy@infradead.org>
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
 bh=48LpEvkQqhIIHZka3Rt488wqdWU55j8+vgW3hpTgoEg=; b=I5lIQhEf/hTaW1Fb6WCvoSbO6X
 O5MMV6z/gx8YcqSqwg+yGygpLsStPnxjKJ/ls0tEoPYw4vBXV15xKGZi0I49ym/md3B9kz+k38X6G
 1qf4HhjIqk1SNWQm8crvx7UgjMm23+OEGQNoHdt7IpPj9uQhQKj68xO+kECXJnpKOLik=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=48LpEvkQqhIIHZka3Rt488wqdWU55j8+vgW3hpTgoEg=; b=Rw5KE0Fzw8qH10Pjl7hFiSFMXM
 UuhkhJe4HAVz2c5dwuKVV34e/YVmE19ehzkUoiRzlC/3p8O5+htZmS5xi3mL4wCZ8wqgrp0ytiFgG
 Wa87WWz1dL2AaABMYzhAvkCNrKtZoPOCX/cAhRAiLIr/ELP0luzZfyiYaRr4j9R6cta4=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=48LpEvkQqhIIHZka3Rt488wqdWU55j8+vgW3hpTgoEg=; b=uR/oSlgB6PfCxT7IbhiF0Y9iy
 zU1Tleybk/DH+sWNNJM8r5aGUZy1X1kvVypZw7rqrNx96384la3H+Qk3+eQrbwE+wUzs84/laRW9l
 yZyEWePrpAzv0SSoBAmzi0Zs8RjNPZiO0LJuumgkVXpAFPNGvfJzeUDmcwuJ3DLJyJTSrkXEB9HC5
 yqJviFQkqVLs1hXYDb+UVQnyDvTSxmtzAuUKVM6Au23QKJPvyV9eo3LjZuzZ0909r5O0EJrHLrhLz
 QpScWxPTDVYo1UAPq51a4/ezse0GZhL7guOEa+dbB/lUI4qUplt597CoJA7JlUQpo9VDm2GDgumot
 hR1iOOl9w==;
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

Since the XArray is embedded in the struct address_space, its address
contains exactly as much entropy as the address of the mapping.  This
patch is purely preparatory for later patches which will simplify the
wait/wake interfaces.

Signed-off-by: Matthew Wilcox <willy@infradead.org>
---
 fs/dax.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 157762fe2ba1..b7f54e386da8 100644
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
@@ -423,7 +424,8 @@ struct page *dax_lock_page(unsigned long pfn)
 			break;
 		}
 
-		wq = dax_entry_waitqueue(mapping, index, entry, &ewait.key);
+		wq = dax_entry_waitqueue(&mapping->i_pages, index, entry,
+				&ewait.key);
 		prepare_to_wait_exclusive(wq, &ewait.wait,
 				TASK_UNINTERRUPTIBLE);
 		xa_unlock_irq(&mapping->i_pages);
@@ -556,8 +558,8 @@ static void *grab_mapping_entry(struct address_space *mapping, pgoff_t index,
 			dax_disassociate_entry(entry, mapping, false);
 			radix_tree_delete(&mapping->i_pages, index);
 			mapping->nrexceptional--;
-			dax_wake_mapping_entry_waiter(mapping, index, entry,
-					true);
+			dax_wake_mapping_entry_waiter(&mapping->i_pages,
+					index, entry, true);
 		}
 
 		entry = dax_make_locked(0, size_flag | DAX_EMPTY);
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
