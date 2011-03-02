From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] lscp: support opening mounted filesystem by directory pathname
Date: Wed, 2 Mar 2011 10:56:08 +0100
Message-ID: <201103021056.08672.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_4QhbNBjkEQXkrlz"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:mime-version
         :content-type:message-id;
        bh=BQcyJcsfauivPQzCBOofr0kGlRE2O738eMMlf+SzTfQ=;
        b=qgk5ueOoZgSTL/aD/Rdattl0eBOf7CHkDQqB9RUvLnkDWc2Qxv8rZXJrkr7q2PHgfA
         OXOo0G1c4Yomb206C6PHKnbcNg6KPEFRvU5NVIydTV/zrfUuwq0R9YCJ5NAhLd1GuCNI
         P9qG5ilAG6IGhwMt4x6d9hXFQJsP4ynlUDpZU=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

--Boundary-00=_4QhbNBjkEQXkrlz
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

I wonder if submission as an attachment will work alright.

=2D-=20
dexen deVries

[[[=E2=86=93][=E2=86=92]]]

> how does a C compiler get to be that big? what is all that code doing?

iterators, string objects, and a full set of C macros that ensure
boundary conditions and improve interfaces.

ron minnich, in response to Charles Forsyth

http://9fans.net/archive/2011/02/90

--Boundary-00=_4QhbNBjkEQXkrlz
Content-Type: text/x-patch;
  charset="UTF-8";
  name="0001-lscp-support-opening-mounted-filesystem-by-directory.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-lscp-support-opening-mounted-filesystem-by-directory.patch"

=46rom d680318225635932b633210a97d39dac09fe44ec Mon Sep 17 00:00:00 2001
=46rom: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Wed, 2 Mar 2011 10:53:11 +0100
Subject: [PATCH] lscp: support opening mounted filesystem by directory path=
name

=2D--
 bin/lscp.c |   23 ++++++++++++++++++-----
 1 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/bin/lscp.c b/bin/lscp.c
index df9a0af..44e9dcb 100644
=2D-- a/bin/lscp.c
+++ b/bin/lscp.c
@@ -28,6 +28,14 @@
 #include "config.h"
 #endif	/* HAVE_CONFIG_H */
=20
+#if HAVE_SYS_TYPES_H
+#include <sys/types.h>
+#endif	/* HAVE_SYS_TYPES_H */
+
+#if HAVE_SYS_STAT_H
+#include <sys/stat.h>
+#endif	/* HAVE_SYS_STAT_H */
+
 #include <stdio.h>
=20
 #if HAVE_STDLIB_H
@@ -324,7 +332,8 @@ int main(int argc, char *argv[])
 {
 	struct nilfs *nilfs;
 	struct nilfs_cpstat cpstat;
=2D	char *dev, *progname;
+	struct stat statbuf;
+	char *pathname, *progname;
 	int c, mode, rvs, status, ret;
 #ifdef _GNU_SOURCE
 	int option_index;
@@ -384,15 +393,19 @@ int main(int argc, char *argv[])
 		fprintf(stderr, "%s: too many arguments\n", progname);
 		exit(1);
 	} else if (optind =3D=3D argc - 1) {
=2D		dev =3D argv[optind++];
+		pathname =3D argv[optind++];
 	} else {
=2D		dev =3D NULL;
+		pathname =3D NULL;
 	}
=20
=2D	nilfs =3D nilfs_open(dev, NULL, NILFS_OPEN_RDONLY);
+	stat(pathname, &statbuf);
+	if (S_ISDIR(statbuf.st_mode))
+		nilfs =3D nilfs_open(NULL, pathname, NILFS_OPEN_RDONLY);
+	else
+		nilfs =3D nilfs_open(pathname, NULL, NILFS_OPEN_RDONLY);
 	if (nilfs =3D=3D NULL) {
 		fprintf(stderr, "%s: %s: cannot open NILFS\n",
=2D			progname, dev);
+			progname, pathname);
 		exit(EXIT_FAILURE);
 	}
=20
=2D-=20
1.7.4.1


--Boundary-00=_4QhbNBjkEQXkrlz--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
