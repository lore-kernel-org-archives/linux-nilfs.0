From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH 1/2] nilfs2: support the allocation of whole blocks of meta data entries
Date: Sun, 12 Oct 2014 12:38:22 +0200
Message-ID: <1413110303-14246-2-git-send-email-andreas.rohner@gmx.net>
References: <1413110303-14246-1-git-send-email-andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1413110303-14246-1-git-send-email-andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

This patch generalizes the function nilfs_palloc_prepare_alloc_entry()
by adding two parameters, namely block_size and threshold.

The newly allocated entry must be at the start of a block of empty
entries of size block_size and it must be contained in a group of at
least threshold number of free entries. The old behavior of the function
can be achieved by supplying 1 and 0 respectively.

This generalization allows for more sophisticated allocation algorithms
to be build on top of it. For example with block_size an algorithm
can space out certain entries to leave room between them for following
allocations, which can achieve a better localization of entries that
belong together and are likely to be accessed at the same time in the
future. threshold on the other hand can be used to exclude groups, where
the search is not likely to find an empty continuous block of size
block_size.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 fs/nilfs2/alloc.c | 161 ++++++++++++++++++++++++++++++++++++++++++++++++++----
 fs/nilfs2/alloc.h |  18 +++++-
 2 files changed, 166 insertions(+), 13 deletions(-)

diff --git a/fs/nilfs2/alloc.c b/fs/nilfs2/alloc.c
index 741fd02..fb71d90 100644
--- a/fs/nilfs2/alloc.c
+++ b/fs/nilfs2/alloc.c
@@ -331,18 +331,18 @@ void *nilfs_palloc_block_get_entry(const struct inode *inode, __u64 nr,
 }
 
 /**
- * nilfs_palloc_find_available_slot - find available slot in a group
+ * nilfs_palloc_find_available_slot_unaligned - find available slot in a group
  * @inode: inode of metadata file using this allocator
  * @group: group number
  * @target: offset number of an entry in the group (start point)
  * @bitmap: bitmap of the group
  * @bsize: size in bits
  */
-static int nilfs_palloc_find_available_slot(struct inode *inode,
-					    unsigned long group,
-					    unsigned long target,
-					    unsigned char *bitmap,
-					    int bsize)
+static int nilfs_palloc_find_available_slot_unaligned(struct inode *inode,
+						      unsigned long group,
+						      unsigned long target,
+						      unsigned char *bitmap,
+						      int bsize)
 {
 	int curr, pos, end, i;
 
@@ -381,6 +381,127 @@ static int nilfs_palloc_find_available_slot(struct inode *inode,
 }
 
 /**
+ * nilfs_palloc_find_available_slot_align32 - find available slot in a group
+ * @inode: inode of metadata file using this allocator
+ * @group: group number
+ * @target: offset number of an entry in the group (start point)
+ * @bitmap: bitmap of the group
+ * @bsize: size in bits
+ *
+ * Description: Finds an available aligned slot in a group. It will be
+ * aligned to 32 slots followed by 31 empty slots.
+ *
+ * Return Value: On success, the available slot is returned.
+ * On error, %-ENOSPC is returned.
+ */
+static int nilfs_palloc_find_available_slot_align32(struct inode *inode,
+						    unsigned long group,
+						    unsigned long target,
+						    unsigned char *bitmap,
+						    int bsize)
+{
+	u32 *end = (u32 *)bitmap + bsize / 32;
+	u32 *p = (u32 *)bitmap + target / 32;
+	int i, pos = target & ~31;
+
+	for (i = 0; i < bsize; i += 32, pos += 32, ++p) {
+		/* wrap around */
+		if (p == end) {
+			p = (u32 *)bitmap;
+			pos = 0;
+		}
+
+		if (!*p && !nilfs_set_bit_atomic(nilfs_mdt_bgl_lock(inode,
+						 group), pos, bitmap))
+			return pos;
+	}
+
+	return -ENOSPC;
+}
+
+/**
+ * nilfs_palloc_find_available_slot_align - find available slot in a group
+ * @inode: inode of metadata file using this allocator
+ * @group: group number
+ * @target: offset number of an entry in the group (start point)
+ * @bitmap: bitmap of the group
+ * @bsize: size in bits
+ * @block_size: size of the empty block to allocate the new entry (in bits)
+ *
+ * Description: Finds an available aligned slot in a group. It will be
+ * aligned to @block_size slots followed by @block_size - 1 empty slots.
+ * @block_size must be smaller or equal to BITS_PER_LONG.
+ *
+ * Return Value: On success, the available slot is returned.
+ * On error, %-ENOSPC is returned.
+ */
+static int nilfs_palloc_find_available_slot_align(struct inode *inode,
+						  unsigned long group,
+						  unsigned long target,
+						  unsigned char *bitmap,
+						  int bsize, int block_size)
+{
+	unsigned long *end = (unsigned long *)bitmap + bsize / BITS_PER_LONG;
+	unsigned long *p = (unsigned long *)bitmap + target / BITS_PER_LONG;
+	unsigned long tmp, mask = ~(~0UL << block_size);
+	int i, j = target & (BITS_PER_LONG - 1);
+	int pos = target & ~(BITS_PER_LONG - 1);
+
+	for (i = 0; i < bsize; i += BITS_PER_LONG, pos += BITS_PER_LONG, ++p) {
+		/* wrap around */
+		if (p == end) {
+			p = (unsigned long *)bitmap;
+			pos = 0;
+		}
+
+		tmp = *p;
+		if (!tmp && !nilfs_set_bit_atomic(nilfs_mdt_bgl_lock(inode,
+						   group), pos, bitmap))
+			return pos;
+
+		if (block_size == BITS_PER_LONG || tmp == ~0UL)
+			continue;
+
+		tmp = nilfs_cpu_to_leul(tmp);
+		for (; j < BITS_PER_LONG; j += block_size) {
+			if (!(tmp & (mask << j)) &&
+			    !nilfs_set_bit_atomic(nilfs_mdt_bgl_lock(inode,
+						  group), pos + j, bitmap))
+				return pos + j;
+		}
+		j = 0;
+	}
+
+	return -ENOSPC;
+}
+
+/**
+ * nilfs_palloc_find_available_slot - find available slot in a group
+ * @inode: inode of metadata file using this allocator
+ * @group: group number
+ * @target: offset number of an entry in the group (start point)
+ * @bitmap: bitmap of the group
+ * @bsize: size in bits
+ * @block_size: size of the empty block to allocate the new entry (in bits)
+ */
+static int nilfs_palloc_find_available_slot(struct inode *inode,
+					    unsigned long group,
+					    unsigned long target,
+					    unsigned char *bitmap,
+					    int bsize, int block_size)
+{
+	if (block_size == 1)
+		return nilfs_palloc_find_available_slot_unaligned(inode, group,
+					target, bitmap, bsize);
+	else if (block_size == 32)
+		return nilfs_palloc_find_available_slot_align32(inode, group,
+					target, bitmap, bsize);
+	else
+		return nilfs_palloc_find_available_slot_align(inode, group,
+					target, bitmap, bsize, block_size);
+}
+
+/**
  * nilfs_palloc_rest_groups_in_desc_block - get the remaining number of groups
  *					    in a group descriptor block
  * @inode: inode of metadata file using this allocator
@@ -461,12 +582,29 @@ int nilfs_palloc_count_max_entries(struct inode *inode, u64 nused, u64 *nmaxp)
 }
 
 /**
- * nilfs_palloc_prepare_alloc_entry - prepare to allocate a persistent object
+ * __nilfs_palloc_prepare_alloc_entry - prepare alloc. of a persistent object
  * @inode: inode of metadata file using this allocator
  * @req: nilfs_palloc_req structure exchanged for the allocation
+ * @block_size: size of the empty block to allocate the new entry
+ * @threshold: allocate only in groups with more free entries than @threshold
+ *
+ * Description: Prepare the allocation of a persistent object. Groups with
+ * less or equal than @threshold free entries are skipped. The new entry is
+ * allocated at the start of an empty block of @block_size slots. @block_size
+ * must be less or equal to BITS_PER_LONG.
+ *
+ * Return Value: On success, 0 is returned and @req is correctly initialized.
+ * On error, one of the following negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ *
+ * %-ENOSPC - No inode left.
  */
-int nilfs_palloc_prepare_alloc_entry(struct inode *inode,
-				     struct nilfs_palloc_req *req)
+int __nilfs_palloc_prepare_alloc_entry(struct inode *inode,
+				       struct nilfs_palloc_req *req,
+				       int block_size, unsigned long threshold)
 {
 	struct buffer_head *desc_bh, *bitmap_bh;
 	struct nilfs_palloc_group_desc *desc;
@@ -478,6 +616,7 @@ int nilfs_palloc_prepare_alloc_entry(struct inode *inode,
 	unsigned long i, j;
 	int pos, ret;
 
+	block_size = (block_size > BITS_PER_LONG) ? BITS_PER_LONG : block_size;
 	ngroups = nilfs_palloc_groups_count(inode);
 	maxgroup = ngroups - 1;
 	group = nilfs_palloc_group(inode, req->pr_entry_nr, &group_offset);
@@ -501,7 +640,7 @@ int nilfs_palloc_prepare_alloc_entry(struct inode *inode,
 							   maxgroup);
 		for (j = 0; j < n; j++, desc++, group++) {
 			if (nilfs_palloc_group_desc_nfrees(inode, group, desc)
-			    > 0) {
+			    > threshold) {
 				ret = nilfs_palloc_get_bitmap_block(
 					inode, group, 1, &bitmap_bh);
 				if (ret < 0)
@@ -510,7 +649,7 @@ int nilfs_palloc_prepare_alloc_entry(struct inode *inode,
 				bitmap = bitmap_kaddr + bh_offset(bitmap_bh);
 				pos = nilfs_palloc_find_available_slot(
 					inode, group, group_offset, bitmap,
-					entries_per_group);
+					entries_per_group, block_size);
 				if (pos >= 0) {
 					/* found a free entry */
 					nilfs_palloc_group_desc_add_entries(
diff --git a/fs/nilfs2/alloc.h b/fs/nilfs2/alloc.h
index 4bd6451..1dc8557 100644
--- a/fs/nilfs2/alloc.h
+++ b/fs/nilfs2/alloc.h
@@ -64,8 +64,16 @@ struct nilfs_palloc_req {
 	struct buffer_head *pr_entry_bh;
 };
 
-int nilfs_palloc_prepare_alloc_entry(struct inode *,
-				     struct nilfs_palloc_req *);
+
+int __nilfs_palloc_prepare_alloc_entry(struct inode *,
+				       struct nilfs_palloc_req *,
+				       int, unsigned long);
+static inline int nilfs_palloc_prepare_alloc_entry(struct inode *inode,
+						   struct nilfs_palloc_req *req)
+{
+	return __nilfs_palloc_prepare_alloc_entry(inode, req, 1, 0);
+}
+
 void nilfs_palloc_commit_alloc_entry(struct inode *,
 				     struct nilfs_palloc_req *);
 void nilfs_palloc_abort_alloc_entry(struct inode *, struct nilfs_palloc_req *);
@@ -77,6 +85,12 @@ int nilfs_palloc_freev(struct inode *, __u64 *, size_t);
 #define nilfs_set_bit_atomic		ext2_set_bit_atomic
 #define nilfs_clear_bit_atomic		ext2_clear_bit_atomic
 #define nilfs_find_next_zero_bit	find_next_zero_bit_le
+#ifdef __BIG_ENDIAN
+#define nilfs_cpu_to_leul	ext2_swab
+#endif
+#ifndef nilfs_cpu_to_leul
+#define nilfs_cpu_to_leul(v)	(v)
+#endif
 
 /**
  * struct nilfs_bh_assoc - block offset and buffer head association
-- 
2.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
