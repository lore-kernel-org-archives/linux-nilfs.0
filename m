From: Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org>
Subject: [PATCH 06/26] nilfs2: remove unnecessary dentry_unhash from rmdir, dir rename
Date: Fri, 27 May 2011 13:41:59 -0700
Message-ID: <1306528939-30636-7-git-send-email-sage@newdream.net>
References: <1306528939-30636-1-git-send-email-sage@newdream.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1306528939-30636-1-git-send-email-sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org>, KONISHI Ryusuke <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

nilfs2 does not have problems with references to unlinked directories.

CC: KONISHI Ryusuke <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
CC: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org>
---
 fs/nilfs2/namei.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 1102a5f..546849b 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -334,8 +334,6 @@ static int nilfs_rmdir(struct inode *dir, struct dentry *dentry)
 	struct nilfs_transaction_info ti;
 	int err;
 
-	dentry_unhash(dentry);
-
 	err = nilfs_transaction_begin(dir->i_sb, &ti, 0);
 	if (err)
 		return err;
@@ -371,9 +369,6 @@ static int nilfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct nilfs_transaction_info ti;
 	int err;
 
-	if (new_inode && S_ISDIR(new_inode->i_mode))
-		dentry_unhash(new_dentry);
-
 	err = nilfs_transaction_begin(old_dir->i_sb, &ti, 1);
 	if (unlikely(err))
 		return err;
-- 
1.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
