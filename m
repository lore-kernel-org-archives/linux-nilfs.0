From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/4] nilfs2: add read ahead mode to nilfs_btnode_submit_block
Date: Sun, 18 Jul 2010 10:42:23 +0900
Message-ID: <1279417346-9688-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1279417346-9688-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1279417346-9688-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This adds mode argument to nilfs_btnode_submit_block() function and
allows it to issue a read-ahead request.

An optional submit_ptr argument is also added to store the actual
block address for which bio is sent.  submit_ptr is used for a series
of read-ahead requests, and helps to decide if each requested block is
continous to the previous one on disk.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/btnode.c  |   17 ++++++++++++++---
 fs/nilfs2/btnode.h  |    4 ++--
 fs/nilfs2/btree.c   |    3 ++-
 fs/nilfs2/gcinode.c |    6 ++++--
 4 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index 0a6834b..f78ab10 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -96,7 +96,8 @@ nilfs_btnode_create_block(struct address_space *btnc, __u64 blocknr)
 }
 
 int nilfs_btnode_submit_block(struct address_space *btnc, __u64 blocknr,
-			      sector_t pblocknr, struct buffer_head **pbh)
+			      sector_t pblocknr, int mode,
+			      struct buffer_head **pbh, sector_t *submit_ptr)
 {
 	struct buffer_head *bh;
 	struct inode *inode = NILFS_BTNC_I(btnc);
@@ -127,7 +128,16 @@ int nilfs_btnode_submit_block(struct address_space *btnc, __u64 blocknr,
 			}
 		}
 	}
-	lock_buffer(bh);
+
+	if (mode == READA) {
+		if (pblocknr != *submit_ptr + 1 || !trylock_buffer(bh)) {
+			err = -EBUSY; /* internal code */
+			brelse(bh);
+			goto out_locked;
+		}
+	} else { /* mode == READ */
+		lock_buffer(bh);
+	}
 	if (buffer_uptodate(bh)) {
 		unlock_buffer(bh);
 		err = -EEXIST; /* internal code */
@@ -138,8 +148,9 @@ int nilfs_btnode_submit_block(struct address_space *btnc, __u64 blocknr,
 	bh->b_blocknr = pblocknr; /* set block address for read */
 	bh->b_end_io = end_buffer_read_sync;
 	get_bh(bh);
-	submit_bh(READ, bh);
+	submit_bh(mode, bh);
 	bh->b_blocknr = blocknr; /* set back to the given block address */
+	*submit_ptr = pblocknr;
 	err = 0;
 found:
 	*pbh = bh;
diff --git a/fs/nilfs2/btnode.h b/fs/nilfs2/btnode.h
index 07da83f..7903749 100644
--- a/fs/nilfs2/btnode.h
+++ b/fs/nilfs2/btnode.h
@@ -42,8 +42,8 @@ void nilfs_btnode_cache_init(struct address_space *, struct backing_dev_info *);
 void nilfs_btnode_cache_clear(struct address_space *);
 struct buffer_head *nilfs_btnode_create_block(struct address_space *btnc,
 					      __u64 blocknr);
-int nilfs_btnode_submit_block(struct address_space *, __u64, sector_t,
-			      struct buffer_head **);
+int nilfs_btnode_submit_block(struct address_space *, __u64, sector_t, int,
+			      struct buffer_head **, sector_t *);
 void nilfs_btnode_delete(struct buffer_head *);
 int nilfs_btnode_prepare_change_key(struct address_space *,
 				    struct nilfs_btnode_chkey_ctxt *);
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 6462c70..4669389 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -71,9 +71,10 @@ static int nilfs_btree_get_block(const struct nilfs_bmap *btree, __u64 ptr,
 {
 	struct address_space *btnc = &NILFS_BMAP_I(btree)->i_btnode_cache;
 	struct buffer_head *bh;
+	sector_t pbn = 0;
 	int err;
 
-	err = nilfs_btnode_submit_block(btnc, ptr, 0, bhp);
+	err = nilfs_btnode_submit_block(btnc, ptr, pbn, READ, bhp, &pbn);
 	if (err)
 		return err == -EEXIST ? 0 : err;
 
diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
index b634382..bed3a78 100644
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -151,8 +151,10 @@ int nilfs_gccache_submit_read_data(struct inode *inode, sector_t blkoff,
 int nilfs_gccache_submit_read_node(struct inode *inode, sector_t pbn,
 				   __u64 vbn, struct buffer_head **out_bh)
 {
-	int ret = nilfs_btnode_submit_block(&NILFS_I(inode)->i_btnode_cache,
-					    vbn ? : pbn, pbn, out_bh);
+	int ret;
+
+	ret = nilfs_btnode_submit_block(&NILFS_I(inode)->i_btnode_cache,
+					vbn ? : pbn, pbn, READ, out_bh, &pbn);
 	if (ret == -EEXIST) /* internal code (cache hit) */
 		ret = 0;
 	return ret;
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
