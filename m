From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH 0/6] nilfs2: implement tracking of live blocks
Date: Sun, 16 Mar 2014 11:47:33 +0100
Message-ID: <cover.1394966728.git.andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

Hi,

This patch set implements the tracking of live blocks in segments. This 
information is crucial in implementing better GC policies, because 
now the policies can make informed decisions about which segments have 
the biggest number of reclaimable blocks.

The difficulty in tracking live blocks is the fact, that any block can 
belong to any number of snapshots and snapshots can be deleted and 
created at any time. A block belongs to a snapshot, if the checkpoint 
number lies between de_start and de_end of the block. So if a new 
snapshot is created, all the reclaimable blocks belonging to it are no 
longer reclaimable and therefore the live block counter of the 
corresponding segment must be incremented. Conversely if a snapshot is 
removed, all the reclaimable blocks belonging to it should really be 
counted as reclaimable again and the counter must be decremented. But if 
one block belongs to two or more snapshots the counter must only be 
incremented once for the first and decremented once for the last 
snapshot.

To achieve this I used the de_rsv field of nilfs_dat_entry to store one 
of the snapshot numbers. Every time a snapshot is created/removed the 
whole DAT-File is scanned and de_rsv is updated if the snapshot number 
is between de_start and de_end. But one block can belong to an 
arbitrary number of snapshots. Here I use the fact, that the 
snapshot list is organized as a sorted linked list. So by knowing the 
previous and the next snapshot number it is possible to 
reliably determine, if a block is reclaimable or belongs to another 
snapshot. 

It is of course unacceptable to update the whole DAT-File to create one 
snapshot. So only reclaimable blocks are updated. But this leads to 
certain situations, where the counters won't be accurate. The userspace 
GC should be capable of compensating and correcting the inaccurate 
values.

Another problem is the protection period in the userspace GC. The kernel 
doesn't know anything about the userspace protection period, and it is 
therefore not reflected in the number of live blocks in a segment. For 
example if the GC policy chooses a segment that seems to have a lot of 
reclaimable blocks, it could turn out, that all of those blocks are 
still protected by the protection period.

To overcome this problem I added an additional field to su_lastdec to 
the segment usage information. Whenever the number of live blocks in a 
segment is adjusted su_lastdec is set to the current timestamp. If the 
number of live blocks was adjusted within the protection period, then 
the userspace GC policy can recognize it and choose a different segment.

Compatibility Issues:
1. su_nblocks is reused to represent the number of live blocks
   old nilfs-utils would break the file system.
2. the vd_pad field of nilfs_vdesc was not initialized to 0
   so old nilfs-utils could send arbitrary flags to the kernel

Benchmark Results:

The benchmark replays NFS-Traces to simulate a real file system load. 
The file system is filled up to 20% capacity and then the NFS-Traces are 
replayed. In parallel every 5 minutes random checkpoints are turned into 
snapshots. After 15 minutes the snapshot is turned back into a 
checkpoint.

Greedy-Policy-Runtime:       6221.712s
Cost-Benefit-Policy-Runtime: 6874.840s
Timestamp-Policy-Runtime:    13179.626s

Best regards,
Andreas Rohner

---
Andreas Rohner (6):
  nilfs2: add helper function to go through all entries of meta data
    file
  nilfs2: add new timestamp to seg usage and function to change
    su_nblocks
  nilfs2: scan dat entries at snapshot creation/deletion time
  nilfs2: add ioctl() to clean snapshot flags from dat entries
  nilfs2: add counting of live blocks for blocks that are overwritten
  nilfs2: add counting of live blocks for deleted files

 fs/nilfs2/alloc.c         | 121 +++++++++++++++++++++++++
 fs/nilfs2/alloc.h         |   6 ++
 fs/nilfs2/bmap.c          |   8 +-
 fs/nilfs2/bmap.h          |   2 +-
 fs/nilfs2/btree.c         |   3 +-
 fs/nilfs2/cpfile.c        |   7 ++
 fs/nilfs2/dat.c           | 225 +++++++++++++++++++++++++++++++++++++++++++++-
 fs/nilfs2/dat.h           |  32 ++++++-
 fs/nilfs2/direct.c        |   3 +-
 fs/nilfs2/inode.c         |   2 +
 fs/nilfs2/ioctl.c         | 109 +++++++++++++++++++++-
 fs/nilfs2/mdt.c           |   5 +-
 fs/nilfs2/page.h          |   6 +-
 fs/nilfs2/segbuf.c        |  25 ++++++
 fs/nilfs2/segbuf.h        |   4 +
 fs/nilfs2/segment.c       |  69 ++++++++++++--
 fs/nilfs2/sufile.c        |  86 +++++++++++++++++-
 fs/nilfs2/sufile.h        |  18 ++++
 include/linux/nilfs2_fs.h |  65 +++++++++++++-
 19 files changed, 772 insertions(+), 24 deletions(-)

-- 
1.9.0

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
