From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: NILFS development contribution
Date: Thu, 03 May 2012 15:59:38 +0900 (JST)
Message-ID: <20120503.155938.77323918.konishi.ryusuke@lab.ntt.co.jp>
References: <CABECqUEGCxizjgZPWUazTJBZYWTUTCQnbieDSaSUMj8oGeMnEQ@mail.gmail.com>
	<20120422.181504.62372140.konishi.ryusuke@lab.ntt.co.jp>
	<CABECqUFm=7V7keg5PJYetJim+O=f7k5UByJF_nbEpKCauY3kxA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABECqUFm=7V7keg5PJYetJim+O=f7k5UByJF_nbEpKCauY3kxA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-8859-1"
To: karuna.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Wed, 25 Apr 2012 11:18:41 +0530, santhosh kumars wrote:
> On Sun, Apr 22, 2012 at 2:45 PM, Ryusuke Konishi
> <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:
> > Hi,
> > On Wed, 18 Apr 2012 16:35:28 +0530, santhosh kumars wrote:
> >> Hi,
> >> I have gone through the documents of NILFS mentioned on the home p=
age
> >> of NILFS. I have interest in file system development and have some
> >> background knowledge about the linux VFS layer and have also creat=
ed a
> >> sample memory based file system which resides only in the memory. =
In
> >> one of the slides "Development of a New Logstructured File System =
for
> >> Linux", there is a mention to involve outside developers in the
> >> project as well. I too want to contribute in the development of ni=
lfs
> >> so I wanted to know where can I start from to get involved in the
> >> project.can any one help me for =A0to get start please.
> >>
> >> Thanks,
> >> karuanakar.
> >
> > Sorry for my late reply. I was quite busy this week.
> >
> >
> > Contribution to our project is of course welcome.
> >
> > NILFS is now a part of the Linux kernel, and is developed using pub=
lic
> > git trees and the linux-nilfs mailing list. =A0I am taking in funct=
ion
> > enhancement as well as bug fixes which outside developers sent to m=
e,
> > simlilarly with usual Linux/OSS development.
> >
> > My recommendation for starting to get involved in the project is to
> > utilize github; both userland utilities and nilfs branch of kernel
> > tree are maintained there.
> >
> > This project has many todo items, which is listed in lower part of
> > http://www.nilfs.org/en/current_status.html
> >
> > My recent concern is improving garbage collection algorithm and I/O
> > performance of in-kernel filesystem module.
> >
> > What is necessary is just to do your favorite or possible thing,
> > however, if you can provide help to these priorities, I would
> > appreciate it :)
> >
> >
> > Thanks,
> > Ryusuke Konishi
>=20
> hi  Ryusuke Konishi
> Thanks for your mail and information. First of all I would like to
> work on  fixing bugs.
> Just i want to know where can i find the list of bugs, so that i can
> move forward.

I think one good start is to use "xfstest", an test suites for xfs and
other filesystems.

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
