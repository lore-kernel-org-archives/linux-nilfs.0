From: Pavel Skripkin <paskripkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] nilfs2: fix memory leak in nilfs_sysfs_delete_device_group
Date: Sat, 12 Jun 2021 17:05:59 +0300
Message-ID: <20210612140559.20022-1-paskripkin@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5JZMHW5UG5CyvDN0SOE2Y9hqb0tFNng+vhQJCVqivJ8=;
        b=D6A/v3863n804431JpJ/EPCUtfVYDzi5Uhzhb4quMvA3+UiYYEvk1ssSEFIblDNXjC
         fduAtA1lKSPuxgPLQ1aIklkw8rwfDwxNlOJgWtwURLw/DCPAXr4mHVcxF4wD1R/bgMx/
         OJ3EKf41fIzJJkYiWoQu8gZ1qgV6zWqngjpvUZmSLJC2zIUaKz6JsnM+uTv42IY3f7O4
         APCOatnS29cF08zfcyOzV0CGUbWgukwmnxsc6/GlA8V0Jkehu7zGnpF5Heg09wES22i0
         37haeWAjqYEcrjqK6G3pI5MrbZrP+cr8TwuA3A7ubAFNxsTSlkEhYVnKnx36yKOsgSlk
         KeRw==
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pavel Skripkin <paskripkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

My local syzbot instance hit memory leak in nilfs2.
The problem was in missing kobject_put() in
nilfs_sysfs_delete_device_group().

kobject_del() does not call kobject_cleanup() for
passed kobject and it leads to leaking duped
kobject name if kobject_put() was not called.

Fail log:

BUG: memory leak
unreferenced object 0xffff8880596171e0 (size 8):
  comm "syz-executor379", pid 8381, jiffies 4294980258 (age 21.100s)
  hex dump (first 8 bytes):
    6c 6f 6f 70 30 00 00 00                          loop0...
  backtrace:
    [<ffffffff81a2c656>] kstrdup+0x36/0x70 mm/util.c:60
    [<ffffffff81a2c6e3>] kstrdup_const+0x53/0x80 mm/util.c:83
    [<ffffffff83ccc698>] kvasprintf_const+0x108/0x190 lib/kasprintf.c:48
    [<ffffffff83e99926>] kobject_set_name_vargs+0x56/0x150 lib/kobject.c:289
    [<ffffffff83e99fd9>] kobject_add_varg lib/kobject.c:384 [inline]
    [<ffffffff83e99fd9>] kobject_init_and_add+0xc9/0x160 lib/kobject.c:473
    [<ffffffff8304e840>] nilfs_sysfs_create_device_group+0x150/0x800 fs/nilfs2/sysfs.c:999
    [<ffffffff830159f6>] init_nilfs+0xe26/0x12b0 fs/nilfs2/the_nilfs.c:637

Fixes: da7141fb78db ("nilfs2: add /sys/fs/nilfs2/<device> group")
Signed-off-by: Pavel Skripkin <paskripkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/nilfs2/sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index 303d71430bdd..9c6c0e2e5880 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -1053,6 +1053,7 @@ void nilfs_sysfs_delete_device_group(struct the_nilfs *nilfs)
 	nilfs_sysfs_delete_superblock_group(nilfs);
 	nilfs_sysfs_delete_segctor_group(nilfs);
 	kobject_del(&nilfs->ns_dev_kobj);
+	kobject_put(&nilfs->ns_dev_kobj);
 	kfree(nilfs->ns_dev_subgroups);
 }
 
-- 
2.32.0

