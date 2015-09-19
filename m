From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 1/7] nilfs2: drop null test before destroy functions
Date: Sat, 19 Sep 2015 19:32:56 +0900
Message-ID: <1442658782-3147-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1442658782-3147-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=KR1/jXvHxfA5JBEKWzKJ18Xm6atrPUxZws1vbZyiWzk=;
        b=rGl8zeRdomEp4CmuzlfLyeqSTLE4nj9IcdwneQ6ZcNOMk9qduW1NZEZ3n97iZ2n44w
         wx3i6BzY5EEDcAJXRJeblHBT/gX+/Wy88hNSUFMXNSWoj/ggc2TW2id9Jejre/k8Top+
         4BqZ20ta2pN5dtdZPLHcMRytTXvA6Md7OyqwfphsrL77J6YbFkNBVOyN6VnVoHMfjkIR
         qmtIsajTjXriPsOy9joDEMl9vLitmyaEZfVOP5/Id0PflbrbM+EXReprpNcIM7ev34oS
         Ks0Nym7UfZxuzZmGc+9hZedec+WYgD9Hu4Yi+WEEowsrzI7w43G4x11GZ/0MjczdMkQx
         3Tjg==
In-Reply-To: <1442658782-3147-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-nilfs <linux-nilfs@vger.kernel.org>, Julia Lawall <Julia.Lawall@lip6.fr>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

From: Julia Lawall <Julia.Lawall@lip6.fr>

Remove unneeded NULL test.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@ expression x; @@
-if (x != NULL)
  \(kmem_cache_destroy\|mempool_destroy\|dma_pool_destroy\)(x);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/super.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index f47585b..c69455a 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1405,14 +1405,10 @@ static void nilfs_destroy_cachep(void)
 	 */
 	rcu_barrier();
 
-	if (nilfs_inode_cachep)
-		kmem_cache_destroy(nilfs_inode_cachep);
-	if (nilfs_transaction_cachep)
-		kmem_cache_destroy(nilfs_transaction_cachep);
-	if (nilfs_segbuf_cachep)
-		kmem_cache_destroy(nilfs_segbuf_cachep);
-	if (nilfs_btree_path_cache)
-		kmem_cache_destroy(nilfs_btree_path_cache);
+	kmem_cache_destroy(nilfs_inode_cachep);
+	kmem_cache_destroy(nilfs_transaction_cachep);
+	kmem_cache_destroy(nilfs_segbuf_cachep);
+	kmem_cache_destroy(nilfs_btree_path_cache);
 }
 
 static int __init nilfs_init_cachep(void)
-- 
1.8.3.1
