From: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 0/9] Remove remaining parts of congestions tracking code.
Date: Thu, 27 Jan 2022 13:46:29 +1100
Message-ID: <164325106958.29787.4865219843242892726.stgit@noble.brown>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1643251625; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=yDPdolIqP1BqbqmgH35S+RrYDCrJz/kAXtj6i96pLsQ=;
        b=hAN5Dg0REL/K5jKsVHYqM3X+M7oL7DolmPiPn5nkKXAbr4U3cj5oAi65hMwxiSWo27QmOB
        cLQTty8i2cI986CYr180STDwieVyetu7kQ3qHdYo7SeahuPrc14qirLFBA73zPbrr4po2f
        zGgWZWBXgqAPi8k0xRaMTCQlkN1djpM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1643251625;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=yDPdolIqP1BqbqmgH35S+RrYDCrJz/kAXtj6i96pLsQ=;
        b=x6ydMXUFPK4DvzDKO6csSNrS9nejdxdCvtHG4Sf6wjFPHRmP2fhorasjEjQ6+4R4FunEK1
        J47b6RQj8pZ6MXBg==
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chao Yu <chao-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ilya Dryomov <idryomov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Darrick J. Wong" <djwong-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Philipp Reisner <philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Congestion hasn't been reliably tracked for quite some time.
Most MM uses of it for guiding writeback decisions were removed in 5.16.
Some other uses were removed in 17-rc1.

This series removes the remaining places that test for congestion, and
the few places which still set it.

The second patch touches a few filesystems.  I didn't think there was
much value in splitting this out by filesystems, but if maintainers
would rather I did that, I will.

The f2fs, cephfs, fuse, NFS, and block patches can go through the
respective trees proving the final patch doesn't land until after they
all do - so maybe it should be held for 5.18-rc2 if all the rest lands
by 5.18-rc1.

Thanks,
NeilBrown

---

NeilBrown (9):
      Remove inode_congested()
      Remove bdi_congested() and wb_congested() and related functions
      f2fs: change retry waiting for f2fs_write_single_data_page()
      f2f2: replace some congestion_wait() calls with io_schedule_timeout()
      cephfs: don't set/clear bdi_congestion
      fuse: don't set/clear bdi_congested
      NFS: remove congestion control.
      block/bfq-iosched.c: use "false" rather than "BLK_RW_ASYNC"
      Remove congestion tracking framework.


 block/bfq-iosched.c              |  2 +-
 drivers/block/drbd/drbd_int.h    |  3 --
 drivers/block/drbd/drbd_req.c    |  3 +-
 fs/ceph/addr.c                   | 27 ---------------
 fs/ceph/super.c                  |  2 --
 fs/ceph/super.h                  |  2 --
 fs/ext2/ialloc.c                 |  2 --
 fs/f2fs/compress.c               |  6 ++--
 fs/f2fs/data.c                   |  9 +++--
 fs/f2fs/segment.c                | 14 ++++----
 fs/f2fs/super.c                  |  8 ++---
 fs/fuse/control.c                | 17 ----------
 fs/fuse/dev.c                    |  8 -----
 fs/nfs/sysctl.c                  |  7 ----
 fs/nfs/write.c                   | 53 +----------------------------
 fs/nilfs2/segbuf.c               | 11 ------
 fs/xfs/xfs_buf.c                 |  3 --
 include/linux/backing-dev-defs.h |  8 -----
 include/linux/backing-dev.h      | 28 ----------------
 include/linux/nfs_fs.h           |  1 -
 include/linux/nfs_fs_sb.h        |  1 -
 include/trace/events/writeback.h | 28 ----------------
 mm/backing-dev.c                 | 57 --------------------------------
 mm/vmscan.c                      |  4 +--
 24 files changed, 25 insertions(+), 279 deletions(-)

--
Signature

