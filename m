From: Yangtao Li <frank.li-DGpbCiVdSXo@public.gmane.org>
Subject: [PATCH v2, RESEND 10/10] nilfs2: convert to kobject_del_and_put()
Date: Sun, 19 Mar 2023 17:26:41 +0800
Message-ID: <20230319092641.41917-10-frank.li@vivo.com>
References: <20230319092641.41917-1-frank.li@vivo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WayaedDV/a0VW4u6mHDaeEBAtKbErUi9bs6Ndywk30M=;
 b=qZHbrM6MC4YkPV/7OmL/AH5SunaCkm92WJvCbppx3BV2kIJDFZXD5UTuBSJSlzebklcSle+h+3iOBOMGOaIj1gk2tGHjAQp1VStrgD76cCNQ52mLJLuO8TRFiNyXqqxjzaSiUloY8ZjF2RjYcUFgggD+z9GEckfJxw0oCstsexNdLD2sHlLFTNtVRM9XYHMEqktHD9a2bcNirBdBVHUnJcBSVKZ7QxI1hTXUNwDmz80dEW/UrgmaIZOlVg2aEc0l4M000srFoeFkIu7vKnUNPlc7+4RG9r+sh/VhnBVtkqXchSjCAuyThP7plvHuHZQB1u7ujvbACR9LXTym9InJCw==
In-Reply-To: <20230319092641.41917-1-frank.li-DGpbCiVdSXo@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yangtao Li <frank.li-DGpbCiVdSXo@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Use kobject_del_and_put() to simplify code.

Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Yangtao Li <frank.li-DGpbCiVdSXo@public.gmane.org>
---
 fs/nilfs2/sysfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index 379d22e28ed6..150965d58ca5 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -1042,8 +1042,7 @@ void nilfs_sysfs_delete_device_group(struct the_nilfs *nilfs)
 	nilfs_sysfs_delete_segments_group(nilfs);
 	nilfs_sysfs_delete_superblock_group(nilfs);
 	nilfs_sysfs_delete_segctor_group(nilfs);
-	kobject_del(&nilfs->ns_dev_kobj);
-	kobject_put(&nilfs->ns_dev_kobj);
+	kobject_del_and_put(&nilfs->ns_dev_kobj);
 	kfree(nilfs->ns_dev_subgroups);
 }
 
-- 
2.35.1

