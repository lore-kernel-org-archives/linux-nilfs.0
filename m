From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH] nilfs2: implement calculation of free inodes count
Date: Fri, 03 May 2013 17:12:26 +0400
Message-ID: <1367586746.5050.4.camel@slavad-ubuntu-12.04>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:From:Subject:Message-ID; bh=WWWSXHJp+qXXCJm3YgbY5HjcXDcxnhOPEoroU8TMr/g=;
	b=WNx7DWwch68TIUyvoOkRhNz4yBpFarPsxVMTLDeGwiwwd/Q9BiXhVNKN+40EeDMw1uAbTRLocy91g3oJhyLuIYDS1IZRQWSEM6+UFJCDIAK8cj5tq8f18oq6VSylReqQ;
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs@vger.kernel.org
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Clemens Eisserer <linuxhippy@gmail.com>

From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH] nilfs2: implement calculation of free inodes count

Currently, NILFS2 returns 0 as free inodes count (f_ffree) and current used inodes count as total file nodes in file system (f_files):

df -i
Filesystem      Inodes  IUsed   IFree IUse% Mounted on
/dev/loop0           2      2       0  100% /mnt/nilfs2

This patch implements real calculation of free inodes count. First of all, it is calculated total file nodes in file system as (desc_blocks_count * groups_per_desc_block * entries_per_group). Then, it is calculated free inodes count as difference the total file nodes and used inodes count. As a result, we have such output for NILFS2:

df -i
Filesystem       Inodes   IUsed    IFree IUse% Mounted on
/dev/loop0      4194304 2114701  2079603   51% /mnt/nilfs2

Reported-by: Clemens Eisserer <linuxhippy@gmail.com>
Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
CC: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Tested-by: Vyacheslav Dubeyko <slava@dubeyko.com>
---
 fs/nilfs2/alloc.c |   36 ++++++++------------------
 fs/nilfs2/alloc.h |   24 ++++++++++++++++++
 fs/nilfs2/ifile.c |   73 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/ifile.h |    4 +++
 fs/nilfs2/mdt.h   |    2 ++
 fs/nilfs2/super.c |    9 +++++--
 6 files changed, 120 insertions(+), 28 deletions(-)

diff --git a/fs/nilfs2/alloc.c b/fs/nilfs2/alloc.c
index eed4d7b..6c61ae9 100644
--- a/fs/nilfs2/alloc.c
+++ b/fs/nilfs2/alloc.c
@@ -30,29 +30,6 @@
 #include "mdt.h"
 #include "alloc.h"
 
-
-/**
- * nilfs_palloc_groups_per_desc_block - get the number of groups that a group
- *					descriptor block can maintain
- * @inode: inode of metadata file using this allocator
- */
-static inline unsigned long
-nilfs_palloc_groups_per_desc_block(const struct inode *inode)
-{
-	return (1UL << inode->i_blkbits) /
-		sizeof(struct nilfs_palloc_group_desc);
-}
-
-/**
- * nilfs_palloc_groups_count - get maximum number of groups
- * @inode: inode of metadata file using this allocator
- */
-static inline unsigned long
-nilfs_palloc_groups_count(const struct inode *inode)
-{
-	return 1UL << (BITS_PER_LONG - (inode->i_blkbits + 3 /* log2(8) */));
-}
-
 /**
  * nilfs_palloc_init_blockgroup - initialize private variables for allocator
  * @inode: inode of metadata file using this allocator
@@ -80,6 +57,13 @@ int nilfs_palloc_init_blockgroup(struct inode *inode, unsigned entry_size)
 		mi->mi_blocks_per_group + 1;
 		/* Number of blocks per descriptor including the
 		   descriptor block */
+	atomic_set(&mi->mi_desc_blocks_count, 1);
+		/*
+		 * The field mi_desc_blocks_count is used for
+		 * storing knowledge about current count of
+		 * desciptor blocks. Initially, it is initialized
+		 * by one.
+		 */
 	return 0;
 }
 
@@ -246,9 +230,9 @@ static int nilfs_palloc_get_block(struct inode *inode, unsigned long blkoff,
  * @create: create flag
  * @bhp: pointer to store the resultant buffer head
  */
-static int nilfs_palloc_get_desc_block(struct inode *inode,
-				       unsigned long group,
-				       int create, struct buffer_head **bhp)
+int nilfs_palloc_get_desc_block(struct inode *inode,
+				unsigned long group,
+				int create, struct buffer_head **bhp)
 {
 	struct nilfs_palloc_cache *cache = NILFS_MDT(inode)->mi_palloc_cache;
 
diff --git a/fs/nilfs2/alloc.h b/fs/nilfs2/alloc.h
index fb72381..073b571 100644
--- a/fs/nilfs2/alloc.h
+++ b/fs/nilfs2/alloc.h
@@ -30,6 +30,28 @@
 #include <linux/fs.h>
 
 /**
+ * nilfs_palloc_groups_count - get maximum number of groups
+ * @inode: inode of metadata file using this allocator
+ */
+static inline unsigned long
+nilfs_palloc_groups_count(const struct inode *inode)
+{
+	return 1UL << (BITS_PER_LONG - (inode->i_blkbits + 3 /* log2(8) */));
+}
+
+/**
+ * nilfs_palloc_groups_per_desc_block - get the number of groups that a group
+ *					descriptor block can maintain
+ * @inode: inode of metadata file using this allocator
+ */
+static inline unsigned long
+nilfs_palloc_groups_per_desc_block(const struct inode *inode)
+{
+	return (1UL << inode->i_blkbits) /
+		sizeof(struct nilfs_palloc_group_desc);
+}
+
+/**
  * nilfs_palloc_entries_per_group - get the number of entries per group
  * @inode: inode of metadata file using this allocator
  *
@@ -45,6 +67,8 @@ nilfs_palloc_entries_per_group(const struct inode *inode)
 int nilfs_palloc_init_blockgroup(struct inode *, unsigned);
 int nilfs_palloc_get_entry_block(struct inode *, __u64, int,
 				 struct buffer_head **);
+int nilfs_palloc_get_desc_block(struct inode *, unsigned long, int,
+				struct buffer_head **);
 void *nilfs_palloc_block_get_entry(const struct inode *, __u64,
 				   const struct buffer_head *, void *);
 
diff --git a/fs/nilfs2/ifile.c b/fs/nilfs2/ifile.c
index d8e65bd..4f25549 100644
--- a/fs/nilfs2/ifile.c
+++ b/fs/nilfs2/ifile.c
@@ -160,6 +160,79 @@ int nilfs_ifile_get_inode_block(struct inode *ifile, ino_t ino,
 }
 
 /**
+ * nilfs_count_free_inodes - calculate free inodes count
+ * @root: root object
+ * @nmaxinodes: current maximum of available inodes count [out]
+ * @nfreeinodes: free inodes count [out]
+ */
+int nilfs_count_free_inodes(struct nilfs_root *root,
+				__statfs_word *nmaxinodes,
+				__statfs_word *nfreeinodes)
+{
+	struct inode *ifile;
+	struct buffer_head *desc_bh;
+	unsigned long groups_per_desc_block, entries_per_group;
+	unsigned long entries_per_desc_block;
+	unsigned long ngroups;
+	unsigned int desc_blocks;
+	__statfs_word nused, nmax;
+	unsigned long i;
+	int err = 0;
+
+	BUG_ON(!root || !nfreeinodes || !nmaxinodes);
+
+	ifile = root->ifile;
+	*nmaxinodes = 0;
+	*nfreeinodes = 0;
+
+	ngroups = nilfs_palloc_groups_count(ifile);
+	groups_per_desc_block = nilfs_palloc_groups_per_desc_block(ifile);
+	entries_per_group = nilfs_palloc_entries_per_group(ifile);
+	nused = atomic_read(&root->inodes_count);
+	entries_per_desc_block = groups_per_desc_block * entries_per_group;
+	desc_blocks =
+		atomic_read(&NILFS_IFILE_I(ifile)->mi.mi_desc_blocks_count);
+	nmax = desc_blocks * entries_per_desc_block;
+
+	if (nused >= nmax) {
+		for (i = groups_per_desc_block * (unsigned long)desc_blocks;
+				i < ngroups;
+					i += groups_per_desc_block) {
+
+			err = nilfs_palloc_get_desc_block(ifile, i, 0,
+								&desc_bh);
+			if (err)
+				break;
+			else
+				desc_blocks++;
+
+			brelse(desc_bh);
+		}
+
+		nmax = entries_per_desc_block * desc_blocks;
+
+		if (nused == nmax) {
+			desc_blocks++;
+			if ((desc_blocks * groups_per_desc_block) < ngroups)
+				nmax += entries_per_desc_block;
+			else
+				desc_blocks--;
+		}
+
+		atomic_set(&NILFS_IFILE_I(ifile)->mi.mi_desc_blocks_count,
+				desc_blocks);
+
+		if (nused > nmax)
+			return err ? err : -ERANGE;
+	}
+
+	*nmaxinodes = nmax;
+	*nfreeinodes = nmax - nused;
+
+	return 0;
+}
+
+/**
  * nilfs_ifile_read - read or get ifile inode
  * @sb: super block instance
  * @root: root object
diff --git a/fs/nilfs2/ifile.h b/fs/nilfs2/ifile.h
index 59b6f2b..57a8564 100644
--- a/fs/nilfs2/ifile.h
+++ b/fs/nilfs2/ifile.h
@@ -27,6 +27,7 @@
 
 #include <linux/fs.h>
 #include <linux/buffer_head.h>
+#include <linux/statfs.h>
 #include <linux/nilfs2_fs.h>
 #include "mdt.h"
 #include "alloc.h"
@@ -49,6 +50,9 @@ int nilfs_ifile_create_inode(struct inode *, ino_t *, struct buffer_head **);
 int nilfs_ifile_delete_inode(struct inode *, ino_t);
 int nilfs_ifile_get_inode_block(struct inode *, ino_t, struct buffer_head **);
 
+int nilfs_count_free_inodes(struct nilfs_root *,
+			    __statfs_word *, __statfs_word *);
+
 int nilfs_ifile_read(struct super_block *sb, struct nilfs_root *root,
 		     size_t inode_size, struct nilfs_inode *raw_inode,
 		     struct inode **inodep);
diff --git a/fs/nilfs2/mdt.h b/fs/nilfs2/mdt.h
index ab172e8..c01b6fb 100644
--- a/fs/nilfs2/mdt.h
+++ b/fs/nilfs2/mdt.h
@@ -53,6 +53,7 @@ struct nilfs_shadow_map {
  * @mi_shadow: shadow of bmap and page caches
  * @mi_blocks_per_group: number of blocks in a group
  * @mi_blocks_per_desc_block: number of blocks per descriptor block
+ * @mi_desc_blocks_count: number of descriptor blocks
  */
 struct nilfs_mdt_info {
 	struct rw_semaphore	mi_sem;
@@ -64,6 +65,7 @@ struct nilfs_mdt_info {
 	struct nilfs_shadow_map *mi_shadow;
 	unsigned long		mi_blocks_per_group;
 	unsigned long		mi_blocks_per_desc_block;
+	atomic_t		mi_desc_blocks_count;
 };
 
 static inline struct nilfs_mdt_info *NILFS_MDT(const struct inode *inode)
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index c7d1f9f..548676b 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -609,6 +609,7 @@ static int nilfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	unsigned long overhead;
 	unsigned long nrsvblocks;
 	sector_t nfreeblocks;
+	__statfs_word nmaxinodes, nfreeinodes;
 	int err;
 
 	/*
@@ -633,14 +634,18 @@ static int nilfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	if (unlikely(err))
 		return err;
 
+	err = nilfs_count_free_inodes(root, &nmaxinodes, &nfreeinodes);
+	if (unlikely(err))
+		return err;
+
 	buf->f_type = NILFS_SUPER_MAGIC;
 	buf->f_bsize = sb->s_blocksize;
 	buf->f_blocks = blocks - overhead;
 	buf->f_bfree = nfreeblocks;
 	buf->f_bavail = (buf->f_bfree >= nrsvblocks) ?
 		(buf->f_bfree - nrsvblocks) : 0;
-	buf->f_files = atomic_read(&root->inodes_count);
-	buf->f_ffree = 0; /* nilfs_count_free_inodes(sb); */
+	buf->f_files = nmaxinodes;
+	buf->f_ffree = nfreeinodes;
 	buf->f_namelen = NILFS_NAME_LEN;
 	buf->f_fsid.val[0] = (u32)id;
 	buf->f_fsid.val[1] = (u32)(id >> 32);
-- 
1.7.9.5



