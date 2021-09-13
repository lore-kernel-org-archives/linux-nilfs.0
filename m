From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.13 18/19] nilfs2: fix memory leak in nilfs_sysfs_create_snapshot_group
Date: Mon, 13 Sep 2021 18:34:14 -0400
Message-ID: <20210913223415.435654-18-sashal@kernel.org>
References: <20210913223415.435654-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572480;
        bh=yeR0sBBYZBk2MG5AkY4jMRHn0KfkeEX2jI4zVJjnd54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JXR/acG57LrAAuxnAucxlrn0KtZLn1FFgSv+GJoE6d+kP3TgcrrGEMOLohduTskKA
         B/Yx6sBmQVwRyCtJj1fMLwzvf6RJTzpWfN1k+OaRKMFMoiRWTRgylhpVmT9nHgizG2
         H2oNspq8Hj+QmXn5NJ4h5CNmgl/1L3oJfA5o2liFZ4R35WC+LmC4i37oEn47ozaBHq
         qb4ZTGpkelDswrsLolpAUDqZsG+ylQ63dwTChyaXuTjKKvVmr+Ls5mOXoAHggVy30u
         esUUY7X49G2uhO+Af6Hfw21Bs4yNNkTapbV+rBt0DHGi1WNJOzRyN69tzOHL8/+WSS
         a1FTvAnMS8aZg==
In-Reply-To: <20210913223415.435654-1-sashal@kernel.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Nanyong Sun <sunnanyong@huawei.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Sasha Levin <sashal@kernel.org>, linux-nilfs@vger.kernel.org

From: Nanyong Sun <sunnanyong@huawei.com>

[ Upstream commit b2fe39c248f3fa4bbb2a20759b4fdd83504190f7 ]

If kobject_init_and_add returns with error, kobject_put() is needed here
to avoid memory leak, because kobject_init_and_add may return error
without freeing the memory associated with the kobject it allocated.

Link: https://lkml.kernel.org/r/20210629022556.3985106-6-sunnanyong@huawei.com
Link: https://lkml.kernel.org/r/1625651306-10829-6-git-send-email-konishi.ryusuke@gmail.com
Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index 34893a57a7b9..44b9ad70a564 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -208,9 +208,9 @@ int nilfs_sysfs_create_snapshot_group(struct nilfs_root *root)
 	}
 
 	if (err)
-		return err;
+		kobject_put(&root->snapshot_kobj);
 
-	return 0;
+	return err;
 }
 
 void nilfs_sysfs_delete_snapshot_group(struct nilfs_root *root)
-- 
2.30.2

