From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH v4 2/6] nilfs-utils: add NILFS_OPT_SET_SUINFO
Date: Wed,  5 Feb 2014 03:16:35 +0100
Message-ID: <a55d555da27aea71386cfe777a0adec95e6ded2e.1391566347.git.andreas.rohner@gmx.net>
References: <20140205.034242.281476472.konishi.ryusuke@lab.ntt.co.jp>
 <cover.1391566347.git.andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1391566347.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
In-Reply-To: <cover.1391566347.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
References: <cover.1391566347.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

This option for the nilfs object corresponds to the use_set_suinfo
flag in the configuration file. This patch adds the flag itself
plus some convenience functions.

The option is set after the configuration file was read in.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 include/nilfs.h          |  7 ++++++-
 lib/nilfs.c              | 28 ++++++++++++++++++++++++++++
 sbin/cleanerd/cleanerd.c |  6 ++++++
 3 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/include/nilfs.h b/include/nilfs.h
index 56286a9..b5f85d3 100644
--- a/include/nilfs.h
+++ b/include/nilfs.h
@@ -128,7 +128,8 @@ struct nilfs {
 #define NILFS_OPEN_RDWR		0x0008	/* Open NILFS API in read/write mode */
 #define NILFS_OPEN_GCLK		0x1000	/* Open GC lock primitive */
 
-#define NILFS_OPT_MMAP	0x01
+#define NILFS_OPT_MMAP		0x01
+#define NILFS_OPT_SET_SUINFO	0x02
 
 
 struct nilfs *nilfs_open(const char *, const char *, int);
@@ -140,6 +141,10 @@ void nilfs_opt_clear_mmap(struct nilfs *);
 int nilfs_opt_set_mmap(struct nilfs *);
 int nilfs_opt_test_mmap(struct nilfs *);
 
+void nilfs_opt_clear_set_suinfo(struct nilfs *);
+int nilfs_opt_set_set_suinfo(struct nilfs *);
+int nilfs_opt_test_set_suinfo(struct nilfs *);
+
 nilfs_cno_t nilfs_get_oldest_cno(struct nilfs *);
 
 struct nilfs_super_block *nilfs_get_sb(struct nilfs *);
diff --git a/lib/nilfs.c b/lib/nilfs.c
index c1771e8..93822de 100644
--- a/lib/nilfs.c
+++ b/lib/nilfs.c
@@ -288,6 +288,34 @@ int nilfs_opt_test_mmap(struct nilfs *nilfs)
 	return !!(nilfs->n_opts & NILFS_OPT_MMAP);
 }
 
+/**
+ * nilfs_opt_set_set_suinfo - set set_suinfo option
+ * @nilfs: nilfs object
+ */
+int nilfs_opt_set_set_suinfo(struct nilfs *nilfs)
+{
+	nilfs->n_opts |= NILFS_OPT_SET_SUINFO;
+	return 0;
+}
+
+/**
+ * nilfs_opt_clear_set_suinfo - clear set_suinfo option
+ * @nilfs: nilfs object
+ */
+void nilfs_opt_clear_set_suinfo(struct nilfs *nilfs)
+{
+	nilfs->n_opts &= ~NILFS_OPT_SET_SUINFO;
+}
+
+/**
+ * nilfs_opt_test_set_suinfo - test whether set_suinfo option is set or not
+ * @nilfs: nilfs object
+ */
+int nilfs_opt_test_set_suinfo(struct nilfs *nilfs)
+{
+	return !!(nilfs->n_opts & NILFS_OPT_SET_SUINFO);
+}
+
 static int nilfs_open_sem(struct nilfs *nilfs)
 {
 	char semnambuf[NAME_MAX - 4];
diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
index b441448..970816f 100644
--- a/sbin/cleanerd/cleanerd.c
+++ b/sbin/cleanerd/cleanerd.c
@@ -247,6 +247,12 @@ static int nilfs_cleanerd_config(struct nilfs_cleanerd *cleanerd,
 	else
 		nilfs_opt_clear_mmap(cleanerd->nilfs);
 #endif	/* HAVE_MMAP */
+
+	if (cleanerd->config.cf_use_set_suinfo)
+		nilfs_opt_set_set_suinfo(cleanerd->nilfs);
+	else
+		nilfs_opt_clear_set_suinfo(cleanerd->nilfs);
+
 	nilfs_cleanerd_set_log_priority(cleanerd);
 
 	if (protection_period != ULONG_MAX) {
-- 
1.8.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
