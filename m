From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 6/7] nilfs2: add helper functions to delete blocks from dat file
Date: Sat, 19 Sep 2015 19:33:01 +0900
Message-ID: <1442658782-3147-7-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1442658782-3147-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=EG+vFXCeJvOLP0Gds1jssSQPW2KBskLh/8/7WkN6ND4=;
        b=pMZy9mXPWsxiPpVTh807b2o18PZ3wI/WpRYt2HhYWEv7QtplPImxXY9ABSCWVMJcI6
         HFBTK9AqHCYuSaBQL7OgYUWf4kotHay0kPxTWv8URPfbLBdZRblW/Li5FrGge+rH60nt
         gLdCEIiVeLtUQJEwq3KcLWfwWuPz6H7YjGbrSB+2klJWLAqpp4MSKKgaIJayCfPGeSwf
         aihNV9lqMnIii0ZZWelwudIIGrw67ZvOi78bcWVaIZSI9qKY8ONvmBAs71EibBvlhCB9
         VsLJ9wXU7E5d3MdtMXOpBPkVO/1UVUCwBYkuQrzSoUOr7j6u30o4yLL0ez1mSQzkSDYc
         SW2Q==
In-Reply-To: <1442658782-3147-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-nilfs <linux-nilfs@vger.kernel.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

This adds delete functions for data blocks of metadata files using
bitmap based allocator.  nilfs_palloc_delete_entry_block() deletes an
entry block (e.g. block storing dat entries), and
nilfs_palloc_delete_bitmap_block() deletes a bitmap block,
respectively.

These helpers are intended to be used in the successive change on
deallocator of block addresses ("nilfs2: free unused dat file blocks
during garbage collection").

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/alloc.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/fs/nilfs2/alloc.c b/fs/nilfs2/alloc.c
index 5b7ee36..225b797 100644
--- a/fs/nilfs2/alloc.c
+++ b/fs/nilfs2/alloc.c
@@ -236,6 +236,26 @@ static int nilfs_palloc_get_block(struct inode *inode, unsigned long blkoff,
 }
 
 /**
+ * nilfs_palloc_delete_block - delete a block on the persistent allocator file
+ * @inode: inode of metadata file using this allocator
+ * @blkoff: block offset
+ * @prev: nilfs_bh_assoc struct of the last used buffer
+ * @lock: spin lock protecting @prev
+ */
+static int nilfs_palloc_delete_block(struct inode *inode, unsigned long blkoff,
+				     struct nilfs_bh_assoc *prev,
+				     spinlock_t *lock)
+{
+	spin_lock(lock);
+	if (prev->bh && blkoff == prev->blkoff) {
+		brelse(prev->bh);
+		prev->bh = NULL;
+	}
+	spin_unlock(lock);
+	return nilfs_mdt_delete_block(inode, blkoff);
+}
+
+/**
  * nilfs_palloc_get_desc_block - get buffer head of a group descriptor block
  * @inode: inode of metadata file using this allocator
  * @group: group number
@@ -274,6 +294,22 @@ static int nilfs_palloc_get_bitmap_block(struct inode *inode,
 }
 
 /**
+ * nilfs_palloc_delete_bitmap_block - delete a bitmap block
+ * @inode: inode of metadata file using this allocator
+ * @group: group number
+ */
+static int nilfs_palloc_delete_bitmap_block(struct inode *inode,
+					    unsigned long group)
+{
+	struct nilfs_palloc_cache *cache = NILFS_MDT(inode)->mi_palloc_cache;
+
+	return nilfs_palloc_delete_block(inode,
+					 nilfs_palloc_bitmap_blkoff(inode,
+								    group),
+					 &cache->prev_bitmap, &cache->lock);
+}
+
+/**
  * nilfs_palloc_get_entry_block - get buffer head of an entry block
  * @inode: inode of metadata file using this allocator
  * @nr: serial number of the entry (e.g. inode number)
@@ -292,6 +328,20 @@ int nilfs_palloc_get_entry_block(struct inode *inode, __u64 nr,
 }
 
 /**
+ * nilfs_palloc_delete_entry_block - delete an entry block
+ * @inode: inode of metadata file using this allocator
+ * @nr: serial number of the entry
+ */
+static int nilfs_palloc_delete_entry_block(struct inode *inode, __u64 nr)
+{
+	struct nilfs_palloc_cache *cache = NILFS_MDT(inode)->mi_palloc_cache;
+
+	return nilfs_palloc_delete_block(inode,
+					 nilfs_palloc_entry_blkoff(inode, nr),
+					 &cache->prev_entry, &cache->lock);
+}
+
+/**
  * nilfs_palloc_block_get_group_desc - get kernel address of a group descriptor
  * @inode: inode of metadata file using this allocator
  * @group: group number
-- 
1.8.3.1
