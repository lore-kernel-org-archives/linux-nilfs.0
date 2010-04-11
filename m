From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: add kernel doc comments to persistent object allocator functions
Date: Mon, 12 Apr 2010 02:39:22 +0900
Message-ID: <1271007562-22829-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

The implementation of persistent object allocator (alloc.c) is poorly
documented.  This adds kernel doc style comments on that functions.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/alloc.c |  154 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/nilfs2/alloc.h |    7 +++
 2 files changed, 160 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/alloc.c b/fs/nilfs2/alloc.c
index c2a1387..d1c667c 100644
--- a/fs/nilfs2/alloc.c
+++ b/fs/nilfs2/alloc.c
@@ -30,6 +30,11 @@
 #include "alloc.h"
 
 
+/**
+ * nilfs_palloc_groups_per_desc_block - get the number of groups that a group
+ *					descriptor block can maintain
+ * @inode: inode of metadata file using this allocator
+ */
 static inline unsigned long
 nilfs_palloc_groups_per_desc_block(const struct inode *inode)
 {
@@ -37,12 +42,21 @@ nilfs_palloc_groups_per_desc_block(const struct inode *inode)
 		sizeof(struct nilfs_palloc_group_desc);
 }
 
+/**
+ * nilfs_palloc_groups_count - get maximum number of groups
+ * @inode: inode of metadata file using this allocator
+ */
 static inline unsigned long
 nilfs_palloc_groups_count(const struct inode *inode)
 {
 	return 1UL << (BITS_PER_LONG - (inode->i_blkbits + 3 /* log2(8) */));
 }
 
+/**
+ * nilfs_palloc_init_blockgroup - initialize private variables for allocator
+ * @inode: inode of metadata file using this allocator
+ * @entry_size: size of the persistent object
+ */
 int nilfs_palloc_init_blockgroup(struct inode *inode, unsigned entry_size)
 {
 	struct nilfs_mdt_info *mi = NILFS_MDT(inode);
@@ -68,6 +82,12 @@ int nilfs_palloc_init_blockgroup(struct inode *inode, unsigned entry_size)
 	return 0;
 }
 
+/**
+ * nilfs_palloc_group - get group number and offset from an entry number
+ * @inode: inode of metadata file using this allocator
+ * @nr: serial number of the entry (e.g. inode number)
+ * @offset: pointer to store offset number in the group
+ */
 static unsigned long nilfs_palloc_group(const struct inode *inode, __u64 nr,
 					unsigned long *offset)
 {
@@ -77,6 +97,14 @@ static unsigned long nilfs_palloc_group(const struct inode *inode, __u64 nr,
 	return group;
 }
 
+/**
+ * nilfs_palloc_desc_blkoff - get block offset of a group descriptor block
+ * @inode: inode of metadata file using this allocator
+ * @group: group number
+ *
+ * nilfs_palloc_desc_blkoff() returns block offset of the descriptor
+ * block which contains a descriptor of the specified group.
+ */
 static unsigned long
 nilfs_palloc_desc_blkoff(const struct inode *inode, unsigned long group)
 {
@@ -85,6 +113,14 @@ nilfs_palloc_desc_blkoff(const struct inode *inode, unsigned long group)
 	return desc_block * NILFS_MDT(inode)->mi_blocks_per_desc_block;
 }
 
+/**
+ * nilfs_palloc_bitmap_blkoff - get block offset of a bitmap block
+ * @inode: inode of metadata file using this allocator
+ * @group: group number
+ *
+ * nilfs_palloc_bitmap_blkoff() returns block offset of the bitmap
+ * block used to allocate/deallocate entries in the specified group.
+ */
 static unsigned long
 nilfs_palloc_bitmap_blkoff(const struct inode *inode, unsigned long group)
 {
@@ -94,6 +130,12 @@ nilfs_palloc_bitmap_blkoff(const struct inode *inode, unsigned long group)
 		desc_offset * NILFS_MDT(inode)->mi_blocks_per_group;
 }
 
+/**
+ * nilfs_palloc_group_desc_nfrees - get the number of free entries in a group
+ * @inode: inode of metadata file using this allocator
+ * @group: group number
+ * @desc: pointer to descriptor structure for the group
+ */
 static unsigned long
 nilfs_palloc_group_desc_nfrees(struct inode *inode, unsigned long group,
 			       const struct nilfs_palloc_group_desc *desc)
@@ -106,6 +148,13 @@ nilfs_palloc_group_desc_nfrees(struct inode *inode, unsigned long group,
 	return nfree;
 }
 
+/**
+ * nilfs_palloc_group_desc_add_entries - adjust count of free entries
+ * @inode: inode of metadata file using this allocator
+ * @group: group number
+ * @desc: pointer to descriptor structure for the group
+ * @n: delta to be added
+ */
 static void
 nilfs_palloc_group_desc_add_entries(struct inode *inode,
 				    unsigned long group,
@@ -117,6 +166,11 @@ nilfs_palloc_group_desc_add_entries(struct inode *inode,
 	spin_unlock(nilfs_mdt_bgl_lock(inode, group));
 }
 
+/**
+ * nilfs_palloc_entry_blkoff - get block offset of an entry block
+ * @inode: inode of metadata file using this allocator
+ * @nr: serial number of the entry (e.g. inode number)
+ */
 static unsigned long
 nilfs_palloc_entry_blkoff(const struct inode *inode, __u64 nr)
 {
@@ -128,6 +182,12 @@ nilfs_palloc_entry_blkoff(const struct inode *inode, __u64 nr)
 		group_offset / NILFS_MDT(inode)->mi_entries_per_block;
 }
 
+/**
+ * nilfs_palloc_desc_block_init - initialize buffer of a group descriptor block
+ * @inode: inode of metadata file
+ * @bh: buffer head of the buffer to be initialized
+ * @kaddr: kernel address mapped for the page including the buffer
+ */
 static void nilfs_palloc_desc_block_init(struct inode *inode,
 					 struct buffer_head *bh, void *kaddr)
 {
@@ -178,6 +238,13 @@ static int nilfs_palloc_get_block(struct inode *inode, unsigned long blkoff,
 	return ret;
 }
 
+/**
+ * nilfs_palloc_get_desc_block - get buffer head of a group descriptor block
+ * @inode: inode of metadata file using this allocator
+ * @group: group number
+ * @create: create flag
+ * @bhp: pointer to store the resultant buffer head
+ */
 static int nilfs_palloc_get_desc_block(struct inode *inode,
 				       unsigned long group,
 				       int create, struct buffer_head **bhp)
@@ -190,6 +257,13 @@ static int nilfs_palloc_get_desc_block(struct inode *inode,
 				      bhp, &cache->prev_desc, &cache->lock);
 }
 
+/**
+ * nilfs_palloc_get_bitmap_block - get buffer head of a bitmap block
+ * @inode: inode of metadata file using this allocator
+ * @group: group number
+ * @create: create flag
+ * @bhp: pointer to store the resultant buffer head
+ */
 static int nilfs_palloc_get_bitmap_block(struct inode *inode,
 					 unsigned long group,
 					 int create, struct buffer_head **bhp)
@@ -202,6 +276,13 @@ static int nilfs_palloc_get_bitmap_block(struct inode *inode,
 				      &cache->prev_bitmap, &cache->lock);
 }
 
+/**
+ * nilfs_palloc_get_entry_block - get buffer head of an entry block
+ * @inode: inode of metadata file using this allocator
+ * @nr: serial number of the entry (e.g. inode number)
+ * @create: create flag
+ * @bhp: pointer to store the resultant buffer head
+ */
 int nilfs_palloc_get_entry_block(struct inode *inode, __u64 nr,
 				 int create, struct buffer_head **bhp)
 {
@@ -213,6 +294,13 @@ int nilfs_palloc_get_entry_block(struct inode *inode, __u64 nr,
 				      &cache->prev_entry, &cache->lock);
 }
 
+/**
+ * nilfs_palloc_block_get_group_desc - get kernel address of a group descriptor
+ * @inode: inode of metadata file using this allocator
+ * @group: group number
+ * @bh: buffer head of the buffer storing the group descriptor block
+ * @kaddr: kernel address mapped for the page including the buffer
+ */
 static struct nilfs_palloc_group_desc *
 nilfs_palloc_block_get_group_desc(const struct inode *inode,
 				  unsigned long group,
@@ -222,6 +310,13 @@ nilfs_palloc_block_get_group_desc(const struct inode *inode,
 		group % nilfs_palloc_groups_per_desc_block(inode);
 }
 
+/**
+ * nilfs_palloc_block_get_entry - get kernel address of an entry
+ * @inode: inode of metadata file using this allocator
+ * @nr: serial number of the entry (e.g. inode number)
+ * @bh: buffer head of the buffer storing the entry block
+ * @kaddr: kernel address mapped for the page including the buffer
+ */
 void *nilfs_palloc_block_get_entry(const struct inode *inode, __u64 nr,
 				   const struct buffer_head *bh, void *kaddr)
 {
@@ -234,11 +329,19 @@ void *nilfs_palloc_block_get_entry(const struct inode *inode, __u64 nr,
 		entry_offset * NILFS_MDT(inode)->mi_entry_size;
 }
 
+/**
+ * nilfs_palloc_find_available_slot - find available slot in a group
+ * @inode: inode of metadata file using this allocator
+ * @group: group number
+ * @target: offset number of an entry in the group (start point)
+ * @bitmap: bitmap of the group
+ * @bsize: size in bits
+ */
 static int nilfs_palloc_find_available_slot(struct inode *inode,
 					    unsigned long group,
 					    unsigned long target,
 					    unsigned char *bitmap,
-					    int bsize)  /* size in bits */
+					    int bsize)
 {
 	int curr, pos, end, i;
 
@@ -276,6 +379,13 @@ static int nilfs_palloc_find_available_slot(struct inode *inode,
 	return -ENOSPC;
 }
 
+/**
+ * nilfs_palloc_rest_groups_in_desc_block - get the remaining number of groups
+ *					    in a group descriptor block
+ * @inode: inode of metadata file using this allocator
+ * @curr: current group number
+ * @max: maximum number of groups
+ */
 static unsigned long
 nilfs_palloc_rest_groups_in_desc_block(const struct inode *inode,
 				       unsigned long curr, unsigned long max)
@@ -286,6 +396,11 @@ nilfs_palloc_rest_groups_in_desc_block(const struct inode *inode,
 		     max - curr + 1);
 }
 
+/**
+ * nilfs_palloc_prepare_alloc_entry - prepare to allocate a persistent object
+ * @inode: inode of metadata file using this allocator
+ * @req: nilfs_palloc_req structure exchanged for the allocation
+ */
 int nilfs_palloc_prepare_alloc_entry(struct inode *inode,
 				     struct nilfs_palloc_req *req)
 {
@@ -365,6 +480,11 @@ int nilfs_palloc_prepare_alloc_entry(struct inode *inode,
 	return ret;
 }
 
+/**
+ * nilfs_palloc_commit_alloc_entry - finish allocation of a persistent object
+ * @inode: inode of metadata file using this allocator
+ * @req: nilfs_palloc_req structure exchanged for the allocation
+ */
 void nilfs_palloc_commit_alloc_entry(struct inode *inode,
 				     struct nilfs_palloc_req *req)
 {
@@ -376,6 +496,11 @@ void nilfs_palloc_commit_alloc_entry(struct inode *inode,
 	brelse(req->pr_desc_bh);
 }
 
+/**
+ * nilfs_palloc_commit_free_entry - finish deallocating a persistent object
+ * @inode: inode of metadata file using this allocator
+ * @req: nilfs_palloc_req structure exchanged for the removal
+ */
 void nilfs_palloc_commit_free_entry(struct inode *inode,
 				    struct nilfs_palloc_req *req)
 {
@@ -409,6 +534,11 @@ void nilfs_palloc_commit_free_entry(struct inode *inode,
 	brelse(req->pr_desc_bh);
 }
 
+/**
+ * nilfs_palloc_abort_alloc_entry - cancel allocation of a persistent object
+ * @inode: inode of metadata file using this allocator
+ * @req: nilfs_palloc_req structure exchanged for the allocation
+ */
 void nilfs_palloc_abort_alloc_entry(struct inode *inode,
 				    struct nilfs_palloc_req *req)
 {
@@ -441,6 +571,11 @@ void nilfs_palloc_abort_alloc_entry(struct inode *inode,
 	req->pr_desc_bh = NULL;
 }
 
+/**
+ * nilfs_palloc_prepare_free_entry - prepare to deallocate a persistent object
+ * @inode: inode of metadata file using this allocator
+ * @req: nilfs_palloc_req structure exchanged for the removal
+ */
 int nilfs_palloc_prepare_free_entry(struct inode *inode,
 				    struct nilfs_palloc_req *req)
 {
@@ -463,6 +598,11 @@ int nilfs_palloc_prepare_free_entry(struct inode *inode,
 	return 0;
 }
 
+/**
+ * nilfs_palloc_abort_free_entry - cancel deallocating a persistent object
+ * @inode: inode of metadata file using this allocator
+ * @req: nilfs_palloc_req structure exchanged for the removal
+ */
 void nilfs_palloc_abort_free_entry(struct inode *inode,
 				   struct nilfs_palloc_req *req)
 {
@@ -474,6 +614,12 @@ void nilfs_palloc_abort_free_entry(struct inode *inode,
 	req->pr_desc_bh = NULL;
 }
 
+/**
+ * nilfs_palloc_group_is_in - judge if an entry is in a group
+ * @inode: inode of metadata file using this allocator
+ * @group: group number
+ * @nr: serial number of the entry (e.g. inode number)
+ */
 static int
 nilfs_palloc_group_is_in(struct inode *inode, unsigned long group, __u64 nr)
 {
@@ -484,6 +630,12 @@ nilfs_palloc_group_is_in(struct inode *inode, unsigned long group, __u64 nr)
 	return (nr >= first) && (nr <= last);
 }
 
+/**
+ * nilfs_palloc_freev - deallocate a set of persistent objects
+ * @inode: inode of metadata file using this allocator
+ * @entry_nrs: array of entry numbers to be deallocated
+ * @nitems: number of entries stored in @entry_nrs
+ */
 int nilfs_palloc_freev(struct inode *inode, __u64 *entry_nrs, size_t nitems)
 {
 	struct buffer_head *desc_bh, *bitmap_bh;
diff --git a/fs/nilfs2/alloc.h b/fs/nilfs2/alloc.h
index 5cccf87..9af34a7 100644
--- a/fs/nilfs2/alloc.h
+++ b/fs/nilfs2/alloc.h
@@ -29,6 +29,13 @@
 #include <linux/buffer_head.h>
 #include <linux/fs.h>
 
+/**
+ * nilfs_palloc_entries_per_group - get the number of entries per group
+ * @inode: inode of metadata file using this allocator
+ *
+ * The number of entries per group is defined by the number of bits
+ * that a bitmap block can maintain.
+ */
 static inline unsigned long
 nilfs_palloc_entries_per_group(const struct inode *inode)
 {
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
