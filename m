From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: fix data loss in mmap page write for hole blocks
Date: Mon, 28 Mar 2011 00:47:53 +0900
Message-ID: <1301240873-12035-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

From the result of a function test of mmap, mmap write to shared pages
turned out to be broken for hole blocks.  It doesn't write out filled
blocks and the data will be lost after umount.  This is due to a bug
that the target file is not queued for log writer when filling hole
blocks.

Also, nilfs_page_mkwrite function exits normal code path even after
successfully filled hole blocks due to a change of block_page_mkwrite
function; just after nilfs was merged into the mainline,
block_page_mkwrite() started to return VM_FAULT_LOCKED instead of zero
by the patch "mm: close page_mkwrite races" (commit:
b827e496c893de0c).  The current nilfs_page_mkwrite() is not handling
this value properly.

This corrects nilfs_page_mkwrite() and will resolve the data loss
problem in mmap write.

[This should be applied to every kernel since 2.6.30 but a fix is
 needed for 2.6.37 and prior kernels]

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Tested-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: stable <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>  [2.6.38]
---
 fs/nilfs2/file.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index 93589fc..397e732 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -72,10 +72,9 @@ static int nilfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	/*
 	 * check to see if the page is mapped already (no holes)
 	 */
-	if (PageMappedToDisk(page)) {
-		unlock_page(page);
+	if (PageMappedToDisk(page))
 		goto mapped;
-	}
+
 	if (page_has_buffers(page)) {
 		struct buffer_head *bh, *head;
 		int fully_mapped = 1;
@@ -90,7 +89,6 @@ static int nilfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 
 		if (fully_mapped) {
 			SetPageMappedToDisk(page);
-			unlock_page(page);
 			goto mapped;
 		}
 	}
@@ -105,16 +103,17 @@ static int nilfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 		return VM_FAULT_SIGBUS;
 
 	ret = block_page_mkwrite(vma, vmf, nilfs_get_block);
-	if (unlikely(ret)) {
+	if (ret != VM_FAULT_LOCKED) {
 		nilfs_transaction_abort(inode->i_sb);
 		return ret;
 	}
+	nilfs_set_file_dirty(inode, 1 << (PAGE_SHIFT - inode->i_blkbits));
 	nilfs_transaction_commit(inode->i_sb);
 
  mapped:
 	SetPageChecked(page);
 	wait_on_page_writeback(page);
-	return 0;
+	return VM_FAULT_LOCKED;
 }
 
 static const struct vm_operations_struct nilfs_file_vm_ops = {
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
