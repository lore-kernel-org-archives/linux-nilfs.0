From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Kernel Bug: unable to handle kernel paging request
Date: Sat, 27 Jul 2013 21:06:52 +0400
Message-ID: <680DC2BF-EEEC-445C-BA5B-DF966CABF1BA@dubeyko.com>
References: <CALJXSJquK6YxGKuH97Ec2CTMyJaZrJjOfePSKtgPDm8_9YXzzw@mail.gmail.com> <CALJXSJoW9Qpp9t42u_k4cW3gO6qzSPoeCjtQDU3tDKq6TJ=K8Q@mail.gmail.com> <F4156394-8A25-4F81-81C3-9921CB00BD92@dubeyko.com> <CALJXSJrj0J_-ZUCOurJXaYhx_wEJwxb2_5OOJjQSSmmP-PQDgg@mail.gmail.com> <1374578141.2226.5.camel@slavad-ubuntu> <CALJXSJrY22eGkYA76wwL4moAdsjV+_PUtvVO6tt5K16hzMh8xQ@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=95EpaU3F9TWjAkT3/GGZJZ5SAwBQDwRS58y0oxTp0tM=;
	b=pZI6lDeT4Hk023mV6GNngF8pZX6M04cN9p8soTJ3nZtCu0foKBQDIH/w6FKn8t+Db0C7+ePg3M6XIdR4hYkfM/x3rKITW8ujZ8EmOT4YmgPr3AgBiQgaBrhZ1uQdBQiL;
In-Reply-To: <CALJXSJrY22eGkYA76wwL4moAdsjV+_PUtvVO6tt5K16hzMh8xQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?iso-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>


On Jul 26, 2013, at 10:13 PM, J=E9r=F4me Poulin wrote:

> Good afternoon,
>=20
> I have more informations to add to the bug.
>=20

Thank you for additional info.

[snip]
> I was able to reproduce consistently the problem.
> 1. Make a snapshot of a checkpoint and mount it.
> 2. Read from the checkpoint (make a backup).
> 3. Issue apt-get update.
>=20

I tried to reproduce the issue but I haven't success in it.
Could you describe the reproducing path in more details?

Moreover, could you share lscp utility output for your NILFS2 partition=
?

[snip]
>=20
> Here are the log files.
> 1. strace from the backup was still reading, it did not stop.
> 2. apt-get-crash.log
> 4362  13:32:04 read(6, " Debugging symbols\nHomepage: htt"..., 32052)=
 =3D 32052
> 4362  13:32:04 read(6, "tcp-wrappers/libwrap0-dev_7.6.q-"..., 32460) =
=3D 32460
> 4362  13:32:04 read(6, "bdevel\nInstalled-Size: 542\nMaint"..., 32710=
) =3D 32710
> 4362  13:32:04 read(6, "ian.org>\nArchitecture: i386\nSour"..., 32558=
) =3D 32558
> 4362  13:32:04 read(6, "l-Maintainer: XCB Developers <xc"..., 32613) =
=3D 32613
> 4362  13:32:04 read(6, "ed: 9m\n\nPackage: libxcb-xvmc0-db"..., 31979=
) =3D 31979
> 4362  13:32:04 read(6, "ibz-dev\nFilename: pool/main/x/xf"..., 32335)=
 =3D 32335
> 4362  13:32:04 read(6, "n: Ubuntu\nSupported: 9m\nTask: my"..., 31903=
) =3D 31903
> 4362  13:32:04 read(6, "\nFilename: pool/main/libx/libxpm"..., 32467)=
 =3D 32467
> 4362  13:32:04 read(6, "buntu/+filebug\nOrigin: Ubuntu\nSu"..., 31982=
) =3D 31982
> 4362  13:32:04 read(6, "chpad.net/ubuntu/+filebug\nOrigin"..., 31976)=
 =3D 31976
> 4362  13:32:04 read(6, "buntu Developers <ubuntu-devel-d"..., 32681) =
=3D 32681
> 4362  13:32:04 read(6, "-utils\nDepends: debconf (>=3D 0.5)"..., 3246=
8) =3D 32468
> 4362  13:32:04 read(6, "top, mythbuntu-backend-slave, my"..., 31678) =
=3D 31678
> 4362  13:32:04 read(6, "d5: 1b0992eebd45ca5ceadc775532a4"..., 32126) =
=3D 32126
> 4362  13:32:04 read(6, " all\nSource: munin\nVersion: 2.0."..., 32535=
) =3D 32535
> 4362  13:32:04 read(6, "fice-core | openoffice.org-hunsp"..., 32373) =
=3D 32373
> 4362  13:32:04 read(6, "ffice.org-dictionaries (1:3.3.0~"..., 32513) =
=3D 32513
> 4362  13:32:04 read(6, "hbuntu-backend-master\n\nPackage: "..., 31756=
) =3D 31756
> 4362  13:32:04 read(6, "2614b9\nSHA256: bcc70d6577dd06565"..., 32118)=
 =3D 32118
> 4362  13:32:04 read(6, "17\nSHA256: d903f798a8c38fef2b992"..., 32339)=
 =3D 32339
> -- End of file --
>=20

Could you share the full strace output?

Because in shared part of strace output I can't see any issue or failur=
e.
Moreover, the reported issue occurs in segstor thread. But, usually, se=
gctor activity
takes place after writing or flushing operation. So, it means for me th=
at a reason of the
issue is hidden in another part of the strace output or, maybe, in stra=
ce output for
backup operation. Could you share the strace output for backup operatio=
n too?

Thanks,
Vyacheslav Dubeyko.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
