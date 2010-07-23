From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Error while testing (using loop device)
Date: Sat, 24 Jul 2010 01:31:41 +0900 (JST)
Message-ID: <20100724.013141.57633737.ryusuke@osrg.net>
References: <AANLkTin0qMJvDgs705a9Nu0hWNLCdGEXWn7q_2sXQ6yZ@mail.gmail.com>
	<20100723.113125.163336402.ryusuke@osrg.net>
	<AANLkTikY4joAzVe-3BSpX9KNSmFPr8cXqpJ_0pJ+rX0P@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikY4joAzVe-3BSpX9KNSmFPr8cXqpJ_0pJ+rX0P-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-8859-1"
To: rdeleonp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Fri, 23 Jul 2010 10:47:38 -0500, Rodrigo_E._De_Le=F3n_Plicet wrote:
> On Thu, Jul 22, 2010 at 9:31 PM, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> w=
rote:
> > How about this?
> >
> > =A0$ sudo mount -t nilfs2 -o ro,cp=3D3,loop=3D/dev/loop0 /tmp/test.=
img /tmp/t2
> >
> > or
> >
> > =A0$ sudo mount -t nilfs2 -r -o cp=3D3,loop=3D/dev/loop0 /tmp/test.=
img /tmp/t2
> > =A0...
> > =A0$ sudo umount /tmp/t2
>=20
> Hi. Thanks for the reply.
>=20
> rdl@linage:/tmp$ lscp
>                  CNO        DATE     TIME  MODE  FLG   NBLKINC       =
ICNT
>                    1  2010-07-23 10:36:35   cp    -         11       =
   3
>                    2  2010-07-23 10:37:22   cp    -          8       =
   3
>                    3  2010-07-23 10:38:13   ss    -        615       =
   4
>                    4  2010-07-23 10:38:58   cp    -         77       =
   5
>                    5  2010-07-23 10:39:05   cp    -         21       =
  10
>                    6  2010-07-23 10:39:12   cp    -         26       =
   7
>                    7  2010-07-23 10:39:43   cp    i          8       =
   7
>=20
> rdl@linage:/tmp$ ls -lad t*
> drwxrwxrwx 3 root root       4096 2010-07-23 10:39 t
> drwxrwxrwx 2 rdl  rdl           6 2010-07-23 10:36 t2
> -rw-r--r-- 1 rdl  rdl  1049624576 2010-07-23 10:36 test.img
>=20
> rdl@linage:/tmp$ mount|grep loop
> /dev/loop0 on /tmp/t type nilfs2 (rw,gcpid=3D2980)
>=20
> rdl@linage:/tmp$ sudo mount -t nilfs2 -o ro,cp=3D3,loop=3D/dev/loop1
> /tmp/test.img /tmp/t2
> mount.nilfs2: Error while mounting /dev/loop1 on /tmp/t2: Read-only f=
ile system
>=20
> :(

This looks limitation of the loop devices.

Try the next one for snapshot mounts.

 $ sudo mount -t nilfs2 -o ro,cp=3D3 /dev/loop0 /tmp/t2

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
