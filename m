From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [RFC PATCH 16/34] fs/direct-io: use bio_new in dio_bio_alloc
Date: Wed, 27 Jan 2021 23:11:15 -0800
Message-ID: <20210128071133.60335-17-chaitanya.kulkarni@wdc.com>
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
  t=1611818043; x=1643354043;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+nCtEeEc6ftLNfXULXJD9MfOSjGF3wrLBEXOv9oezHI=;
  b=mGMHMACVYdi5FiLtGjJiyXx6tYott3zQopn4qTNBqtOG7JuQ2trtio0O
   9aUONhKGZkoO5i0NgCH96neygJdAFv4CT7cIyRIw0xwdBfpzVWcqemvPA
   xbZTxuruuZjfnRzHoz0Tk4cdeyj+jqwW3U/qqhf11t2OToho4vVzRd2bx
   zKd8EmnhWqkhMSzVDsmvUdO4mExjkBF1NZyuee6JPZNukp6BlYDmwNyWp
   3O3jkCGKmOKR5IYHS9qkyeHfuLASbOdBcpKLzGZ2oAy+z0AzWMaafYaeB
   hsV/xvUmeFQ9I1IOiOldMW+i31fRKH38Y4R5v6YdEGpTrqnS04wiGBPc8
   g==;
In-Reply-To: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
Content-Type: text/plain; charset="us-ascii"
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com, xen-devel@lists.xenproject.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-fscrypt@vger.kernel.org, jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-pm@vger.kernel.org, linux-mm@kvack.org
Cc: axboe@kernel.dk, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, konrad.wilk@oracle.com, roger.pau@citrix.com, minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky.work@gmail.com, agk@redhat.com, snitzer@redhat.com, hch@lst.de, sagi@grimberg.me, chaitanya.kulkarni@wdc.com, martin.petersen@oracle.com, viro@zeniv.linux.org.uk, tytso@mit.edu, jaegeuk@kernel.org, ebiggers@kernel.org, djwong@kernel.org, shaggy@kernel.org, konishi.ryusuke@gmail.com, mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, damien.lemoal@wdc.com, naohiro.aota@wdc.com, jth@kernel.org, rjw@rjwysocki.net, len.brown@intel.com, pavel@ucw.cz, akpm@linux-foundation.org, hare@suse.de, gustavoars@kernel.org, tiwai@suse.de, alex.shi@linux.alibaba.com, asml.silence@gmail.com, ming.lei@redhat.com, tj@kernel.org, osandov@fb.com, bvanassche@acm.org, jefflexu@lin

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 fs/crypto/bio.c | 2 +-
 fs/direct-io.c  | 6 ++----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/crypto/bio.c b/fs/crypto/bio.c
index 20dab9bdf098..28cd62ce853e 100644
--- a/fs/crypto/bio.c
+++ b/fs/crypto/bio.c
@@ -148,7 +148,7 @@ int fscrypt_zeroout_range(const struct inode *inode, pgoff_t lblk,
 		return -EINVAL;
 
 	/* This always succeeds since __GFP_DIRECT_RECLAIM is set. */
-	bio = bio_alloc(inode->i_sb->s_bdev, 0, REQ_OP_WRITE, 0, nr_pages,
+	bio = bio_new(inode->i_sb->s_bdev, 0, REQ_OP_WRITE, 0, nr_pages,
 			GFP_NOFS);
 
 	do {
diff --git a/fs/direct-io.c b/fs/direct-io.c
index aa1083ecd623..6aab1bd167bc 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -397,11 +397,9 @@ dio_bio_alloc(struct dio *dio, struct dio_submit *sdio,
 	 * bio_alloc() is guaranteed to return a bio when allowed to sleep and
 	 * we request a valid number of vectors.
 	 */
-	bio = bio_alloc(GFP_KERNEL, nr_vecs);
+	bio = bio_new(bdev, first_sector, dio->op, dio->op_flags, nr_vecs,
+		      GFP_KERNEL);
 
-	bio_set_dev(bio, bdev);
-	bio->bi_iter.bi_sector = first_sector;
-	bio_set_op_attrs(bio, dio->op, dio->op_flags);
 	if (dio->is_async)
 		bio->bi_end_io = dio_bio_end_aio;
 	else
-- 
2.22.1


