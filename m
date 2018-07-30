From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: [PATCH v2] fs/buffer: Convert return type int to vm_fault_t
Date: Mon, 30 Jul 2018 20:31:42 +0530
Message-ID: <20180730150142.GA8414@jordon-HP-15-Notebook-PC>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=Zo2IcPN+YDyX615MW/9rPyYaNzvi5cxf3kzJtY5lUgM=;
        b=Q0v0NtozO+5aZLchbMn8BjDeX4dGlRYKpPJw/HgqKZCYQIEgqUi+tU3YjDv7ALwXh3
         UquM+rDYUjyq18bLA6eAwkwXvR4CqhGyArLi6kpg58wCaA9pBRd8vJtaXOsT2+qgq8rO
         Q3dsWSiOWN9BQ0bn//iupuuYaQQ6cSVzw9lU4TcW2ww5vl1MMicz8T1MiWmG+rqD37YC
         cSC+WgFnooIegXmBC4Cs18H3IJ5iHE4JqCvV8n/Be066+hRvv6EhIjB4emIsojt60IN+
         vWRNHz/mReNxCeMbiLJZpDVwnnI9wC+F0E6IqMHBPrcnBfOMKUMMNInvrH2uDt3JSFHn
         9eVw==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: viro@zeniv.linux.org.uk, konishi.ryusuke@lab.ntt.co.jp, axboe@kernel.dk, darrick.wong@oracle.com, ebiggers@google.com, kstewart@linuxfoundation.org, gregkh@linuxfoundation.org, kemi.wang@intel.com, willy@infradead.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, sabyasachi.linux@gmail.com, brajeswar.linux@gmail.com

Return type of block_page_mkwrite() is converted to
vm_fault_t type. The caller of block_page_mkwrite
inside fs/nilfs2 nilfs_page_mkwrite converted accordingly.

Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
---
v2: Address Jens's comment. Remove ret variable
    from block_page_mkwrite().

 fs/buffer.c                 | 16 ++++++++--------
 fs/nilfs2/file.c            | 13 ++++++++-----
 include/linux/buffer_head.h |  2 +-
 3 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index cabc045..aeed99f 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2444,21 +2444,21 @@ int block_commit_write(struct page *page, unsigned from, unsigned to)
  * Direct callers of this function should protect against filesystem freezing
  * using sb_start_pagefault() - sb_end_pagefault() functions.
  */
-int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
+vm_fault_t block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 			 get_block_t get_block)
 {
 	struct page *page = vmf->page;
 	struct inode *inode = file_inode(vma->vm_file);
 	unsigned long end;
 	loff_t size;
-	int ret;
+	int err;
 
 	lock_page(page);
 	size = i_size_read(inode);
 	if ((page->mapping != inode->i_mapping) ||
 	    (page_offset(page) > size)) {
 		/* We overload EFAULT to mean page got truncated */
-		ret = -EFAULT;
+		err = -EFAULT;
 		goto out_unlock;
 	}
 
@@ -2468,18 +2468,18 @@ int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 	else
 		end = PAGE_SIZE;
 
-	ret = __block_write_begin(page, 0, end, get_block);
-	if (!ret)
-		ret = block_commit_write(page, 0, end);
+	err = __block_write_begin(page, 0, end, get_block);
+	if (!err)
+		err = block_commit_write(page, 0, end);
 
-	if (unlikely(ret < 0))
+	if (unlikely(err < 0))
 		goto out_unlock;
 	set_page_dirty(page);
 	wait_for_stable_page(page);
 	return 0;
 out_unlock:
 	unlock_page(page);
-	return ret;
+	return block_page_mkwrite_return(err);
 }
 EXPORT_SYMBOL(block_page_mkwrite);
 
diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index c5fa3de..da2759e 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -57,7 +57,8 @@ static int nilfs_page_mkwrite(struct vm_fault *vmf)
 	struct page *page = vmf->page;
 	struct inode *inode = file_inode(vma->vm_file);
 	struct nilfs_transaction_info ti;
-	int ret = 0;
+	vm_fault_t ret = VM_FAULT_LOCKED;
+	int err = 0;
 
 	if (unlikely(nilfs_near_disk_full(inode->i_sb->s_fs_info)))
 		return VM_FAULT_SIGBUS; /* -ENOSPC */
@@ -67,7 +68,7 @@ static int nilfs_page_mkwrite(struct vm_fault *vmf)
 	if (page->mapping != inode->i_mapping ||
 	    page_offset(page) >= i_size_read(inode) || !PageUptodate(page)) {
 		unlock_page(page);
-		ret = -EFAULT;	/* make the VM retry the fault */
+		ret = VM_FAULT_NOPAGE;	/* make the VM retry the fault */
 		goto out;
 	}
 
@@ -99,10 +100,12 @@ static int nilfs_page_mkwrite(struct vm_fault *vmf)
 	/*
 	 * fill hole blocks
 	 */
-	ret = nilfs_transaction_begin(inode->i_sb, &ti, 1);
+	err = nilfs_transaction_begin(inode->i_sb, &ti, 1);
 	/* never returns -ENOMEM, but may return -ENOSPC */
-	if (unlikely(ret))
+	if (unlikely(err)) {
+		ret = block_page_mkwrite_return(err);
 		goto out;
+	}
 
 	file_update_time(vma->vm_file);
 	ret = block_page_mkwrite(vma, vmf, nilfs_get_block);
@@ -117,7 +120,7 @@ static int nilfs_page_mkwrite(struct vm_fault *vmf)
 	wait_for_stable_page(page);
  out:
 	sb_end_pagefault(inode->i_sb);
-	return block_page_mkwrite_return(ret);
+	return ret;
 }
 
 static const struct vm_operations_struct nilfs_file_vm_ops = {
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index ed7a81b..7184c6e 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -240,7 +240,7 @@ int cont_write_begin(struct file *, struct address_space *, loff_t,
 			get_block_t *, loff_t *);
 int generic_cont_expand_simple(struct inode *inode, loff_t size);
 int block_commit_write(struct page *page, unsigned from, unsigned to);
-int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
+vm_fault_t block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 				get_block_t get_block);
 /* Convert errno to return value from ->page_mkwrite() call */
 static inline vm_fault_t block_page_mkwrite_return(int err)
-- 
1.9.1

