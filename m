Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0736A392829
	for <linux-nilfs@vger.kernel.org>; Sat,  8 Aug 2026 08:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786176669; cv=none; b=IZE6Yftg/aqG/nw5V07p15aQqQIZurxDNi8QRQqMIJ9thVCLg7R74Q7g1ah6Dv6wux/g78kZI5/YNr/eUPUehXMq07Ulc7b4E/x3j4Li3Sjpad06DArmsO2fRZ50HHD4E26SFh0ffNGwob9TKl1NaUrYP0gsYOaPvWjF+z+Ode4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786176669; c=relaxed/simple;
	bh=apzRki146y7f8LrwcL5uw/Lt2uieMgbvKHxGMTUJqRg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iu+i46DQwW7A55NZ/tV/Zg93D2YEpjuZe6bOKk3glAEkHxu0p9Jr0c6HMzU0ltSf3b6OfvOrp0SvXWuowa0oUgAmJV9Y+omAuZBuCjkb8+UsaxBeL7dmYHFykRhi/y624Z+xaEEbkobgJ0t/0yp7jTQUgz2oiN6DwdlED5tk3vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=OXls+mLj; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="OXls+mLj"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=TLH20zqAjCNHdP1rhlb8FfcvS4qNtYRi/+uKDCwvgW0=;
	b=OXls+mLjNLHkyT5bhz35VJshL//51JDX7fjFwM4rKmgSeili6cKIOV8WmMjpo70vnjeVMYL2s
	htBlnTGxkVUvZoiAcOPGXv27WAJvrkW/YHFBXQF85fu3NbGhSsVwANgZmSRMSNW/XmFjZkM2quv
	Uaez6yKjVODiQt1K+uAa5Xc=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hHD322k9wznTVd;
	Sat,  8 Aug 2026 16:00:30 +0800 (CST)
Received: from kwepemf200016.china.huawei.com (unknown [7.202.181.9])
	by mail.maildlp.com (Postfix) with ESMTPS id 2F05240572;
	Sat,  8 Aug 2026 16:10:55 +0800 (CST)
Received: from huawei.com (10.113.213.244) by kwepemf200016.china.huawei.com
 (7.202.181.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 8 Aug
 2026 16:10:54 +0800
From: Wang Jianjian <wangjianjian3@huawei.com>
To: <konishi.ryusuke@gmail.com>, <slava@dubeyko.com>,
	<linux-nilfs@vger.kernel.org>
CC: Wang Jianjian <wangjianjian3@huawei.com>,
	<syzbot+158be45e4d99232e1900@syzkaller.appspotmail.com>
Subject: [PATCH v2 2/2] nilfs2: enhance btree node keys check
Date: Sat, 8 Aug 2026 15:38:37 +0800
Message-ID: <20260808073837.2689615-2-wangjianjian3@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260808073837.2689615-1-wangjianjian3@huawei.com>
References: <20260808073837.2689615-1-wangjianjian3@huawei.com>
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

syzbot reported a warning on nilfs_btree_assign:
WARNING: fs/nilfs2/btree.c:2302 at nilfs_btree_assign+0x983/0xbe0 fs/nilfs2/btree.c:2302,

Analysis found that a corrupted file has the following btree layout:
Level2(key/ptr): [ 256/15 ]
Level1(key/ptr): [ 0/8, 1/9, 0/10, 3/11, 4/12, 5/13, 6/14, 139637976727559/16, 0/17 ]

The test truncated the file to 2 bytes, which partially zeroes the first block and
adds the file to the dirty list. When the segment constructor writes it and assigns
a new blocknr for the index block, it searches the btree with key=0 and min level=2,
and apparently returns ENOENT.

Therefore, we should perform more checks on the btree nodes and return early.

Reported-by: syzbot+158be45e4d99232e1900@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=158be45e4d99232e1900
Signed-off-by: Wang Jianjian <wangjianjian3@huawei.com>
---
 fs/nilfs2/btree.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 64d5f7c5ab44..adf087c896ba 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -341,7 +341,8 @@ static int nilfs_btree_node_broken(const struct nilfs_btree_node *node,
 				   sector_t blocknr)
 {
 	int level, flags, nchildren;
-	int ret = 0;
+	__u64 key, prev_key;
+	int i;
 
 	level = nilfs_btree_node_get_level(node);
 	flags = nilfs_btree_node_get_flags(node);
@@ -356,9 +357,19 @@ static int nilfs_btree_node_broken(const struct nilfs_btree_node *node,
 			   "bad btree node (ino=%llu, blocknr=%llu): level = %d, flags = 0x%x, nchildren = %d",
 			   inode->i_ino, (unsigned long long)blocknr, level,
 			   flags, nchildren);
-		ret = 1;
+		return 1;
 	}
-	return ret;
+
+	for (i = 1, prev_key = nilfs_btree_node_get_key(node, 0); i < nchildren; i++, prev_key = key) {
+		key = nilfs_btree_node_get_key(node, i);
+		if (unlikely(key <= prev_key)) {
+			nilfs_crit(inode->i_sb,
+				"bad btree node(ino=%llu, blocknr=%llu), key not sorted: %d/%llu <= %d/%llu",
+				inode->i_ino, (unsigned long long)blocknr, i, key, i - 1, prev_key);
+			return 1;
+		}
+	}
+	return 0;
 }
 
 /**
-- 
2.34.1

