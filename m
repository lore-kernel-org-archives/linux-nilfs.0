From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/3] nilfs2: add missing error code in comment of nilfs_search_super_root
Date: Fri, 25 Jun 2010 01:38:38 +0900
Message-ID: <1277397519-6715-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1277397519-6715-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1277397519-6715-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

nilfs_search_super_root can return -ENOMEM, but this error code is not
described in its kernel-doc comment.  This fixes the discrepancy.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/recovery.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index f5d9c3f..83e3d8c 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -804,6 +804,8 @@ int nilfs_salvage_orphan_logs(struct the_nilfs *nilfs,
  * %-EINVAL - No valid segment found
  *
  * %-EIO - I/O error
+ *
+ * %-ENOMEM - Insufficient memory available.
  */
 int nilfs_search_super_root(struct the_nilfs *nilfs,
 			    struct nilfs_recovery_info *ri)
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
