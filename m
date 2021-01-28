From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [RFC PATCH 11/34] nvmet: use bio_new in nvmet_bdev_execute_rw
Date: Wed, 27 Jan 2021 23:11:10 -0800
Message-ID: <20210128071133.60335-12-chaitanya.kulkarni@wdc.com>
References: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <xen-devel-bounces@lists.xenproject.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.xenproject.org/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xenproject.org>
List-Help: <mailto:xen-devel-request@lists.xenproject.org?subject=help>
List-Subscribe: <https://lists.xenproject.org/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xenproject.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xenproject.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611818004; x=1643354004;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g8HJbcPmpqxtxJgQpVgZEQpuhn8q+oe36W4m3E0vxow=;
  b=XI0ykKj/3zgNK4sf+v7xp9lq/h6L+2YFPel83iOYaHKerDSqtKOr+24f
   fa5MlVF00jCXb5UG4SV5lp1cMfen1eryHuczjkB60XCYCSsPdrKXjL6GH
   3hcrRhOA6kMe5XWR0x/kiTndQXq3S+VMVi3Fr63rdMzkwCd7ye7KNubKp
   mckYbemMizhDK1jtXZSrCnrHJjtEqNIls5ba8ZAZqgFtAciV5Hi1jI2rl
   2qr0jNty/KqiuY6FzEOynYNDpr1/8PpxGHL4SHgM+FPEkfvQDoljmpFws
   MxUDS2URF+mWm9ZEsqM6pKEZOMrlpOreqW/9hvJjE2MBDSePRYASFJ7RS
   Q==;
In-Reply-To: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
Content-Type: text/plain; charset="us-ascii"
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com, xen-devel@lists.xenproject.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-fscrypt@vger.kernel.org, jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-pm@vger.kernel.org, linux-mm@kvack.org
Cc: axboe@kernel.dk, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, konrad.wilk@oracle.com, roger.pau@citrix.com, minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky.work@gmail.com, agk@redhat.com, snitzer@redhat.com, hch@lst.de, sagi@grimberg.me, chaitanya.kulkarni@wdc.com, martin.petersen@oracle.com, viro@zeniv.linux.org.uk, tytso@mit.edu, jaegeuk@kernel.org, ebiggers@kernel.org, djwong@kernel.org, shaggy@kernel.org, konishi.ryusuke@gmail.com, mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, damien.lemoal@wdc.com, naohiro.aota@wdc.com, jth@kernel.org, rjw@rjwysocki.net, len.brown@intel.com, pavel@ucw.cz, akpm@linux-foundation.org, hare@suse.de, gustavoars@kernel.org, tiwai@suse.de, alex.shi@linux.alibaba.com, asml.silence@gmail.com, ming.lei@redhat.com, tj@kernel.org, osandov@fb.com, bvanassche@acm.org, jefflexu@lin

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/nvme/target/io-cmd-bdev.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index bf6e0ac9ad28..f5fd93a796a6 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -225,6 +225,7 @@ static int nvmet_bdev_alloc_bip(struct nvmet_req *req, struct bio *bio,
 
 static void nvmet_bdev_execute_rw(struct nvmet_req *req)
 {
+	struct block_device *bdev = req->ns->bdev;
 	int sg_cnt = req->sg_cnt;
 	struct bio *bio;
 	struct scatterlist *sg;
@@ -265,7 +266,7 @@ static void nvmet_bdev_execute_rw(struct nvmet_req *req)
 	} else {
 		bio = bio_alloc(GFP_KERNEL, min(sg_cnt, BIO_MAX_PAGES));
 	}
-	bio_set_dev(bio, req->ns->bdev);
+	bio_set_dev(bio, bdev);
 	bio->bi_iter.bi_sector = sector;
 	bio->bi_private = req;
 	bio->bi_end_io = nvmet_bio_done;
@@ -290,11 +291,7 @@ static void nvmet_bdev_execute_rw(struct nvmet_req *req)
 				}
 			}
 
-			bio = bio_alloc(GFP_KERNEL, min(sg_cnt, BIO_MAX_PAGES));
-			bio_set_dev(bio, req->ns->bdev);
-			bio->bi_iter.bi_sector = sector;
-			bio->bi_opf = op;
-
+			bio = bio_new(bdev, sector, op, 0, sg_cnt, GFP_KERNEL);
 			bio_chain(bio, prev);
 			submit_bio(prev);
 		}
-- 
2.22.1


