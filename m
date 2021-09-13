From: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH AUTOSEL 5.13 15/19] nilfs2: fix NULL pointer in nilfs_##name##_attr_release
Date: Mon, 13 Sep 2021 18:34:11 -0400
Message-ID: <20210913223415.435654-15-sashal@kernel.org>
References: <20210913223415.435654-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572476;
        bh=NI5vzxRA4xOIRgELtpOvzWbw+aq+beXD8MEhnlnKu50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u/8Pq/fbkm6foNQcQXVIz5Tw8fKngPIrYD50jTrUu5EHdDh3vcjkArd9tQ1KqlK4t
         +qtmVLUrhclPnK3YVDM7rdEKX2ywKjKYa+7VGBvlLiaIowyQqEZcrL8az1Fr1USEsv
         Rt+zsniquVWbqJh2Khoi9jkHtMgM7rqAlIX2vOeZpqVvRx1Ur0rzxnTsPbgiRQrNz8
         y0lbFXVljFphP8QZCrhnB00icxqV8jqkBrTM/EQn08T0sEK3YsEVzDxdVrTIGkhaVs
         BGAitm1bsC495cNUXEgPqAvmGch788nfAEIgoLiJWxRLaywxU7mehmWkCm7VBHWD00
         6waTyHDvo1vqw==
In-Reply-To: <20210913223415.435654-1-sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Nanyong Sun <sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Nanyong Sun <sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

[ Upstream commit dbc6e7d44a514f231a64d9d5676e001b660b6448 ]

In nilfs_##name##_attr_release, kobj->parent should not be referenced
because it is a NULL pointer.  The release() method of kobject is always
called in kobject_put(kobj), in the implementation of kobject_put(), the
kobj->parent will be assigned as NULL before call the release() method.
So just use kobj to get the subgroups, which is more efficient and can fix
a NULL pointer reference problem.

Link: https://lkml.kernel.org/r/20210629022556.3985106-3-sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Link: https://lkml.kernel.org/r/1625651306-10829-3-git-send-email-konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Signed-off-by: Nanyong Sun <sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Signed-off-by: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Signed-off-by: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 fs/nilfs2/sysfs.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index b6a48492fed2..43f660beb9b4 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -64,11 +64,9 @@ static const struct sysfs_ops nilfs_##name##_attr_ops = { \
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

