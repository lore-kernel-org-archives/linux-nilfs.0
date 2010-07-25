From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/2] nilfs2: avoid rec_len overflow with 64KB block size
Date: Mon, 26 Jul 2010 01:00:07 +0900
Message-ID: <1280073608-17772-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1280073608-17772-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1280073608-17772-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

With 64KB blocksize, a directory entry can have size 64KB which does
not fit into 16 bits we have for entry length.  So this patch stores
0xffff instead and converts value when read from / written to disk.

Nilfs derives its directory implementation from ext2 filesystem, and
this draws upon the corresponding change on ext2.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/dir.c           |   26 ++++++++++++++------------
 include/linux/nilfs2_fs.h |   20 +++++++++++++++++++-
 2 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index d8d183e..b60277b 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -141,7 +141,7 @@ static void nilfs_check_page(struct page *page)
 	}
 	for (offs = 0; offs <= limit - NILFS_DIR_REC_LEN(1); offs += rec_len) {
 		p = (struct nilfs_dir_entry *)(kaddr + offs);
-		rec_len = le16_to_cpu(p->rec_len);
+		rec_len = nilfs_rec_len_from_disk(p->rec_len);
 
 		if (rec_len < NILFS_DIR_REC_LEN(1))
 			goto Eshort;
@@ -235,7 +235,8 @@ nilfs_match(int len, const unsigned char *name, struct nilfs_dir_entry *de)
  */
 static struct nilfs_dir_entry *nilfs_next_entry(struct nilfs_dir_entry *p)
 {
-	return (struct nilfs_dir_entry *)((char *)p + le16_to_cpu(p->rec_len));
+	return (struct nilfs_dir_entry *)((char *)p +
+					  nilfs_rec_len_from_disk(p->rec_len));
 }
 
 static unsigned char
@@ -326,7 +327,7 @@ static int nilfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 					goto success;
 				}
 			}
-			filp->f_pos += le16_to_cpu(de->rec_len);
+			filp->f_pos += nilfs_rec_len_from_disk(de->rec_len);
 		}
 		nilfs_put_page(page);
 	}
@@ -441,7 +442,7 @@ void nilfs_set_link(struct inode *dir, struct nilfs_dir_entry *de,
 		    struct page *page, struct inode *inode)
 {
 	unsigned from = (char *) de - (char *) page_address(page);
-	unsigned to = from + le16_to_cpu(de->rec_len);
+	unsigned to = from + nilfs_rec_len_from_disk(de->rec_len);
 	struct address_space *mapping = page->mapping;
 	int err;
 
@@ -497,7 +498,7 @@ int nilfs_add_link(struct dentry *dentry, struct inode *inode)
 				/* We hit i_size */
 				name_len = 0;
 				rec_len = chunk_size;
-				de->rec_len = cpu_to_le16(chunk_size);
+				de->rec_len = nilfs_rec_len_to_disk(chunk_size);
 				de->inode = 0;
 				goto got_it;
 			}
@@ -511,7 +512,7 @@ int nilfs_add_link(struct dentry *dentry, struct inode *inode)
 			if (nilfs_match(namelen, name, de))
 				goto out_unlock;
 			name_len = NILFS_DIR_REC_LEN(de->name_len);
-			rec_len = le16_to_cpu(de->rec_len);
+			rec_len = nilfs_rec_len_from_disk(de->rec_len);
 			if (!de->inode && rec_len >= reclen)
 				goto got_it;
 			if (rec_len >= name_len + reclen)
@@ -534,8 +535,8 @@ got_it:
 		struct nilfs_dir_entry *de1;
 
 		de1 = (struct nilfs_dir_entry *)((char *)de + name_len);
-		de1->rec_len = cpu_to_le16(rec_len - name_len);
-		de->rec_len = cpu_to_le16(name_len);
+		de1->rec_len = nilfs_rec_len_to_disk(rec_len - name_len);
+		de->rec_len = nilfs_rec_len_to_disk(name_len);
 		de = de1;
 	}
 	de->name_len = namelen;
@@ -566,7 +567,8 @@ int nilfs_delete_entry(struct nilfs_dir_entry *dir, struct page *page)
 	struct inode *inode = mapping->host;
 	char *kaddr = page_address(page);
 	unsigned from = ((char *)dir - kaddr) & ~(nilfs_chunk_size(inode) - 1);
-	unsigned to = ((char *)dir - kaddr) + le16_to_cpu(dir->rec_len);
+	unsigned to = ((char *)dir - kaddr) +
+		nilfs_rec_len_from_disk(dir->rec_len);
 	struct nilfs_dir_entry *pde = NULL;
 	struct nilfs_dir_entry *de = (struct nilfs_dir_entry *)(kaddr + from);
 	int err;
@@ -587,7 +589,7 @@ int nilfs_delete_entry(struct nilfs_dir_entry *dir, struct page *page)
 	err = nilfs_prepare_chunk(page, mapping, from, to);
 	BUG_ON(err);
 	if (pde)
-		pde->rec_len = cpu_to_le16(to - from);
+		pde->rec_len = nilfs_rec_len_to_disk(to - from);
 	dir->inode = 0;
 	nilfs_commit_chunk(page, mapping, from, to);
 	inode->i_ctime = inode->i_mtime = CURRENT_TIME;
@@ -621,14 +623,14 @@ int nilfs_make_empty(struct inode *inode, struct inode *parent)
 	memset(kaddr, 0, chunk_size);
 	de = (struct nilfs_dir_entry *)kaddr;
 	de->name_len = 1;
-	de->rec_len = cpu_to_le16(NILFS_DIR_REC_LEN(1));
+	de->rec_len = nilfs_rec_len_to_disk(NILFS_DIR_REC_LEN(1));
 	memcpy(de->name, ".\0\0", 4);
 	de->inode = cpu_to_le64(inode->i_ino);
 	nilfs_set_de_type(de, inode);
 
 	de = (struct nilfs_dir_entry *)(kaddr + NILFS_DIR_REC_LEN(1));
 	de->name_len = 2;
-	de->rec_len = cpu_to_le16(chunk_size - NILFS_DIR_REC_LEN(1));
+	de->rec_len = nilfs_rec_len_to_disk(chunk_size - NILFS_DIR_REC_LEN(1));
 	de->inode = cpu_to_le64(parent->i_ino);
 	memcpy(de->name, "..\0", 4);
 	nilfs_set_de_type(de, inode);
diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index 7dd4cd4..970828a 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -326,7 +326,25 @@ enum {
 #define NILFS_DIR_ROUND			(NILFS_DIR_PAD - 1)
 #define NILFS_DIR_REC_LEN(name_len)	(((name_len) + 12 + NILFS_DIR_ROUND) & \
 					~NILFS_DIR_ROUND)
+#define NILFS_MAX_REC_LEN		((1<<16)-1)
 
+static inline unsigned nilfs_rec_len_from_disk(__le16 dlen)
+{
+	unsigned len = le16_to_cpu(dlen);
+
+	if (len == NILFS_MAX_REC_LEN)
+		return 1 << 16;
+	return len;
+}
+
+static inline __le16 nilfs_rec_len_to_disk(unsigned len)
+{
+	if (len == (1 << 16))
+		return cpu_to_le16(NILFS_MAX_REC_LEN);
+	else if (len > (1 << 16))
+		BUG();
+	return cpu_to_le16(len);
+}
 
 /**
  * struct nilfs_finfo - file information
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
