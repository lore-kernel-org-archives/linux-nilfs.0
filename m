From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 4/6] nilfs2: fix incorrect masking of permission flags for symlinks
Date: Tue, 19 Jul 2022 21:18:34 -0400
Message-ID: <20220720011836.1025430-4-sashal@kernel.org>
References: <20220720011836.1025430-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279934;
        bh=2EAe9d/15fb9EvQLyRctfq8yKMy23iuGqG2W9wu1BFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OM5NzPSyKMLLKbRDTYtuFpQHJ81tIiV90bJavaQyqsYCtBNiB1RoI3ShATGu/sny9
         jSSpLKhrVg4DZzoFShkd9JZkWx4VolJNaopcVe/UTPYULL8XA6TxOOfwbQKGELsBxc
         ZJRaQQmTcBt23By2wMdUwjUWWeaKt5+atrGsxJxvZb1X/bXcIjdGtwdMf+hrFIC81m
         buHeswDwT7Ktl3Gz+tNJ16F6T+TXYxfRNvNUgH/zx5ZVpHI8B3V8sGgkzvxxQzhL86
         MYO+eSvGaKedsF6xKP8wOBRbRkqgiFc35+wCRaBeQRZVcPJ+7gM4l5MrFm8LA1pDo2
         C/C2QEs7c7nQQ==
In-Reply-To: <20220720011836.1025430-1-sashal@kernel.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>, Tommy Pettersson <ptp@lysator.liu.se>, Ciprian Craciun <ciprian.craciun@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Sasha Levin <sashal@kernel.org>, linux-nilfs@vger.kernel.org

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

[ Upstream commit 5924e6ec1585445f251ea92713eb15beb732622a ]

The permission flags of newly created symlinks are wrongly dropped on
nilfs2 with the current umask value even though symlinks should have 777
(rwxrwxrwx) permissions:

 $ umask
 0022
 $ touch file && ln -s file symlink; ls -l file symlink
 -rw-r--r--. 1 root root 0 Jun 23 16:29 file
 lrwxr-xr-x. 1 root root 4 Jun 23 16:29 symlink -> file

This fixes the bug by inserting a missing check that excludes
symlinks.

Link: https://lkml.kernel.org/r/1655974441-5612-1-git-send-email-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: Tommy Pettersson <ptp@lysator.liu.se>
Reported-by: Ciprian Craciun <ciprian.craciun@gmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/nilfs.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 33f8c8fc96e8..a89704271428 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -212,6 +212,9 @@ static inline int nilfs_acl_chmod(struct inode *inode)
 
 static inline int nilfs_init_acl(struct inode *inode, struct inode *dir)
 {
+	if (S_ISLNK(inode->i_mode))
+		return 0;
+
 	inode->i_mode &= ~current_umask();
 	return 0;
 }
-- 
2.35.1

