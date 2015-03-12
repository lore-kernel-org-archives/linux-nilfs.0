From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 3/7] nilfs2: use bgl_lock_ptr()
Date: Thu, 12 Mar 2015 23:38:10 +0900
Message-ID: <1426171094-27414-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1426171094-27414-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=DBo2LeutyA7nTf2SNQ2jxAkuurY5ctv3J9MXTF6fxOQ=;
        b=EMsE8oSrfzMUzG/sWDMNDXIcrm/oiFtEity02PotX079BPZQ5Bi4qGJsYQwwsBwxcr
         2MXmXJ6VGS42TAct3Yn/q+V5STxYc3n7YbIoOwXO19EKVkMppzlGRya588XoFemU50jv
         wG+JcdLKg4FRn+6TOWoxsjJyCJtuUC+OBVPCKjGRNtY5P+c1mME0D+kNRUOgIrlkHJRt
         GTq38BNq0k3Q1Ll11nEGGs4Mo1B29xk8gk6M5pyYFWGOPQBu0i9HPJdTGn5wwWtsw9tq
         f96Z++uG78IbnIWUkbqzBlpqSBefOLPIXQVXKtgDENfVWNUdQ9GmuHWREGw2eL4JiIwA
         W3dg==
In-Reply-To: <1426171094-27414-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Simplify nilfs_mdt_bgl_lock() by utilizing bgl_lock_ptr() helper in
<linux/blockgroup_lock.h>.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/mdt.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/mdt.h b/fs/nilfs2/mdt.h
index ab172e8..a294ea3 100644
--- a/fs/nilfs2/mdt.h
+++ b/fs/nilfs2/mdt.h
@@ -111,7 +111,10 @@ static inline __u64 nilfs_mdt_cno(struct inode *inode)
 	return ((struct the_nilfs *)inode->i_sb->s_fs_info)->ns_cno;
 }
 
-#define nilfs_mdt_bgl_lock(inode, bg) \
-	(&NILFS_MDT(inode)->mi_bgl->locks[(bg) & (NR_BG_LOCKS-1)].lock)
+static inline spinlock_t *
+nilfs_mdt_bgl_lock(struct inode *inode, unsigned int block_group)
+{
+	return bgl_lock_ptr(NILFS_MDT(inode)->mi_bgl, block_group);
+}
 
 #endif /* _NILFS_MDT_H */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
