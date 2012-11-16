From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: very large mount time after unxepected power down
Date: Fri, 16 Nov 2012 10:53:55 +0400
Message-ID: <1353048835.2029.17.camel@slavad-ubuntu>
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
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=xGydPi3IMFytDq6LKFrwld74uh21KZmJeVNTY99X0OQ=;
	b=I+3JbFPgNBwz8lIAbqc3byUe1OiT2X1NLUDRdCUTe0vLi0BA5tZM4nk/f1KIhNgirG4Hu4k63qp5y+5KLyRLACcUGO519br5HFlAfLjLJ1vTcAL1N2w0x5hHkgB1GnPS;
In-Reply-To: <CAFPMYnFLSZW068cFZ4FqDKF5sS_zF3SoV=vPG2=m+kvaxq-BZA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?=D0=A1=D0=B5=D1=80=D0=B3=D0=B5=D0=B9_?= =?UTF-8?Q?=D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B0=D0=BD=D0=B4=D1=80=D0=BE?= =?UTF-8?Q?=D0=B2?= <splavgm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 2012-11-16 at 09:40 +0300, =D0=A1=D0=B5=D1=80=D0=B3=D0=B5=D0=B9=
 =D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B0=D0=BD=D0=B4=D1=80=D0=BE=D0=B2 wro=
te:
> Sorry, but I didn't save top output this time..
> But for sure, it was "mount /dev/md0 /nfs/raid -o ...." process. The
> CPU load was fully in kernel space.
> So while the mount call, the kernel was doing something very both IO
> and CPU intensive for almost 50 minutes.
> As I have already written the load was about 80MB/s read IO according
> to iotop, and about 60% of the first CPU core according to top.
>=20

Ok. I see.

I suspect currently that you can have some special corruption of the
volume state that is resulted in so long recovery code working time. Bu=
t
if so, then you can have some warning messages in system log from
recovery subsystem (maybe not, of course). As I know, Gentoo has specia=
l
log that keeps error and warning messages from the kernel. Could you
check that shared by you the dmesg output contains error messages from
kernel?

Moreover, current functionality state of fsck.nilfs2 is not very useful
yet. But it can check superblocks and segment summary headers validity.
Maybe it makes sense to check your volume by fsck.nilfs2. Could you try
to check your volume?

With the best regards,
Vyacheslav Dubeyko.


> If this info is not sufficient I'll try to reproduce the case as soon
> as possible.
> --------------------------------------------------
> =D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B0=D0=BD=D0=B4=D1=80=D0=BE=D0=B2 =D0=
=A1=D0=B5=D1=80=D0=B3=D0=B5=D0=B9 =D0=92=D0=B0=D1=81=D0=B8=D0=BB=D1=8C=D0=
=B5=D0=B2=D0=B8=D1=87
>=20
>=20
> 2012/11/16 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>:
> > On Thu, 2012-11-15 at 16:08 +0300, =D0=A1=D0=B5=D1=80=D0=B3=D0=B5=D0=
=B9 =D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B0=D0=BD=D0=B4=D1=80=D0=BE=D0=B2 =
wrote:
> >> lssu, lscp after mount. Actually I missed the moment and
> >> nilfs_cleanerd has cleaned some data.
> >> Mount took about 50 minutes.
> >>
> >
> > Thank you for info.
> >
> > I have some additional questions after thinking about issue. As I
> > remember, you wrote that you tried to understand what process eats =
CPU
> > time during issue. But you don't share details about it. Could you =
share
> > details of "top" and "ps ax" outputs for the case of issue reproduc=
ing?
> >
> > With the best regards,
> > Vyacheslav Dubeyko.
> >
> >> --------------------------------------------------
> >> =D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B0=D0=BD=D0=B4=D1=80=D0=BE=D0=B2=
 =D0=A1=D0=B5=D1=80=D0=B3=D0=B5=D0=B9 =D0=92=D0=B0=D1=81=D0=B8=D0=BB=D1=
=8C=D0=B5=D0=B2=D0=B8=D1=87
> >>
> >>


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
