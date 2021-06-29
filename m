From: Nanyong Sun <sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 5/6] nilfs2: fix memory leak in nilfs_sysfs_create_snapshot_group
Date: Tue, 29 Jun 2021 10:25:55 +0800
Message-ID: <20210629022556.3985106-6-sunnanyong@huawei.com>
References: <20210629022556.3985106-1-sunnanyong@huawei.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20210629022556.3985106-1-sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

If kobject_init_and_add returns with error, kobject_put() is needed
here to avoid memory leak, because kobject_init_and_add may return
error without freeing the memory associated with the kobject it allocated.

Signed-off-by: Nanyong Sun <sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 fs/nilfs2/sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index d989e6500bd7..5ba87573ad3b 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -195,9 +195,9 @@ int nilfs_sysfs_create_snapshot_group(struct nilfs_root *root)
 	}
 
 	if (err)
-		return err;
+		kobject_put(&root->snapshot_kobj);
 
-	return 0;
+	return err;
 }
 
 void nilfs_sysfs_delete_snapshot_group(struct nilfs_root *root)
-- 
2.18.0.huawei.25

