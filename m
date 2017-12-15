From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v5 74/78] xfs: Convert mru cache to XArray
Date: Fri, 15 Dec 2017 14:04:46 -0800
Message-ID: <20171215220450.7899-75-willy@infradead.org>
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
 bh=pQoPAZH+LdTNlYHSvc0jw9KpY7VbWvr8hV9iL3hlNZg=; b=g/4io9esFennM20jnsinHCxKHa
 X9Im1bS60DaD6ksSyv9INH4ect1RP7vkfFOzoXCHNy/UdempPv9SFGXciLaQReYE+ibY78UJq8wu0
 eg0WWDMOgtotu4ulIcEP0iT3slw0VUlmretYRSp+xnR8WolWrEKHd5atog1C2ZnuYSSY=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=pQoPAZH+LdTNlYHSvc0jw9KpY7VbWvr8hV9iL3hlNZg=; b=hTabGqv99vupC3uM6xwPoY0l3u
 gC6c261ZN3Y3EruP3sZ94JwAlcaRP8ySGDzYdMltGCshpx+18bPH89hIMRE69Z/e9uVKkQkhUom7V
 SX7btfH8b4SvxmCjNv6gecnN5P79x3YULtBZ+a+YZ442kCcbP9IAZpWO6Fe+Q5TFMgE8=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=pQoPAZH+LdTNlYHSvc0jw9KpY7VbWvr8hV9iL3hlNZg=; b=eW4uJfOYlv0iSRk5Uj+lql5bB
 +k/SWZdnWAAjSPlc8A8KjPKmxH5G+CTdlonJOkQp6hviwIfPQ62PVRjeSx268FeQ9jSHK950AZj8X
 /BnvO2dqdDw5QXXy0HL0V3NtpREleEOOKlyKOqhE/MQ5gxe5fHSle7edJdY/0/TcVOvhx824N3Ztr
 udOJhCUkbMhUDl1cXZ6dvlh5LevHVgVmMKPVFQWxZkorzKrxTAjFF6u6m3Nw2LBR3BK6qK1lAqJCK
 FEKLeu7Ox20rF+55otvsM2jYLgSOlKMd6hOgQSWYKKK6aB92JuRNjP7G1/Hwp24cOIOu4VPO4HWag
 n5HT6MKmQ==;
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

This eliminates a call to radix_tree_preload().

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/xfs/xfs_mru_cache.c | 72 +++++++++++++++++++++++---------------------------
 1 file changed, 33 insertions(+), 39 deletions(-)

diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
index f8a674d7f092..2179bede5396 100644
--- a/fs/xfs/xfs_mru_cache.c
+++ b/fs/xfs/xfs_mru_cache.c
@@ -101,10 +101,9 @@
  * an infinite loop in the code.
  */
 struct xfs_mru_cache {
-	struct radix_tree_root	store;     /* Core storage data structure.  */
+	struct xarray		store;     /* Core storage data structure.  */
 	struct list_head	*lists;    /* Array of lists, one per grp.  */
 	struct list_head	reap_list; /* Elements overdue for reaping. */
-	spinlock_t		lock;      /* Lock to protect this struct.  */
 	unsigned int		grp_count; /* Number of discrete groups.    */
 	unsigned int		grp_time;  /* Time period spanned by grps.  */
 	unsigned int		lru_grp;   /* Group containing time zero.   */
@@ -232,22 +231,21 @@ _xfs_mru_cache_list_insert(
  * data store, removing it from the reap list, calling the client's free
  * function and deleting the element from the element zone.
  *
- * We get called holding the mru->lock, which we drop and then reacquire.
- * Sparse need special help with this to tell it we know what we are doing.
+ * We get called holding the mru->store lock, which we drop and then reacquire.
+ * Sparse needs special help with this to tell it we know what we are doing.
  */
 STATIC void
 _xfs_mru_cache_clear_reap_list(
 	struct xfs_mru_cache	*mru)
-		__releases(mru->lock) __acquires(mru->lock)
+		__releases(mru->store) __acquires(mru->store)
 {
 	struct xfs_mru_cache_elem *elem, *next;
 	struct list_head	tmp;
 
 	INIT_LIST_HEAD(&tmp);
 	list_for_each_entry_safe(elem, next, &mru->reap_list, list_node) {
-
 		/* Remove the element from the data store. */
-		radix_tree_delete(&mru->store, elem->key);
+		__xa_erase(&mru->store, elem->key);
 
 		/*
 		 * remove to temp list so it can be freed without
@@ -255,14 +253,14 @@ _xfs_mru_cache_clear_reap_list(
 		 */
 		list_move(&elem->list_node, &tmp);
 	}
-	spin_unlock(&mru->lock);
+	xa_unlock(&mru->store);
 
 	list_for_each_entry_safe(elem, next, &tmp, list_node) {
 		list_del_init(&elem->list_node);
 		mru->free_func(elem);
 	}
 
-	spin_lock(&mru->lock);
+	xa_lock(&mru->store);
 }
 
 /*
@@ -284,7 +282,7 @@ _xfs_mru_cache_reap(
 	if (!mru || !mru->lists)
 		return;
 
-	spin_lock(&mru->lock);
+	xa_lock(&mru->store);
 	next = _xfs_mru_cache_migrate(mru, jiffies);
 	_xfs_mru_cache_clear_reap_list(mru);
 
@@ -298,7 +296,7 @@ _xfs_mru_cache_reap(
 		queue_delayed_work(xfs_mru_reap_wq, &mru->work, next);
 	}
 
-	spin_unlock(&mru->lock);
+	xa_unlock(&mru->store);
 }
 
 int
@@ -358,13 +356,8 @@ xfs_mru_cache_create(
 	for (grp = 0; grp < mru->grp_count; grp++)
 		INIT_LIST_HEAD(mru->lists + grp);
 
-	/*
-	 * We use GFP_KERNEL radix tree preload and do inserts under a
-	 * spinlock so GFP_ATOMIC is appropriate for the radix tree itself.
-	 */
-	INIT_RADIX_TREE(&mru->store, GFP_ATOMIC);
+	xa_init(&mru->store);
 	INIT_LIST_HEAD(&mru->reap_list);
-	spin_lock_init(&mru->lock);
 	INIT_DELAYED_WORK(&mru->work, _xfs_mru_cache_reap);
 
 	mru->grp_time  = grp_time;
@@ -394,17 +387,17 @@ xfs_mru_cache_flush(
 	if (!mru || !mru->lists)
 		return;
 
-	spin_lock(&mru->lock);
+	xa_lock(&mru->store);
 	if (mru->queued) {
-		spin_unlock(&mru->lock);
+		xa_unlock(&mru->store);
 		cancel_delayed_work_sync(&mru->work);
-		spin_lock(&mru->lock);
+		xa_lock(&mru->store);
 	}
 
 	_xfs_mru_cache_migrate(mru, jiffies + mru->grp_count * mru->grp_time);
 	_xfs_mru_cache_clear_reap_list(mru);
 
-	spin_unlock(&mru->lock);
+	xa_unlock(&mru->store);
 }
 
 void
@@ -431,24 +424,24 @@ xfs_mru_cache_insert(
 	unsigned long		key,
 	struct xfs_mru_cache_elem *elem)
 {
+	XA_STATE(xas, &mru->store, key);
 	int			error;
 
 	ASSERT(mru && mru->lists);
 	if (!mru || !mru->lists)
 		return -EINVAL;
 
-	if (radix_tree_preload(GFP_NOFS))
-		return -ENOMEM;
-
 	INIT_LIST_HEAD(&elem->list_node);
 	elem->key = key;
 
-	spin_lock(&mru->lock);
-	error = radix_tree_insert(&mru->store, key, elem);
-	radix_tree_preload_end();
-	if (!error)
-		_xfs_mru_cache_list_insert(mru, elem);
-	spin_unlock(&mru->lock);
+	do {
+		xas_lock(&xas);
+		xas_store(&xas, elem);
+		error = xas_error(&xas);
+		if (!error)
+			_xfs_mru_cache_list_insert(mru, elem);
+		xas_unlock(&xas);
+	} while (xas_nomem(&xas, GFP_NOFS));
 
 	return error;
 }
@@ -470,11 +463,11 @@ xfs_mru_cache_remove(
 	if (!mru || !mru->lists)
 		return NULL;
 
-	spin_lock(&mru->lock);
-	elem = radix_tree_delete(&mru->store, key);
+	xa_lock(&mru->store);
+	elem = __xa_erase(&mru->store, key);
 	if (elem)
 		list_del(&elem->list_node);
-	spin_unlock(&mru->lock);
+	xa_unlock(&mru->store);
 
 	return elem;
 }
@@ -520,20 +513,21 @@ xfs_mru_cache_lookup(
 	struct xfs_mru_cache	*mru,
 	unsigned long		key)
 {
+	XA_STATE(xas, &mru->store, key);
 	struct xfs_mru_cache_elem *elem;
 
 	ASSERT(mru && mru->lists);
 	if (!mru || !mru->lists)
 		return NULL;
 
-	spin_lock(&mru->lock);
-	elem = radix_tree_lookup(&mru->store, key);
+	xas_lock(&xas);
+	elem = xas_load(&xas);
 	if (elem) {
 		list_del(&elem->list_node);
 		_xfs_mru_cache_list_insert(mru, elem);
-		__release(mru_lock); /* help sparse not be stupid */
+		__release(&xas); /* help sparse not be stupid */
 	} else
-		spin_unlock(&mru->lock);
+		xas_unlock(&xas);
 
 	return elem;
 }
@@ -546,7 +540,7 @@ xfs_mru_cache_lookup(
 void
 xfs_mru_cache_done(
 	struct xfs_mru_cache	*mru)
-		__releases(mru->lock)
+		__releases(mru->store)
 {
-	spin_unlock(&mru->lock);
+	xa_unlock(&mru->store);
 }
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
