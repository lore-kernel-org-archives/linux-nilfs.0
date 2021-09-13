From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.14 23/25] nilfs2: fix memory leak in nilfs_sysfs_delete_##name##_group
Date: Mon, 13 Sep 2021 18:33:37 -0400
Message-ID: <20210913223339.435347-23-sashal@kernel.org>
References: <20210913223339.435347-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572451;
        bh=SWpGI+SH78dd0NC5kpeEA6SxFm1ZXeG3u+T33maKLEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lrelXSpwtapAXOsnDgfnjrzTHhGfIemUIsihY2vExzd51CQ2R4Tygz+5R/TUrK2xx
         rbo6vkwNiVWf/PZi/KI8xnnNViZUj7Hj5WGY0FKVPIBayTfoyIY7Eb2aR/L7MrGYEp
         3coqAdhLm1UFGH7WwUyo6FAuYg9SwID64NYER7unoJQJ7sjbuiYOlBECyLbrSKepcR
         vhppbFqTbk37y9los2SVEavfiKNd7OccOAcbUO2M+3OfgfJDwW7AkhhiIYQSAUNOsx
         uWDzcocDonl1bfXBbOct34XmMO3JYoHxbLjnPam3eycNAdqoSLT7UI4q4U1rD78CHN
         vq0Hx1LpZ4Cfg==
In-Reply-To: <20210913223339.435347-1-sashal@kernel.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Nanyong Sun <sunnanyong@huawei.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Sasha Levin <sashal@kernel.org>, linux-nilfs@vger.kernel.org

From: Nanyong Sun <sunnanyong@huawei.com>

[ Upstream commit a3e181259ddd61fd378390977a1e4e2316853afa ]

The kobject_put() should be used to cleanup the memory associated with the
kobject instead of kobject_del.  See the section "Kobject removal" of
"Documentation/core-api/kobject.rst".

Link: https://lkml.kernel.org/r/20210629022556.3985106-5-sunnanyong@huawei.com
Link: https://lkml.kernel.org/r/1625651306-10829-5-git-send-email-konishi.ryusuke@gmail.com
Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index 6305e4ef7e39..d989e6500bd7 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -84,7 +84,7 @@ static int nilfs_sysfs_create_##name##_group(struct the_nilfs *nilfs) \
 } \
 static void nilfs_sysfs_delete_##name##_group(struct the_nilfs *nilfs) \
 { \
-	kobject_del(&nilfs->ns_##parent_name##_subgroups->sg_##name##_kobj); \
+	kobject_put(&nilfs->ns_##parent_name##_subgroups->sg_##name##_kobj); \
 }
 
 /************************************************************************
-- 
2.30.2

