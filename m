From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] mount.nilfs2: ensure gcpid option is dropped if the value is zero
Date: Thu, 23 Jan 2014 02:18:44 +0900
Message-ID: <1390411124-19356-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Legacy version of mount.nilfs2 and umount.nilfs2 may leave invalid
mount option string "gcpid=0" in /etc/mtab.  This adds a new macro
replace_drop_opt() which replaces or drops mount option based on the
given condition, and uses the macro to ensure the gcpid option will be
deleted when its value equals zero.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 sbin/mount/mount.nilfs2.c  |   22 ++++++----------------
 sbin/mount/mount_opts.h    |   28 ++++++++++++++++++++++++++++
 sbin/mount/umount.nilfs2.c |    4 ++--
 3 files changed, 36 insertions(+), 18 deletions(-)

diff --git a/sbin/mount/mount.nilfs2.c b/sbin/mount/mount.nilfs2.c
index de49513..e1d32a2 100644
--- a/sbin/mount/mount.nilfs2.c
+++ b/sbin/mount/mount.nilfs2.c
@@ -290,20 +290,9 @@ static char *fix_extra_opts_string(const char *exopts, gcpid_opt_t gcpid,
 	pp_opt_t oldpp;
 	gcpid_opt_t oldpid;
 
-	if (gcpid) {
-		s = replace_optval(s, gcpid_opt_fmt, &oldpid, gcpid);
-	} else {
-		/* Remove the gcpid option if gcpid == 0 */
-		s = replace_opt(s, gcpid_opt_fmt, &oldpid, NULL);
-	}
-
-	if (protection_period != ULONG_MAX) {
-		s = replace_optval(s, pp_opt_fmt, &oldpp, protection_period);
-	} else {
-		/* Remove the pp option if pp == ULONG_MAX */
-		s = replace_opt(s, pp_opt_fmt, &oldpp, NULL);
-	}
-
+	s = replace_drop_opt(s, gcpid_opt_fmt, &oldpid, gcpid, gcpid != 0);
+	s = replace_drop_opt(s, pp_opt_fmt, &oldpp, protection_period,
+			     protection_period != ULONG_MAX);
 	return s;
 }
 
@@ -515,8 +504,9 @@ do_mount_one(struct nilfs_mount_info *mi, const struct mount_options *mo)
 				printf(_("%s: restarted %s\n"),
 				       progname, NILFS_CLEANERD_NAME);
 
-			mi->optstr = replace_optval(
-				mi->optstr, gcpid_opt_fmt, &oldpid, mi->gcpid);
+			mi->optstr = replace_drop_opt(
+				mi->optstr, gcpid_opt_fmt, &oldpid, mi->gcpid,
+				mi->gcpid != 0);
 
 			update_mtab_entry(mi->device, mi->mntdir, fstype,
 					  mi->optstr, 0, 0, !mi->mounted);
diff --git a/sbin/mount/mount_opts.h b/sbin/mount/mount_opts.h
index b387da2..cce3856 100644
--- a/sbin/mount/mount_opts.h
+++ b/sbin/mount/mount_opts.h
@@ -43,5 +43,33 @@ int find_opt(const char *opts, const char *token, void *varp);
 char *replace_opt(char *s, const char *fmt, void *varp, const char *instead);
 char *replace_optval(char *s, const char *fmt, void *varp, ...);
 
+/**
+ * replace_drop_opt() - replace or drop mount option string
+ * @str: comma-separated string
+ * @fmt: format string of target option such as "pid=%lu"
+ * @oldvalp: pointer to old value
+ * @newval: new value of option
+ * @cond: condition of mount option manipulation
+ *
+ * replace_drop_opt() finds out an option string matching @fmt in
+ * @str, and replaces value of the option with @newval if @cond is
+ * true or otherwise deletes the whole option string from @str.  In
+ * both cases, old value of the option is saved in @oldvalp, where
+ * @oldvalp must have the type of pointer to a value specified in
+ * @fmt.  If replacement or removal occurs, old @str is automatically
+ * freed.
+ *
+ * Return Value: new options string is retured.
+ */
+#define replace_drop_opt(str, fmt, oldvalp, newval, cond)	\
+({								\
+	char *ret;						\
+	if (cond)						\
+		ret = replace_optval(				\
+			str, fmt, oldvalp, newval);		\
+	else							\
+		ret = replace_opt(str, fmt, oldvalp, NULL);	\
+	ret;							\
+})
 
 #endif /* _MOUNT_OPTS_H */
diff --git a/sbin/mount/umount.nilfs2.c b/sbin/mount/umount.nilfs2.c
index eeffe6e..770c9d1 100644
--- a/sbin/mount/umount.nilfs2.c
+++ b/sbin/mount/umount.nilfs2.c
@@ -431,8 +431,8 @@ umount_one(const char *spec, const char *node, const char *type,
 					printf(_("%s: restarted %s(pid=%d)\n"),
 					       progname, NILFS_CLEANERD_NAME,
 					       (int)pid);
-				s = replace_optval(s, gcpid_opt_fmt, &oldpid,
-						   pid);
+				s = replace_drop_opt(s, gcpid_opt_fmt, &oldpid,
+						     pid, pid != 0);
 				change_mtab_opt(spec, node, type, s);
 				goto out;
 			} else
-- 
1.7.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
