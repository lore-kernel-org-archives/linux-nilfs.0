From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH 0/4] nilfs-utils: new feature to skip inefficient gc
Date: Sun, 19 Jan 2014 15:01:38 +0100
Message-ID: <cover.1390139797.git.andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

Hi,

This patch set implements a small new feature and there shouldn't be
any compatibility issues. It enables the GC to check how much free
space can be gained from cleaning a segment and if it is less than a
certain threshold it will abort the operation and try a different
segment. Although no blocks need to be moved, the SUFILE entry of the
corresponding segment needs to be updated to avoid an infinite loop.

This is potentially useful for all gc policies, but it is especially
beneficial for the timestamp policy. Lets assume for example a NILFS2
volume with 20% static files, which is not unreasonable, and lets assume these
static files are in the oldest segments. So the current timestamp
policy will select the oldest segments and since the data is static
it needs to be moved to new segments. Now it is in the newest segments,
but after a while they will become the oldest segments again. Then
timestamp will move them again. These moving operations are expensive
and unnecessary.

I designed a benchmark that uses a fresh NILFS2 volume, initialized
with 20% static data. Above that, normal file operations are simulated,
but the static data is never touched. These are the results:

SSD:
    Timestamp GB Written: 1857.88
    Timestamp GB Read:    711.1417
    Timestamp Runtime:    10724.27s

    Patched GB Written:   823.6395
    Patched GB Read:      222.1085
    Patched Runtime:      6374.93s

HDD:
    Timestamp GB Written: 609.026
    Timestamp GB Read:    382.4147
    Timestamp Runtime:    13123.15s

    Patched GB Written:   423.8563
    Patched GB Read:      199.2632
    Patched Runtime:      9460.73s

Admittedly the benchmark is a bit biased to highlight the problem. On a
real system the static data won't be so completely static and so the
performance improvements are probably not so extreme.

This is my first patch set to this mailing list. I hope 
everything is formally correct.

Best regards,
Andreas Rohner

Andreas Rohner (4):
  nilfs-utils: cldconfig add an option to set minimal free blocks
  nilfs-utils: cleanerd: add custom error value to enable fast retry
  nilfs-utils: refactoring of nilfs_reclaim_segment to add minblocks
    param
  nilfs-utils: add support for and define some nilfs_argv flags

 include/nilfs.h                  |  2 +-
 include/nilfs2_fs.h              |  6 ++++++
 include/nilfs_gc.h               |  6 ++++--
 lib/gc.c                         | 21 +++++++++++++++++----
 lib/nilfs.c                      |  3 ++-
 sbin/cleanerd/cldconfig.c        | 20 ++++++++++++++++++++
 sbin/cleanerd/cldconfig.h        |  2 ++
 sbin/cleanerd/cleanerd.c         | 15 ++++++++++++---
 sbin/nilfs-resize/nilfs-resize.c |  2 +-
 9 files changed, 65 insertions(+), 12 deletions(-)

-- 
1.8.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
