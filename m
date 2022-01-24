From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/19] fs: remove mpage_alloc
Date: Mon, 24 Jan 2022 10:10:49 +0100
Message-ID: <20220124091107.642561-2-hch@lst.de>
References: <20220124091107.642561-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=k9xFroBmk3qsQBF01SQtJtA/UuQWo3OoxDB4XEu/hlU=; b=eOrLkdjf0mmS8f/CtvAZiPo6uX
        G/VVNiKCFucEha0OyK/bZHsYEWLQ8xt7Bm9GixZ3tXgynPAQ2lxe/OElmzLeezeL0/RwDpkgmYeKY
        sz0jxyE8u/ZmbzvVPqeFTOOgFV5BttmczKSHZSHX083YPyiVCbcYIJUXbwklJ27Jxtkj9NACszfwn
        KyrdR4b8FWyP3Y2PI8CYfXr543bSterKv2k1N8EN6qQbnNeTnXRNQZ1IY/xSrJDRAih0f3uqmi1Wh
        Xl0xPQ3rDdce0WxMXn872laxukK7ywf9uRa3awgU+FjYW4wAryVnmN6XEnrDqL3ko+YEed4hUg3uX
        3w4WP7yw==;
In-Reply-To: <20220124091107.642561-1-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, Mike Snitzer <snitzer@redhat.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Andrew Morton <akpm@linux-foundation.org>, "Md . Haris Iqbal " <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.co>, Philipp Reisner <philipp.reisner@linbit.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev, xen-devel@lists.xenproject.org, drbd-dev@lists.linbit.com

open code mpage_alloc in it's two callers and simplify the results
because of the context:

 - __mpage_writepage always passes GFP_NOFS and can thus always sleep and
    will never get a NULL return from bio_alloc at all.
 - do_mpage_readpage can only get a non-sleeping context for readahead
   which never sets PF_MEMALLOC and thus doesn't need the retry loop
   either.

Both cases will never have __GFP_HIGH set.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/mpage.c | 35 ++++++-----------------------------
 1 file changed, 6 insertions(+), 29 deletions(-)

diff --git a/fs/mpage.c b/fs/mpage.c
index 87f5cfef6caa7..06e95d777e940 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -66,29 +66,6 @@ static struct bio *mpage_bio_submit(int op, int op_flags, struct bio *bio)
 	return NULL;
 }
 
-static struct bio *
-mpage_alloc(struct block_device *bdev,
-		sector_t first_sector, int nr_vecs,
-		gfp_t gfp_flags)
-{
-	struct bio *bio;
-
-	/* Restrict the given (page cache) mask for slab allocations */
-	gfp_flags &= GFP_KERNEL;
-	bio = bio_alloc(gfp_flags, nr_vecs);
-
-	if (bio == NULL && (current->flags & PF_MEMALLOC)) {
-		while (!bio && (nr_vecs /= 2))
-			bio = bio_alloc(gfp_flags, nr_vecs);
-	}
-
-	if (bio) {
-		bio_set_dev(bio, bdev);
-		bio->bi_iter.bi_sector = first_sector;
-	}
-	return bio;
-}
-
 /*
  * support function for mpage_readahead.  The fs supplied get_block might
  * return an up to date buffer.  This is used to map that buffer into
@@ -296,10 +273,11 @@ static struct bio *do_mpage_readpage(struct mpage_readpage_args *args)
 								page))
 				goto out;
 		}
-		args->bio = mpage_alloc(bdev, blocks[0] << (blkbits - 9),
-					bio_max_segs(args->nr_pages), gfp);
+		args->bio = bio_alloc(gfp, bio_max_segs(args->nr_pages));
 		if (args->bio == NULL)
 			goto confused;
+		bio_set_dev(args->bio, bdev);
+		args->bio->bi_iter.bi_sector = blocks[0] << (blkbits - 9);
 	}
 
 	length = first_hole << blkbits;
@@ -608,10 +586,9 @@ static int __mpage_writepage(struct page *page, struct writeback_control *wbc,
 								page, wbc))
 				goto out;
 		}
-		bio = mpage_alloc(bdev, blocks[0] << (blkbits - 9),
-				BIO_MAX_VECS, GFP_NOFS|__GFP_HIGH);
-		if (bio == NULL)
-			goto confused;
+		bio = bio_alloc(GFP_NOFS, BIO_MAX_VECS);
+		bio_set_dev(bio, bdev);
+		bio->bi_iter.bi_sector = blocks[0] << (blkbits - 9);
 
 		wbc_init_bio(wbc, bio);
 		bio->bi_write_hint = inode->i_write_hint;
-- 
2.30.2

