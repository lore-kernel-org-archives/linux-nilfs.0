From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: very large mount time after unxepected power down
Date: Fri, 16 Nov 2012 10:26:37 +0400
Message-ID: <1353047197.2029.5.camel@slavad-ubuntu>
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
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=Wyb/+bDJ7vyTFpAY683jUn1OBFiLqv9a8emmYb/p7eQ=;
	b=RvPl7vmBCKfAiG14eeF5oC/NSfw3NQrQHJtldaOt5oCIpxufXZNjTISAuMhBCFlLLvzUQlddziy6XACbb98ewi39neMtoe49aI+VFeX0wavU4/FyBz5a0h3VRisHa3Q+;
In-Reply-To: <CAFPMYnG6zjT6-=x7XcVuuCp1__H0FhCBfNmyrfQi8dNpWC_m2w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?=D0=A1=D0=B5=D1=80=D0=B3=D0=B5=D0=B9_?= =?UTF-8?Q?=D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B0=D0=BD=D0=B4=D1=80=D0=BE?= =?UTF-8?Q?=D0=B2?= <splavgm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 2012-11-15 at 16:08 +0300, =D0=A1=D0=B5=D1=80=D0=B3=D0=B5=D0=B9=
 =D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B0=D0=BD=D0=B4=D1=80=D0=BE=D0=B2 wro=
te:
> lssu, lscp after mount. Actually I missed the moment and
> nilfs_cleanerd has cleaned some data.
> Mount took about 50 minutes.
>=20

Thank you for info.

I have some additional questions after thinking about issue. As I
remember, you wrote that you tried to understand what process eats CPU
time during issue. But you don't share details about it. Could you shar=
e
details of "top" and "ps ax" outputs for the case of issue reproducing?

With the best regards,
Vyacheslav Dubeyko.

> --------------------------------------------------
> =D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B0=D0=BD=D0=B4=D1=80=D0=BE=D0=B2 =D0=
=A1=D0=B5=D1=80=D0=B3=D0=B5=D0=B9 =D0=92=D0=B0=D1=81=D0=B8=D0=BB=D1=8C=D0=
=B5=D0=B2=D0=B8=D1=87
>=20
>=20
> 2012/11/15 =D0=A1=D0=B5=D1=80=D0=B3=D0=B5=D0=B9 =D0=90=D0=BB=D0=B5=D0=
=BA=D1=81=D0=B0=D0=BD=D0=B4=D1=80=D0=BE=D0=B2 <splavgm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> > 2012/11/15 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>:
> >
> >>> The bug appeared again. And apparently it's a kernel one.
> >>> My bad that I didn't notice that the CPU activity wals in kernel =
space.
> >>> The mount process hangs inside mount call itself. I've an strace
> >>> output, but it's not informative, it perfectly normal besides the=
 hang
> >>> in mount call.
> >>
> >> I will try to reproduce the issue. As I remember, you described yo=
ur
> >> environment with details. But what size of files you have preferab=
ly on
> >> your partition? Moreover, could you share strace output anyway? Be=
cause
> >> it can be a basis for understanding of achieving the issue reprodu=
cing
> >> and analysis of execution environment.
> >
> > Essentially there are three kind of files: large ones about 700MB-2=
GB,
> > video, written by rtorrent/libtorrent (with no preallocation, if it
> > matters)and physics numerical simulation files - about 2GB data fil=
es
> > and few killobytes long description files.
> >
> >>
> >> If you want to try to investigate and fix the issue by yourself th=
en
> >> your strace output is needed also.
> >>
> >> By the way, could you share your dmesg output for analysis?
> >
> > strace and dmesg output attached. Mount is in progress.
> >
> >>
> >> I think also it can be very useful lscp and lssu output before sud=
den
> >> power off and after mount is ended successfully. Could you share i=
t?
> >
> > It will be a bit hard to get the before data, but when mount will b=
e
> > finished I'll send you after results.
> >
> >
> > I'll try to reproduce and get the before results too, but I am not
> > sure about it.
> >
> >
> > Best regards,
> > Aleksandrov Sergey Vasil'evich


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
