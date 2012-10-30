From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: very large mount time after unxepected power down
Date: Tue, 30 Oct 2012 18:52:54 +0400
Message-ID: <1351608774.2026.6.camel@slavad-ubuntu>
References: <CAFPMYnE3ybWO4o=E1UonAZJ7Uwn5y9n4840ksYGAu7qAYJ0zKw@mail.gmail.com>
	 <CAFPMYnEZ28qvwkE3kaB59h2rD_8noT+gQtp7Hs6uvmHcL6KzYA@mail.gmail.com>
	 <1351604965.2069.13.camel@slavad-ubuntu>
	 <CAFPMYnHhtFxuVZOMu9MZ6Xb74mFPm1a-4axyFKkHiJjDEW_4BA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=/i4yXgHzm4xGaEABiMQzqaakVkAGPwfLI6xdCrGz0Qg=;
	b=CeO3AMgoF5ij5iNaQq8fgRKwJ9JOXMopt17XVc9SyvPhptCgXU0I4/p1qL6UWnqHa8Ymz+VEtEC0/BwlDfbofja87BxBBKi3bWbM1nAO4kQJy8x9LosU0PdUD15RZJQX;
In-Reply-To: <CAFPMYnHhtFxuVZOMu9MZ6Xb74mFPm1a-4axyFKkHiJjDEW_4BA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?=D0=A1=D0=B5=D1=80=D0=B3=D0=B5=D0=B9_?= =?UTF-8?Q?=D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B0=D0=BD=D0=B4=D1=80=D0=BE?= =?UTF-8?Q?=D0=B2?= <splavgm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 2012-10-30 at 17:30 +0300, =D0=A1=D0=B5=D1=80=D0=B3=D0=B5=D0=B9=
 =D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B0=D0=BD=D0=B4=D1=80=D0=BE=D0=B2 wro=
te:
> --------------------------------------------------
> =D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B0=D0=BD=D0=B4=D1=80=D0=BE=D0=B2 =D0=
=A1=D0=B5=D1=80=D0=B3=D0=B5=D0=B9 =D0=92=D0=B0=D1=81=D0=B8=D0=BB=D1=8C=D0=
=B5=D0=B2=D0=B8=D1=87
>=20
>=20
> 2012/10/30 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>:
> > Hi,
> >
> > On Tue, 2012-10-30 at 16:20 +0300, =D0=A1=D0=B5=D1=80=D0=B3=D0=B5=D0=
=B9 =D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B0=D0=BD=D0=B4=D1=80=D0=BE=D0=B2 =
wrote:
> >> Good time of the day!
> >>
> >> I'v got a nilfs2 partition on a 1TB md RAID1 partition composed of=
 two
> >> HDD's. Kernel 3.5.3, userspace utils v2.1.1. Gentoo linux
> >> distribution.
> >> Just updated utils to 2.1.4 but no failure since.
> >>
> >> After power shutdown, mount takes about several hours.
> >>
> >
> > What about RAID1 consistency? Could you describe more about your RA=
ID
> > configuration?
>=20
> # cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [ra=
id4]
> md0 : active raid1 sdb1[0] sdc1[2]
>       976760400 blocks super 1.2 [2/2] [UU]
>=20
> So, raid is consistent. Reading speed from md device is about 60MB/s
> according to iostat.
>=20
> >> For the first time I thought that it won't mount at all and tried =
to
> >> use fsck tool, found somewhere in the internet(don't really rememb=
er).
> >> It reported that superblock is ok.
> >
> > So, I am implementing the fsck tool for NILFS2. I guess that you ta=
ke
> > sources from NILFS2 e-mail list.
> >
> >> Than I commented the check in the source file and the default numb=
er
> >> of blocks to check appeared to be too small. It failed to find the
> >> next superblock. I've increased the number, but increasing it to *=
100
> >> didn't help.
> >
> > Sorry, I can't understand about what sources you are talking. Could=
 you
> > describe more details about what and where you commented?
> >
> I've forced test_latest_log to return negative result. And changed
> MAX_SCAN_SEGMENTS to 100000
> That was not enough. It finished without finding the SB.
>=20
>=20
> The load from fsck was the same as from mount.
> About 60MB/s read from md device and about 30% load on one core.
>=20
> >> So, probably the reserved SB is too far from away and it takes too
> >> long to find it.
> >>
> >
> > If you try to find the second superblock then it is placed in the b=
egin
> > of last 4 KB of the volume. Your device size is 1000202649600 bytes=
=2E
> >
> >> Does anybody knows, how can it be speed up? I know, UPS is a solut=
ion,
> >> but I consider it be a bug.
> >>
> >
> > Could you share more details about situation during mount operation=
s? I
> > mean: (1) NILFS2-related messages in the system log; (2) "ps ax" ou=
tput;
> > (3) maybe "top" output can be useful also; (4) "mount" output befor=
e
> > trying to mount NILFS2 volume.
> last situation:
>=20
> messages log:
> Oct 30 12:18:52 router kernel: [  159.674579] NILFS warning: mounting
> unchecked fs
> .....
> .....
> Oct 30 13:03:06 router kernel: [ 2810.304245] NILFS: recovery complet=
e.
> Oct 30 13:03:06 router kernel: [ 2810.325240] segctord starting.
> Construction interval =3D 5 seconds, CP frequency < 30 seconds
> Oct 30 13:03:07 router nilfs_cleanerd[15453]: start
> Oct 30 13:03:07 router nilfs_cleanerd[15453]: pause (clean check)
>=20

Could you share content of your /etc/nilfs_cleanerd.conf file?

Could you try to reproduce the issue with log_priority enhanced to debu=
g
level (I mean option in nilfs_cleanerd.conf) and share messages log
again?

> It took about 45 minutes.
> Previous time it took more than 4 hours.

You mean that your console returns input after 45 minutes when you try
to execute mount. Am I correct?

With the best regards,
Vyacheslav Dubeyko.

> Both times RAID was consistent.
>=20
> top showed one process eating about 27% of cpu (2 cores, AMD Athon II
> X2 250 @3000MHz)
> Also, about 80% of memory is used for cache.
> Sory, have not saved ps output...
>=20
> I can repeat the situation if it helps.
>=20
> --------------------------------------------------
> Aleksandrov Sergey Vasil'evich


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
