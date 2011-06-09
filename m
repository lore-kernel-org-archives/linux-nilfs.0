From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Problem setting CP interval
Date: Fri, 10 Jun 2011 00:41:25 +0900 (JST)
Message-ID: <20110610.004125.192724285.ryusuke@osrg.net>
References: <BANLkTim7Dp7-U1ee1hm7EWpw5We+pPBjAw@mail.gmail.com>
	<BANLkTimA3C9rCnsEHuCVwpx1DcB-a0757A@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTimA3C9rCnsEHuCVwpx1DcB-a0757A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-8859-1"
To: andrea.gelmini-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

Hi Andrea,
On Thu, 9 Jun 2011 16:11:24 +0200, Andrea Gelmini wrote:
> 2011/6/8 Andrea Gelmini <andrea.gelmini-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>=20
> Hi all,
>    and thanks a lot for your time.
>=20
> > =A0 But it doesn't care... I can change 'Commit interval' in any wa=
y,
> > =A0 but when I mount it I see this:
> > [ 2366.096819] segctord starting. Construction interval =3D 0 secon=
ds,
> > CP frequency < 30 seconds
> > [ 2535.082421] segctord starting. Construction interval =3D 0 secon=
ds,
> > CP frequency < 30 seconds
>=20
> I made a stupid script to replicate my problem.
> Results are the same, using different kernel, and so on.
> I also tried different version of nilfs-tools, picking via git
> since commit that introduce nilfs-tune.
>=20
> You have just to run it as root (give it a look, before):
> root@dell:/home/gelma/dev/prg# bash test_nilf.sh
> 0+0 records in
> 0+0 records out
> 0 bytes (0 B) copied, 3.506e-05 s, 0.0 kB/s
> mkfs.nilfs2 (nilfs-utils 2.1.0-rc1)
> Start writing file system initial data to the device
>        Blocksize:4096  Device:/dev/loop0  Device Size:1073741824
> File system initialization succeeded !!
> [  623.103552] segctord starting. Construction interval =3D 5 seconds=
,
> CP frequency < 30 seconds
> nilfs-tune 2.1.0-rc1
> [  624.212073] segctord starting. Construction interval =3D 0 seconds=
,
> CP frequency < 30 seconds
>=20
> Thanks a lot for your time,
> Andrea

Thank you, I could easily reproduce this problem.
I will fix it.

Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
