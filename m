From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/6] nilfs2: fix memory leak in nilfs_sysfs_delete_##name##_group
Date: Wed,  7 Jul 2021 18:48:24 +0900
Message-ID: <1625651306-10829-5-git-send-email-konishi.ryusuke@gmail.com>
References: <1625651306-10829-1-git-send-email-konishi.ryusuke@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Jm/J1o+TQpzcHBhxjA/suPmsl2pJmPGx91gwOJgbshQ=;
        b=SnViRNeGD8tPxOTvIR/wc5IFDeE9SYmRwqPj+In9bmtPibgokbUlvYrXcxnslfFu1w
         NyZ+anSqC5rW0YYwF5IXRm1AVD+Uoq2c3DFVlSgXzu7bmSE3LGDG7MjVJAQ6lL/j0FqA
         uT6eDsjlB+ucP+nBjr4H5XdQfO2dut2uTlHyL1TIZOPvDcvTu7Pq6RXZr+G+r062SVPd
         VPG6HfnSZzgxUPSmPRrE83sloro8UBVHYV7/mXC/fRMWqTDuXn2q4xgsHZiMeRS8YeNS
         Rz1p4ytOfbN8Fd38Ces8T4UleMd3hEgYPs+WLYp+qYHDc7gnEv0uz5bOsbtslX006L87
         6JxA==
In-Reply-To: <1625651306-10829-1-git-send-email-konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

From: Nanyong Sun <sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

The kobject_put() should be used to cleanup the memory associated with
the kobject instead of kobject_del. See the section "Kobject removal"
of "Documentation/core-api/kobject.rst".

Link: https://lkml.kernel.org/r/20210629022556.3985106-5-sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Signed-off-by: Nanyong Sun <sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/nilfs2/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index 5dc468ff5903..34893a57a7b9 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -97,7 +97,7 @@
 } \
 static void nilfs_sysfs_delete_##name##_group(struct the_nilfs *nilfs) \
 { \
-	kobject_del(&nilfs->ns_##parent_name##_subgroups->sg_##name##_kobj); \
+	kobject_put(&nilfs->ns_##parent_name##_subgroups->sg_##name##_kobj); \
 }
 
 /************************************************************************
-- 
1.8.3.1

