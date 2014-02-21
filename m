From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH v3 0/2] nilfs2: add support for FITRIM ioctl
Date: Fri, 21 Feb 2014 15:56:49 +0100
Message-ID: <cover.1392994051.git.andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

Hi,

This patch adds support for the FITRIM ioctl, which allows user space 
tools like fstrim to issue TRIM/DISCARD requests to the underlying 
device. It takes a fstrim_range structure as a parameter and for every 
clean segment in the specified range the function blkdev_issue_discard 
is called. The range is truncated to file system block boundaries.

I tested it with a 32 bit and 64 bit kernel. On the 32 bit system 
CONFIG_LBDAF was disabled so that sector_t was 32 bit.  

Best regards,
Andreas Rohner

---
v2->v3 (based on review by Ryusuke Konishi)
 * Fix integer overflow
 * Round range to block boundary instead of sector boundary
 * Move range check to nilfs_sufile_trim_fs()
v1->v2 (based on review by Ryusuke Konishi)
 * Remove upper limit of minlen
 * Add check for minlen
 * Round range to sector boundary instead of segment boundary
 * Fix minor bug
 * Use kmap_atomic instead of kmap
 * Move input checks to ioctl.c
 * Use nilfs_sufile_segment_usages_in_block()
--
Andreas Rohner (2):
  nilfs2: add nilfs_sufile_trim_fs to trim clean segs
  nilfs2: add FITRIM ioctl support for nilfs2

 fs/nilfs2/ioctl.c  |  46 +++++++++++++++++
 fs/nilfs2/sufile.c | 147 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/sufile.h |   1 +
 3 files changed, 194 insertions(+)

-- 
1.9.0

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
