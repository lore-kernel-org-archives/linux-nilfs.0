From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 4/7] shmem: remove shmem_get_partial_folio
Date: Sun, 19 Mar 2023 22:19:21 -0700 (PDT)
Message-ID: <9d1aaa4-1337-fb81-6f37-74ebc96f9ef@google.com>
References: <20230307143410.28031-1-hch@lst.de> <20230307143410.28031-5-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-ext4-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679289575;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=76ELY9xLQn4IJW/KKPmxMLn2xf0xOodzC5hbi9tbLEo=;
        b=VIOl8mEl+TRm12B9vr0x3MI5qg8HBc3Nvf52ADz2JTRE/pUljORPAwc9zGnOtL4n1q
         vY+fhSDADSjmuqWodTBtrH1DhVZeZ2kit132/OUM0iOL20vYKI667wtJE/oms15hgrXf
         dC6EpWmifHlAfRjrxg6QBYvE8ZqZwVq1TYZgOrdvLuc5N4pedfxUdPHf1feziMopEW0b
         SpjoYiMhcD12XJr9g0F0C6O1oDAreASe3as52lgZsY5Jt+89aEdG66BxLERBD5SirCqV
         FcaIo7as2beEAwrD58d10DhNG6Sgy5ZDddUiykyc3xGAhVNWJgAvdw9XEon+S0h4faek
         qWbA==
In-Reply-To: <20230307143410.28031-5-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, cluster-devel@redhat.com, linux-mm@kvack.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nilfs@vger.kernel.org

On Tue, 7 Mar 2023, Christoph Hellwig wrote:

> Add a new SGP_FIND mode for shmem_get_partial_folio that works like
> SGP_READ, but does not check i_size.  Use that instead of open coding
> the page cache lookup in shmem_get_partial_folio.  Note that this is
> a behavior change in that it reads in swap cache entries for offsets
> outside i_size, possibly causing a little bit of extra work.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/linux/shmem_fs.h |  1 +
>  mm/shmem.c               | 46 ++++++++++++----------------------------
>  2 files changed, 15 insertions(+), 32 deletions(-)

I thought this was fine at first, and of course it's good for all the
usual cases; but not for shmem_get_partial_folio()'s awkward cases.

Two issues with it.

One, as you highlight above, the possibility of reading more swap
unnecessarily.  I do not mind if partial truncation entails reading
a little unnecessary swap; but I don't like the common case of
truncation to 0 to entail that; even less eviction; even less
unmounting, when eviction of all risks reading lots of swap.
The old code behaved well at i_size 0, the new code not so much.

Two, truncating a large folio is expected to trim that folio down
to the smaller sizei (if splitting allows); but SGP_FIND was coded
too much like SGP_READ, in reporting fallocated (!uptodate) folios
as NULL, unlike before.  Then the following loop of shmem_undo_range()
removed that whole folio - removing pages "promised" to the file by
the earlier fallocate.  Not as seriously bad as deleting data would be,
and not very likely to be noticed, but still not right.

Replacing shmem_get_partial_folio() by SGP_FIND was a good direction
to try, but it hasn't worked out.  I tried to get SGPs to work right
for it before, when shmem_get_partial_page() was introduced; but I
did not manage to do so.  I think we have to go back to how this was.

Andrew, please replace Christoph's "shmem: remove shmem_get_partial_folio"
in mm-unstable by this patch below, which achieves the same object
(eliminating FGP_ENTRY) while keeping closer to the old mechanism.

[PATCH] shmem: shmem_get_partial_folio use filemap_get_entry

To avoid use of the FGP_ENTRY flag, adapt shmem_get_partial_folio() to
use filemap_get_entry() and folio_lock() instead of __filemap_get_folio().
Update "page" in the comments there to "folio".

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 mm/shmem.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -886,14 +886,21 @@ static struct folio *shmem_get_partial_folio(struct inode *inode, pgoff_t index)
 
 	/*
 	 * At first avoid shmem_get_folio(,,,SGP_READ): that fails
-	 * beyond i_size, and reports fallocated pages as holes.
+	 * beyond i_size, and reports fallocated folios as holes.
 	 */
-	folio = __filemap_get_folio(inode->i_mapping, index,
-					FGP_ENTRY | FGP_LOCK, 0);
-	if (!xa_is_value(folio))
+	folio = filemap_get_entry(inode->i_mapping, index);
+	if (!folio)
 		return folio;
+	if (!xa_is_value(folio)) {
+		folio_lock(folio);
+		if (folio->mapping == inode->i_mapping)
+			return folio;
+		/* The folio has been swapped out */
+		folio_unlock(folio);
+		folio_put(folio);
+	}
 	/*
-	 * But read a page back from swap if any of it is within i_size
+	 * But read a folio back from swap if any of it is within i_size
 	 * (although in some cases this is just a waste of time).
 	 */
 	folio = NULL;
