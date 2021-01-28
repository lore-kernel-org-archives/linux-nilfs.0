From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [RFC PATCH 02/34] block: introduce and use bio_new
Date: Wed, 27 Jan 2021 23:11:01 -0800
Message-ID: <20210128071133.60335-3-chaitanya.kulkarni@wdc.com>
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
  t=1611817917; x=1643353917;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1Q7huJyMDOVynURh2o3jolV4xRilOq3cl8xkF29/liU=;
  b=enGvdYf9NC84Zw8fbazQwuF8lHG7Hl7OHG0Djn6p15CQ6sFWQnSTdMIE
   fTVb2TGE7FlZTfw/GSjjxlF8nlg6qwVG3KwfAiR9/Sb3jbYufvvtcwSDF
   uRuW2DIRa+wWd+gEg/P94nTH9uFQdCSYAJg82Ys9HYgDM21+absYlbSFy
   r1Y7ZFsFafQhwTFE0hF4lHuvM4ibWvT1gCpdwtL+fzmm3p6AyJSnMOTyk
   iCSboWzoGwZ+lY/cihXiZ/SnVrv3xPyB6RsMsbW4QRpoEo6xXdH9RfQFO
   C26zlsxlQYPVKqFwWyWh1tH/tUYek+t4qaUQZm0ja4Hm/fZDXuHpSEoIA
   w==;
In-Reply-To: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
Content-Type: text/plain; charset="us-ascii"
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com, xen-devel@lists.xenproject.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-fscrypt@vger.kernel.org, jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-pm@vger.kernel.org, linux-mm@kvack.org
Cc: axboe@kernel.dk, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, konrad.wilk@oracle.com, roger.pau@citrix.com, minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky.work@gmail.com, agk@redhat.com, snitzer@redhat.com, hch@lst.de, sagi@grimberg.me, chaitanya.kulkarni@wdc.com, martin.petersen@oracle.com, viro@zeniv.linux.org.uk, tytso@mit.edu, jaegeuk@kernel.org, ebiggers@kernel.org, djwong@kernel.org, shaggy@kernel.org, konishi.ryusuke@gmail.com, mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, damien.lemoal@wdc.com, naohiro.aota@wdc.com, jth@kernel.org, rjw@rjwysocki.net, len.brown@intel.com, pavel@ucw.cz, akpm@linux-foundation.org, hare@suse.de, gustavoars@kernel.org, tiwai@suse.de, alex.shi@linux.alibaba.com, asml.silence@gmail.com, ming.lei@redhat.com, tj@kernel.org, osandov@fb.com, bvanassche@acm.org, jefflexu@lin

Introduce bio_new() helper and use it in blk-lib.c to allocate and
initialize various non-optional or semi-optional members of the bio
along with bio allocation done with bio_alloc(). Here we also calmp the
max_bvecs for bio with BIO_MAX_PAGES before we pass to bio_alloc().

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 block/blk-lib.c     |  6 +-----
 include/linux/bio.h | 25 +++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index fb486a0bdb58..ec29415f00dd 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -14,17 +14,13 @@ struct bio *blk_next_bio(struct bio *bio, struct block_device *bdev,
 			sector_t sect, unsigned op, unsigned opf,
 			unsigned int nr_pages, gfp_t gfp)
 {
-	struct bio *new = bio_alloc(gfp, nr_pages);
+	struct bio *new = bio_new(bdev, sect, op, opf, gfp, nr_pages);
 
 	if (bio) {
 		bio_chain(bio, new);
 		submit_bio(bio);
 	}
 
-	new->bi_iter.bi_sector = sect;
-	bio_set_dev(new, bdev);
-	bio_set_op_attrs(new, op, opf);
-
 	return new;
 }
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index c74857cf1252..2a09ba100546 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -826,5 +826,30 @@ static inline void bio_set_polled(struct bio *bio, struct kiocb *kiocb)
 	if (!is_sync_kiocb(kiocb))
 		bio->bi_opf |= REQ_NOWAIT;
 }
+/**
+ * bio_new -	allcate and initialize new bio
+ * @bdev:	blockdev to issue discard for
+ * @sector:	start sector
+ * @op:		REQ_OP_XXX from enum req_opf
+ * @op_flags:	REQ_XXX from enum req_flag_bits
+ * @max_bvecs:	maximum bvec to be allocated for this bio
+ * @gfp_mask:	memory allocation flags (for bio_alloc)
+ *
+ * Description:
+ *    Allocates, initializes common members, and returns a new bio.
+ */
+static inline struct bio *bio_new(struct block_device *bdev, sector_t sector,
+				  unsigned int op, unsigned int op_flags,
+				  unsigned int max_bvecs, gfp_t gfp_mask)
+{
+	unsigned nr_bvec = clamp_t(unsigned int, max_bvecs, 0, BIO_MAX_PAGES);
+	struct bio *bio = bio_alloc(gfp_mask, nr_bvec);
+
+	bio_set_dev(bio, bdev);
+	bio->bi_iter.bi_sector = sector;
+	bio_set_op_attrs(bio, op, op_flags);
+
+	return bio;
+}
 
 #endif /* __LINUX_BIO_H */
-- 
2.22.1


