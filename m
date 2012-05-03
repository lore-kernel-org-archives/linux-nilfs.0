From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: man nilfs-clean
Date: Thu, 03 May 2012 13:13:29 +0900 (JST)
Message-ID: <20120503.131329.212713486.konishi.ryusuke@lab.ntt.co.jp>
References: <CAJi=nxo9vTiYeHYRZ+vXSP_weHbW+0XaENAm7QhrAaebGeRYuw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJi=nxo9vTiYeHYRZ+vXSP_weHbW+0XaENAm7QhrAaebGeRYuw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-8859-1"
To: tiago.caxias-FFYn/CNdgSA@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 2 May 2012 15:44:33 +0100, Tiago Caxias wrote:
> Hi all.
>=20
> First of all let me thank and congratulate everyone on the nilfs2 pro=
ject.
>=20
> I believe I found a typo in the nilfs-clean man page. (is an interger
> value -> is an integer value)

Thanks, I will apply it.

> I cloned the git repo, edited the file and then I did a git diff.
> Not sure if this is the proper way to post a "patch" but here's my fi=
rst try.

That's OK.

One thing I will ask you to do, is to include a "Singed-off-by" line
(sob line for short) in your patch, which certifies that you wrote it
or otherwise have the right to pass it on as an open-source patch.
even if it's a typo fix ;)

The sob line is inserted before the source code diff in the following
form:

Signed-off-by: Tiago Caxias <your e-mail address>

This is automatically done if you used "git commit" command with an -s
option; usually you can make a patch from the local change by "git
commit -a -s".

Then you can confirm or output the patch by "git show" or "git
format-patch HEAD^.."

I think that it is good to learn the function of git little by little
starting from hand working since git has various functions.


Thanks,
Ryusuke Konishi

> diff --git a/man/nilfs-clean.8 b/man/nilfs-clean.8
> index 758b9e1..04e11c6 100644
> --- a/man/nilfs-clean.8
> +++ b/man/nilfs-clean.8
> @@ -45,7 +45,7 @@ Display help message and exit.
> =A0.TP
> =A0\fB\-p\fR, \fB\-\-protection-period=3D\fIinterval\fR
> =A0Set protection period for a cleaner run.=A0 The \fIinterval\fR par=
ameter
> -is an interger value and specifies the minimum time that deleted or
> +is an integer value and specifies the minimum time that deleted or
> =A0overrode data will be preserved in the file system.=A0 Smaller val=
ues will
> =A0increase free space made by garbage collection.=A0 Optionally, the
> =A0\fIinterval\fP parameter may be suffixed by one of the following
>=20
> --
> Best regards,
> Tiago Caxias
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
