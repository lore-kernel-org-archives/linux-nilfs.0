From: Yangtao Li <frank.li-DGpbCiVdSXo@public.gmane.org>
Subject: [RESEND,PATCH v2 10/10] nilfs2: convert to kobject_del_and_put()
Date: Tue, 21 Mar 2023 02:47:29 +0800
Message-ID: <20230320184730.56475-9-frank.li@vivo.com>
References: <20230320184730.56475-1-frank.li@vivo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YeSXbiSKn/Htu8RDFyUlihMaEwMnfwHjUTJcCENoL/A=;
 b=kDeD+jMjL4Hor89FZpdLKWL+Byaf/dxFZiUqOh9KskRW/VXim1KRKpb7PIL97Hl/91BlIJ0hevA3Rp3Daz9T/T4/WalOsFMDWDAz9C6nMFn6PjBgmBtDg2/03BbnevqxKkqJEoPJgM27cASndEoJNt2sLLkbfe+vyXpxQw9gWeLxoCO3UZ8ItHhmTCg4V21a4XUhyPnZf1mIrm8vNoBYw3frBT3XuYF6RcS/RjfyhjRG0H2o7nehv1Xdtd01bMYKXlQt0qCeJqO5LJalD1GR8ImKyfQFF5V/LDeltsdLN97FAQrD88Ksq9npfnKwSwLpG7K7IIcidGUwbL94nJ9fBg==
In-Reply-To: <20230320184730.56475-1-frank.li-DGpbCiVdSXo@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yangtao Li <frank.li-DGpbCiVdSXo@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Damien Le Moal <damien.lemoal-yzvPICuk2AC/Fx7ZUtofftBPR1lH4CV8@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Use kobject_del_and_put() to simplify code.

Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Damien Le Moal <damien.lemoal-yzvPICuk2AC/Fx7ZUtofftBPR1lH4CV8@public.gmane.org>
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

