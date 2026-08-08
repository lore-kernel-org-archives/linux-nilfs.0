Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99A431715F
	for <linux-nilfs@vger.kernel.org>; Sat,  8 Aug 2026 08:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786176668; cv=none; b=pHYB6XxFYK7YH6vlqbxOspQ2/Qbr2IFpDcGT73QHg7dzfmWxdzKOd9Zgb7Jp1mW1LARKSqN7jpeSkW7JjTuUCWz8TKW/CdILTXZdBESwa44SmF1yJm95QPdnk+kji237vP6TyQ15KIeRbQskLc84omRmPLJCnEuudZmvcM8A3Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786176668; c=relaxed/simple;
	bh=tzrXbW78y7memsk0OiYw83QM8r7v35qdphHqBbgZ3BY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NZ7EJO0yEgvHIZ8C//ac5nj1HR6y6S8apJ+BVPs4pPnINPHTFcsLA/kXE0v60xd1qyMkmKHLMIpMh6mZk2zlGXRKCSQB1nBbevS1oWVsGjHTcoebzz4sbfIctdVu7dfiyKeonINoH2RF4Ox8F75LNhnh9T1gLFtTz0ar2gyxxCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=ixeXTqAV; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="ixeXTqAV"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=8zJqhWQ/tcwhUhrZCllmRI+N+fZAty62m1DyfMKER24=;
	b=ixeXTqAV2xdT9DySpBsZOYJuG6g8Q69voCFwV260LX5xO1wb3UNw/WolbqXl+um1wOCfFefXX
	oegqQ6n1obIAHFbKBB2QZbZCzgpwnQT6ihMUp+kp2fFKPPWoDsJkr0odXYsfLizUnK3ulP2T57B
	bHq21/Gs1zlsTCyc0MSxVH0=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4hHD2q0Wb3z1K9cD;
	Sat,  8 Aug 2026 16:00:19 +0800 (CST)
Received: from kwepemf200016.china.huawei.com (unknown [7.202.181.9])
	by mail.maildlp.com (Postfix) with ESMTPS id 90BDE40572;
	Sat,  8 Aug 2026 16:10:53 +0800 (CST)
Received: from huawei.com (10.113.213.244) by kwepemf200016.china.huawei.com
 (7.202.181.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 8 Aug
 2026 16:10:52 +0800
From: Wang Jianjian <wangjianjian3@huawei.com>
To: <konishi.ryusuke@gmail.com>, <slava@dubeyko.com>,
	<linux-nilfs@vger.kernel.org>
CC: Wang Jianjian <wangjianjian3@huawei.com>,
	<syzbot+f6c7e1f1809f235eeb90@syzkaller.appspotmail.com>
Subject: [PATCH v2 1/2] nilfs2: check new inode's nlink when rename
Date: Sat, 8 Aug 2026 15:38:36 +0800
Message-ID: <20260808073837.2689615-1-wangjianjian3@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemf200016.china.huawei.com (7.202.181.9)

Syzbot reported below warning:
inode->i_nlink == 0
WARNING: fs/inode.c:417 at drop_nlink+0xc5/0x110 fs/inode.c:417, CPU#0:
syz.0.17/5467

The reason is as below:
1. setup a tracepoint bpf program on nilfs_transaction_transition and it
   will send signal 33 when hit it.
2. rename foo -> file1
    vfs_rename
      nilfs_rename
        // nilfs will remove old dentry from buffer cache and decrase
        // target inode's links to zero
        nilfs_transaction_commit
          nilfs_construct_segment // fs mounted with SYNC
            nilfs_segctor_sync
	      signal_pending // pend sigal 33 by bpf program sent
			     // set error to ERESTARTSYS
      // vfs got error, dentry will not be unhashed and left in cache

3. above rename will be executed again(ERESTARTSYS) and get dentry from
   cache but nilfs_rename will return ENOENT since old dentry had been
   removed from buffer cache.
4. another renameat2 bar -> file1. This will find the old file1's dentry but its
   links had been zero so that trigger this warning.

Reported-by: syzbot+f6c7e1f1809f235eeb90@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f6c7e1f1809f235eeb90
Signed-off-by: Wang Jianjian <wangjianjian3@huawei.com>
---
 fs/nilfs2/namei.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index e2fe95de3d71..2ad1c83188e2 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -397,6 +397,12 @@ static int nilfs_rename(struct mnt_idmap *idmap,
 		struct folio *new_folio;
 		struct nilfs_dir_entry *new_de;
 
+		if (new_inode->i_nlink == 0) {
+			nilfs_error(old_dir->i_sb, "inode %lu links is zero", new_inode->i_ino);
+			err = -EIO;
+			goto out_dir;
+		}
+
 		err = -ENOTEMPTY;
 		if (old_is_dir && !nilfs_empty_dir(new_inode))
 			goto out_dir;
-- 
2.34.1

