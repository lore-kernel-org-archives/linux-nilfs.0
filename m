From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH] cleanerd stopping
Date: Fri, 19 Dec 2008 02:07:49 +0900 (JST)
Message-ID: <20081219.020749.105118792.ryusuke@osrg.net>
References: <49162468.8020503@mib-infotech.co.nz>
	<20081217.001437.44157644.ryusuke@osrg.net>
	<4947EA0B.3040604@mib-infotech.co.nz>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <4947EA0B.3040604-jE24nFfhqzU3hwNNidygWXTaI6DYlTYJ@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: John-jE24nFfhqzU3hwNNidygWXTaI6DYlTYJ@public.gmane.org
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi,
On Wed, 17 Dec 2008 06:48:59 +1300, John Huttley wrote:
> Ryusuke Konishi wrote:
> > I've found a bug of nilfs2 kernel module (in ioctl code) that may
> > cause this error.
> >
> > If the bug was the cause, it should occur for volumes having numerous
> > snapshots, or on the machine whose amount of memory is low.
> >
> > I would like to fix this early.
>
> The machine is has 1Gb ram 5110 processor in 64 bit mode
> nilfs is in a 4Gb partition. It is my IMAP spool.
> The only time snapshots are taken is for backup, this is daily.
> 
> Traffic is low on the fs and the snapshot is deleted after the backup.

All right. This seems like another problem.

Anyhow, I made a patch to fix the other "no such file or directory"
problem of the cleaner daemon.  It's against nilfs-2.0.5.

Try the attached patch when in the mood.
I'll include it in the next nilfs release.

Thanks,
Ryusuke

---
diff --git a/fs/cpfile.c b/fs/cpfile.c
index 480dd31..1e9ce4c 100644
--- a/fs/cpfile.c
+++ b/fs/cpfile.c
@@ -422,20 +422,20 @@ static ssize_t nilfs_cpfile_do_get_cpinfo(struct inode *cpfile, __u64 cno,
 	return ret;
 }
 
-static ssize_t nilfs_cpfile_do_get_ssinfo(struct inode *cpfile, __u64 cno,
+static ssize_t nilfs_cpfile_do_get_ssinfo(struct inode *cpfile, __u64 *cnop,
 					  struct nilfs_cpinfo *ci, size_t nci)
 {
 	struct buffer_head *bh;
 	struct nilfs_cpfile_header *header;
 	struct nilfs_checkpoint *cp;
-	__u64 curr, next;
+	__u64 curr = *cnop, next;
 	unsigned long curr_blkoff, next_blkoff;
 	void *kaddr;
 	int n, ret;
 
 	down_read(&NILFS_MDT(cpfile)->mi_sem);
 
-	if (cno == 0) {
+	if (curr == 0) {
 		ret = nilfs_cpfile_get_header_block(cpfile, &bh);
 		if (ret < 0)
 			goto out;
@@ -448,8 +448,11 @@ static ssize_t nilfs_cpfile_do_get_ssinfo(struct inode *cpfile, __u64 cno,
 			ret = 0;
 			goto out;
 		}
-	} else
-		curr = cno;
+	} else if (unlikely(curr == ~(__u64)0)) {
+		ret = 0;
+		goto out;
+	}
+
 	curr_blkoff = nilfs_cpfile_get_blkoff(cpfile, curr);
 	ret = nilfs_cpfile_get_checkpoint_block(cpfile, curr, 0, &bh);
 	if (ret < 0)
@@ -461,7 +464,7 @@ static ssize_t nilfs_cpfile_do_get_ssinfo(struct inode *cpfile, __u64 cno,
 		nilfs_cpfile_checkpoint_to_cpinfo(cpfile, cp, &ci[n]);
 		next = le64_to_cpu(cp->cp_snapshot_list.ssl_next);
 		if (next == 0) {
-			curr = next;
+			curr = ~(__u64)0; /* Terminator */
 			n++;
 			break;
 		}
@@ -480,6 +483,7 @@ static ssize_t nilfs_cpfile_do_get_ssinfo(struct inode *cpfile, __u64 cno,
 	}
 	kunmap_atomic(kaddr, KM_USER0);
 	brelse(bh);
+	*cnop = curr;
 	ret = n;
 
  out:
@@ -494,15 +498,15 @@ static ssize_t nilfs_cpfile_do_get_ssinfo(struct inode *cpfile, __u64 cno,
  * @ci:
  * @nci:
  */
-ssize_t nilfs_cpfile_get_cpinfo(struct inode *cpfile,
-				__u64 cno, int mode,
+
+ssize_t nilfs_cpfile_get_cpinfo(struct inode *cpfile, __u64 *cnop, int mode,
 				struct nilfs_cpinfo *ci, size_t nci)
 {
 	switch (mode) {
 	case NILFS_CHECKPOINT:
-		return nilfs_cpfile_do_get_cpinfo(cpfile, cno, ci, nci);
+		return nilfs_cpfile_do_get_cpinfo(cpfile, *cnop, ci, nci);
 	case NILFS_SNAPSHOT:
-		return nilfs_cpfile_do_get_ssinfo(cpfile, cno, ci, nci);
+		return nilfs_cpfile_do_get_ssinfo(cpfile, cnop, ci, nci);
 	default:
 		return -EINVAL;
 	}
diff --git a/fs/cpfile.h b/fs/cpfile.h
index 8bebcf1..02917e4 100644
--- a/fs/cpfile.h
+++ b/fs/cpfile.h
@@ -39,7 +39,7 @@ int nilfs_cpfile_delete_checkpoint(struct inode *, __u64);
 int nilfs_cpfile_change_cpmode(struct inode *, __u64, int);
 int nilfs_cpfile_is_snapshot(struct inode *, __u64);
 int nilfs_cpfile_get_stat(struct inode *, struct nilfs_cpstat *);
-ssize_t nilfs_cpfile_get_cpinfo(struct inode *, __u64, int,
+ssize_t nilfs_cpfile_get_cpinfo(struct inode *, __u64 *, int,
 				struct nilfs_cpinfo *, size_t);
 
 #endif	/* _NILFS_CPFILE_H */
diff --git a/fs/ioctl.c b/fs/ioctl.c
index 5832e3b..9c55ee5 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -34,41 +34,32 @@
 #include "dat.h"
 
 
-#define KMALLOC_SIZE_MIN	4096	/* 4KB */
-#define KMALLOC_SIZE_MAX	131072	/* 128 KB */
-
 static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
 				 struct nilfs_argv *argv, int dir,
 				 ssize_t (*dofunc)(struct the_nilfs *,
-						   int, int,
+						   __u64 *, int,
 						   void *, size_t, size_t))
 {
 	void *buf;
-	size_t ksize, maxmembs, total, n;
+	size_t maxmembs, total, n;
 	ssize_t nr;
 	int ret, i;
+	__u64 pos, ppos;
 
 	if (argv->v_nmembs == 0)
 		return 0;
 
-	ksize = min_t(unsigned long, argv->v_nmembs * argv->v_size,
-		      KMALLOC_SIZE_MAX);
-	while (ksize >= KMALLOC_SIZE_MIN) {
-		buf = kmalloc(ksize, GFP_NOWAIT | __GFP_NOWARN);
-		if (buf)
-			goto allocated;
-		ksize >>= 1;
-	}
-	ksize = max_t(size_t, ksize, argv->v_size);
-	buf = kmalloc(ksize, GFP_NOFS);
+	if (argv->v_size > PAGE_SIZE)
+		return -EINVAL;
+
+	buf = (void *)__get_free_pages(GFP_NOFS, 0);
 	if (unlikely(!buf))
 		return -ENOMEM;
-
- allocated:
-	maxmembs = ksize / argv->v_size;
+	maxmembs = PAGE_SIZE / argv->v_size;
 
 	ret = 0;
 	total = 0;
+	pos = argv->v_index;
 	for (i = 0; i < argv->v_nmembs; i += n) {
 		n = (argv->v_nmembs - i < maxmembs) ?
 			argv->v_nmembs - i : maxmembs;
@@ -79,8 +70,9 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
 			ret = -EFAULT;
 			break;
 		}
-		nr = (*dofunc)(nilfs, argv->v_index + i, argv->v_flags, buf,
-			       argv->v_size, n);
+		ppos = pos;
+		nr = (*dofunc)(nilfs, &pos, argv->v_flags, buf, argv->v_size,
+			       n);
 		if (nr < 0) {
 			ret = nr;
 			break;
@@ -93,10 +85,14 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
 			break;
 		}
 		total += nr;
+		if ((size_t)nr < n)
+			break;
+		if (pos == ppos)
+			pos += n;
 	}
 	argv->v_nmembs = total;
 
-	kfree(buf);
+	free_pages((unsigned long)buf, 0);
 	return ret;
 }
 
@@ -141,10 +137,10 @@ nilfs_ioctl_delete_checkpoint(struct inode *inode, struct file *filp,
 }
 
 static ssize_t
-nilfs_ioctl_do_get_cpinfo(struct the_nilfs *nilfs, int index, int flags,
+nilfs_ioctl_do_get_cpinfo(struct the_nilfs *nilfs, __u64 *posp, int flags,
 			  void *buf, size_t size, size_t nmembs)
 {
-	return nilfs_cpfile_get_cpinfo(nilfs->ns_cpfile, index, flags, buf,
+	return nilfs_cpfile_get_cpinfo(nilfs->ns_cpfile, posp, flags, buf,
 				       nmembs);
 }
 
@@ -189,10 +185,10 @@ static int nilfs_ioctl_get_cpstat(struct inode *inode, struct file *filp,
 }
 
 static ssize_t
-nilfs_ioctl_do_get_suinfo(struct the_nilfs *nilfs, int index, int flags,
+nilfs_ioctl_do_get_suinfo(struct the_nilfs *nilfs, __u64 *posp, int flags,
 			  void *buf, size_t size, size_t nmembs)
 {
-	return nilfs_sufile_get_suinfo(nilfs->ns_sufile, index, buf, nmembs);
+	return nilfs_sufile_get_suinfo(nilfs->ns_sufile, *posp, buf, nmembs);
 }
 
 static int nilfs_ioctl_get_suinfo(struct inode *inode, struct file *filp,
@@ -236,7 +232,7 @@ static int nilfs_ioctl_get_sustat(struct inode *inode, struct file *filp,
 }
 
 static ssize_t
-nilfs_ioctl_do_get_vinfo(struct the_nilfs *nilfs, int index, int flags,
+nilfs_ioctl_do_get_vinfo(struct the_nilfs *nilfs, __u64 *posp, int flags,
 			 void *buf, size_t size, size_t nmembs)
 {
 	return nilfs_dat_get_vinfo(nilfs_dat_inode(nilfs), buf, nmembs);
@@ -264,7 +260,7 @@ static int nilfs_ioctl_get_vinfo(struct inode *inode, struct file *filp,
 }
 
 static ssize_t
-nilfs_ioctl_do_get_bdescs(struct the_nilfs *nilfs, int index, int flags,
+nilfs_ioctl_do_get_bdescs(struct the_nilfs *nilfs, __u64 *posp, int flags,
 			  void *buf, size_t size, size_t nmembs)
 {
 	struct inode *dat = nilfs_dat_inode(nilfs);
@@ -342,7 +338,7 @@ static int nilfs_ioctl_move_inode_block(struct inode *inode,
 }
 
 static ssize_t
-nilfs_ioctl_do_move_blocks(struct the_nilfs *nilfs, int index, int flags,
+nilfs_ioctl_do_move_blocks(struct the_nilfs *nilfs, __u64 *posp, int flags,
 			   void *buf, size_t size, size_t nmembs)
 {
 	struct inode *inode;
@@ -414,7 +410,7 @@ static inline int nilfs_ioctl_move_blocks(struct the_nilfs *nilfs,
 }
 
 static ssize_t
-nilfs_ioctl_do_delete_checkpoints(struct the_nilfs *nilfs, int index,
+nilfs_ioctl_do_delete_checkpoints(struct the_nilfs *nilfs, __u64 *posp,
 				  int flags, void *buf, size_t size,
 				  size_t nmembs)
 {
@@ -440,7 +436,7 @@ static inline int nilfs_ioctl_delete_checkpoints(struct the_nilfs *nilfs,
 }
 
 static ssize_t
-nilfs_ioctl_do_free_vblocknrs(struct the_nilfs *nilfs, int index, int flags,
+nilfs_ioctl_do_free_vblocknrs(struct the_nilfs *nilfs, __u64 *posp, int flags,
 			      void *buf, size_t size, size_t nmembs)
 {
 	int ret = nilfs_dat_freev(nilfs_dat_inode(nilfs), buf, nmembs);
@@ -457,8 +453,9 @@ static inline int nilfs_ioctl_free_vblocknrs(struct the_nilfs *nilfs,
 }
 
 static ssize_t
-nilfs_ioctl_do_mark_blocks_dirty(struct the_nilfs *nilfs, int index, int flags,
-				 void *buf, size_t size, size_t nmembs)
+nilfs_ioctl_do_mark_blocks_dirty(struct the_nilfs *nilfs, __u64 *posp,
+				 int flags, void *buf, size_t size,
+				 size_t nmembs)
 {
 	struct inode *dat = nilfs_dat_inode(nilfs);
 	struct nilfs_bmap *bmap = NILFS_I(dat)->i_bmap;
@@ -507,7 +504,7 @@ static inline int nilfs_ioctl_mark_blocks_dirty(struct the_nilfs *nilfs,
 }
 
 static ssize_t
-nilfs_ioctl_do_free_segments(struct the_nilfs *nilfs, int index, int flags,
+nilfs_ioctl_do_free_segments(struct the_nilfs *nilfs, __u64 *posp, int flags,
 			     void *buf, size_t size, size_t nmembs)
 {
 	struct nilfs_sb_info *sbi = nilfs_get_writer(nilfs);
