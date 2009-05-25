From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 16/17] nilfs2: allow future expansion of
	metadata read out via get info ioctl
Date: Mon, 25 May 2009 19:18:20 +0900
Message-ID: <1243246701-5193-17-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1243246701-5193-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1243246701-5193-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Nilfs has some ioctl commands to read out metadata from meta data
files:

 - NILFS_IOCTL_GET_CPINFO for checkpoint file,
 - NILFS_IOCTL_GET_SUINFO for segment usage file, and
 - NILFS_IOCTL_GET_VINFO for Disk Address Transalation (DAT) file,
   respectively.

Every routine on these metadata files is implemented so that it allows
future expansion of on-disk format.  But, the above ioctl commands do
not support expansion even though nilfs_argv structure can handle
arbitrary size for data exchanged via ioctl.

This allows future expansion of the following structures which give
basic format of the "get information" ioctls:

 - struct nilfs_cpinfo
 - struct nilfs_suinfo
 - struct nilfs_vinfo

So, this introduces forward compatility of such ioctl commands.

In this patch, a sanity check in nilfs_ioctl_get_info() function is
changed to accept larger data structure [1], and metadata read
routines are rewritten so that they become compatible for larger
structures; the routines will just ignore the remaining fields which
the current version of nilfs doesn't know.

[1] The ioctl function already has another upper limit (PAGE_SIZE
    against a structure, which appears in nilfs_ioctl_wrap_copy
    function), and this will not cause security problem.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/cpfile.c |   33 +++++++++++++++++++++------------
 fs/nilfs2/cpfile.h |    4 ++--
 fs/nilfs2/dat.c    |   21 +++++++++++----------
 fs/nilfs2/dat.h    |    2 +-
 fs/nilfs2/ioctl.c  |    9 +++++----
 fs/nilfs2/sufile.c |   22 +++++++++++++---------
 fs/nilfs2/sufile.h |    2 +-
 7 files changed, 54 insertions(+), 39 deletions(-)

diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index 7d8c845..8db96ae 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -382,9 +382,10 @@ static void nilfs_cpfile_checkpoint_to_cpinfo(struct inode *cpfile,
 }
 
 static ssize_t nilfs_cpfile_do_get_cpinfo(struct inode *cpfile, __u64 *cnop,
-					  struct nilfs_cpinfo *ci, size_t nci)
+					  void *buf, unsigned cisz, size_t nci)
 {
 	struct nilfs_checkpoint *cp;
+	struct nilfs_cpinfo *ci = buf;
 	struct buffer_head *bh;
 	size_t cpsz = NILFS_MDT(cpfile)->mi_entry_size;
 	__u64 cur_cno = nilfs_mdt_cno(cpfile), cno = *cnop;
@@ -408,17 +409,22 @@ static ssize_t nilfs_cpfile_do_get_cpinfo(struct inode *cpfile, __u64 *cnop,
 		kaddr = kmap_atomic(bh->b_page, KM_USER0);
 		cp = nilfs_cpfile_block_get_checkpoint(cpfile, cno, bh, kaddr);
 		for (i = 0; i < ncps && n < nci; i++, cp = (void *)cp + cpsz) {
-			if (!nilfs_checkpoint_invalid(cp))
-				nilfs_cpfile_checkpoint_to_cpinfo(
-					cpfile, cp, &ci[n++]);
+			if (!nilfs_checkpoint_invalid(cp)) {
+				nilfs_cpfile_checkpoint_to_cpinfo(cpfile, cp,
+								  ci);
+				ci = (void *)ci + cisz;
+				n++;
+			}
 		}
 		kunmap_atomic(kaddr, KM_USER0);
 		brelse(bh);
 	}
 
 	ret = n;
-	if (n > 0)
-		*cnop = ci[n - 1].ci_cno + 1;
+	if (n > 0) {
+		ci = (void *)ci - cisz;
+		*cnop = ci->ci_cno + 1;
+	}
 
  out:
 	up_read(&NILFS_MDT(cpfile)->mi_sem);
@@ -426,11 +432,12 @@ static ssize_t nilfs_cpfile_do_get_cpinfo(struct inode *cpfile, __u64 *cnop,
 }
 
 static ssize_t nilfs_cpfile_do_get_ssinfo(struct inode *cpfile, __u64 *cnop,
-					  struct nilfs_cpinfo *ci, size_t nci)
+					  void *buf, unsigned cisz, size_t nci)
 {
 	struct buffer_head *bh;
 	struct nilfs_cpfile_header *header;
 	struct nilfs_checkpoint *cp;
+	struct nilfs_cpinfo *ci = buf;
 	__u64 curr = *cnop, next;
 	unsigned long curr_blkoff, next_blkoff;
 	void *kaddr;
@@ -470,7 +477,9 @@ static ssize_t nilfs_cpfile_do_get_ssinfo(struct inode *cpfile, __u64 *cnop,
 		if (unlikely(nilfs_checkpoint_invalid(cp) ||
 			     !nilfs_checkpoint_snapshot(cp)))
 			break;
-		nilfs_cpfile_checkpoint_to_cpinfo(cpfile, cp, &ci[n++]);
+		nilfs_cpfile_checkpoint_to_cpinfo(cpfile, cp, ci);
+		ci = (void *)ci + cisz;
+		n++;
 		next = le64_to_cpu(cp->cp_snapshot_list.ssl_next);
 		if (next == 0)
 			break; /* reach end of the snapshot list */
@@ -509,13 +518,13 @@ static ssize_t nilfs_cpfile_do_get_ssinfo(struct inode *cpfile, __u64 *cnop,
  */
 
 ssize_t nilfs_cpfile_get_cpinfo(struct inode *cpfile, __u64 *cnop, int mode,
-				struct nilfs_cpinfo *ci, size_t nci)
+				void *buf, unsigned cisz, size_t nci)
 {
 	switch (mode) {
 	case NILFS_CHECKPOINT:
-		return nilfs_cpfile_do_get_cpinfo(cpfile, cnop, ci, nci);
+		return nilfs_cpfile_do_get_cpinfo(cpfile, cnop, buf, cisz, nci);
 	case NILFS_SNAPSHOT:
-		return nilfs_cpfile_do_get_ssinfo(cpfile, cnop, ci, nci);
+		return nilfs_cpfile_do_get_ssinfo(cpfile, cnop, buf, cisz, nci);
 	default:
 		return -EINVAL;
 	}
@@ -533,7 +542,7 @@ int nilfs_cpfile_delete_checkpoint(struct inode *cpfile, __u64 cno)
 	ssize_t nci;
 	int ret;
 
-	nci = nilfs_cpfile_do_get_cpinfo(cpfile, &tcno, &ci, 1);
+	nci = nilfs_cpfile_do_get_cpinfo(cpfile, &tcno, &ci, sizeof(ci), 1);
 	if (nci < 0)
 		return nci;
 	else if (nci == 0 || ci.ci_cno != cno)
diff --git a/fs/nilfs2/cpfile.h b/fs/nilfs2/cpfile.h
index 1a8a100..788a459 100644
--- a/fs/nilfs2/cpfile.h
+++ b/fs/nilfs2/cpfile.h
@@ -39,7 +39,7 @@ int nilfs_cpfile_delete_checkpoint(struct inode *, __u64);
 int nilfs_cpfile_change_cpmode(struct inode *, __u64, int);
 int nilfs_cpfile_is_snapshot(struct inode *, __u64);
 int nilfs_cpfile_get_stat(struct inode *, struct nilfs_cpstat *);
-ssize_t nilfs_cpfile_get_cpinfo(struct inode *, __u64 *, int,
-				struct nilfs_cpinfo *, size_t);
+ssize_t nilfs_cpfile_get_cpinfo(struct inode *, __u64 *, int, void *, unsigned,
+				size_t);
 
 #endif	/* _NILFS_CPFILE_H */
diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index 1827f62..0b2710e 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -376,36 +376,37 @@ int nilfs_dat_translate(struct inode *dat, __u64 vblocknr, sector_t *blocknrp)
 	return ret;
 }
 
-ssize_t nilfs_dat_get_vinfo(struct inode *dat, struct nilfs_vinfo *vinfo,
+ssize_t nilfs_dat_get_vinfo(struct inode *dat, void *buf, unsigned visz,
 			    size_t nvi)
 {
 	struct buffer_head *entry_bh;
 	struct nilfs_dat_entry *entry;
+	struct nilfs_vinfo *vinfo = buf;
 	__u64 first, last;
 	void *kaddr;
 	unsigned long entries_per_block = NILFS_MDT(dat)->mi_entries_per_block;
 	int i, j, n, ret;
 
 	for (i = 0; i < nvi; i += n) {
-		ret = nilfs_palloc_get_entry_block(dat, vinfo[i].vi_vblocknr,
+		ret = nilfs_palloc_get_entry_block(dat, vinfo->vi_vblocknr,
 						   0, &entry_bh);
 		if (ret < 0)
 			return ret;
 		kaddr = kmap_atomic(entry_bh->b_page, KM_USER0);
 		/* last virtual block number in this block */
-		first = vinfo[i].vi_vblocknr;
+		first = vinfo->vi_vblocknr;
 		do_div(first, entries_per_block);
 		first *= entries_per_block;
 		last = first + entries_per_block - 1;
 		for (j = i, n = 0;
-		     j < nvi && vinfo[j].vi_vblocknr >= first &&
-			     vinfo[j].vi_vblocknr <= last;
-		     j++, n++) {
+		     j < nvi && vinfo->vi_vblocknr >= first &&
+			     vinfo->vi_vblocknr <= last;
+		     j++, n++, vinfo = (void *)vinfo + visz) {
 			entry = nilfs_palloc_block_get_entry(
-				dat, vinfo[j].vi_vblocknr, entry_bh, kaddr);
-			vinfo[j].vi_start = le64_to_cpu(entry->de_start);
-			vinfo[j].vi_end = le64_to_cpu(entry->de_end);
-			vinfo[j].vi_blocknr = le64_to_cpu(entry->de_blocknr);
+				dat, vinfo->vi_vblocknr, entry_bh, kaddr);
+			vinfo->vi_start = le64_to_cpu(entry->de_start);
+			vinfo->vi_end = le64_to_cpu(entry->de_end);
+			vinfo->vi_blocknr = le64_to_cpu(entry->de_blocknr);
 		}
 		kunmap_atomic(kaddr, KM_USER0);
 		brelse(entry_bh);
diff --git a/fs/nilfs2/dat.h b/fs/nilfs2/dat.h
index d956065..d328b81 100644
--- a/fs/nilfs2/dat.h
+++ b/fs/nilfs2/dat.h
@@ -47,6 +47,6 @@ void nilfs_dat_abort_end(struct inode *, struct nilfs_palloc_req *);
 int nilfs_dat_mark_dirty(struct inode *, __u64);
 int nilfs_dat_freev(struct inode *, __u64 *, size_t);
 int nilfs_dat_move(struct inode *, __u64, sector_t);
-ssize_t nilfs_dat_get_vinfo(struct inode *, struct nilfs_vinfo *, size_t);
+ssize_t nilfs_dat_get_vinfo(struct inode *, void *, unsigned, size_t);
 
 #endif	/* _NILFS_DAT_H */
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index bdad7e4..6ea5f87 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -152,7 +152,7 @@ nilfs_ioctl_do_get_cpinfo(struct the_nilfs *nilfs, __u64 *posp, int flags,
 
 	down_read(&nilfs->ns_segctor_sem);
 	ret = nilfs_cpfile_get_cpinfo(nilfs->ns_cpfile, posp, flags, buf,
-				      nmembs);
+				      size, nmembs);
 	up_read(&nilfs->ns_segctor_sem);
 	return ret;
 }
@@ -182,7 +182,8 @@ nilfs_ioctl_do_get_suinfo(struct the_nilfs *nilfs, __u64 *posp, int flags,
 	int ret;
 
 	down_read(&nilfs->ns_segctor_sem);
-	ret = nilfs_sufile_get_suinfo(nilfs->ns_sufile, *posp, buf, nmembs);
+	ret = nilfs_sufile_get_suinfo(nilfs->ns_sufile, *posp, buf, size,
+				      nmembs);
 	up_read(&nilfs->ns_segctor_sem);
 	return ret;
 }
@@ -212,7 +213,7 @@ nilfs_ioctl_do_get_vinfo(struct the_nilfs *nilfs, __u64 *posp, int flags,
 	int ret;
 
 	down_read(&nilfs->ns_segctor_sem);
-	ret = nilfs_dat_get_vinfo(nilfs_dat_inode(nilfs), buf, nmembs);
+	ret = nilfs_dat_get_vinfo(nilfs_dat_inode(nilfs), buf, size, nmembs);
 	up_read(&nilfs->ns_segctor_sem);
 	return ret;
 }
@@ -589,7 +590,7 @@ static int nilfs_ioctl_get_info(struct inode *inode, struct file *filp,
 	if (copy_from_user(&argv, argp, sizeof(argv)))
 		return -EFAULT;
 
-	if (argv.v_size != membsz)
+	if (argv.v_size < membsz)
 		return -EINVAL;
 
 	ret = nilfs_ioctl_wrap_copy(nilfs, &argv, _IOC_DIR(cmd), dofunc);
diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index da12732..37994d4 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -587,7 +587,8 @@ void nilfs_sufile_do_set_error(struct inode *sufile, __u64 segnum,
  * nilfs_sufile_get_suinfo -
  * @sufile: inode of segment usage file
  * @segnum: segment number to start looking
- * @si: array of suinfo
+ * @buf: array of suinfo
+ * @sisz: byte size of suinfo
  * @nsi: size of suinfo array
  *
  * Description:
@@ -599,11 +600,12 @@ void nilfs_sufile_do_set_error(struct inode *sufile, __u64 segnum,
  *
  * %-ENOMEM - Insufficient amount of memory available.
  */
-ssize_t nilfs_sufile_get_suinfo(struct inode *sufile, __u64 segnum,
-				struct nilfs_suinfo *si, size_t nsi)
+ssize_t nilfs_sufile_get_suinfo(struct inode *sufile, __u64 segnum, void *buf,
+				unsigned sisz, size_t nsi)
 {
 	struct buffer_head *su_bh;
 	struct nilfs_segment_usage *su;
+	struct nilfs_suinfo *si = buf;
 	size_t susz = NILFS_MDT(sufile)->mi_entry_size;
 	struct the_nilfs *nilfs = NILFS_MDT(sufile)->mi_nilfs;
 	void *kaddr;
@@ -628,20 +630,22 @@ ssize_t nilfs_sufile_get_suinfo(struct inode *sufile, __u64 segnum,
 			if (ret != -ENOENT)
 				goto out;
 			/* hole */
-			memset(&si[i], 0, sizeof(struct nilfs_suinfo) * n);
+			memset(si, 0, sisz * n);
+			si = (void *)si + sisz * n;
 			continue;
 		}
 
 		kaddr = kmap_atomic(su_bh->b_page, KM_USER0);
 		su = nilfs_sufile_block_get_segment_usage(
 			sufile, segnum, su_bh, kaddr);
-		for (j = 0; j < n; j++, su = (void *)su + susz) {
-			si[i + j].sui_lastmod = le64_to_cpu(su->su_lastmod);
-			si[i + j].sui_nblocks = le32_to_cpu(su->su_nblocks);
-			si[i + j].sui_flags = le32_to_cpu(su->su_flags) &
+		for (j = 0; j < n;
+		     j++, su = (void *)su + susz, si = (void *)si + sisz) {
+			si->sui_lastmod = le64_to_cpu(su->su_lastmod);
+			si->sui_nblocks = le32_to_cpu(su->su_nblocks);
+			si->sui_flags = le32_to_cpu(su->su_flags) &
 				~(1UL << NILFS_SEGMENT_USAGE_ACTIVE);
 			if (nilfs_segment_is_active(nilfs, segnum + j))
-				si[i + j].sui_flags |=
+				si->sui_flags |=
 					(1UL << NILFS_SEGMENT_USAGE_ACTIVE);
 		}
 		kunmap_atomic(kaddr, KM_USER0);
diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
index fd6232e..a2c4d76 100644
--- a/fs/nilfs2/sufile.h
+++ b/fs/nilfs2/sufile.h
@@ -43,7 +43,7 @@ void nilfs_sufile_put_segment_usage(struct inode *, __u64,
 				    struct buffer_head *);
 int nilfs_sufile_get_stat(struct inode *, struct nilfs_sustat *);
 int nilfs_sufile_get_ncleansegs(struct inode *, unsigned long *);
-ssize_t nilfs_sufile_get_suinfo(struct inode *, __u64, struct nilfs_suinfo *,
+ssize_t nilfs_sufile_get_suinfo(struct inode *, __u64, void *, unsigned,
 				size_t);
 
 int nilfs_sufile_updatev(struct inode *, __u64 *, size_t, int, size_t *,
-- 
1.6.2
