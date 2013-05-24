From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v5 1/2] nilfs2: implement calculation of free inodes count
Date: Fri, 24 May 2013 17:32:35 +0400
Message-ID: <1369402355.2235.22.camel@slavad-ubuntu>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=h0X6hqJOi2Yq9dQTBovl/mSptG4gGgfvyYRijPaDDjk=;
	b=Wx96mezMUb48Ke9DQmI7OfJPw54KkkCNP6R8GaqHxInNeDZvudf6v79e3Qq/s+b4jTv2IeteCD37CqiCtzyWSkPPPVclNxEFRI81YzI0SYf26YyUhE9unly0bcDjoyFu;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v5 1/2] nilfs2: implement calculation of free inodes count

Currently, NILFS2 returns 0 as free inodes count (f_ffree) and
current used inodes count as total file nodes in file system
(f_files):

df -i
Filesystem      Inodes  IUsed   IFree IUse% Mounted on
/dev/loop0           2      2       0  100% /mnt/nilfs2

This patch implements real calculation of free inodes count.
First of all, it is calculated total file nodes in file system
as (desc_blocks_count * groups_per_desc_block * entries_per_group).
Then, it is calculated free inodes count as difference the total
file nodes and used inodes count. As a result, we have such output
for NILFS2:

df -i
Filesystem       Inodes   IUsed    IFree IUse% Mounted on
/dev/loop0      4194304 2114701  2079603   51% /mnt/nilfs2

Reported-by: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Tested-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
 fs/nilfs2/alloc.c |   65 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/alloc.h |    2 ++
 fs/nilfs2/ifile.c |   22 ++++++++++++++++++
 fs/nilfs2/ifile.h |    2 ++
 fs/nilfs2/super.c |   25 +++++++++++++++++++--
 5 files changed, 114 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/alloc.c b/fs/nilfs2/alloc.c
index eed4d7b..472665a 100644
--- a/fs/nilfs2/alloc.c
+++ b/fs/nilfs2/alloc.c
@@ -398,6 +398,71 @@ nilfs_palloc_rest_groups_in_desc_block(const struct inode *inode,
 }
 
 /**
+ * nilfs_palloc_count_desc_blocks - count descriptor blocks number
+ * @inode: inode of metadata file using this allocator
+ * @desc_blocks: descriptor blocks number [out]
+ */
+static int nilfs_palloc_count_desc_blocks(struct inode *inode,
+					  unsigned long *desc_blocks)
+{
+	unsigned long blknum;
+	int ret;
+
+	ret = nilfs_bmap_last_key(NILFS_I(inode)->i_bmap, &blknum);
+	if (likely(!ret))
+		*desc_blocks = DIV_ROUND_UP(
+			blknum, NILFS_MDT(inode)->mi_blocks_per_desc_block);
+	return ret;
+}
+
+/**
+ * nilfs_palloc_mdt_file_can_grow - check potential opportunity for
+ *					MDT file growing
+ * @inode: inode of metadata file using this allocator
+ * @desc_blocks: known current descriptor blocks count
+ */
+static inline bool nilfs_palloc_mdt_file_can_grow(struct inode *inode,
+						    unsigned long desc_blocks)
+{
+	return (nilfs_palloc_groups_per_desc_block(inode) * desc_blocks) <
+			nilfs_palloc_groups_count(inode);
+}
+
+/**
+ * nilfs_palloc_count_max_entries - count max number of entries that can be
+ *					described by descriptor blocks count
+ * @inode: inode of metadata file using this allocator
+ * @nused: current number of used entries
+ * @nmaxp: max number of entries [out]
+ */
+int nilfs_palloc_count_max_entries(struct inode *inode, u64 nused, u64 *nmaxp)
+{
+	unsigned long desc_blocks = 0;
+	u64 entries_per_desc_block, nmax;
+	int err;
+
+	err = nilfs_palloc_count_desc_blocks(inode, &desc_blocks);
+	if (unlikely(err))
+			return err;
+
+	entries_per_desc_block = (u64)nilfs_palloc_entries_per_group(inode) *
+				nilfs_palloc_groups_per_desc_block(inode);
+	nmax = entries_per_desc_block * desc_blocks;
+
+	if (nused == nmax &&
+			nilfs_palloc_mdt_file_can_grow(inode, desc_blocks)) {
+		nmax += entries_per_desc_block;
+		++desc_blocks;
+	}
+
+	if (nused > nmax)
+		return -ERANGE;
+
+	*nmaxp = nmax;
+	return 0;
+}
+
+/**
  * nilfs_palloc_prepare_alloc_entry - prepare to allocate a persistent object
  * @inode: inode of metadata file using this allocator
  * @req: nilfs_palloc_req structure exchanged for the allocation
diff --git a/fs/nilfs2/alloc.h b/fs/nilfs2/alloc.h
index fb72381..4bd6451 100644
--- a/fs/nilfs2/alloc.h
+++ b/fs/nilfs2/alloc.h
@@ -48,6 +48,8 @@ int nilfs_palloc_get_entry_block(struct inode *, __u64, int,
 void *nilfs_palloc_block_get_entry(const struct inode *, __u64,
 				   const struct buffer_head *, void *);
 
+int nilfs_palloc_count_max_entries(struct inode *, u64, u64 *);
+
 /**
  * nilfs_palloc_req - persistent allocator request and reply
  * @pr_entry_nr: entry number (vblocknr or inode number)
diff --git a/fs/nilfs2/ifile.c b/fs/nilfs2/ifile.c
index d8e65bd..d788a59 100644
--- a/fs/nilfs2/ifile.c
+++ b/fs/nilfs2/ifile.c
@@ -160,6 +160,28 @@ int nilfs_ifile_get_inode_block(struct inode *ifile, ino_t ino,
 }
 
 /**
+ * nilfs_ifile_count_free_inodes - calculate free inodes count
+ * @ifile: ifile inode
+ * @nmaxinodes: current maximum of available inodes count [out]
+ * @nfreeinodes: free inodes count [out]
+ */
+int nilfs_ifile_count_free_inodes(struct inode *ifile,
+				    u64 *nmaxinodes, u64 *nfreeinodes)
+{
+	u64 nused;
+	int err;
+
+	*nmaxinodes = 0;
+	*nfreeinodes = 0;
+
+	nused = atomic_read(&NILFS_I(ifile)->i_root->inodes_count);
+	err = nilfs_palloc_count_max_entries(ifile, nused, nmaxinodes);
+	if (likely(!err))
+		*nfreeinodes = *nmaxinodes - nused;
+	return err;
+}
+
+/**
  * nilfs_ifile_read - read or get ifile inode
  * @sb: super block instance
  * @root: root object
diff --git a/fs/nilfs2/ifile.h b/fs/nilfs2/ifile.h
index 59b6f2b..679674d 100644
--- a/fs/nilfs2/ifile.h
+++ b/fs/nilfs2/ifile.h
@@ -49,6 +49,8 @@ int nilfs_ifile_create_inode(struct inode *, ino_t *, struct buffer_head **);
 int nilfs_ifile_delete_inode(struct inode *, ino_t);
 int nilfs_ifile_get_inode_block(struct inode *, ino_t, struct buffer_head **);
 
+int nilfs_ifile_count_free_inodes(struct inode *, u64 *, u64 *);
+
 int nilfs_ifile_read(struct super_block *sb, struct nilfs_root *root,
 		     size_t inode_size, struct nilfs_inode *raw_inode,
 		     struct inode **inodep);
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index c7d1f9f..acd110f 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -609,6 +609,7 @@ static int nilfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	unsigned long overhead;
 	unsigned long nrsvblocks;
 	sector_t nfreeblocks;
+	u64 nmaxinodes, nfreeinodes;
 	int err;
 
 	/*
@@ -633,14 +634,34 @@ static int nilfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	if (unlikely(err))
 		return err;
 
+	err = nilfs_ifile_count_free_inodes(root->ifile,
+						&nmaxinodes, &nfreeinodes);
+	if (unlikely(err)) {
+		printk(KERN_WARNING
+			"NILFS warning: fail to count free inodes: err %d.\n",
+			err);
+		if (err == -ERANGE) {
+			/*
+			 * If nilfs_palloc_count_max_entries() returns
+			 * -ERANGE error code then we simply treat
+			 * curent inodes count as maximum possible and
+			 * zero as free inodes value.
+			 */
+			nmaxinodes = atomic_read(&root->inodes_count);
+			nfreeinodes = 0;
+			err = 0;
+		} else
+			return err;
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
