From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs-utils: kill gcc warnings for unused return value of strtoul
Date: Sun, 26 Sep 2010 22:59:35 +0900
Message-ID: <1285509575-6346-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Recent gcc complains if the return value of strtoul() is not used:

chcp.c: In function =A1=C6main=A1=C7:
chcp.c:122: warning: ignoring return value of =A1=C6strtoul=A1=C7, decl=
ared with attribute warn_unused_result

dumpseg.c: In function =A1=C6main=A1=C7:
dumpseg.c:214: warning: ignoring return value of =A1=C6strtoul=A1=C7, d=
eclared with attribute warn_unused_result

This kills these warnings.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 bin/chcp.c    |    3 ++-
 bin/dumpseg.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/bin/chcp.c b/bin/chcp.c
index deb9a2b..a66e437 100644
--- a/bin/chcp.c
+++ b/bin/chcp.c
@@ -78,6 +78,7 @@ int main(int argc, char *argv[])
 	nilfs_cno_t cno;
 	char *dev, *modestr, *progname, *endptr;
 	int c, mode, status;
+	unsigned long val;
 #ifdef _GNU_SOURCE
 	int option_index;
 #endif	/* _GNU_SOURCE */
@@ -119,7 +120,7 @@ int main(int argc, char *argv[])
 		dev =3D NULL;
 	} else {
 		modestr =3D argv[optind++];
-		strtoul(argv[optind], &endptr, CHCP_BASE);
+		val =3D strtoul(argv[optind], &endptr, CHCP_BASE);
 		if (*endptr =3D=3D '\0')
 			dev =3D NULL;
 		else
diff --git a/bin/dumpseg.c b/bin/dumpseg.c
index fbc587d..0ee6aee 100644
--- a/bin/dumpseg.c
+++ b/bin/dumpseg.c
@@ -174,6 +174,7 @@ int main(int argc, char *argv[])
 	void *seg;
 	ssize_t segsize;
 	int c, i, status;
+	unsigned long val;
 #ifdef _GNU_SOURCE
 	int option_index;
 #endif	/* _GNU_SOURCE */
@@ -211,7 +212,7 @@ int main(int argc, char *argv[])
 		fprintf(stderr, "%s: too few arguments\n", progname);
 		exit(1);
 	} else {
-		strtoul(argv[optind], &endptr, DUMPSEG_BASE);
+		val =3D strtoul(argv[optind], &endptr, DUMPSEG_BASE);
 		if (*endptr =3D=3D '\0')
 			dev =3D NULL;
 		else
--=20
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
