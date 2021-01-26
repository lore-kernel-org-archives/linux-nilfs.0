From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/17] block: split bio_kmalloc from
	bio_alloc_bioset
Date: Tue, 26 Jan 2021 15:52:34 +0100
Message-ID: <20210126145247.1964410-5-hch@lst.de>
References: <20210126145247.1964410-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20210126145247.1964410-1-hch@lst.de>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>
Cc: Mike Snitzer <snitzer@redhat.com>, David Sterba <dsterba@suse.com>, dm-devel@redhat.com, Naohiro Aota <naohiro.aota@wdc.com>, linux-nilfs@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, Chao Yu <chao@kernel.org>, linux-nfs@vger.kernel.org, Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org, drbd-dev@tron.linbit.com, Jaegeuk Kim <jaegeuk@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, linux-block@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Philipp Reisner <philipp.reisner@linbit.com>, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, Lars Ellenberg <lars.ellenberg@linbit.com>, linux-btrfs@vger.kernel.org

bio_kmalloc shares almost no logic with the bio_set based fast path
in bio_alloc_bioset.  Split it into an entirely separate implementation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c         | 167 ++++++++++++++++++++++----------------------
 include/linux/bio.h |   6 +-
 2 files changed, 86 insertions(+), 87 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index dfd7740a32300a..d4375619348c52 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -396,123 +396,101 @@ static void punt_bios_to_rescuer(struct bio_set *bs)
  * @nr_iovecs:	number of iovecs to pre-allocate
  * @bs:		the bio_set to allocate from.
  *
- * Description:
- *   If @bs is NULL, uses kmalloc() to allocate the bio; else the allocation is
- *   backed by the @bs's mempool.
+ * Allocate a bio from the mempools in @bs.
  *
- *   When @bs is not NULL, if %__GFP_DIRECT_RECLAIM is set then bio_alloc will
- *   always be able to allocate a bio. This is due to the mempool guarantees.
- *   To make this work, callers must never allocate more than 1 bio at a time
- *   from this pool. Callers that need to allocate more than 1 bio must always
- *   submit the previously allocated bio for IO before attempting to allocate
- *   a new one. Failure to do so can cause deadlocks under memory pressure.
+ * If %__GFP_DIRECT_RECLAIM is set then bio_alloc will always be able to
+ * allocate a bio.  This is due to the mempool guarantees.  To make this work,
+ * callers must never allocate more than 1 bio at a time from the general pool.
+ * Callers that need to allocate more than 1 bio must always submit the
+ * previously allocated bio for IO before attempting to allocate a new one.
+ * Failure to do so can cause deadlocks under memory pressure.
  *
- *   Note that when running under submit_bio_noacct() (i.e. any block
- *   driver), bios are not submitted until after you return - see the code in
- *   submit_bio_noacct() that converts recursion into iteration, to prevent
- *   stack overflows.
+ * Note that when running under submit_bio_noacct() (i.e. any block driver),
+ * bios are not submitted until after you return - see the code in
+ * submit_bio_noacct() that converts recursion into iteration, to prevent
+ * stack overflows.
  *
- *   This would normally mean allocating multiple bios under
- *   submit_bio_noacct() would be susceptible to deadlocks, but we have
- *   deadlock avoidance code that resubmits any blocked bios from a rescuer
- *   thread.
+ * This would normally mean allocating multiple bios under submit_bio_noacct()
+ * would be susceptible to deadlocks, but we have
+ * deadlock avoidance code that resubmits any blocked bios from a rescuer
+ * thread.
  *
- *   However, we do not guarantee forward progress for allocations from other
- *   mempools. Doing multiple allocations from the same mempool under
- *   submit_bio_noacct() should be avoided - instead, use bio_set's front_pad
- *   for per bio allocations.
+ * However, we do not guarantee forward progress for allocations from other
+ * mempools. Doing multiple allocations from the same mempool under
+ * submit_bio_noacct() should be avoided - instead, use bio_set's front_pad
+ * for per bio allocations.
  *
- *   RETURNS:
- *   Pointer to new bio on success, NULL on failure.
+ * Returns: Pointer to new bio on success, NULL on failure.
  */
 struct bio *bio_alloc_bioset(gfp_t gfp_mask, unsigned int nr_iovecs,
 			     struct bio_set *bs)
 {
 	gfp_t saved_gfp = gfp_mask;
-	unsigned front_pad;
-	unsigned inline_vecs;
-	struct bio_vec *bvl = NULL;
 	struct bio *bio;
 	void *p;
 
-	if (!bs) {
-		if (nr_iovecs > UIO_MAXIOV)
-			return NULL;
-
-		p = kmalloc(struct_size(bio, bi_inline_vecs, nr_iovecs), gfp_mask);
-		front_pad = 0;
-		inline_vecs = nr_iovecs;
-	} else {
-		/* should not use nobvec bioset for nr_iovecs > 0 */
-		if (WARN_ON_ONCE(!mempool_initialized(&bs->bvec_pool) &&
-				 nr_iovecs > 0))
-			return NULL;
-		/*
-		 * submit_bio_noacct() converts recursion to iteration; this
-		 * means if we're running beneath it, any bios we allocate and
-		 * submit will not be submitted (and thus freed) until after we
-		 * return.
-		 *
-		 * This exposes us to a potential deadlock if we allocate
-		 * multiple bios from the same bio_set() while running
-		 * underneath submit_bio_noacct(). If we were to allocate
-		 * multiple bios (say a stacking block driver that was splitting
-		 * bios), we would deadlock if we exhausted the mempool's
-		 * reserve.
-		 *
-		 * We solve this, and guarantee forward progress, with a rescuer
-		 * workqueue per bio_set. If we go to allocate and there are
-		 * bios on current->bio_list, we first try the allocation
-		 * without __GFP_DIRECT_RECLAIM; if that fails, we punt those
-		 * bios we would be blocking to the rescuer workqueue before
-		 * we retry with the original gfp_flags.
-		 */
-
-		if (current->bio_list &&
-		    (!bio_list_empty(&current->bio_list[0]) ||
-		     !bio_list_empty(&current->bio_list[1])) &&
-		    bs->rescue_workqueue)
-			gfp_mask &= ~__GFP_DIRECT_RECLAIM;
+	/* should not use nobvec bioset for nr_iovecs > 0 */
+	if (WARN_ON_ONCE(!mempool_initialized(&bs->bvec_pool) && nr_iovecs > 0))
+		return NULL;
 
+	/*
+	 * submit_bio_noacct() converts recursion to iteration; this means if
+	 * we're running beneath it, any bios we allocate and submit will not be
+	 * submitted (and thus freed) until after we return.
+	 *
+	 * This exposes us to a potential deadlock if we allocate multiple bios
+	 * from the same bio_set() while running underneath submit_bio_noacct().
+	 * If we were to allocate multiple bios (say a stacking block driver
+	 * that was splitting bios), we would deadlock if we exhausted the
+	 * mempool's reserve.
+	 *
+	 * We solve this, and guarantee forward progress, with a rescuer
+	 * workqueue per bio_set. If we go to allocate and there are bios on
+	 * current->bio_list, we first try the allocation without
+	 * __GFP_DIRECT_RECLAIM; if that fails, we punt those bios we would be
+	 * blocking to the rescuer workqueue before we retry with the original
+	 * gfp_flags.
+	 */
+	if (current->bio_list &&
+	    (!bio_list_empty(&current->bio_list[0]) ||
+	     !bio_list_empty(&current->bio_list[1])) &&
+	    bs->rescue_workqueue)
+		gfp_mask &= ~__GFP_DIRECT_RECLAIM;
+
+	p = mempool_alloc(&bs->bio_pool, gfp_mask);
+	if (!p && gfp_mask != saved_gfp) {
+		punt_bios_to_rescuer(bs);
+		gfp_mask = saved_gfp;
 		p = mempool_alloc(&bs->bio_pool, gfp_mask);
-		if (!p && gfp_mask != saved_gfp) {
-			punt_bios_to_rescuer(bs);
-			gfp_mask = saved_gfp;
-			p = mempool_alloc(&bs->bio_pool, gfp_mask);
-		}
-
-		front_pad = bs->front_pad;
-		inline_vecs = BIO_INLINE_VECS;
 	}
-
 	if (unlikely(!p))
 		return NULL;
 
-	bio = p + front_pad;
-	bio_init(bio, NULL, 0);
-
-	if (nr_iovecs > inline_vecs) {
+	bio = p + bs->front_pad;
+	if (nr_iovecs > BIO_INLINE_VECS) {
 		unsigned long idx = 0;
+		struct bio_vec *bvl = NULL;
 
 		bvl = bvec_alloc(gfp_mask, nr_iovecs, &idx, &bs->bvec_pool);
 		if (!bvl && gfp_mask != saved_gfp) {
 			punt_bios_to_rescuer(bs);
 			gfp_mask = saved_gfp;
-			bvl = bvec_alloc(gfp_mask, nr_iovecs, &idx, &bs->bvec_pool);
+			bvl = bvec_alloc(gfp_mask, nr_iovecs, &idx,
+					 &bs->bvec_pool);
 		}
 
 		if (unlikely(!bvl))
 			goto err_free;
 
 		bio->bi_flags |= idx << BVEC_POOL_OFFSET;
-		bio->bi_max_vecs = bvec_nr_vecs(idx);
+		bio_init(bio, bvl, bvec_nr_vecs(idx));
 	} else if (nr_iovecs) {
-		bvl = bio->bi_inline_vecs;
-		bio->bi_max_vecs = inline_vecs;
+		bio_init(bio, bio->bi_inline_vecs, BIO_INLINE_VECS);
+	} else {
+		bio_init(bio, NULL, 0);
 	}
 
 	bio->bi_pool = bs;
-	bio->bi_io_vec = bvl;
 	return bio;
 
 err_free:
@@ -521,6 +499,31 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, unsigned int nr_iovecs,
 }
 EXPORT_SYMBOL(bio_alloc_bioset);
 
+/**
+ * bio_kmalloc - kmalloc a bio for I/O
+ * @gfp_mask:   the GFP_* mask given to the slab allocator
+ * @nr_iovecs:	number of iovecs to pre-allocate
+ *
+ * Use kmalloc to allocate and initialize a bio.
+ *
+ * Returns: Pointer to new bio on success, NULL on failure.
+ */
+struct bio *bio_kmalloc(gfp_t gfp_mask, unsigned int nr_iovecs)
+{
+	struct bio *bio;
+
+	if (nr_iovecs > UIO_MAXIOV)
+		return NULL;
+
+	bio = kmalloc(struct_size(bio, bi_inline_vecs, nr_iovecs), gfp_mask);
+	if (unlikely(!bio))
+		return NULL;
+	bio_init(bio, nr_iovecs ? bio->bi_inline_vecs : NULL, nr_iovecs);
+	bio->bi_pool = NULL;
+	return bio;
+}
+EXPORT_SYMBOL(bio_kmalloc);
+
 void zero_fill_bio_iter(struct bio *bio, struct bvec_iter start)
 {
 	unsigned long flags;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 676870b2c88d80..c74857cf12528c 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -408,6 +408,7 @@ extern int biovec_init_pool(mempool_t *pool, int pool_entries);
 extern int bioset_init_from_src(struct bio_set *bs, struct bio_set *src);
 
 extern struct bio *bio_alloc_bioset(gfp_t, unsigned int, struct bio_set *);
+struct bio *bio_kmalloc(gfp_t gfp_mask, unsigned int nr_iovecs);
 extern void bio_put(struct bio *);
 
 extern void __bio_clone_fast(struct bio *, struct bio *);
@@ -420,11 +421,6 @@ static inline struct bio *bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs)
 	return bio_alloc_bioset(gfp_mask, nr_iovecs, &fs_bio_set);
 }
 
-static inline struct bio *bio_kmalloc(gfp_t gfp_mask, unsigned int nr_iovecs)
-{
-	return bio_alloc_bioset(gfp_mask, nr_iovecs, NULL);
-}
-
 extern blk_qc_t submit_bio(struct bio *);
 
 extern void bio_endio(struct bio *);
-- 
2.29.2
