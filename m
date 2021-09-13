From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 10/10] nilfs2: fix memory leak in nilfs_sysfs_delete_snapshot_group
Date: Mon, 13 Sep 2021 18:35:21 -0400
Message-ID: <20210913223521.436250-10-sashal@kernel.org>
References: <20210913223521.436250-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572534;
        bh=eQ3LCeWRN8D9/OAav1FmOG19LmXMe7aLh9WavSLwbbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lXyiAp8CFQDAv0zh1lHyB5gnx5FpBtFZcsF9jboM6Q7lsLF/bq+dtrdXlL5tXglji
         q5+acPXetHPw0WgpgZglSh9k8ydcB6Vwi5tHtyOvg/88EYMx7fDgCqrp3VFcuYad92
         IhHa8nPpuJyZS/g2SoD+RHbddIWKYqCJSk/Cdvp/Z31LCFUUDqCsSFZOSwQiPkOE/7
         GMNq4PTirJXwteW6sJDm9GxJaYuOpgldpebmksMDbeT5Q7E3ELOUxZb8QBCBDN8LkI
         2wh0PhcCq4VYUBZF6yUzszj/1+/dQLR4Di7gTVQT2Ab9MFfDYJrEkXotZyAIoEtx6X
         1MWkI6MUlLrsA==
In-Reply-To: <20210913223521.436250-1-sashal@kernel.org>
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
index 6c92ac314b06..28a2db3b1787 100644
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

