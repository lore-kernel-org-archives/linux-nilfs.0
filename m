From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: [PATCH 2/6] nilfs2: fix NULL pointer in nilfs_##name##_attr_release
Date: Wed,  7 Jul 2021 18:48:22 +0900
Message-ID: <1625651306-10829-3-git-send-email-konishi.ryusuke@gmail.com>
References: <1625651306-10829-1-git-send-email-konishi.ryusuke@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nDphwP7rk7MVmmwi41RmQwruvzgJtyrk5UC8vBfmCnU=;
        b=HAwqV7SRwg6Bmoo+IUskz5DjJH8OArmVvNbXrAsMJFs1WKQPXL4k8BMKwnvr8tsADx
         V+Kss4NWm4EsIyxBLRXjn20jxwQac+LwPilRbQCebnzRO9fHHDPUfsOLIyd1aflsfhrY
         eZRG9VycHCBnh9ASsKcssnV5YuYaHu7v5YQ9E0AL7uLvzx/E3KFR4DhrMCg7dAm/GuNX
         XSFQYJF47N/D9cKiDGVJEzWca8GP3OU8YxzWzS9DKK9tR7P0gc+uvIeEXzxjB/J1O3W5
         J7Zj9lYBjV0FGeERQcv0rBKI2/E6tv32w3NdOFSSr+kxAI7duSNB5bg/mAKgPGnfaSjh
         LJYA==
In-Reply-To: <1625651306-10829-1-git-send-email-konishi.ryusuke@gmail.com>
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

From: Nanyong Sun <sunnanyong@huawei.com>

In nilfs_##name##_attr_release, kobj->parent should not be
referenced because it is a NULL pointer. The release() method of
kobject is always called in kobject_put(kobj), in the implementation
of kobject_put(), the kobj->parent will be assigned as NULL before
call the release() method. So just use kobj to get the subgroups,
which is more efficient and can fix a NULL pointer reference problem.

Link: https://lkml.kernel.org/r/20210629022556.3985106-3-sunnanyong@huawei.com
Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/sysfs.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index b6a48492fed2..43f660beb9b4 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -64,11 +64,9 @@
 #define NILFS_DEV_INT_GROUP_TYPE(name, parent_name) \
 static void nilfs_##name##_attr_release(struct kobject *kobj) \
 { \
-	struct nilfs_sysfs_##parent_name##_subgroups *subgroups; \
-	struct the_nilfs *nilfs = container_of(kobj->parent, \
-						struct the_nilfs, \
-						ns_##parent_name##_kobj); \
-	subgroups = nilfs->ns_##parent_name##_subgroups; \
+	struct nilfs_sysfs_##parent_name##_subgroups *subgroups = container_of(kobj, \
+						struct nilfs_sysfs_##parent_name##_subgroups, \
+						sg_##name##_kobj); \
 	complete(&subgroups->sg_##name##_kobj_unregister); \
 } \
 static struct kobj_type nilfs_##name##_ktype = { \
-- 
1.8.3.1

