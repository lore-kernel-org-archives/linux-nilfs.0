From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 7/9] nilfs2: add routine to find directory entry from inode number
Date: Mon, 16 May 2011 18:05:20 +0900
Message-ID: <1305536722-1311-8-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1305536722-1311-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1305536722-1311-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This adds a directory lookup function nilfs_find_entry_by_ino(), which
finds a directory entry by an inode number instead of a file name.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/dir.c   |   60 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/nilfs.h |    2 +
 2 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index 3a19239..bc0512b 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -395,6 +395,66 @@ found:
 	return de;
 }
 
+struct nilfs_dir_entry *
+nilfs_find_entry_by_ino(struct inode *dir, ino_t ino, struct page **res_page)
+{
+	unsigned reclen = NILFS_DIR_REC_LEN(1);
+	unsigned long start, n;
+	unsigned long npages = dir_pages(dir);
+	struct page *page = NULL;
+	struct nilfs_inode_info *ii = NILFS_I(dir);
+	struct nilfs_dir_entry *de;
+	void *kaddr;
+
+	if (npages == 0)
+		goto out;
+
+	/* OFFSET_CACHE */
+	*res_page = NULL;
+
+	start = ii->i_dir_start_lookup;
+	if (start >= npages)
+		start = 0;
+	n = start;
+	do {
+		page = nilfs_get_page(dir, n);
+		if (!IS_ERR(page)) {
+			kaddr = page_address(page);
+			de = kaddr;
+			kaddr += nilfs_last_byte(dir, n) - reclen;
+			while ((void *)de <= kaddr) {
+				if (de->rec_len == 0) {
+					nilfs_error(dir->i_sb, __func__,
+						"zero-length directory entry");
+					nilfs_put_page(page);
+					goto out;
+				}
+				if (le64_to_cpu(de->inode) == ino)
+					goto found;
+				de = nilfs_next_entry(de);
+			}
+			nilfs_put_page(page);
+		}
+		if (++n >= npages)
+			n = 0;
+		/* next page is past the blocks we've got */
+		if (unlikely(n > (dir->i_blocks >> (PAGE_CACHE_SHIFT - 9)))) {
+			nilfs_error(dir->i_sb, __func__,
+			       "dir %lu size %lld exceeds block count %llu",
+			       dir->i_ino, dir->i_size,
+			       (unsigned long long)dir->i_blocks);
+			goto out;
+		}
+	} while (n != start);
+out:
+	return NULL;
+
+found:
+	*res_page = page;
+	ii->i_dir_start_lookup = n;
+	return de;
+}
+
 struct nilfs_dir_entry *nilfs_dotdot(struct inode *dir, struct page **p)
 {
 	struct page *page = nilfs_get_page(dir, 0);
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 40bada2..1e47669 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -229,6 +229,8 @@ extern ino_t nilfs_inode_by_name(struct inode *, const struct qstr *);
 extern int nilfs_make_empty(struct inode *, struct inode *);
 extern struct nilfs_dir_entry *
 nilfs_find_entry(struct inode *, const struct qstr *, struct page **);
+struct nilfs_dir_entry *
+nilfs_find_entry_by_ino(struct inode *dir, ino_t ino, struct page **res_page);
 extern int nilfs_delete_entry(struct nilfs_dir_entry *, struct page *);
 extern int nilfs_empty_dir(struct inode *);
 extern struct nilfs_dir_entry *nilfs_dotdot(struct inode *, struct page **);
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
