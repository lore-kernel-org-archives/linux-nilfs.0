From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: [PATCH] fs/nilfs2: remove some unused macros to tame gcc
Date: Thu, 10 Dec 2020 07:25:33 +0900
Message-ID: <1607552733-24292-1-git-send-email-konishi.ryusuke@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=8wQM6SGZhatAmTI9tOUrGWUVSmmno5n0WNRbEje9OEI=;
        b=mknZQBlUBpIaNmmNfvrzMywLKXW4Mw/vpLFSF0lCvqdUXWAbNTm6tJpl1wSsvVVn1p
         rfOHDGKYlBc3jpgydISN+WfsMekyHOepRVQuW4ZF2LqzlHoBZ3ypp52MJdrXtUa2gn+H
         pGfyNBh2DI537zi05lWJXgZR4Ed6EGm29VuhvKL61xa3nkhPnIbG+BlqybWBiIPkHZsx
         A39rfywAUbdFqRGkZ1S/nDWr0bpmBrC0PhPPoojGO8lTmq8BnFMICRei04QLHP5J3wgb
         w+JK2dj44tukjDJs9x6PUsqZ+JvSs+XIVgif168fbGvwLUKzXoYXuMUDLt/qxs/dR5mG
         tuAg==
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

From: Alex Shi <alex.shi@linux.alibaba.com>

There some macros are unused and cause gcc warning. Remove them.

fs/nilfs2/segment.c:137:0: warning: macro "nilfs_cnt32_gt" is not used
[-Wunused-macros]
fs/nilfs2/segment.c:144:0: warning: macro "nilfs_cnt32_le" is not used
[-Wunused-macros]
fs/nilfs2/segment.c:143:0: warning: macro "nilfs_cnt32_lt" is not used
[-Wunused-macros]

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
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

