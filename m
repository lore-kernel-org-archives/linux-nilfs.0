From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 06/19] dm-crypt: remove clone_init
Date: Tue, 18 Jan 2022 08:19:39 +0100
Message-ID: <20220118071952.1243143-7-hch@lst.de>
References: <20220118071952.1243143-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=NiiyVm7T1RSoly2lncOqK9SkmVJ5v0QSThOfEky6q20=; b=MpqAqQ8K5Fa6Y5wTGJl/gbG8OO
        dn6PaxcYnaVlNfT2mS1jeUKelsFExp+uG3u9mIvCpmas8BzQ0HJleX15bQnbvwePmlkVlO5W0vzSK
        HvgBfIGs0RGASj9FFd6sE8tJ4qfhkmRCextanNUhqXChTqh8JwFoHdtpflmklbp5zQYV6ZVzOyC1T
        pwKLY+kGCwUQFPrabqHRfoONsuU1ADJ9WWyYqDlTyqsbbVI8ypgDGmJbl8/GUeu7NuW8yznpIFL9H
        xC7HLvhlMXxb+qdKze/uBd+r7dTrjI/Jf8j/c9/dF2KRq4+f8hr1Qn1e+/PCC7wHouMmupch1ruki
        Eavz2L2w==;
In-Reply-To: <20220118071952.1243143-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Konstantin Komarov <almaz.alexandrovich-m5I1DM4ARimttCpgsWEBFlaTQe2KTcn/@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Md . Haris Iqbal " <haris.iqbal-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, Jack Wang <jinpu.wang-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau-Sxgqhf6Nn4Bhl2p70BpVqQ@public.gmane.org>, Philipp Reisner <philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ntfs3-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org

Just open code it next to the bio allocations, which saves a few lines
of code, prepares for future changes and allows to remove the duplicate
bi_opf assignment for the bio_clone_fast case in kcryptd_io_read.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/md/dm-crypt.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 20abe3486aba1..3c5ecd35d3483 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -234,7 +234,7 @@ static volatile unsigned long dm_crypt_pages_per_client;
 #define DM_CRYPT_MEMORY_PERCENT			2
 #define DM_CRYPT_MIN_PAGES_PER_CLIENT		(BIO_MAX_VECS * 16)
 
-static void clone_init(struct dm_crypt_io *, struct bio *);
+static void crypt_endio(struct bio *clone);
 static void kcryptd_queue_crypt(struct dm_crypt_io *io);
 static struct scatterlist *crypt_get_sg_data(struct crypt_config *cc,
 					     struct scatterlist *sg);
@@ -1673,7 +1673,10 @@ static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned size)
 		mutex_lock(&cc->bio_alloc_lock);
 
 	clone = bio_alloc_bioset(GFP_NOIO, nr_iovecs, &cc->bs);
-	clone_init(io, clone);
+	clone->bi_private = io;
+	clone->bi_end_io = crypt_endio;
+	bio_set_dev(clone, cc->dev->bdev);
+	clone->bi_opf = io->base_bio->bi_opf;
 
 	remaining_size = size;
 
@@ -1826,16 +1829,6 @@ static void crypt_endio(struct bio *clone)
 	crypt_dec_pending(io);
 }
 
-static void clone_init(struct dm_crypt_io *io, struct bio *clone)
-{
-	struct crypt_config *cc = io->cc;
-
-	clone->bi_private = io;
-	clone->bi_end_io  = crypt_endio;
-	bio_set_dev(clone, cc->dev->bdev);
-	clone->bi_opf	  = io->base_bio->bi_opf;
-}
-
 static int kcryptd_io_read(struct dm_crypt_io *io, gfp_t gfp)
 {
 	struct crypt_config *cc = io->cc;
@@ -1850,10 +1843,12 @@ static int kcryptd_io_read(struct dm_crypt_io *io, gfp_t gfp)
 	clone = bio_clone_fast(io->base_bio, gfp, &cc->bs);
 	if (!clone)
 		return 1;
+	clone->bi_private = io;
+	clone->bi_end_io = crypt_endio;
+	bio_set_dev(clone, cc->dev->bdev);
 
 	crypt_inc_pending(io);
 
-	clone_init(io, clone);
 	clone->bi_iter.bi_sector = cc->start + io->sector;
 
 	if (dm_crypt_integrity_io_alloc(io, clone)) {
-- 
2.30.2

