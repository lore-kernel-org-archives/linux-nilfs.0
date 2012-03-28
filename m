From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH 16/19] nilfs2: Convert to new freezing mechanism
Date: Thu, 29 Mar 2012 01:43:31 +0200
Message-ID: <1332978214-15535-17-git-send-email-jack@suse.cz>
References: <1332978214-15535-1-git-send-email-jack@suse.cz>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1332978214-15535-1-git-send-email-jack-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Kamal Mostafa <kamal-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, KONISHI Ryusuke <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

We change nilfs_page_mkwrite() to provide proper freeze protection for
writeable page faults (we must wait for frozen filesystem even if the
page is fully mapped).

We remove all vfs_check_frozen() checks since they are now handled by
the generic code.

CC: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: KONISHI Ryusuke <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Signed-off-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
---
 fs/nilfs2/file.c    |   18 +++++++++++-------
 fs/nilfs2/ioctl.c   |    2 --
 fs/nilfs2/segment.c |    5 ++++-
 3 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index 2660152..0cdd702 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -65,16 +65,18 @@ static int nilfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	struct page *page = vmf->page;
 	struct inode *inode = vma->vm_file->f_dentry->d_inode;
 	struct nilfs_transaction_info ti;
-	int ret;
+	int ret = 0;
 
 	if (unlikely(nilfs_near_disk_full(inode->i_sb->s_fs_info)))
 		return VM_FAULT_SIGBUS; /* -ENOSPC */
 
+	sb_start_pagefault(inode->i_sb);
 	lock_page(page);
 	if (page->mapping != inode->i_mapping ||
 	    page_offset(page) >= i_size_read(inode) || !PageUptodate(page)) {
 		unlock_page(page);
-		return VM_FAULT_NOPAGE; /* make the VM retry the fault */
+		ret = -EFAULT;	/* make the VM retry the fault */
+		goto out;
 	}
 
 	/*
@@ -108,19 +110,21 @@ static int nilfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	ret = nilfs_transaction_begin(inode->i_sb, &ti, 1);
 	/* never returns -ENOMEM, but may return -ENOSPC */
 	if (unlikely(ret))
-		return VM_FAULT_SIGBUS;
+		goto out;
 
-	ret = block_page_mkwrite(vma, vmf, nilfs_get_block);
-	if (ret != VM_FAULT_LOCKED) {
+	ret = __block_page_mkwrite(vma, vmf, nilfs_get_block);
+	if (ret) {
 		nilfs_transaction_abort(inode->i_sb);
-		return ret;
+		goto out;
 	}
 	nilfs_set_file_dirty(inode, 1 << (PAGE_SHIFT - inode->i_blkbits));
 	nilfs_transaction_commit(inode->i_sb);
 
  mapped:
 	wait_on_page_writeback(page);
-	return VM_FAULT_LOCKED;
+ out:
+	sb_end_pagefault(inode->i_sb);
+	return block_page_mkwrite_return(ret);
 }
 
 static const struct vm_operations_struct nilfs_file_vm_ops = {
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 2a70fce..a2063c7 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -660,8 +660,6 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
 		goto out_free;
 	}
 
-	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
-
 	ret = nilfs_ioctl_move_blocks(inode->i_sb, &argv[0], kbufs[0]);
 	if (ret < 0)
 		printk(KERN_ERR "NILFS: GC failed during preparation: "
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 0e72ad6..627351a 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -189,7 +189,7 @@ int nilfs_transaction_begin(struct super_block *sb,
 	if (ret > 0)
 		return 0;
 
-	vfs_check_frozen(sb, SB_FREEZE_WRITE);
+	sb_start_intwrite(sb);
 
 	nilfs = sb->s_fs_info;
 	down_read(&nilfs->ns_segctor_sem);
@@ -205,6 +205,7 @@ int nilfs_transaction_begin(struct super_block *sb,
 	current->journal_info = ti->ti_save;
 	if (ti->ti_flags & NILFS_TI_DYNAMIC_ALLOC)
 		kmem_cache_free(nilfs_transaction_cachep, ti);
+	sb_end_intwrite(sb);
 	return ret;
 }
 
@@ -246,6 +247,7 @@ int nilfs_transaction_commit(struct super_block *sb)
 		err = nilfs_construct_segment(sb);
 	if (ti->ti_flags & NILFS_TI_DYNAMIC_ALLOC)
 		kmem_cache_free(nilfs_transaction_cachep, ti);
+	sb_end_intwrite(sb);
 	return err;
 }
 
@@ -264,6 +266,7 @@ void nilfs_transaction_abort(struct super_block *sb)
 	current->journal_info = ti->ti_save;
 	if (ti->ti_flags & NILFS_TI_DYNAMIC_ALLOC)
 		kmem_cache_free(nilfs_transaction_cachep, ti);
+	sb_end_intwrite(sb);
 }
 
 void nilfs_relax_pressure_in_lock(struct super_block *sb)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
