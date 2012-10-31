From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: very large mount time after unxepected power down
Date: Wed, 31 Oct 2012 10:13:22 +0400
Message-ID: <1351664002.2105.3.camel@slavad-ubuntu>
References: <CAFPMYnE3ybWO4o=E1UonAZJ7Uwn5y9n4840ksYGAu7qAYJ0zKw@mail.gmail.com>
	 <CAFPMYnEZ28qvwkE3kaB59h2rD_8noT+gQtp7Hs6uvmHcL6KzYA@mail.gmail.com>
	 <1351604965.2069.13.camel@slavad-ubuntu>
	 <CAFPMYnHhtFxuVZOMu9MZ6Xb74mFPm1a-4axyFKkHiJjDEW_4BA@mail.gmail.com>
	 <1351608774.2026.6.camel@slavad-ubuntu>
	 <CAFPMYnGn4aNf=5B9v93TtTc6x4hG1ULgt0P9i75uO=xGX0U2bg@mail.gmail.com>
	 <AFFE5823-0AD0-488C-B465-55CF45A10785@dubeyko.com>
	 <CAFPMYnEtXMr1UOVYdNNRxxH83=O-_UOR_ZhCdqjh+JuUNrFiDA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=gloTanddX2jlf4ANw2zsfYewVUqD7GIN7ZSvbzO3xKM=;
	b=TCzdr+rhDiP3kRktlf7cIbVVw1xZwOg43aFqmXHFYCtZ0BpNHMDw653/2UNfyls2miuGZqoQUQSFNZS7md1qSncn5DOQBiq5Q4VBDy2Bm0at+Mcz/v0AqrhwXKCbJ1u2;
In-Reply-To: <CAFPMYnEtXMr1UOVYdNNRxxH83=O-_UOR_ZhCdqjh+JuUNrFiDA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?=D0=A1=D0=B5=D1=80=D0=B3=D0=B5=D0=B9_?= =?UTF-8?Q?=D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B0=D0=BD=D0=B4=D1=80=D0=BE?= =?UTF-8?Q?=D0=B2?= <splavgm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 2012-10-31 at 06:51 +0300, =D0=A1=D0=B5=D1=80=D0=B3=D0=B5=D0=B9=
 =D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B0=D0=BD=D0=B4=D1=80=D0=BE=D0=B2 wro=
te:
> >>> Could you try to reproduce the issue with log_priority enhanced t=
o debug
> >>> level (I mean option in nilfs_cleanerd.conf) and share messages l=
og
> >>> again?
> >>
> >> I can, but a bit later, if you don''t mind(in 24 hours).
> >>
> >
> > Please, try to mount with using "strace". The output of "strace" ca=
n be useful. Please, share it after trying.
>=20
> I really dont'n know, what happened, but I failed to reproduce...
> The only thing that have changed is version of nilfs-utils. It seems
> that somewhere between 2.1.1 and 2.1.4 the bug was fixed.
> Should I try to reprodce the bug with v 2.1.1, or we will consider th=
e
> question closed?
>=20

I think that it makes sense to try to reproduce the issue with 2.1.1
version. If you can reproduce on 2.1.1 version but on 2.1.4 can't then
it means that bug was fixed.

But if you are happy without it then don't worry. :-)

With the best regards,
Vyacheslav Dubeyko.

> --------------------------------------------------
> Aleksandrov Sergey Vasil'evich


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
