From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH] nilfs2: fix issue with flush kernel thread after remount in
 RO mode because of driver's internal error or metadata corruption
Date: Tue, 16 Apr 2013 12:04:05 +0400
Message-ID: <1366099445.2091.8.camel@slavad-ubuntu>
Reply-To: slava@dubeyko.com
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=uhd7oY5GYhysi4Xrenxnbjz0nBRQsNTIjsGpvWYBxKU=;
	b=ig3wFKFVLlHfN034FtUxQGWE3+JJhaShgCGI0fFFM6WZbJafvw976oIkQCMO8P4GsQkUUt7xEY6mlcJwXlG0BXFLjb20x7YvyboRb5VwObB3ZOV+HcijTxqTHKxkYX0f;
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs@vger.kernel.org
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Anthony Doggett <Anthony2486@interfaces.org.uk>, ARAI Shun-ichi <hermes@ceres.dti.ne.jp>, Piotr Szymaniak <szarpaj@grubelek.pl>, Zahid Chowdhury <zahid.chowdhury@starsolutions.com>, Elmer Zhang <freeboy6716@gmail.com>

From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH] nilfs2: fix issue with flush kernel thread after remount in RO mode because of driver's internal error or metadata corruption

DESCRIPTION:
NILFS2 driver remounts itself in RO mode in the case of metadata corruption discovering (for example, in the case of broken bmap discovering). But, usually, it takes place file system operations before remounting in RO mode. Thereby, NILFS2 driver can be in RO mode with presence of dirty pages in modified inodes' address spaces. It results in flush kernel thread's infinite trying to flush dirty pages in RO mode. As a result, it is possible to see such side effects as: (1) flush kernel thread occupies 50% - 99% of CPU time; (2) system can't be shutdowned without manual power switch off.

SYMPTOMS:
(1) System log contains error message: "Remounting filesystem read-only".
(2) The flush kernel thread occupies 50% - 99% of CPU time.
(3) The system can't be shutdowned without manual power switch off.

REPRODUCTION PATH:
(1) Create volume group with name "unencrypted" by means of vgcreate utility.
(2) Run script (prepared by Anthony Doggett <Anthony2486@interfaces.org.uk>):

----------------[BEGIN SCRIPT]--------------------
#!/bin/bash

VG=unencrypted
#apt-get install nilfs-tools darcs
lvcreate --size 2G --name ntest $VG
mkfs.nilfs2 -b 1024 -B 8192 /dev/mapper/$VG-ntest
mkdir /var/tmp/n
mkdir /var/tmp/n/ntest
mount /dev/mapper/$VG-ntest /var/tmp/n/ntest
mkdir /var/tmp/n/ntest/thedir
cd /var/tmp/n/ntest/thedir
sleep 2
date
darcs init
sleep 2
dmesg|tail -n 5
date
darcs whatsnew || true
date
sleep 2
dmesg|tail -n 5
----------------[END SCRIPT]--------------------

(3) Try to shutdown the system.

REPRODUCIBILITY: 100%

FIX:
The patch implements checking mount state of NILFS2 driver in nilfs_writepage(), nilfs_writepages() and nilfs_mdt_write_page() methods. If it is detected the RO mount state then all dirty pages are simply discarded with warning messages is written in system log.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
CC: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Tested-by: Vyacheslav Dubeyko <slava@dubeyko.com>
---
 fs/nilfs2/inode.c |   17 +++++++++++++
 fs/nilfs2/mdt.c   |   19 +++++++++++----
 fs/nilfs2/page.c  |   69 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/nilfs2/page.h  |    3 ++-
 4 files changed, 102 insertions(+), 6 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 6b49f14..7f4db1d 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -175,6 +175,11 @@ static int nilfs_writepages(struct address_space *mapping,
 	struct inode *inode = mapping->host;
 	int err = 0;
 
+	if (inode->i_sb->s_flags & MS_RDONLY) {
+		nilfs_clear_dirty_pages(mapping, false);
+		return -EROFS;
+	}
+
 	if (wbc->sync_mode == WB_SYNC_ALL)
 		err = nilfs_construct_dsync_segment(inode->i_sb, inode,
 						    wbc->range_start,
@@ -187,6 +192,18 @@ static int nilfs_writepage(struct page *page, struct writeback_control *wbc)
 	struct inode *inode = page->mapping->host;
 	int err;
 
+	if (inode && (inode->i_sb->s_flags & MS_RDONLY)) {
+		/*
+		 * It means that filesystem was remounted in read-only
+		 * mode because of error or metadata corruption. But we
+		 * have dirty pages that try to be flushed in background.
+		 * So, here we simply discard this dirty page.
+		 */
+		err = nilfs_discard_page_in_ro_mode(page);
+		if (err == -EROFS) /* page is unlocked */
+			return err;
+	}
+
 	redirty_page_for_writepage(wbc, page);
 	unlock_page(page);
 
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index f9897d0..a386fb0 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -375,14 +375,25 @@ int nilfs_mdt_fetch_dirty(struct inode *inode)
 static int
 nilfs_mdt_write_page(struct page *page, struct writeback_control *wbc)
 {
-	struct inode *inode;
+	struct inode *inode = page->mapping->host;
 	struct super_block *sb;
 	int err = 0;
 
+	if (inode && (inode->i_sb->s_flags & MS_RDONLY)) {
+		/*
+		 * It means that filesystem was remounted in read-only
+		 * mode because of error or metadata corruption. But we
+		 * have dirty pages that try to be flushed in background.
+		 * So, here we simply discard this dirty page.
+		 */
+		err = nilfs_discard_page_in_ro_mode(page);
+		if (err == -EROFS) /* page is unlocked */
+			return err;
+	}
+
 	redirty_page_for_writepage(wbc, page);
 	unlock_page(page);
 
-	inode = page->mapping->host;
 	if (!inode)
 		return 0;
 
@@ -561,10 +572,10 @@ void nilfs_mdt_restore_from_shadow_map(struct inode *inode)
 	if (mi->mi_palloc_cache)
 		nilfs_palloc_clear_cache(inode);
 
-	nilfs_clear_dirty_pages(inode->i_mapping);
+	nilfs_clear_dirty_pages(inode->i_mapping, true);
 	nilfs_copy_back_pages(inode->i_mapping, &shadow->frozen_data);
 
-	nilfs_clear_dirty_pages(&ii->i_btnode_cache);
+	nilfs_clear_dirty_pages(&ii->i_btnode_cache, true);
 	nilfs_copy_back_pages(&ii->i_btnode_cache, &shadow->frozen_btnodes);
 
 	nilfs_bmap_restore(ii->i_bmap, &shadow->bmap_store);
diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 07f76db..9aa6793 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -108,6 +108,61 @@ void nilfs_forget_buffer(struct buffer_head *bh)
 }
 
 /**
+ * nilfs_discard_page_in_ro_mode - discard page dirty state in RO mode
+ * @page: discarded dirty page
+ */
+int nilfs_discard_page_in_ro_mode(struct page *page)
+{
+	struct inode *inode = page->mapping->host;
+	struct super_block *sb;
+
+	if (!inode)
+		return -EINVAL;
+
+	BUG_ON(!test_bit(PG_locked, &page->flags));
+
+	sb = inode->i_sb;
+
+	if (inode->i_sb->s_flags & MS_RDONLY) {
+		/*
+		 * It means that filesystem was remounted in read-only
+		 * mode because of error or metadata corruption. But we
+		 * have dirty pages that try to be flushed in background.
+		 * So, here we simply discard this dirty page.
+		 */
+		nilfs_warning(inode->i_sb, __func__,
+			"discard dirty page: offset %lld, ino %lu\n",
+			page_offset(page), inode->i_ino);
+
+		ClearPageUptodate(page);
+		ClearPageMappedToDisk(page);
+		if (page_has_buffers(page)) {
+			struct buffer_head *bh, *head;
+
+			bh = head = page_buffers(page);
+			do {
+				lock_buffer(bh);
+				nilfs_warning(inode->i_sb, __func__,
+				      "discard dirty block %llu, size %lu\n",
+				      (u64)bh->b_blocknr, bh->b_size);
+				clear_buffer_dirty(bh);
+				clear_buffer_nilfs_volatile(bh);
+				clear_buffer_nilfs_checked(bh);
+				clear_buffer_nilfs_redirected(bh);
+				clear_buffer_uptodate(bh);
+				clear_buffer_mapped(bh);
+				unlock_buffer(bh);
+			} while (bh = bh->b_this_page, bh != head);
+		}
+		__nilfs_clear_page_dirty(page);
+		unlock_page(page);
+	} else
+		return 0;
+
+	return -EROFS;
+}
+
+/**
  * nilfs_copy_buffer -- copy buffer data and flags
  * @dbh: destination buffer
  * @sbh: source buffer
@@ -370,7 +425,7 @@ repeat:
 	goto repeat;
 }
 
-void nilfs_clear_dirty_pages(struct address_space *mapping)
+void nilfs_clear_dirty_pages(struct address_space *mapping, bool silent)
 {
 	struct pagevec pvec;
 	unsigned int i;
@@ -384,12 +439,24 @@ void nilfs_clear_dirty_pages(struct address_space *mapping)
 			struct page *page = pvec.pages[i];
 			struct buffer_head *bh, *head;
 
+			if (!silent) {
+				nilfs_warning(mapping->host->i_sb, __func__,
+				    "discard page: offset %lld, ino %lu\n",
+				    page_offset(page), mapping->host->i_ino);
+			}
+
 			lock_page(page);
 			ClearPageUptodate(page);
 			ClearPageMappedToDisk(page);
 			bh = head = page_buffers(page);
 			do {
 				lock_buffer(bh);
+				if (!silent) {
+					nilfs_warning(mapping->host->i_sb,
+					    __func__,
+					    "discard block %llu, size %lu\n",
+					    (u64)bh->b_blocknr, bh->b_size);
+				}
 				clear_buffer_dirty(bh);
 				clear_buffer_nilfs_volatile(bh);
 				clear_buffer_nilfs_checked(bh);
diff --git a/fs/nilfs2/page.h b/fs/nilfs2/page.h
index fb7de71..3dcc5c8 100644
--- a/fs/nilfs2/page.h
+++ b/fs/nilfs2/page.h
@@ -49,13 +49,14 @@ int __nilfs_clear_page_dirty(struct page *);
 struct buffer_head *nilfs_grab_buffer(struct inode *, struct address_space *,
 				      unsigned long, unsigned long);
 void nilfs_forget_buffer(struct buffer_head *);
+int nilfs_discard_page_in_ro_mode(struct page *page);
 void nilfs_copy_buffer(struct buffer_head *, struct buffer_head *);
 int nilfs_page_buffers_clean(struct page *);
 void nilfs_page_bug(struct page *);
 
 int nilfs_copy_dirty_pages(struct address_space *, struct address_space *);
 void nilfs_copy_back_pages(struct address_space *, struct address_space *);
-void nilfs_clear_dirty_pages(struct address_space *);
+void nilfs_clear_dirty_pages(struct address_space *, bool);
 void nilfs_mapping_init(struct address_space *mapping, struct inode *inode,
 			struct backing_dev_info *bdi);
 unsigned nilfs_page_count_clean_buffers(struct page *, unsigned, unsigned);
-- 
1.7.9.5



