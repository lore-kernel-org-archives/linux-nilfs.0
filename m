From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH v2 0/5] nilfs-utils: skip inefficient gc operations
Date: Tue, 21 Jan 2014 14:59:39 +0100
Message-ID: <cover.1390310509.git.andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

Hi,

This is the second version of this patch set. It replaces the kind of 
hacky use of v_flags with a proper implementation of 
NILFS_IOCTL_SET_SUINFO ioctl.

v1->v2
* Implementation of NILFS_IOCTL_SET_SUINFO
* Added mc_min_free_blocks_threshold config option
  (if clean segments < min_clean_segments)
* Added new command line param for nilfs-clean
* Update man- and config-files
* Simpler benchmark

This patch set implements a small new feature and there shouldn't be
any compatibility issues. It enables the GC to check how much free
space can be gained from cleaning a segment and if it is less than a
certain threshold it will abort the operation and try a different
segment. Although no blocks need to be moved, the SUFILE entry of the
corresponding segment needs to be updated to avoid an infinite loop.

This is potentially useful for all gc policies, but it is especially
beneficial for the timestamp policy. Lets assume for example a NILFS2
volume with 20% static files and lets assume these static files are in 
the oldest segments. The current timestamp policy will select the oldest 
segments and, since the data is static, move them mostly unchanged to 
new segments. After a while they will become the oldest segments again. 
Then timestamp will move them again. These moving operations are 
expensive and unnecessary.

I used a simple benchmark to test the patch set (only a few lines of C). 
I used a 100 GB partition and performed the following steps:

1. Write a 20 GB file
2. Write a 50 GB file
3. Overwrite chunks of 1 MB within the 50 GB file at random
4. Repeat step 3 until 60 GB of data is written

Steps 3 and 4 are only perfomed to get the GC started. So the benchmark 
writes a 130 GB in total to a 100 GB partition.

HHD:
    Timestamp GB Written: 340.7574
    Timestamp GB Read:    208.2935
    Timestamp Runtime:    7787.546s

    Patched GB Written:   313.2566
    Patched GB Read:      182.6389
    Patched Runtime:      7410.892s

SSD:
    Timestamp GB Written: 679.3901
    Timestamp GB Read:    242.59
    Timestamp Runtime:    3022.081s

    Patched GB Written:   500.0095
    Patched GB Read:      157.475   
    Patched Runtime:      2313.448

The results for the HDD clearly show, that about 20 GB less data has 
been written and read in the patched version. It is reasonable to 
assume, that these 20 GB are the static data.

The speed of the GC was tuned to the HDD. It was probably too aggressive 
for the much faster SSD. That is probably the reason why the difference 
in GB written and read is much higher than 20 GB.

Best regards,
Andreas Rohner 
---
Andreas Rohner (5):
  nilfs-utils: cldconfig add an option to set minimal free blocks
  nilfs-utils: cleanerd: add custom error value to enable fast retry
  nilfs-utils: refactoring of nilfs_reclaim_segment to add minblocks
    param
  nilfs-utils: add support for NILFS_IOCTL_SET_SUINFO ioctl
  nilfs-utils: man: add description of min_free_blocks_threshold

 include/nilfs.h                   |  2 ++
 include/nilfs2_fs.h               | 41 ++++++++++++++++++++++++++++++++
 include/nilfs_cleaner.h           | 19 ++++++++-------
 include/nilfs_gc.h                |  6 +++--
 lib/gc.c                          | 49 ++++++++++++++++++++++++++++++++++++---
 lib/nilfs.c                       | 26 +++++++++++++++++++++
 man/nilfs-clean.8                 |  4 ++++
 man/nilfs_cleanerd.conf.5         |  9 +++++++
 sbin/cleanerd/cldconfig.c         | 40 ++++++++++++++++++++++++++++++++
 sbin/cleanerd/cldconfig.h         |  4 ++++
 sbin/cleanerd/cleanerd.c          | 38 +++++++++++++++++++++++++++---
 sbin/cleanerd/nilfs_cleanerd.conf |  9 +++++++
 sbin/nilfs-clean/nilfs-clean.c    | 18 ++++++++++----
 sbin/nilfs-resize/nilfs-resize.c  |  2 +-
 14 files changed, 245 insertions(+), 22 deletions(-)

-- 
1.8.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
