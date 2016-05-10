From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/7] nilfs2: remove space before semicolon
Date: Tue, 10 May 2016 22:24:26 +0900
Message-ID: <1462886671-3521-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1462886671-3521-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=JGwdR3vgkAYfGPKLPjSKt3q10oF43N6HUb38o5A4ojI=;
        b=coyb2AqEqWhLbCObpikkL+FbmlX8jK31M3fgLovhpPwQ0dcjEd+sF11BfG3HkzGZir
         pe8CrM37lH4H3v5AwJRAEGcj+7AVnwDtfKUDDf37c+Me439IyF8ve4lJ2kCnSiVB4AhC
         +Fyr3oHv+3uTvaxn+Xv/qv/aqeo4yQ8yZ+4DnccilQdPwfveFsv9FTw5RP3JQ+BeoRlY
         RsM5uDUYcoD86gzXld6tVb4w1G/LQteEJgBdIMOQ8akhpVtZPgHwzWc/qRyccMlyIzDY
         9B1qhhB+E/4CdaiUR52dHK7gFohapCHg75Fq4tPlZ5WOush17N8IcUTL4/lMBGSjQ8lU
         DZpQ==
In-Reply-To: <1462886671-3521-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This fixes the checkpatch.pl warning "WARNING: space prohibited before
semicolon" at nilfs_store_magic_and_option().

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 92acb00..0271784 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -886,7 +886,7 @@ int nilfs_store_magic_and_option(struct super_block *sb,
 	nilfs->ns_interval = le32_to_cpu(sbp->s_c_interval);
 	nilfs->ns_watermark = le32_to_cpu(sbp->s_c_block_max);
 
-	return !parse_options(data, sb, 0) ? -EINVAL : 0 ;
+	return !parse_options(data, sb, 0) ? -EINVAL : 0;
 }
 
 int nilfs_check_feature_compatibility(struct super_block *sb,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
