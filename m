From: Frank Louwers <frank-sbM3GJIWwA3bB1ukUYwELw@public.gmane.org>
Subject: Binary diff between two snapshots?
Date: Mon, 8 Dec 2014 20:12:49 +0100
Message-ID: <4CB39535-0200-459E-8FCD-59F130F0D185@openminds.be>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2063\))
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.8.4 zimbra-om-001.openminds.be 3F1117453D4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=openminds.be;
	s=8410EF12-6E3E-11E3-B1CE-64217EF0CCC6; t=1418065970;
	bh=G82bbNooknyTaAijYS/Nv/uWQmjRvxQiOzGwAZxWp2M=;
	h=From:Content-Type:Content-Transfer-Encoding:Subject:Message-Id:
	 Date:To:Mime-Version;
	b=pNHf3EaJK76u0UCQ3NXluT/r2UU1UelGuXbHH2U6MHV6NPq17jr7KlKVT1+t6Oudq
	 HqXLt62wh/KIHctBQvj8g3PKPGaXQ7//fngJKYRzIeLKqqVRl3P/C5BTmw+ffbAnR/
	 yYBa9JhkhJVSrgg8Q1pQRG7/4QMHU38jT90TLCWU=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi all,

I was wondering if there is a way to get a binary =E2=80=9Cdiff=E2=80=9D=
 between two snapshots? Output would be the contents off the blocks tha=
t are changed + some metadata to tell which blocks it actually are. Goa=
l would be:

- take FS at snapshot A, sync that snapshot to a different volume/LUN/r=
emote machine/=E2=80=A6
- [changes occur to the fs]
- take FS at point B

I=E2=80=99d now like to get the =E2=80=9Cdiff=E2=80=9D between A and B,=
 and get it in a format we can apply to the secondary (=E2=80=9Cbackup=E2=
=80=9D) volume that is still at level A. Outcome would be that the seco=
nd volume is a copy of the first volume, at point B.

Inspiration: https://github.com/mpalmer/lvmsync



=46rank Louwers
Openminds bvba

Tel: +32 9 225 82 91--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
