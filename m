From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: very large mount time after unxepected power down
Date: Fri, 16 Nov 2012 11:37:16 +0400
Message-ID: <1353051436.2029.26.camel@slavad-ubuntu>
References: <CAFPMYnE3ybWO4o=E1UonAZJ7Uwn5y9n4840ksYGAu7qAYJ0zKw@mail.gmail.com>
	 <CAFPMYnEZ28qvwkE3kaB59h2rD_8noT+gQtp7Hs6uvmHcL6KzYA@mail.gmail.com>
	 <1351604965.2069.13.camel@slavad-ubuntu>
	 <CAFPMYnHhtFxuVZOMu9MZ6Xb74mFPm1a-4axyFKkHiJjDEW_4BA@mail.gmail.com>
	 <1351608774.2026.6.camel@slavad-ubuntu>
	 <CAFPMYnGn4aNf=5B9v93TtTc6x4hG1ULgt0P9i75uO=xGX0U2bg@mail.gmail.com>
	 <AFFE5823-0AD0-488C-B465-55CF45A10785@dubeyko.com>
	 <CAFPMYnEtXMr1UOVYdNNRxxH83=O-_UOR_ZhCdqjh+JuUNrFiDA@mail.gmail.com>
	 <1351664002.2105.3.camel@slavad-ubuntu>
	 <CAFPMYnHyUSEr5jwBNkh43Xpt=VrzgiSCK8LG3Vkf3HcwV9cnMQ@mail.gmail.com>
	 <CAFPMYnHB=x2y3C-bVSEcaT2nMYn12zc5Jnr56ph31zBbym4Kfw@mail.gmail.com>
	 <CAFPMYnE2j0DjiqcSuJRiJX5hfDjHoyh-WUhG0cMav9K=tbsLDQ@mail.gmail.com>
	 <1352961172.2076.10.camel@slavad-ubuntu>
	 <CAFPMYnH4npNU8dJKAHwjatxAA=WoT10EWho5xyYjZJjz4uOYBA@mail.gmail.com>
	 <CAFPMYnG6zjT6-=x7XcVuuCp1__H0FhCBfNmyrfQi8dNpWC_m2w@mail.gmail.com>
	 <1353047197.2029.5.camel@slavad-ubuntu>
	 <CAFPMYnFLSZW068cFZ4FqDKF5sS_zF3SoV=vPG2=m+kvaxq-BZA@mail.gmail.com>
	 <1353048835.2029.17.camel@slavad-ubuntu>
	 <CAFPMYnEYnLv5e6a3ZcFRjw-8cNB80T5=mpuiX9jaWa+pEj8Q-A@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=BqpfNcfp1+WQ/CiFF2nvX14u9EmS6X34Ai/SqGlCCX8=;
	b=qOjCvpbt8EpG644FyMyOczpkpxqUgx8bNlF8J7NeJqIfVlE6ZNRuwk38hf28lKFl7THRX4xVttWUr2c3dkgmzIwtLCPv+QK/99ILrH8NzwH+jbDDaecZgctDQQVcZdVb;
In-Reply-To: <CAFPMYnEYnLv5e6a3ZcFRjw-8cNB80T5=mpuiX9jaWa+pEj8Q-A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?=D0=A1=D0=B5=D1=80=D0=B3=D0=B5=D0=B9_?= =?UTF-8?Q?=D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B0=D0=BD=D0=B4=D1=80=D0=BE?= =?UTF-8?Q?=D0=B2?= <splavgm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 2012-11-16 at 10:11 +0300, =D0=A1=D0=B5=D1=80=D0=B3=D0=B5=D0=B9=
 =D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B0=D0=BD=D0=B4=D1=80=D0=BE=D0=B2 wro=
te:
> dmesg:
> [53994.254432] NILFS warning: mounting unchecked fs
> [56686.968229] NILFS: recovery complete.
> [56686.969316] segctord starting. Construction interval =3D 5 seconds=
,
> CP frequency < 30 seconds
>=20
> messages:
> Nov 15 10:57:06 router kernel: [53994.254432] NILFS warning: mounting
> unchecked fs
> Nov 15 11:42:02 router kernel: [56686.968229] NILFS: recovery complet=
e.
> Nov 15 11:42:02 router kernel: [56686.969316] segctord starting.
> Construction interval =3D 5 seconds, CP frequency < 30 seconds
>=20
> May be there is some kernel config option to get more debug output?
>=20

I am afraid that it is all that we can get from NILFS2 driver currently=
=2E
So, as I understand, we haven't any messages about detected corruptions=
=2E
It needs to analyze situation further.

But maybe, it makes sense to enable some kernel options from the kernel
hacking part (maybe, synchronization related).=20

> As for fsck, I have not found it in git public repo, so where can I
> get the latest version?

Unfortunately, you can get it in the form of path set only. I sent the
last version (v4) in the e-mail list at November 12.=20

With the best regards,
Vyacheslav Dubeyko.

> --------------------------------------------------
> =D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B0=D0=BD=D0=B4=D1=80=D0=BE=D0=B2 =D0=
=A1=D0=B5=D1=80=D0=B3=D0=B5=D0=B9 =D0=92=D0=B0=D1=81=D0=B8=D0=BB=D1=8C=D0=
=B5=D0=B2=D0=B8=D1=87
>=20
>=20
> 2012/11/16 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>:
> > On Fri, 2012-11-16 at 09:40 +0300, =D0=A1=D0=B5=D1=80=D0=B3=D0=B5=D0=
=B9 =D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B0=D0=BD=D0=B4=D1=80=D0=BE=D0=B2 =
wrote:
> >> Sorry, but I didn't save top output this time..
> >> But for sure, it was "mount /dev/md0 /nfs/raid -o ...." process. T=
he
> >> CPU load was fully in kernel space.
> >> So while the mount call, the kernel was doing something very both =
IO
> >> and CPU intensive for almost 50 minutes.
> >> As I have already written the load was about 80MB/s read IO accord=
ing
> >> to iotop, and about 60% of the first CPU core according to top.
> >>
> >
> > Ok. I see.
> >
> > I suspect currently that you can have some special corruption of th=
e
> > volume state that is resulted in so long recovery code working time=
=2E But
> > if so, then you can have some warning messages in system log from
> > recovery subsystem (maybe not, of course). As I know, Gentoo has sp=
ecial
> > log that keeps error and warning messages from the kernel. Could yo=
u
> > check that shared by you the dmesg output contains error messages f=
rom
> > kernel?
> >
> > Moreover, current functionality state of fsck.nilfs2 is not very us=
eful
> > yet. But it can check superblocks and segment summary headers valid=
ity.
> > Maybe it makes sense to check your volume by fsck.nilfs2. Could you=
 try
> > to check your volume?
> >
> > With the best regards,
> > Vyacheslav Dubeyko.
> >
> >
> >> If this info is not sufficient I'll try to reproduce the case as s=
oon
> >> as possible.
> >> --------------------------------------------------
> >> =D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B0=D0=BD=D0=B4=D1=80=D0=BE=D0=B2=
 =D0=A1=D0=B5=D1=80=D0=B3=D0=B5=D0=B9 =D0=92=D0=B0=D1=81=D0=B8=D0=BB=D1=
=8C=D0=B5=D0=B2=D0=B8=D1=87
> >>
> >>
> >> 2012/11/16 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>:
> >> > On Thu, 2012-11-15 at 16:08 +0300, =D0=A1=D0=B5=D1=80=D0=B3=D0=B5=
=D0=B9 =D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B0=D0=BD=D0=B4=D1=80=D0=BE=D0=B2=
 wrote:
> >> >> lssu, lscp after mount. Actually I missed the moment and
> >> >> nilfs_cleanerd has cleaned some data.
> >> >> Mount took about 50 minutes.
> >> >>
> >> >
> >> > Thank you for info.
> >> >
> >> > I have some additional questions after thinking about issue. As =
I
> >> > remember, you wrote that you tried to understand what process ea=
ts CPU
> >> > time during issue. But you don't share details about it. Could y=
ou share
> >> > details of "top" and "ps ax" outputs for the case of issue repro=
ducing?
> >> >
> >> > With the best regards,
> >> > Vyacheslav Dubeyko.
> >> >
> >> >> --------------------------------------------------
> >> >> =D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B0=D0=BD=D0=B4=D1=80=D0=BE=D0=
=B2 =D0=A1=D0=B5=D1=80=D0=B3=D0=B5=D0=B9 =D0=92=D0=B0=D1=81=D0=B8=D0=BB=
=D1=8C=D0=B5=D0=B2=D0=B8=D1=87
> >> >>
> >> >>
> >
> >


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
