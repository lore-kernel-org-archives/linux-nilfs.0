From: Elmer Zhang <freeboy6716-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Which version of nilfs do you use?
Date: Fri, 28 Dec 2012 15:12:14 +0800
Message-ID: <948BD9D2-CAF2-444D-A23B-00D689BA69CE@gmail.com>
References: <AAEC3976-3D79-4170-B1DC-2A04499392DE@gmail.com> <1356674810.2126.4.camel@slavad-ubuntu>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:content-type:mime-version:subject:from:in-reply-to:date
         :cc:content-transfer-encoding:message-id:references:to:x-mailer;
        bh=ze9qjCu+OkoZtTQsPHC3skiVl6u/rL3LuFFPMCsTgF0=;
        b=zFjaYrXOY9PaZAq6E6ZOflFUa/xT/U5yFc9NxXXr7dacZqU6XKxesIyMw5M8E3Cx/q
         c/BQ4F+umlhXqseA6Qya6rgnxEPkb928rICgD+QgBWnnnEHq/34mVQQXeeBN6iDC+D46
         QPj4GqcqZMPbJtHgTwaqJnDaHbfrvYzaBj0TkfOaEEArs+S9zmgFBIDQKhCSVEScGnBL
         63cLfBnmv1+o5jBdrL2OWKmK3Wh4J6R9GKyx9PsmCeszDadKN02NvDVvvgVldRXe67m9
         +hQETcfT1jEtuNHr6dhoHz/fDPxzYsC9m8cK7JZQMrYlYYqb8ePkBU/HhAiEtus4aROb
         8MCA==
In-Reply-To: <1356674810.2126.4.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

There was three bad btree nodes:

Dec 20 16:12:08 yf237 kernel: NILFS: bad btree node (blocknr=3D71015340=
6): level =3D 0, flags =3D 0x2, nchildren =3D 25088
Dec 20 16:12:08 yf237 kernel: NILFS error (device sdb2): nilfs_bmap_las=
t_key: broken bmap (inode number=3D321775)
--
Dec 21 10:10:07 yf237 kernel: NILFS: bad btree node (blocknr=3D71134391=
7): level =3D 199, flags =3D 0x60, nchildren =3D 16670
Dec 21 10:10:07 yf237 kernel: NILFS error (device sdb2): nilfs_bmap_las=
t_key: broken bmap (inode number=3D324685)
--
Dec 21 10:13:41 yf237 kernel: NILFS: bad btree node (blocknr=3D14167806=
): level =3D 0, flags =3D 0x0, nchildren =3D 0
Dec 21 10:13:41 yf237 kernel: NILFS error (device sdb2): nilfs_bmap_las=
t_key: broken bmap (inode number=3D253710)

I have not found new bad btree nodes in recent days. But the MyISAM tab=
les still often be crashed and soon be ok without repairing.


=D4=DA 2012-12-28=A3=AC14:06=A3=ACVyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org=
> =D0=B4=B5=C0=A3=BA

> Hi,
>=20
> On Thu, 2012-12-27 at 17:47 +0800, Elmer Zhang wrote:
>> Hi konishi ryusuke,
>>=20
>> I am trying to use NILFS2 to make MySQL cold backup, but  the MySQL =
tables often be crashed. It seems there is some problems with nilfs fil=
esystem.
>>=20
>=20
> As I remember, you reported initially the error message about issue w=
ith
> (inode number=3D321775) and (blocknr=3D710153406). If you have new My=
SQL
> tables' crashes then it means that you have new NILFS error messages =
in
> your syslog. Do you have error messages about new inode numbers and
> block numbers or about the same?
>=20
> With the best regards,
> Vyacheslav Dubeyko.
>=20
>> I have described how I use nilfs in this mail: http://www.mail-archi=
ve.com/linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg01481.html
>>=20
>> Can I know which version of nilfs do you use, and what do you use ni=
lfs for?
>>=20
>> Thanks,
>> Elmer Zhang--
>> To unsubscribe from this list: send the line "unsubscribe linux-nilf=
s" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
