From: Geliang Tang <geliangtang@gmail.com>
Subject: [PATCH 2/2] nilfs2: use nilfs_btree_node_size()
Date: Fri, 20 Jan 2017 22:34:58 +0800
Message-ID: <9739473c1af067900c2e54990fd06b7ef2e99d0f.1484896146.git.geliangtang@gmail.com>
References: <ebd4d1fb0aada6ed0bb1d2de21230c3b1fb148a9.1484896146.git.geliangtang@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=7PZyO/5lHu1IEomIeVC3Vglzgp6IAluzqNNAqHZJBAs=;
        b=lcNTYnrPqvGlrkgKf2XTsWcDktUJcSVpa6PK08mJ8gOumEiAcsAYy+L/aa5ftzWNzc
         /Ab8MhVCGL71nX31CQMvBZ6Q9hIcBiv8snCIKRJ2vFnOqEEnj1OPsc/Tuls8up8a+tKO
         Bcx86V4zxIhTtypnRaI+HtPS+Wrdpwm/s93kc2PggpmXkyxCTW76rCqAppemT3r7hkVk
         7yKDHtaYnDzyIBSGvUsVI5AwLp/xO1ksfDN5g0kpxszLpF/Sl1Y+8UQmzImMCIEoSaCb
         EsgHQOf8xNSjm0A5N3emluJUHE5iWlxdopsB+25LL6BBrCduOjhbFhNkh7f7BllZkB/d
         4iew==
In-Reply-To: <ebd4d1fb0aada6ed0bb1d2de21230c3b1fb148a9.1484896146.git.geliangtang@gmail.com>
In-Reply-To: <ebd4d1fb0aada6ed0bb1d2de21230c3b1fb148a9.1484896146.git.geliangtang@gmail.com>
References: <ebd4d1fb0aada6ed0bb1d2de21230c3b1fb148a9.1484896146.git.geliangtang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org

Use nilfs_btree_node_size() instead of open-coding.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 fs/nilfs2/btree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index d75238a..06ffa13 100644
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
2.9.3

