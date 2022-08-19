From: cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] nilfs2: delete unnecessary checks before brelse()
Date: Fri, 19 Aug 2022 08:17:00 +0000
Message-ID: <20220819081700.96279-1-chi.minghao@zte.com.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=sWp63BpVW8U7jAJS0MU5jHAUsPkleFN5R+CfvsKi3C8=;
        b=C6E1jDISCgMWDW9pnZhE7J0+TOlfLs/SL0BvEnbhBl1cOaLOXPUkG0PsMKXga8lGMf
         S2wHURTITV1Rq9JkhGaTwKlby/7FSHfRAIPScHpHSMT3YjsBMELwfC8ipcrB464GrD9h
         ZnJjlI6vdcoh0J+8Cyay7v86g01ubH4NdCXSZqylVbyit+YHsruhkTAkIT62SuJ09kiX
         hwh+ogQuE+SpWKDkY7qLQNHDWxp287xo5wQ7QCtE/P9sEfHcRkIJGifHtkQfRbJUcGHY
         RNGtxDVImZlWR/qzbM2CWJPwn243C+fiGciyO9ooeAdtPheFINVJaw6zGFirPIHpyXvj
         1oSg==
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Minghao Chi <chi.minghao-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>, Zeal Robot <zealci-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

From: Minghao Chi <chi.minghao-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

The brelse() function tests whether its argument is NULL
and then returns immediately.
Thus remove the tests which are not needed around the shown calls.

Reported-by: Zeal Robot <zealci-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
Signed-off-by: Minghao Chi <chi.minghao-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
---
 fs/nilfs2/btree.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index f544c22fff78..b3b5a46488c2 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -1668,8 +1668,7 @@ static int nilfs_btree_check_delete(struct nilfs_bmap *btree, __u64 key)
 	maxkey = nilfs_btree_node_get_key(node, nchildren - 1);
 	nextmaxkey = (nchildren > 1) ?
 		nilfs_btree_node_get_key(node, nchildren - 2) : 0;
-	if (bh != NULL)
-		brelse(bh);
+	brelse(bh);
 
 	return (maxkey == key) && (nextmaxkey < NILFS_BMAP_LARGE_LOW);
 }
@@ -1717,8 +1716,7 @@ static int nilfs_btree_gather_data(struct nilfs_bmap *btree,
 		ptrs[i] = le64_to_cpu(dptrs[i]);
 	}
 
-	if (bh != NULL)
-		brelse(bh);
+	brelse(bh);
 
 	return nitems;
 }
-- 
2.25.1
