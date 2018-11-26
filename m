From: Pan Bian <bianpan2016@163.com>
Subject: [PATCH] nilfs2: fix potential use after free
Date: Mon, 26 Nov 2018 11:08:29 +0800
Message-ID: <1543201709-53191-1-git-send-email-bianpan2016@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=sZHw3HwZvqhwcBwOFj
        MO9QS8Qu4C+xqi4pUgXqgre/Q=; b=bgoZpqFNaiXTDqx/DhRlXR4zLrLYQYeMSA
        ri9Egs+UGoOIcPk0BIOOFcbgyEYtVaVvs19gvfAnEtqXKg8hiblp8DyUSnoBkV61
        Rhs0+RqJb5gMMP3JGvmVcjeriVqr1Cxzjx8Af+MgeRJfermvClgMh2wQEsW06UrC
        kl9E4H9vg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>

brelse(bh) is called to drop the reference count of bh when the call
to nilfs_dat_translate fails. If the reference count hits 0, bh may be
freed. However, bh->b_page is unlocked and put after that, which may
result in a use-after-free bug. This patch moves the release operation
after unlocking and putting the page.

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 fs/nilfs2/gcinode.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
index aa3c328..a24bb29 100644
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -73,10 +73,8 @@ int nilfs_gccache_submit_read_data(struct inode *inode, sector_t blkoff,
 		struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
 
 		err = nilfs_dat_translate(nilfs->ns_dat, vbn, &pbn);
-		if (unlikely(err)) { /* -EIO, -ENOMEM, -ENOENT */
-			brelse(bh);
+		if (unlikely(err)) /* -EIO, -ENOMEM, -ENOENT */
 			goto failed;
-		}
 	}
 
 	lock_buffer(bh);
@@ -102,6 +100,8 @@ int nilfs_gccache_submit_read_data(struct inode *inode, sector_t blkoff,
  failed:
 	unlock_page(bh->b_page);
 	put_page(bh->b_page);
+	if (unlikely(err))
+		brelse(bh);
 	return err;
 }
 
-- 
2.7.4


