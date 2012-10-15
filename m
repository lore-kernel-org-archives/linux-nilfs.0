From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: NILFS: corrupt root inode after Turbo Mode?
Date: Mon, 15 Oct 2012 10:18:08 +0400
Message-ID: <1350281888.2488.9.camel@slavad-ubuntu>
References: <20121010220331.GA27763@wloczykij>
	 <1349938258.1908.3.camel@slavad-ubuntu> <20121011092300.GB27763@wloczykij>
	 <1349950320.1908.11.camel@slavad-ubuntu> <20121011180332.GE27763@wloczykij>
	 <1350025832.2026.43.camel@slavad-ubuntu> <20121012103119.GF27763@wloczykij>
	 <1350040053.2026.47.camel@slavad-ubuntu> <20121012114043.GG27763@wloczykij>
	 <26EBDBC2-8938-41BC-8C0C-6F6F3A0FD1EC@dubeyko.com>
	 <20121014200836.GK27763@wloczykij>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=FanQR4FNEm364SGQpqEL5Pe9RUiTYwyN7VsLIR+OK8E=;
	b=aMgPxTL2blumV/69m+EDZ/5cUo4UVpJqSEU6jsrToNfCmC4fq0HSzfuuNQNLAPDrgv7rOUnwW7Esld1W6nydGV0Fkzydp5o3PgxDMC6HttczHte/MIQiV+XhN4IDE2cl;
In-Reply-To: <20121014200836.GK27763@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, 2012-10-14 at 22:08 +0200, Piotr Szymaniak wrote:
> On Sun, Oct 14, 2012 at 06:55:59PM +0400, Vyacheslav Dubeyko wrote:
> >=20
> > So, it is clear that #359 segment is empty. Moreover, #357 segment =
doesn't contain ifile block with blkoff =3D 2 as I can see from dumpseg=
 output. Currently, I know that #358 segment contains empty ifile block=
 with blkoff =3D 2. It needs to find segment which contains not empty b=
lock of ifile for blkoff =3D 2. Could you share dumpseg output of all p=
revious segments (for #358)?
>=20
> dumpseg of blocks 340 =E2=86=92 357 attached (I hope, the file is ~20=
0KB).
>=20

As I can see, checkpoints #1843 and #1819 contain ifile's block with bl=
koff =3D 2.

Could you check state of blocks 719300 and 698817? If any of these bloc=
ks are not empty then, please, send the raw dump of non-empty block(s).

Thanks,
Vyacheslav Dubeyko.=20


> Piotr Szymaniak.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
