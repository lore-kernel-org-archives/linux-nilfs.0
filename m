From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 2/2] nilfs2: fix gcc uninitialized-variable warnings in powerpc build
Date: Mon, 12 Oct 2015 12:45:31 +0900
Message-ID: <1444621531-14142-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1444621531-14142-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=MenVXD3l4NiJsH7ik22d8aJ4WAnJfM9PtPWoaMbtdJc=;
        b=RQB9pKKrLVUQcF0w3BCkYlX4hIm+3r1oUaaBIuPPxZmLWq/4HDQ0VdRlt0dIYD8WxN
         MTrg9V+fFnoG1XkWX7lkrCjjnLakk4lA/7k5XgdUoEJlh3EfLWavsdeGg75c03d9+EaM
         3XzZ08JzsgQbhhavQZYe5E+Zs0OnCYsrt/KKfUnIoaG0k00zAyGB3r97yyUysOr5k7QW
         gtJaQBIV4+tw5ulYet8qBMkM04muI+K1s6/jHNG6qLwz+vTY7vpW603MPsrtFIPE3fUe
         nCV9J3Ag8ktNM+w7ejZ2e4aq12UoUaUq+qGO5hi0kuqaWXAlb3yRrIb3v/xES9l5Dyr/
         riiA==
In-Reply-To: <1444621531-14142-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

Some false positive warnings are reported for powerpc build.

The following warnings are reported in
 http://kisskb.ellerman.id.au/kisskb/buildresult/12519703/

   CC      fs/nilfs2/super.o
 fs/nilfs2/super.c: In function 'nilfs_resize_fs':
 fs/nilfs2/super.c:376:2: warning: 'blocknr' may be used uninitialized in this function [-Wuninitialized]
 fs/nilfs2/super.c:362:11: note: 'blocknr' was declared here
   CC      fs/nilfs2/recovery.o
 fs/nilfs2/recovery.c: In function 'nilfs_salvage_orphan_logs':
 fs/nilfs2/recovery.c:631:21: warning: 'sum' may be used uninitialized in this function [-Wuninitialized]
 fs/nilfs2/recovery.c:585:32: note: 'sum' was declared here
 fs/nilfs2/recovery.c: In function 'nilfs_search_super_root':
 fs/nilfs2/recovery.c:873:11: warning: 'sum' may be used uninitialized in this function [-Wuninitialized]

Another similar warning is reported in
 http://kisskb.ellerman.id.au/kisskb/buildresult/12520079/

   CC      fs/nilfs2/btree.o
 fs/nilfs2/btree.c: In function 'nilfs_btree_convert_and_insert':
 include/asm-generic/bitops/non-atomic.h:105:20: warning: 'bh' may be used uninitialized in this function [-Wuninitialized]
 fs/nilfs2/btree.c:1859:22: note: 'bh' was declared here

This cleans out these warnings by forcing the variables to be initialized.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 fs/nilfs2/btree.c    | 2 +-
 fs/nilfs2/recovery.c | 4 ++--
 fs/nilfs2/super.c    | 5 ++++-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index f609a85..3a3821b 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -1851,7 +1851,7 @@ int nilfs_btree_convert_and_insert(struct nilfs_bmap *btree,
 				   __u64 key, __u64 ptr,
 				   const __u64 *keys, const __u64 *ptrs, int n)
 {
-	struct buffer_head *bh;
+	struct buffer_head *bh = NULL;
 	union nilfs_bmap_ptr_req dreq, nreq, *di, *ni;
 	struct nilfs_bmap_stats stats;
 	int ret;
diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index ff00a0b..9b4f205 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -582,7 +582,7 @@ static int nilfs_do_roll_forward(struct the_nilfs *nilfs,
 				 struct nilfs_recovery_info *ri)
 {
 	struct buffer_head *bh_sum = NULL;
-	struct nilfs_segment_summary *sum;
+	struct nilfs_segment_summary *sum = NULL;
 	sector_t pseg_start;
 	sector_t seg_start, seg_end;  /* Starting/ending DBN of full segment */
 	unsigned long nsalvaged_blocks = 0;
@@ -814,7 +814,7 @@ int nilfs_search_super_root(struct the_nilfs *nilfs,
 			    struct nilfs_recovery_info *ri)
 {
 	struct buffer_head *bh_sum = NULL;
-	struct nilfs_segment_summary *sum;
+	struct nilfs_segment_summary *sum = NULL;
 	sector_t pseg_start, pseg_end, sr_pseg_start = 0;
 	sector_t seg_start, seg_end; /* range of full segment (block number) */
 	sector_t b, end;
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index f47585b..c6b5008 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -361,7 +361,7 @@ static int nilfs_move_2nd_super(struct super_block *sb, loff_t sb2off)
 	struct nilfs_super_block *nsbp;
 	sector_t blocknr, newblocknr;
 	unsigned long offset;
-	int sb2i = -1;  /* array index of the secondary superblock */
+	int sb2i;  /* array index of the secondary superblock */
 	int ret = 0;
 
 	/* nilfs->ns_sem must be locked by the caller. */
@@ -372,6 +372,9 @@ static int nilfs_move_2nd_super(struct super_block *sb, loff_t sb2off)
 	} else if (nilfs->ns_sbh[0]->b_blocknr > nilfs->ns_first_data_block) {
 		sb2i = 0;
 		blocknr = nilfs->ns_sbh[0]->b_blocknr;
+	} else {
+		sb2i = -1;
+		blocknr = 0;
 	}
 	if (sb2i >= 0 && (u64)blocknr << nilfs->ns_blocksize_bits == sb2off)
 		goto out;  /* super block location is unchanged */
-- 
1.8.3.1
