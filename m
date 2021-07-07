From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/6] nilfs2: fix memory leak in nilfs_sysfs_create_##name##_group
Date: Wed,  7 Jul 2021 18:48:23 +0900
Message-ID: <1625651306-10829-4-git-send-email-konishi.ryusuke@gmail.com>
References: <1625651306-10829-1-git-send-email-konishi.ryusuke@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tg8Rx1wWlkNbqejilODw641z/b4x4fF9Uuzm0P4x4D0=;
        b=PrljIE+wuY2ULWNMaoB/MgNZV+baMZEw5jLy1StHdilD/VcS99UswWyI5DXhaoGnEc
         AK4A0yeTJpj7bkQC1MWz2HCkCqXW1ZHPIioYLmu5prnU1wrqtg1CmDK6aMjhYzlbVL67
         3nB+owYsvkETSfWHkXSrJ7bqkCO33K5pLz9eXGDh29BvuaxxTeFylm8m5T5rtWVI4nkz
         garM9kmXjh8FTwyk0Tki6hAMb7fxkX0Lw3Au7we3s03pmxuFOiDkBBW9JXCS+pOvJ0BS
         Ebu3SgcWHAGkBwNkJJOWZyc3jOVTJgaV3Y1UBdKg8y/KvqWA54wIP4HqHEtMrqcrLw9v
         kivQ==
In-Reply-To: <1625651306-10829-1-git-send-email-konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

From: Nanyong Sun <sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

If kobject_init_and_add return with error, kobject_put() is needed
here to avoid memory leak, because kobject_init_and_add may return
error without freeing the memory associated with the kobject it allocated.

Link: https://lkml.kernel.org/r/20210629022556.3985106-4-sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Signed-off-by: Nanyong Sun <sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/nilfs2/sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index 43f660beb9b4..5dc468ff5903 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -92,8 +92,8 @@
 	err = kobject_init_and_add(kobj, &nilfs_##name##_ktype, parent, \
 				    #name); \
 	if (err) \
-		return err; \
-	return 0; \
+		kobject_put(kobj); \
+	return err; \
 } \
 static void nilfs_sysfs_delete_##name##_group(struct the_nilfs *nilfs) \
 { \
-- 
1.8.3.1

