From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: FIBMAP ioctl missing
Date: Thu, 24 Feb 2011 19:21:53 -0500
Message-ID: <-2895307820866716365@unknownmsgid>
References: <201102242334.38044.dexen.devries@gmail.com>
Mime-Version: 1.0 (iPhone Mail 8B117)
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:references:from:in-reply-to:mime-version:date
         :message-id:subject:to:cc:content-type:content-transfer-encoding;
        bh=skPIbSF6Ib2e2ZqumCAQoRs+X4FAkvyH4zyLJ0cQwGY=;
        b=GUb4XzB2NtagFxEPlFOi+Wqls1sRcXNVjx98T1xgI/g60aIyNlekyRuy8JZwK3v2pE
         pNHEksc+7DrGumLyy2U9Q7Exp/ok0pliI2xNP7kUA/OF/7jfNP4ZPYw/U/9wO9fzTE9r
         uzpF7sc1EFcuIpjjDankD+SuzguSwPQJ9xK+g=
In-Reply-To: <201102242334.38044.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Just thinking about it fast, NILFS2 is a filesystem that wraps around
the disk forever and LILO writes a bitmap of where the kernel image
is. So if NILFS moves the image then LILO is at lost and will load
some data which is not the kernel instead. A fast guess I would say
using LILO on NILFS is impossible by design.

Envoy=C3=A9 de mon appareil mobile.

J=C3=A9r=C3=B4me Poulin
Solutions G.A.

On 2011-02-24, at 17:34, dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Hello,
>
> as NILFS2 doesn't implement the FIBMAP ioctl, LILO cannot be used on =
it.
> I've just learned about it the hard way -- after migrating computer's=
 only
> filesystem to NILFS2, running LILO returns:
> ioctl FIBMAP: Invalid argument
>
> I see the FS_IOC_FIEMAP is implemented; perhaps some wrapper around c=
ould be
> used to provide FIBMAP as well?
>
>
> Regards,
> --
> dexen deVries
>
> [[[=E2=86=93][=E2=86=92]]]
>
>> how does a C compiler get to be that big? what is all that code doin=
g?
>
> iterators, string objects, and a full set of C macros that ensure
> boundary conditions and improve interfaces.
>
> ron minnich, in response to Charles Forsyth
>
> http://9fans.net/archive/2011/02/90
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
