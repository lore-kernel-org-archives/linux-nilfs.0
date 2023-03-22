From: Yangtao Li <frank.li-DGpbCiVdSXo@public.gmane.org>
Subject: [PATCH v3 10/10] nilfs2: convert to kobject_del_and_put()
Date: Thu, 23 Mar 2023 00:59:05 +0800
Message-ID: <20230322165905.55389-9-frank.li@vivo.com>
References: <20230322165905.55389-1-frank.li@vivo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YeSXbiSKn/Htu8RDFyUlihMaEwMnfwHjUTJcCENoL/A=;
 b=NuhvGdyeKkkSMp+Z62JFUScTXvDMRB9XyKUOpkU91HY/zlVSteoNvV684AqzMiT6PQ4kdwT8Sz3zn8K7avLMed9jhxUaNILeI46p3TFWJQxswV3B/cMgTN6AnSDGrjnkWuuS9RJhGfHCEjJhZf3LNIjVOKnykbmLdX6buFdN+qAmLG9Gi9xCQGozHfInbbgJk+5lKDajr1rxHF5+cw3YuS+YgYGGNYlXqn/pmliFzetvZhDRjxPlKu0N5RHGIbCaeXU5XUC1qaMvngMVB6yaqLY7h+nYxGkg+8LTHAVL4fHPIgnoFrPXEIMJWpN9g5wqkVk8CL4+r1qmh1VFhsNzcA==
In-Reply-To: <20230322165905.55389-1-frank.li-DGpbCiVdSXo@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yangtao Li <frank.li-DGpbCiVdSXo@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Damien Le Moal <damien.lemoal-yzvPICuk2AC/Fx7ZUtofftBPR1lH4CV8@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Use kobject_del_and_put() to simplify code.

Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Damien Le Moal <damien.lemoal-yzvPICuk2AC/Fx7ZUtofftBPR1lH4CV8@public.gmane.org>
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

