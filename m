From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Binary diff between two snapshots?
Date: Sun, 14 Dec 2014 13:32:11 -0800
Message-ID: <1418592731.4039.5.camel@slavad-CELSIUS-H720>
References: <4CB39535-0200-459E-8FCD-59F130F0D185@openminds.be>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Content-Transfer-Encoding:Mime-Version:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=dTejJIf8MdZVqZhLkrp6Z2ZsyFYf0rDk5OucHKsOpJA=;
	b=OGNYg6eJp7gFmrEGcQwpT+p0M3OdUmFeEd2UbRX/2OwwLx/YCedULkYcWOOzmvQCMMBMBHFA3mR86fw2hCWcRK/4dvf0OZAxSXWVeylM7iHHDwFLOtuLkPr2ir1+a6JF;
In-Reply-To: <4CB39535-0200-459E-8FCD-59F130F0D185-sbM3GJIWwA3bB1ukUYwELw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Frank Louwers <frank-sbM3GJIWwA3bB1ukUYwELw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 2014-12-08 at 20:12 +0100, Frank Louwers wrote:
> Hi all,
>=20
> I was wondering if there is a way to get a binary =E2=80=9Cdiff=E2=80=
=9D between two snapshots? Output would be the contents off the blocks =
that are changed + some metadata to tell which blocks it actually are. =
Goal would be:
>=20
> - take FS at snapshot A, sync that snapshot to a different volume/LUN=
/remote machine/=E2=80=A6
> - [changes occur to the fs]
> - take FS at point B
>=20
> I=E2=80=99d now like to get the =E2=80=9Cdiff=E2=80=9D between A and =
B, and get it in a format we can apply to the secondary (=E2=80=9Cbacku=
p=E2=80=9D) volume that is still at level A. Outcome would be that the =
second volume is a copy of the first volume, at point B.
>=20
> Inspiration: https://github.com/mpalmer/lvmsync
>=20

There are experimental branches:

nilfs-utils  git://github.com/konis/nilfs-utils.git  (diff-v2 branch)
kernel       git://github.com/konis/nilfs2.git       (diffapi-v2 branch=
)

The nilfs-diff shows changes between two checkpoints of nilfs2 volume.

[1] http://marc.info/?l=3Dlinux-nilfs&m=3D141294888117653&w=3D2
[2] http://marc.info/?l=3Dlinux-nilfs&m=3D134404514116556&w=3D2

Thanks,
Vyacheslav Dubeyko.

>=20
>=20
> Frank Louwers
> Openminds bvba
>=20
> Tel: +32 9 225 82 91--
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs=
" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
