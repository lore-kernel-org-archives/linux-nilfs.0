From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [GIT PULL] nilfs2 additional fix
Date: Sun, 22 Aug 2010 22:30:40 +0900 (JST)
Message-ID: <20100822.223040.116160895.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Hi Linus,

please pull:

  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

to grab the following fix, which corrects sync failure of discard in
nilfs that Christoph noticed me recently.

Thanks!

Ryusuke Konishi
--
The following changes since commit 3b89f56783a4ef796190ef1192c25e72e0b986b6:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../jmorris/security-testing-2.6

Ryusuke Konishi (1):
      nilfs2: wait for discard to finish

 fs/nilfs2/the_nilfs.c |    4 +++-

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 6af1c00..4317f17 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -775,6 +775,7 @@ int nilfs_discard_segments(struct the_nilfs *nilfs, __u64 *segnump,
 						   start * sects_per_block,
 						   nblocks * sects_per_block,
 						   GFP_NOFS,
+						   BLKDEV_IFL_WAIT |
 						   BLKDEV_IFL_BARRIER);
 			if (ret < 0)
 				return ret;
@@ -785,7 +786,8 @@ int nilfs_discard_segments(struct the_nilfs *nilfs, __u64 *segnump,
 		ret = blkdev_issue_discard(nilfs->ns_bdev,
 					   start * sects_per_block,
 					   nblocks * sects_per_block,
-					   GFP_NOFS, BLKDEV_IFL_BARRIER);
+					   GFP_NOFS,
+					  BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
 	return ret;
 }
 
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
