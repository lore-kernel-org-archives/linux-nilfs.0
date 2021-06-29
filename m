From: Nanyong Sun <sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/6] nilfs2: fix memory leak in nilfs_sysfs_delete_##name##_group
Date: Tue, 29 Jun 2021 10:25:54 +0800
Message-ID: <20210629022556.3985106-5-sunnanyong@huawei.com>
References: <20210629022556.3985106-1-sunnanyong@huawei.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20210629022556.3985106-1-sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

The kobject_put() should be used to cleanup the memory associated with
the kobject insead of kobject_del. See the section "Kobject removal"
of "Documentation/core-api/kobject.rst".

Signed-off-by: Nanyong Sun <sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 fs/nilfs2/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index 6305e4ef7e39..d989e6500bd7 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -84,7 +84,7 @@ static int nilfs_sysfs_create_##name##_group(struct the_nilfs *nilfs) \
 } \
 static void nilfs_sysfs_delete_##name##_group(struct the_nilfs *nilfs) \
 { \
-	kobject_del(&nilfs->ns_##parent_name##_subgroups->sg_##name##_kobj); \
+	kobject_put(&nilfs->ns_##parent_name##_subgroups->sg_##name##_kobj); \
 }
 
 /************************************************************************
-- 
2.18.0.huawei.25

