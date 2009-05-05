From: admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org
Subject: Re: nilfs_cpfile_delete_checkpoints: cannot delete
 block
Date: Tue,  5 May 2009 17:26:48 +0200
Message-ID: <D6LvKjCkn1gF.D60GTY3Z@mail.prnet.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-Language: i-default
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
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Thank you.
I will try this patch in a few hours.
If I see it correctly the patch will prevent this error in future and will not correct the current error, so I suppose that after applying the patch I will need to reformat the volume.

Bye,
David Arendt

-original message-
Subject: Re: [NILFS users] nilfs_cpfile_delete_checkpoints: cannot delete block
From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Date: 05/05/2009 13:24

Hi David,
On Mon, 04 May 2009 06:16:24 +0200, David Arendt wrote:
> Hi,
> 
> This night. I had lots of:
> 
> nilfs_btree_propagate: key = 67, level == 0
> 
> On the parition where cleanerd has failed.

This error is related to the GC failure.

Both logs indicate that btree look-up of the 67th block on the
checkpoint file failed.

I suspect inconsistency between the block on page cache and btree; the
block was removed from the btree but were remaining on the page cache.

Could you try the following bugfix patch?

The patch ensures to clear dirty state of page and buffer after
removal of block, and would prevent the inconsistency.

Thanks in advance,
Ryusuke Konishi
--
diff --git a/fs/btnode.c b/fs/btnode.c
index 5e83c60..11a7305 100644
--- a/fs/btnode.c
+++ b/fs/btnode.c
@@ -176,7 +176,6 @@ void nilfs_btnode_delete(struct buffer_head *bh)
 	struct address_space *mapping;
 	struct page *page = bh->b_page;
 	pgoff_t index = page_index(page);
-	int still_dirty;
 
 	page_cache_get(page);
 	lock_page(page);
@@ -186,12 +185,11 @@ void nilfs_btnode_delete(struct buffer_head *bh)
 		BH_DEBUG(bh, "deleting unused btnode buffer");
 
 	nilfs_forget_buffer(bh);
-	still_dirty = PageDirty(page);
 	mapping = page->mapping;
 	unlock_page(page);
 	page_cache_release(page);
 
-	if (!still_dirty && mapping)
+	if (mapping)
 		invalidate_inode_pages2_range(mapping, index, index);
 }
 
diff --git a/fs/mdt.c b/fs/mdt.c
index 2792e76..4c9fb00 100644
--- a/fs/mdt.c
+++ b/fs/mdt.c
@@ -327,7 +327,7 @@ int nilfs_mdt_delete_block(struct inode *inode, unsigned long block)
 
 	mdt_debug(3, "called (ino=%lu, blkoff=%lu)\n", inode->i_ino, block);
 	err = nilfs_bmap_delete(ii->i_bmap, block);
-	if (likely(!err)) {
+	if (!err || err == -ENOENT) {
 		nilfs_mdt_mark_dirty(inode);
 		nilfs_mdt_forget_block(inode, block);
 	}
@@ -357,7 +357,6 @@ int nilfs_mdt_forget_block(struct inode *inode, unsigned long block)
 	struct page *page;
 	unsigned long first_block;
 	int ret = 0;
-	int still_dirty;
 
 	mdt_debug(3, "called (ino=%lu, blkoff=%lu)\n", inode->i_ino, block);
 	page = find_lock_page(inode->i_mapping, index);
@@ -373,13 +372,13 @@ int nilfs_mdt_forget_block(struct inode *inode, unsigned long block)
 
 		bh = nilfs_page_get_nth_block(page, block - first_block);
 		nilfs_forget_buffer(bh);
+	} else {
+		__nilfs_clear_page_dirty(page);
 	}
-	still_dirty = PageDirty(page);
 	unlock_page(page);
 	page_cache_release(page);
 
-	if (still_dirty ||
-	    invalidate_inode_pages2_range(inode->i_mapping, index, index) != 0)
+	if (invalidate_inode_pages2_range(inode->i_mapping, index, index) != 0)
 		ret = -EBUSY;
 	mdt_debug(3, "done (err=%d)\n", ret);
 	return ret;
diff --git a/fs/page.c b/fs/page.c
index 9cf93c3..d333fef 100644
--- a/fs/page.c
+++ b/fs/page.c
@@ -129,7 +129,8 @@ void nilfs_forget_buffer(struct buffer_head *bh)
 
 	lock_buffer(bh);
 	clear_buffer_nilfs_volatile(bh);
-	if (test_clear_buffer_dirty(bh) && nilfs_page_buffers_clean(page))
+	clear_buffer_dirty(bh);
+	if (nilfs_page_buffers_clean(page))
 		__nilfs_clear_page_dirty(page);
 
 	clear_buffer_uptodate(bh);
