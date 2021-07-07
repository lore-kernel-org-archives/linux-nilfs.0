From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 6/6] nilfs2: fix memory leak in nilfs_sysfs_delete_snapshot_group
Date: Wed,  7 Jul 2021 18:48:26 +0900
Message-ID: <1625651306-10829-7-git-send-email-konishi.ryusuke@gmail.com>
References: <1625651306-10829-1-git-send-email-konishi.ryusuke@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=e2xjwDG/oZGI2BDWWVUZ80C0oSrUvvIT1iby/SeB9H8=;
        b=JhvyPBxeQDK0AX7lHIYF3EBROFvkLgtaCEPz9WylHwpHVc9kbRdh7rqGKjqL/eKDf2
         sYk1Qj14BNzFx2wJSWs35fR5G16VsNcaAMrWL6AX8Irn/nTKm6JkH1za1WNlf5BsuA9h
         8Iz9jAwS75U8loxeXMPhYjKTeJRBsBo/PWJDoz2Wz0YyGDPx08DZfWWFR3bsI5c01gvE
         CHKHR15hjJXlV/laOcvLng8piA9Nswly05jShlaOJKaIQ8x5qfyqFid+Rmnt6fTycTWR
         T8OYE25BrFYEI6HzzzDeMm4/se9UDIRt1kUPmEMFygVDM7wfGcmD05iFE+fVXkFQWj7i
         pPAQ==
In-Reply-To: <1625651306-10829-1-git-send-email-konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

From: Nanyong Sun <sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Kobject_put() should be used to cleanup the memory associated with
the kobject instead of kobject_del(). See the section "Kobject removal"
of "Documentation/core-api/kobject.rst".

Link: https://lkml.kernel.org/r/20210629022556.3985106-7-sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Signed-off-by: Nanyong Sun <sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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
1.8.3.1

