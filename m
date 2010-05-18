From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [stable] nilfs2: fix sync silent failure
Date: Wed, 19 May 2010 01:47:41 +0900 (JST)
Message-ID: <20100519.014741.220046229.ryusuke@osrg.net>
References: <20100519.012423.218986668.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100519.012423.218986668.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: stable <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 19 May 2010 01:24:23 +0900 (JST), Ryusuke Konishi wrote:
> Please consider commit 973bec34bfc1bc2465646181653d67f767d418c8 for
> inclusion in 2.6.33.y and 2.6.32.y.
> 
> Here is the commit message.  It fixes a grave regression since 2.6.32,
> which makes "sync" operation nonfunctional, and leading to unexpected
> user's data loss.
> 
> I have tested the patch, and confirmed that it restores the function
> of "sync" for both 2.6.33.y and 2.6.32.y.  Unfortunetaly, the patch
> didn't apply to 2.6.32.y as is (3-way merge was required).
> 
> To make sure, I will later post an adjusted patch against 2.6.32.y.

Here is the patch for 2.6.32.y.

Thanks,
Ryusuke Konishi

--
From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Date: Mon, 3 May 2010 21:00:48 +0900
Subject: [PATCH] nilfs2: fix sync silent failure

As of 32a88aa1, __sync_filesystem() will return 0 if s_bdi is not set.
And nilfs does not set s_bdi anywhere.  I noticed this problem by the
warning introduced by the recent commit 5129a469 ("Catch filesystem
lacking s_bdi").

 WARNING: at fs/super.c:959 vfs_kern_mount+0xc5/0x14e()
 Hardware name: PowerEdge 2850
 Modules linked in: nilfs2 loop tpm_tis tpm tpm_bios video shpchp pci_hotplug output dcdbas
 Pid: 3773, comm: mount.nilfs2 Not tainted 2.6.34-rc6-debug #38
 Call Trace:
  [<c1028422>] warn_slowpath_common+0x60/0x90
  [<c102845f>] warn_slowpath_null+0xd/0x10
  [<c1095936>] vfs_kern_mount+0xc5/0x14e
  [<c1095a03>] do_kern_mount+0x32/0xbd
  [<c10a811e>] do_mount+0x671/0x6d0
  [<c1073794>] ? __get_free_pages+0x1f/0x21
  [<c10a684f>] ? copy_mount_options+0x2b/0xe2
  [<c107b634>] ? strndup_user+0x48/0x67
  [<c10a81de>] sys_mount+0x61/0x8f
  [<c100280c>] sysenter_do_call+0x12/0x32

This ensures to set s_bdi for nilfs and fixes the sync silent failure.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Acked-by: Jens Axboe <jens.axboe-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
---
 fs/nilfs2/super.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 644e667..63e7b10 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -781,6 +781,7 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
 	sb->s_export_op = &nilfs_export_ops;
 	sb->s_root = NULL;
 	sb->s_time_gran = 1;
+	sb->s_bdi = nilfs->ns_bdi;
 
 	if (!nilfs_loaded(nilfs)) {
 		err = load_nilfs(nilfs, sbi);
-- 
1.5.6.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
