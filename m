From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 10/11] nilfs2: add missing line spacing
Date: Fri, 29 Apr 2016 22:15:46 +0900
Message-ID: <1461935747-10380-11-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1461935747-10380-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=pyLKGkNSxqD2ix07lm65Vy8mkul3G4VL5KFv39oY1RY=;
        b=gNUqc2sRcDhVvddQcnBbR75wSIAyS7gcf6fy3zfiVDPyHFv+LMo4I4x0mREt4DXgD5
         rYz7ozcAANxJNe7aFkhkT+ZVI+OHw8Pf9hyjYD5S+VFLcbs6D8wxCzAfxZKb6XlawT+Z
         CEmdDzvKzVEe4w4qlNwGqgv35KaRO79Vfvd37PjidTGfxe/7vAVgiOUWFfdwZnyScdQs
         Q/SxTIoMKBtvJi+HeR2qWxR1oGBGMkWMQLbobh3sWglWE/tUO+Edx697FiT1s17tNPuR
         QyKt3Q1t+dTE30A5yqvlylphkLyAkiJeo0rxrfRyPFaPj3r2500FPQkXM4/buqi1E1pR
         vYbQ==
In-Reply-To: <1461935747-10380-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Clean up checkpatch.pl warnings "WARNING: Missing a blank line after
declarations" from nilfs2.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/cpfile.c    | 2 ++
 fs/nilfs2/dir.c       | 2 ++
 fs/nilfs2/ifile.h     | 1 +
 fs/nilfs2/inode.c     | 1 +
 fs/nilfs2/namei.c     | 1 +
 fs/nilfs2/recovery.c  | 1 +
 fs/nilfs2/segment.c   | 1 +
 fs/nilfs2/sufile.c    | 2 ++
 fs/nilfs2/super.c     | 1 +
 fs/nilfs2/the_nilfs.h | 2 ++
 10 files changed, 14 insertions(+)

diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index d192b48..16f884b 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -37,6 +37,7 @@ static unsigned long
 nilfs_cpfile_get_blkoff(const struct inode *cpfile, __u64 cno)
 {
 	__u64 tcno = cno + NILFS_MDT(cpfile)->mi_first_entry_offset - 1;
+
 	do_div(tcno, nilfs_cpfile_checkpoints_per_block(cpfile));
 	return (unsigned long)tcno;
 }
@@ -46,6 +47,7 @@ static unsigned long
 nilfs_cpfile_get_offset(const struct inode *cpfile, __u64 cno)
 {
 	__u64 tcno = cno + NILFS_MDT(cpfile)->mi_first_entry_offset - 1;
+
 	return do_div(tcno, nilfs_cpfile_checkpoints_per_block(cpfile));
 }
 
diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index edd3ca9..6ac166e 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -74,6 +74,7 @@ static unsigned nilfs_last_byte(struct inode *inode, unsigned long page_nr)
 static int nilfs_prepare_chunk(struct page *page, unsigned from, unsigned to)
 {
 	loff_t pos = page_offset(page) + from;
+
 	return __block_write_begin(page, pos, to - from, nilfs_get_block);
 }
 
@@ -336,6 +337,7 @@ nilfs_find_entry(struct inode *dir, const struct qstr *qstr,
 	n = start;
 	do {
 		char *kaddr;
+
 		page = nilfs_get_page(dir, n);
 		if (!IS_ERR(page)) {
 			kaddr = page_address(page);
diff --git a/fs/nilfs2/ifile.h b/fs/nilfs2/ifile.h
index 1b7d7af..23ad2f0 100644
--- a/fs/nilfs2/ifile.h
+++ b/fs/nilfs2/ifile.h
@@ -32,6 +32,7 @@ static inline struct nilfs_inode *
 nilfs_ifile_map_inode(struct inode *ifile, ino_t ino, struct buffer_head *ibh)
 {
 	void *kaddr = kmap(ibh->b_page);
+
 	return nilfs_palloc_block_get_entry(ifile, ino, ibh, kaddr);
 }
 
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 191bc218..bdd11c6 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -851,6 +851,7 @@ out_err:
 int nilfs_permission(struct inode *inode, int mask)
 {
 	struct nilfs_root *root = NILFS_I(inode)->i_root;
+
 	if ((mask & MAY_WRITE) && root &&
 	    root->cno != NILFS_CPTREE_CURRENT_CNO)
 		return -EROFS; /* snapshot is not writable */
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 3cf8169..e5bed2d 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -44,6 +44,7 @@
 static inline int nilfs_add_nondir(struct dentry *dentry, struct inode *inode)
 {
 	int err = nilfs_add_link(dentry, inode);
+
 	if (!err) {
 		d_instantiate(dentry, inode);
 		unlock_new_inode(inode);
diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index 402a45c..685fa73 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -522,6 +522,7 @@ static int nilfs_recover_dsync_blocks(struct the_nilfs *nilfs,
 					0, &page, nilfs_get_block);
 		if (unlikely(err)) {
 			loff_t isize = inode->i_size;
+
 			if (pos + blocksize > isize)
 				nilfs_write_failed(inode->i_mapping,
 							pos + blocksize);
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index ddbfb09..69e9ea8 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2391,6 +2391,7 @@ static int nilfs_segctor_construct(struct nilfs_sc_info *sci, int mode)
 static void nilfs_construction_timeout(unsigned long data)
 {
 	struct task_struct *p = (struct task_struct *)data;
+
 	wake_up_process(p);
 }
 
diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index df439da..1963595 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -57,6 +57,7 @@ static unsigned long
 nilfs_sufile_get_blkoff(const struct inode *sufile, __u64 segnum)
 {
 	__u64 t = segnum + NILFS_MDT(sufile)->mi_first_entry_offset;
+
 	do_div(t, nilfs_sufile_segment_usages_per_block(sufile));
 	return (unsigned long)t;
 }
@@ -65,6 +66,7 @@ static unsigned long
 nilfs_sufile_get_offset(const struct inode *sufile, __u64 segnum)
 {
 	__u64 t = segnum + NILFS_MDT(sufile)->mi_first_entry_offset;
+
 	return do_div(t, nilfs_sufile_segment_usages_per_block(sufile));
 }
 
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 2cb78b8..92acb00 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -743,6 +743,7 @@ static int parse_options(char *options, struct super_block *sb, int is_remount)
 
 	while ((p = strsep(&options, ",")) != NULL) {
 		int token;
+
 		if (!*p)
 			continue;
 
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 6a26293..62bd7b1 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -269,6 +269,7 @@ struct nilfs_root {
 static inline int nilfs_sb_need_update(struct the_nilfs *nilfs)
 {
 	u64 t = get_seconds();
+
 	return t < nilfs->ns_sbwtime ||
 		t > nilfs->ns_sbwtime + nilfs->ns_sb_update_freq;
 }
@@ -276,6 +277,7 @@ static inline int nilfs_sb_need_update(struct the_nilfs *nilfs)
 static inline int nilfs_sb_will_flip(struct the_nilfs *nilfs)
 {
 	int flip_bits = nilfs->ns_sbwcount & 0x0FL;
+
 	return (flip_bits != 0x08 && flip_bits != 0x0F);
 }
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
