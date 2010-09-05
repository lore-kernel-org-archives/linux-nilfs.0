From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [GIT PULL] nilfs2 fix
Date: Sun, 05 Sep 2010 11:52:12 +0900 (JST)
Message-ID: <20100905.115212.58895734.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Linus,

please pull a nilfs2 fix from:

  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

This fixes a leak issue that occurs when recovery aborted.

Thanks,

Ryusuke Konishi
--
The following changes since commit 2bfc96a127bc1cc94d26bfaa40159966064f9c8c:
  Linus Torvalds (1):
        Linux 2.6.36-rc3

Ryusuke Konishi (1):
      nilfs2: fix leak of shadow dat inode in error path of load_nilfs

 fs/nilfs2/the_nilfs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 4317f17..ba7c10c 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -446,6 +446,7 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 	nilfs_mdt_destroy(nilfs->ns_cpfile);
 	nilfs_mdt_destroy(nilfs->ns_sufile);
 	nilfs_mdt_destroy(nilfs->ns_dat);
+	nilfs_mdt_destroy(nilfs->ns_gc_dat);
 
  failed:
 	nilfs_clear_recovery_info(&ri);
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
