From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v2 3/4] nilfs2: Switch to use %ptTs
Date: Tue, 11 May 2021 18:39:57 +0300
Message-ID: <20210511153958.34527-3-andriy.shevchenko@linux.intel.com>
References: <20210511153958.34527-1-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20210511153958.34527-1-andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, JC Kuo <jckuo-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Sumit Garg <sumit.garg-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kgdb-bugreport-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Mathias Nyman <mathias.nyman-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Thierry Reding <thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jonathan Hunter <jonathanh-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Wessel <jason.wessel-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>, Daniel Thompson <daniel.thompson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Douglas Anderson <dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

Use %ptTs instead of open coded variant to print contents
of time64_t type in human readable form.

Use sysfs_emit() at the same time in the changed functions.

Cc: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Reviewed-by: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
---
v2: collected tags
 fs/nilfs2/sysfs.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index 303d71430bdd..4e10423f0448 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -19,19 +19,6 @@
 /* /sys/fs/<nilfs>/ */
 static struct kset *nilfs_kset;
 
-#define NILFS_SHOW_TIME(time_t_val, buf) ({ \
-		struct tm res; \
-		int count = 0; \
-		time64_to_tm(time_t_val, 0, &res); \
-		res.tm_year += 1900; \
-		res.tm_mon += 1; \
-		count = scnprintf(buf, PAGE_SIZE, \
-				    "%ld-%.2d-%.2d %.2d:%.2d:%.2d\n", \
-				    res.tm_year, res.tm_mon, res.tm_mday, \
-				    res.tm_hour, res.tm_min, res.tm_sec);\
-		count; \
-})
-
 #define NILFS_DEV_INT_GROUP_OPS(name, parent_name) \
 static ssize_t nilfs_##name##_attr_show(struct kobject *kobj, \
 					struct attribute *attr, char *buf) \
@@ -576,7 +563,7 @@ nilfs_segctor_last_seg_write_time_show(struct nilfs_segctor_attr *attr,
 	ctime = nilfs->ns_ctime;
 	up_read(&nilfs->ns_segctor_sem);
 
-	return NILFS_SHOW_TIME(ctime, buf);
+	return sysfs_emit(buf, "%ptTs\n", &ctime);
 }
 
 static ssize_t
@@ -604,7 +591,7 @@ nilfs_segctor_last_nongc_write_time_show(struct nilfs_segctor_attr *attr,
 	nongc_ctime = nilfs->ns_nongc_ctime;
 	up_read(&nilfs->ns_segctor_sem);
 
-	return NILFS_SHOW_TIME(nongc_ctime, buf);
+	return sysfs_emit(buf, "%ptTs\n", &nongc_ctime);
 }
 
 static ssize_t
@@ -724,7 +711,7 @@ nilfs_superblock_sb_write_time_show(struct nilfs_superblock_attr *attr,
 	sbwtime = nilfs->ns_sbwtime;
 	up_read(&nilfs->ns_sem);
 
-	return NILFS_SHOW_TIME(sbwtime, buf);
+	return sysfs_emit(buf, "%ptTs\n", &sbwtime);
 }
 
 static ssize_t
-- 
2.30.2

