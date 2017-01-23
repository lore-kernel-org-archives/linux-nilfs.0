From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH -mm 1/2] nilfs2: use nilfs_btree_node_size()
Date: Tue, 24 Jan 2017 00:17:34 +0900
Message-ID: <1485184655-3895-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1485184655-3895-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=G55jQRCzbvHaSnkbvIsVNJgO6d8Y1qlLVj/nxF4Dx6M=;
        b=ENdImyaaP35k0W4fpekaQlV3R0dLq+UpOzbmM5u2JDUG+lWjXVZZJ3BxD32Euvo5J2
         fTF9hfcowfZ8ShO1v9TkSHKjDpy3+DVR5BRMc+HPXEGvwMg0zELEpcM3Ju1jp0W+IY9C
         dZHlXT182bX6hfSloLFKmLvXDHlwwMrcsyNSrrJehZ6Z4AyGnxzGvCTTvHpg3m8gePR1
         D768Ip5Z4P7ghHl4U6TEA3KzTuxNN986I9gAJR0A0x2AQN+DuajxwXCD5we4mJdjWodI
         1vyQzB3pM/5uDgOD6X97MzUm9tX/6nPI/rPDMIaWNpgloxPKCh09J8IGOE4RQV//dt2f
         2iSQ==
In-Reply-To: <1485184655-3895-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-nilfs <linux-nilfs@vger.kernel.org>, Geliang Tang <geliangtang@gmail.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

From: Geliang Tang <geliangtang@gmail.com>

Use nilfs_btree_node_size() instead of open-coding.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/btree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 2e315f9..9c7ea17 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -1870,7 +1870,7 @@ int nilfs_btree_convert_and_insert(struct nilfs_bmap *btree,
 		di = &dreq;
 		ni = NULL;
 	} else if ((n + 1) <= NILFS_BTREE_NODE_NCHILDREN_MAX(
-			   1 << btree->b_inode->i_blkbits)) {
+			   nilfs_btree_node_size(btree))) {
 		di = &dreq;
 		ni = &nreq;
 	} else {
-- 
1.8.3.1

