From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [GIT PULL] nilfs2 fix for 2.6.39
Date: Wed, 11 May 2011 00:59:38 +0900 (JST)
Message-ID: <20110511.005938.137710056.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Linus,

please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

to grab one regression fix.  This corrects an infinite loop bug that
happened in an abnormal condition.

Thanks,

Ryusuke Konishi
--
The following changes since commit 693d92a1bbc9e42681c42ed190bd42b636ca876f:

  Linux 2.6.39-rc7 (2011-05-09 19:33:54 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git fixes

Ryusuke Konishi (1):
      nilfs2: fix infinite loop in nilfs_palloc_freev function

 fs/nilfs2/alloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/alloc.c b/fs/nilfs2/alloc.c
index 0a0a66d..f768448 100644
--- a/fs/nilfs2/alloc.c
+++ b/fs/nilfs2/alloc.c
@@ -646,7 +646,7 @@ int nilfs_palloc_freev(struct inode *inode, __u64 *entry_nrs, size_t nitems)
 	unsigned long group, group_offset;
 	int i, j, n, ret;
 
-	for (i = 0; i < nitems; i += n) {
+	for (i = 0; i < nitems; i = j) {
 		group = nilfs_palloc_group(inode, entry_nrs[i], &group_offset);
 		ret = nilfs_palloc_get_desc_block(inode, group, 0, &desc_bh);
 		if (ret < 0)
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
