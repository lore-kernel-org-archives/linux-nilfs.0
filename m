From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: add sanity check in nilfs_btree_add_dirty_buffer
Date: Thu,  8 Jul 2010 11:56:26 +0900
Message-ID: <1278557786-26804-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

According to the report titled "problem with nilfs_cleanerd" from
=C5=81ukasz W=C3=B3jcicki, nilfs_btree_lookup_dirty_buffers or
nilfs_btree_add_dirty_buffer got memory violation during garbage
collection.

This could happen if a level field of given btree node buffer is
incorrect, which is a crucial internal bug.

This inserts a sanity check to figure out the problem.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/btree.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index b27a342..3863567 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -1920,6 +1920,18 @@ static void nilfs_btree_add_dirty_buffer(struct =
nilfs_btree *btree,
 	node =3D (struct nilfs_btree_node *)bh->b_data;
 	key =3D nilfs_btree_node_get_key(node, 0);
 	level =3D nilfs_btree_node_get_level(node);
+	if (level < NILFS_BTREE_LEVEL_NODE_MIN ||
+	    level >=3D NILFS_BTREE_LEVEL_MAX) {
+		dump_stack();
+		printk(KERN_WARNING
+		       "%s: invalid btree level: %d (key=3D%llu, ino=3D%lu, "
+		       "blocknr=3D%llu)\n",
+		       __func__, level, (unsigned long long)key,
+		       NILFS_BMAP_I(&btree->bt_bmap)->vfs_inode.i_ino,
+		       (unsigned long long)bh->b_blocknr);
+		return;
+	}
+
 	list_for_each(head, &lists[level]) {
 		cbh =3D list_entry(head, struct buffer_head, b_assoc_buffers);
 		cnode =3D (struct nilfs_btree_node *)cbh->b_data;
--=20
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
