From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 15/23] nilfs2: add routines to save and restore bmap state
Date: Tue, 14 Sep 2010 00:37:16 +0900
Message-ID: <1284392244-27100-16-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1284392244-27100-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1284392244-27100-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

This adds routines to save and restore the state of bmap structure.
The bmap state is stored in a given nilfs_bmap_store object.

These routines will be used to roll back the state of dat inode
without using gcdat inode.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/bmap.c |   18 ++++++++++++++++++
 fs/nilfs2/bmap.h |    8 ++++++++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
index 3dbdc1d..0024440 100644
--- a/fs/nilfs2/bmap.c
+++ b/fs/nilfs2/bmap.c
@@ -548,3 +548,21 @@ void nilfs_bmap_commit_gcdat(struct nilfs_bmap *gcbmap, struct nilfs_bmap *bmap)
 	lockdep_set_class(&bmap->b_sem, &nilfs_bmap_dat_lock_key);
 	bmap->b_inode = &NILFS_BMAP_I(bmap)->vfs_inode;
 }
+
+void nilfs_bmap_save(const struct nilfs_bmap *bmap,
+		     struct nilfs_bmap_store *store)
+{
+	memcpy(store->data, bmap->b_u.u_data, sizeof(store->data));
+	store->last_allocated_key = bmap->b_last_allocated_key;
+	store->last_allocated_ptr = bmap->b_last_allocated_ptr;
+	store->state = bmap->b_state;
+}
+
+void nilfs_bmap_restore(struct nilfs_bmap *bmap,
+			const struct nilfs_bmap_store *store)
+{
+	memcpy(bmap->b_u.u_data, store->data, sizeof(store->data));
+	bmap->b_last_allocated_key = store->last_allocated_key;
+	bmap->b_last_allocated_ptr = store->last_allocated_ptr;
+	bmap->b_state = store->state;
+}
diff --git a/fs/nilfs2/bmap.h b/fs/nilfs2/bmap.h
index a20569b..5f3339e 100644
--- a/fs/nilfs2/bmap.h
+++ b/fs/nilfs2/bmap.h
@@ -135,6 +135,12 @@ struct nilfs_bmap {
 /* state */
 #define NILFS_BMAP_DIRTY	0x00000001
 
+struct nilfs_bmap_store {
+	__le64 data[NILFS_BMAP_SIZE / sizeof(__le64)];
+	__u64 last_allocated_key;
+	__u64 last_allocated_ptr;
+	int state;
+};
 
 int nilfs_bmap_test_and_clear_dirty(struct nilfs_bmap *);
 int nilfs_bmap_read(struct nilfs_bmap *, struct nilfs_inode *);
@@ -156,6 +162,8 @@ void nilfs_bmap_init_gc(struct nilfs_bmap *);
 void nilfs_bmap_init_gcdat(struct nilfs_bmap *, struct nilfs_bmap *);
 void nilfs_bmap_commit_gcdat(struct nilfs_bmap *, struct nilfs_bmap *);
 
+void nilfs_bmap_save(const struct nilfs_bmap *, struct nilfs_bmap_store *);
+void nilfs_bmap_restore(struct nilfs_bmap *, const struct nilfs_bmap_store *);
 
 static inline int nilfs_bmap_lookup(struct nilfs_bmap *bmap, __u64 key,
 				    __u64 *ptr)
-- 
1.6.6.2

