From: Dan McGee <dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
Subject: [PATCH] libmount: don't base GC startup on no-mtab context
Date: Mon,  1 Sep 2014 14:45:14 -0500
Message-ID: <1409600714-25174-1-git-send-email-dan@archlinux.org>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:subject:date:message-id;
        bh=z2x2VoajMLiRm8xeOzvhrWmHyH+Z1uEcw2XghHh11tI=;
        b=p0jZnM3TuooVei/ZPjeKbkMzoXKB5SwiL+Mepz//WzXE7eKlk/y+VgDMwBIKm6VY9v
         jcasdBtu3g7rE91YuWGHbcznrUYl01/5j5hc1ze3vykRpc1MzQFjIk94mtXpHjuZ979l
         mMpb8ruNgwg7QDLtt2mzwsA9L5qc4ZSlPD85hzZ5o4p4MynsU2mkaRF8553mtQVfsbAx
         JW9/JTRM9cy8xm61iuU2oOE8Na1bHMAg5Mn0bdMUI0qSGGRpeJwnv7+Vo5xX/zjbruSg
         HS6qC83zmqQfOXoZeDF1Dz4fOgTFu7o/HdnQHxO5l/GVlpbmBfGMH4Dy8W3hI0PCc5zd
         sFuQ==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

When mtab is a symlink to /proc/mounts, libmount uses /run/mount/utab to
store filesystem-specific mount attributes, making this check
unnecessary. Worse, it now breaks nilfs_cleanerd under systemd 216+
since it always passes `-n` to the mount command.

Signed-off-by: Dan McGee <dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
---
 sbin/mount/mount_libmount.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/sbin/mount/mount_libmount.c b/sbin/mount/mount_libmount.c
index c518475..b901654 100644
--- a/sbin/mount/mount_libmount.c
+++ b/sbin/mount/mount_libmount.c
@@ -404,12 +404,6 @@ static int nilfs_update_mount_state(struct nilfs_mount_info *mi)
 	rungc = gc_ok && !mi->new_attrs.nogc;
 	old_attrs = (mi->mflags & MS_REMOUNT) ? &mi->old_attrs : NULL;
 
-	if (mnt_context_is_nomtab(cxt)) {
-		if (rungc)
-			printf(_("%s not started\n"), NILFS_CLEANERD_NAME);
-		return 0;
-	}
-
 	if (rungc) {
 		if (mi->new_attrs.pp == ULONG_MAX)
 			mi->new_attrs.pp = mi->old_attrs.pp;
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
