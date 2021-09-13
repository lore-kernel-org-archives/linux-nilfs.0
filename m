From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 15/16] nilfs2: fix memory leak in nilfs_sysfs_create_snapshot_group
Date: Mon, 13 Sep 2021 18:34:41 -0400
Message-ID: <20210913223442.435885-15-sashal@kernel.org>
References: <20210913223442.435885-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572502;
        bh=yeR0sBBYZBk2MG5AkY4jMRHn0KfkeEX2jI4zVJjnd54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MptDnEDgvNLl1z+gKqa14qY69ioGD4PMJkObdYcoRDNI0+9xj3YZZz4/o8BCnhWwH
         ZRwC1z2HREGco8iqZlZ8hO/j0gK/J9KyCI8+2iTEVcYZhE1c7oOUoOe2S2bxwFdv3L
         V6wH6r+C96TB6TvvA/61PthIbFGwxWOOKrW7+J79PsLLWkl1/ZD/KV/i3XpvVmtAkd
         zO/F/ink9YTIAK2/4LaU/4glix8447fmzKM/acbKrD6uY/4NDX73wZ0RJfgNia/5nz
         zyEDXbpQFVucogFHcgK8vayhfrmLuTsouHbptbZKbieQPqxordCwFX09AcLiq3VtRJ
         WPsbfJKeCh7xg==
In-Reply-To: <20210913223442.435885-1-sashal@kernel.org>
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

