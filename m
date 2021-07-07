From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: [PATCH 0/6] nilfs2: fix incorrect usage of kobject
Date: Wed,  7 Jul 2021 18:48:20 +0900
Message-ID: <1625651306-10829-1-git-send-email-konishi.ryusuke@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Cc+gCUPAZx+LyHdRSTQp6eiJxr/vq/O0gj+XZ0T3Lwo=;
        b=Sl82vp63dbbtc98hScOpOoPm+YleBTjm06dkdaLTpKDFd+yw71TST/kzJQNi+ikJ6C
         1aUNEMFLFuissBMN+DaZgVgGtoWIPz5MDHjHJWHtZW8i/AbjJER7giD8l26f7T+lzU6w
         zNj7yOd240mm+V5eDR4jjkOXKP5zHtnkrQU/aQGRKkQKk0UzlTepemzQhCHvcAF3NgQD
         /7hr1/cYSHlFBL2Z+wwwgAT8MZGkaU3ggkklqBlY1LQMIm6pU5ixya00yJfO0JH6i/Rt
         MXnnBlOQdYypQOnEKv7YLg6hTlQjZ6z+EEbX6Q4divuftRHLo+VceRJSVTImfbmd9CLE
         0VYg==
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

Hi Andrew,

Please send the following patchset to upstream.

Nanyong Sun (6):
  nilfs2: fix memory leak in nilfs_sysfs_create_device_group
  nilfs2: fix NULL pointer in nilfs_##name##_attr_release
  nilfs2: fix memory leak in nilfs_sysfs_create_##name##_group
  nilfs2: fix memory leak in nilfs_sysfs_delete_##name##_group
  nilfs2: fix memory leak in nilfs_sysfs_create_snapshot_group
  nilfs2: fix memory leak in nilfs_sysfs_delete_snapshot_group

This patchset from Nanyong Sun fixes memory leak issues and a NULL
pointer dereference issue caused by incorrect usage of kboject in
nilfs2 sysfs implementation.

Thanks,
Ryusuke Konishi
--
 fs/nilfs2/sysfs.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

-- 
1.8.3.1

