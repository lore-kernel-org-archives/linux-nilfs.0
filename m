From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2] nilfs2: implement calculation of free inodes count
Date: Mon, 13 May 2013 15:54:51 +0400
Message-ID: <1368446091.2229.9.camel@slavad-ubuntu>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=SAA51mYzNfWSF2WgGAY0zN4c6t8xVhxXobFfoc1kf+g=;
	b=UeAjP++M3ALOOA+RX149z/CK53UD4P77i2TwskDk67H87Seg0dRKk4Ss2JP1k+mTDhuSmmIfFXJE5Fjv/aOi0XPPZuFc4jmKXV0SdS/dz8Yq8FGf72WDohlDCW7dP2NI;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hi Ryusuke,

This is second version of the patch.

v1->v2
 * Change __statfs_word on u64 type.
 * Rename nilfs_count_free_inodes() into nilfs_ifile_count_free_inodes() method.
 * Introduce auxiliary functions: nilfs_palloc_count_max_entries(), nilfs_palloc_count_desc_blocks(), nilfs_palloc_mdt_file_can_grow().
 * Rework processing of returned error from nilfs_ifile_count_free_inodes() in nilfs_statfs().

With the best regards,
Vyacheslav Dubeyko.
---
From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2] nilfs2: implement calculation of free inodes count

Currently, NILFS2 returns 0 as free inodes count (f_ffree) and current used inodes count as total file nodes in file system (f_files):

df -i
Filesystem      Inodes  IUsed   IFree IUse% Mounted on
/dev/loop0           2      2       0  100% /mnt/nilfs2

This patch implements real calculation of free inodes count. First of all, it is calculated total file nodes in file system as (desc_blocks_count * groups_per_desc_block * entries_per_group). Then, it is calculated free inodes count as difference the total file nodes and used inodes count. As a result, we have such output for NILFS2:

df -i
Filesystem       Inodes   IUsed    IFree IUse% Mounted on
/dev/loop0      4194304 2114701  2079603   51% /mnt/nilfs2

Reported-by: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Tested-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
 fs/nilfs2/alloc.c |   85 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/alloc.h |    4 +++
 fs/nilfs2/ifile.c |   52 ++++++++++++++++++++++++++++++++
 fs/nilfs2/ifile.h |    2 ++
 fs/nilfs2/mdt.h   |    2 ++
 fs/nilfs2/super.c |   15 ++++++++--
 6 files changed, 158 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/alloc.c b/fs/nilfs2/alloc.c
index eed4d7b..519600e 100644
--- a/fs/nilfs2/alloc.c
+++ b/fs/nilfs2/alloc.c
@@ -80,6 +80,13 @@ int nilfs_palloc_init_blockgroup(struct inode *inode, unsigned entry_size)
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
 
@@ -398,6 +405,84 @@ nilfs_palloc_rest_groups_in_desc_block(const struct inode *inode,
 }
 
 /**
+ * nilfs_palloc_count_max_entries - count max number of entries that can be
+ *					described by @desc_blocks
+ * @inode: inode of metadata file using this allocator
+ * @desc_blocks: descriptor blocks count
+ */
+u64 nilfs_palloc_count_max_entries(struct inode *inode,
+				    unsigned int desc_blocks)
+{
+	unsigned long ngroups;
+	unsigned long groups_per_desc_block;
+	unsigned long entries_per_group;
+	unsigned long entries_per_desc_block;
+
+	BUG_ON(!inode);
+
+	ngroups = nilfs_palloc_groups_count(inode);
+	groups_per_desc_block = nilfs_palloc_groups_per_desc_block(inode);
+	entries_per_group = nilfs_palloc_entries_per_group(inode);
+	entries_per_desc_block = groups_per_desc_block * entries_per_group;
+
+	return entries_per_desc_block * (u64)desc_blocks;
+}
+
+/**
+ * nilfs_palloc_count_desc_blocks - count descriptor blocks number
+ * @inode: inode of metadata file using this allocator
+ * @start_desc_blks: known current descriptor blocks count
+ */
+unsigned int nilfs_palloc_count_desc_blocks(struct inode *inode,
+					    unsigned int start_desc_blks)
+{
+	unsigned long ngroups;
+	unsigned long groups_per_desc_block;
+	struct buffer_head *desc_bh;
+	unsigned long i;
+	unsigned int desc_blocks = start_desc_blks;
+	int err;
+
+	BUG_ON(!inode);
+
+	ngroups = nilfs_palloc_groups_count(inode);
+	groups_per_desc_block = nilfs_palloc_groups_per_desc_block(inode);
+	i = groups_per_desc_block * (unsigned long)desc_blocks;
+
+	for (; i < ngroups; i += groups_per_desc_block) {
+		err = nilfs_palloc_get_desc_block(inode, i, 0, &desc_bh);
+		if (err)
+			break;
+		else
+			desc_blocks++;
+
+		brelse(desc_bh);
+	}
+
+	return desc_blocks;
+}
+
+/**
+ * nilfs_palloc_mdt_file_can_grow - check potential opportunity for
+ *					MDT file growing
+ * @inode: inode of metadata file using this allocator
+ * @desc_blocks: known current descriptor blocks count
+ */
+bool nilfs_palloc_mdt_file_can_grow(struct inode *inode,
+				    unsigned int desc_blocks)
+{
+	unsigned long ngroups;
+	unsigned long groups_per_desc_block;
+
+	BUG_ON(!inode);
+
+	ngroups = nilfs_palloc_groups_count(inode);
+	groups_per_desc_block = nilfs_palloc_groups_per_desc_block(inode);
+
+	return (groups_per_desc_block * (u64)desc_blocks) < ngroups;
+}
+
+/**
  * nilfs_palloc_prepare_alloc_entry - prepare to allocate a persistent object
  * @inode: inode of metadata file using this allocator
  * @req: nilfs_palloc_req structure exchanged for the allocation
diff --git a/fs/nilfs2/alloc.h b/fs/nilfs2/alloc.h
index fb72381..db1d222 100644
--- a/fs/nilfs2/alloc.h
+++ b/fs/nilfs2/alloc.h
@@ -48,6 +48,10 @@ int nilfs_palloc_get_entry_block(struct inode *, __u64, int,
 void *nilfs_palloc_block_get_entry(const struct inode *, __u64,
 				   const struct buffer_head *, void *);
 
+u64 nilfs_palloc_count_max_entries(struct inode *, unsigned int);
+unsigned int nilfs_palloc_count_desc_blocks(struct inode *, unsigned int);
+bool nilfs_palloc_mdt_file_can_grow(struct inode *, unsigned int);
+
 /**
  * nilfs_palloc_req - persistent allocator request and reply
  * @pr_entry_nr: entry number (vblocknr or inode number)
diff --git a/fs/nilfs2/ifile.c b/fs/nilfs2/ifile.c
index d8e65bd..fe0e02f 100644
--- a/fs/nilfs2/ifile.c
+++ b/fs/nilfs2/ifile.c
@@ -160,6 +160,58 @@ int nilfs_ifile_get_inode_block(struct inode *ifile, ino_t ino,
 }
 
 /**
+ * nilfs_ifile_count_free_inodes - calculate free inodes count
+ * @root: root object
+ * @nmaxinodes: current maximum of available inodes count [out]
+ * @nfreeinodes: free inodes count [out]
+ */
+int nilfs_ifile_count_free_inodes(struct nilfs_root *root,
+					u64 *nmaxinodes,
+					u64 *nfreeinodes)
+{
+	struct inode *ifile;
+	unsigned int desc_blocks;
+	u64 nused, nmax;
+
+	BUG_ON(!root || !nfreeinodes || !nmaxinodes);
+
+	ifile = root->ifile;
+	*nmaxinodes = 0;
+	*nfreeinodes = 0;
+
+	nused = atomic_read(&root->inodes_count);
+	desc_blocks =
+		atomic_read(&NILFS_IFILE_I(ifile)->mi.mi_desc_blocks_count);
+	nmax = nilfs_palloc_count_max_entries(ifile, desc_blocks);
+
+	if (nused >= nmax) {
+		desc_blocks =
+			nilfs_palloc_count_desc_blocks(ifile, desc_blocks);
+		nmax = nilfs_palloc_count_max_entries(ifile, desc_blocks);
+
+		if (nused == nmax) {
+			if (nilfs_palloc_mdt_file_can_grow(ifile,
+							    desc_blocks)) {
+				nmax =
+				    nilfs_palloc_count_max_entries(ifile,
+							    ++desc_blocks);
+			}
+		}
+
+		atomic_set(&NILFS_IFILE_I(ifile)->mi.mi_desc_blocks_count,
+				desc_blocks);
+
+		if (nused > nmax)
+			return -ERANGE;
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
index 59b6f2b..aee5ab01 100644
--- a/fs/nilfs2/ifile.h
+++ b/fs/nilfs2/ifile.h
@@ -49,6 +49,8 @@ int nilfs_ifile_create_inode(struct inode *, ino_t *, struct buffer_head **);
 int nilfs_ifile_delete_inode(struct inode *, ino_t);
 int nilfs_ifile_get_inode_block(struct inode *, ino_t, struct buffer_head **);
 
+int nilfs_ifile_count_free_inodes(struct nilfs_root *, u64 *, u64 *);
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
index c7d1f9f..33f427a 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -609,6 +609,7 @@ static int nilfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	unsigned long overhead;
 	unsigned long nrsvblocks;
 	sector_t nfreeblocks;
+	u64 nmaxinodes, nfreeinodes;
 	int err;
 
 	/*
@@ -633,14 +634,24 @@ static int nilfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	if (unlikely(err))
 		return err;
 
+	err = nilfs_ifile_count_free_inodes(root, &nmaxinodes, &nfreeinodes);
+	if (unlikely(err)) {
+		printk(KERN_WARNING
+			"NILFS warning: fail to count free inodes: err %d.\n",
+			err);
+		err = 0;
+		nmaxinodes = atomic_read(&root->inodes_count);
+		nfreeinodes = 0;
+	}
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



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
