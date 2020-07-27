From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: [PATCH 1/3] nilfs2: only call unlock_new_inode() if I_NEW
Date: Mon, 27 Jul 2020 23:28:29 +0900
Message-ID: <1595860111-3920-2-git-send-email-konishi.ryusuke@gmail.com>
References: <1595860111-3920-1-git-send-email-konishi.ryusuke@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nUFJGvnWyF6qoYfPbdIhfrpvCAwFxFbm++nM0m4j1+A=;
        b=IfKrJo2o03JmvLHa+pQ2r8tvOMDEMmMS9689Tf2c5z77DEloP8Eb99Osg4bcOQndKD
         BV/TOFVYF4CI/SFNAJ3eS04KWPGS17hc4VK6WghPxgZENZrR/+7nMFarP0iNIKRlD5M7
         ksIbJaoAhkqJ/FWyV51biNozuvKJVN8UvT/lbXLrf/cit6S0+8IZSn6HXA2rvBgumxQv
         t3cSnKd9UoeA7TenvxvDRoB7sik8lG+xVVQqwHAVXx5vlmuXx5f/bhPt8HGUQ3F/ZgpV
         eeAR3yk6wDpzW7MtqznGl0yz2Gy8tHJtQDCsB+lmKpDCLJJcMGWL+9KagLTS5j9rCl4A
         ng8w==
In-Reply-To: <1595860111-3920-1-git-send-email-konishi.ryusuke@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

unlock_new_inode() is only meant to be called after a new inode has
already been inserted into the hash table.  But nilfs_new_inode() can
call it even before it has inserted the inode, triggering the WARNING in
unlock_new_inode().  Fix this by only calling unlock_new_inode() if the
inode has the I_NEW flag set, indicating that it's in the table.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 28009ec54420..3318dd1350b2 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -388,7 +388,8 @@ struct inode *nilfs_new_inode(struct inode *dir, umode_t mode)
 
  failed_after_creation:
 	clear_nlink(inode);
-	unlock_new_inode(inode);
+	if (inode->i_state & I_NEW)
+		unlock_new_inode(inode);
 	iput(inode);  /*
 		       * raw_inode will be deleted through
 		       * nilfs_evict_inode().
-- 
1.8.3.1

