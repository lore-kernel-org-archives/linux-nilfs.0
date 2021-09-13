From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 5/9] nilfs2: fix NULL pointer in nilfs_##name##_attr_release
Date: Mon, 13 Sep 2021 18:35:45 -0400
Message-ID: <20210913223549.436541-5-sashal@kernel.org>
References: <20210913223549.436541-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572556;
        bh=fCO9R0/Qxe84dd91lwRnKAl4EqdMlH58wnSc69yN0b8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z1/Td05/IeF9vvMegJjbIr5Ju4qBBu85TQNksFr6oMlgYjJ6/u3AnT+mNycvPSJ0q
         h5QPXIM0y4RGICjgU3nFRz+399m+rvzl5hvI2zUHlgk3hkteUNL7W/qe1JxH+7dE3V
         lwoelrPenFzG5RD6DBi6xBQJDNPws5NihQTp3scqY+OHgEId3UoCYNjGNlYaKGHEDU
         61wEABfB63ieIwc2n2uX6XL6G9MK34Of4LHEv0OvOFru92HqiMTvNUTIr5p+6d+oLz
         3WJlzDVQtN1hkBoyYNmfx/06rvR+9WOtEwt1rL14eLBGBpF2gUzWDQzw10wZMwNTvE
         a1QXoHIazi7JA==
In-Reply-To: <20210913223549.436541-1-sashal@kernel.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Nanyong Sun <sunnanyong@huawei.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Sasha Levin <sashal@kernel.org>, linux-nilfs@vger.kernel.org

From: Nanyong Sun <sunnanyong@huawei.com>

[ Upstream commit dbc6e7d44a514f231a64d9d5676e001b660b6448 ]

In nilfs_##name##_attr_release, kobj->parent should not be referenced
because it is a NULL pointer.  The release() method of kobject is always
called in kobject_put(kobj), in the implementation of kobject_put(), the
kobj->parent will be assigned as NULL before call the release() method.
So just use kobj to get the subgroups, which is more efficient and can fix
a NULL pointer reference problem.

Link: https://lkml.kernel.org/r/20210629022556.3985106-3-sunnanyong@huawei.com
Link: https://lkml.kernel.org/r/1625651306-10829-3-git-send-email-konishi.ryusuke@gmail.com
Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/sysfs.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index a35978bf8395..027a50bc0765 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -73,11 +73,9 @@ static const struct sysfs_ops nilfs_##name##_attr_ops = { \
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
2.30.2

