From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 16/16] nilfs2: fix memory leak in nilfs_sysfs_delete_snapshot_group
Date: Mon, 13 Sep 2021 18:34:42 -0400
Message-ID: <20210913223442.435885-16-sashal@kernel.org>
References: <20210913223442.435885-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572503;
        bh=TT7Yvm89GHTbDbLnTP/llXc34jgViI7ozSu+6avBdUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zv/xenr0zgOL/qno5oah32SWCbtAMwZ7/nhPaEw9Ib3k3jlfA5QU6lDUd6D0HEkWF
         6foC7fy6xNCBClB9ujA7FqQbbpOgyXlPziW1uNd1XVMdw6+uOqoAS1TxfeyIfEyTZU
         7GSG+Z7XYHU+lyGAzuZA7LMZ/YdtM95R3C4WA6naH4ou8s4bemErczFQbD6Ts4KjLg
         14uWDabj3dK0BTERPwx+5t7lCw4MT7NyvS1Mkih7aW2rchRky+YhGnN/mBsomsAfd+
         GaywLildxp5oW/moz4BlvAkgbLVBlvjKfTVfpawISazXI7cooSyatLxoUWHZU5yO3s
         Nk9LtHqAeeXoQ==
In-Reply-To: <20210913223442.435885-1-sashal@kernel.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Nanyong Sun <sunnanyong@huawei.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Sasha Levin <sashal@kernel.org>, linux-nilfs@vger.kernel.org

From: Nanyong Sun <sunnanyong@huawei.com>

[ Upstream commit 17243e1c3072b8417a5ebfc53065d0a87af7ca77 ]

kobject_put() should be used to cleanup the memory associated with the
kobject instead of kobject_del().  See the section "Kobject removal" of
"Documentation/core-api/kobject.rst".

Link: https://lkml.kernel.org/r/20210629022556.3985106-7-sunnanyong@huawei.com
Link: https://lkml.kernel.org/r/1625651306-10829-7-git-send-email-konishi.ryusuke@gmail.com
Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index 44b9ad70a564..57afd06db62d 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -215,7 +215,7 @@ int nilfs_sysfs_create_snapshot_group(struct nilfs_root *root)
 
 void nilfs_sysfs_delete_snapshot_group(struct nilfs_root *root)
 {
-	kobject_del(&root->snapshot_kobj);
+	kobject_put(&root->snapshot_kobj);
 }
 
 /************************************************************************
-- 
2.30.2

