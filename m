From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH] nilfs2: rework error message subsystem
Date: Mon, 02 Dec 2013 18:08:53 +0400
Message-ID: <1385993333.3945.3.camel@slavad-ubuntu>
Reply-To: slava@dubeyko.com
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=ar87Hc5a2ihwUT47/A2BjjMZUyOTFp7xe4z7f9ny9Zw=;
	b=GjZH5g4rp/SNMIuOji+2NMldNdFfgHrY3+pQfJjTcYuMwPLbiQO6FdHbUtraSmwnKToKNRAamgCJ2fIlg6OD285sslZiv589gM6Dao/Msun3SIohl2oEjp/w4gRD5MUi;
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Michael Conrad <mconrad@intellitree.com>, linux-nilfs@vger.kernel.org, Linux FS Devel <linux-fsdevel@vger.kernel.org>, akpm@linux-foundation.org

From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH] nilfs2: rework error message subsystem

There are situations when real error can emit huge amount of
messages. As a result, system log contains many identical
error messages. This patch changes printk on
pr_[err|warn]_ratelimited version in proper places. Also
printk was changed on pr_[err|warning|info] version in
other places.

Reported-by: Michael Conrad <mconrad@intellitree.com>
Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
CC: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/alloc.c     |   26 ++++++++-------
 fs/nilfs2/btree.c     |   27 ++++++++--------
 fs/nilfs2/cpfile.c    |   13 ++++----
 fs/nilfs2/dat.c       |    8 ++---
 fs/nilfs2/direct.c    |    8 ++---
 fs/nilfs2/inode.c     |   10 ++----
 fs/nilfs2/ioctl.c     |   30 ++++++++---------
 fs/nilfs2/page.c      |   18 +++++------
 fs/nilfs2/recovery.c  |   49 ++++++++++------------------
 fs/nilfs2/segbuf.c    |    3 +-
 fs/nilfs2/segment.c   |   18 ++++-------
 fs/nilfs2/sufile.c    |   19 +++++------
 fs/nilfs2/super.c     |   85 ++++++++++++++++++++-----------------------------
 fs/nilfs2/the_nilfs.c |   80 +++++++++++++++++++---------------------------
 14 files changed, 170 insertions(+), 224 deletions(-)

diff --git a/fs/nilfs2/alloc.c b/fs/nilfs2/alloc.c
index 741fd02..5a77178 100644
--- a/fs/nilfs2/alloc.c
+++ b/fs/nilfs2/alloc.c
@@ -581,10 +581,11 @@ void nilfs_palloc_commit_free_entry(struct inode *inode,
 	bitmap = bitmap_kaddr + bh_offset(req->pr_bitmap_bh);
 
 	if (!nilfs_clear_bit_atomic(nilfs_mdt_bgl_lock(inode, group),
-				    group_offset, bitmap))
-		printk(KERN_WARNING "%s: entry number %llu already freed\n",
-		       __func__, (unsigned long long)req->pr_entry_nr);
-	else
+				    group_offset, bitmap)) {
+		pr_warn_ratelimited("%s: entry number %llu already freed\n",
+					__func__,
+					(unsigned long long)req->pr_entry_nr);
+	} else
 		nilfs_palloc_group_desc_add_entries(inode, group, desc, 1);
 
 	kunmap(req->pr_bitmap_bh->b_page);
@@ -618,10 +619,11 @@ void nilfs_palloc_abort_alloc_entry(struct inode *inode,
 	bitmap_kaddr = kmap(req->pr_bitmap_bh->b_page);
 	bitmap = bitmap_kaddr + bh_offset(req->pr_bitmap_bh);
 	if (!nilfs_clear_bit_atomic(nilfs_mdt_bgl_lock(inode, group),
-				    group_offset, bitmap))
-		printk(KERN_WARNING "%s: entry number %llu already freed\n",
-		       __func__, (unsigned long long)req->pr_entry_nr);
-	else
+				    group_offset, bitmap)) {
+		pr_warn_ratelimited("%s: entry number %llu already freed\n",
+					__func__,
+					(unsigned long long)req->pr_entry_nr);
+	} else
 		nilfs_palloc_group_desc_add_entries(inode, group, desc, 1);
 
 	kunmap(req->pr_bitmap_bh->b_page);
@@ -733,10 +735,10 @@ int nilfs_palloc_freev(struct inode *inode, __u64 *entry_nrs, size_t nitems)
 			if (!nilfs_clear_bit_atomic(
 				    nilfs_mdt_bgl_lock(inode, group),
 				    group_offset, bitmap)) {
-				printk(KERN_WARNING
-				       "%s: entry number %llu already freed\n",
-				       __func__,
-				       (unsigned long long)entry_nrs[j]);
+				pr_warn_ratelimited(
+					"%s: entry number %llu already freed\n",
+					__func__,
+					(unsigned long long)entry_nrs[j]);
 			} else {
 				n++;
 			}
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index b2e3ff3..a6a8df0 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -356,13 +356,13 @@ static int nilfs_btree_node_broken(const struct nilfs_btree_node *node,
 	nchildren = nilfs_btree_node_get_nchildren(node);
 
 	if (unlikely(level < NILFS_BTREE_LEVEL_NODE_MIN ||
-		     level >= NILFS_BTREE_LEVEL_MAX ||
-		     (flags & NILFS_BTREE_NODE_ROOT) ||
-		     nchildren < 0 ||
-		     nchildren > NILFS_BTREE_NODE_NCHILDREN_MAX(size))) {
-		printk(KERN_CRIT "NILFS: bad btree node (blocknr=%llu): "
-		       "level = %d, flags = 0x%x, nchildren = %d\n",
-		       (unsigned long long)blocknr, level, flags, nchildren);
+	    level >= NILFS_BTREE_LEVEL_MAX ||
+	    (flags & NILFS_BTREE_NODE_ROOT) ||
+	    nchildren < 0 ||
+	    nchildren > NILFS_BTREE_NODE_NCHILDREN_MAX(size))) {
+		pr_crit_ratelimited("NILFS: bad btree node (blocknr=%llu): level = %d, flags = 0x%x, nchildren = %d\n",
+				    (unsigned long long)blocknr, level,
+				    flags, nchildren);
 		ret = 1;
 	}
 	return ret;
@@ -427,8 +427,8 @@ nilfs_btree_bad_node(struct nilfs_btree_node *node, int level)
 {
 	if (unlikely(nilfs_btree_node_get_level(node) != level)) {
 		dump_stack();
-		printk(KERN_CRIT "NILFS: btree level mismatch: %d != %d\n",
-		       nilfs_btree_node_get_level(node), level);
+		pr_crit_ratelimited("NILFS: btree level mismatch: %d != %d\n",
+				    nilfs_btree_node_get_level(node), level);
 		return 1;
 	}
 	return 0;
@@ -1989,8 +1989,9 @@ static int nilfs_btree_propagate(struct nilfs_bmap *btree,
 	ret = nilfs_btree_do_lookup(btree, path, key, NULL, level + 1, 0);
 	if (ret < 0) {
 		if (unlikely(ret == -ENOENT))
-			printk(KERN_CRIT "%s: key = %llu, level == %d\n",
-			       __func__, (unsigned long long)key, level);
+			pr_crit_ratelimited("%s: key = %llu, level == %d\n",
+					    __func__,
+					    (unsigned long long)key, level);
 		goto out;
 	}
 
@@ -2027,9 +2028,7 @@ static void nilfs_btree_add_dirty_buffer(struct nilfs_bmap *btree,
 	if (level < NILFS_BTREE_LEVEL_NODE_MIN ||
 	    level >= NILFS_BTREE_LEVEL_MAX) {
 		dump_stack();
-		printk(KERN_WARNING
-		       "%s: invalid btree level: %d (key=%llu, ino=%lu, "
-		       "blocknr=%llu)\n",
+		pr_warn_ratelimited("%s: invalid btree level: %d (key=%llu, ino=%lu, blocknr=%llu)\n",
 		       __func__, level, (unsigned long long)key,
 		       NILFS_BMAP_I(btree)->vfs_inode.i_ino,
 		       (unsigned long long)bh->b_blocknr);
diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index deaa3d3..a8c1d437 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -289,9 +289,10 @@ int nilfs_cpfile_delete_checkpoints(struct inode *cpfile,
 	int ret, ncps, nicps, nss, count, i;
 
 	if (unlikely(start == 0 || start > end)) {
-		printk(KERN_ERR "%s: invalid range of checkpoint numbers: "
-		       "[%llu, %llu)\n", __func__,
-		       (unsigned long long)start, (unsigned long long)end);
+		pr_err_ratelimited("%s: invalid range of checkpoint numbers: [%llu, %llu)\n",
+				    __func__,
+				    (unsigned long long)start,
+				    (unsigned long long)end);
 		return -EINVAL;
 	}
 
@@ -343,9 +344,9 @@ int nilfs_cpfile_delete_checkpoints(struct inode *cpfile,
 								   cpfile, cno);
 					if (ret == 0)
 						continue;
-					printk(KERN_ERR
-					       "%s: cannot delete block\n",
-					       __func__);
+					pr_err_ratelimited(
+						"%s: cannot delete block\n",
+						__func__);
 					break;
 				}
 			}
diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index fa0f803..df976b6 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -355,10 +355,10 @@ int nilfs_dat_move(struct inode *dat, __u64 vblocknr, sector_t blocknr)
 	kaddr = kmap_atomic(entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, vblocknr, entry_bh, kaddr);
 	if (unlikely(entry->de_blocknr == cpu_to_le64(0))) {
-		printk(KERN_CRIT "%s: vbn = %llu, [%llu, %llu)\n", __func__,
-		       (unsigned long long)vblocknr,
-		       (unsigned long long)le64_to_cpu(entry->de_start),
-		       (unsigned long long)le64_to_cpu(entry->de_end));
+		pr_crit_ratelimited("%s: vbn = %llu, [%llu, %llu)\n", __func__,
+			(unsigned long long)vblocknr,
+			(unsigned long long)le64_to_cpu(entry->de_start),
+			(unsigned long long)le64_to_cpu(entry->de_end));
 		kunmap_atomic(kaddr);
 		brelse(entry_bh);
 		return -EINVAL;
diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
index 82f4865..5dcf67d 100644
--- a/fs/nilfs2/direct.c
+++ b/fs/nilfs2/direct.c
@@ -325,14 +325,14 @@ static int nilfs_direct_assign(struct nilfs_bmap *bmap,
 
 	key = nilfs_bmap_data_get_key(bmap, *bh);
 	if (unlikely(key > NILFS_DIRECT_KEY_MAX)) {
-		printk(KERN_CRIT "%s: invalid key: %llu\n", __func__,
-		       (unsigned long long)key);
+		pr_crit_ratelimited("%s: invalid key: %llu\n", __func__,
+				    (unsigned long long)key);
 		return -EINVAL;
 	}
 	ptr = nilfs_direct_get_ptr(bmap, key);
 	if (unlikely(ptr == NILFS_BMAP_INVALID_PTR)) {
-		printk(KERN_CRIT "%s: invalid pointer: %llu\n", __func__,
-		       (unsigned long long)ptr);
+		pr_crit_ratelimited("%s: invalid pointer: %llu\n", __func__,
+				    (unsigned long long)ptr);
 		return -EINVAL;
 	}
 
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 7e350c5..3b07089 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -113,13 +113,9 @@ int nilfs_get_block(struct inode *inode, sector_t blkoff,
 				 * However, the page having this block must
 				 * be locked in this case.
 				 */
-				printk(KERN_WARNING
-				       "nilfs_get_block: a race condition "
-				       "while inserting a data block. "
-				       "(inode number=%lu, file block "
-				       "offset=%llu)\n",
-				       inode->i_ino,
-				       (unsigned long long)blkoff);
+				pr_warn_ratelimited("nilfs_get_block: a race condition while inserting a data block. (inode number=%lu, file block offset=%llu)\n",
+						    inode->i_ino,
+						    (unsigned long long)blkoff);
 				err = 0;
 			}
 			nilfs_transaction_abort(inode->i_sb);
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index b44bdb2..d7a2b0a 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -369,20 +369,20 @@ static int nilfs_ioctl_move_inode_block(struct inode *inode,
 
 	if (unlikely(ret < 0)) {
 		if (ret == -ENOENT)
-			printk(KERN_CRIT
-			       "%s: invalid virtual block address (%s): "
-			       "ino=%llu, cno=%llu, offset=%llu, "
-			       "blocknr=%llu, vblocknr=%llu\n",
-			       __func__, vdesc->vd_flags ? "node" : "data",
-			       (unsigned long long)vdesc->vd_ino,
-			       (unsigned long long)vdesc->vd_cno,
-			       (unsigned long long)vdesc->vd_offset,
-			       (unsigned long long)vdesc->vd_blocknr,
-			       (unsigned long long)vdesc->vd_vblocknr);
+			pr_crit_ratelimited(
+				"%s: invalid virtual block address (%s): "
+				"ino=%llu, cno=%llu, offset=%llu, "
+				"blocknr=%llu, vblocknr=%llu\n",
+				__func__, vdesc->vd_flags ? "node" : "data",
+				(unsigned long long)vdesc->vd_ino,
+				(unsigned long long)vdesc->vd_cno,
+				(unsigned long long)vdesc->vd_offset,
+				(unsigned long long)vdesc->vd_blocknr,
+				(unsigned long long)vdesc->vd_vblocknr);
 		return ret;
 	}
 	if (unlikely(!list_empty(&bh->b_assoc_buffers))) {
-		printk(KERN_CRIT "%s: conflicting %s buffer: ino=%llu, "
+		pr_crit_ratelimited("%s: conflicting %s buffer: ino=%llu, "
 		       "cno=%llu, offset=%llu, blocknr=%llu, vblocknr=%llu\n",
 		       __func__, vdesc->vd_flags ? "node" : "data",
 		       (unsigned long long)vdesc->vd_ino,
@@ -566,8 +566,8 @@ int nilfs_ioctl_prepare_clean_segments(struct the_nilfs *nilfs,
 	return 0;
 
  failed:
-	printk(KERN_ERR "NILFS: GC failed during preparation: %s: err=%d\n",
-	       msg, ret);
+	pr_err_ratelimited("NILFS: GC failed during preparation: %s: err=%d\n",
+			    msg, ret);
 	return ret;
 }
 
@@ -662,8 +662,8 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
 
 	ret = nilfs_ioctl_move_blocks(inode->i_sb, &argv[0], kbufs[0]);
 	if (ret < 0)
-		printk(KERN_ERR "NILFS: GC failed during preparation: "
-			"cannot read source blocks: err=%d\n", ret);
+		pr_err_ratelimited("NILFS: GC failed during preparation: cannot read source blocks: err=%d\n",
+				    ret);
 	else {
 		if (nilfs_sb_need_update(nilfs))
 			set_nilfs_discontinued(nilfs);
diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index da27664..e1cdcd5 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -173,17 +173,17 @@ void nilfs_page_bug(struct page *page)
 	unsigned long ino;
 
 	if (unlikely(!page)) {
-		printk(KERN_CRIT "NILFS_PAGE_BUG(NULL)\n");
+		pr_crit_ratelimited("NILFS_PAGE_BUG(NULL)\n");
 		return;
 	}
 
 	m = page->mapping;
 	ino = m ? m->host->i_ino : 0;
 
-	printk(KERN_CRIT "NILFS_PAGE_BUG(%p): cnt=%d index#=%llu flags=0x%lx "
-	       "mapping=%p ino=%lu\n",
-	       page, atomic_read(&page->_count),
-	       (unsigned long long)page->index, page->flags, m, ino);
+	pr_crit_ratelimited("NILFS_PAGE_BUG(%p): cnt=%d index#=%llu flags=0x%lx mapping=%p ino=%lu\n",
+			    page, atomic_read(&page->_count),
+			    (unsigned long long)page->index,
+			    page->flags, m, ino);
 
 	if (page_has_buffers(page)) {
 		struct buffer_head *bh, *head;
@@ -191,10 +191,10 @@ void nilfs_page_bug(struct page *page)
 
 		bh = head = page_buffers(page);
 		do {
-			printk(KERN_CRIT
-			       " BH[%d] %p: cnt=%d block#=%llu state=0x%lx\n",
-			       i++, bh, atomic_read(&bh->b_count),
-			       (unsigned long long)bh->b_blocknr, bh->b_state);
+			pr_crit_ratelimited(" BH[%d] %p: cnt=%d block#=%llu state=0x%lx\n",
+					    i++, bh, atomic_read(&bh->b_count),
+					    (unsigned long long)bh->b_blocknr,
+					    bh->b_state);
 			bh = bh->b_this_page;
 		} while (bh != head);
 	}
diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index ff00a0b..27cc03d 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -60,32 +60,25 @@ static int nilfs_warn_segment_error(int err)
 {
 	switch (err) {
 	case NILFS_SEG_FAIL_IO:
-		printk(KERN_WARNING
-		       "NILFS warning: I/O error on loading last segment\n");
+		pr_warn("NILFS warning: I/O error on loading last segment\n");
 		return -EIO;
 	case NILFS_SEG_FAIL_MAGIC:
-		printk(KERN_WARNING
-		       "NILFS warning: Segment magic number invalid\n");
+		pr_warn("NILFS warning: Segment magic number invalid\n");
 		break;
 	case NILFS_SEG_FAIL_SEQ:
-		printk(KERN_WARNING
-		       "NILFS warning: Sequence number mismatch\n");
+		pr_warn("NILFS warning: Sequence number mismatch\n");
 		break;
 	case NILFS_SEG_FAIL_CHECKSUM_SUPER_ROOT:
-		printk(KERN_WARNING
-		       "NILFS warning: Checksum error in super root\n");
+		pr_warn("NILFS warning: Checksum error in super root\n");
 		break;
 	case NILFS_SEG_FAIL_CHECKSUM_FULL:
-		printk(KERN_WARNING
-		       "NILFS warning: Checksum error in segment payload\n");
+		pr_warn("NILFS warning: Checksum error in segment payload\n");
 		break;
 	case NILFS_SEG_FAIL_CONSISTENCY:
-		printk(KERN_WARNING
-		       "NILFS warning: Inconsistent segment\n");
+		pr_warn("NILFS warning: Inconsistent segment\n");
 		break;
 	case NILFS_SEG_NO_SUPER_ROOT:
-		printk(KERN_WARNING
-		       "NILFS warning: No super root in the last segment\n");
+		pr_warn("NILFS warning: No super root in the last segment\n");
 		break;
 	}
 	return -EINVAL;
@@ -554,11 +547,9 @@ static int nilfs_recover_dsync_blocks(struct the_nilfs *nilfs,
 		page_cache_release(page);
 
  failed_inode:
-		printk(KERN_WARNING
-		       "NILFS warning: error recovering data block "
-		       "(err=%d, ino=%lu, block-offset=%llu)\n",
-		       err, (unsigned long)rb->ino,
-		       (unsigned long long)rb->blkoff);
+		pr_warn("NILFS warning: error recovering data block (err=%d, ino=%lu, block-offset=%llu)\n",
+			err, (unsigned long)rb->ino,
+			(unsigned long long)rb->blkoff);
 		if (!err2)
 			err2 = err;
  next:
@@ -681,8 +672,8 @@ static int nilfs_do_roll_forward(struct the_nilfs *nilfs,
 	}
 
 	if (nsalvaged_blocks) {
-		printk(KERN_INFO "NILFS (device %s): salvaged %lu blocks\n",
-		       sb->s_id, nsalvaged_blocks);
+		pr_info("NILFS (device %s): salvaged %lu blocks\n",
+			sb->s_id, nsalvaged_blocks);
 		ri->ri_need_recovery = NILFS_RECOVERY_ROLLFORWARD_DONE;
 	}
  out:
@@ -693,9 +684,7 @@ static int nilfs_do_roll_forward(struct the_nilfs *nilfs,
  confused:
 	err = -EINVAL;
  failed:
-	printk(KERN_ERR
-	       "NILFS (device %s): Error roll-forwarding "
-	       "(err=%d, pseg block=%llu). ",
+	pr_err("NILFS (device %s): Error roll-forwarding (err=%d, pseg block=%llu). ",
 	       sb->s_id, err, (unsigned long long)pseg_start);
 	goto out;
 }
@@ -716,9 +705,7 @@ static void nilfs_finish_roll_forward(struct the_nilfs *nilfs,
 	set_buffer_dirty(bh);
 	err = sync_dirty_buffer(bh);
 	if (unlikely(err))
-		printk(KERN_WARNING
-		       "NILFS warning: buffer sync write failed during "
-		       "post-cleaning of recovery.\n");
+		pr_warn("NILFS warning: buffer sync write failed during post-cleaning of recovery.\n");
 	brelse(bh);
 }
 
@@ -753,8 +740,7 @@ int nilfs_salvage_orphan_logs(struct the_nilfs *nilfs,
 
 	err = nilfs_attach_checkpoint(sb, ri->ri_cno, true, &root);
 	if (unlikely(err)) {
-		printk(KERN_ERR
-		       "NILFS: error loading the latest checkpoint.\n");
+		pr_err("NILFS: error loading the latest checkpoint.\n");
 		return err;
 	}
 
@@ -765,8 +751,7 @@ int nilfs_salvage_orphan_logs(struct the_nilfs *nilfs,
 	if (ri->ri_need_recovery == NILFS_RECOVERY_ROLLFORWARD_DONE) {
 		err = nilfs_prepare_segment_for_recovery(nilfs, sb, ri);
 		if (unlikely(err)) {
-			printk(KERN_ERR "NILFS: Error preparing segments for "
-			       "recovery.\n");
+			pr_err("NILFS: Error preparing segments for recovery.\n");
 			goto failed;
 		}
 
@@ -779,7 +764,7 @@ int nilfs_salvage_orphan_logs(struct the_nilfs *nilfs,
 		nilfs_detach_log_writer(sb);
 
 		if (unlikely(err)) {
-			printk(KERN_ERR "NILFS: Oops! recovery failed. "
+			pr_err("NILFS: Oops! recovery failed. "
 			       "(err=%d)\n", err);
 			goto failed;
 		}
diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index 2d8be51..09671ab 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -528,7 +528,8 @@ static int nilfs_segbuf_wait(struct nilfs_segment_buffer *segbuf)
 	} while (--segbuf->sb_nbio > 0);
 
 	if (unlikely(atomic_read(&segbuf->sb_err) > 0)) {
-		printk(KERN_ERR "NILFS: IO error writing segment\n");
+		pr_err_ratelimited("NILFS: IO error writing segment %llu\n",
+				    segbuf->sb_segnum);
 		err = -EIO;
 	}
 	return err;
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 9f6b486..55bd8b2 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -129,9 +129,7 @@ static int nilfs_prepare_segment_lock(struct nilfs_transaction_info *ti)
 			 * it is saved and will be restored on
 			 * nilfs_transaction_commit().
 			 */
-			printk(KERN_WARNING
-			       "NILFS warning: journal info from a different "
-			       "FS\n");
+			pr_warn_ratelimited("NILFS warning: journal info from a different FS\n");
 			save = current->journal_info;
 		}
 	}
@@ -2368,9 +2366,8 @@ int nilfs_clean_segments(struct super_block *sb, struct nilfs_argv *argv,
 		int ret = nilfs_discard_segments(nilfs, sci->sc_freesegs,
 						 sci->sc_nfreesegs);
 		if (ret) {
-			printk(KERN_WARNING
-			       "NILFS warning: error %d on discard request, "
-			       "turning discards off for the device\n", ret);
+			pr_warn_ratelimited("NILFS warning: error %d on discard request, turning discards off for the device\n",
+					    ret);
 			nilfs_clear_opt(nilfs, DISCARD);
 		}
 	}
@@ -2453,10 +2450,8 @@ static int nilfs_segctor_thread(void *arg)
 	/* start sync. */
 	sci->sc_task = current;
 	wake_up(&sci->sc_wait_task); /* for nilfs_segctor_start_thread() */
-	printk(KERN_INFO
-	       "segctord starting. Construction interval = %lu seconds, "
-	       "CP frequency < %lu seconds\n",
-	       sci->sc_interval / HZ, sci->sc_mjcp_freq / HZ);
+	pr_info("segctord starting. Construction interval = %lu seconds, CP frequency < %lu seconds\n",
+		sci->sc_interval / HZ, sci->sc_mjcp_freq / HZ);
 
 	spin_lock(&sci->sc_state_lock);
  loop:
@@ -2530,8 +2525,7 @@ static int nilfs_segctor_start_thread(struct nilfs_sc_info *sci)
 	if (IS_ERR(t)) {
 		int err = PTR_ERR(t);
 
-		printk(KERN_ERR "NILFS: error %d creating segctord thread\n",
-		       err);
+		pr_err("NILFS: error %d creating segctord thread\n", err);
 		return err;
 	}
 	wait_event(sci->sc_wait_task, sci->sc_task != NULL);
diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 3127e9f..3e87f1b 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -181,9 +181,10 @@ int nilfs_sufile_updatev(struct inode *sufile, __u64 *segnumv, size_t nsegs,
 	down_write(&NILFS_MDT(sufile)->mi_sem);
 	for (seg = segnumv; seg < segnumv + nsegs; seg++) {
 		if (unlikely(*seg >= nilfs_sufile_get_nsegments(sufile))) {
-			printk(KERN_WARNING
-			       "%s: invalid segment number: %llu\n", __func__,
-			       (unsigned long long)*seg);
+			pr_warn_ratelimited(
+				"%s: invalid segment number: %llu\n",
+				__func__,
+				(unsigned long long)*seg);
 			nerr++;
 		}
 	}
@@ -240,8 +241,8 @@ int nilfs_sufile_update(struct inode *sufile, __u64 segnum, int create,
 	int ret;
 
 	if (unlikely(segnum >= nilfs_sufile_get_nsegments(sufile))) {
-		printk(KERN_WARNING "%s: invalid segment number: %llu\n",
-		       __func__, (unsigned long long)segnum);
+		pr_warn_ratelimited("%s: invalid segment number: %llu\n",
+					__func__, (unsigned long long)segnum);
 		return -EINVAL;
 	}
 	down_write(&NILFS_MDT(sufile)->mi_sem);
@@ -416,8 +417,8 @@ void nilfs_sufile_do_cancel_free(struct inode *sufile, __u64 segnum,
 	kaddr = kmap_atomic(su_bh->b_page);
 	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, su_bh, kaddr);
 	if (unlikely(!nilfs_segment_usage_clean(su))) {
-		printk(KERN_WARNING "%s: segment %llu must be clean\n",
-		       __func__, (unsigned long long)segnum);
+		pr_warn_ratelimited("%s: segment %llu must be clean\n",
+					__func__, (unsigned long long)segnum);
 		kunmap_atomic(kaddr);
 		return;
 	}
@@ -473,8 +474,8 @@ void nilfs_sufile_do_free(struct inode *sufile, __u64 segnum,
 	kaddr = kmap_atomic(su_bh->b_page);
 	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, su_bh, kaddr);
 	if (nilfs_segment_usage_clean(su)) {
-		printk(KERN_WARNING "%s: segment %llu is already clean\n",
-		       __func__, (unsigned long long)segnum);
+		pr_warn_ratelimited("%s: segment %llu is already clean\n",
+					__func__, (unsigned long long)segnum);
 		kunmap_atomic(kaddr);
 		return;
 	}
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 7ac2a12..846fada 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -118,8 +118,8 @@ void nilfs_error(struct super_block *sb, const char *function,
 	vaf.fmt = fmt;
 	vaf.va = &args;
 
-	printk(KERN_CRIT "NILFS error (device %s): %s: %pV\n",
-	       sb->s_id, function, &vaf);
+	pr_crit_ratelimited("NILFS error (device %s): %s: %pV\n",
+			    sb->s_id, function, &vaf);
 
 	va_end(args);
 
@@ -127,7 +127,7 @@ void nilfs_error(struct super_block *sb, const char *function,
 		nilfs_set_error(sb);
 
 		if (nilfs_test_opt(nilfs, ERRORS_RO)) {
-			printk(KERN_CRIT "Remounting filesystem read-only\n");
+			pr_crit_ratelimited("Remounting filesystem read-only\n");
 			sb->s_flags |= MS_RDONLY;
 		}
 	}
@@ -148,8 +148,8 @@ void nilfs_warning(struct super_block *sb, const char *function,
 	vaf.fmt = fmt;
 	vaf.va = &args;
 
-	printk(KERN_WARNING "NILFS warning (device %s): %s: %pV\n",
-	       sb->s_id, function, &vaf);
+	pr_warn_ratelimited("NILFS warning (device %s): %s: %pV\n",
+			    sb->s_id, function, &vaf);
 
 	va_end(args);
 }
@@ -202,8 +202,7 @@ static int nilfs_sync_super(struct super_block *sb, int flag)
 	}
 
 	if (unlikely(err)) {
-		printk(KERN_ERR
-		       "NILFS: unable to write superblock (err=%d)\n", err);
+		pr_err("NILFS: unable to write superblock (err=%d)\n", err);
 		if (err == -EIO && nilfs->ns_sbh[1]) {
 			/*
 			 * sbp[0] points to newer log than sbp[1],
@@ -273,8 +272,8 @@ struct nilfs_super_block **nilfs_prepare_super(struct super_block *sb,
 		    sbp[1]->s_magic == cpu_to_le16(NILFS_SUPER_MAGIC)) {
 			memcpy(sbp[0], sbp[1], nilfs->ns_sbsize);
 		} else {
-			printk(KERN_CRIT "NILFS: superblock broke on dev %s\n",
-			       sb->s_id);
+			pr_crit("NILFS: superblock broke on dev %s\n",
+				sb->s_id);
 			return NULL;
 		}
 	} else if (sbp[1] &&
@@ -378,9 +377,8 @@ static int nilfs_move_2nd_super(struct super_block *sb, loff_t sb2off)
 	offset = sb2off & (nilfs->ns_blocksize - 1);
 	nsbh = sb_getblk(sb, newblocknr);
 	if (!nsbh) {
-		printk(KERN_WARNING
-		       "NILFS warning: unable to move secondary superblock "
-		       "to block %llu\n", (unsigned long long)newblocknr);
+		pr_warn("NILFS warning: unable to move secondary superblock to block %llu\n",
+			(unsigned long long)newblocknr);
 		ret = -EIO;
 		goto out;
 	}
@@ -540,8 +538,7 @@ int nilfs_attach_checkpoint(struct super_block *sb, __u64 cno, int curr_mnt,
 	up_read(&nilfs->ns_segctor_sem);
 	if (unlikely(err)) {
 		if (err == -ENOENT || err == -EINVAL) {
-			printk(KERN_ERR
-			       "NILFS: Invalid checkpoint "
+			pr_err("NILFS: Invalid checkpoint "
 			       "(checkpoint number=%llu)\n",
 			       (unsigned long long)cno);
 			err = -EINVAL;
@@ -639,9 +636,8 @@ static int nilfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	err = nilfs_ifile_count_free_inodes(root->ifile,
 					    &nmaxinodes, &nfreeinodes);
 	if (unlikely(err)) {
-		printk(KERN_WARNING
-			"NILFS warning: fail to count free inodes: err %d.\n",
-			err);
+		pr_warn_ratelimited("NILFS warning: fail to count free inodes: err %d.\n",
+				    err);
 		if (err == -ERANGE) {
 			/*
 			 * If nilfs_palloc_count_max_entries() returns
@@ -772,9 +768,8 @@ static int parse_options(char *options, struct super_block *sb, int is_remount)
 			break;
 		case Opt_snapshot:
 			if (is_remount) {
-				printk(KERN_ERR
-				       "NILFS: \"%s\" option is invalid "
-				       "for remount.\n", p);
+				pr_err("NILFS: \"%s\" option is invalid for remount.\n",
+					p);
 				return 0;
 			}
 			break;
@@ -788,8 +783,7 @@ static int parse_options(char *options, struct super_block *sb, int is_remount)
 			nilfs_clear_opt(nilfs, DISCARD);
 			break;
 		default:
-			printk(KERN_ERR
-			       "NILFS: Unrecognized mount option \"%s\"\n", p);
+			pr_err("NILFS: Unrecognized mount option \"%s\"\n", p);
 			return 0;
 		}
 	}
@@ -825,12 +819,10 @@ static int nilfs_setup_super(struct super_block *sb, int is_mount)
 	mnt_count = le16_to_cpu(sbp[0]->s_mnt_count);
 
 	if (nilfs->ns_mount_state & NILFS_ERROR_FS) {
-		printk(KERN_WARNING
-		       "NILFS warning: mounting fs with errors\n");
+		pr_warn("NILFS warning: mounting fs with errors\n");
 #if 0
 	} else if (max_mnt_count >= 0 && mnt_count >= max_mnt_count) {
-		printk(KERN_WARNING
-		       "NILFS warning: maximal mount count reached\n");
+		pr_warn("NILFS warning: maximal mount count reached\n");
 #endif
 	}
 	if (!max_mnt_count)
@@ -893,16 +885,14 @@ int nilfs_check_feature_compatibility(struct super_block *sb,
 	features = le64_to_cpu(sbp->s_feature_incompat) &
 		~NILFS_FEATURE_INCOMPAT_SUPP;
 	if (features) {
-		printk(KERN_ERR "NILFS: couldn't mount because of unsupported "
-		       "optional features (%llx)\n",
+		pr_err("NILFS: couldn't mount because of unsupported optional features (%llx)\n",
 		       (unsigned long long)features);
 		return -EINVAL;
 	}
 	features = le64_to_cpu(sbp->s_feature_compat_ro) &
 		~NILFS_FEATURE_COMPAT_RO_SUPP;
 	if (!(sb->s_flags & MS_RDONLY) && features) {
-		printk(KERN_ERR "NILFS: couldn't mount RDWR because of "
-		       "unsupported optional features (%llx)\n",
+		pr_err("NILFS: couldn't mount RDWR because of unsupported optional features (%llx)\n",
 		       (unsigned long long)features);
 		return -EINVAL;
 	}
@@ -919,13 +909,13 @@ static int nilfs_get_root_dentry(struct super_block *sb,
 
 	inode = nilfs_iget(sb, root, NILFS_ROOT_INO);
 	if (IS_ERR(inode)) {
-		printk(KERN_ERR "NILFS: get root inode failed\n");
+		pr_err("NILFS: get root inode failed\n");
 		ret = PTR_ERR(inode);
 		goto out;
 	}
 	if (!S_ISDIR(inode->i_mode) || !inode->i_blocks || !inode->i_size) {
 		iput(inode);
-		printk(KERN_ERR "NILFS: corrupt root inode.\n");
+		pr_err("NILFS: corrupt root inode.\n");
 		ret = -EINVAL;
 		goto out;
 	}
@@ -953,7 +943,7 @@ static int nilfs_get_root_dentry(struct super_block *sb,
 	return ret;
 
  failed_dentry:
-	printk(KERN_ERR "NILFS: get root dentry failed\n");
+	pr_err("NILFS: get root dentry failed\n");
 	goto out;
 }
 
@@ -973,8 +963,7 @@ static int nilfs_attach_snapshot(struct super_block *s, __u64 cno,
 		ret = (ret == -ENOENT) ? -EINVAL : ret;
 		goto out;
 	} else if (!ret) {
-		printk(KERN_ERR "NILFS: The specified checkpoint is "
-		       "not a snapshot (checkpoint number=%llu).\n",
+		pr_err("NILFS: The specified checkpoint is not a snapshot (checkpoint number=%llu).\n",
 		       (unsigned long long)cno);
 		ret = -EINVAL;
 		goto out;
@@ -982,9 +971,8 @@ static int nilfs_attach_snapshot(struct super_block *s, __u64 cno,
 
 	ret = nilfs_attach_checkpoint(s, cno, false, &root);
 	if (ret) {
-		printk(KERN_ERR "NILFS: error loading snapshot "
-		       "(checkpoint number=%llu).\n",
-	       (unsigned long long)cno);
+		pr_err("NILFS: error loading snapshot (checkpoint number=%llu).\n",
+			(unsigned long long)cno);
 		goto out;
 	}
 	ret = nilfs_get_root_dentry(s, root, root_dentry);
@@ -1081,7 +1069,7 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent)
 	cno = nilfs_last_cno(nilfs);
 	err = nilfs_attach_checkpoint(sb, cno, true, &fsroot);
 	if (err) {
-		printk(KERN_ERR "NILFS: error loading last checkpoint "
+		pr_err("NILFS: error loading last checkpoint "
 		       "(checkpoint number=%llu).\n", (unsigned long long)cno);
 		goto failed_unload;
 	}
@@ -1141,9 +1129,8 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 	err = -EINVAL;
 
 	if (!nilfs_valid_fs(nilfs)) {
-		printk(KERN_WARNING "NILFS (device %s): couldn't "
-		       "remount because the filesystem is in an "
-		       "incomplete recovery state.\n", sb->s_id);
+		pr_warn("NILFS (device %s): couldn't remount because the filesystem is in an incomplete recovery state.\n",
+			sb->s_id);
 		goto restore_opts;
 	}
 
@@ -1175,10 +1162,8 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 			~NILFS_FEATURE_COMPAT_RO_SUPP;
 		up_read(&nilfs->ns_sem);
 		if (features) {
-			printk(KERN_WARNING "NILFS (device %s): couldn't "
-			       "remount RDWR because of unsupported optional "
-			       "features (%llx)\n",
-			       sb->s_id, (unsigned long long)features);
+			pr_warn("NILFS (device %s): couldn't remount RDWR because of unsupported optional features (%llx)\n",
+				sb->s_id, (unsigned long long)features);
 			err = -EROFS;
 			goto restore_opts;
 		}
@@ -1241,8 +1226,7 @@ static int nilfs_identify(char *data, struct nilfs_super_data *sd)
 				}
 			}
 			if (ret)
-				printk(KERN_ERR
-				       "NILFS: invalid mount option: %s\n", p);
+				pr_err("NILFS: invalid mount option: %s\n", p);
 		}
 		if (!options)
 			break;
@@ -1325,8 +1309,7 @@ nilfs_mount(struct file_system_type *fs_type, int flags,
 	} else if (!sd.cno) {
 		if (nilfs_tree_is_busy(s->s_root)) {
 			if ((flags ^ s->s_flags) & MS_RDONLY) {
-				printk(KERN_ERR "NILFS: the device already "
-				       "has a %s mount.\n",
+				pr_err("NILFS: the device already has a %s mount.\n",
 				       (s->s_flags & MS_RDONLY) ?
 				       "read-only" : "read/write");
 				err = -EBUSY;
@@ -1455,7 +1438,7 @@ static int __init init_nilfs_fs(void)
 	if (err)
 		goto free_cachep;
 
-	printk(KERN_INFO "NILFS version 2 loaded\n");
+	pr_info("NILFS version 2 loaded\n");
 	return 0;
 
 free_cachep:
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 94c451c..c858de2 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -193,7 +193,8 @@ static int nilfs_store_log_cursor(struct the_nilfs *nilfs,
 		nilfs_get_segnum_of_block(nilfs, nilfs->ns_last_pseg);
 	nilfs->ns_cno = nilfs->ns_last_cno + 1;
 	if (nilfs->ns_segnum >= nilfs->ns_nsegments) {
-		printk(KERN_ERR "NILFS invalid last segment number.\n");
+		pr_err("NILFS invalid last segment number %llu.\n",
+			nilfs->ns_segnum);
 		ret = -EINVAL;
 	}
 	return ret;
@@ -217,12 +218,10 @@ int load_nilfs(struct the_nilfs *nilfs, struct super_block *sb)
 	int err;
 
 	if (!valid_fs) {
-		printk(KERN_WARNING "NILFS warning: mounting unchecked fs\n");
+		pr_warn("NILFS warning: mounting unchecked fs\n");
 		if (s_flags & MS_RDONLY) {
-			printk(KERN_INFO "NILFS: INFO: recovery "
-			       "required for readonly filesystem.\n");
-			printk(KERN_INFO "NILFS: write access will "
-			       "be enabled during recovery.\n");
+			pr_info("NILFS: INFO: recovery required for readonly filesystem.\n");
+			pr_info("NILFS: write access will be enabled during recovery.\n");
 		}
 	}
 
@@ -237,13 +236,10 @@ int load_nilfs(struct the_nilfs *nilfs, struct super_block *sb)
 			goto scan_error;
 
 		if (!nilfs_valid_sb(sbp[1])) {
-			printk(KERN_WARNING
-			       "NILFS warning: unable to fall back to spare"
-			       "super block\n");
+			pr_warn("NILFS warning: unable to fall back to spare super block\n");
 			goto scan_error;
 		}
-		printk(KERN_INFO
-		       "NILFS: try rollback from an earlier position\n");
+		pr_info("NILFS: try rollback from an earlier position\n");
 
 		/*
 		 * restore super block with its spare and reconfigure
@@ -256,10 +252,8 @@ int load_nilfs(struct the_nilfs *nilfs, struct super_block *sb)
 		/* verify consistency between two super blocks */
 		blocksize = BLOCK_SIZE << le32_to_cpu(sbp[0]->s_log_block_size);
 		if (blocksize != nilfs->ns_blocksize) {
-			printk(KERN_WARNING
-			       "NILFS warning: blocksize differs between "
-			       "two super blocks (%d != %d)\n",
-			       blocksize, nilfs->ns_blocksize);
+			pr_warn("NILFS warning: blocksize differs between two super blocks (%d != %d)\n",
+				blocksize, nilfs->ns_blocksize);
 			goto scan_error;
 		}
 
@@ -278,7 +272,7 @@ int load_nilfs(struct the_nilfs *nilfs, struct super_block *sb)
 
 	err = nilfs_load_super_root(nilfs, sb, ri.ri_super_root);
 	if (unlikely(err)) {
-		printk(KERN_ERR "NILFS: error loading super root.\n");
+		pr_err("NILFS: error loading super root.\n");
 		goto failed;
 	}
 
@@ -289,30 +283,25 @@ int load_nilfs(struct the_nilfs *nilfs, struct super_block *sb)
 		__u64 features;
 
 		if (nilfs_test_opt(nilfs, NORECOVERY)) {
-			printk(KERN_INFO "NILFS: norecovery option specified. "
-			       "skipping roll-forward recovery\n");
+			pr_info("NILFS: norecovery option specified. skipping roll-forward recovery\n");
 			goto skip_recovery;
 		}
 		features = le64_to_cpu(nilfs->ns_sbp[0]->s_feature_compat_ro) &
 			~NILFS_FEATURE_COMPAT_RO_SUPP;
 		if (features) {
-			printk(KERN_ERR "NILFS: couldn't proceed with "
-			       "recovery because of unsupported optional "
-			       "features (%llx)\n",
+			pr_err("NILFS: couldn't proceed with recovery because of unsupported optional features (%llx)\n",
 			       (unsigned long long)features);
 			err = -EROFS;
 			goto failed_unload;
 		}
 		if (really_read_only) {
-			printk(KERN_ERR "NILFS: write access "
-			       "unavailable, cannot proceed.\n");
+			pr_err("NILFS: write access unavailable, cannot proceed.\n");
 			err = -EROFS;
 			goto failed_unload;
 		}
 		sb->s_flags &= ~MS_RDONLY;
 	} else if (nilfs_test_opt(nilfs, NORECOVERY)) {
-		printk(KERN_ERR "NILFS: recovery cancelled because norecovery "
-		       "option was specified for a read/write mount\n");
+		pr_err("NILFS: recovery cancelled because norecovery option was specified for a read/write mount\n");
 		err = -EINVAL;
 		goto failed_unload;
 	}
@@ -327,11 +316,10 @@ int load_nilfs(struct the_nilfs *nilfs, struct super_block *sb)
 	up_write(&nilfs->ns_sem);
 
 	if (err) {
-		printk(KERN_ERR "NILFS: failed to update super block. "
-		       "recovery unfinished.\n");
+		pr_err("NILFS: failed to update super block. recovery unfinished.\n");
 		goto failed_unload;
 	}
-	printk(KERN_INFO "NILFS: recovery complete.\n");
+	pr_info("NILFS: recovery complete.\n");
 
  skip_recovery:
 	nilfs_clear_recovery_info(&ri);
@@ -339,7 +327,7 @@ int load_nilfs(struct the_nilfs *nilfs, struct super_block *sb)
 	return 0;
 
  scan_error:
-	printk(KERN_ERR "NILFS: error searching super root.\n");
+	pr_err("NILFS: error searching super root.\n");
 	goto failed;
 
  failed_unload:
@@ -386,7 +374,7 @@ static int nilfs_store_disk_layout(struct the_nilfs *nilfs,
 				   struct nilfs_super_block *sbp)
 {
 	if (le32_to_cpu(sbp->s_rev_level) < NILFS_MIN_SUPP_REV) {
-		printk(KERN_ERR "NILFS: unsupported revision "
+		pr_err("NILFS: unsupported revision "
 		       "(superblock rev.=%d.%d, current rev.=%d.%d). "
 		       "Please check the version of mkfs.nilfs.\n",
 		       le32_to_cpu(sbp->s_rev_level),
@@ -403,7 +391,7 @@ static int nilfs_store_disk_layout(struct the_nilfs *nilfs,
 
 	nilfs->ns_blocks_per_segment = le32_to_cpu(sbp->s_blocks_per_segment);
 	if (nilfs->ns_blocks_per_segment < NILFS_SEG_MIN_BLOCKS) {
-		printk(KERN_ERR "NILFS: too short segment.\n");
+		pr_err("NILFS: too short segment.\n");
 		return -EINVAL;
 	}
 
@@ -412,7 +400,7 @@ static int nilfs_store_disk_layout(struct the_nilfs *nilfs,
 		le32_to_cpu(sbp->s_r_segments_percentage);
 	if (nilfs->ns_r_segments_percentage < 1 ||
 	    nilfs->ns_r_segments_percentage > 99) {
-		printk(KERN_ERR "NILFS: invalid reserved segments percentage.\n");
+		pr_err("NILFS: invalid reserved segments percentage.\n");
 		return -EINVAL;
 	}
 
@@ -496,16 +484,14 @@ static int nilfs_load_super_block(struct the_nilfs *nilfs,
 
 	if (!sbp[0]) {
 		if (!sbp[1]) {
-			printk(KERN_ERR "NILFS: unable to read superblock\n");
+			pr_err("NILFS: unable to read superblock\n");
 			return -EIO;
 		}
-		printk(KERN_WARNING
-		       "NILFS warning: unable to read primary superblock "
-		       "(blocksize = %d)\n", blocksize);
+		pr_warn("NILFS warning: unable to read primary superblock (blocksize = %d)\n",
+			blocksize);
 	} else if (!sbp[1]) {
-		printk(KERN_WARNING
-		       "NILFS warning: unable to read secondary superblock "
-		       "(blocksize = %d)\n", blocksize);
+		pr_warn("NILFS warning: unable to read secondary superblock (blocksize = %d)\n",
+			blocksize);
 	}
 
 	/*
@@ -527,14 +513,13 @@ static int nilfs_load_super_block(struct the_nilfs *nilfs,
 	}
 	if (!valid[swp]) {
 		nilfs_release_super_block(nilfs);
-		printk(KERN_ERR "NILFS: Can't find nilfs on dev %s.\n",
-		       sb->s_id);
+		pr_err("NILFS: Can't find nilfs on dev %s.\n", sb->s_id);
 		return -EINVAL;
 	}
 
 	if (!valid[!swp])
-		printk(KERN_WARNING "NILFS warning: broken superblock. "
-		       "using spare superblock (blocksize = %d).\n", blocksize);
+		pr_warn("NILFS warning: broken superblock. using spare superblock (blocksize = %d).\n",
+			blocksize);
 	if (swp)
 		nilfs_swap_super_block(nilfs);
 
@@ -568,7 +553,7 @@ int init_nilfs(struct the_nilfs *nilfs, struct super_block *sb, char *data)
 
 	blocksize = sb_min_blocksize(sb, NILFS_MIN_BLOCK_SIZE);
 	if (!blocksize) {
-		printk(KERN_ERR "NILFS: unable to set blocksize\n");
+		pr_err("NILFS: unable to set blocksize\n");
 		err = -EINVAL;
 		goto out;
 	}
@@ -587,8 +572,8 @@ int init_nilfs(struct the_nilfs *nilfs, struct super_block *sb, char *data)
 	blocksize = BLOCK_SIZE << le32_to_cpu(sbp->s_log_block_size);
 	if (blocksize < NILFS_MIN_BLOCK_SIZE ||
 	    blocksize > NILFS_MAX_BLOCK_SIZE) {
-		printk(KERN_ERR "NILFS: couldn't mount because of unsupported "
-		       "filesystem blocksize %d\n", blocksize);
+		pr_err("NILFS: couldn't mount because of unsupported filesystem blocksize %d\n",
+			blocksize);
 		err = -EINVAL;
 		goto failed_sbh;
 	}
@@ -596,8 +581,7 @@ int init_nilfs(struct the_nilfs *nilfs, struct super_block *sb, char *data)
 		int hw_blocksize = bdev_logical_block_size(sb->s_bdev);
 
 		if (blocksize < hw_blocksize) {
-			printk(KERN_ERR
-			       "NILFS: blocksize %d too small for device "
+			pr_err("NILFS: blocksize %d too small for device "
 			       "(sector-size = %d).\n",
 			       blocksize, hw_blocksize);
 			err = -EINVAL;
-- 
1.7.9.5



