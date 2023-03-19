From: Yangtao Li <frank.li-DGpbCiVdSXo@public.gmane.org>
Subject: [PATCH v2 10/10] nilfs2: convert to kobject_del_and_put()
Date: Sun, 19 Mar 2023 16:41:33 +0800
Message-ID: <20230319084134.11804-10-frank.li@vivo.com>
References: <20230319084134.11804-1-frank.li@vivo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cChoitUiIc7ttW7uWFlm2vga0tLO+9+UHdJAAvZFHvM=;
 b=E27KLRg1vYqXBeNlHnnsKgM0JBaVJSmjAfOD0IVf5RHuVkWska+N1SOFrEz3mQdV7lASzjwEZlwSAUWBM5vrs2q+G9Yq/ljWpqaAzqDsJC8+7uD1TXim8UOkcpBOMHITFY8eF51SO53bN0LM0uEjTAZo6HTJL3eu2s/e0cfvf1yUe1p03M/LbPEbDk0C47HVhQaONYx89XjXQHg7Mql3UJ7xnIcx4o7VcYnFMl6lwB2qFRe6sHj+IUhZ94Lu2+Sxf0zzqGt2PlHi+c8ukhG5PVvpug5omqgVEpfI44W8e4rpmHOW/bC2jDrMe2oPLi+30jdryjvU6kcKkETcgwPvHA==
In-Reply-To: <20230319084134.11804-1-frank.li-DGpbCiVdSXo@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yangtao Li <frank.li-DGpbCiVdSXo@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Use kobject_del_and_put() to simplify code.

Signed-off-by: Yangtao Li <frank.li-DGpbCiVdSXo@public.gmane.org>
---
 fs/nilfs2/sysfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index 379d22e28ed6..150965d58ca5 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -1042,8 +1042,7 @@ void nilfs_sysfs_delete_device_group(struct the_nilfs *nilfs)
 	nilfs_sysfs_delete_segments_group(nilfs);
 	nilfs_sysfs_delete_superblock_group(nilfs);
 	nilfs_sysfs_delete_segctor_group(nilfs);
-	kobject_del(&nilfs->ns_dev_kobj);
-	kobject_put(&nilfs->ns_dev_kobj);
+	kobject_del_and_put(&nilfs->ns_dev_kobj);
 	kfree(nilfs->ns_dev_subgroups);
 }
 
-- 
2.35.1

