From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: kernel panic (2.6.36) after file system corruption (?)
Date: Tue, 21 Dec 2010 11:55:42 +0900 (JST)
Message-ID: <20101221.115542.199417894.ryusuke@osrg.net>
References: <AANLkTika7SunjtX+eMq=22L97T=dHBs0_GFdL8KbKwQ3@mail.gmail.com>
	<20101220.020412.51927139.ryusuke@osrg.net>
	<AANLkTimMj1DdHaCJwJiGaKY4=+rB6jn6ru1L0koV=suK@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimMj1DdHaCJwJiGaKY4=+rB6jn6ru1L0koV=suK-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-8859-1"
To: fijam7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>

Hi,
On Tue, 21 Dec 2010 00:40:38 +0100, Jan Misiak wrote:
> On 19 December 2010 18:04, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:
> > Two more questions here.
> >
> > =A01) Did the panic arise during mount?
>=20
> Yes, the panic occurs just after issuing the 'mount' command.
>=20
> > =A02) Did you see the following message just before this oops?
> > =A0 "segctord starting. Construction interval =3D 5 seconds, CP fre=
quency < 30 seconds"
>=20
> Yes, netconsole managed to capture it:
>=20
> sd 2:0:0:0: [sdb] Attached SCSI removable disk
> segctord starting. Construction interval =3D 5 seconds, CP frequency =
< 30 seconds
> BUG: unable to handle kernel paging request at 00001000
> IP: [<c10d572b>] page_address+0xb/0xd0
> *pde =3D 00000000
> Oops: 0000 [#1] PREEMPT SMP
>=20
> > After that, try just a read-only mount without the norecovery optio=
n.
> >
> > =A0# mount -t nilfs2 -o ro /dev/sdb1 /your-mount-dir
>=20
> It does not trigger the oops. Sorry for not mentioning it earlier. Th=
e
> kernel only panics if the file system is mounted 'rw'.
> Thank you for looking into this.
>=20
> Regards,
> Jan

Thank you for your cooperation.

According to the situation, I'm guessing the oops is triggered by the
writeback of two super blocks.

Could you get device size information in a few ways?

(In the following examples, I assumed the target device is /dev/sdb1.)

1) sysfs reported sizes
 # cat /sys/block/sdb/size
 # cat /sys/block/sdb/sdb1/size

2) Sizes on the partition table
 # fdisk -lu /dev/sdb

3) Dump of the first super block (it has the layout information)

 # dd if=3D/dev/sdb1 bs=3D1k count=3D1 skip=3D1 2>/dev/null | hd


Thanks,
Ryusuke Konishi

> >
> > On Sun, 19 Dec 2010 13:04:23 +0100, Jan Misiak wrote:
> >> On 19 December 2010 06:13, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrot=
e:
> >> > Hi,
> >> > On Sat, 18 Dec 2010 15:08:45 +0100, Jan Misiak wrote:
> >> >> Hello,
> >> >>
> >> >> I am just a simple end-user but as nobody in my distribution ha=
s had
> >> >> the same problem I was forced to turn to the upstream. Please b=
ear
> >> >> with me.
> >> >>
> >> >> I have been using nilfs2 on a 16GB usb-stick on a x86 thin clie=
nt
> >> >> running Arch Linux. The box had been running 24/7 and had an up=
time of
> >> >> about two weeks with kernel 2.6.36/nilfs-utils 2.0.20 when it
> >> >> panicked. Unfortunately nothing was to be seen in the logs (sys=
tem
> >> >> partition was ext3). Now it panics every time I attempt to moun=
t the
> >> >> volume.
> >> >>
> >> >> I tried to use netconsole to capture the panic message but it g=
ets
> >> >> truncated so I had to resort to taking pictures.
> >> >>
> >> >> box #1 kernel 2.6.36.2/nilfs-utlis 2.0.20
> >> >> =A0 =A0 http://fijam.eu.org/other/netconsole.log
> >> >> =A0 =A0 http://fijam.eu.org/other/0000.jpg
> >> >>
> >> >> I tried to mount the usb-stick on a laptop with the same kernel
> >> >> (2.6.36.2) to capture more of the panic messages:
> >> >>
> >> >> box #2 kernel 2.6.36.2/nilfs-utlis 2.0.20
> >> >> =A0 =A0 http://fijam.eu.org/other/0001.jpeg
> >> >> =A0 =A0 http://fijam.eu.org/other/0002.jpeg
> >> >>
> >> >> It crashes when I try to mount with kernel 2.6.32.27 as well:
> >> >>
> >> >> box #2 kernel 2.6.32.27/nilfs-utlis 2.0.20
> >> >> =A0 =A0 http://fijam.eu.org/other/0003.jpeg
> >> >> =A0 =A0 http://fijam.eu.org/other/0004.jpeg
> >> >>
> >> >> I would be grateful for advice on how can I help with getting t=
o the
> >> >> bottom of this.
> >> >>
> >> >> Regards,
> >> >> Jan
> >> >
> >> > It looks like these oopses were hit in the common block layer co=
de
> >> > called from the usb mass storage driver.
> >> >
> >> > Could you do some tests to narrow down the issue ?
> >> >
> >> > =A01) Use "nogc" mount option to see whether the oops depends on=
 the
> >> > =A0 =A0context of garbage collection or not:
> >> >
> >> > =A0 # mount -t nilfs2 -o nogc /dev/sdb1 /your-mount-dir
> >> >
> >> > =A02) Mount the partition read-only with "norecovery" option and=
 make
> >> > =A0 =A0read accesses to the filesystem as below:
> >> >
> >> > =A0 # mount -t nilfs2 -o ro,norecovery /dev/sdb1 /your-mount-dir
> >> > =A0 # find /your-mount-dir -type f -exec cat {} > /dev/null \;
> >> >
> >> > =A03) Try to read the block device directly with "dd":
> >> >
> >> > =A0 # dd if=3D/dev/sdb1 bs=3D4k > /dev/null
> >> >
> >> > =A04) Try lssu and lscp commands in the read-only mount to do qu=
ick
> >> > =A0 =A0sanity checks of meta data files.
> >> >
> >> > =A0 # mount -t nilfs2 -o ro,norecovery /dev/sdb1 /your-mount-dir
> >> > =A0 # lssu -a
> >> > =A0 # lscp
> >> >
> >> >
> >> > Regards,
> >> > Ryusuke Konishi
> >> >
> >>
> >> Thank you for your reply and suggestions. I have tried the followi=
ng:
> >>
> >> # mount -t nilfs2 -o nogc /dev/sdb1 /your-mount-dir
> >> =A0 =A0 Results in exactly the same kernel panic.
> >>
> >> # mount -t nilfs2 -o ro,norecovery /dev/sdb1 /your-mount-dir
> >> # find /your-mount-dir -type f -exec cat {} > /dev/null \;
> >> =A0 =A0 Doesn't trigger the oops. I was able to retrieve my data b=
ut
> >> haven't checked them for correctness yet.
> >>
> >> # lssu -a
> >> =A0 =A0 http://fijam.eu.org/other/lssu
> >> # lscp
> >> =A0 =A0 http://fijam.eu.org/other/lscp
> >>
> >> # dd if=3D/dev/sdb1 bs=3D4k > /dev/null
> >> =A0 =A0 Likewise, it doesn't trigger the oops.
> >>
> >> Is there anything else I could do to help?
> >>
> >> Regards,
> >> Jan
> >
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
