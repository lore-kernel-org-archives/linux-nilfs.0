From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: fix list corruption after ifile creation failure
Date: Fri, 13 Aug 2010 15:50:14 +0900
Message-ID: <1281682214-29423-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

If nilfs_attach_checkpoint() gets a memory allocation failure during
creation of ifile, it will return without removing nilfs_sb_info
struct from ns_supers list.  When a concurrently mounted snapshot is
unmounted or another new snapshot is mounted after that, this causes
kernel oops as below:

> BUG: unable to handle kernel NULL pointer dereference at (null)
> IP: [<f83662ff>] nilfs_find_sbinfo+0x74/0xa4 [nilfs2]
> *pde = 00000000
> Oops: 0000 [#1] SMP
<snip>
> Call Trace:
>  [<f835dc29>] ? nilfs_get_sb+0x165/0x532 [nilfs2]
>  [<c1173c87>] ? ida_get_new_above+0x16d/0x187
>  [<c109a7f8>] ? alloc_vfsmnt+0x7e/0x10a
>  [<c1070790>] ? kstrdup+0x2c/0x40
>  [<c1089041>] ? vfs_kern_mount+0x96/0x14e
>  [<c108913d>] ? do_kern_mount+0x32/0xbd
>  [<c109b331>] ? do_mount+0x642/0x6a1
>  [<c101a415>] ? do_page_fault+0x0/0x2d1
>  [<c1099c00>] ? copy_mount_options+0x80/0xe2
>  [<c10705d8>] ? strndup_user+0x48/0x67
>  [<c109b3f1>] ? sys_mount+0x61/0x90
>  [<c10027cc>] ? sysenter_do_call+0x12/0x22

This fixes the problem.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/super.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 1fa86b9..bee60c0 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -400,9 +400,10 @@ int nilfs_attach_checkpoint(struct nilfs_sb_info *sbi, __u64 cno)
 	list_add(&sbi->s_list, &nilfs->ns_supers);
 	up_write(&nilfs->ns_super_sem);
 
+	err = -ENOMEM;
 	sbi->s_ifile = nilfs_ifile_new(sbi, nilfs->ns_inode_size);
 	if (!sbi->s_ifile)
-		return -ENOMEM;
+		goto delist;
 
 	down_read(&nilfs->ns_segctor_sem);
 	err = nilfs_cpfile_get_checkpoint(nilfs->ns_cpfile, cno, 0, &raw_cp,
@@ -433,6 +434,7 @@ int nilfs_attach_checkpoint(struct nilfs_sb_info *sbi, __u64 cno)
 	nilfs_mdt_destroy(sbi->s_ifile);
 	sbi->s_ifile = NULL;
 
+ delist:
 	down_write(&nilfs->ns_super_sem);
 	list_del_init(&sbi->s_list);
 	up_write(&nilfs->ns_super_sem);
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
