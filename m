From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 06/11] nilfs-utils: fsck: modify check_mount() function with the purpose of adding opportunity of RO mount checking
Date: Wed, 5 Sep 2012 23:14:49 +0400
Message-ID: <2A4C3DC1-F84D-41FB-85C4-246C85C5DFFB@dubeyko.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:To:Message-Id:Date:Subject:Content-Transfer-Encoding:Content-Type:From; bh=CTB2+J3Eat2TYRignW1vug3hRrXxMsbcYdOpKSa1a2s=;
	b=X3w/CynJaO4h/I4iJvolZGLSVzm7zJxLDKCzBKDtOOcuKRjnC0UB6fet0kkgk3FPQIgPG6Ce/a8r34bXku0m26CkYfOZyGDGZnhtM+gq5LXzR0PuSVHIjzUNLInG9+da;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

This patch modifies check_mount() function with the purpose of adding opportunity of RO mount checking.

With the best regards,
Vyacheslav Dubeyko.
--
From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 06/11] nilfs-utils: fsck: modify check_mount() function with the purpose of adding opportunity of RO mount checking

This patch modifies check_mount() function with the purpose of adding opportunity of RO mount checking.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
 lib/ismounted.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/lib/ismounted.c b/lib/ismounted.c
index 7c5f0fc..d16dce9 100644
--- a/lib/ismounted.c
+++ b/lib/ismounted.c
@@ -31,6 +31,15 @@
 
 #define LINE_BUFFER_SIZE	256  /* Line buffer size for reading mtab */
 
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
+	int mount_type = 0;
 
 	f = setmntent(_PATH_MOUNTED, "r");
 	if (f == NULL) {
@@ -71,6 +81,9 @@ int check_mount(const char *device)
 		}
 	}
 
+	if (mnt)
+		mount_type = (hasmntopt(mnt, MNTOPT_RO)) ? -2 : -1;
+
 	endmntent(f);
-	return (mnt == NULL) ? 0 : -1;
+	return (mnt == NULL) ? 0 : mount_type;
 }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
