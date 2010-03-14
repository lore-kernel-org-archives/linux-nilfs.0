From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 5/6] nilfs2: remove spaces before tabs
Date: Sun, 14 Mar 2010 11:28:38 +0900
Message-ID: <1268533719-19454-6-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1268533719-19454-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1268533719-19454-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This kills the following checkpatch warnings:

 WARNING: please, no space before tabs
 #74: FILE: segment.h:74:
 +^Iunsigned ^I^Iflags;$

 WARNING: please, no space before tabs
 #35: FILE: segbuf.c:35:
 +^Iint ^I^I^Istart, end; /* The region to be submitted */$

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/segbuf.c  |    2 +-
 fs/nilfs2/segment.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index e3f67c6..636eaaf 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -32,7 +32,7 @@
 struct nilfs_write_info {
 	struct the_nilfs       *nilfs;
 	struct bio	       *bio;
-	int 			start, end; /* The region to be submitted */
+	int			start, end; /* The region to be submitted */
 	int			rest_blocks;
 	int			max_pages;
 	int			nr_vecs;
diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
index 2a79456..82dfd6a 100644
--- a/fs/nilfs2/segment.h
+++ b/fs/nilfs2/segment.h
@@ -71,7 +71,7 @@ struct nilfs_recovery_info {
  */
 struct nilfs_cstage {
 	int			scnt;
-	unsigned 		flags;
+	unsigned		flags;
 	struct nilfs_inode_info *dirty_file_ptr;
 	struct nilfs_inode_info *gc_inode_ptr;
 };
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
