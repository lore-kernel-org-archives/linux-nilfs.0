From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Split some metadata onto separate device?
Date: Fri, 3 Jun 2011 12:29:33 +0200
Message-ID: <201106031229.38758.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:x-face
         :mime-version:content-type:content-transfer-encoding:message-id;
        bh=wluI2UUv6dPCZcyvhQvD6KtCunTHMXK9adySH4NadpE=;
        b=tU547+WKzPpsF6vBiQ9NrPP0aMC8vCtKn29U982uRvpzg6smK9+yg+glV9BekKl8tL
         X+loK1wiIbjSjzVGkJI1W/eZDKRdtlI3M52RnunmTb2dQdKKvTiaMqHkVwrbpWPFu2AP
         vY6oRfcKceAglXXEUOC0YUcks7vvGCAKPk1vE=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi list,

back when I was using XFS, there was an option to put one particular pi=
ece of=20
metadata -- the journal -- onto separate physical device. The speed-up =
was=20
very significant, especially for operations on lots of files. For examp=
le, with=20
external journal removing whole kernel source tree on XFS would take le=
ss time=20
than on ext2 or ext3; with internal it would be much longer than ext2 o=
r 3.

The journal was needed only in case of unclean unmount, as only then it=
=20
contained any information not applied yet; if the unmount was clean, th=
e=20
journal contained no important information.

XFS journals only metadata changes, btw.


My question is, would it be feasible to move some part of NILFS2 metada=
ta onto=20
separate device for R/W/GC speed-up?=20

Perhaps some of metadata could even be considered `recoverable' -- that=
 is, if=20
the other device gets broken or lost, the metadata on it could be re-
constructed from content of the main device.


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
