From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [RFC PATCH 00/34] block: introduce bio_new()
Date: Wed, 27 Jan 2021 23:10:59 -0800
Message-ID: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
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
  t=1611817899; x=1643353899;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BWhCtPmFmY8SRwjALXcTfESKnsKfTCmOrzddkgcZe24=;
  b=najx2apuJj8Rzstic9UUF6wkNiJmnz1WB56S5SNgmasfosOAzrepDxzF
   /J9Q7w+qfB7GbJesGGScfJzUjVqmT3JD9Hf+/14UdR1NlTBPnsVbcSukI
   r91h8dUn0Khd00+bcfmD/cfOFbgH8s8pAQ/2CZa4Aitm8Atb4sBHCAbbi
   qFh0N60tSMFdApsojgGp+L4OVaUERC6tJr7fwmH3eGX+foXOJH2OSvXj4
   hoh5CSYDMPZKG719NfKurUxYb61CNaGu0Lu0Fb8PPh/ln4KLpS5WjQaHe
   LkxgIihXWqzfLLwbtm4v5vOWHKMx9/FeINee+X2oC1hcVxTcmJ5PR7H3Y
   Q==;
Content-Type: text/plain; charset="us-ascii"
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com, xen-devel@lists.xenproject.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-fscrypt@vger.kernel.org, jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-pm@vger.kernel.org, linux-mm@kvack.org
Cc: axboe@kernel.dk, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, konrad.wilk@oracle.com, roger.pau@citrix.com, minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky.work@gmail.com, agk@redhat.com, snitzer@redhat.com, hch@lst.de, sagi@grimberg.me, chaitanya.kulkarni@wdc.com, martin.petersen@oracle.com, viro@zeniv.linux.org.uk, tytso@mit.edu, jaegeuk@kernel.org, ebiggers@kernel.org, djwong@kernel.org, shaggy@kernel.org, konishi.ryusuke@gmail.com, mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, damien.lemoal@wdc.com, naohiro.aota@wdc.com, jth@kernel.org, rjw@rjwysocki.net, len.brown@intel.com, pavel@ucw.cz, akpm@linux-foundation.org, hare@suse.de, gustavoars@kernel.org, tiwai@suse.de, alex.shi@linux.alibaba.com, asml.silence@gmail.com, ming.lei@redhat.com, tj@kernel.org, osandov@fb.com, bvanassche@acm.org, jefflexu@lin

Hi,

This is a *compile only RFC* which adds a generic helper to initialize
the various fields of the bio that is repeated all the places in
file-systems, block layer, and drivers.

The new helper allows callers to initialize non-optional members of bio
such as bdev, sector, op, opflags, max_bvecs and gfp_mask by
encapsulating new bio allocation with bio alloc with initialization
at one place.

The objective of this RFC is to only start a discussion, this it not 
completely tested at all.

-ck                         

Chaitanya Kulkarni (34):
  block: move common code into blk_next_bio()
  block: introduce and use bio_new
  drdb: use bio_new in drdb
  drdb: use bio_new() in submit_one_flush
  xen-blkback: use bio_new
  zram: use bio_new
  dm: use bio_new in dm-log-writes
  dm-zoned: use bio_new in get_mblock_slow
  dm-zoned: use bio_new in dmz_write_mblock
  dm-zoned: use bio_new in dmz_rdwr_block
  nvmet: use bio_new in nvmet_bdev_execute_rw
  scsi: target/iblock: use bio_new
  block: use bio_new in __blkdev_direct_IO
  fs/buffer: use bio_new in submit_bh_wbc
  fscrypt: use bio_new in fscrypt_zeroout_range
  fs/direct-io: use bio_new in dio_bio_alloc
  iomap: use bio_new in iomap_dio_zero
  iomap: use bio_new in iomap_dio_bio_actor
  fs/jfs/jfs_logmgr.c: use bio_new in lbmRead
  fs/jfs/jfs_logmgr.c: use bio_new in lbmStartIO
  fs/jfs/jfs_metapage.c: use bio_new in metapage_writepage
  fs/jfs/jfs_metapage.c: use bio_new in metapage_readpage
  fs/mpage.c: use bio_new mpage_alloc
  fs/nilfs: use bio_new nilfs_alloc_seg_bio
  ocfs/cluster: use bio_new in dm-log-writes
  xfs: use bio_new in xfs_rw_bdev
  xfs: use bio_new in xfs_buf_ioapply_map
  zonefs: use bio_new
  power/swap: use bio_new in hib_submit_io
  hfsplus: use bio_new in hfsplus_submit_bio()
  iomap: use bio_new in iomap_readpage_actor
  mm: use bio_new in __swap_writepage
  mm: use bio_new in swap_readpage
  mm: add swap_bio_new common bio helper

 block/blk-lib.c                     | 34 ++++++++++-------------------
 block/blk-zoned.c                   |  4 +---
 block/blk.h                         |  5 +++--
 drivers/block/drbd/drbd_receiver.c  | 12 +++++-----
 drivers/block/xen-blkback/blkback.c | 20 +++++++++++------
 drivers/block/zram/zram_drv.c       |  5 ++---
 drivers/md/dm-log-writes.c          | 30 +++++++++----------------
 drivers/md/dm-zoned-metadata.c      | 18 +++++----------
 drivers/nvme/target/io-cmd-bdev.c   |  9 +++-----
 drivers/target/target_core_iblock.c |  5 ++---
 fs/block_dev.c                      |  6 ++---
 fs/buffer.c                         | 16 ++++++--------
 fs/crypto/bio.c                     |  5 ++---
 fs/direct-io.c                      |  6 ++---
 fs/hfsplus/wrapper.c                |  5 +----
 fs/iomap/buffered-io.c              | 12 +++++-----
 fs/iomap/direct-io.c                | 11 ++++------
 fs/jfs/jfs_logmgr.c                 | 13 ++++-------
 fs/jfs/jfs_metapage.c               | 15 +++++--------
 fs/mpage.c                          | 18 +++++----------
 fs/nilfs2/segbuf.c                  | 10 ++-------
 fs/ocfs2/cluster/heartbeat.c        |  6 ++---
 fs/xfs/xfs_bio_io.c                 |  7 ++----
 fs/xfs/xfs_buf.c                    |  6 ++---
 fs/zonefs/super.c                   |  6 ++---
 include/linux/bio.h                 | 25 +++++++++++++++++++++
 kernel/power/swap.c                 |  7 +++---
 mm/page_io.c                        | 30 +++++++++++++------------
 28 files changed, 151 insertions(+), 195 deletions(-)

-- 
2.22.1


