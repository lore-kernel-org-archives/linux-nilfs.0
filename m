From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: A lot of NILFS: bad btree node messages (readonly fs)
Date: Fri, 30 Nov 2012 10:09:04 +0400
Message-ID: <1354255744.2090.3.camel@slavad-ubuntu>
References: <20121129210650.GA4028@wloczykij>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=jVNlMH++mlXVKtcB9CB08QJDrtyb7UrNckwuvAmwU38=;
	b=s+6+wUqvxGgM4bqrcjZAWCzXIS56YISEmFIxWEIzchv1ZqQSdIi+xcgTWnxs//ik1erw618IzoPqs0fgubX1ZmrTJILVtWC0yEXI8ydXsA4oM/78dvc3BjnIhJGLZU38;
In-Reply-To: <20121129210650.GA4028@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On Thu, 2012-11-29 at 22:06 +0100, Piotr Szymaniak wrote:
> Hello.
>=20
> Doing some work today (system update, kernel update, rsync rootfs wit=
h
> external drive) I noticed some unwanted behaviour:
> maszn ~ # touch afile
> touch: cannot touch =E2=80=98afile=E2=80=99: System plik=C3=B3w wy=C5=
=82=C4=85cznie do odczytu
>                         it's Read only filesystem
>=20
> dmesg shows a lot (1812 in the log) of:
> [ 8288.319012] NILFS: bad btree node (blocknr=3D26229286): level =3D =
178,
> flags =3D 0x0, nchildren =3D 0
> [ 8288.319017] NILFS error (device sda2): nilfs_bmap_lookup_contig:
> broken bmap (inode number=3D102230)
>=20
> After mount -o remount,rw /
> [ 8384.734024] segctord starting. Construction interval =3D 300 secon=
ds,
> CP frequency < 30 seconds
> [ 8384.734028] NILFS warning: mounting fs with errors
>=20
> Never happend before and it looks like it works fine now (using vanil=
la
> kernel 3.6.4).
>=20
> After a reboot (to vanilla kernel 3.6.8) dmesg shows:
> [    6.046883] segctord starting. Construction interval =3D 300 secon=
ds,
> CP frequency < 30 seconds
> [    6.046884] NILFS warning: mounting fs with errors
>=20
> I don't like the "errors" part...
>=20

Can you reproduce this issue (I mean that the issue reproducible or
not)? Have you any side effects of the issue such as data loss or any
other bad things?

With the best regards,
Vyacheslav Dubeyko.

>=20
> Piotr Szymaniak.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
