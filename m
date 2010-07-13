From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/5] nilfs2: remove redundant pointer checks in bmap lookup functions
Date: Tue, 13 Jul 2010 23:33:51 +0900
Message-ID: <1279031635-6717-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1279031635-6717-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1279031635-6717-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

nilfs_bmap_lookup and its variants are supposed to take a valid
pointer argument to return a block address, thus pointer checks in
nilfs_btree_lookup and nilfs_direct_lookup are needless.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/btree.c  |    6 +-----
 fs/nilfs2/direct.c |    3 +--
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index c81893a..c05586a 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -554,17 +554,13 @@ static int nilfs_btree_lookup(const struct nilfs_bmap *btree,
 			      __u64 key, int level, __u64 *ptrp)
 {
 	struct nilfs_btree_path *path;
-	__u64 ptr;
 	int ret;
 
 	path = nilfs_btree_alloc_path();
 	if (path == NULL)
 		return -ENOMEM;
 
-	ret = nilfs_btree_do_lookup(btree, path, key, &ptr, level);
-
-	if (ptrp != NULL)
-		*ptrp = ptr;
+	ret = nilfs_btree_do_lookup(btree, path, key, ptrp, level);
 
 	nilfs_btree_free_path(path);
 
diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
index 3186130..324d80c 100644
--- a/fs/nilfs2/direct.c
+++ b/fs/nilfs2/direct.c
@@ -56,8 +56,7 @@ static int nilfs_direct_lookup(const struct nilfs_bmap *direct,
 	if (ptr == NILFS_BMAP_INVALID_PTR)
 		return -ENOENT;
 
-	if (ptrp != NULL)
-		*ptrp = ptr;
+	*ptrp = ptr;
 	return 0;
 }
 
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
