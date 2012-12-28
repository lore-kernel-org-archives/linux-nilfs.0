From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Which version of nilfs do you use?
Date: Fri, 28 Dec 2012 11:33:07 +0400
Message-ID: <1356679987.2126.17.camel@slavad-ubuntu>
References: <AAEC3976-3D79-4170-B1DC-2A04499392DE@gmail.com>
	 <1356674810.2126.4.camel@slavad-ubuntu>
	 <948BD9D2-CAF2-444D-A23B-00D689BA69CE@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=/DfpnoSlhTW4wZjrnh9h3MxNaHTa6t4AeuA/HAETvmA=;
	b=X0PDYTiYuTt02LeUQJ3l/Yt20/Eln/WyZ27HEO3LUBRAXESRCorm9Q4iCSPjcXoSFLcSWLVG4zRC3lDQc+i3mu2iH2fXFFUtbT2rHpLeSSrIkdOoZgBKKdqu7yrkFGt9;
In-Reply-To: <948BD9D2-CAF2-444D-A23B-00D689BA69CE-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Elmer Zhang <freeboy6716-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, 2012-12-28 at 15:12 +0800, Elmer Zhang wrote:
> Hi,
>=20
> There was three bad btree nodes:
>=20
> Dec 20 16:12:08 yf237 kernel: NILFS: bad btree node (blocknr=3D710153=
406): level =3D 0, flags =3D 0x2, nchildren =3D 25088
> Dec 20 16:12:08 yf237 kernel: NILFS error (device sdb2): nilfs_bmap_l=
ast_key: broken bmap (inode number=3D321775)
> --
> Dec 21 10:10:07 yf237 kernel: NILFS: bad btree node (blocknr=3D711343=
917): level =3D 199, flags =3D 0x60, nchildren =3D 16670
> Dec 21 10:10:07 yf237 kernel: NILFS error (device sdb2): nilfs_bmap_l=
ast_key: broken bmap (inode number=3D324685)
> --
> Dec 21 10:13:41 yf237 kernel: NILFS: bad btree node (blocknr=3D141678=
06): level =3D 0, flags =3D 0x0, nchildren =3D 0
> Dec 21 10:13:41 yf237 kernel: NILFS error (device sdb2): nilfs_bmap_l=
ast_key: broken bmap (inode number=3D253710)
>=20

I think that it makes sense to investigate dumps of the segments that
contains these blocks. Could you make dumps of #346754, #347335, #6917
segments and send only on my personal e-mail for analysis?

Example:

dd if=3D<device> of=3D<file> bs=3D4096 skip=3D710152192 count=3D2048

(710152192 =3D=3D 346754 * 2048)

With the best regards,
Vyacheslav Dubeyko.

> I have not found new bad btree nodes in recent days. But the MyISAM t=
ables still often be crashed and soon be ok without repairing.
>=20
>=20
> =E5=9C=A8 2012-12-28=EF=BC=8C14:06=EF=BC=8CVyacheslav Dubeyko <slava@=
dubeyko.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> > Hi,
> >=20
> > On Thu, 2012-12-27 at 17:47 +0800, Elmer Zhang wrote:
> >> Hi konishi ryusuke,
> >>=20
> >> I am trying to use NILFS2 to make MySQL cold backup, but  the MySQ=
L tables often be crashed. It seems there is some problems with nilfs f=
ilesystem.
> >>=20
> >=20
> > As I remember, you reported initially the error message about issue=
 with
> > (inode number=3D321775) and (blocknr=3D710153406). If you have new =
MySQL
> > tables' crashes then it means that you have new NILFS error message=
s in
> > your syslog. Do you have error messages about new inode numbers and
> > block numbers or about the same?
> >=20
> > With the best regards,
> > Vyacheslav Dubeyko.
> >=20
> >> I have described how I use nilfs in this mail: http://www.mail-arc=
hive.com/linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg01481.html
> >>=20
> >> Can I know which version of nilfs do you use, and what do you use =
nilfs for?
> >>=20
> >> Thanks,
> >> Elmer Zhang--
> >> To unsubscribe from this list: send the line "unsubscribe linux-ni=
lfs" in
> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >=20
> >=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs=
" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
