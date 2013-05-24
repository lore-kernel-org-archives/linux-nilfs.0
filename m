From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v5 2/2] nilfs2: use atomic_long_t type for inodes_count and
 blocks_count fields in nilfs_root struct
Date: Fri, 24 May 2013 17:32:52 +0400
Message-ID: <1369402372.2235.23.camel@slavad-ubuntu>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=kHUfxwE5sS1Hdol+7rXCfaPro0ep/eLH/VGonD8PlqE=;
	b=Bh1PMm1lUQQDHUTpw8owEzm/KbmPIT64kgs1pEp4mMz5X5e7rQEgqf8b1b6pU6mYkvAmxsutYoTnznGab6wr0AOMblXWwPQGjUrqGfVOTpiokrUHntkWWPnNiZylJwGN;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v5 2/2] nilfs2: use atomic_long_t type for inodes_count and
 blocks_count fields in nilfs_root struct

The cp_inodes_count and cp_blocks_count are represented as
__le64 type in on-disk structure (struct nilfs_checkpoint).
But analogous fields in in-core structure (struct nilfs_root)
are represented by atomic_t type.

This patch replaces atomic_t on atomic_long_t type in representation
of inodes_count and blocks_count fields in struct nilfs_root.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/ifile.c     |    2 +-
 fs/nilfs2/inode.c     |    8 ++++----
 fs/nilfs2/segment.c   |    4 ++--
 fs/nilfs2/super.c     |    8 +++++---
 fs/nilfs2/the_nilfs.c |    4 ++--
 fs/nilfs2/the_nilfs.h |    4 ++--
 6 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/fs/nilfs2/ifile.c b/fs/nilfs2/ifile.c
index d788a59..d540a42 100644
--- a/fs/nilfs2/ifile.c
+++ b/fs/nilfs2/ifile.c
@@ -174,7 +174,7 @@ int nilfs_ifile_count_free_inodes(struct inode *ifile,
 	*nmaxinodes = 0;
 	*nfreeinodes = 0;
 
-	nused = atomic_read(&NILFS_I(ifile)->i_root->inodes_count);
+	nused = atomic_long_read(&NILFS_I(ifile)->i_root->inodes_count);
 	err = nilfs_palloc_count_max_entries(ifile, nused, nmaxinodes);
 	if (likely(!err))
 		*nfreeinodes = *nmaxinodes - nused;
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 689fb60..9e13255 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -54,7 +54,7 @@ void nilfs_inode_add_blocks(struct inode *inode, int n)
 
 	inode_add_bytes(inode, (1 << inode->i_blkbits) * n);
 	if (root)
-		atomic_add(n, &root->blocks_count);
+		atomic_long_add(n, &root->blocks_count);
 }
 
 void nilfs_inode_sub_blocks(struct inode *inode, int n)
@@ -63,7 +63,7 @@ void nilfs_inode_sub_blocks(struct inode *inode, int n)
 
 	inode_sub_bytes(inode, (1 << inode->i_blkbits) * n);
 	if (root)
-		atomic_sub(n, &root->blocks_count);
+		atomic_long_sub(n, &root->blocks_count);
 }
 
 /**
@@ -350,7 +350,7 @@ struct inode *nilfs_new_inode(struct inode *dir, umode_t mode)
 		goto failed_ifile_create_inode;
 	/* reference count of i_bh inherits from nilfs_mdt_read_block() */
 
-	atomic_inc(&root->inodes_count);
+	atomic_long_inc(&root->inodes_count);
 	inode_init_owner(inode, dir, mode);
 	inode->i_ino = ino;
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
@@ -782,7 +782,7 @@ void nilfs_evict_inode(struct inode *inode)
 
 	ret = nilfs_ifile_delete_inode(ii->i_root->ifile, inode->i_ino);
 	if (!ret)
-		atomic_dec(&ii->i_root->inodes_count);
+		atomic_long_dec(&ii->i_root->inodes_count);
 
 	nilfs_clear_inode(inode);
 
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index a5752a58..051f67b 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -835,9 +835,9 @@ static int nilfs_segctor_fill_in_checkpoint(struct nilfs_sc_info *sci)
 	raw_cp->cp_snapshot_list.ssl_next = 0;
 	raw_cp->cp_snapshot_list.ssl_prev = 0;
 	raw_cp->cp_inodes_count =
-		cpu_to_le64(atomic_read(&sci->sc_root->inodes_count));
+		cpu_to_le64(atomic_long_read(&sci->sc_root->inodes_count));
 	raw_cp->cp_blocks_count =
-		cpu_to_le64(atomic_read(&sci->sc_root->blocks_count));
+		cpu_to_le64(atomic_long_read(&sci->sc_root->blocks_count));
 	raw_cp->cp_nblk_inc =
 		cpu_to_le64(sci->sc_nblk_inc + sci->sc_nblk_this_inc);
 	raw_cp->cp_create = cpu_to_le64(sci->sc_seg_ctime);
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index acd110f..f1ce6d4 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -554,8 +554,10 @@ int nilfs_attach_checkpoint(struct super_block *sb, __u64 cno, int curr_mnt,
 	if (err)
 		goto failed_bh;
 
-	atomic_set(&root->inodes_count, le64_to_cpu(raw_cp->cp_inodes_count));
-	atomic_set(&root->blocks_count, le64_to_cpu(raw_cp->cp_blocks_count));
+	atomic_long_set(&root->inodes_count,
+			le64_to_cpu(raw_cp->cp_inodes_count));
+	atomic_long_set(&root->blocks_count,
+			le64_to_cpu(raw_cp->cp_blocks_count));
 
 	nilfs_cpfile_put_checkpoint(nilfs->ns_cpfile, cno, bh_cp);
 
@@ -647,7 +649,7 @@ static int nilfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 			 * curent inodes count as maximum possible and
 			 * zero as free inodes value.
 			 */
-			nmaxinodes = atomic_read(&root->inodes_count);
+			nmaxinodes = atomic_long_read(&root->inodes_count);
 			nfreeinodes = 0;
 			err = 0;
 		} else
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 41e6a04..d005510 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -764,8 +764,8 @@ nilfs_find_or_create_root(struct the_nilfs *nilfs, __u64 cno)
 	new->ifile = NULL;
 	new->nilfs = nilfs;
 	atomic_set(&new->count, 1);
-	atomic_set(&new->inodes_count, 0);
-	atomic_set(&new->blocks_count, 0);
+	atomic_long_set(&new->inodes_count, 0);
+	atomic_long_set(&new->blocks_count, 0);
 
 	rb_link_node(&new->rb_node, parent, p);
 	rb_insert_color(&new->rb_node, &nilfs->ns_cptree);
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index be1267a..e37a246 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -241,8 +241,8 @@ struct nilfs_root {
 	struct the_nilfs *nilfs;
 	struct inode *ifile;
 
-	atomic_t inodes_count;
-	atomic_t blocks_count;
+	atomic_long_t inodes_count;
+	atomic_long_t blocks_count;
 };
 
 /* Special checkpoint number */
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
