Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A93E30EF8F
	for <linux-nilfs@vger.kernel.org>; Thu, 30 Jul 2026 12:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785414776; cv=none; b=U1kJim5dmZfZfZ3+TmYBIOxIpGvFpK9Fy6wCR328BWH8f/OG6FqB2DV0KS9hAg8BZbtZlPXVcZ+s8AlXygkAAxxkVqIyy9vvY7YKEBdIZYGfywfQc6t+0ZYRsQ9h2pi8FpkWaAh/veXeFw7Plz9/0KkZJTJ2wHdM9mlHqQZbxZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785414776; c=relaxed/simple;
	bh=39qajB48rbzxBkjSHb78svelt5Psf92ncaoSapRI1Xw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=INtLz6zWGoFj82p+yjXQCiC0vnYUfxiXeEM/cv9tBHcGg1lfl9JMadrSDnvXvQ2A5WgD2rGc1qQExsKtnYe2ev/WKC+DYoOwWn1Inx1hw3TQG4y9OdKngp8bOaB2W+pUEg6T8IbEcqzrk8NT8ldQIvK/zBgK1q1mJPdoozrKpCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=PzvCRWxr; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="PzvCRWxr"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=YrLU+gfRNbj2eohMOqPL4l06YOGegGgdvnuG68EiIG8=;
	b=PzvCRWxrChi4+XVuXJ5L5D+6tRRE1m3h5PsWqAVSSC8uHlrwlVGNa6U3hJ0Rkgw7cFUvrXy/1
	LTfYtP7tza8VkrCakkoomTyJtAeaVmYVH5noEwyBGnczQRteE/CvXE966QXaMbChRQGAvIDocxW
	YUqA2qfyGED176Yo5tFw7Bw=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4h9pJS31j4z1prLg;
	Thu, 30 Jul 2026 20:23:20 +0800 (CST)
Received: from kwepemf200016.china.huawei.com (unknown [7.202.181.9])
	by mail.maildlp.com (Postfix) with ESMTPS id 2CABA40579;
	Thu, 30 Jul 2026 20:32:50 +0800 (CST)
Received: from huawei.com (10.113.213.244) by kwepemf200016.china.huawei.com
 (7.202.181.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 30 Jul
 2026 20:32:49 +0800
From: Wang Jianjian <wangjianjian3@huawei.com>
To: <konishi.ryusuke@gmail.com>, <slava@dubeyko.com>,
	<linux-nilfs@vger.kernel.org>
CC: Wang Jianjian <wangjianjian3@huawei.com>
Subject: [PATCH 2/2] nilfs: check new inode's nlink when rename
Date: Thu, 30 Jul 2026 20:01:05 +0800
Message-ID: <20260730120105.2746192-2-wangjianjian3@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260730120105.2746192-1-wangjianjian3@huawei.com>
References: <20260730120105.2746192-1-wangjianjian3@huawei.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemf200016.china.huawei.com (7.202.181.9)

When rename, if new inode exists, then its nlink must not be zero.

Signed-off-by: Wang Jianjian <wangjianjian3@huawei.com>
---
 fs/nilfs2/namei.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index e2fe95de3d71..db171789a316 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -397,6 +397,11 @@ static int nilfs_rename(struct mnt_idmap *idmap,
 		struct folio *new_folio;
 		struct nilfs_dir_entry *new_de;
 
+		if (new_inode->i_nlink == 0) {
+			err = -EFSCORRUPTED;
+			goto out_dir;
+		}
+
 		err = -ENOTEMPTY;
 		if (old_is_dir && !nilfs_empty_dir(new_inode))
 			goto out_dir;
-- 
2.34.1

