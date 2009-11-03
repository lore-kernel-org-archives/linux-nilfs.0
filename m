From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 3/3] nilfs2: get rid of BUG_ON use in btree
	lookup routines
Date: Tue,  3 Nov 2009 13:53:39 +0900
Message-ID: <1257224019-29261-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1257224019-29261-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1257224019-29261-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
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

The current btree lookup routines make a kernel oops when detected
inconsistency in btree blocks.  These routines should instead return a
proper error code because the inconsistency usually comes from
corruption of on-disk metadata.

This fixes the issue by converting BUG_ON calls to proper error
handlings.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/btree.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index e25b507..420c9ec 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -444,6 +444,18 @@ nilfs_btree_get_node(const struct nilfs_btree *btree,
 		nilfs_btree_get_nonroot_node(path, level);
 }
 
+static inline int
+nilfs_btree_bad_node(struct nilfs_btree_node *node, int level)
+{
+	if (unlikely(nilfs_btree_node_get_level(node) != level)) {
+		dump_stack();
+		printk(KERN_CRIT "NILFS: btree level mismatch: %d != %d\n",
+		       nilfs_btree_node_get_level(node), level);
+		return 1;
+	}
+	return 0;
+}
+
 static int nilfs_btree_do_lookup(const struct nilfs_btree *btree,
 				 struct nilfs_btree_path *path,
 				 __u64 key, __u64 *ptrp, int minlevel)
@@ -467,7 +479,8 @@ static int nilfs_btree_do_lookup(const struct nilfs_btree *btree,
 		if (ret < 0)
 			return ret;
 		node = nilfs_btree_get_nonroot_node(path, level);
-		BUG_ON(level != nilfs_btree_node_get_level(node));
+		if (nilfs_btree_bad_node(node, level))
+			return -EINVAL;
 		if (!found)
 			found = nilfs_btree_node_lookup(node, key, &index);
 		else
@@ -512,7 +525,8 @@ static int nilfs_btree_do_lookup_last(const struct nilfs_btree *btree,
 		if (ret < 0)
 			return ret;
 		node = nilfs_btree_get_nonroot_node(path, level);
-		BUG_ON(level != nilfs_btree_node_get_level(node));
+		if (nilfs_btree_bad_node(node, level))
+			return -EINVAL;
 		index = nilfs_btree_node_get_nchildren(node) - 1;
 		ptr = nilfs_btree_node_get_ptr(btree, node, index);
 		path[level].bp_index = index;
-- 
1.6.3.4
