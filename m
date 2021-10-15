From: Christoph Hellwig <hch@lst.de>
Subject: don't use ->bd_inode to access the block device size v2
Date: Fri, 15 Oct 2021 15:26:13 +0200
Message-ID: <20211015132643.1621913-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=m11Dq4cW6FA9xt6yZiLfFZy28M5hrrDxv9fMOoQKfEw=; b=uCUSRnMNJ6iAkq7Ql9eS8UB78r
        ZUKu0FwbuHM5gwIZZ5C6rzyInrghQOiMBN0Wt3ZVp4tRWfHLI5lsRPuzzNF2xoArcp7I595KhvRFq
        J8hdGD7Ai4d9Bhpx05mHeTY3p1xGxNOTGGkExIDDMTQPOwgHYOpPwe/auNS6cVLV4a2+PbLpdpdfk
        Ee5rDwTmGI3bQP+5U/IbzpGmiq8b7nlDL/YgM8KZ9/cQwCPGJWuv5jQtAUcL6AP8jfSfn2reujKLl
        SvjqEAx/nwvdXb6q0aVC2dt9aDl7DjF0HLTA2VxvJoK5OtlM5V6Iu9bvv4rwIW3QQjr+k7HfdvPMD
        GpsHUkvw==;
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-fsdevel@vger.kernel.or

Hi Jens,

various drivers currently poke directy at the block device inode, which
is a bit of a mess.  This series cleans up the places that read the
block device size to use the proper helpers.  I have separate patches
for many of the other bd_inode uses, but this series is already big
enough as-is,

Changes since v1:
 - move SECTOR_SIZE & co
 - use SECTOR_SHIFT in sb_bdev_nr_blocks
 - add a bdev_nr_bytes helper
 - reuse a variable in the SCSI target code
 - drop the block2mtd patch, a bigger rewrite for that code is pending

Diffstat:
 block/fops.c                        |    2 +-
 drivers/block/drbd/drbd_int.h       |    3 +--
 drivers/md/bcache/super.c           |    2 +-
 drivers/md/bcache/util.h            |    4 ----
 drivers/md/bcache/writeback.c       |    2 +-
 drivers/md/dm-bufio.c               |    2 +-
 drivers/md/dm-cache-metadata.c      |    2 +-
 drivers/md/dm-cache-target.c        |    2 +-
 drivers/md/dm-clone-target.c        |    2 +-
 drivers/md/dm-dust.c                |    5 ++---
 drivers/md/dm-ebs-target.c          |    2 +-
 drivers/md/dm-era-target.c          |    2 +-
 drivers/md/dm-exception-store.h     |    2 +-
 drivers/md/dm-flakey.c              |    3 +--
 drivers/md/dm-integrity.c           |    6 +++---
 drivers/md/dm-linear.c              |    3 +--
 drivers/md/dm-log-writes.c          |    4 ++--
 drivers/md/dm-log.c                 |    2 +-
 drivers/md/dm-mpath.c               |    2 +-
 drivers/md/dm-raid.c                |    6 +++---
 drivers/md/dm-switch.c              |    2 +-
 drivers/md/dm-table.c               |    3 +--
 drivers/md/dm-thin-metadata.c       |    2 +-
 drivers/md/dm-thin.c                |    2 +-
 drivers/md/dm-verity-target.c       |    3 +--
 drivers/md/dm-writecache.c          |    2 +-
 drivers/md/dm-zoned-target.c        |    2 +-
 drivers/md/md.c                     |   26 +++++++++++---------------
 drivers/nvme/target/io-cmd-bdev.c   |    4 ++--
 drivers/target/target_core_iblock.c |    4 ++--
 fs/affs/super.c                     |    2 +-
 fs/btrfs/dev-replace.c              |    3 +--
 fs/btrfs/disk-io.c                  |    2 +-
 fs/btrfs/ioctl.c                    |    4 ++--
 fs/btrfs/volumes.c                  |    8 ++++----
 fs/buffer.c                         |    4 ++--
 fs/cramfs/inode.c                   |    2 +-
 fs/ext4/super.c                     |    2 +-
 fs/fat/inode.c                      |    5 +----
 fs/hfs/mdb.c                        |    2 +-
 fs/hfsplus/wrapper.c                |    2 +-
 fs/jfs/resize.c                     |    5 ++---
 fs/jfs/super.c                      |    5 ++---
 fs/nfs/blocklayout/dev.c            |    4 ++--
 fs/nilfs2/ioctl.c                   |    2 +-
 fs/nilfs2/super.c                   |    2 +-
 fs/nilfs2/the_nilfs.c               |    2 +-
 fs/ntfs/super.c                     |    8 +++-----
 fs/ntfs3/super.c                    |    3 +--
 fs/pstore/blk.c                     |    8 +++-----
 fs/reiserfs/super.c                 |    8 ++------
 fs/squashfs/super.c                 |    5 +++--
 fs/udf/lowlevel.c                   |    5 ++---
 fs/udf/super.c                      |    9 +++------
 include/linux/blk_types.h           |   17 +++++++++++++++++
 include/linux/blkdev.h              |   17 -----------------
 include/linux/genhd.h               |   13 ++++++++++++-
 57 files changed, 118 insertions(+), 139 deletions(-)
