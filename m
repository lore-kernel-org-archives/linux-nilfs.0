From: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH AUTOSEL 4.14 7/9] nilfs2: fix memory leak in nilfs_sysfs_delete_##name##_group
Date: Mon, 13 Sep 2021 18:35:33 -0400
Message-ID: <20210913223535.436405-7-sashal@kernel.org>
References: <20210913223535.436405-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572545;
        bh=qmwpcNHmEWuMzPfSNlDTsweTD3lan5X1LDgDZlx7Zt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FTJ53fisMfJrfVay/E8xRZs6jmdjZPXIhK6QCoDMG2sJI4yh6te5NLCiavMos0kG7
         1CwAdO6wtdo0t8q/2otOX1BML83iPkVYmap3HJk6AbGRZW8h6y0OZgWo6WX6N9jwP6
         qt44598NaYI1y6QBkuHpRmkdhebDRLV/HMznYFj9HK6ZugF17i3eBlOqIqtfGemweg
         cDweRN164EXPwUS61kVe+Eqls1o2gZioZhLQE8ZGkeMnqE9+aMEWrd6A3SuG73dbun
         fq0rki+ppypy1Es98H+5jNi0DQR/2c/K08eyu4Jjw7G0I6NcEr8uRc1X+gM33W3hxG
         Ijpk5q9PDfrIA==
In-Reply-To: <20210913223535.436405-1-sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Nanyong Sun <sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Nanyong Sun <sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

[ Upstream commit a3e181259ddd61fd378390977a1e4e2316853afa ]

The kobject_put() should be used to cleanup the memory associated with the
kobject instead of kobject_del.  See the section "Kobject removal" of
"Documentation/core-api/kobject.rst".

Link: https://lkml.kernel.org/r/20210629022556.3985106-5-sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Link: https://lkml.kernel.org/r/1625651306-10829-5-git-send-email-konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Signed-off-by: Nanyong Sun <sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Signed-off-by: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Signed-off-by: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 fs/nilfs2/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index eab7bd68da12..31eed118d0ce 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -106,7 +106,7 @@ static int nilfs_sysfs_create_##name##_group(struct the_nilfs *nilfs) \
 } \
 static void nilfs_sysfs_delete_##name##_group(struct the_nilfs *nilfs) \
 { \
-	kobject_del(&nilfs->ns_##parent_name##_subgroups->sg_##name##_kobj); \
+	kobject_put(&nilfs->ns_##parent_name##_subgroups->sg_##name##_kobj); \
 }
 
 /************************************************************************
-- 
2.30.2

