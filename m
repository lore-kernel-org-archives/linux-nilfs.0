From: Christoph Hellwig <hch@lst.de>
Subject: decouple block open flags from fmode_t
Date: Tue,  6 Jun 2023 09:39:19 +0200
Message-ID: <20230606073950.225178-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-um-bounces+glud-user-mode-linux-devel=m.gmane-mx.org@lists.infradead.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=lists.infradead.org; s=bombadil.20210309; h=Sender:
	Content-Transfer-Encoding:Content-Type:List-Subscribe:List-Help:List-Post:
	List-Archive:List-Unsubscribe:List-Id:MIME-Version:Message-Id:Date:Subject:Cc
	:To:From:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:
	List-Owner; bh=mjy04L6II9PMzcy0xLS5KC0IVsr03bJIispSpQz/Vg4=; b=zZWnVHNDsBFowM
	Cij1HQ18vbEoM4JkchPgy2T3pmdn7cz/EVQ3r7j0YAASL96FlhC+tA/CC6K5ZRXbuM0OnAWFQXgSY
	GzBzNOX7z1GeIf5rQUwKbt9O+LceN2B0BhrN4d4yDq7pGlxNqlOWqlH5TdzT3HzLsh1hWBwUzuDGO
	Z0L2gTVfOv9QjrMa5gvhR87chBJRFpJqSDBIxa3NIGg3lecvQ3Bg7OuBDN8aeWzOfswYJouA3UtmW
	5gY2lpCDUc2jqNmxznB9e+AT0poZurD9c+FolAmrv0B150Tywhoy7YduTz2RYLu9TrFTGFw1OXS7g
	EZfSE/YJaLzW7PgaPVAQ==;
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-um>,
 <mailto:linux-um-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-um/>
List-Post: <mailto:linux-um@lists.infradead.org>
List-Help: <mailto:linux-um-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-um>,
 <mailto:linux-um-request@lists.infradead.org?subject=subscribe>
Sender: "linux-um" <linux-um-bounces@lists.infradead.org>
Errors-To: linux-um-bounces+glud-user-mode-linux-devel=m.gmane-mx.org@lists.infradead.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Richard Weinberger <richard@nod.at>, Josef Bacik <josef@toxicpanda.com>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, Phillip Potter <phil@philpotter.co.uk>, Coly Li <colyli@suse.de>, Miquel Raynal <miquel.raynal@bootlin.com>, Vignesh Raghavendra <vigneshr@ti.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-um@lists.infradead.org, linux-scsi@vger.kernel.org, linux-bcache@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-btrfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-fsdeve

Hi all,

this series adds a new blk_mode_t for block open flags instead of abusing
fmode_t.  The block open flags work very different from the normal use of
fmode_t and only share the basic READ/WRITE flags with it.  None of the
other normal FMODE_* flags is used, but instead there are three
block-specific ones not used by anyone else, which can now be removed.

Note that I've only CCed maintainers and lists for drivers and file systems
that have non-trivial changes, as otherwise the series would spam literally
everyone in the block and file system world.

Diffstat:
 arch/um/drivers/ubd_kern.c          |   20 ++-----
 arch/xtensa/platforms/iss/simdisk.c |    6 +-
 block/bdev.c                        |   99 ++++++++++++++++++------------------
 block/blk-zoned.c                   |   12 ++--
 block/blk.h                         |   26 ++++++++-
 block/bsg-lib.c                     |    2 
 block/bsg.c                         |    8 +-
 block/disk-events.c                 |   47 +++++++----------
 block/fops.c                        |   54 ++++++++++++-------
 block/genhd.c                       |   13 ++--
 block/ioctl.c                       |   61 +++++++---------------
 drivers/block/amiflop.c             |   20 +++----
 drivers/block/aoe/aoeblk.c          |    8 +-
 drivers/block/ataflop.c             |   43 +++++++--------
 drivers/block/drbd/drbd_main.c      |   13 ++--
 drivers/block/drbd/drbd_nl.c        |   23 +++++---
 drivers/block/floppy.c              |   72 +++++++++++++-------------
 drivers/block/loop.c                |   24 ++++----
 drivers/block/mtip32xx/mtip32xx.c   |    4 -
 drivers/block/nbd.c                 |   12 ++--
 drivers/block/pktcdvd.c             |   36 ++++++-------
 drivers/block/rbd.c                 |    6 +-
 drivers/block/rnbd/rnbd-clt.c       |    8 +-
 drivers/block/rnbd/rnbd-srv-sysfs.c |    3 -
 drivers/block/rnbd/rnbd-srv.c       |   23 ++++----
 drivers/block/rnbd/rnbd-srv.h       |    2 
 drivers/block/sunvdc.c              |    2 
 drivers/block/swim.c                |   24 ++++----
 drivers/block/swim3.c               |   33 +++++-------
 drivers/block/ublk_drv.c            |    4 -
 drivers/block/xen-blkback/xenbus.c  |    4 -
 drivers/block/xen-blkfront.c        |    2 
 drivers/block/z2ram.c               |    8 +-
 drivers/block/zram/zram_drv.c       |   21 +++----
 drivers/cdrom/cdrom.c               |   36 +++----------
 drivers/cdrom/gdrom.c               |   12 ++--
 drivers/md/bcache/bcache.h          |    2 
 drivers/md/bcache/request.c         |    4 -
 drivers/md/bcache/super.c           |   25 ++++-----
 drivers/md/dm-cache-target.c        |   12 ++--
 drivers/md/dm-clone-target.c        |   10 +--
 drivers/md/dm-core.h                |    7 +-
 drivers/md/dm-era-target.c          |    6 +-
 drivers/md/dm-ioctl.c               |   10 +--
 drivers/md/dm-snap.c                |    4 -
 drivers/md/dm-table.c               |   11 ++--
 drivers/md/dm-thin.c                |    9 +--
 drivers/md/dm-verity-fec.c          |    2 
 drivers/md/dm-verity-target.c       |    6 +-
 drivers/md/dm.c                     |   20 +++----
 drivers/md/dm.h                     |    2 
 drivers/md/md.c                     |   50 +++++++++---------
 drivers/mmc/core/block.c            |   12 ++--
 drivers/mtd/devices/block2mtd.c     |    6 +-
 drivers/mtd/mtd_blkdevs.c           |    8 +-
 drivers/mtd/mtdblock.c              |    2 
 drivers/mtd/ubi/block.c             |    9 +--
 drivers/nvme/host/core.c            |    6 +-
 drivers/nvme/host/ioctl.c           |   66 +++++++++++++-----------
 drivers/nvme/host/multipath.c       |    6 +-
 drivers/nvme/host/nvme.h            |    4 -
 drivers/nvme/target/io-cmd-bdev.c   |    4 -
 drivers/s390/block/dasd.c           |   10 +--
 drivers/s390/block/dasd_genhd.c     |    5 +
 drivers/s390/block/dasd_int.h       |    3 -
 drivers/s390/block/dasd_ioctl.c     |    2 
 drivers/s390/block/dcssblk.c        |   11 +---
 drivers/scsi/ch.c                   |    3 -
 drivers/scsi/scsi_bsg.c             |    4 -
 drivers/scsi/scsi_ioctl.c           |   38 ++++++-------
 drivers/scsi/sd.c                   |   39 ++++++--------
 drivers/scsi/sg.c                   |    7 +-
 drivers/scsi/sr.c                   |   22 ++++----
 drivers/scsi/st.c                   |    2 
 drivers/target/target_core_iblock.c |    9 +--
 drivers/target/target_core_pscsi.c  |   10 +--
 fs/btrfs/dev-replace.c              |    6 +-
 fs/btrfs/ioctl.c                    |   12 ++--
 fs/btrfs/super.c                    |   21 ++-----
 fs/btrfs/volumes.c                  |   55 +++++++++-----------
 fs/btrfs/volumes.h                  |   11 +---
 fs/erofs/super.c                    |    7 +-
 fs/ext4/super.c                     |   11 +---
 fs/f2fs/super.c                     |   12 ++--
 fs/jfs/jfs_logmgr.c                 |    6 +-
 fs/nfs/blocklayout/dev.c            |    9 +--
 fs/nilfs2/super.c                   |   12 +---
 fs/ocfs2/cluster/heartbeat.c        |    7 +-
 fs/reiserfs/journal.c               |   19 +++---
 fs/reiserfs/reiserfs.h              |    1 
 fs/super.c                          |   33 ++++--------
 fs/xfs/xfs_super.c                  |   15 ++---
 include/linux/blkdev.h              |   68 +++++++++++-------------
 include/linux/bsg.h                 |    2 
 include/linux/cdrom.h               |   12 ++--
 include/linux/device-mapper.h       |    8 +-
 include/linux/fs.h                  |    8 --
 include/linux/mtd/blktrans.h        |    2 
 include/scsi/scsi_ioctl.h           |    4 -
 kernel/power/hibernate.c            |   12 +---
 kernel/power/power.h                |    2 
 kernel/power/swap.c                 |   28 ++++------
 mm/swapfile.c                       |    7 +-
 103 files changed, 796 insertions(+), 853 deletions(-)
