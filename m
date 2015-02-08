From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: use bgl_lock_ptr()
Date: Mon,  9 Feb 2015 01:26:04 +0900
Message-ID: <1423412764-6848-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=DBo2LeutyA7nTf2SNQ2jxAkuurY5ctv3J9MXTF6fxOQ=;
        b=LdvGcr+hpF6MIvFnMTfox99kN+yTSLtKRUhRXJIYuQSSZLfPRrDhUN+K3qQi33+l9o
         4MFt6i9mzagdeUUzpm1qATjLvTtrrYxqCmqVgRUTTo9RMb+xWOokNsQZWrfjcVLZ6pwQ
         xUhn02EUomkQZxxKuCQT1YGH0GPfJGcjOZAW6ju8b1jJg3Qmyi9BkgnnsVtWfxk6+sid
         SAX5QkrHO4YzN2VoBnXSg2J/q3j7Dwu9KMrcVbMZfttAmmMKfcjgF6NBzC/uE6M13IEM
         PmCVXXNKQqpHiQ6bRMFvV7Bmhc7/CL4Nyw3jDCOvsF+GEXO2xcYZBtzSsxeZZhxaDHxN
         NwOg==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

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
