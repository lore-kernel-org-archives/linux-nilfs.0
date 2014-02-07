From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH v6 0/6] nilfs-utils: shortcut for certain GC operations
Date: Fri,  7 Feb 2014 13:16:15 +0100
Message-ID: <cover.1391774956.git.andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
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
v5->v6 (based on review by Ryusuke Konishi)
* Add support for percent in nilfs-clean -m argument
* Change location of nilfs_opt_test_set_suinfo check
* Change interpretation of stat.cleaned_segs and stat.deferred_segs
  to be not exclusive

v4->v5 (based on review by Ryusuke Konishi)
* Add missing comments and documentation
* Fix nilfs_set_suinfo return value
* Fix coding style issues
* Return error if invalid min_reclaimable_blocks is sent 
  from nilfs-clean command
* Use nilfs_vector instead of malloc in nilfs_xreclaim_segment
* Rename nilfs_reclaim_params flag to
  NILFS_RECLAIM_PARAM_MIN_RECLAIMABLE_BLKS
* Changed the interpretation of deferred_segs in 
  nilfs_reclaim_stat

v3->v4 (based on review by Ryusuke Konishi)
* nilfs-utils: Rebase on refactored nilfs_reclaim_segments 
  (by Ryusuke Konishi)
* nilfs-utils: Add no_timeout if cleaning was deferred

v2->v3 (based on review by Ryusuke Konishi)
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

v1->v2 (based on review by Ryusuke Konishi)
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
  nilfs-utils: add optimized version of nilfs_xreclaim_segments
  nilfs-utils: add a no_timeout flag to enable faster loop

 include/nilfs.h                   |   9 +-
 include/nilfs2_fs.h               |  44 ++++++++++
 include/nilfs_cleaner.h           |  43 +++++++---
 include/nilfs_gc.h                |  11 +--
 lib/gc.c                          |  74 +++++++++++++++--
 lib/nilfs.c                       |  59 +++++++++++++
 man/nilfs-clean.8                 |   7 ++
 man/nilfs_cleanerd.conf.5         |  22 +++++
 sbin/cleanerd/cldconfig.c         | 169 ++++++++++++++++++++++++++++----------
 sbin/cleanerd/cldconfig.h         |  12 +++
 sbin/cleanerd/cleanerd.c          | 100 ++++++++++++++++++++--
 sbin/cleanerd/nilfs_cleanerd.conf |  20 +++++
 sbin/nilfs-clean/nilfs-clean.c    |  58 +++++++++++--
 13 files changed, 549 insertions(+), 79 deletions(-)

-- 
1.8.5.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
