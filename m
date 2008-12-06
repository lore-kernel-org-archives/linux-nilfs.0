From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: nilfs2 fails to mount after io/error
Date: Sun, 07 Dec 2008 04:05:09 +0900 (JST)
Message-ID: <20081207.040509.20004012.ryusuke@osrg.net>
References: <20081204092947.c29d230d.adrian@blinkenlights.ch>
	<20081204.215805.88483726.ryusuke@osrg.net>
	<20081204140431.ec72f1ec.adrian@blinkenlights.ch>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20081204140431.ec72f1ec.adrian-4ZM2p5qjiQGewZBzVTKGGg@public.gmane.org>
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
To: adrian-4ZM2p5qjiQGewZBzVTKGGg@public.gmane.org
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi,

On Thu, 4 Dec 2008 14:04:31 +0100, Adrian Ulrich wrote:
> > Wait for a moment.  I'm now writing an impromptu tool
> > to correct this kind of problem.
> 
> Oh, great. I'll be glad to test it ;-)

Sorry to keep you waiting. ;-)

I will attach a patch against nilfs2-utils-2.0.6, which adds the
tool 'fsck0.nilfs2'.

 # fsck0.nilfs2 <device name>

will, hopefully, correct your partition.
(I'm not sure because it's not yet tested enough)

Regards,
Ryusuke Konishi
---
From ce7bac99115bdf1fdadc002ba2b14bcb1ae4c19c Mon Sep 17 00:00:00 2001
From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Date: Fri, 5 Dec 2008 00:53:21 +0900
Subject: [PATCH] nilfs2-utils: add test tool to correct log pointer in super block

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 sbin/mkfs/Makefile.am    |    6 +-
 sbin/mkfs/fsck0.nilfs2.c |  958 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 963 insertions(+), 1 deletions(-)
 create mode 100644 sbin/mkfs/fsck0.nilfs2.c

diff --git a/sbin/mkfs/Makefile.am b/sbin/mkfs/Makefile.am
index 965094e..5cbe02a 100644
--- a/sbin/mkfs/Makefile.am
+++ b/sbin/mkfs/Makefile.am
@@ -4,13 +4,17 @@
 ##
 ## Written by Koji Sato <koji-sG5X7nlA6pw@public.gmane.org>.
 
-sbin_PROGRAMS = mkfs.nilfs2
+sbin_PROGRAMS = mkfs.nilfs2 fsck0.nilfs2
 
 mkfs_nilfs2_SOURCES = mkfs.c bitops.c ../../lib/crc32.c mkfs.h
 mkfs_nilfs2_CFLAGS = -Wall
 mkfs_nilfs2_CPPFLAGS = -I$(top_srcdir)/include
 mkfs_nilfs2_LDADD = -luuid
 
+fsck0_nilfs2_SOURCES = fsck0.nilfs2.c ../../lib/crc32.c mkfs.h
+fsck0_nilfs2_CFLAGS = -Wall
+fsck0_nilfs2_CPPFLAGS = -I$(top_srcdir)/include
+
 install-exec-hook:
 	list='$(sbin_PROGRAMS)'; \
 	for p in $$list; do \
diff --git a/sbin/mkfs/fsck0.nilfs2.c b/sbin/mkfs/fsck0.nilfs2.c
new file mode 100644
index 0000000..d3d335f
--- /dev/null
+++ b/sbin/mkfs/fsck0.nilfs2.c
@@ -0,0 +1,958 @@
+/*
+ * fsck0.nilfs2.c - correct inconsistencies of nilfs2 volume
+ *
+ * Licensed under GPLv2: the complete text of the GNU General Public License
+ * can be found in COPYING file of the nilfs2-utils package.
+ *
+ * Copyright (C) 2008 Nippon Telegraph and Telephone Corporation.
+ * Written by Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
+ */
+#define _LARGEFILE64_SOURCE
+#define _XOPEN_SOURCE 600
+
+#include <sys/types.h>
+#include <linux/types.h>
+#include <endian.h>
+#include <byteswap.h>
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <strings.h>
+#include <stdarg.h>
+#include <stddef.h>
+#include <time.h>
+#include <string.h>
+#include <assert.h>
+#include "mkfs.h"
+
+#define MOUNTS			"/etc/mtab"
+#define LINE_BUFFER_SIZE	256  /* Line buffer size for reading mtab */
+#define MAX_SCAN_SEGMENT	50   /* Maximum number of segments which are
+					tested for the latest segment search */
+#define SCAN_INDICATOR_SPEED	3    /* Indicator speed (smaller value for
+					higher speed) */
+#define SCAN_SEGMENT_MASK	((1U << SCAN_INDICATOR_SPEED) - 1)
+
+# define DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
+
+char *progname = NULL;
+
+struct nilfs_pseg_ref {
+	__u64 blocknr;   /* start blocknumber */
+	__u64 seqnum;    /* sequence number */
+	__u64 cno;       /* checkpoint number */
+	__u64 ctime;     /* creation time */
+};
+
+static int devfd = -1;
+static int blocksize;
+static __u32 crc_seed;
+static __u32 blocks_per_segment;
+static __u64 first_data_block;
+static __u64 nsegments;
+static __u16 checkpoint_size;
+
+static int first_checkpoint_offset;
+static int ncheckpoints_per_block;
+
+/*
+ * Generic routines
+ */
+void die(const char *fmt, ...)
+{
+	va_list args;
+
+	va_start(args, fmt);
+	fprintf(stderr, "%s: ", progname);
+	vfprintf(stderr, fmt, args);
+	fprintf(stderr, "\n");
+	va_end(args);
+
+	if (devfd >= 0)
+		close(devfd);
+	exit(1);
+}
+
+static void (*nilfs_shrink)(void) = NULL;
+
+void *nilfs_malloc(size_t size)
+{
+	void *p = malloc(size);
+	if (!p) {
+		if (nilfs_shrink)
+			nilfs_shrink();
+		p = malloc(size);
+		if (!p)
+			die("memory allocation failure");
+	}
+	return p;
+}
+
+static inline void *nilfs_zalloc(size_t size)
+{
+	void *p = nilfs_malloc(size);
+	memset(p, 0, size);
+	return p;
+}
+
+/*
+ * Block buffer
+ */
+static void *block_buffer = NULL;
+
+static void destroy_block_buffer(void)
+{
+	if (block_buffer) {
+		free(block_buffer);
+		block_buffer = NULL;
+	}
+}
+
+static void init_block_buffer(void)
+{
+	block_buffer = nilfs_malloc(blocksize);
+	atexit(destroy_block_buffer);
+}
+
+static void read_block(int fd, __u64 blocknr, void *buf,
+		       unsigned long size)
+{
+	if (lseek64(fd, blocknr * blocksize, SEEK_SET) < 0 ||
+	    read(fd, buf, size) < size)
+		die("cannot read block (blocknr = %llu)",
+		    (unsigned long long)blocknr);
+}
+
+static inline __u64 segment_start_blocknr(unsigned long segnum)
+{
+	return segnum > 0 ? blocks_per_segment * segnum : first_data_block;
+}
+
+static int pseg_valid(int fd, __u64 pseg_start,
+		      struct nilfs_segment_summary *ss)
+{
+	__u32 crc, sum;
+	int offset = sizeof(ss->ss_datasum);
+	int nblocks = le32_to_cpu(ss->ss_nblocks);
+	__u64 blocknr = pseg_start;
+
+	if (le32_to_cpu(ss->ss_magic) != NILFS_SEGSUM_MAGIC)
+		return 0;
+
+	if (nblocks == 0 || nblocks > blocks_per_segment)
+		return 0;
+
+	sum = le32_to_cpu(ss->ss_datasum);
+
+	posix_fadvise(fd, pseg_start * blocksize, nblocks * blocksize,
+		      POSIX_FADV_SEQUENTIAL);
+
+	read_block(fd, blocknr++, block_buffer, blocksize);
+	crc = nilfs_crc32(crc_seed, block_buffer + offset, blocksize - offset);
+	while (--nblocks > 0) {
+		read_block(fd, blocknr++, block_buffer, blocksize);
+		crc = nilfs_crc32(crc, block_buffer, blocksize);
+	}
+	return crc == sum;
+}
+
+/*
+ * Routines to handle partial segment list
+ */
+struct nilfs_list {  /* use struct list_head in kernel land */
+	struct nilfs_list *prev;
+	struct nilfs_list *next;
+};
+
+static inline void nilfs_list_init(struct nilfs_list *list)
+{
+	list->prev = list->next = list;
+}
+
+static inline int nilfs_list_empty(struct nilfs_list *list)
+{
+	return list->next == list;
+}
+
+static inline void nilfs_list_del(struct nilfs_list *list)
+{
+	struct nilfs_list *p = list->prev, *n = list->next;
+
+	p->next = n;
+	n->prev = p;
+	list->prev = list->next = list;
+}
+
+static inline void nilfs_list_add(struct nilfs_list *list,
+				  struct nilfs_list *item)
+{
+	struct nilfs_list *p = list->prev;
+
+	item->prev = p;
+	item->next = list;
+	p->next = list->prev = item;
+}
+
+/* partial segment information */
+struct nilfs_pseg_info {
+	struct nilfs_list list;
+	__u64 pseg_start;  /* start blocknr */
+	__u32 nblocks;
+	struct nilfs_segment_summary segsum;  /* on-disk log header */
+	__u16 flags;
+};
+
+static inline struct nilfs_pseg_info *
+nilfs_pseg_list_entry(struct nilfs_list *p)
+{
+	return (void *)p - offsetof(struct nilfs_pseg_info, list);
+}
+
+struct nilfs_pseg_info *new_pseg_info(__u64 blocknr)
+{
+	struct nilfs_pseg_info *pseginfo = nilfs_zalloc(sizeof(*pseginfo));
+
+	pseginfo->pseg_start = blocknr;
+	nilfs_list_init(&pseginfo->list);
+	return pseginfo;
+}
+
+static void dispose_pseg_list(struct nilfs_list *list)
+{
+	struct nilfs_list *p, *n;
+
+	for (p = list->next; n = p->next, p != list; p = n) {
+		nilfs_list_del(p);
+		free(nilfs_pseg_list_entry(p));
+	}    
+}
+
+/*
+ * Segment information
+ */
+struct nilfs_segment_info {
+	struct nilfs_list list;
+	struct nilfs_list pseg_list;	/* partial segment list */
+	__u64 seg_start;		/* start blocknr of the segment */
+	__u64 next;			/* pointer to the next full segment */
+	__u64 segseq;			/* sequence number of the segment */
+	unsigned long segnum;		/* the number of the segment */
+	int npsegs;			/* number of partial segments */
+	int refcnt;
+};
+
+static struct nilfs_list segment_cache;
+
+static inline struct nilfs_segment_info *
+nilfs_segment_list_entry(struct nilfs_list *p)
+{
+	return (void *)p - offsetof(struct nilfs_segment_info, list);
+}
+
+struct nilfs_segment_info *new_segment_info(unsigned long segnum)
+{
+	struct nilfs_segment_info *seginfo;
+
+	seginfo = nilfs_zalloc(sizeof(*seginfo));
+	seginfo->segnum = segnum;
+	seginfo->seg_start = segment_start_blocknr(segnum);
+	seginfo->refcnt = 1;
+
+	nilfs_list_init(&seginfo->pseg_list);
+	nilfs_list_add(&segment_cache, &seginfo->list);
+	return seginfo;
+}
+
+void destroy_segment_info(struct nilfs_segment_info *seginfo)
+{
+	nilfs_list_del(&seginfo->list);
+	dispose_pseg_list(&seginfo->pseg_list);
+	free(seginfo);
+}
+
+static inline struct nilfs_segment_info *
+get_segment_info(struct nilfs_segment_info *seginfo)
+{
+	seginfo->refcnt++;
+	return seginfo;
+}
+
+static inline void put_segment_info(struct nilfs_segment_info *seginfo)
+{
+	assert(seginfo->refcnt > 0);
+	seginfo->refcnt--;
+}
+
+/*
+ * Segment cache
+ */
+void destroy_segment_cache(void)
+{
+	struct nilfs_list *p, *n;
+
+	for (p = segment_cache.next; n = p->next, p != &segment_cache; p = n) {
+		destroy_segment_info(nilfs_segment_list_entry(p));
+	}    
+}
+
+void shrink_segment_cache(void)
+{
+	struct nilfs_list *p, *n;
+	struct nilfs_segment_info *seginfo;
+
+	for (p = segment_cache.next; n = p->next, p != &segment_cache; p = n) {
+		seginfo = nilfs_segment_list_entry(p);
+		if (seginfo->refcnt == 0)
+			destroy_segment_info(seginfo);
+	}    
+}
+
+void init_segment_cache(void)
+{
+	nilfs_list_init(&segment_cache);
+	nilfs_shrink = shrink_segment_cache;
+	atexit(destroy_segment_cache);
+}
+
+struct nilfs_segment_info *lookup_segment(unsigned long segnum)
+{
+	struct nilfs_segment_info *seginfo;
+	struct nilfs_list *p;
+
+	for (p = segment_cache.next; p != &segment_cache; p = p->next) {
+		seginfo = nilfs_segment_list_entry(p);
+		if (seginfo->segnum == segnum) {
+			get_segment_info(seginfo);
+			return seginfo;
+		}
+	}
+	return NULL;
+}
+
+struct nilfs_segment_info *load_segment(int fd, unsigned long segnum)
+{
+	struct nilfs_segment_info *seginfo;
+	struct nilfs_pseg_info *pseginfo;
+	struct nilfs_segment_summary *ss;
+	__u64 blocknr, end;
+
+	seginfo = lookup_segment(segnum);
+	if (seginfo)
+		return seginfo;
+
+	seginfo = new_segment_info(segnum);
+	blocknr = seginfo->seg_start;
+
+	pseginfo = new_pseg_info(blocknr);
+	nilfs_list_add(&seginfo->pseg_list, &pseginfo->list);
+
+	ss = &pseginfo->segsum;
+	read_block(fd, blocknr, ss, sizeof(*ss));
+
+	if (!pseg_valid(fd, blocknr, ss)) {
+		put_segment_info(seginfo);
+		fprintf(stderr, "empty or bad segment: "
+			"segnum = %lu, blocknr = %llu\n", segnum,
+			(unsigned long long)segment_start_blocknr(segnum));
+		return NULL; /* no valid partial segment found */
+	}
+
+	seginfo->segseq = le64_to_cpu(ss->ss_seq);
+	seginfo->next = le64_to_cpu(ss->ss_next);
+
+	end = blocknr + blocks_per_segment;
+	do {
+		seginfo->npsegs++;
+
+		pseginfo->nblocks = le32_to_cpu(ss->ss_nblocks);
+		pseginfo->flags = le16_to_cpu(ss->ss_flags);
+
+		blocknr += pseginfo->nblocks;
+		if (blocknr >= end)
+			return seginfo;
+
+		pseginfo = new_pseg_info(blocknr);
+		nilfs_list_add(&seginfo->pseg_list, &pseginfo->list);
+
+		ss = &pseginfo->segsum;
+		read_block(fd, blocknr, ss, sizeof(*ss));
+
+	} while (pseg_valid(fd, blocknr, ss) &&
+		 le64_to_cpu(ss->ss_seq) == seginfo->segseq);
+
+	nilfs_list_del(&pseginfo->list);
+	free(pseginfo);
+
+	return seginfo;
+}
+
+/*
+ * Operations on segment_info structure
+ */
+struct nilfs_pseg_info *lookup_pseg(struct nilfs_segment_info *seginfo,
+				    __u64 blocknr)
+{
+	struct nilfs_pseg_info *pseginfo;
+	struct nilfs_list *p;
+
+	for (p = seginfo->pseg_list.next; p != &seginfo->pseg_list;
+	     p = p->next) {
+		pseginfo = nilfs_pseg_list_entry(p);
+		if (pseginfo->pseg_start == blocknr)
+			return pseginfo;
+	}
+	return NULL;
+}
+
+struct nilfs_pseg_info *first_pseg(struct nilfs_segment_info *seginfo)
+{
+	return nilfs_list_empty(&seginfo->pseg_list) ? NULL :
+		nilfs_pseg_list_entry(seginfo->pseg_list.next);
+}
+
+struct nilfs_pseg_info *last_pseg(struct nilfs_segment_info *seginfo)
+{
+	return nilfs_list_empty(&seginfo->pseg_list) ? NULL :
+		nilfs_pseg_list_entry(seginfo->pseg_list.prev);
+}
+
+struct nilfs_pseg_info *next_pseg(struct nilfs_segment_info *seginfo,
+				  struct nilfs_pseg_info *pseginfo)
+{
+	return pseginfo->list.next == &seginfo->pseg_list ? NULL :
+		nilfs_pseg_list_entry(pseginfo->list.next);
+}
+
+struct nilfs_pseg_info *prev_pseg(struct nilfs_segment_info *seginfo,
+				  struct nilfs_pseg_info *pseginfo)
+{
+	return pseginfo->list.prev == &seginfo->pseg_list ? NULL :
+		nilfs_pseg_list_entry(pseginfo->list.prev);
+}
+
+struct nilfs_pseg_info *
+lookup_last_super_root(struct nilfs_segment_info *seginfo)
+{
+	struct nilfs_pseg_info *pseginfo;
+
+	for (pseginfo = last_pseg(seginfo); pseginfo != NULL;
+	     pseginfo = prev_pseg(seginfo, pseginfo)) {
+		if (pseginfo->flags & NILFS_SS_SR)
+			return pseginfo;
+	}
+	return NULL;
+}
+
+unsigned long log_length(struct nilfs_segment_info *seginfo)
+{
+	return nilfs_list_empty(&seginfo->pseg_list) ? 0 :
+		nilfs_pseg_list_entry(seginfo->pseg_list.prev)->pseg_start -
+		seginfo->seg_start +
+		nilfs_pseg_list_entry(seginfo->pseg_list.prev)->nblocks;
+}
+
+/*
+ * Routines to get latest checkpoint number
+ */
+static __u64 find_latest_checkpoint(int fd, __u64 cpblocknr, __u64 blkoff)
+{
+	struct nilfs_checkpoint *cp;
+	int i, ncp;
+	__u64 cno = 0;
+
+	read_block(fd, cpblocknr, block_buffer, blocksize);
+	if (blkoff == 0) {
+		cp = block_buffer + first_checkpoint_offset * checkpoint_size;
+		ncp = ncheckpoints_per_block - first_checkpoint_offset;
+	} else {
+		cp = block_buffer;
+		ncp = ncheckpoints_per_block;
+	}
+	
+	for (i = 0; i < ncp; i++, cp = (void *)cp + checkpoint_size) {
+		if (!nilfs_checkpoint_invalid(cp) &&
+		    le64_to_cpu(cp->cp_cno) > cno)
+			cno = le64_to_cpu(cp->cp_cno);
+	}
+	return cno;
+}
+
+static void *next_ss_entry(int fd, __u64 *blocknrp,
+			   unsigned *offsetp, unsigned entry_size)
+{
+	void *p;
+
+	if (*offsetp + entry_size > blocksize) {
+		(*blocknrp)++;
+		read_block(fd, *blocknrp, block_buffer, blocksize);
+		*offsetp = 0;
+	}
+	p = block_buffer + *offsetp;
+	(*offsetp) += entry_size;
+	return p;
+}
+
+static __u64 get_latest_cno(int fd, __u64 pseg_start)
+{
+	struct nilfs_segment_summary *ss;
+	struct nilfs_finfo *finfo;
+	__u32 nfinfo;
+	__u32 nblocks, ndatablk, nnodeblk;
+	__u64 ino;
+	__u64 latest_cno = 0, cno;
+	__u64 blocknr = pseg_start, fblocknr;
+	unsigned offset;
+	int i, j;
+
+	read_block(fd, blocknr, block_buffer, blocksize);
+	ss = block_buffer;
+	nfinfo = le32_to_cpu(ss->ss_nfinfo);
+	offset = le16_to_cpu(ss->ss_bytes);
+	fblocknr = blocknr + DIV_ROUND_UP(le32_to_cpu(ss->ss_sumbytes),
+					  blocksize);
+
+	for (i = 0; i < nfinfo; i++) {
+		finfo = next_ss_entry(fd, &blocknr, &offset, sizeof(*finfo));
+	
+		nblocks = le32_to_cpu(finfo->fi_nblocks);
+		ndatablk = le32_to_cpu(finfo->fi_ndatablk);
+		nnodeblk = nblocks - ndatablk;
+		ino = le64_to_cpu(finfo->fi_ino);
+
+		if (ino == NILFS_DAT_INO) {
+			__le64 *blkoff;
+			struct nilfs_binfo_dat *binfo_dat;
+
+			for (j = 0; j < ndatablk; j++, fblocknr++) {
+				blkoff = next_ss_entry(fd, &blocknr,
+						       &offset,
+						       sizeof(*blkoff));
+			}
+			for (j = 0; j < nnodeblk; j++, fblocknr++) {
+				binfo_dat = next_ss_entry(fd, &blocknr,
+							  &offset,
+							  sizeof(*binfo_dat));
+			}
+		} else {
+			struct nilfs_binfo_v *binfo_v;
+			__le64 *vblocknr;
+
+			for (j = 0; j < ndatablk; j++, fblocknr++) {
+				binfo_v = next_ss_entry(fd, &blocknr,
+							&offset,
+							sizeof(*binfo_v));
+			}
+			if (ino == NILFS_CPFILE_INO && ndatablk > 0) {
+				cno = find_latest_checkpoint(
+					fd, fblocknr - 1,
+					le64_to_cpu(binfo_v->bi_blkoff));
+				if (cno > latest_cno)
+					latest_cno = cno;
+			}
+			for (j = 0; j < nnodeblk; j++, fblocknr++) {
+				vblocknr = next_ss_entry(fd, &blocknr,
+							 &offset,
+							 sizeof(*vblocknr));
+			}
+		}
+	}
+
+	return latest_cno;
+}
+
+__u64 find_latest_cno_in_logical_segment(int fd,
+					 struct nilfs_segment_info *seginfo,
+					 struct nilfs_pseg_info *start)
+{
+	struct nilfs_pseg_info *pseginfo = start ? : last_pseg(seginfo);
+	__u64 cno, latest_cno = 0;
+	__u64 seq;
+	int i = 0;
+
+	if (pseginfo == NULL)
+		return 0;
+
+	get_segment_info(seginfo);
+	do {
+		cno = get_latest_cno(fd, pseginfo->pseg_start);
+		if (cno > latest_cno)
+			latest_cno = cno;
+		
+		if (pseginfo->flags & NILFS_SS_LOGBGN)
+			break;
+
+		pseginfo = prev_pseg(seginfo, pseginfo);
+		if (pseginfo == NULL) {
+			unsigned long segnum = seginfo->segnum;
+
+			if (++i > MAX_SCAN_SEGMENT)
+				break;
+			segnum = (segnum == 0) ? nsegments - 1 : segnum - 1;
+			seq = seginfo->segseq;
+
+			put_segment_info(seginfo);
+			seginfo = load_segment(fd, segnum);
+
+			if (!seginfo || seginfo->segseq != seq - 1)
+				break;
+			pseginfo = last_pseg(seginfo);
+		}
+	} while (pseginfo != NULL && !(pseginfo->flags & NILFS_SS_LOGEND));
+
+	if (seginfo)
+		put_segment_info(seginfo);
+	return latest_cno;
+}
+
+void print_pseg_message(struct nilfs_pseg_ref *pseg_ref, const char *fmt, ...)
+{
+	const char *cp;
+	va_list args;
+
+	va_start(args, fmt);
+	vfprintf(stderr, fmt, args);
+	fprintf(stderr, ": blocknr = %llu\n",
+		(unsigned long long)pseg_ref->blocknr);
+
+	for (cp = fmt; *cp == ' '; cp++)
+		fputc(' ', stderr);
+	fprintf(stderr, "    segnum = %lu, seq = %llu, cno=%llu\n",
+		(unsigned long)pseg_ref->blocknr / blocks_per_segment,
+		(unsigned long long)pseg_ref->seqnum,
+		(unsigned long long)pseg_ref->cno);
+	if (pseg_ref->ctime) {
+		char tmbuf[LINE_BUFFER_SIZE];
+		struct tm tm;
+		time_t t = (time_t)le64_to_cpu(pseg_ref->ctime);
+
+		localtime_r(&t, &tm);
+		strftime(tmbuf, LINE_BUFFER_SIZE, "%F %T", &tm);
+		for (cp = fmt; *cp == ' '; cp++)
+			fputc(' ', stderr);
+		fprintf(stderr, "    creation time = %s\n", tmbuf);
+	}
+	va_end(args);
+}
+
+struct nilfs_pseg_info *
+find_latest_super_root(int fd, unsigned long segnum, __u64 blocknr,
+		       struct nilfs_segment_info **seginfop)
+{
+	struct nilfs_segment_info *seginfo;
+	struct nilfs_segment_info *seginfo_sr = NULL;
+		/* seginfo which has the last super root */
+	struct nilfs_pseg_info *pseg_sr = NULL;
+	int cont = 0, invert = 0;
+	int i;
+
+	seginfo = load_segment(fd, segnum);
+	if (seginfo) {
+		pseg_sr = lookup_last_super_root(seginfo);
+		if (pseg_sr)
+			seginfo_sr = get_segment_info(seginfo);
+
+		if (blocknr < seginfo->seg_start + log_length(seginfo))
+			cont = 1;
+	}
+
+	for (i = 0; i < MAX_SCAN_SEGMENT; i++) {
+		struct nilfs_segment_info *seginfo2;
+
+		/*
+		 * Look into the previous segment.
+		 *
+		 * This code depends on the current GC policy; discontinuously
+		 * allocated segments are not supported.
+		 */
+		if (!(i & SCAN_SEGMENT_MASK))
+			fputc('.', stderr);
+		segnum = (segnum == 0) ? nsegments - 1 : segnum - 1;
+
+		seginfo2 = load_segment(fd, segnum);
+		if (!seginfo2) {
+			if (pseg_sr && cont) {
+				pseg_sr = NULL;
+				put_segment_info(seginfo_sr);
+				seginfo_sr = NULL;
+			}
+			cont = 0;
+			if (seginfo) {
+				put_segment_info(seginfo);
+				seginfo = NULL;
+			}
+			continue;
+		}
+
+		if (!seginfo) {
+			seginfo = seginfo2;
+			seginfo2 = NULL;
+
+			if (pseg_sr)
+				put_segment_info(seginfo_sr);
+			pseg_sr = lookup_last_super_root(seginfo);
+			if (pseg_sr)
+				seginfo_sr = get_segment_info(seginfo);
+			continue;
+		}
+
+		if (seginfo2->segseq + 1 != seginfo->segseq)
+			cont = 0;
+
+		if (seginfo2->segseq > seginfo->segseq) {
+			invert++;
+			if (pseg_sr) {
+				pseg_sr = NULL;
+				put_segment_info(seginfo_sr);
+				seginfo_sr = NULL;
+			}
+		}
+		if (invert && !pseg_sr) {
+			pseg_sr = lookup_last_super_root(seginfo2);
+			if (pseg_sr) {
+				put_segment_info(seginfo);
+				*seginfop = seginfo2;
+				fputc('\n', stderr);
+				return pseg_sr; /* latest segment was found */
+			}
+		}
+
+		if (!cont && !pseg_sr) {
+			pseg_sr = lookup_last_super_root(seginfo2);
+			if (pseg_sr)
+				seginfo_sr = get_segment_info(seginfo2);
+		}
+
+		put_segment_info(seginfo);
+		seginfo = seginfo2;
+		seginfo2 = NULL;
+	}
+	fputc('\n', stderr);
+	if (seginfo)
+		put_segment_info(seginfo);
+
+	if (pseg_sr && !cont) {
+		*seginfop = seginfo_sr;
+		return pseg_sr; /* regard second-ranking candidate
+				   as the latest segment */
+	}
+	if (seginfo_sr)
+		put_segment_info(seginfo_sr);
+	return NULL;
+}
+
+static void check_mount(int fd, const char *device)
+{
+	FILE *fp;
+	char line[LINE_BUFFER_SIZE];
+
+	fp = fopen(MOUNTS, "r");
+	if (fp == NULL)
+		die("cannot open %s!", MOUNTS);
+
+	while (fgets(line, LINE_BUFFER_SIZE, fp) != NULL) {
+		if (strncmp(strtok(line, " "), device, strlen(device)) == 0) {
+			fclose(fp);
+			die("%s is currently mounted.", device);
+		}
+	}
+	fclose(fp);
+}
+
+static void check_super_block(struct nilfs_super_block *sb)
+{
+	char tmbuf[LINE_BUFFER_SIZE];
+	struct tm tm;
+	time_t t;
+	__u32 sbsum, crc;
+	int sb_bytes = le16_to_cpu(sb->s_bytes);
+
+	if (le16_to_cpu(sb->s_magic) != NILFS_SUPER_MAGIC)
+		die("Not nilfs2 partition");
+
+	fprintf(stderr, "Super-block:\n");
+
+	crc_seed = le32_to_cpu(sb->s_crc_seed);
+	sbsum = le32_to_cpu(sb->s_sum);
+
+	sb->s_sum = 0;
+	crc = nilfs_crc32(crc_seed, (unsigned char *)sb, sb_bytes);
+	sb->s_sum = cpu_to_le32(sb->s_sum);
+
+	fprintf(stderr, "    revision = %d.%d, checksum = %s\n",
+		le32_to_cpu(sb->s_rev_level),
+		le16_to_cpu(sb->s_minor_rev_level),
+		crc == sbsum ? "OK" : "error");
+
+	blocksize = 1 << (le32_to_cpu(sb->s_log_block_size) + 10);
+	blocks_per_segment = le32_to_cpu(sb->s_blocks_per_segment);
+	first_data_block = le64_to_cpu(sb->s_first_data_block);
+	nsegments = le64_to_cpu(sb->s_nsegments);
+	checkpoint_size = le16_to_cpu(sb->s_checkpoint_size);
+
+	first_checkpoint_offset =
+		DIV_ROUND_UP(sizeof(struct nilfs_cpfile_header),
+			     checkpoint_size);
+	ncheckpoints_per_block = blocksize / checkpoint_size;
+
+	t = (time_t)le64_to_cpu(sb->s_wtime);
+	localtime_r(&t, &tm);
+	strftime(tmbuf, LINE_BUFFER_SIZE, "%F %T", &tm);
+
+	fprintf(stderr, "    blocksize = %d\n", blocksize);
+	fprintf(stderr, "    write time = %s\n", tmbuf);
+}
+
+static void commit_super_block(struct nilfs_super_block *sb,
+			       struct nilfs_pseg_ref *pseg_ref)
+{
+	__u32 sbsum;
+	int sb_bytes = le16_to_cpu(sb->s_bytes);
+
+	sb->s_last_pseg = cpu_to_le64(pseg_ref->blocknr);
+	sb->s_last_seq = cpu_to_le64(pseg_ref->seqnum);
+	sb->s_last_cno = cpu_to_le64(pseg_ref->cno);
+
+	sb->s_state = cpu_to_le16(le16_to_cpu(sb->s_state) & ~NILFS_VALID_FS);
+
+	/* fill in crc */
+	sb->s_sum = 0;
+	sbsum = nilfs_crc32(crc_seed, (unsigned char *)sb, sb_bytes);
+	sb->s_sum = cpu_to_le32(sbsum);
+}
+
+static int nilfs_do_recovery(int fd, struct nilfs_pseg_ref *pseg_ref)
+{
+	struct nilfs_pseg_info *pseginfo;
+	struct nilfs_segment_info *seginfo;
+	unsigned long segnum;
+	int ret = 0;
+
+	init_block_buffer();
+	init_segment_cache();
+
+	/*
+	 * check the partial segment pointed by superblock.
+	 */
+	segnum = pseg_ref->blocknr / blocks_per_segment;
+	seginfo = load_segment(fd, segnum);
+	if (seginfo) {
+		pseginfo = lookup_pseg(seginfo, pseg_ref->blocknr);
+		if (pseginfo &&
+		    seginfo->segseq == pseg_ref->seqnum &&
+		    pseginfo->flags & NILFS_SS_SR) {
+			pseg_ref->ctime = le64_to_cpu(pseginfo->segsum.ss_create);
+
+			print_pseg_message(pseg_ref,
+					   "Valid segment is pointed by "
+					   "superblock (No change needed)");
+			goto out;
+		}
+		put_segment_info(seginfo);
+	}
+
+	/*
+	 * check logs in the current and prior full segments.
+	 */
+	fprintf(stderr, "The latest segment is lost. "
+		"Trying rollback recovery..\n");
+
+	pseginfo = find_latest_super_root(fd, segnum, pseg_ref->blocknr,
+					  &seginfo);
+	if (!pseginfo)
+		die("Cannot find super root");
+
+	pseg_ref->blocknr = pseginfo->pseg_start;
+	pseg_ref->seqnum = seginfo->segseq;
+	pseg_ref->ctime = le64_to_cpu(pseginfo->segsum.ss_create);
+	
+	fprintf(stderr, "Searching the latest checkpoint.\n");
+	pseg_ref->cno = find_latest_cno_in_logical_segment(
+		fd, seginfo, pseginfo);
+	if (pseg_ref->cno == 0)
+		die("Cannot identify the latest checkpoint");
+
+	print_pseg_message(pseg_ref, "Selected segment");
+	ret = 1;
+ out:
+	destroy_segment_cache();
+	destroy_block_buffer();
+	return ret;
+}
+
+static void nilfs_fsck(const char *device)
+{
+	struct nilfs_super_block sb;
+	struct nilfs_pseg_ref pseg_ref;
+	ssize_t size;
+	int c;
+
+	if ((devfd = open(device, O_RDONLY | O_LARGEFILE)) < 0)
+		die("cannot open device %s", device);
+
+	size = pread(devfd, &sb, sizeof(sb), NILFS_SB_OFFSET_BYTES);
+	if (size < sizeof(sb))
+		die("cannot read super block (device=%s)", device);
+
+	check_mount(devfd, device);
+	check_super_block(&sb);
+
+	pseg_ref.blocknr = le64_to_cpu(sb.s_last_pseg);
+	pseg_ref.seqnum = le64_to_cpu(sb.s_last_seq);
+	pseg_ref.cno = le64_to_cpu(sb.s_last_cno);
+	pseg_ref.ctime = 0;
+	print_pseg_message(&pseg_ref, "    indicated partial segment");
+	fputc('\n', stderr);
+
+	if (le16_to_cpu(sb.s_state) & NILFS_VALID_FS) {
+		fprintf(stderr, "Clean FS.\n");
+		goto out_clean;
+	}
+
+	if (nilfs_do_recovery(devfd, &pseg_ref) == 0)
+		goto out;
+
+	/*
+	 * Reopen device to update superblock
+	 */
+	close(devfd);
+	devfd = -1;
+	if ((devfd = open(device, O_RDWR | O_LARGEFILE)) < 0)
+		die("cannot open device %s in read/write mode",
+		    device);
+
+	fprintf(stderr, "Do you wish to overwrite super block (y/N)? ");
+	if ((c = getchar()) == 'y') {
+		commit_super_block(&sb, &pseg_ref);
+		size = pwrite(devfd, &sb, sizeof(sb), NILFS_SB_OFFSET_BYTES);
+		if (size < sizeof(sb))
+			die("cannot write out super block (device=%s)", device);
+		fsync(devfd);
+	}
+ out:
+	fprintf(stderr, "Recovery will complete on mount.\n");
+
+ out_clean:
+	close(devfd);
+}
+
+int main(int argc, char *argv[])
+{
+	char *device;
+
+	if ((progname = strrchr(argv[0], '/')) != NULL)
+		progname++;
+	else
+		progname = argv[0];
+
+	if (argc < 2) {
+		fprintf(stderr, "Usage: %s <device>\n", progname);
+		exit(0);
+	}
+	
+	device = argv[1];
+	nilfs_fsck(device);
+
+	return 0;
+}
-- 
1.5.6.5
