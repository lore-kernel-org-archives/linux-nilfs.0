From: wu000273-OJFnDUYgAso@public.gmane.org
Subject: [PATCH V2] nilfs2: Fix reference count leak in nilfs_sysfs_create_device_group
Date: Wed, 27 May 2020 18:04:42 -0500
Message-ID: <20200527230442.24228-1-wu000273@umn.edu>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-p5.oit.umn.edu 49XRHP6wKgz9vYjG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=YHV5y6pIipCjzQp8LJwYmqlUFnQseQ80Ln/ckTdkCZw=;
        b=cTHdopN1hULb06TaGd+P4W4iF4wc7U/uaQW2V250xUb74vT/pfcAPR/g7vHCexSE9Y
         2W4eeIUZWE0ubJXJebuMkJuDiQDogzRy969KUhph1Z8Fpyxp7S2HZ98bY6d0mWzii+ol
         JP1eqF6PGJdyzbh5D74xjdDym8bsW0Yd3N3ZLKoWZYAiwW0FAHmg3AzvKgh/Ip/VmI8J
         J95FoovDFBV1D2IOtBvw8iabv3ImXcgts0MdLraATS6I5cLk6NCJTGSPmnKuf/p7xdsb
         S218PRxjeZqROisKi/g/v3FZpOnnkqlTG9Z+Tv6PsXxvGLt6vUmKFf+gQMR2dNTH8MwG
         QpNw==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kjlu-OJFnDUYgAso@public.gmane.org, wu000273-OJFnDUYgAso@public.gmane.org

From: Qiushi Wu <wu000273-OJFnDUYgAso@public.gmane.org>

kobject_init_and_add() takes reference even when it fails.
In nilfs_sysfs_create_device_group(), the memory allocated by
kobject_init_and_add() is not freed when kobject_init_and_add()
fails. Fix this issue by calling kobject_put() to clean up the
kobject.

Fixes: da7141fb78db ("nilfs2: add /sys/fs/nilfs2/<device> group")
Signed-off-by: Qiushi Wu <wu000273-OJFnDUYgAso@public.gmane.org>
---
 V2: using kobject_put() to handle kobject_init_and_add() instead of
 kobject_del().

 fs/nilfs2/sysfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index e60be7bb55b0..8416f915d118 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -999,8 +999,10 @@ int nilfs_sysfs_create_device_group(struct super_block *sb)
 	init_completion(&nilfs->ns_dev_kobj_unregister);
 	err = kobject_init_and_add(&nilfs->ns_dev_kobj, &nilfs_dev_ktype, NULL,
 				    "%s", sb->s_id);
-	if (err)
+	if (err) {
+		kobject_put(&nilfs->ns_dev_kobj);
 		goto free_dev_subgroups;
+	}
 
 	err = nilfs_sysfs_create_mounted_snapshots_group(nilfs);
 	if (err)
-- 
2.17.1

