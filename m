From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 7/8] nilfs2: fix memory leak in nilfs_sysfs_create_snapshot_group
Date: Mon, 13 Sep 2021 18:36:00 -0400
Message-ID: <20210913223601.436675-7-sashal@kernel.org>
References: <20210913223601.436675-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572571;
        bh=ekuu+j5sqteKEeoM1Rl8ALM+PbUP6fGe4Cn6hDSMX+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MHWdVTWoGjGSU3MBopymatCBLKgoi/k29Wswk+Go+0c+svgRWTwoIpKoaGqRtwRpm
         cfOri/Lh77HRs7xj2RSzDMqrVFLNsG+2ftOM+2x8mVmsCF3c18Kc/USJcqHxf0meUj
         Dsi/mb0eST/kxJ7cGZ3bBzoYcXeqB2u6uityFlSw8UrWJQPalhCMTuLgsuDOBa2Aoq
         2xanY1rZffoaZRHECl/WfG/yQDU31D0hVQvT53PgktXRK1AHTfj7ijL/QwYCGTq8WR
         dobERjFZZoD1Has6PVG+SIJLswisdQJ79+hTuDOSTHlNdQabOkPPT8fuCixfmgSm74
         +D3vQ2DADrwlw==
In-Reply-To: <20210913223601.436675-1-sashal@kernel.org>
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
index 8a0af1e378c1..73d872a24a21 100644
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

