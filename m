From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/6] nilfs2: fix memory leak in nilfs_sysfs_create_snapshot_group
Date: Wed,  7 Jul 2021 18:48:25 +0900
Message-ID: <1625651306-10829-6-git-send-email-konishi.ryusuke@gmail.com>
References: <1625651306-10829-1-git-send-email-konishi.ryusuke@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=g65fz9nM8vuwTrmBSnevy9pcjESld9hrzhcHi3C3t4A=;
        b=ikrRirSr4cUmzEpdQmmFKc3izLb2YT7TEKkwWpA/6cJD74N7eMpo5j3U53PUJo1R0q
         CRonVthx/k2QMQG8mWc0UBQ2khL/d6GA+IxHqHfVXC/7+lSE0YM+TrqdilRXESMVh1ZH
         pqzRavBwP/YobXByESncEa1Y6EeZaf01367AMDI1gh2p3pEiGiL9/sfnOWcW3Qklw3Ba
         qXQwifUzvGFIDdCbZ/VZN9LJ0X7TlF3Wf/cLY08XOESlyb9Ck3IaDUG9edOp1NEieHwJ
         NFqzqa49e/h9nXKcaQC0MG42XoFkJlq5HjRmSxBgzBa0KtCVS34V2VAoi1T0FmBedHV+
         wFhg==
In-Reply-To: <1625651306-10829-1-git-send-email-konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

From: Nanyong Sun <sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

If kobject_init_and_add returns with error, kobject_put() is needed
here to avoid memory leak, because kobject_init_and_add may return
error without freeing the memory associated with the kobject it allocated.

Link: https://lkml.kernel.org/r/20210629022556.3985106-6-sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Signed-off-by: Nanyong Sun <sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/nilfs2/sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index 34893a57a7b9..44b9ad70a564 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -208,9 +208,9 @@ int nilfs_sysfs_create_snapshot_group(struct nilfs_root *root)
 	}
 
 	if (err)
-		return err;
+		kobject_put(&root->snapshot_kobj);
 
-	return 0;
+	return err;
 }
 
 void nilfs_sysfs_delete_snapshot_group(struct nilfs_root *root)
-- 
1.8.3.1

