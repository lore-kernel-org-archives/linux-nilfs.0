From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH 0/9] nilfs2: implementation of cost-benefit GC policy
Date: Tue, 24 Feb 2015 20:01:35 +0100
Message-ID: <1424804504-10914-1-git-send-email-andreas.rohner@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

Hi everyone!

One of the biggest performance problems of NILFS is its
inefficient Timestamp GC policy. This patch set introduces two new GC
policies, namely Cost-Benefit and Greedy.

The Cost-Benefit policy is nothing new. It has been around for a long
time with log-structured file systems [1]. But it relies on accurate
information, about the number of live blocks in a segment. NILFS
currently does not provide the necessary information. So this patch set
extends the entries in the SUFILE to include a counter for the number o=
f
live blocks. This counter is decremented whenever a file is deleted or
overwritten.

Except for some tricky parts, the counting of live blocks is quite
trivial. The problem is snapshots. At any time, a checkpoint can be
turned into a snapshot or vice versa. So blocks that are reclaimable at
one point in time, are protected by a snapshot a moment later.

This patch set does not try to track snapshots at all. Instead it uses =
a
heuristic approach to prevent the worst case scenario. The performance
is still significantly better than timestamp for my benchmarks.

The worst case scenario is, the following:

1. Segment 1 is written
2. Snapshot is created
3. GC tries to reclaim Segment 1, but all blocks are protected
   by the Snapshot. The GC has to set the number of live blocks
   to maximum to avoid reclaiming this Segment again in the near future=
=2E
4. Snapshot is deleted
5. Segment 1 is reclaimable, but its counter is so high, that the GC
   will never try to reclaim it again.

To prevent this kind of starvation I use another field in the SUFILE
entry, to store the number of blocks that are protected by a snapshot.
This value is just a heuristic and it is usually set to 0. Only if the
GC reclaims a segment, it is written to the SUFILE entry. The GC has to
check for snapshots anyway, so we get this information for free. By
storing this information in the SUFILE we can avoid starvation in the
following way:

1. Segment 1 is written
2. Snapshot is created
3. GC tries to reclaim Segment 1, but all blocks are protected
   by the Snapshot. The GC has to set the number of live blocks
   to maximum to avoid reclaiming this Segment again in the near future=
=2E
4. GC sets the number of snapshot blocks in Segment 1 in the SUFILE
   entry
5. Snapshot is deleted
6. On Snapshot deletion we walk through every entry in the SUFILE and
   reduce the number of live blocks to half, if the number of snapshot
   blocks is bigger than half of the maximum.
7. Segment 1 is reclaimable and the number of live blocks entry is at
   half the maximum. The GC will try to reclaim this segment as soon as
   there are no other better choices.

BENCHMARKS:
-----------

My benchmark is quite simple. It consists of a process, that replays
real NFS traces at a faster speed. It thereby creates relatively
realistic patterns of file creation and deletions. At the same time
multiple snapshots are created and deleted in parallel. I use a 100GB
partition of a Samsung SSD:

WITH SNAPSHOTS EVERY 5 MINUTES:
--------------------------------------------------------------------
                Execution time       Wear (Data written to disk)
Timestamp:      100%                 100%
Cost-Benefit:   80%                  43%

NO SNAPSHOTS:
---------------------------------------------------------------------
                Execution time       Wear (Data written to disk)
Timestamp:      100%                 100%
Cost-Benefit:   70%                  45%

I plan on adding more benchmark results soon.

Best regards,
Andreas Rohner

[1] Mendel Rosenblum and John K. Ousterhout. The design and implementa-
    tion of a log-structured file system. ACM Trans. Comput. Syst.,
    10(1):26=E2=80=9352, February 1992.

Andreas Rohner (9):
  nilfs2: refactor nilfs_sufile_updatev()
  nilfs2: add simple cache for modifications to SUFILE
  nilfs2: extend SUFILE on-disk format to enable counting of live block=
s
  nilfs2: add function to modify su_nlive_blks
  nilfs2: add simple tracking of block deletions and updates
  nilfs2: use modification cache to improve performance
  nilfs2: add additional flags for nilfs_vdesc
  nilfs2: improve accuracy and correct for invalid GC values
  nilfs2: prevent starvation of segments protected by snapshots

 fs/nilfs2/bmap.c          |  84 +++++++-
 fs/nilfs2/bmap.h          |  14 +-
 fs/nilfs2/btree.c         |   4 +-
 fs/nilfs2/cpfile.c        |   5 +
 fs/nilfs2/dat.c           |  95 ++++++++-
 fs/nilfs2/dat.h           |   8 +-
 fs/nilfs2/direct.c        |   4 +-
 fs/nilfs2/inode.c         |  24 ++-
 fs/nilfs2/ioctl.c         |  27 ++-
 fs/nilfs2/mdt.c           |   5 +-
 fs/nilfs2/page.h          |   6 +-
 fs/nilfs2/segbuf.c        |   6 +
 fs/nilfs2/segbuf.h        |   3 +
 fs/nilfs2/segment.c       | 155 +++++++++++++-
 fs/nilfs2/segment.h       |   3 +
 fs/nilfs2/sufile.c        | 533 ++++++++++++++++++++++++++++++++++++++=
+++++---
 fs/nilfs2/sufile.h        |  97 +++++++--
 fs/nilfs2/the_nilfs.c     |   4 +
 fs/nilfs2/the_nilfs.h     |  23 ++
 include/linux/nilfs2_fs.h | 122 ++++++++++-
 20 files changed, 1126 insertions(+), 96 deletions(-)

--=20
2.3.0

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
