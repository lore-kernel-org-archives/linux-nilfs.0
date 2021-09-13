From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 8/9] nilfs2: fix memory leak in nilfs_sysfs_create_snapshot_group
Date: Mon, 13 Sep 2021 18:35:34 -0400
Message-ID: <20210913223535.436405-8-sashal@kernel.org>
References: <20210913223535.436405-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572547;
        bh=DTLkUcX8uZmbCVP4ckZc+XfsJHIBYPUK8tiOu761O4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HLnNJWzKv2KrcO9cjOvUWhqq3Mbf+pxWbczmvWBzObYr3s1D9zmkIIYOYzuTyodfc
         EingDB3ZPiKyn8+Rs9FaQ3/q3GW8Wa+NBAkZq/ohqqL4hYWA/Nt2IDoDAOeaHk92oi
         npCpvGHpbHZW5XIXKPBOvCYWUrYssxaZ9T7fAfX1CuDxwhMhI3zPMq1et0vfZb8NGj
         ytx8GXaYGQsOJTjLgdGVtL4DXIkvzDJxnbxSMXPYv/v835ErvW1G9xiimJpas1mAlb
         6h+xtWNqTOUjY3EzbqBCb5YuENpTsHeoNM362g30fw7S+kEH3Wss7RpodstLGC60dj
         rJhJaf4rHfhQg==
In-Reply-To: <20210913223535.436405-1-sashal@kernel.org>
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
index 31eed118d0ce..28f5572c6aae 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -217,9 +217,9 @@ int nilfs_sysfs_create_snapshot_group(struct nilfs_root *root)
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

