From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: fun with nilfs_cleanerd
Date: Thu, 26 May 2011 11:10:07 +0200
Message-ID: <201105261110.15660.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:x-face
         :mime-version:content-type:content-transfer-encoding:message-id;
        bh=KgXk6mumeRVOC8AFMlbnhQ5RdavnMN7r3BKkEKZ+tf8=;
        b=AYbuAY4osKs+ym/lqbfh7P6E0aoZgH7sQIS46YSuX4C6zFXWHGCbZ47iLNXhet4vX0
         MPDwHji9mjNNufdJjdoIJZoYxY9aKl2hwNe8rglDrB4wzywHqdI4FJDWqpmgQD8WdxXB
         6hHq6QC7xJTqfGgWi1bbrQt+Qxk+iajlBFa2U=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi list,

in /etc/rc.d/rc.local I have a command starting cleanerd for root files=
ystem:
# /sbin/nilfs_cleanerd -c /etc/nilfs_cleanerd-root.conf /dev/sda3

At first I wanted a separate config for root filesystem, but now same w=
as to be=20
used for both / and /home. So I've removed the metion of the config fil=
e, and =20
the command became:

# /sbin/nilfs_cleanerd -c /dev/sda3

(note the -c !)
=2E..ended up with nilfs_cleanerd spewing countless errors into /var/lo=
g/syslog,=20
like:

May 26 11:05:08 coil nilfs_cleanerd[18902]: =D7=B8=EF=BF=BD=EF=BF=BD: u=
nknown keyword
May 26 11:05:08 coil nilfs_cleanerd[18902]: c=CB=AE=EF=BF=BD=EF=BF=BD=EF=
=BF=BD: unknown keyword
May 26 11:05:08 coil nilfs_cleanerd[18902]: A=EF=BF=BD;^C=EF=BF=BDS-=EF=
=BF=BDg^W=EF=BF=BD^F=C9=82: unknown keyword
May 26 11:05:08 coil nilfs_cleanerd[18902]: too long line


nilfs_cleanerd using whole partition as the config file =3D=3D fun! ;-)
--=20
dexen deVries

[[[=E2=86=93][=E2=86=92]]]

=46or example, if the first thing in the file is:
   <?kzy irefvba=3D"1.0" rapbqvat=3D"ebg13"?>
an XML parser will recognize that the document is stored in the traditi=
onal=20
ROT13 encoding.

(( Joe English, http://www.flightlab.com/~joe/sgml/faq-not.txt ))
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
