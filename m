From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] nilfs2: remove redundant continue statement in a while-loop
Date: Fri, 25 Jun 2021 03:01:04 +0900
Message-ID: <1624557664-17159-1-git-send-email-konishi.ryusuke@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=0Kxa6sZKClpIemf8Xwi+xgUNqQi000u7Br5b9L8QPXM=;
        b=NIKFU7m4YSoY+VX+USS4jSFrp9E3oem1ny0oG0ECsadGqTOpmQvHYRLUC0ayLLser0
         L786DqLxZEGuoTZys72tLCN0jJFMt0mJmw8yzWDpPH14F9oBMQBa9pX+I12l3Ljnbtcw
         INPZeGt9s+ZPtpB0aw5jkkWxRLm4VE3AGITej9qzOMHitIsFrdF46jUuk6FHtpZdWP6+
         +7Y5sw/v4agoJUqgmgPlMBmsLfAM/hyYflMmuYp1KpmMEGQ44qqXF6yKsXvCdQAD8fGx
         bAOOyO4gkQ/Y7BX4AmhC7xw/9c8KyZuv3KmaeSsmlU0jCAS5YUZzJ0+dUhDSf3+TcN4S
         Chkg==
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

From: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

The continue statement at the end of the while-loop is redundant,
remove it.

Addresses-Coverity: ("Continue has no effect")
Link: https://lkml.kernel.org/r/20210621100519.10257-1-colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org
Signed-off-by: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/nilfs2/btree.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index f42ab57201e7..ab9ec073330f 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -738,7 +738,6 @@ static int nilfs_btree_lookup_contig(const struct nilfs_bmap *btree,
 			if (ptr2 != ptr + cnt || ++cnt == maxblocks)
 				goto end;
 			index++;
-			continue;
 		}
 		if (level == maxlevel)
 			break;
-- 
1.8.3.1

