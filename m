From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/3] ext4: pass the operation to bio_alloc
Date: Tue, 22 Feb 2022 16:46:33 +0100
Message-ID: <20220222154634.597067-3-hch@lst.de>
References: <20220222154634.597067-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-ext4-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=sd9RxJShPGiAFRICO73ZkjFAfnS+ztcq1MfxJ2y9BeM=; b=eiFrWaVPt5ZxRL5mRXxJlrXxZN
        AtUo1z+jidH2+odsHyo1urmrJ6GQPMjkJ0fn4aDuvs883+kOmYRsRxwUdQuQvOwCIgkXPP23LWCNT
        TwwAXu6Pdk2xIzqIH5Bjejr4s6wdBp5w4Fk6sBTE0AvP+1zmbyUfk6UJnZE2ReTvQfjZz7Hf4wCuL
        6gbDDg8JUYora+UTNAYZSvU89KaMrj2LIFtbGZi242pXwbAllNPTiLx5Up7fGExDpdMoNvpVNfx2/
        5JV+EJve3iRsb7qYfv1Y6/sQcEX1tX2I/jaSUhlVbQVtafSFZ+4WB26VFnAnqsdSfXsYA0k77IE3J
        NDqPrulw==;
In-Reply-To: <20220222154634.597067-1-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>, Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-block@vger.kernel.org, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nilfs@vger.kernel.org

Refactor the readpage code to pass the op to bio_alloc instead of setting
it just before the submission.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/ext4/page-io.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 1253982268730..35ada7baf41e5 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -372,10 +372,9 @@ void ext4_io_submit(struct ext4_io_submit *io)
 	struct bio *bio = io->io_bio;
 
 	if (bio) {
-		int io_op_flags = io->io_wbc->sync_mode == WB_SYNC_ALL ?
-				  REQ_SYNC : 0;
+		if (io->io_wbc->sync_mode == WB_SYNC_ALL)
+			io->io_bio->bi_opf |= REQ_SYNC;
 		io->io_bio->bi_write_hint = io->io_end->inode->i_write_hint;
-		bio_set_op_attrs(io->io_bio, REQ_OP_WRITE, io_op_flags);
 		submit_bio(io->io_bio);
 	}
 	io->io_bio = NULL;
@@ -398,7 +397,7 @@ static void io_submit_init_bio(struct ext4_io_submit *io,
 	 * bio_alloc will _always_ be able to allocate a bio if
 	 * __GFP_DIRECT_RECLAIM is set, see comments for bio_alloc_bioset().
 	 */
-	bio = bio_alloc(bh->b_bdev, BIO_MAX_VECS, 0, GFP_NOIO);
+	bio = bio_alloc(bh->b_bdev, BIO_MAX_VECS, REQ_OP_WRITE, GFP_NOIO);
 	fscrypt_set_bio_crypt_ctx_bh(bio, bh, GFP_NOIO);
 	bio->bi_iter.bi_sector = bh->b_blocknr * (bh->b_size >> 9);
 	bio->bi_end_io = ext4_end_bio;
-- 
2.30.2

