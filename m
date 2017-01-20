From: Geliang Tang <geliangtang@gmail.com>
Subject: [PATCH 1/2] nilfs2: use i_blocksize()
Date: Fri, 20 Jan 2017 22:34:57 +0800
Message-ID: <ebd4d1fb0aada6ed0bb1d2de21230c3b1fb148a9.1484896146.git.geliangtang@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=rVPql+SSkqJtJtpbr+oxzRi05juiczit/LGEBMFM1bo=;
        b=VeYcGqw+bD1LpPKAmfPpfHkFZSGyarhjBX1dd9R1y+G1fM100jtFksfEFiE6R+o1Sc
         GxK3LFFLVCvhzpgUS1Haj33OFdUuND8vn4A4e9EwacSBDeSo0emGv+kIpsBhYB6T2hVf
         gYR9GVgvIjlQ8uzzkRmiixlULeTUXme4/5Iw86zZo2cr8c1qwc6VuKSBqjHc5Kbo32Zc
         f6aeATxLxY4KjMH/pRCqxK7as7oWzsQwFjYPYaPaFD+ChkHo7fYG89SGWrVWUFbDHbP+
         7O5R+gLJlVNBcDnfXxNKsG8R+GML5VcITb6egpwqg4putUoIUNZpmRYwUVK1LweJbA0c
         GNkw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org

Since i_blocksize() helper has been defined in fs.h, use it instead
of open-coding.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 fs/nilfs2/alloc.c | 2 +-
 fs/nilfs2/btree.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/alloc.c b/fs/nilfs2/alloc.c
index 2c90e28..03b8ba9 100644
--- a/fs/nilfs2/alloc.c
+++ b/fs/nilfs2/alloc.c
@@ -34,7 +34,7 @@
 static inline unsigned long
 nilfs_palloc_groups_per_desc_block(const struct inode *inode)
 {
-	return (1UL << inode->i_blkbits) /
+	return i_blocksize(inode) /
 		sizeof(struct nilfs_palloc_group_desc);
 }
 
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 2e315f9..d75238a 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -119,7 +119,7 @@ nilfs_btree_node_set_nchildren(struct nilfs_btree_node *node, int nchildren)
 
 static int nilfs_btree_node_size(const struct nilfs_bmap *btree)
 {
-	return 1 << btree->b_inode->i_blkbits;
+	return i_blocksize(btree->b_inode);
 }
 
 static int nilfs_btree_nchildren_per_block(const struct nilfs_bmap *btree)
-- 
2.9.3

