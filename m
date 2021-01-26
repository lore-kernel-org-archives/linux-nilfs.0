From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/17] f2fs: use blkdev_issue_flush in
	__submit_flush_wait
Date: Tue, 26 Jan 2021 15:52:37 +0100
Message-ID: <20210126145247.1964410-8-hch@lst.de>
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

Use the blkdev_issue_flush helper instead of duplicating it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/f2fs/data.c    |  3 ++-
 fs/f2fs/f2fs.h    |  1 -
 fs/f2fs/segment.c | 12 +-----------
 3 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 8cbf0315975228..0cf0c605992431 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -56,7 +56,8 @@ static inline struct bio *__f2fs_bio_alloc(gfp_t gfp_mask,
 	return bio_alloc_bioset(gfp_mask, nr_iovecs, &f2fs_bioset);
 }
 
-struct bio *f2fs_bio_alloc(struct f2fs_sb_info *sbi, int npages, bool noio)
+static struct bio *f2fs_bio_alloc(struct f2fs_sb_info *sbi, int npages,
+		bool noio)
 {
 	if (noio) {
 		/* No failure on bio allocation */
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index bb11759191dcc9..902bd3267c03e1 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -3424,7 +3424,6 @@ void f2fs_destroy_checkpoint_caches(void);
  */
 int __init f2fs_init_bioset(void);
 void f2fs_destroy_bioset(void);
-struct bio *f2fs_bio_alloc(struct f2fs_sb_info *sbi, int npages, bool noio);
 int f2fs_init_bio_entry_cache(void);
 void f2fs_destroy_bio_entry_cache(void);
 void f2fs_submit_bio(struct f2fs_sb_info *sbi,
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index deca74cb17dfd8..c495f170ee400b 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -566,17 +566,7 @@ void f2fs_balance_fs_bg(struct f2fs_sb_info *sbi, bool from_bg)
 static int __submit_flush_wait(struct f2fs_sb_info *sbi,
 				struct block_device *bdev)
 {
-	struct bio *bio;
-	int ret;
-
-	bio = f2fs_bio_alloc(sbi, 0, false);
-	if (!bio)
-		return -ENOMEM;
-
-	bio->bi_opf = REQ_OP_WRITE | REQ_SYNC | REQ_PREFLUSH;
-	bio_set_dev(bio, bdev);
-	ret = submit_bio_wait(bio);
-	bio_put(bio);
+	int ret = blkdev_issue_flush(bdev);
 
 	trace_f2fs_issue_flush(bdev, test_opt(sbi, NOBARRIER),
 				test_opt(sbi, FLUSH_MERGE), ret);
-- 
2.29.2
