From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 19/23] nilfs2: add cache framework for
	persistent object allocator
Date: Sun, 15 Nov 2009 21:46:57 +0900
Message-ID: <1258289221-3827-20-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1258289221-3827-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1258289221-3827-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This adds setup and cleanup routines of the persistent object
allocator cache.

According to ftrace analyses, accessing buffers of the DAT file
suffers indispensable overhead many times.  To mitigate the overhead,
This introduce cache framework for the persistent object allocator
(palloc) which the DAT file and ifile are using.

struct nilfs_palloc_cache represents the cache object per metadata
file using palloc.

The cache is initialized through nilfs_palloc_setup_cache() and
destroyed by nilfs_palloc_destroy_cache(); callers of the former
function will be added to individual allocators of DAT and ifile on
successive patches.

nilfs_palloc_destroy_cache() will be called from nilfs_mdt_destroy()
if the cache is attached to a metadata file.  A companion function
nilfs_palloc_clear_cache() is provided to allow releasing buffer head
references independently with the cleanup task.  This adjunctive
function will be used before invalidating pages of metadata file with
the cache.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/alloc.c |   27 +++++++++++++++++++++++++++
 fs/nilfs2/alloc.h |   21 +++++++++++++++++++++
 fs/nilfs2/mdt.c   |    2 ++
 fs/nilfs2/mdt.h   |    2 ++
 4 files changed, 52 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/alloc.c b/fs/nilfs2/alloc.c
index 7e2b3ce..c56300d 100644
--- a/fs/nilfs2/alloc.c
+++ b/fs/nilfs2/alloc.c
@@ -491,3 +491,30 @@ int nilfs_palloc_freev(struct inode *inode, __u64 *entry_nrs, size_t nitems)
 	}
 	return 0;
 }
+
+void nilfs_palloc_setup_cache(struct inode *inode,
+			      struct nilfs_palloc_cache *cache)
+{
+	NILFS_MDT(inode)->mi_palloc_cache = cache;
+	spin_lock_init(&cache->lock);
+}
+
+void nilfs_palloc_clear_cache(struct inode *inode)
+{
+	struct nilfs_palloc_cache *cache = NILFS_MDT(inode)->mi_palloc_cache;
+
+	spin_lock(&cache->lock);
+	brelse(cache->prev_desc.bh);
+	brelse(cache->prev_bitmap.bh);
+	brelse(cache->prev_entry.bh);
+	cache->prev_desc.bh = NULL;
+	cache->prev_bitmap.bh = NULL;
+	cache->prev_entry.bh = NULL;
+	spin_unlock(&cache->lock);
+}
+
+void nilfs_palloc_destroy_cache(struct inode *inode)
+{
+	nilfs_palloc_clear_cache(inode);
+	NILFS_MDT(inode)->mi_palloc_cache = NULL;
+}
diff --git a/fs/nilfs2/alloc.h b/fs/nilfs2/alloc.h
index 4ace547..f4543ac 100644
--- a/fs/nilfs2/alloc.h
+++ b/fs/nilfs2/alloc.h
@@ -69,4 +69,25 @@ int nilfs_palloc_freev(struct inode *, __u64 *, size_t);
 #define nilfs_clear_bit_atomic		ext2_clear_bit_atomic
 #define nilfs_find_next_zero_bit	ext2_find_next_zero_bit
 
+/*
+ * persistent object allocator cache
+ */
+
+struct nilfs_bh_assoc {
+	unsigned long blkoff;
+	struct buffer_head *bh;
+};
+
+struct nilfs_palloc_cache {
+	spinlock_t lock;
+	struct nilfs_bh_assoc prev_desc;
+	struct nilfs_bh_assoc prev_bitmap;
+	struct nilfs_bh_assoc prev_entry;
+};
+
+void nilfs_palloc_setup_cache(struct inode *inode,
+			      struct nilfs_palloc_cache *cache);
+void nilfs_palloc_clear_cache(struct inode *inode);
+void nilfs_palloc_destroy_cache(struct inode *inode);
+
 #endif	/* _NILFS_ALLOC_H */
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 948b1f8..06713ff 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -571,6 +571,8 @@ void nilfs_mdt_destroy(struct inode *inode)
 {
 	struct nilfs_mdt_info *mdi = NILFS_MDT(inode);
 
+	if (mdi->mi_palloc_cache)
+		nilfs_palloc_destroy_cache(inode);
 	nilfs_mdt_clear(inode);
 
 	kfree(mdi->mi_bgl); /* kfree(NULL) is safe */
diff --git a/fs/nilfs2/mdt.h b/fs/nilfs2/mdt.h
index c396b6c..6c4bbb0 100644
--- a/fs/nilfs2/mdt.h
+++ b/fs/nilfs2/mdt.h
@@ -36,6 +36,7 @@
  * @mi_entry_size: size of an entry
  * @mi_first_entry_offset: offset to the first entry
  * @mi_entries_per_block: number of entries in a block
+ * @mi_palloc_cache: persistent object allocator cache
  * @mi_blocks_per_group: number of blocks in a group
  * @mi_blocks_per_desc_block: number of blocks per descriptor block
  */
@@ -46,6 +47,7 @@ struct nilfs_mdt_info {
 	unsigned		mi_entry_size;
 	unsigned		mi_first_entry_offset;
 	unsigned long		mi_entries_per_block;
+	struct nilfs_palloc_cache *mi_palloc_cache;
 	unsigned long		mi_blocks_per_group;
 	unsigned long		mi_blocks_per_desc_block;
 };
-- 
1.6.3.4
