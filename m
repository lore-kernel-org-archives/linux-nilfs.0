From: Dongliang Mu <mudongliangabcd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] nilfs2: fix memory leak in nilfs_sysfs_create_device_group
Date: Mon,  6 Sep 2021 12:13:30 +0800
Message-ID: <20210906041330.2065214-1-mudongliangabcd@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DDfs506elfVQtwvsSc35KPZpNEn95r25l9p9sqG0B24=;
        b=ojfO4IOtMRTy69WphW9Tmy1bAz8RPBeEY38eHzq8DFTANyDHjGN0aHRotHC/g2+3LW
         O7vb9rhbjFmuj4qOI3SCSfq8YtGdoIbcDhNEtw8xUMSMY8xSUlg4O6+QqofS7oRkgwkj
         T9/WH3HKF7xuJFaO/FYSidOxBt0LgN4fWcWK1EYFLOW0uzkaVBlCF5cu1Icjd2O9ygjA
         tKyruamwlIESAymZeo/cEi+2AbLLAjfv62HODSGcVFhWDwZ1KYovTCTC7JfODcT7G3cm
         uiaSgzwRzjDav2ahkjb5jEKQf0exIXIJ9xqT6hrt7lM2CmzMiXe2t1K4lGTlgrfaBgwu
         5SQQ==
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: paskripkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Dongliang Mu <mudongliangabcd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The commit 8fd0c1b0647a ("nilfs2: fix memory leak in
nilfs_sysfs_delete_device_group") adds a kobject_put to free the leaking
object name. However, it is incomplete to only add kobject_put in the
nilfs_sysfs_delete_device_group. The function
nilfs_sysfs_create_device_group also needs the kobject_put to
free the object name in the error handling part.

Fix this by adding kobject_put in the error handling code of
nilfs_sysfs_create_device_group.

Signed-off-by: Dongliang Mu <mudongliangabcd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/nilfs2/sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index 68e8d61e28dd..7ab60711ca76 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -1024,6 +1024,7 @@ int nilfs_sysfs_create_device_group(struct super_block *sb)
 
 cleanup_dev_kobject:
 	kobject_del(&nilfs->ns_dev_kobj);
+	kobject_put(&nilfs->ns_dev_kobj);
 
 free_dev_subgroups:
 	kfree(nilfs->ns_dev_subgroups);
-- 
2.25.1

