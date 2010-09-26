From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs-utils: kill gcc warning on fstab.c
Date: Sun, 26 Sep 2010 22:58:24 +0900
Message-ID: <1285509504-6287-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Will kill the following gcc warning:

fstab.c: In function =A1=C6update_mtab=A1=C7:
fstab.c:573: warning: ignoring return value of =A1=C6chown=A1=C7, decla=
red with attribute warn_unused_result

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 sbin/mount/fstab.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/sbin/mount/fstab.c b/sbin/mount/fstab.c
index 2921915..c69502f 100644
--- a/sbin/mount/fstab.c
+++ b/sbin/mount/fstab.c
@@ -480,6 +480,7 @@ update_mtab (const char *dir, struct my_mntent *ins=
tead) {
 	const char *fnam =3D MOUNTED;
 	struct mntentchn mtabhead;	/* dummy */
 	struct mntentchn *mc, *mc0, *absent =3D NULL;
+	int ret;
=20
 	if (mtab_does_not_exist() || mtab_is_a_symlink())
 		return;
@@ -570,7 +571,7 @@ update_mtab (const char *dir, struct my_mntent *ins=
tead) {
 	   */
 	    struct stat sbuf;
 	    if (stat (MOUNTED, &sbuf) =3D=3D 0)
-		chown (MOUNTED_TEMP, sbuf.st_uid, sbuf.st_gid);
+		ret =3D chown(MOUNTED_TEMP, sbuf.st_uid, sbuf.st_gid);
 	}
=20
 	/* rename mtemp to mtab */
--=20
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
