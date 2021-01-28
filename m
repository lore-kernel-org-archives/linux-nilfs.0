From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [RFC PATCH 29/34] power/swap: use bio_new in hib_submit_io
Date: Wed, 27 Jan 2021 23:11:28 -0800
Message-ID: <20210128071133.60335-30-chaitanya.kulkarni@wdc.com>
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
  t=1611818140; x=1643354140;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mX0lBXgZV5dDDUNO5/xUPQTxA6WXojrnDbaB4rJIAQ4=;
  b=aaVLORsEGRgytiupj+H8u8Nwfro8Wh3jnZGjXcDD4jt2HKyp/W8ERIXp
   fQEmB8ar99oys/4QKD4tcrrQUi5sGkoM1TPci77eg8niu4H/UQKRJF7xu
   KazKuO3tqz61g7nyfZl+sAsXbjSqmq8Iz6yUbq2cwh0J/GKqg6NTTlJUW
   Yub6sZdsFGXQTXwUA2NDFDHVC1hcVkngxwoRiXEyhK0L/ACZRPo7hEM8+
   UIGoinidpnrqFz9AHnIlAtP1yx7dx8L79GJwiNFw/pIZ7nWLPgL5W3r8F
   xsuNeovEl2ICMMBi09a0/fuW2gsLkovlx87gPzzhca5uipPwjfQQJ7fW5
   A==;
In-Reply-To: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
Content-Type: text/plain; charset="us-ascii"
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com, xen-devel@lists.xenproject.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-fscrypt@vger.kernel.org, jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-pm@vger.kernel.org, linux-mm@kvack.org
Cc: axboe@kernel.dk, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, konrad.wilk@oracle.com, roger.pau@citrix.com, minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky.work@gmail.com, agk@redhat.com, snitzer@redhat.com, hch@lst.de, sagi@grimberg.me, chaitanya.kulkarni@wdc.com, martin.petersen@oracle.com, viro@zeniv.linux.org.uk, tytso@mit.edu, jaegeuk@kernel.org, ebiggers@kernel.org, djwong@kernel.org, shaggy@kernel.org, konishi.ryusuke@gmail.com, mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, damien.lemoal@wdc.com, naohiro.aota@wdc.com, jth@kernel.org, rjw@rjwysocki.net, len.brown@intel.com, pavel@ucw.cz, akpm@linux-foundation.org, hare@suse.de, gustavoars@kernel.org, tiwai@suse.de, alex.shi@linux.alibaba.com, asml.silence@gmail.com, ming.lei@redhat.com, tj@kernel.org, osandov@fb.com, bvanassche@acm.org, jefflexu@lin

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 kernel/power/swap.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index c73f2e295167..e92e36c053a6 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -271,13 +271,12 @@ static int hib_submit_io(int op, int op_flags, pgoff_t page_off, void *addr,
 		struct hib_bio_batch *hb)
 {
 	struct page *page = virt_to_page(addr);
+	sector_t sect = page_off * (PAGE_SIZE >> 9);
 	struct bio *bio;
 	int error = 0;
 
-	bio = bio_alloc(GFP_NOIO | __GFP_HIGH, 1);
-	bio->bi_iter.bi_sector = page_off * (PAGE_SIZE >> 9);
-	bio_set_dev(bio, hib_resume_bdev);
-	bio_set_op_attrs(bio, op, op_flags);
+	bio = bio_new(hib_resume_bdev, sect, op, op_flags, 1,
+		      GFP_NOIO | __GFP_HIGH);
 
 	if (bio_add_page(bio, page, PAGE_SIZE, 0) < PAGE_SIZE) {
 		pr_err("Adding page to bio failed at %llu\n",
-- 
2.22.1


