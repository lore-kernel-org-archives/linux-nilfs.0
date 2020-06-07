From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] nilfs2: fix null pointer dereference at
 nilfs_segctor_do_construct()
Date: Mon, 08 Jun 2020 01:18:19 +0900 (JST)
Message-ID: <20200608.011819.1399059588922299158.konishi.ryusuke@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:to:cc:subject:from:mime-version
         :content-transfer-encoding;
        bh=71YhZNLGhXbmxGNeFEQZl+p8Dpt5MYdooBczOyZ+OjU=;
        b=WDXWp0V9hMZ+1+Pc/Kkpj9DcDd/QARTzErAVYWNdh8fTCm8rJGEAxp2cnn61W4EhVE
         tj2/cz1vfg595gs86XIiY9vvgxDuL7mT6OPDRafcteRX9/o5SryKgyf+OdLmxkr4PIKy
         KFg/NRHRWSxTP7VwdB0MLBsnWioCNnjCfQT5+GtyMeGWWW1+tc20wVK5AYxw7czEBbZK
         QY55GpFT1j3t2Q7uFqWhdrGu/VFVDVwZpxW/stkLy+W7K1RwxGnyaz9KoujLO5mPKLH5
         2A4oNPfnrpAKN5KiSx4vOWvokF5zE5loHEygyZAsJ0NxmkD368/nV5s+UtZ9fSvksY6F
         nyQQ==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

After commit c3aab9a0bd91 ("mm/filemap.c: don't initiate writeback if
mapping has no dirty pages"), the following null pointer dereference
has been reported on nilfs2:

 BUG: kernel NULL pointer dereference, address: 00000000000000a8
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0
 Oops: 0000 [#1] SMP PTI
 ...
 RIP: 0010:percpu_counter_add_batch+0xa/0x60
 ...
 Call Trace:
  __test_set_page_writeback+0x2d3/0x330
  nilfs_segctor_do_construct+0x10d3/0x2110 [nilfs2]
  nilfs_segctor_construct+0x168/0x260 [nilfs2]
  nilfs_segctor_thread+0x127/0x3b0 [nilfs2]
  kthread+0xf8/0x130
  ...

This crash turned out to be caused by set_page_writeback() call for
segment summary buffers at nilfs_segctor_prepare_write().

set_page_writeback() can call inc_wb_stat(inode_to_wb(inode),
WB_WRITEBACK) where inode_to_wb(inode) is NULL if the inode of
underlying block device does not have an associated wb.

This fixes the issue by calling inode_attach_wb() in advance to ensure
to associate the bdev inode with its wb.

Reported-by: Walton Hoops <me-ymjcnyHyYt2fg5KWHKSrRg@public.gmane.org>
Reported-by: Tomas Hlavaty <tom-3l5KtCzVe0PQT0dZR+AlfA@public.gmane.org>
Reported-by: ARAI Shun-ichi <hermes-akuOmOme3sQYOdUovKs6ag@public.gmane.org>
Reported-by: Hideki EIRAKU <hdk1983-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Tested-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # v5.4+
---
 fs/nilfs2/segment.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 445eef4..91b58c8 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2780,6 +2780,8 @@ int nilfs_attach_log_writer(struct super_block *sb, struct nilfs_root *root)
 	if (!nilfs->ns_writer)
 		return -ENOMEM;
 
+	inode_attach_wb(nilfs->ns_bdev->bd_inode, NULL);
+
 	err = nilfs_segctor_start_thread(nilfs->ns_writer);
 	if (err) {
 		kfree(nilfs->ns_writer);
-- 
1.8.3.1

