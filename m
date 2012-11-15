From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: very large mount time after unxepected power down
Date: Thu, 15 Nov 2012 10:32:52 +0400
Message-ID: <1352961172.2076.10.camel@slavad-ubuntu>
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
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=69zYTeff0xvwxf8vnohtRbXJA/mYXEDVCNa/pSsaxC8=;
	b=FNdOzwwCd0R/w4fRvVIkq8qu3pS1icMePy/qOoj7wTsRURsJ3nxvBoC0fKfa00OwcnmMHQeduFwbkHQ1Up0FpzKhQKedIn/cvBPv7fNMeimXkB3uXdkuaBB/eR0R7Mm/;
In-Reply-To: <CAFPMYnE2j0DjiqcSuJRiJX5hfDjHoyh-WUhG0cMav9K=tbsLDQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?=D0=A1=D0=B5=D1=80=D0=B3=D0=B5=D0=B9_?= =?UTF-8?Q?=D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B0=D0=BD=D0=B4=D1=80=D0=BE?= =?UTF-8?Q?=D0=B2?= <splavgm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On Thu, 2012-11-15 at 07:07 +0300, =D0=A1=D0=B5=D1=80=D0=B3=D0=B5=D0=B9=
 =D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B0=D0=BD=D0=B4=D1=80=D0=BE=D0=B2 wro=
te:
> Hi,
> The bug appeared again. And apparently it's a kernel one.
> My bad that I didn't notice that the CPU activity wals in kernel spac=
e.
> The mount process hangs inside mount call itself. I've an strace
> output, but it's not informative, it perfectly normal besides the han=
g
> in mount call.

I will try to reproduce the issue. As I remember, you described your
environment with details. But what size of files you have preferably on
your partition? Moreover, could you share strace output anyway? Because
it can be a basis for understanding of achieving the issue reproducing
and analysis of execution environment.

If you want to try to investigate and fix the issue by yourself then
your strace output is needed also.

By the way, could you share your dmesg output for analysis?

I think also it can be very useful lscp and lssu output before sudden
power off and after mount is ended successfully. Could you share it?

With the best regards,
Vyacheslav Dubeyko.

> I've a very few experience in catching kernel bugs like that, but I'l=
l
> do my best to help.
>=20
>=20
> According to my observations, the bug takes place only after emergenc=
y
> power down after a rather long uptime, may be even the time it takes
> to mount the partition is proportional to ether uptime or the amount
> of io since last mount.
>=20
> I left FS unclean, so it is possible to do some tests, but I would
> like to see it up and running as soon as possible.
>=20
>=20
> Best regards,
> Aleksandrov Sergey Vasil'evich


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
