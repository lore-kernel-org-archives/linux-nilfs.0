From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH 1/6] nilfs2: add helper function to go through all entries of meta data file
Date: Sun, 16 Mar 2014 11:47:34 +0100
Message-ID: <2adbf1034ab4b129223553746577f6ec0e699869.1394966729.git.andreas.rohner@gmx.net>
References: <cover.1394966728.git.andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1394966728.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
In-Reply-To: <cover.1394966728.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
References: <cover.1394966728.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

This patch introduces the nilfs_palloc_scan_entries() function,
which takes an inode of one of nilfs' meta data files and iterates
through all of its entries. For each entry the callback function
pointer that is given as a parameter is called. The data parameter
is passed to the callback function, so that it may receive
parameters and return results.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 fs/nilfs2/alloc.c | 121 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/alloc.h |   6 +++
 2 files changed, 127 insertions(+)

diff --git a/fs/nilfs2/alloc.c b/fs/nilfs2/alloc.c
index 741fd02..0edd85a 100644
--- a/fs/nilfs2/alloc.c
+++ b/fs/nilfs2/alloc.c
@@ -545,6 +545,127 @@ int nilfs_palloc_prepare_alloc_entry(struct inode *inode,
 }
 
 /**
+ * nilfs_palloc_scan_entries - scan through every entry and execute dofunc
+ * @inode: inode of metadata file using this allocator
+ * @dofunc: function executed for every entry
+ * @data: data pointer passed to dofunc
+ *
+ * Description: nilfs_palloc_scan_entries() walks through every allocated entry
+ * of a metadata file and executes dofunc on it. It passes a data pointer to
+ * dofunc, which can be used as an input parameter or for returning of results.
+ *
+ * Return Value: On success, 0 is returned. On error, a
+ * negative error code is returned.
+ */
+int nilfs_palloc_scan_entries(struct inode *inode,
+			      void (*dofunc)(struct inode *,
+					     struct nilfs_palloc_req *,
+					     void *),
+			      void *data)
+{
+	struct buffer_head *desc_bh, *bitmap_bh;
+	struct nilfs_palloc_group_desc *desc;
+	struct nilfs_palloc_req req;
+	unsigned char *bitmap;
+	void *desc_kaddr, *bitmap_kaddr;
+	unsigned long group, maxgroup, ngroups;
+	unsigned long n, m, entries_per_group, groups_per_desc_block;
+	unsigned long i, j, pos;
+	unsigned long blkoff, prev_blkoff;
+	int ret;
+
+	ngroups = nilfs_palloc_groups_count(inode);
+	maxgroup = ngroups - 1;
+	entries_per_group = nilfs_palloc_entries_per_group(inode);
+	groups_per_desc_block = nilfs_palloc_groups_per_desc_block(inode);
+
+	for (group = 0; group < ngroups;) {
+		ret = nilfs_palloc_get_desc_block(inode, group, 0, &desc_bh);
+		if (ret == -ENOENT)
+			return 0;
+		else if (ret < 0)
+			return ret;
+		req.pr_desc_bh = desc_bh;
+		desc_kaddr = kmap(desc_bh->b_page);
+		desc = nilfs_palloc_block_get_group_desc(inode, group,
+							 desc_bh, desc_kaddr);
+		n = nilfs_palloc_rest_groups_in_desc_block(inode, group,
+							   maxgroup);
+
+		for (i = 0; i < n; i++, desc++, group++) {
+			m = entries_per_group -
+					nilfs_palloc_group_desc_nfrees(inode,
+							group, desc);
+			if (!m)
+				continue;
+
+			ret = nilfs_palloc_get_bitmap_block(
+				inode, group, 0, &bitmap_bh);
+			if (ret == -ENOENT) {
+				ret = 0;
+				goto out_desc;
+			} else if (ret < 0)
+				goto out_desc;
+
+			req.pr_bitmap_bh = bitmap_bh;
+			bitmap_kaddr = kmap(bitmap_bh->b_page);
+			bitmap = bitmap_kaddr + bh_offset(bitmap_bh);
+			/* entry blkoff is always bigger than 0 */
+			blkoff = 0;
+			pos = 0;
+
+			for (j = 0; j < m; ++j, ++pos) {
+				pos = nilfs_find_next_bit(bitmap,
+						entries_per_group, pos);
+
+				if (pos >= entries_per_group)
+					break;
+
+				/* found an entry */
+				req.pr_entry_nr =
+					entries_per_group * group + pos;
+
+				prev_blkoff = blkoff;
+				blkoff = nilfs_palloc_entry_blkoff(inode,
+							req.pr_entry_nr);
+
+				if (blkoff != prev_blkoff) {
+					if (prev_blkoff)
+						brelse(req.pr_entry_bh);
+
+					ret = nilfs_palloc_get_entry_block(
+							inode, req.pr_entry_nr,
+							0, &req.pr_entry_bh);
+					if (ret < 0)
+						goto out_entry;
+				}
+
+				dofunc(inode, &req, data);
+			}
+
+			if (blkoff)
+				brelse(req.pr_entry_bh);
+			kunmap(bitmap_bh->b_page);
+			brelse(bitmap_bh);
+		}
+
+		kunmap(desc_bh->b_page);
+		brelse(desc_bh);
+	}
+
+	return 0;
+
+out_entry:
+	kunmap(bitmap_bh->b_page);
+	brelse(bitmap_bh);
+
+out_desc:
+	kunmap(desc_bh->b_page);
+	brelse(desc_bh);
+	return ret;
+}
+
+/**
  * nilfs_palloc_commit_alloc_entry - finish allocation of a persistent object
  * @inode: inode of metadata file using this allocator
  * @req: nilfs_palloc_req structure exchanged for the allocation
diff --git a/fs/nilfs2/alloc.h b/fs/nilfs2/alloc.h
index 4bd6451..0592035 100644
--- a/fs/nilfs2/alloc.h
+++ b/fs/nilfs2/alloc.h
@@ -77,6 +77,7 @@ int nilfs_palloc_freev(struct inode *, __u64 *, size_t);
 #define nilfs_set_bit_atomic		ext2_set_bit_atomic
 #define nilfs_clear_bit_atomic		ext2_clear_bit_atomic
 #define nilfs_find_next_zero_bit	find_next_zero_bit_le
+#define nilfs_find_next_bit			find_next_bit_le
 
 /**
  * struct nilfs_bh_assoc - block offset and buffer head association
@@ -106,5 +107,10 @@ void nilfs_palloc_setup_cache(struct inode *inode,
 			      struct nilfs_palloc_cache *cache);
 void nilfs_palloc_clear_cache(struct inode *inode);
 void nilfs_palloc_destroy_cache(struct inode *inode);
+int nilfs_palloc_scan_entries(struct inode *,
+			      void (*dofunc)(struct inode *,
+					     struct nilfs_palloc_req *,
+					     void *),
+			      void *);
 
 #endif	/* _NILFS_ALLOC_H */
-- 
1.9.0

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
