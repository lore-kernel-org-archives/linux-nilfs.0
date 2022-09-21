From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] nilfs2: delete unnecessary checks before brelse()
Date: Wed, 21 Sep 2022 12:48:02 +0900
Message-ID: <20220921034803.2476-2-konishi.ryusuke@gmail.com>
References: <20220921034803.2476-1-konishi.ryusuke@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=zuUTrKEQfr4sTAkgNNcxkQQm8I/DlTKY/sYvpN04CR0=;
        b=UQ0NYQxyERDLPcyJTHUVOAlubjXits94UXZaEE8wQN5td+CsnsaZPwiMBon6QtK4YI
         lmpzLrH2r3Xg6zlv36JgVKynEauD/hPI8QWUwSLVpQ5CXDaBF9pHK2Beqat0ZPYKLPCx
         2l09Fcrr3//pD6/aV6YFZ7Qad5NT5XfGnSQntyYOV//0qNGbvSEI2Ds54km2Abrc07pX
         VkisyPGoXZHLRWNaripFL1ZMNVDAzjJVnqvsSCgdADYfau4TySmIkX1O1LRx73WNXNrC
         w6UWGb4Ri4u8xJQUMSbd/EnQO85UBjyhFgaGDy+TLPrrBtPKmvh3K34AH8oKZMqtQWiR
         9b1A==
In-Reply-To: <20220921034803.2476-1-konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

From: Minghao Chi <chi.minghao-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

The brelse() inline function tests whether its argument is NULL
and then returns immediately.
Thus remove the tests which are not needed around the shown calls.

Link: https://lkml.kernel.org/r/20220819081700.96279-1-chi.minghao-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org
Reported-by: Zeal Robot <zealci-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
Signed-off-by: Minghao Chi <chi.minghao-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/nilfs2/btree.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 9f4d9432d38a..b9d15c3df3cc 100644
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
2.34.1

