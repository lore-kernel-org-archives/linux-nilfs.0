From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] mount.nilfs2: invoke cleanerd even if no-mtab option is specified
Date: Wed, 17 Sep 2014 23:09:05 +0900
Message-ID: <1410962945-4219-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=YowJoj76TQi/O90jtITRFhNbrtsHcacEDJRAqJBGLVw=;
        b=e6JeAzbnzR4IV85HVGTTGsQXoRSoFwGk3U5AjpRhcuePkEeSHIcl0Gvxi+E2O4Isr5
         ktv4Zi5dA9vCuuDPh5JDUiaxaio1tk0PrtwHzpTj8x3huFSY8jjQTgwJx3rqmPiwg25G
         M6zVsk3t5mU/PtkitjhFNKi/qeWkSrtoLHj4l51ZRIZlD1v7kz/V59293qdmjUrOpT8M
         qcnrTI9C07DsLqI782Jz0upgXVC1MmoC7CmVC934FF6P7y6Bk60H2/CTIKb2D6yqwERE
         jdsiB1HUIwrxw2+ezhmupIlwLxhTdKjlx7256dKE/+jli+Z9JXsT/soP+NCbtvsazr5e
         aTEQ==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

After commit 7f7b227f8a8eda5603b58899597c2fdee2a73ab7 "libmount: don't
base GC startup on no-mtab context" was applied, behavior of the new
mount.nilfs2 (libmount based implementation) was slightly changed.  It
now invokes cleanerd even when no-mtab option "-n" is specified.

This patch makes a similiar change to the legacy mount.nilfs2, and
updates the manpage of mount.nilfs2 to reflect the change.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 man/mount.nilfs2.8        |    5 +----
 sbin/mount/mount.nilfs2.c |    9 +++------
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/man/mount.nilfs2.8 b/man/mount.nilfs2.8
index 8f0115e..5f3c464 100644
--- a/man/mount.nilfs2.8
+++ b/man/mount.nilfs2.8
@@ -64,10 +64,7 @@ and handling of pseudo mount options.
 .TP
 .B \-n
 Mount without writing in \fI/etc/mtab\fP.  This is necessary for
-example when \fI/etc\fP is on a read-only file system.  With this
-option, invocation of \fBnilfs_cleanerd\fP(8) is skipped.
-To add entries to mtab and invoke the garbage collector later, the
-\fB-f\fP option is available.
+example when \fI/etc\fP is on a read-only file system.
 .TP
 .B \-r
 Mount the file system read-only.  A synonym is \fB"\-o ro"\fP.
diff --git a/sbin/mount/mount.nilfs2.c b/sbin/mount/mount.nilfs2.c
index 72aa07a..e9cb25e 100644
--- a/sbin/mount/mount.nilfs2.c
+++ b/sbin/mount/mount.nilfs2.c
@@ -528,12 +528,6 @@ static void update_mount_state(struct nilfs_mount_info *mi,
 
 	rungc = (find_opt(mo->extra_opts, nogc_opt_fmt, NULL) < 0) && !(mo->flags & MS_RDONLY) && !(mo->flags & MS_BIND);
 
-	if (!check_mtab()) {
-		if (rungc)
-			printf(_("%s not started\n"), NILFS_CLEANERD_NAME);
-		return;
-	}
-
 	if (rungc) {
 		if (find_opt(mo->extra_opts, pp_opt_fmt, &pp) < 0)
 			pp = mi->protperiod;
@@ -545,6 +539,9 @@ static void update_mount_state(struct nilfs_mount_info *mi,
 			       NILFS_CLEANERD_NAME);
 	}
 
+	if (!check_mtab())
+		return;
+
 	my_free(mi->optstr);
 	exopts = fix_extra_opts_string(mo->extra_opts, pid, pp);
 	mi->optstr = fix_opts_string(((mo->flags & ~MS_NOMTAB) | MS_NETDEV),
-- 
1.7.9.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
