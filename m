From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH] fs/nilfs2: remove some unused macros to tame gcc
Date: Fri,  6 Nov 2020 13:48:33 +0800
Message-ID: <1604641713-6484-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

There some macros are unused and cause gcc warning. Remove them.

fs/nilfs2/segment.c:137:0: warning: macro "nilfs_cnt32_gt" is not used
[-Wunused-macros]
fs/nilfs2/segment.c:144:0: warning: macro "nilfs_cnt32_le" is not used
[-Wunused-macros]
fs/nilfs2/segment.c:143:0: warning: macro "nilfs_cnt32_lt" is not used
[-Wunused-macros]

Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> 
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org 
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org 
---
 fs/nilfs2/segment.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index e3726aca28ed..cd4da9535aed 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -134,14 +134,9 @@ struct nilfs_sc_operations {
 static void nilfs_segctor_do_immediate_flush(struct nilfs_sc_info *);
 static void nilfs_dispose_list(struct the_nilfs *, struct list_head *, int);
 
-#define nilfs_cnt32_gt(a, b)   \
-	(typecheck(__u32, a) && typecheck(__u32, b) && \
-	 ((__s32)(b) - (__s32)(a) < 0))
 #define nilfs_cnt32_ge(a, b)   \
 	(typecheck(__u32, a) && typecheck(__u32, b) && \
 	 ((__s32)(a) - (__s32)(b) >= 0))
-#define nilfs_cnt32_lt(a, b)  nilfs_cnt32_gt(b, a)
-#define nilfs_cnt32_le(a, b)  nilfs_cnt32_ge(b, a)
 
 static int nilfs_prepare_segment_lock(struct super_block *sb,
 				      struct nilfs_transaction_info *ti)
-- 
1.8.3.1

