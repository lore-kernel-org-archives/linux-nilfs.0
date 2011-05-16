From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 8/9] nilfs2: add pathname lookup routine from inode number
Date: Mon, 16 May 2011 18:05:21 +0900
Message-ID: <1305536722-1311-9-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This adds pathname lookup routine nilfs_search_path(), which makes up
a full pathname of a given inode number tracking namespace upward from
the inode to the root directory with the parent inode number added to
each inode.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/namei.c |   92 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/nilfs.h |    5 +++
 2 files changed, 97 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 16bfa37..320e5d3 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -455,6 +455,98 @@ out:
 	return err;
 }
 
+/**
+ * nilfs_search_path - lookup path of inode in a past checkpoint tree
+ * @sb: super block instance
+ * @root: root object
+ * @ino: inode number
+ * @parent_index: parent index number
+ * @buf: buffer in which a pathname to be stored
+ * @bufsz: size of @buf
+ * @namesz: buffer to store size of the acquired pathname
+ */
+ssize_t nilfs_search_path(struct super_block *sb, struct nilfs_root *root,
+			  ino_t ino, int parent_index,
+			  char *buf, size_t bufsz, size_t *namesz)
+{
+	struct inode *inode, *parent;
+	struct nilfs_dir_entry *de;
+	struct page *page;
+	ssize_t ret;
+	size_t namelen;
+	char *cp;
+
+	inode = nilfs_iget(sb, root, ino);
+	if (IS_ERR(inode)) {
+		ret = PTR_ERR(inode);
+		if (ret == -EINVAL)
+			ret = -ENOENT;
+		goto out;
+	}
+
+	cp = buf + bufsz - 1;
+	if (cp - 1 < buf) {
+		/* at least the root directory needs one more character */
+		ret = -ENAMETOOLONG;
+		goto out_iput;
+	}
+	*cp = '\0'; /* end of a pathname */
+	ret = 1;
+
+	if (inode->i_ino == NILFS_ROOT_INO) {
+		*--cp = '/';
+		goto out_iput;
+	}
+
+	do {
+		if (!NILFS_I(inode)->i_parent_ino) {
+			ret = -ENOENT;
+			break;
+		}
+
+		parent = nilfs_iget(sb, root,
+				    NILFS_I(inode)->i_parent_ino);
+		if (IS_ERR(parent)) {
+			ret = PTR_ERR(parent);
+			if (ret == -EINVAL)
+				ret = -ENOENT;
+			break;
+		}
+
+		de = nilfs_find_entry_by_ino(parent, inode->i_ino, &page);
+		if (!de) {
+			iput(parent);
+			ret = -ENOENT;
+			break;
+		}
+
+		namelen = de->name_len;
+		if (cp - (namelen + 1) < buf) {
+			kunmap(page);
+			page_cache_release(page);
+			iput(parent);
+			ret = -ENAMETOOLONG;
+			break;
+		}
+		cp -= namelen;
+		memcpy(cp, de->name, namelen);
+		*--cp = '/';
+		kunmap(page);
+		page_cache_release(page);
+
+		iput(inode);
+		inode = parent;
+
+	} while (inode->i_ino != NILFS_ROOT_INO);
+
+out_iput:
+	iput(inode);
+	if (ret >= 0)
+		*namesz = buf + bufsz - cp;
+out:
+	return ret;
+}
+
 /*
  * Export operations
  */
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 1e47669..e8e97c2 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -237,6 +237,11 @@ extern struct nilfs_dir_entry *nilfs_dotdot(struct inode *, struct page **);
 extern void nilfs_set_link(struct inode *, struct nilfs_dir_entry *,
 			   struct page *, struct inode *);
 
+/* namei.c */
+ssize_t nilfs_search_path(struct super_block *sb, struct nilfs_root *root,
+			  ino_t ino, int parent_index,
+			  char *buf, size_t bufsz, size_t *namesz);
+
 /* file.c */
 extern int nilfs_sync_file(struct file *, int);
 
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
