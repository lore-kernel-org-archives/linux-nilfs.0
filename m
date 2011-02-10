From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs-utils: fix incorrect initial inode count
Date: Thu, 10 Feb 2011 15:21:28 +0900
Message-ID: <1297318888-24387-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

There was a slip-up on the mkfs.nilfs2 program.  Even though the
initial number of inodes is two (i.e. root directory plus .nilfs),
lscp reports that it's three.  Unbelievable, but real.

This patch belatedly fixes that fundamental mistake.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 sbin/mkfs/mkfs.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/sbin/mkfs/mkfs.c b/sbin/mkfs/mkfs.c
index 092edfd..0eeb859 100644
--- a/sbin/mkfs/mkfs.c
+++ b/sbin/mkfs/mkfs.c
@@ -150,8 +150,7 @@ static void parse_options(int argc, char *argv[]);
 static const unsigned group_desc_blocks_per_group = 1;
 static const unsigned bitmap_blocks_per_group = 1;
 static const unsigned nr_initial_segments = 2; /* initial segment + next */
-static const unsigned nr_initial_inodes = 3;  /* root directory + .sketch +
-						 .nilfs */
+static const unsigned nr_initial_inodes = 2;  /* root directory + .nilfs */
 static const __u64 first_cno = 1; /* Number of the first checkpoint */
 
 /* Segment layout information (per partial segment) */
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
