From: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH AUTOSEL 4.14 9/9] nilfs2: fix memory leak in nilfs_sysfs_delete_snapshot_group
Date: Mon, 13 Sep 2021 18:35:35 -0400
Message-ID: <20210913223535.436405-9-sashal@kernel.org>
References: <20210913223535.436405-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572548;
        bh=z3fD1eXLu52vtiK1cOfP6pjzNLL6Ku0x60Rfm6bw5pA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R2OQc21lqC3f01U0uCc6Q6Gbzzzw1VurRPIYCZxBv37cz8LVgb7EVT31Q07m6U1lY
         jYeRYdTdCSyiOjs5Wqe2MSvx8eb59G3y7hFx2djFP6Ru2zRs0bkAlQa7sWOw153IXb
         OiiUag9CTI7dRiHT2Fmm1IqEpzhK8XLRQ8X7skTQEuVee/pHf88+MLxqDNn6T7b3ot
         AXIw0ZEmHd1QkFLfTV9luKcQkZhv0lS5BuVfn3AOyExd7c18ul55eSxKOKNwzZQfG9
         DMeAo6KYN2eyXnefUs6YoYU/V0QQHC9hC+9vLQALW2vtjy+F5wf5cKmWHRCiaR1Tvz
         8cCgiOOIkJf9w==
In-Reply-To: <20210913223535.436405-1-sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
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
index 28f5572c6aae..33fba75aa9f3 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -224,7 +224,7 @@ int nilfs_sysfs_create_snapshot_group(struct nilfs_root *root)
 
 void nilfs_sysfs_delete_snapshot_group(struct nilfs_root *root)
 {
-	kobject_del(&root->snapshot_kobj);
+	kobject_put(&root->snapshot_kobj);
 }
 
 /************************************************************************
-- 
2.30.2

