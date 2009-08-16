From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 7/7] nilfs2: convert nilfs_bmap_lookup to an
	inline function
Date: Sun, 16 Aug 2009 15:51:10 +0900
Message-ID: <1250405470-23326-8-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1250405470-23326-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1250405470-23326-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
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

The nilfs_bmap_lookup() is now a wrapper function of
nilfs_bmap_lookup_at_level().

This moves the nilfs_bmap_lookup() to a header file converting it to
an inline function and gives an opportunity for optimization.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/bmap.c |   53 ++++++++++++++++++++---------------------------------
 fs/nilfs2/bmap.h |    7 ++++++-
 fs/nilfs2/mdt.c  |    4 ++--
 3 files changed, 28 insertions(+), 36 deletions(-)

diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
index f98c5c4..08834df 100644
--- a/fs/nilfs2/bmap.c
+++ b/fs/nilfs2/bmap.c
@@ -36,6 +36,26 @@ struct inode *nilfs_bmap_get_dat(const struct nilfs_bmap *bmap)
 	return nilfs_dat_inode(NILFS_I_NILFS(bmap->b_inode));
 }
 
+/**
+ * nilfs_bmap_lookup_at_level - find a data block or node block
+ * @bmap: bmap
+ * @key: key
+ * @level: level
+ * @ptrp: place to store the value associated to @key
+ *
+ * Description: nilfs_bmap_lookup_at_level() finds a record whose key
+ * matches @key in the block at @level of the bmap.
+ *
+ * Return Value: On success, 0 is returned and the record associated with @key
+ * is stored in the place pointed by @ptrp. On error, one of the following
+ * negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ *
+ * %-ENOENT - A record associated with @key does not exist.
+ */
 int nilfs_bmap_lookup_at_level(struct nilfs_bmap *bmap, __u64 key, int level,
 			       __u64 *ptrp)
 {
@@ -69,39 +89,6 @@ int nilfs_bmap_lookup_contig(struct nilfs_bmap *bmap, __u64 key, __u64 *ptrp,
 	return ret;
 }
 
-/**
- * nilfs_bmap_lookup - find a record
- * @bmap: bmap
- * @key: key
- * @recp: pointer to record
- *
- * Description: nilfs_bmap_lookup() finds a record whose key matches @key in
- * @bmap.
- *
- * Return Value: On success, 0 is returned and the record associated with @key
- * is stored in the place pointed by @recp. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-ENOENT - A record associated with @key does not exist.
- */
-int nilfs_bmap_lookup(struct nilfs_bmap *bmap,
-		      unsigned long key,
-		      unsigned long *recp)
-{
-	__u64 ptr;
-	int ret;
-
-	/* XXX: use macro for level 1 */
-	ret = nilfs_bmap_lookup_at_level(bmap, key, 1, &ptr);
-	if (recp != NULL)
-		*recp = ptr;
-	return ret;
-}
-
 static int nilfs_bmap_do_insert(struct nilfs_bmap *bmap, __u64 key, __u64 ptr)
 {
 	__u64 keys[NILFS_BMAP_SMALL_HIGH + 1];
diff --git a/fs/nilfs2/bmap.h b/fs/nilfs2/bmap.h
index a4f64e5..9980d7d 100644
--- a/fs/nilfs2/bmap.h
+++ b/fs/nilfs2/bmap.h
@@ -142,7 +142,6 @@ struct nilfs_bmap {
 int nilfs_bmap_test_and_clear_dirty(struct nilfs_bmap *);
 int nilfs_bmap_read(struct nilfs_bmap *, struct nilfs_inode *);
 void nilfs_bmap_write(struct nilfs_bmap *, struct nilfs_inode *);
-int nilfs_bmap_lookup(struct nilfs_bmap *, unsigned long, unsigned long *);
 int nilfs_bmap_lookup_contig(struct nilfs_bmap *, __u64, __u64 *, unsigned);
 int nilfs_bmap_insert(struct nilfs_bmap *, unsigned long, unsigned long);
 int nilfs_bmap_delete(struct nilfs_bmap *, unsigned long);
@@ -161,6 +160,12 @@ void nilfs_bmap_init_gcdat(struct nilfs_bmap *, struct nilfs_bmap *);
 void nilfs_bmap_commit_gcdat(struct nilfs_bmap *, struct nilfs_bmap *);
 
 
+static inline int nilfs_bmap_lookup(struct nilfs_bmap *bmap, __u64 key,
+				    __u64 *ptr)
+{
+	return nilfs_bmap_lookup_at_level(bmap, key, 1, ptr);
+}
+
 /*
  * Internal use only
  */
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 5b3faf1..c90d168 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -139,7 +139,7 @@ nilfs_mdt_submit_block(struct inode *inode, unsigned long blkoff,
 		       int mode, struct buffer_head **out_bh)
 {
 	struct buffer_head *bh;
-	unsigned long blknum = 0;
+	__u64 blknum = 0;
 	int ret = -ENOMEM;
 
 	bh = nilfs_grab_buffer(inode, inode->i_mapping, blkoff, 0);
@@ -170,7 +170,7 @@ nilfs_mdt_submit_block(struct inode *inode, unsigned long blkoff,
 			goto failed_bh;
 		}
 		bh->b_bdev = NILFS_MDT(inode)->mi_nilfs->ns_bdev;
-		bh->b_blocknr = blknum;
+		bh->b_blocknr = (sector_t)blknum;
 		set_buffer_mapped(bh);
 	}
 
-- 
1.6.3.4
