From: Nanyong Sun <sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/6] nilfs2: fix incorrect usage of kobject
Date: Tue, 29 Jun 2021 10:25:50 +0800
Message-ID: <20210629022556.3985106-1-sunnanyong@huawei.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

This patchset fix the memory leak problems and NULL pointer problem
caused by incorrect usage of kobject in nilfs2 sysfs driver.

Nanyong Sun (6):
  nilfs2: fix memory leak in nilfs_sysfs_create_device_group
  nilfs2: fix NULL pointer in nilfs_##name##_attr_release
  nilfs2: fix memory leak in nilfs_sysfs_create_##name##_group
  nilfs2: fix memory leak in nilfs_sysfs_delete_##name##_group
  nilfs2: fix memory leak in nilfs_sysfs_create_snapshot_group
  nilfs2: fix memory leak in nilfs_sysfs_delete_snapshot_group

 fs/nilfs2/sysfs.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

-- 
2.18.0.huawei.25

