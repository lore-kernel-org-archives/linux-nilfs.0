From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 5/7] nilfs2: get rid of nilfs_palloc_group_is_in()
Date: Sat, 19 Sep 2015 19:33:00 +0900
Message-ID: <1442658782-3147-6-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1442658782-3147-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=j+D4zT2eSeelOO46uI1z2W1Wzgm5u4X0td/BjARekdM=;
        b=L9Jb+7dq3za6KzQtJg1HsKjsUI8qktJt/dt4C1Q3sgJ2BajcfYg6viiBD64tUE/8cE
         UDI7gxzKPfe6slA5iLiTRSnX7K279SCLJLRWC4KdEIgkLpss5BQ4ttp/MTmRMf4YyS+U
         VUA8DzcT0hu5ze+JZ6XNMQdu/U2ODclJTBtG1M1Gva2aPke+Mc22XZBHihBAyqw990M0
         gO38cV1hi0ndQzPjhBqS/Pp87H7yCgD3AuEtDPMydvuhvO1jldBWNBXTmEq8qt9RG6nX
         +/QcavayyMCP406Zk4Tm7QWjzeAg6hrOH5635NFU50YT0ZwedQ3btd6BDiQJNtHgAitM
         P4Sw==
In-Reply-To: <1442658782-3147-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-nilfs <linux-nilfs@vger.kernel.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

This unfolds nilfs_palloc_group_is_in() helper function into
nilfs_palloc_freev() function to simplify a range check and an index
calculation repeatedy performed in a loop of the function.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/alloc.c | 28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/fs/nilfs2/alloc.c b/fs/nilfs2/alloc.c
index b15daf8..5b7ee36 100644
--- a/fs/nilfs2/alloc.c
+++ b/fs/nilfs2/alloc.c
@@ -673,22 +673,6 @@ void nilfs_palloc_abort_free_entry(struct inode *inode,
 }
 
 /**
- * nilfs_palloc_group_is_in - judge if an entry is in a group
- * @inode: inode of metadata file using this allocator
- * @group: group number
- * @nr: serial number of the entry (e.g. inode number)
- */
-static int
-nilfs_palloc_group_is_in(struct inode *inode, unsigned long group, __u64 nr)
-{
-	__u64 first, last;
-
-	first = group * nilfs_palloc_entries_per_group(inode);
-	last = first + nilfs_palloc_entries_per_group(inode) - 1;
-	return (nr >= first) && (nr <= last);
-}
-
-/**
  * nilfs_palloc_freev - deallocate a set of persistent objects
  * @inode: inode of metadata file using this allocator
  * @entry_nrs: array of entry numbers to be deallocated
@@ -701,6 +685,8 @@ int nilfs_palloc_freev(struct inode *inode, __u64 *entry_nrs, size_t nitems)
 	unsigned char *bitmap;
 	void *desc_kaddr, *bitmap_kaddr;
 	unsigned long group, group_offset;
+	__u64 group_min_nr;
+	const unsigned long epg = nilfs_palloc_entries_per_group(inode);
 	spinlock_t *lock;
 	int i, j, n, ret;
 
@@ -715,6 +701,10 @@ int nilfs_palloc_freev(struct inode *inode, __u64 *entry_nrs, size_t nitems)
 			brelse(desc_bh);
 			return ret;
 		}
+
+		/* Get the first entry number of the group */
+		group_min_nr = (__u64)group * epg;
+
 		desc_kaddr = kmap(desc_bh->b_page);
 		desc = nilfs_palloc_block_get_group_desc(
 			inode, group, desc_bh, desc_kaddr);
@@ -722,10 +712,10 @@ int nilfs_palloc_freev(struct inode *inode, __u64 *entry_nrs, size_t nitems)
 		bitmap = bitmap_kaddr + bh_offset(bitmap_bh);
 		lock = nilfs_mdt_bgl_lock(inode, group);
 		for (j = i, n = 0;
-		     (j < nitems) && nilfs_palloc_group_is_in(inode, group,
-							      entry_nrs[j]);
+		     j < nitems && entry_nrs[j] >= group_min_nr &&
+			     entry_nrs[j] < group_min_nr + epg;
 		     j++) {
-			nilfs_palloc_group(inode, entry_nrs[j], &group_offset);
+			group_offset = entry_nrs[j] - group_min_nr;
 			if (!nilfs_clear_bit_atomic(lock, group_offset,
 						    bitmap)) {
 				nilfs_warning(inode->i_sb, __func__,
-- 
1.8.3.1
