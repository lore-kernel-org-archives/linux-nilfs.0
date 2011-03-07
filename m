From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: lscp & friends: indicate filesystem by directory
Date: Mon, 7 Mar 2011 10:51:25 +0100
Message-ID: <201103071051.25290.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:x-face
         :mime-version:content-type:content-transfer-encoding:message-id;
        bh=0jpW0qSx/kLgXGA/A0vCB2+Fy2dGiSzI9QXA7TWtFFU=;
        b=M6zTEEhuqMCb/amkbInWf0k/MkOduhv9sjudqx47SsJgF9qb82diERv2IraZN8+vrO
         nWzgknsy1UhFUH34ldr+iCBOLE+iEMiycD3Aeglr0Qe4EYVBvXx0aqJWO193da9sw4m/
         OI/0QY7lT2yg5KzfyOyhijeCbBG0UdRbTMwi4=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

I've suspended issuing my current patches for lscp & friends till I imp=
lement=20
the functionality Ryusuke mentioned.

Please review the following sketch of algorithm for all interactive uti=
ls:

char *dev, *dir, *object;
char canonical[PATH_MAX + 2];
struct stat statbuffer;

dev =3D dir =3D object =3D NULL;

if (optind < argc)
                object =3D argv[optind++];

if (object) {
	stat(object, &statbuffer);
	if (S_ISDIR(statbuffer))
		dir =3D myrealpath(object, canonical, sizeof(canonical));
	else
		dev =3D myrealpath(object, canonical, sizeof(canonical));
}
else
	dir =3D getwd(canonical);

/* a new function; traverses directory hierarchy up till it reaches nil=
fs=20
mountpoint */
if (dir)
	dir =3D up_to_nilfs_mountpoint(dir); =20

nilfs_open(dev, dir, ...);


The main difference to the current version is:
if no object is explicitly indicated on the command line, the tool uses=
=20
current working directory. Thus by default it'd operate on the filesyst=
em=20
holding the current working directory -- rather than the first NILFS2 i=
n=20
/proc/mounts as it does currently.

To indicate which filesystem is to be used, I'd like to print a header =
line=20
roughly like:
# device: /dev/sdb3

What's your opinion?
--=20
dexen deVries

[[[=E2=86=93][=E2=86=92]]]

47. As Will Rogers would have said, "There is no such thing as a free=20
variable."

(Alan Perlis, `Epigrams on Programming')
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
