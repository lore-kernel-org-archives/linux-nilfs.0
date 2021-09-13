From: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH AUTOSEL 5.13 19/19] nilfs2: fix memory leak in nilfs_sysfs_delete_snapshot_group
Date: Mon, 13 Sep 2021 18:34:15 -0400
Message-ID: <20210913223415.435654-19-sashal@kernel.org>
References: <20210913223415.435654-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572481;
        bh=TT7Yvm89GHTbDbLnTP/llXc34jgViI7ozSu+6avBdUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hTgkeASdguw4ZVtjZxTGhQvS6Hzatnlq2SoCm60iIUtm4oIGwjMxyYaiqps9vNUgh
         DhY27OpTgJK+bvwdW37hzH0IUdmdsrtOqh1dZi/4jFFQoEf3fNsGpBSXKvCNdUeepH
         b7QUFPT6rrPJtMvQJiSYknP6CooqcCaJwDy6MxTQCk5ykLYx6MWSTdjwAD8j9bcxfM
         2SB2N9AhKLgUndTntjnWEn0kJ960YCkxR4QEu8vRaFlaCmhzZxXb9f8YIpT4Yi3WC1
         jDSfpVKQ0AIjSqBB7tGYQpFYtd1VBqjmpbY2o0lSUVQgG9WdWTsvaBVB3w/HaUxAQD
         nwevCeDEh8raA==
In-Reply-To: <20210913223415.435654-1-sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Nanyong Sun <sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Nanyong Sun <sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

[ Upstream commit 17243e1c3072b8417a5ebfc53065d0a87af7ca77 ]

kobject_put() should be used to cleanup the memory associated with the
kobject instead of kobject_del().  See the section "Kobject removal" of
"Documentation/core-api/kobject.rst".

Link: https://lkml.kernel.org/r/20210629022556.3985106-7-sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Link: https://lkml.kernel.org/r/1625651306-10829-7-git-send-email-konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Signed-off-by: Nanyong Sun <sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Signed-off-by: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Signed-off-by: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 fs/nilfs2/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index 44b9ad70a564..57afd06db62d 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -215,7 +215,7 @@ int nilfs_sysfs_create_snapshot_group(struct nilfs_root *root)
 
 void nilfs_sysfs_delete_snapshot_group(struct nilfs_root *root)
 {
-	kobject_del(&root->snapshot_kobj);
+	kobject_put(&root->snapshot_kobj);
 }
 
 /************************************************************************
-- 
2.30.2

