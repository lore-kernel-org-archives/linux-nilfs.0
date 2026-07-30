Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9E33EB81D
	for <linux-nilfs@vger.kernel.org>; Thu, 30 Jul 2026 09:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785405512; cv=none; b=uf5mdUe8WU2zqLBN5aGOKA4liDkbmPyo07M11055g8yruSNUWJ3jnhTbfXuCLr1k7yOEKcycCUwN/aaunX07kgSz9UGKzi1Rnf+3pLDBPBIqS7xMejroG+0zx50FlSMO5h5p+PFn9EKeFOlZaoBhM/bSTC44NsfomM+rOMwr7CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785405512; c=relaxed/simple;
	bh=VWBCnsCdyvApk/xbx5c/j6/ig6q69++Ge/e0KKWZLYM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=U93lP6sQUO/Wc084nkkz6bgGq8YgWeyMSrfykcKjN+For887xL1pTMwD1VoBovX33E6sUwfbscCat1W8YHWfe3UZ1oHiM6GfoLCp/c1EXkejP1bDVP02JDHoDLEWu9fp4rRKPbBUI+ERC/Kab58y9h0s3SZF8gbiUJ01RC8rZxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=j+BXt+1h; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="j+BXt+1h"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=0U960Ey6HOLhcVs8/5Kw+NwLgLBacVahuM+uKcXU5Sk=;
	b=j+BXt+1hpU6LJDSygaHq51I1FmtByFE8p+Ehab5MlzGwXqU9+Lf1cye6NqYGNJ9TbOhsHbwyN
	CoKegCNVU4DU2zdjg31OcxFzbm1R9KMu1NHvdhLxEG7QGb2rc1yygk1gVBRRcfGFFn9krQ9WeG8
	kg8gIJAPWEQIWXIZcZzY1dA=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4h9ktC4tYtz1T4MG;
	Thu, 30 Jul 2026 17:48:51 +0800 (CST)
Received: from kwepemf200016.china.huawei.com (unknown [7.202.181.9])
	by mail.maildlp.com (Postfix) with ESMTPS id A21AB2025F;
	Thu, 30 Jul 2026 17:58:23 +0800 (CST)
Received: from huawei.com (10.113.213.244) by kwepemf200016.china.huawei.com
 (7.202.181.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 30 Jul
 2026 17:58:23 +0800
From: Wang Jianjian <wangjianjian3@huawei.com>
To: <konishi.ryusuke@gmail.com>, <slava@dubeyko.com>,
	<linux-nilfs@vger.kernel.org>
CC: Wang Jianjian <wangjianjian3@huawei.com>
Subject: [PATCH] nilfs: enhance btree node keys check
Date: Thu, 30 Jul 2026 17:26:40 +0800
Message-ID: <20260730092640.1088530-1-wangjianjian3@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemf200016.china.huawei.com (7.202.181.9)

syzbot reported a warning on nilfs_btree_assign:
WARNING: fs/nilfs2/btree.c:2302 at nilfs_btree_assign+0x983/0xbe0 fs/nilfs2/btree.c:2302,

Analysis found that a corrupted file has the following btree layout:
Level2(key/ptr): [ 256/15 ]
Level1(key/ptr): [ 0/8, 1/9, 0/10, 3/11, 4/12, 5/13, 6/14, 139637976727559/16, 0/17 ]

The test truncated the file to 2 bytes, which partially zeroes the first block and
adds the file to the dirty list. When the segment constructor writes it and assigns
a new blocknr for the index block, it searches the btree with key=0 and min level=2,
and apparently returns ENOENT.

Therefore, we should perform more checks on the btree nodes and return early.

Signed-off-by: Wang Jianjian <wangjianjian3@huawei.com>
---
 fs/nilfs2/btree.c | 40 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 35 insertions(+), 5 deletions(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 64d5f7c5ab44..8b164e13663f 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -448,16 +448,46 @@ nilfs_btree_get_node(const struct nilfs_bmap *btree,
 }
 
 static int nilfs_btree_bad_node(const struct nilfs_bmap *btree,
+				const struct nilfs_btree_path *path,
 				struct nilfs_btree_node *node, int level)
 {
+	struct inode *inode = btree->b_inode;
+	__u64 key1, key2;
+	int i, ncmax;
+
 	if (unlikely(nilfs_btree_node_get_level(node) != level)) {
 		dump_stack();
-		nilfs_crit(btree->b_inode->i_sb,
+		nilfs_crit(inode->i_sb,
 			   "btree level mismatch (ino=%llu): %d != %d",
-			   btree->b_inode->i_ino,
-			   nilfs_btree_node_get_level(node), level);
+			   inode->i_ino, nilfs_btree_node_get_level(node), level);
 		return 1;
 	}
+
+	for (i = 1; i < nilfs_btree_node_get_nchildren(node); i++) {
+		key1 = nilfs_btree_node_get_key(node, i);
+		key2 = nilfs_btree_node_get_key(node, i - 1);
+
+		if (key1 <= key2) {
+			nilfs_crit(inode->i_sb,
+				   "btree node(ino=%llu) level=%d key not sorted: %d/%llu <= %d/%llu",
+					inode->i_ino, level, i, key1, i - 1, key2);
+			return 1;
+		}
+	}
+
+	if (level < nilfs_btree_height(btree) - 1) {
+		struct nilfs_btree_node *parent = nilfs_btree_get_node(btree, path, level + 1, &ncmax);
+
+		key1 = nilfs_btree_node_get_key(parent, path[level + 1].bp_index);
+		key2 = nilfs_btree_node_get_key(node, 0);
+		if (key1 != key2) {
+			nilfs_crit(inode->i_sb,
+				   "btree node(ino=%llu) level=%d key=%llu not equal to parent's key=%llu",
+				   inode->i_ino, level, key2, key1);
+			return 1;
+		}
+	}
+
 	return 0;
 }
 
@@ -582,7 +612,7 @@ static int nilfs_btree_do_lookup(const struct nilfs_bmap *btree,
 			return ret;
 
 		node = nilfs_btree_get_nonroot_node(path, level);
-		if (nilfs_btree_bad_node(btree, node, level))
+		if (nilfs_btree_bad_node(btree, path, node, level))
 			return -EINVAL;
 		if (!found)
 			found = nilfs_btree_node_lookup(node, key, &index);
@@ -630,7 +660,7 @@ static int nilfs_btree_do_lookup_last(const struct nilfs_bmap *btree,
 		if (ret < 0)
 			return ret;
 		node = nilfs_btree_get_nonroot_node(path, level);
-		if (nilfs_btree_bad_node(btree, node, level))
+		if (nilfs_btree_bad_node(btree, path, node, level))
 			return -EINVAL;
 		index = nilfs_btree_node_get_nchildren(node) - 1;
 		ptr = nilfs_btree_node_get_ptr(node, index, ncmax);
-- 
2.34.1

