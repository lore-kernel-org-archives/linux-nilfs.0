From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH -mm 2/2] nilfs2: use i_blocksize()
Date: Tue, 24 Jan 2017 00:17:35 +0900
Message-ID: <1485184655-3895-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1485184655-3895-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=EA6mdD3mOiQ7vIWq9t8fbFFEDluUeNv0wDteUlhlSPM=;
        b=uFORO2qlNpq5MCCHAGOzqYLGPey8S1bgN8uaxhCNaLZ8LSxE+V1xHR8iD18UzVadzM
         2EhF896w/HVAuE+I1UQWx8EI7xjOwVQT/yhItiCmksGZrpyCnBhiJdZ7jHpiSDd1kYwm
         kNG/j+CLN7tIWY2UQp0cMRfuD6nQWrv/UqWgr6pzLRavwewfFUbOZa3MYIkavt5OnWuw
         0+Z/s0F9mhjuP1/LvfVf4kTEimK2y1s68+s8MTmCRaJaXGe1a1pfC8nHDS9MVTFYn+uo
         OOu+0XgUzniyHhedWAJSUPQDnQ+6fbEEnE+9Bju/JuB2RcFomWXGPSQ7VwLk1pY1+iKd
         mrew==
In-Reply-To: <1485184655-3895-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-nilfs <linux-nilfs@vger.kernel.org>, Geliang Tang <geliangtang@gmail.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

From: Geliang Tang <geliangtang@gmail.com>

Since i_blocksize() helper has been defined in fs.h, use it instead
of open-coding.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
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
index 9c7ea17..06ffa13 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -119,7 +119,7 @@ static int nilfs_btree_node_get_nchildren(const struct nilfs_btree_node *node)
 
 static int nilfs_btree_node_size(const struct nilfs_bmap *btree)
 {
-	return 1 << btree->b_inode->i_blkbits;
+	return i_blocksize(btree->b_inode);
 }
 
 static int nilfs_btree_nchildren_per_block(const struct nilfs_bmap *btree)
-- 
1.8.3.1

