From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] nilfs2: fix leak of nilfs_root in case of writer thread creation failure
Date: Fri,  7 Oct 2022 17:52:26 +0900
Message-ID: <20221007085226.57667-1-konishi.ryusuke@gmail.com>
References: <00000000000098972c05e2117b39@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TB46KdvMZJgbp7dR23YxTpKAGexyJNaQ7bch9IZKt5g=;
        b=LBVqR/yPOZwnyKzExIyyeK2UXrPOk/YcWE0CJHj+Y71HAu4SeFTCiLYC2TTConOuKa
         iCqBXE+VJSoEDuDJJaG167OwcsEKmPNvHSxOzxmRz3rNt88cW4v2rD/mf3uzK0vdzbyy
         ESS1NLv4eJgRvbehfiTj80l+kBB4KIit9CSiyAu7LZaqkqoBb/rClNbnkCAg+W7sfvYL
         rlqwJYepj2zpik//780faN81CpKDaKlT+UigHfVwGQtV0QryXdSjlIrD6ZhZQiIlN+Zf
         pNgzOd0C6q29AXAUQxDpSo6+xz4xIB6Qv+MyQAKFY+1zK3vFqAqenEd8yTFjqS9NDORq
         ot2A==
In-Reply-To: <00000000000098972c05e2117b39-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, syzbot <syzbot+7381dc4ad60658ca4c05-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

If nilfs_attach_log_writer() failed to create a log writer thread, it
frees a data structure of the log writer without any cleanup.  After
commit e912a5b66837 ("nilfs2: use root object to get ifile"), this
causes a leak of struct nilfs_root, which started to leak an ifile
metadata inode and a kobject on that struct.

In addition, if the kernel is booted with panic_on_warn, the above
ifile metadata inode leak will cause the following panic when the
nilfs2 kernel module is removed:

  kmem_cache_destroy nilfs2_inode_cache: Slab cache still has objects when
  called from nilfs_destroy_cachep+0x16/0x3a [nilfs2]
  WARNING: CPU: 8 PID: 1464 at mm/slab_common.c:494 kmem_cache_destroy+0x138/0x140
  ...
  RIP: 0010:kmem_cache_destroy+0x138/0x140
  Code: 00 20 00 00 e8 a9 55 d8 ff e9 76 ff ff ff 48 8b 53 60 48 c7 c6 20 70 65 86 48 c7 c7 d8 69 9c 86 48 8b 4c 24 28 e8 ef 71 c7 00 <0f> 0b e9 53 ff ff ff c3 48 81 ff ff 0f 00 00 77 03 31 c0 c3 53 48
  ...
  Call Trace:
   <TASK>
   ? nilfs_palloc_freev.cold.24+0x58/0x58 [nilfs2]
   nilfs_destroy_cachep+0x16/0x3a [nilfs2]
   exit_nilfs_fs+0xa/0x1b [nilfs2]
    __x64_sys_delete_module+0x1d9/0x3a0
   ? __sanitizer_cov_trace_pc+0x1a/0x50
   ? syscall_trace_enter.isra.19+0x119/0x190
   do_syscall_64+0x34/0x80
   entry_SYSCALL_64_after_hwframe+0x63/0xcd
   ...
   </TASK>
  Kernel panic - not syncing: panic_on_warn set ...

This patch fixes these issues by calling nilfs_detach_log_writer()
cleanup function if spawning the log writer thread fails.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Fixes: e912a5b66837 ("nilfs2: use root object to get ifile")
Reported-by: syzbot+7381dc4ad60658ca4c05-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
Tested-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 fs/nilfs2/segment.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 0afe0832c754..5276ab525f01 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2786,10 +2786,9 @@ int nilfs_attach_log_writer(struct super_block *sb, struct nilfs_root *root)
 	inode_attach_wb(nilfs->ns_bdev->bd_inode, NULL);
 
 	err = nilfs_segctor_start_thread(nilfs->ns_writer);
-	if (err) {
-		kfree(nilfs->ns_writer);
-		nilfs->ns_writer = NULL;
-	}
+	if (unlikely(err))
+		nilfs_detach_log_writer(sb);
+
 	return err;
 }
 
-- 
2.34.1

