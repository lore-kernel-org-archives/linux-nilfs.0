From: Yaowei Bai <bywxiaobai@163.com>
Subject: [PATCH 14/17] fs/nilfs2: remove unnecessary new_valid_dev check
Date: Mon, 28 Sep 2015 22:33:43 +0800
Message-ID: <1443450823-5692-1-git-send-email-bywxiaobai@163.com>
References: <1443446807-4838-1-git-send-email-bywxiaobai@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id; bh=gOkPJUCxCoJhKOH33V
	9EmiiRKR7fjRs05xB4iGo6yPM=; b=hbNEKmmSVTUZHHAydvTg4zzi2WgRqXrOry
	UrkXm3awtPYXDRQ7t+/TkcJAwcp/pvgZyhYz4M0K1wDus6GkXj3hGy0s94LM3/gA
	f/Mugc+5dXjBiLeIuSEf43BxIZSCn40InKHdBCJpWjmLTj+FAIbHVPzhLpOQ+WuS
	4Njmmgoqw=
In-Reply-To: <1443446807-4838-1-git-send-email-bywxiaobai@163.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: viro@zeniv.linux.org.uk, konishi.ryusuke@lab.ntt.co.jp
Cc: linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

As new_valid_dev always returns 1, so !new_valid_dev check is not
needed, remove it.

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
---
 fs/nilfs2/namei.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 37dd6b0..c9a1a49 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -120,9 +120,6 @@ nilfs_mknod(struct inode *dir, struct dentry *dentry, umode_t mode, dev_t rdev)
 	struct nilfs_transaction_info ti;
 	int err;
 
-	if (!new_valid_dev(rdev))
-		return -EINVAL;
-
 	err = nilfs_transaction_begin(dir->i_sb, &ti, 1);
 	if (err)
 		return err;
-- 
1.9.1

