From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: append blocksize info to warnings during loading
 super blocks
Date: Mon, 24 Jan 2011 01:35:53 +0900 (JST)
Message-ID: <20110124.013553.69293224.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Wakko Warner <wakko-WZdgCHJQUilg9hUCZPvPmw@public.gmane.org>

Wakko Warner gave us a report that the same warning was output twice
when nilfs detected a problem on super blocks.

I first thought about combining the repeated messages into one, but
soon found it's not a good idea.  For instance, if an error arises
between the two warnings, both would be suppressed if we don't rewrite
carefully.  It seems like such change doesn't clarify things after
all.

This patch, instead, relieves the confusion just by adding block size
information to those warnings.

Ryusuke Konishi
--
From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

nilfs2: append blocksize info to warnings during loading super blocks

At present, the same warning message can be output twice when nilfs
detected a problem on super blocks:

 NILFS warning: broken superblock. using spare superblock.
 NILFS warning: broken superblock. using spare superblock.
 ...

This is because these super blocks are reloaded with the block size
written in a super block if it differs from the first block size, but
this repetition looks somewhat confusing.  So, we hint at what is
going on by appending block size information to those messages.

Reported-by: Wakko Warner <wakko-WZdgCHJQUilg9hUCZPvPmw@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/the_nilfs.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index ad4ac60..9098909 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -475,10 +475,13 @@ static int nilfs_load_super_block(struct the_nilfs *nilfs,
 			return -EIO;
 		}
 		printk(KERN_WARNING
-		       "NILFS warning: unable to read primary superblock\n");
-	} else if (!sbp[1])
+		       "NILFS warning: unable to read primary superblock "
+		       "(blocksize = %d)\n", blocksize);
+	} else if (!sbp[1]) {
 		printk(KERN_WARNING
-		       "NILFS warning: unable to read secondary superblock\n");
+		       "NILFS warning: unable to read secondary superblock "
+		       "(blocksize = %d)\n", blocksize);
+	}
 
 	/*
 	 * Compare two super blocks and set 1 in swp if the secondary
@@ -505,7 +508,7 @@ static int nilfs_load_super_block(struct the_nilfs *nilfs,
 
 	if (!valid[!swp])
 		printk(KERN_WARNING "NILFS warning: broken superblock. "
-		       "using spare superblock.\n");
+		       "using spare superblock (blocksize = %d).\n", blocksize);
 	if (swp)
 		nilfs_swap_super_block(nilfs);
 
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
