From: wu000273-OJFnDUYgAso@public.gmane.org
Subject: [PATCH] nilfs2: Fix reference count leak in nilfs_sysfs_create_device_group
Date: Wed, 27 May 2020 15:09:33 -0500
Message-ID: <20200527200933.31135-1-wu000273@umn.edu>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-p6.oit.umn.edu 49XMPw1JcWz9vZ29
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=hPSY+Zh0t1rGNkSqJtjBbGWhpyEB+X/pF0E6TThgwhg=;
        b=cO0BH8ko43bkOPatdOWMTW1FAm4WGWEPap0aloF2Ov8I0nG59A/3qh6AZfb6yAbZZO
         WAhNKKNK7gSl5i+QdplLfll1L86UVGr2JjcN3cCuvjtM4R1WxDbhalnYCwNgAdRyz5pR
         gYgtyRBZD+g5y6bZ/jB0XJ+eePjHUzxTXtJ8zt8lnJwfL9WqejH+dysiC2m3vWxz0qIU
         5nQrWV7T5cxzaojhGzAJaNCP3VPFY8xJInVRdfzCR+MaWpnpTT3X+w0EwAsjWp/q6kjl
         XGbnFX8oRUWA22jCtYpUo772KJpqFPyEjNrgn1OTYXUggTnMtWI0arlJAKaeejZwEVHO
         OJ/A==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: kjlu-OJFnDUYgAso@public.gmane.org
Cc: wu000273-OJFnDUYgAso@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vyacheslav Dubeyko <Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Qiushi Wu <wu000273-OJFnDUYgAso@public.gmane.org>

kobject_init_and_add() takes reference even when it fails.
In nilfs_sysfs_create_device_group(), the memory allocated by
kobject_init_and_add() is not freed when kobject_init_and_add()
fails. Thus replace the jump target "free_dev_subgroups" by
"cleanup_dev_kobject".

Fixes: da7141fb78db ("nilfs2: add /sys/fs/nilfs2/<device> group")
Signed-off-by: Qiushi Wu <wu000273-OJFnDUYgAso@public.gmane.org>
---
 fs/nilfs2/sysfs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index e60be7bb55b0..4a74756d52fe 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -1000,7 +1000,7 @@ int nilfs_sysfs_create_device_group(struct super_block *sb)
 	err = kobject_init_and_add(&nilfs->ns_dev_kobj, &nilfs_dev_ktype, NULL,
 				    "%s", sb->s_id);
 	if (err)
-		goto free_dev_subgroups;
+		goto cleanup_dev_kobject;
 
 	err = nilfs_sysfs_create_mounted_snapshots_group(nilfs);
 	if (err)
@@ -1038,8 +1038,6 @@ int nilfs_sysfs_create_device_group(struct super_block *sb)
 
 cleanup_dev_kobject:
 	kobject_del(&nilfs->ns_dev_kobj);
-
-free_dev_subgroups:
 	kfree(nilfs->ns_dev_subgroups);
 
 failed_create_device_group:
-- 
2.17.1

