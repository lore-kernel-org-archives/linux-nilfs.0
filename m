From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Problem setting CP interval
Date: Fri, 10 Jun 2011 01:20:00 +0900 (JST)
Message-ID: <20110610.012000.93457188.ryusuke@osrg.net>
References: <BANLkTim7Dp7-U1ee1hm7EWpw5We+pPBjAw@mail.gmail.com>
	<BANLkTimA3C9rCnsEHuCVwpx1DcB-a0757A@mail.gmail.com>
	<20110610.004125.192724285.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110610.004125.192724285.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-8859-1"
To: andrea.gelmini-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

On Fri, 10 Jun 2011 00:41:25 +0900 (JST), Ryusuke Konishi wrote:
> Hi Andrea,
> On Thu, 9 Jun 2011 16:11:24 +0200, Andrea Gelmini wrote:
> > 2011/6/8 Andrea Gelmini <andrea.gelmini-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> >=20
> > Hi all,
> >    and thanks a lot for your time.
> >=20
> > > =A0 But it doesn't care... I can change 'Commit interval' in any =
way,
> > > =A0 but when I mount it I see this:
> > > [ 2366.096819] segctord starting. Construction interval =3D 0 sec=
onds,
> > > CP frequency < 30 seconds
> > > [ 2535.082421] segctord starting. Construction interval =3D 0 sec=
onds,
> > > CP frequency < 30 seconds
> >=20
> > I made a stupid script to replicate my problem.
> > Results are the same, using different kernel, and so on.
> > I also tried different version of nilfs-tools, picking via git
> > since commit that introduce nilfs-tune.
> >=20
> > You have just to run it as root (give it a look, before):
> > root@dell:/home/gelma/dev/prg# bash test_nilf.sh
> > 0+0 records in
> > 0+0 records out
> > 0 bytes (0 B) copied, 3.506e-05 s, 0.0 kB/s
> > mkfs.nilfs2 (nilfs-utils 2.1.0-rc1)
> > Start writing file system initial data to the device
> >        Blocksize:4096  Device:/dev/loop0  Device Size:1073741824
> > File system initialization succeeded !!
> > [  623.103552] segctord starting. Construction interval =3D 5 secon=
ds,
> > CP frequency < 30 seconds
> > nilfs-tune 2.1.0-rc1
> > [  624.212073] segctord starting. Construction interval =3D 0 secon=
ds,
> > CP frequency < 30 seconds
> >=20
> > Thanks a lot for your time,
> > Andrea
>=20
> Thank you, I could easily reproduce this problem.
> I will fix it.

The following patch fixes your problem.  (this patch is primarily
intended for the latest kernel and may not apply to older kernels as
is).

I will send it upstream along with other bug-fixes.

Thanks,
Ryusuke Konishi

---
=46rom: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

nilfs2: fix problem in setting checkpoint interval

Checkpoint generation interval of nilfs goes wrong after user has
changed the interval parameter with nilfs-tune tool.

 segctord starting. Construction interval =3D 5 seconds,
 CP frequency < 30 seconds
 segctord starting. Construction interval =3D 0 seconds,
 CP frequency < 30 seconds

This turned out to be caused by a trivial bug in initialization code
of log writer.  This will fix it.

Reported-by: Andrea Gelmini <andrea.gelmini-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/segment.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 141646e..bb24ab6 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2573,7 +2573,7 @@ static struct nilfs_sc_info *nilfs_segctor_new(st=
ruct super_block *sb,
 	sci->sc_watermark =3D NILFS_SC_DEFAULT_WATERMARK;
=20
 	if (nilfs->ns_interval)
-		sci->sc_interval =3D nilfs->ns_interval;
+		sci->sc_interval =3D HZ * nilfs->ns_interval;
 	if (nilfs->ns_watermark)
 		sci->sc_watermark =3D nilfs->ns_watermark;
 	return sci;
--=20
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
