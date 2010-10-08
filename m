From: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Subject: [PATCH 1/2] nilfs2: eliminate sparse warnings - "symbol not declared"
Date: Fri,  8 Oct 2010 22:37:27 +0900
Message-ID: <1286545048-21582-2-git-send-email-jir@unicus.jp>
References: <1286545048-21582-1-git-send-email-jir@unicus.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1286545048-21582-1-git-send-email-jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, ryusuke-sG5X7nlA6pw@public.gmane.org, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

change nilfs_dat_commit_free and nilfs_inode_cachep static
to fix following warnings

fs/nilfs2/super.c:72:19: warning: symbol 'nilfs_inode_cachep' was not declared. Should it be static?
fs/nilfs2/dat.c:106:6: warning: symbol 'nilfs_dat_commit_free' was not declared. Should it be static?

Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
---
 fs/nilfs2/dat.c   |    3 ++-
 fs/nilfs2/super.c |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index ab04a68..49c844d 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -103,7 +103,8 @@ void nilfs_dat_abort_alloc(struct inode *dat, struct nilfs_palloc_req *req)
 	nilfs_palloc_abort_alloc_entry(dat, req);
 }
 
-void nilfs_dat_commit_free(struct inode *dat, struct nilfs_palloc_req *req)
+static void nilfs_dat_commit_free(struct inode *dat,
+				  struct nilfs_palloc_req *req)
 {
 	struct nilfs_dat_entry *entry;
 	void *kaddr;
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 027c7e8..1d506a5 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -69,7 +69,7 @@ MODULE_DESCRIPTION("A New Implementation of the Log-structured Filesystem "
 		   "(NILFS)");
 MODULE_LICENSE("GPL");
 
-struct kmem_cache *nilfs_inode_cachep;
+static struct kmem_cache *nilfs_inode_cachep;
 struct kmem_cache *nilfs_transaction_cachep;
 struct kmem_cache *nilfs_segbuf_cachep;
 struct kmem_cache *nilfs_btree_path_cache;
-- 
1.5.6.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
