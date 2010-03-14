From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/6] nilfs2: fix function name typos in docbook comments
Date: Sun, 14 Mar 2010 11:28:35 +0900
Message-ID: <1268533719-19454-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1268533719-19454-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1268533719-19454-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Fixes the following typos in docbook comments:

 nilfs_detroy_transaction_cache -> nilfs_destroy_transaction_cache
 nilfs_secgtor_start_timer -> nilfs_segctor_start_timer

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/segment.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index ada2f1b..3265bfc 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -141,7 +141,7 @@ int nilfs_init_transaction_cache(void)
 }
 
 /**
- * nilfs_detroy_transaction_cache - destroy the cache for transaction info
+ * nilfs_destroy_transaction_cache - destroy the cache for transaction info
  *
  * nilfs_destroy_transaction_cache() frees the slab cache for the struct
  * nilfs_transaction_info.
@@ -2214,7 +2214,7 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
 }
 
 /**
- * nilfs_secgtor_start_timer - set timer of background write
+ * nilfs_segctor_start_timer - set timer of background write
  * @sci: nilfs_sc_info
  *
  * If the timer has already been set, it ignores the new request.
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
