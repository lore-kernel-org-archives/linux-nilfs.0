From: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH AUTOSEL 4.9 4/6] nilfs2: fix incorrect masking of permission flags for symlinks
Date: Tue, 19 Jul 2022 21:18:55 -0400
Message-ID: <20220720011858.1025523-4-sashal@kernel.org>
References: <20220720011858.1025523-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279957;
        bh=2EAe9d/15fb9EvQLyRctfq8yKMy23iuGqG2W9wu1BFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uk9EoO5MDa4c8jWPkFM8Hae5bSLUkoF9+gxPTgbax9SAmTAx9ph3QL3h+ay3KygRj
         YXEqR6XPyrq0/xYC14H4lOkEZMI7B9kAd/VzdXYCp7RUIfnTXjrnqsF7FlHaUfeMlz
         iMtf3eUGOxvSsoGFwABOYkcTIUUK19dskunwDTmPKcMnx+Q+phD0AE4A/3VBc22uBm
         xhgVSw8N2ww14S2OFm+VurucDtvvSR/JMXJHXndItcFQGLxqsrpHxYUYCRGZAjq4sw
         wop1Npka485lFfRGnpZXIB6BIVZ5he5t8fgW4deWocSQabI3xAksNyvdZ5+S+lrOiJ
         V/oixs6Bqe4Xg==
In-Reply-To: <20220720011858.1025523-1-sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tommy Pettersson <ptp-SamgB31n2u5IcsJQ0EH25Q@public.gmane.org>, Ciprian Craciun <ciprian.craciun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

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

Link: https://lkml.kernel.org/r/1655974441-5612-1-git-send-email-konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reported-by: Tommy Pettersson <ptp-SamgB31n2u5IcsJQ0EH25Q@public.gmane.org>
Reported-by: Ciprian Craciun <ciprian.craciun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Tested-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Signed-off-by: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
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

