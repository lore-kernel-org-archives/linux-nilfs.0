From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: fix gcc warning at nilfs_checkpoint_is_mounted()
Date: Thu,  2 Apr 2015 23:38:48 +0900
Message-ID: <1427985528-4701-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=8Yai7PNyWAUZaigmwbsEmlzENCwVQNp45RxPtcledbA=;
        b=aP+YuxyKcRmSDI8u4SOeJINZGqHPphIIjHXCVVVTe167GwgA6IwYx+4gyjnZOrNoll
         RuA0Jq451wEtIUL/F3nfU01xJsXxVwAMoH3/k6SIfTaPaUXIay8Gs2oW3xpYuPsafEiN
         E3/PX8v2RNNhR10H0LNwfK/Nly/kEK3VAD2IhQb13hsVVU7KaJcnSKK2kH4yNtWOhqC0
         uGWmfe8LCtp3jt5fwL5KEDrn+svkiZpScQ3bxncLngiNpm+AM8yYJvVLcdWKhwINunbL
         WpivFrndTaUjDjC+cxwUjnsiJ9KcoskUJdGXx+evK36jFvWNSMAtXQI3BwvkKzbg1MEH
         GVCA==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Binderman <dcb314-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Fix the following build warning:

 fs/nilfs2/super.c: In function 'nilfs_checkpoint_is_mounted':
 fs/nilfs2/super.c:1023:10: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
   if (cno < 0 || cno > nilfs->ns_cno)
           ^

This warning indicates that the comparision "cno < 0" is useless
because variable "cno" has an unsigned integer type "__u64".

Reported-by: David Binderman <dcb314-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 5bc2a1c..c1725f20 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1020,7 +1020,7 @@ int nilfs_checkpoint_is_mounted(struct super_block *sb, __u64 cno)
 	struct dentry *dentry;
 	int ret;
 
-	if (cno < 0 || cno > nilfs->ns_cno)
+	if (cno > nilfs->ns_cno)
 		return false;
 
 	if (cno >= nilfs_last_cno(nilfs))
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
