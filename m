Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4ED36D9EE
	for <linux-nilfs@vger.kernel.org>; Fri, 17 Jul 2026 04:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784263252; cv=none; b=pRxxEYrzGuNvHPrDtgVFHStub6gR8mqCyNgxU5Fg/r+3p5WC1029UUo7KlmjYNVTKaOEWzCJsKlEAxiFw5R56BAL7Xdg1AKWNkVAih4pJ536aIElUiiWS2vM7Y2YY+RLsd2oiQ7wke3YXS6rLrAXuhkaLLgt5Z58aQSlATPAob8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784263252; c=relaxed/simple;
	bh=ibjRgNu+sb+l/5C/6V9yv9kgZ6Wvymzgh2mWjoJawNw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Risg2YjWZNi1r4DzLGqjZGHmmz5ahz4OmiOxrBltdlA0gE0tEGvnI1p4yLmrG/Tg6oOhIQ66LmfVLpdlH/Jt1j7SdZu6n/IpzuT/GzQORS/FVKi9gQHeA9nGiU1Z4cxWI4jzAqype0Jo/y/6R1GSHe48q52AXkLMQtZ3GDe5zJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qoq+6bDc; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qoq+6bDc"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-38511175ad3so6176483a91.2
        for <linux-nilfs@vger.kernel.org>; Thu, 16 Jul 2026 21:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784263248; x=1784868048; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5ebZeX2Y3/4ooTohYbbIM7IFOTRj/UajhZ6G3Yjs6Hw=;
        b=Qoq+6bDcHOORAD6YNDEmX8pY1MfUzTrQIhHB3LltoR4seWrjorLTGCoDg32XEmOfna
         91g83/i7UrtWW+lo8YCrblK2pdbcUOxinnHsQEiX/1AS5SrZMbC/bt2evHGoXR8XKg1p
         pugOwigeCtMINbB1IgNjAPyVhmEg6DtljZE6ReMNoozbZmnTX9D0K35ZHpQptvhDrBA1
         /o7PVSBC4fXqmJiv2my4sKvAnx9h+oBxW95PO4sJWqTvSs/btV9ZVJ93dsFE7qLadlf/
         sO57kHEa7tFa0pUbjJm2JG7VPTJRlIFVbJ8bKLyJ4htS+f9KrCMlFKW9ja4DZgsGEhCX
         fUyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784263248; x=1784868048;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5ebZeX2Y3/4ooTohYbbIM7IFOTRj/UajhZ6G3Yjs6Hw=;
        b=G1h8I2dXhxpcjn88WRbeCW4P22k4RdVx01aScdp/9yGlqZ38u2/Jl/jQriHdOihass
         NsBd9XlqVxEA+BDgYLRSHKg98nNAAlOpd6hgPDmiDZgT6At9HztsOwGGIm9FSZK9quP9
         7IrMhvt6XgCgwaSpuyU4R4JYIW8fHOUJ5brikmpGV4vmQrPWLyurq66XL5V9eI6QVcl2
         RYnj/75vu3b4IWw/2klFnLGf7y7a9+lFfJbA9wt62vxXvV2/OT4vnksPmIxvSy4xsxIt
         0RqBkYdzGqI82bFNnniPTVdoGBKnMkDaygLvh80pzc+UIEcBcVwLhXVsLfj6y1RU04WR
         hIhg==
X-Gm-Message-State: AOJu0YxTm0/fsEL521eQ15hRflwUDNbEN5E0/FP3iWKvQLDc/c0Wx9a4
	Ys3pHOJGm7tUu1h9B+cjqt8RwYAOBNSInntgbaZB5QRl2k+G1jm1wRlE
X-Gm-Gg: AfdE7cnAfVLUpfDx7WmTJgnVrotK0K17c0fNFeodSI8is8Mw5x3bJZ6wq5s6rgdVD2I
	u2kSF79HGtPtqFtT+Q2nqIIV0HtamXgylHDETmp3wEsUcvuiamP59ZLUSwJGal4jpjpf5adU8Fq
	Tm9dCS0Ndq8XoTUhPLfk+ioCGGdNVJGtAGfFysOEMl4+zCWovma+AADxNesK6IP7bqwhWnDTsXS
	IMMfRrqnc7fdcyHZYLwfWG7S0sjq7qLO7zBff2Aa4X/3/CA1aJEbjXKAaUwnvTdn6w6s2BjQ7Xm
	AjTXR/oW/iwURnAos/uQZykxyX7IkqdrsWTU1vjE1hByLphNiyiHkR8QBRNuu0O1HaRd1ekqNPD
	DgnV6z9mHmA1/bDNA/goJ8v/Rm8cReqbJ1BfQ3TwPFHU5aVd5KtOvJmPTBsyUdlFy+eckGvfysY
	CEvvqWIL2FJ+fdKyVdwBCRG3hW5gl9dplmO79wE3MoZY0l4g==
X-Received: by 2002:a17:90b:2703:b0:38e:2e16:859b with SMTP id 98e67ed59e1d1-38e4b513e04mr875584a91.20.1784263248080;
        Thu, 16 Jul 2026 21:40:48 -0700 (PDT)
Received: from carrot.taila25129.ts.net (madb688455.ap.nuro.jp. [219.104.132.85])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e4b0e9b9dsm339642a91.9.2026.07.16.21.40.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 21:40:47 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Subject: [PATCH] nilfs2: fix slab-out-of-bounds in nilfs_direct_propagate after truncation
Date: Fri, 17 Jul 2026 13:39:43 +0900
Message-ID: <20260717044045.137808-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Shuangpeng Bai reported that KASAN detected a slab-out-of-bounds error
in nilfs_direct_propagate() during testing.

Analysis revealed that after truncating a file, a node block immediately
below the B-tree root was not deleted.  Instead, it remained in the B-tree
node cache in a dirty state.  The log writer subsequently detected this
block and incorrectly invoked nilfs_direct_propagate() on it, which is
designed to handle only data blocks in direct mapping.

B-tree nodes in the cache are managed by virtual block numbers, and their
logical keys typically exceed the range expected by direct mapping.
Consequently, processing such a node as a direct mapping entry triggers
a slab-out-of-bounds access.

The root cause is that when a B-tree mapping collapses into a direct
mapping during truncation, an intermediate node block pointed to by the
root node is left behind as garbage instead of being explicitly deleted.

This resolves the issue by adding a nilfs_btree_discard() operation
to delete the remaining intermediate node block during the conversion.
A 'deform' flag is added to the bop_delete interface to explicitly signal
that the deletion is part of a mapping transformation.  This allows the
B-tree mapping implementation to perform the necessary cleanup and
discarding of the residual node structure that would be otherwise be left
orphaned after the transition.

Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Closes: https://lore.kernel.org/r/08A3603A-ADB6-484C-9015-9AC1340E6FB8@gmail.com
Fixes: 36a580eb489f ("nilfs2: direct block mapping")
Cc: stable@vger.kernel.org
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
Hi Viacheslav,

Please apply this for the next cycle.

This fixes a flaw in the original B-tree implementation related to truncation
and resolves the reported out-of-bounds memory access issue.

Thanks,
Ryusuke Konishi

 fs/nilfs2/bmap.c   |  2 +-
 fs/nilfs2/bmap.h   |  2 +-
 fs/nilfs2/btree.c  | 39 ++++++++++++++++++++++++++++++++-------
 fs/nilfs2/direct.c |  4 ++--
 4 files changed, 36 insertions(+), 11 deletions(-)

diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
index 5f0f1f283af0..83f6ea30cc8b 100644
--- a/fs/nilfs2/bmap.c
+++ b/fs/nilfs2/bmap.c
@@ -175,7 +175,7 @@ static int nilfs_bmap_do_delete(struct nilfs_bmap *bmap, __u64 key)
 			return ret;
 	}
 
-	return bmap->b_ops->bop_delete(bmap, key);
+	return bmap->b_ops->bop_delete(bmap, key, false);
 }
 
 /**
diff --git a/fs/nilfs2/bmap.h b/fs/nilfs2/bmap.h
index 4656df392722..a72f3c308a5d 100644
--- a/fs/nilfs2/bmap.h
+++ b/fs/nilfs2/bmap.h
@@ -63,7 +63,7 @@ struct nilfs_bmap_operations {
 	int (*bop_lookup_contig)(const struct nilfs_bmap *, __u64, __u64 *,
 				 unsigned int);
 	int (*bop_insert)(struct nilfs_bmap *, __u64, __u64);
-	int (*bop_delete)(struct nilfs_bmap *, __u64);
+	int (*bop_delete)(struct nilfs_bmap *bmap, __u64 key, bool deform);
 	void (*bop_clear)(struct nilfs_bmap *);
 
 	int (*bop_propagate)(struct nilfs_bmap *, struct buffer_head *);
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 64d5f7c5ab44..64bac66af25b 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -1425,6 +1425,28 @@ static void nilfs_btree_shrink(struct nilfs_bmap *btree,
 	path[level].bp_bh = NULL;
 }
 
+/**
+ * nilfs_btree_discard - discard the last node for the mapping transformation
+ * @btree: bmap struct of btree
+ * @path: array of nilfs_btree_path struct
+ * @level: level of the B-tree node being operated on
+ * @keyp: argument for passing a key (unused)
+ * @ptrp: argument for passing a pointer (unused)
+ */
+static void nilfs_btree_discard(struct nilfs_bmap *btree,
+				struct nilfs_btree_path *path, int level,
+				__u64 *keyp, __u64 *ptrp)
+{
+	struct nilfs_btree_node *root = nilfs_btree_get_root(btree);
+
+	nilfs_btree_node_delete(root, 0, NULL, NULL,
+				NILFS_BTREE_ROOT_NCHILDREN_MAX);
+	nilfs_btree_node_set_level(root, level);
+
+	nilfs_btnode_delete(path[level].bp_bh);
+	path[level].bp_bh = NULL;
+}
+
 static void nilfs_btree_nop(struct nilfs_bmap *btree,
 			    struct nilfs_btree_path *path,
 			    int level, __u64 *keyp, __u64 *ptrp)
@@ -1435,7 +1457,7 @@ static int nilfs_btree_prepare_delete(struct nilfs_bmap *btree,
 				      struct nilfs_btree_path *path,
 				      int *levelp,
 				      struct nilfs_bmap_stats *stats,
-				      struct inode *dat)
+				      struct inode *dat, bool deform)
 {
 	struct buffer_head *bh;
 	struct nilfs_btree_node *node, *parent, *sib;
@@ -1522,15 +1544,17 @@ static int nilfs_btree_prepare_delete(struct nilfs_bmap *btree,
 			if (nilfs_btree_node_get_nchildren(node) - 1 <=
 			    NILFS_BTREE_ROOT_NCHILDREN_MAX) {
 				path[level].bp_op = nilfs_btree_shrink;
-				stats->bs_nblocks += 2;
-				level++;
-				path[level].bp_op = nilfs_btree_nop;
-				goto shrink_root_child;
+			} else if (deform) {
+				path[level].bp_op = nilfs_btree_discard;
 			} else {
 				path[level].bp_op = nilfs_btree_do_delete;
 				stats->bs_nblocks++;
 				goto out;
 			}
+			stats->bs_nblocks += 2;
+			level++;
+			path[level].bp_op = nilfs_btree_nop;
+			goto shrink_root_child;
 		}
 	}
 
@@ -1581,7 +1605,7 @@ static void nilfs_btree_commit_delete(struct nilfs_bmap *btree,
 		nilfs_bmap_set_dirty(btree);
 }
 
-static int nilfs_btree_delete(struct nilfs_bmap *btree, __u64 key)
+static int nilfs_btree_delete(struct nilfs_bmap *btree, __u64 key, bool deform)
 
 {
 	struct nilfs_btree_path *path;
@@ -1601,7 +1625,8 @@ static int nilfs_btree_delete(struct nilfs_bmap *btree, __u64 key)
 
 	dat = NILFS_BMAP_USE_VBN(btree) ? nilfs_bmap_get_dat(btree) : NULL;
 
-	ret = nilfs_btree_prepare_delete(btree, path, &level, &stats, dat);
+	ret = nilfs_btree_prepare_delete(btree, path, &level, &stats, dat,
+			deform);
 	if (ret < 0)
 		goto out;
 	nilfs_btree_commit_delete(btree, path, level, dat);
diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
index 8bd0b1374e25..b8643d3aa2f8 100644
--- a/fs/nilfs2/direct.c
+++ b/fs/nilfs2/direct.c
@@ -144,7 +144,7 @@ static int nilfs_direct_insert(struct nilfs_bmap *bmap, __u64 key, __u64 ptr)
 	return ret;
 }
 
-static int nilfs_direct_delete(struct nilfs_bmap *bmap, __u64 key)
+static int nilfs_direct_delete(struct nilfs_bmap *bmap, __u64 key, bool deform)
 {
 	union nilfs_bmap_ptr_req req;
 	struct inode *dat;
@@ -234,7 +234,7 @@ int nilfs_direct_delete_and_convert(struct nilfs_bmap *bmap,
 	/* no need to allocate any resource for conversion */
 
 	/* delete */
-	ret = bmap->b_ops->bop_delete(bmap, key);
+	ret = bmap->b_ops->bop_delete(bmap, key, true);
 	if (ret < 0)
 		return ret;
 
-- 
2.43.0

