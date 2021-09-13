From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 09/12] nilfs2: fix memory leak in nilfs_sysfs_create_##name##_group
Date: Mon, 13 Sep 2021 18:35:01 -0400
Message-ID: <20210913223504.436087-9-sashal@kernel.org>
References: <20210913223504.436087-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572517;
        bh=MZHPjOgSScrm6cdhIJYO2FUe0kknctPwkqVKbwsVvUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FphPETujj1VhTU0+PD9cbWABgXcM5IPxGT+NfXtpgveoccZ+I3wWdtTy3oF7U9I+j
         o2W5gYR3glORrOCz9EExrl6+kHJEoCZszzeSIcHJcwjuKHMwaGqXhW6mgTwKz4FA1e
         gkBM6geuKvsXOWIhnHM/1w40g4SE9zZ5S9Idsu+OaeNvQWX3bz9bsY2xU6mtyLWW94
         DzPO6bvVtmULlJzSpOB865iCvpuwUPF6tpnX5eXgz7ao56R8hotaVU+Oqp21mGu+zY
         cXghEVON5PnihTLDglIXGPuLOXfxPc3XE1kRNrIp+34riYdi88B+y2Sd7/eMWbDInA
         uuu/FFYxZqrfg==
In-Reply-To: <20210913223504.436087-1-sashal@kernel.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Nanyong Sun <sunnanyong@huawei.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Sasha Levin <sashal@kernel.org>, linux-nilfs@vger.kernel.org

From: Nanyong Sun <sunnanyong@huawei.com>

[ Upstream commit 24f8cb1ed057c840728167dab33b32e44147c86f ]

If kobject_init_and_add return with error, kobject_put() is needed here to
avoid memory leak, because kobject_init_and_add may return error without
freeing the memory associated with the kobject it allocated.

Link: https://lkml.kernel.org/r/20210629022556.3985106-4-sunnanyong@huawei.com
Link: https://lkml.kernel.org/r/1625651306-10829-4-git-send-email-konishi.ryusuke@gmail.com
Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index ca720d958315..31d640a87b59 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -92,8 +92,8 @@ static int nilfs_sysfs_create_##name##_group(struct the_nilfs *nilfs) \
 	err = kobject_init_and_add(kobj, &nilfs_##name##_ktype, parent, \
 				    #name); \
 	if (err) \
-		return err; \
-	return 0; \
+		kobject_put(kobj); \
+	return err; \
 } \
 static void nilfs_sysfs_delete_##name##_group(struct the_nilfs *nilfs) \
 { \
-- 
2.30.2

