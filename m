From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/2] nilfs2: put out gfp mask manipulation from nilfs_set_inode_flags()
Date: Wed,  8 Apr 2015 23:49:44 +0900
Message-ID: <1428504585-1111-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1428504585-1111-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=rxzxvMEIwe1GOZOQjsbe0yLigTRn1MujJ/xccthVSmw=;
        b=Z0rTLM7LPr1jNWVnkW6DxbjtIgof3tTHk3LDpkxybWjjg/CaoOQB8YLf46pR4kOrAc
         GU4zcevB5Jo0K7KhrIMrfB1VUuZrZLOuAv9NvCKr6ofSxzPtmUKKx7LBKzMClYcVHtaB
         p3eTDPaoN2+j089+esz5DZ8ex8ytLqprNLpdo/OOkqd5P3lSoNy/OQ5IHDYhQOwzDQhh
         jbQ+trdKSLSDEmKeH7GC18RLMIpcP0kpQ1jSDQdeONemMEXO5wpZDfaHiC3VQqLdh3+q
         HKNAY/DqLKRWxhIJx6CSiaQe1wEhf9qBpj7YZJ+Cc6kZpRMTrLbFkYRGFKJdMzsmRf1K
         Li1w==
In-Reply-To: <1428504585-1111-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

nilfs_set_inode_flags() function adjusts gfp-mask of inode->i_mapping
as well as i_flags, however, this coupling of operations is not
appropriate.

For instance, nilfs_ioctl_setflags(), one of three callers of
nilfs_set_inode_flags(), doesn't need to reinitialize the gfp-mask at
all.  In addition, nilfs_new_inode(), another caller of
nilfs_set_inode_flags(), doesn't either because it has already
initialized the gfp-mask.

Only __nilfs_read_inode(), the remaining caller, needs it.  So, this
moves the gfp mask manipulation to __nilfs_read_inode() from
nilfs_set_inode_flags().

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index cf9e489..0c28ccb 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -456,8 +456,6 @@ void nilfs_set_inode_flags(struct inode *inode)
 		inode->i_flags |= S_NOATIME;
 	if (flags & FS_DIRSYNC_FL)
 		inode->i_flags |= S_DIRSYNC;
-	mapping_set_gfp_mask(inode->i_mapping,
-			     mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS);
 }
 
 int nilfs_read_inode_common(struct inode *inode,
@@ -542,6 +540,8 @@ static int __nilfs_read_inode(struct super_block *sb,
 	brelse(bh);
 	up_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
 	nilfs_set_inode_flags(inode);
+	mapping_set_gfp_mask(inode->i_mapping,
+			     mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS);
 	return 0;
 
  failed_unmap:
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
