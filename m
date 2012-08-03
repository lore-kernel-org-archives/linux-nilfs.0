From: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Subject: [PATCH v2 5/7] nilfs-utils: fsck: modify =?UTF-8?Q?check=5Fmount?=
 =?UTF-8?Q?=28=29=20function=20with=20the=20purpose=20of=20adding=20opport?=
 =?UTF-8?Q?unity=20of=20RO=20mount=20checking?=
Date: Fri, 03 Aug 2012 07:56:37 -0600
Message-ID: <32bb508a95174ddd801dd8ce114152f3@dubeyko.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Message-ID:Subject:Cc:To:From:Date:Content-Transfer-Encoding:Content-Type:MIME-Version; bh=3OCDlShB5fHRMmOO9wJFz2Wk8UZTIg08PnlsL5VUNAg=;
	b=AkgS21XNhQ+JyeEizPpTe47lRWqMSjPQsu2JYIwL16pWKXxQTVfvBxTV6sZMX5boelLfxtQ2tIf1p/RI/EV3W7q9ny6iwaFW2ObzgxTjN+m1Y3SJpT8cbP4n4hvBksca;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

Hi,

This patch modifies check_mount() function with the purpose of adding 
opportunity of RO mount checking.

With the best regards,
Vyacheslav Dubeyko.
--
 From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 5/7] nilfs-utils: fsck: modify check_mount() 
function with the purpose of adding opportunity of RO mount checking

This patch modifies check_mount() function with the purpose of adding 
opportunity of RO mount checking.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
diff --git a/lib/ismounted.c b/lib/ismounted.c
index 7c5f0fc..d16dce9 100644
--- a/lib/ismounted.c
+++ b/lib/ismounted.c
@@ -31,6 +31,15 @@

  #define LINE_BUFFER_SIZE       256  /* Line buffer size for reading 
mtab */

+/*
+ * check_mount - Check that device mounted or not.
+ * @device: pointer on device.
+ *
+ * Return value:
+ * 0 - device is not mounted.
+ * -1 - device is mounted in RW mode.
+ * -2 - device is mounted in RO mode.
+ */
  int check_mount(const char *device)
  {
         struct mntent *mnt;
@@ -38,6 +47,7 @@ int check_mount(const char *device)
         FILE *f;
         dev_t file_dev = 0, file_rdev = 0;
         ino_t file_ino = 0;
+       int mount_type = 0;

         f = setmntent(_PATH_MOUNTED, "r");
         if (f == NULL) {
@@ -71,6 +81,9 @@ int check_mount(const char *device)
                 }
         }

+       if (mnt)
+               mount_type = (hasmntopt(mnt, MNTOPT_RO)) ? -2 : -1;
+
         endmntent(f);
-       return (mnt == NULL) ? 0 : -1;
+       return (mnt == NULL) ? 0 : mount_type;
  }
--

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
