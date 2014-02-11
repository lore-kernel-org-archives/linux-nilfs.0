From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] lssu: fix protection period option
Date: Tue, 11 Feb 2014 12:10:31 +0900
Message-ID: <1392088231-9344-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Fix a bug of nilfs_get_latest_usage() function which blocks the
protection period specified with -p option from being passed to
nilfs_assess_segment() function and results in incorrect output of
live block counts.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 bin/lssu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/bin/lssu.c b/bin/lssu.c
index a452d19..1873957 100644
--- a/bin/lssu.c
+++ b/bin/lssu.c
@@ -137,7 +137,7 @@ static ssize_t lssu_get_latest_usage(struct nilfs *nilfs,
 	__u64 segnums[1];
 	int ret;
 
-	if (protcno == NILFS_CNO_MAX) {
+	if (protcno != NILFS_CNO_MAX) {
 		params.flags |= NILFS_RECLAIM_PARAM_PROTCNO;
 		params.protcno = protcno;
 	}
-- 
1.7.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
