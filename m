From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH] cldconfig: fix inconsistency in rounding percent values
Date: Tue, 11 Feb 2014 11:50:09 +0100
Message-ID: <9d514116552f5e31b7a867e695abd8fefce8e025.1392115778.git.andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

The number of blocks calculated from a percent value given to the
-min-reclaimable-blocks command line parameter of nilfs-clean is rounded
up. The same percent value in the configuration file is not rounded up.
This patch fixes the inconsistency by rounding up both values.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 sbin/cleanerd/cldconfig.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sbin/cleanerd/cldconfig.c b/sbin/cleanerd/cldconfig.c
index bdd8c85..c8b197b 100644
--- a/sbin/cleanerd/cldconfig.c
+++ b/sbin/cleanerd/cldconfig.c
@@ -472,7 +472,8 @@ nilfs_convert_size_to_blocks_per_segment(struct nilfs *nilfs,
 	if (param->unit == NILFS_SIZE_UNIT_NONE) {
 		ret = param->num;
 	} else if (param->unit == NILFS_SIZE_UNIT_PERCENT) {
-		ret = (nilfs_get_blocks_per_segment(nilfs) * param->num) / 100;
+		ret = (nilfs_get_blocks_per_segment(nilfs) * param->num + 99)
+				/ 100;
 	} else {
 		block_size = nilfs_get_block_size(nilfs);
 		segment_size = block_size *
-- 
1.8.5.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
