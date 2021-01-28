From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [RFC PATCH 25/34] ocfs/cluster: use bio_new in dm-log-writes
Date: Wed, 27 Jan 2021 23:11:24 -0800
Message-ID: <20210128071133.60335-26-chaitanya.kulkarni@wdc.com>
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
  t=1611818109; x=1643354109;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MfH3EN2qKmNoDMJp2ceJniIXfb1rQ8RA/+9VrY6oRvA=;
  b=i0tcfM8LPDdJD76KNz+KebHt7aNu8dhDBYf/yXb5/+nYgQh0WMse7Sn9
   ozH9xc9Sc+UfsdK76ohaCN6GCCqFE6bAY2B1MPyc5DLSfnPLPwFnYTKgo
   C+OoNr6y2lvG3ysq55KlUUYx0SyWumd7F1WOxvIw9Fep6NoRLLh1itIGY
   olcxqnkChE8DQ21CN5uYlkYXOgVZGydZPzcofilVELDK1rCglBJtI88zl
   XslA1BLq6AxPBwEweAnxe/9kwmqcWSX4LyaLSH9Hi5ekxO6pVUVdSUFMV
   Lfq5RSA+OdcgwBD60MbPkiMMaeX9mBe48U+a84ScWlpFvvr5FvH74xaRT
   w==;
In-Reply-To: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
Content-Type: text/plain; charset="us-ascii"
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com, xen-devel@lists.xenproject.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-fscrypt@vger.kernel.org, jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-pm@vger.kernel.org, linux-mm@kvack.org
Cc: axboe@kernel.dk, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, konrad.wilk@oracle.com, roger.pau@citrix.com, minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky.work@gmail.com, agk@redhat.com, snitzer@redhat.com, hch@lst.de, sagi@grimberg.me, chaitanya.kulkarni@wdc.com, martin.petersen@oracle.com, viro@zeniv.linux.org.uk, tytso@mit.edu, jaegeuk@kernel.org, ebiggers@kernel.org, djwong@kernel.org, shaggy@kernel.org, konishi.ryusuke@gmail.com, mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, damien.lemoal@wdc.com, naohiro.aota@wdc.com, jth@kernel.org, rjw@rjwysocki.net, len.brown@intel.com, pavel@ucw.cz, akpm@linux-foundation.org, hare@suse.de, gustavoars@kernel.org, tiwai@suse.de, alex.shi@linux.alibaba.com, asml.silence@gmail.com, ming.lei@redhat.com, tj@kernel.org, osandov@fb.com, bvanassche@acm.org, jefflexu@lin

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 fs/ocfs2/cluster/heartbeat.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 0179a73a3fa2..b34518036446 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -515,12 +515,13 @@ static struct bio *o2hb_setup_one_bio(struct o2hb_region *reg,
 	unsigned int cs = *current_slot;
 	struct bio *bio;
 	struct page *page;
+	sector_t sect = (reg->hr_start_block + cs) << (bits - 9);
 
 	/* Testing has shown this allocation to take long enough under
 	 * GFP_KERNEL that the local node can get fenced. It would be
 	 * nicest if we could pre-allocate these bios and avoid this
 	 * all together. */
-	bio = bio_alloc(GFP_ATOMIC, 16);
+	bio = bio_new(reg->hr_bdev, sect, op, op_flags, 16, GFP_ATOMIC);
 	if (!bio) {
 		mlog(ML_ERROR, "Could not alloc slots BIO!\n");
 		bio = ERR_PTR(-ENOMEM);
@@ -528,11 +529,8 @@ static struct bio *o2hb_setup_one_bio(struct o2hb_region *reg,
 	}
 
 	/* Must put everything in 512 byte sectors for the bio... */
-	bio->bi_iter.bi_sector = (reg->hr_start_block + cs) << (bits - 9);
-	bio_set_dev(bio, reg->hr_bdev);
 	bio->bi_private = wc;
 	bio->bi_end_io = o2hb_bio_end_io;
-	bio_set_op_attrs(bio, op, op_flags);
 
 	vec_start = (cs << bits) % PAGE_SIZE;
 	while(cs < max_slots) {
-- 
2.22.1


