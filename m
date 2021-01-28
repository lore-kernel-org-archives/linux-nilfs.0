From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [RFC PATCH 32/34] mm: use bio_new in __swap_writepage
Date: Wed, 27 Jan 2021 23:11:31 -0800
Message-ID: <20210128071133.60335-33-chaitanya.kulkarni@wdc.com>
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
  t=1611818165; x=1643354165;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gllqHMP2deuE0vZ0qLUvAasM9UgJt1wGssSRSahQx/E=;
  b=hOGHLilUmvGxftol4u3kaHh/IdpbjeATrhmzK2p5u3wlcOEAGVolUwiC
   ijbbza2rMpSD0nIG909thINsbBpAouH+uSekpnwnBUg93ZAO3U5auD88H
   CFORGFo1Pr7Xk67T7/tcRqjkXscVFk6dzsxMBM3CoKEb9K0KOU9o7mBFJ
   IsOW2SrDDadHEZSq75JiQrHdn930EF8m8WAAkQvrdsRQfGVQoLs7M15rS
   eZRPONG5dBLWI5EafB+spMp9kR+MX7PmUiZNoXZcTeDAEJLwPYPyQD0aK
   YM92r0meR2GBK9vsqgfmuJsMzaGILCu1X5kJ7zgepRUgzohRH4kNV/HO2
   A==;
In-Reply-To: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
Content-Type: text/plain; charset="us-ascii"
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com, xen-devel@lists.xenproject.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-fscrypt@vger.kernel.org, jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-pm@vger.kernel.org, linux-mm@kvack.org
Cc: axboe@kernel.dk, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, konrad.wilk@oracle.com, roger.pau@citrix.com, minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky.work@gmail.com, agk@redhat.com, snitzer@redhat.com, hch@lst.de, sagi@grimberg.me, chaitanya.kulkarni@wdc.com, martin.petersen@oracle.com, viro@zeniv.linux.org.uk, tytso@mit.edu, jaegeuk@kernel.org, ebiggers@kernel.org, djwong@kernel.org, shaggy@kernel.org, konishi.ryusuke@gmail.com, mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, damien.lemoal@wdc.com, naohiro.aota@wdc.com, jth@kernel.org, rjw@rjwysocki.net, len.brown@intel.com, pavel@ucw.cz, akpm@linux-foundation.org, hare@suse.de, gustavoars@kernel.org, tiwai@suse.de, alex.shi@linux.alibaba.com, asml.silence@gmail.com, ming.lei@redhat.com, tj@kernel.org, osandov@fb.com, bvanassche@acm.org, jefflexu@lin

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 mm/page_io.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 92f7941c6d01..25b321489703 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -342,10 +342,8 @@ int __swap_writepage(struct page *page, struct writeback_control *wbc,
 		return 0;
 	}
 
-	bio = bio_alloc(GFP_NOIO, 1);
-	bio_set_dev(bio, sis->bdev);
-	bio->bi_iter.bi_sector = swap_page_sector(page);
-	bio->bi_opf = REQ_OP_WRITE | REQ_SWAP | wbc_to_write_flags(wbc);
+	bio = bio_alloc(sis->bdev, swap_page_sector(page), REQ_OP_WRITE,
+			REQ_SWAP | wbc_to_write_flags(wbc), 1, GFP_NOIO);
 	bio->bi_end_io = end_write_func;
 	bio_add_page(bio, page, thp_size(page), 0);
 
-- 
2.22.1


