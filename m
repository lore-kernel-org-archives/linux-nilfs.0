From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Kernel Bug: unable to handle kernel paging request
Date: Fri, 30 Aug 2013 09:43:50 +0400
Message-ID: <1377841430.2343.11.camel@slavad-ubuntu>
References: <CALJXSJqV5nYb_t6GMS0FpWyf1aRehAgpvebwgbJzMJfctf1b2A@mail.gmail.com>
	 <1376054125.2272.84.camel@slavad-ubuntu>
	 <20130815.073806.260411879.konishi.ryusuke@lab.ntt.co.jp>
	 <20130816.134934.27810145.konishi.ryusuke@lab.ntt.co.jp>
	 <1376636610.2301.28.camel@slavad-ubuntu>
	 <72C60256-983E-43D0-9DA1-D4A446B578BB@dubeyko.com>
	 <CALJXSJpbHN2SQWz0e2gC_hrRKG8EcnV2bWf068GWsuoa8AX5Dw@mail.gmail.com>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=Bo1YfSTq3szd0XqqqD/oqbZSz+z40DdyF6C6DtyeNNU=;
	b=G0wtHTC1CDa0p7pMRe1JEv5xUyyXBl9Z8s1V2D3kJSS2LXVHfz87ZF4h7COxy8pXVwNp4U8pkzfsZOoF2NV+UC8mTX9W+1011AtgP34QKYxTOP3bkcgEpqsJoUM0/yt9;
In-Reply-To: <CALJXSJpbHN2SQWz0e2gC_hrRKG8EcnV2bWf068GWsuoa8AX5Dw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?ISO-8859-1?Q?J=E9r=F4me?= Poulin <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, 2013-08-29 at 19:37 -0400, J=C3=A9r=C3=B4me Poulin wrote:
> On Thu, Aug 29, 2013 at 3:10 PM, Vyacheslav Dubeyko <slava-yeENwD64cLyIwRZHo2/mJg@public.gmane.org=
m> wrote:
> > I need to check independently some my suspicions about the issue. S=
o, I need in additional details.
> >
> > Did you have any mounted ext4/ext3 partitions in the background of =
the reproduced issue?
>=20
> I had /boot as ext3 mounted all that time but completely unused until
> we started diagnosing the logs.
>=20

Yes, I also has mounted ext4 partition in the background of the issue.

> >
> > Could you check that you can reproduce the issue in the case of abs=
ence any mounted
> > ext4/ext3 partitions?
> >
>=20
> Would you like me to try with /boot umounted?
>=20

Yes, it needs to check without any ext3/ext4 mounted partitions in
background. I suspect that it has some strange interaction between jbd
(ext3/ext4 journaling daemon) and segctor on the block layer. Maybe I a=
m
wrong. But I can't reproduce the issue for the case of more earlier
kernel version (3.2, for example). This kernel version hasn't some
commits for jbd/ext4/ext3. So, I need to check my assumption
independently because I can misunderstand something. I have checked man=
y
assumptions about the issue earlier but I don't catch the reason yet. I
hope that I have some real hints about the issue's reason now.

> > Could you check also that you can reproduce the issue for 3.2 or ea=
rlier kernel version?
>=20
> That would be harder to test but possible.
>=20
>=20
> I have a bigger issue though. Right now I'm running in the problem
> that the cleaner won't work anymore and partition is full. I migrated
> to ext4 until I decide making a new nilfs2 partition, I'm not sure
> I'll be able to reproduce the problem on a full FS, I could resize it
> a bit though.
>=20
> Link to this problem:
> http://permalink.gmane.org/gmane.comp.file-systems.nilfs.user/3072

Yes, it is bad. Maybe, it is another issue.

But if you can try to reproduce and confirm (or refuse) my assumption
then it will be great.

Thanks,
Vyacheslav Dubeyko.=20


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
