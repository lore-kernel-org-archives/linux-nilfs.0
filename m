From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Cleancache
Date: Wed, 8 Jun 2011 15:14:59 +0200
Message-ID: <201106081514.59693.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:x-face
         :mime-version:content-type:content-transfer-encoding:message-id;
        bh=b9rZ/m1IvUvlIkXJ5Gz7goY5aX2grJZ4YX2GMVpoi9Y=;
        b=tIneAOUBxCJMo3fLu/IJDqYKc5SqiHaxNdg5ncSCyeStfVyny9GIRYLEyMZ3TxseNM
         OrZ9ftGVQZ+hjtjq/hhIdYR36UdFmhmNbdH67WpFVHzthPlhQgMTo7K6SHsfuyTtZt7g
         5qP28XMtxY+J3h1I/TtPOpCTp4V27tBa562Xk=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi list,


there's that recent interesting addition to linux: `cleancache' (and=20
`zcache').
I've enabled it for NILFS2 yesterday (in 3.0-rc2).
It seemed to work for a while -- sensible numbers in=20
/sys/kernel/mm/cleancache/*=20
But it broke terribly after performing
echo 3 > /proc/sys/vm/drop_caches
kernel reported NULL pointer dereference, IIRC. Ext4 works a-OK with th=
at, so=20
my first guess waws NILFS2 is doing something funky with page allocatio=
n or=20
mapping.

Cleancache has own hooks into VFS, and for `normal' filesystem that's e=
nough;=20
at least enough for ext3 and ext4 drivers to work reliably. On the othe=
r hand,=20
btrfs does something unusual with pages and they used extra cleancache =
hooks=20
for btrfs, IIRC.

Should I dig further, post backtraces or something?

I believe using cleancache + zcache could be beneficial, especially for=
 NILFS2=20
metadata like the DAT file; what are your thoughts on it?


Regards,
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
