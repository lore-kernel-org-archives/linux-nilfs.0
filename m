From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/19] dm-thin: use blkdev_issue_flush instead of open coding it
Date: Tue, 18 Jan 2022 08:19:41 +0100
Message-ID: <20220118071952.1243143-9-hch@lst.de>
References: <20220118071952.1243143-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Mjlg0k+4PavheCjtECQRQWUa0Hx79sA/tX844Pch6ns=; b=J16yfBYxqMqCR4/icZDJD57u2j
        DA/h/Bvx6tp5hUWp6T5hIN6kAo0h81u7VB5vX2PJFYPbA5Jip0zIxH0QF77uc+wv3Tt3bQNqL9zpU
        Xw1J5pCKIH4fMZo0zDzehCBQK4ptMHCf/kurjvoKFxzlkJPj1x3WnU1HronoCcx+5iVomGRe0jbQ5
        +9TeZAxV9SZXRFSdLXyyweZa76qUuxS8EEF2auFQY5FdB6lJIdHPnVZG9tukiFG1EbWFY3JNY3gYZ
        aZzw30AY/9fH2bVgiL3+07XqlleukFPs4e5SlLWaCZ9yT49wuT1K5cXjvZftA2oHDecikY339m78F
        GsPtzqbw==;
In-Reply-To: <20220118071952.1243143-1-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, Mike Snitzer <snitzer@redhat.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Andrew Morton <akpm@linux-foundation.org>, "Md . Haris Iqbal " <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.co>, Philipp Reisner <philipp.reisner@linbit.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev, xen-devel@lists.xenproject.org, drbd-dev@lists.linbit.com

Use blkdev_issue_flush, which uses an on-stack bio instead of an
opencoded version with a bio embedded into struct pool.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-thin.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 76a9c2e9aeeea..411a3f56ed90c 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -282,8 +282,6 @@ struct pool {
 	struct dm_bio_prison_cell **cell_sort_array;
 
 	mempool_t mapping_pool;
-
-	struct bio flush_bio;
 };
 
 static void metadata_operation_failed(struct pool *pool, const char *op, int r);
@@ -2906,7 +2904,6 @@ static void __pool_destroy(struct pool *pool)
 	if (pool->next_mapping)
 		mempool_free(pool->next_mapping, &pool->mapping_pool);
 	mempool_exit(&pool->mapping_pool);
-	bio_uninit(&pool->flush_bio);
 	dm_deferred_set_destroy(pool->shared_read_ds);
 	dm_deferred_set_destroy(pool->all_io_ds);
 	kfree(pool);
@@ -2987,7 +2984,6 @@ static struct pool *pool_create(struct mapped_device *pool_md,
 	pool->low_water_triggered = false;
 	pool->suspended = true;
 	pool->out_of_data_space = false;
-	bio_init(&pool->flush_bio, NULL, 0);
 
 	pool->shared_read_ds = dm_deferred_set_create();
 	if (!pool->shared_read_ds) {
@@ -3194,13 +3190,8 @@ static void metadata_low_callback(void *context)
 static int metadata_pre_commit_callback(void *context)
 {
 	struct pool *pool = context;
-	struct bio *flush_bio = &pool->flush_bio;
-
-	bio_reset(flush_bio);
-	bio_set_dev(flush_bio, pool->data_dev);
-	flush_bio->bi_opf = REQ_OP_WRITE | REQ_PREFLUSH;
 
-	return submit_bio_wait(flush_bio);
+	return blkdev_issue_flush(pool->data_dev);
 }
 
 static sector_t get_dev_size(struct block_device *bdev)
-- 
2.30.2

