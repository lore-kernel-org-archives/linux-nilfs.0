From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 5/8] nilfs2: fix incorrect masking of permission flags for symlinks
Date: Tue, 19 Jul 2022 21:18:07 -0400
Message-ID: <20220720011810.1025308-5-sashal@kernel.org>
References: <20220720011810.1025308-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279910;
        bh=yvYYLK8GTpvd0DLQXvYV+6tSNlBZQRy5OKk9R12S89Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=noxgCKL2mllNuRxMoCis/H7toQ0RwSU/YGfJdPabFMYmTfX4sWLAdU71ROrGz5Njs
         3n7qCx1NfYprtCcfaJjAJNyooH0GXHAgCUFxbVibUWUzdzjHzKzPd1FCTkfLk12kdB
         IJhTxPZ1jEg9l0LY16Cs3vyE0idP0Sh+zb9ACuJMOLDNBuwmqqj4/UtGhDCRZrgPiJ
         J2VqErt4mrgck6s6zTcj2r9MVG6sK+ZdPjDqeDBMFnsE/x+O+tcMXdjTUw7AOsA51Y
         fv9M6PGc+ZPZu4Hj2nkbUkNF0Zqvwxx18swrEIP6mD/0LT5kmwzV4bv1fXVnOuWSe3
         lUhNF9PHlHsXg==
In-Reply-To: <20220720011810.1025308-1-sashal@kernel.org>
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
index 8699bdc9e391..cca30f0f965c 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -198,6 +198,9 @@ static inline int nilfs_acl_chmod(struct inode *inode)
 
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

