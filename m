From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH v4 0/6] nilfs-utils: shortcut for certain GC operations
Date: Wed,  5 Feb 2014 03:16:33 +0100
Message-ID: <cover.1391566347.git.andreas.rohner@gmx.net>
References: <20140205.034242.281476472.konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140205.034242.281476472.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

Hi,

This patch set adds an optimized version of 
nilfs_xreclaim_segments, which has an additional parameter 
min_reclaimable_blks. This parameter specifies the minimum number of 
reclaimable blocks in a segment, before it can be cleaned. If a 
segment is below this threshold, it is considered to be not worth 
cleaning, because all the live blocks would need to be moved to a 
new segment, which is expensive, and the number of reclaimable 
blocks is too low. But it is still necessary to update the segment 
usage information to turn the old segment into a new one.
    
This is basically a shortcut to cleaning the segment. It is still 
necessary to read the segment summary information, but the writing 
of the live blocks can be skipped if it's not worth it.

Additionally new options are introduced for the configuration file 
and nilfs-clean to allow the user to specify the threshold. 

This is potentially useful for all gc policies, but it is especially
beneficial for the timestamp policy. Lets assume for example a NILFS2
volume with 20% static files and lets assume these static files 
are in the oldest segments. The current timestamp policy will 
select the oldest segments and, since the data is static, move 
them mostly unchanged to new segments. After a while they will 
become the oldest segments again. Then timestamp will move them 
again. These moving operations are expensive and unnecessary.

Regards,
Andreas Rohner

---
v3->v4
* nilfs-utils: Rebase on refactored nilfs_reclaim_segments (Ryusuke)
* nilfs-utils: Add no_timeout if cleaning was deferred
v2->v3
* Alignment in nilfs_suinfo_update
* Add missing comments
* nilfs2: Extra validity checks in nilfs_sufile_set_suinfo
* nilfs2: Update sh_ncleansegs, sh_ndirtysegs if flags change
* nilfs2: Fix bugs in nilfs_sufile_set_suinfo
* nilfs2: Use vmalloc instead of ioctl_wrap_copy
* nilfs-utils: Separate nilfs_relaim_segments_with_threshold
* nilfs-utils: Allow different units for min_reclaimable_blocks
* nilfs-utils: Introduce flag to disable the optimization
* nilfs-utils: Disable optimization if kernel retruns ENOTTY
* nilfs-utils: Remove EGCTRYAGAIN error return code
* nilfs-utils: Rename option to min_reclaimable_blocks
v1->v2
* Implementation of NILFS_IOCTL_SET_SUINFO
* Added mc_min_free_blocks_threshold config option
  (if clean segments < min_clean_segments)
* Added new command line param for nilfs-clean
* Update man- and config-file
--
Andreas Rohner (6):
  nilfs-utils: cldconfig add an option to set min. reclaimable blocks
  nilfs-utils: add NILFS_OPT_SET_SUINFO
  nilfs-utils: nilfs-clean add cmdline param min-reclaimable-blocks
  nilfs-utils: add suport for NILFS_IOCTL_SET_SUINFO ioctl
  nilfs-utils: add optimized version of nilfs_reclaim_segments
  nilfs-utils: add a no_timeout flag to enable faster loop

 include/nilfs.h                   |   9 +-
 include/nilfs2_fs.h               |  43 ++++++++++
 include/nilfs_cleaner.h           |  19 +++--
 include/nilfs_gc.h                |   7 +-
 lib/gc.c                          |  63 +++++++++++++-
 lib/nilfs.c                       |  63 ++++++++++++++
 man/nilfs-clean.8                 |   4 +
 man/nilfs_cleanerd.conf.5         |  22 +++++
 sbin/cleanerd/cldconfig.c         | 168 ++++++++++++++++++++++++++++----------
 sbin/cleanerd/cldconfig.h         |   8 ++
 sbin/cleanerd/cleanerd.c          |  55 ++++++++++++-
 sbin/cleanerd/nilfs_cleanerd.conf |  13 +++
 sbin/nilfs-clean/nilfs-clean.c    |  44 ++++++++--
 13 files changed, 450 insertions(+), 68 deletions(-)

-- 
1.8.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
