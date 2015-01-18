From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/3] nilfs-utils: get rid of my_free()
Date: Mon, 19 Jan 2015 02:34:37 +0900
Message-ID: <1421602478-1896-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1421602478-1896-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=rRG1Ajcd28wdQaqIsYRhryMBnSctrbIYZXSrb3QnUnA=;
        b=deMWjFPfQxJbxpkhKKq6WkhbSgwLm/BhKIHaEVwBiIsLToUrlgFa3eej0k4WcEwPR1
         QDOMEPbSIUiAwHksqJFRHhn7GfeVzAKu0+aWFk9ukUeon+Tvh1hRMHIxiUw3CARDmw3j
         K6kIpqocFgA3xXzu1ceocSaqEzqCHgv1fqcZzhzOLpHkhJtALU62DFwfZkt4dFOwJU8J
         tY5P2oQ0ML5MSb/j4v7zvL8J1yOM8Q4aC/GkEL2QKNYfRoWYvD7Ht9RC3DJeRHXjuEb5
         ADKOO9iUfUg9SXpjhZyhCNxxoiY78M/dyEPwA+RT4dRcxEcRU8aGCMF/5rP9XHb3KSlw
         9hUA==
In-Reply-To: <1421602478-1896-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Remove my_free wrapper functions used in fstab.c, mount.nilfs2.c and
umount.nilfs2.c.  They are just doing an unnecessary null check before
calling free() and eliminable since free(NULL) is just ignored.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 sbin/mount/fstab.c         | 20 +++++++-------------
 sbin/mount/mount.nilfs2.c  | 38 +++++++++++++++-----------------------
 sbin/mount/umount.nilfs2.c | 15 ++++-----------
 3 files changed, 26 insertions(+), 47 deletions(-)

diff --git a/sbin/mount/fstab.c b/sbin/mount/fstab.c
index b0addbe..656a39b 100644
--- a/sbin/mount/fstab.c
+++ b/sbin/mount/fstab.c
@@ -124,19 +124,13 @@ fstab_head() {
 	return &fstab;
 }
 
-static void
-my_free(const void *s) {
-	if (s)
-		free((void *) s);
-}
-
-static void
-my_free_mc(struct mntentchn *mc) {
+static void my_free_mc(struct mntentchn *mc)
+{
 	if (mc) {
-		my_free(mc->m.mnt_fsname);
-		my_free(mc->m.mnt_dir);
-		my_free(mc->m.mnt_type);
-		my_free(mc->m.mnt_opts);
+		free(mc->m.mnt_fsname);
+		free(mc->m.mnt_dir);
+		free(mc->m.mnt_type);
+		free(mc->m.mnt_opts);
 		free(mc);
 	}
 }
@@ -574,7 +568,7 @@ void update_mtab(const char *dir, struct my_mntent *instead)
 			}
 		} else {
 			/* Replace option strings. (changed for nilfs2) */
-			my_free(mc->m.mnt_opts);
+			free(mc->m.mnt_opts);
 			mc->m.mnt_opts = xstrdup(instead->mnt_opts);
 		}
 	} else if (instead) {
diff --git a/sbin/mount/mount.nilfs2.c b/sbin/mount/mount.nilfs2.c
index e9cb25e..e3fc727 100644
--- a/sbin/mount/mount.nilfs2.c
+++ b/sbin/mount/mount.nilfs2.c
@@ -24,7 +24,6 @@
  * The following functions are extracted from util-linux-2.12r/mount.c:
  *  - print_one()
  *  - update_mtab_entry()
- *  - my_free()
  */
 
 #ifdef HAVE_CONFIG_H
@@ -172,13 +171,6 @@ static void handle_signal(int sig)
 	}
 }
 
-static inline void my_free(const void *ptr)
-{
-	/* free(NULL) is ignored; the check below is just to be sure */
-	if (ptr)
-		free((void *)ptr);
-}
-
 static int device_is_readonly(const char *device, int *ro)
 {
 	int fd, res;
@@ -255,7 +247,7 @@ static struct mntentchn *find_rw_mount(const char *device)
 			break;
 		mc = getmntdevbackward(fsname, mc);
 	}
-	my_free(fsname);
+	free(fsname);
 	return mc;
 }
 
@@ -275,8 +267,8 @@ static int mounted(const char *spec, const char *node)
 		}
 		mc = getmntdirbackward(dir, mc);
 	}
-	my_free(fsname);
-	my_free(dir);
+	free(fsname);
+	free(dir);
 	return ret;
 }
 
@@ -335,10 +327,10 @@ update_mtab_entry(const char *spec, const char *node, const char *type,
 		my_endmntent(mfp);
 		unlock_mtab();
 	}
-	my_free(mnt.mnt_fsname);
-	my_free(mnt.mnt_dir);
-	my_free(mnt.mnt_type);
-	my_free(mnt.mnt_opts);
+	free(mnt.mnt_fsname);
+	free(mnt.mnt_dir);
+	free(mnt.mnt_type);
+	free(mnt.mnt_opts);
 }
 
 enum remount_type {
@@ -349,7 +341,7 @@ enum remount_type {
 
 static int check_remount_dir(struct mntentchn *mc, const char *mntdir)
 {
-	const char *dir = canonicalize(mntdir);
+	char *dir = canonicalize(mntdir);
 	int res = 0;
 
 	if (strcmp(dir, mc->m.mnt_dir) != 0) {
@@ -357,7 +349,7 @@ static int check_remount_dir(struct mntentchn *mc, const char *mntdir)
 		      progname, mntdir);
 		res = -1;
 	}
-	my_free(dir);
+	free(dir);
 	return res;
 }
 
@@ -514,7 +506,7 @@ do_mount_one(struct nilfs_mount_info *mi, const struct mount_options *mo)
 	} else
 		printf(_("%s not restarted\n"), NILFS_CLEANERD_NAME);
  out:
-	my_free(exopts);
+	free(exopts);
 	return res;
 }
 
@@ -542,14 +534,14 @@ static void update_mount_state(struct nilfs_mount_info *mi,
 	if (!check_mtab())
 		return;
 
-	my_free(mi->optstr);
+	free(mi->optstr);
 	exopts = fix_extra_opts_string(mo->extra_opts, pid, pp);
 	mi->optstr = fix_opts_string(((mo->flags & ~MS_NOMTAB) | MS_NETDEV),
 				     exopts, NULL);
 
 	update_mtab_entry(mi->device, mi->mntdir, fstype, mi->optstr, 0, 0,
 			  !mi->mounted);
-	my_free(exopts);
+	free(exopts);
 }
 
 static int mount_one(char *device, char *mntdir,
@@ -591,7 +583,7 @@ static int mount_one(char *device, char *mntdir,
 
 	err = 0;
  failed:
-	my_free(mi.optstr);
+	free(mi.optstr);
 	return err;
 }
 
@@ -655,7 +647,7 @@ int main(int argc, char *argv[])
 	res = mount_one(device, mntdir, opts);
 	block_signals(SIG_UNBLOCK);
 
-	my_free(opts->opts);
-	my_free(opts->extra_opts);
+	free(opts->opts);
+	free(opts->extra_opts);
 	return res;
 }
diff --git a/sbin/mount/umount.nilfs2.c b/sbin/mount/umount.nilfs2.c
index 1fc17d3..832e754 100644
--- a/sbin/mount/umount.nilfs2.c
+++ b/sbin/mount/umount.nilfs2.c
@@ -341,13 +341,6 @@ static inline pid_t get_mtab_gcpid(const struct mntentchn *mc)
 	return pid;
 }
 
-static inline void my_free(const void *ptr)
-{
-	/* free(NULL) is ignored; the check below is just to be sure */
-	if (ptr)
-		free((void *)ptr);
-}
-
 static void change_mtab_opt(const char *spec, const char *node,
 			    const char *type, char *opts)
 {
@@ -364,10 +357,10 @@ static void change_mtab_opt(const char *spec, const char *node,
 	if (!nomtab)
 		update_mtab(node, &mnt);
 
-	my_free(mnt.mnt_fsname);
-	my_free(mnt.mnt_dir);
-	my_free(mnt.mnt_type);
-	my_free(mnt.mnt_opts);
+	free(mnt.mnt_fsname);
+	free(mnt.mnt_dir);
+	free(mnt.mnt_type);
+	free(mnt.mnt_opts);
 }
 
 /* Umount a single device.  Return a status code, so don't exit
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
