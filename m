From: Anand Jain <anand.jain@oracle.com>
Subject: Re: don't use ->bd_inode to access the block device size
Date: Wed, 13 Oct 2021 15:14:55 +0800
Message-ID: <6d96d52b-3a19-8e00-4089-c2483a4cdbcc@oracle.com>
References: <20211013051042.1065752-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=tw7w8HaA6+b3R9ce+G4pr9Q+e3Aor6MTcRv59KVHYqc=;
 b=t1G2ukmQPvUbrQ6WaL+XxNwsfxufdOJelwM0tMIX/LkupVmQbe8bW0sm0IJKg65ljTqJ
 2petZcdXTNS1sNzJ2M3YNYqGvLDs4DPpn9i+G6FYC3Z2vVhFOi3LIKqD/T99Fuce8H2A
 SU6DJfqKIJ9WB0y761L5JaSpPDhe5+LZI+26S1Gwe65Std1kR6RJdZfMgApku/FhaBB0
 B28dWZE8qZyExX5CDCDwNHz3Hx+24H02rxf0+Z5+C3n8W1jpbtqwDkXd1b3yQypJPKxa
 IqNG5ykf+T/+NG/h9ZZiqgMwirxMDI8GRA0FIcrvEABvx2THKY0jzUjx2+t4fCz9UVlB sQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tw7w8HaA6+b3R9ce+G4pr9Q+e3Aor6MTcRv59KVHYqc=;
 b=Um+Qs0fPjbYJf+adG21vf2cGKDogXwAv1GE+9qe3lM1AzTKluhFhoozG9l/Dd2FtHMcwr0VTuzM6SvSbiuzRIBZYg6zL1T74RQpteUEWL6594r4A6NzPEELyO0fbDTvypRz+DBSf2jeHgPbPjo5e7jijXN49eKkcKsQW2b2OKT4=
In-Reply-To: <20211013051042.1065752-1-hch@lst.de>
Content-Language: en-US
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 13/10/2021 13:10, Christoph Hellwig wrote:
> Hi Jens,
> 
> various drivers currently poke directy at the block device inode, which
> is a bit of a mess.  This series cleans up the places that read the
> block device size to use the proper helpers.  I have separate patches
> for many of the other bd_inode uses, but this series is already big
> enough as-is,
> 
> I wondered about adding a helper for looking at the size in byte units
> to avoid the SECTOR_SHIFT shifts in various places.  But given that
> I could not come up with a good name and 


> block devices fundamentally
> work in sector size granularity I decided against that.

Yes.  However,  POV of its usage outside the block-layer, a wrapper 
helper is a lot better. No.? If you agree, how about naming it bdev_size()?

Thanks, Anand

> 
> Diffstat:
>   block/fops.c                        |    2 +-
>   drivers/block/drbd/drbd_int.h       |    3 +--
>   drivers/md/bcache/super.c           |    2 +-
>   drivers/md/bcache/util.h            |    4 ----
>   drivers/md/bcache/writeback.c       |    2 +-
>   drivers/md/dm-bufio.c               |    2 +-
>   drivers/md/dm-cache-metadata.c      |    2 +-
>   drivers/md/dm-cache-target.c        |    2 +-
>   drivers/md/dm-clone-target.c        |    2 +-
>   drivers/md/dm-dust.c                |    5 ++---
>   drivers/md/dm-ebs-target.c          |    2 +-
>   drivers/md/dm-era-target.c          |    2 +-
>   drivers/md/dm-exception-store.h     |    2 +-
>   drivers/md/dm-flakey.c              |    3 +--
>   drivers/md/dm-integrity.c           |    6 +++---
>   drivers/md/dm-linear.c              |    3 +--
>   drivers/md/dm-log-writes.c          |    4 ++--
>   drivers/md/dm-log.c                 |    2 +-
>   drivers/md/dm-mpath.c               |    2 +-
>   drivers/md/dm-raid.c                |    6 +++---
>   drivers/md/dm-switch.c              |    2 +-
>   drivers/md/dm-table.c               |    3 +--
>   drivers/md/dm-thin-metadata.c       |    2 +-
>   drivers/md/dm-thin.c                |    2 +-
>   drivers/md/dm-verity-target.c       |    3 +--
>   drivers/md/dm-writecache.c          |    2 +-
>   drivers/md/dm-zoned-target.c        |    2 +-
>   drivers/md/md.c                     |   26 +++++++++++---------------
>   drivers/mtd/devices/block2mtd.c     |    5 +++--
>   drivers/nvme/target/io-cmd-bdev.c   |    4 ++--
>   drivers/target/target_core_iblock.c |    5 +++--
>   fs/affs/super.c                     |    2 +-
>   fs/btrfs/dev-replace.c              |    2 +-
>   fs/btrfs/disk-io.c                  |    3 ++-
>   fs/btrfs/ioctl.c                    |    4 ++--
>   fs/btrfs/volumes.c                  |    7 ++++---
>   fs/buffer.c                         |    4 ++--
>   fs/cramfs/inode.c                   |    2 +-
>   fs/ext4/super.c                     |    2 +-
>   fs/fat/inode.c                      |    5 +----
>   fs/hfs/mdb.c                        |    2 +-
>   fs/hfsplus/wrapper.c                |    2 +-
>   fs/jfs/resize.c                     |    5 ++---
>   fs/jfs/super.c                      |    5 ++---
>   fs/nfs/blocklayout/dev.c            |    4 ++--
>   fs/nilfs2/ioctl.c                   |    2 +-
>   fs/nilfs2/super.c                   |    2 +-
>   fs/nilfs2/the_nilfs.c               |    3 ++-
>   fs/ntfs/super.c                     |    8 +++-----
>   fs/ntfs3/super.c                    |    3 +--
>   fs/pstore/blk.c                     |    4 ++--
>   fs/reiserfs/super.c                 |    7 ++-----
>   fs/squashfs/super.c                 |    5 +++--
>   fs/udf/lowlevel.c                   |    5 ++---
>   fs/udf/super.c                      |    9 +++------
>   include/linux/genhd.h               |    6 ++++++
>   56 files changed, 100 insertions(+), 117 deletions(-)
> 

