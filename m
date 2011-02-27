From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: It is not possible to restore file from a mounted snapshot using
 a hardlink
Date: Sun, 27 Feb 2011 10:56:25 -0500
Message-ID: <-5130718212985067227@unknownmsgid>
References: <201102271420.57110.dexen.devries@gmail.com>
Mime-Version: 1.0 (iPhone Mail 8B117)
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:references:from:in-reply-to:mime-version:date
         :message-id:subject:to:cc:content-type:content-transfer-encoding;
        bh=mw1RaIa0VQE8ySl2l3SpH0l1pjBc72ppy7PYWmFeaZk=;
        b=R0CDqNe7mlyR4RmTSva3+cRZ5/8LrWJYQ8ZXkvhakny5bcdjQxZXwCHxeJauVs+2w8
         9i2bDRUTViGB6QiOuBLV+nhUSXBuAE7EP/yOTpqz4ZYZOcH+obup95giE60DY9l5Q9mC
         2RZgqgt9Gr2EDdpivWY65CYAm6hWHSNqNyNkQ=
In-Reply-To: <201102271420.57110.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

In fact, hard links are not supposed to work but cp --reflink
*should* work but it does not seem to. cp --reflink is what you would
need to achieve what you want.

Envoy=E9 de mon appareil mobile.

J=E9r=F4me Poulin
Solutions G.A.

On 2011-02-27, at 08:20, dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Hello,
>
>
> The following is more of a feature request than problem report, actua=
lly.
>
> I've mounted an older snapshot and tried to restore (add it to the cu=
rrent
> filesystem state) by creating a hardlink.
> Roughly like:
> mount /dev/sdb3 ~/current
> mount.nilfs2 /dev/sdb3 ~/old -o ro,cp=3D1234
> cd ~/current
> ln ~/old/file.bin ./restored-file.bin
>
> The `ln' returned `Invalid cross-device link'.
>
> I expected such hardlink to have semantics of re-using all the data b=
locks &
> metadata of file.bin from snapshot as restored-file.bin, so no duplic=
ation of
> data blocks happens.
>
>
> Regards,
> --
> dexen deVries
>
> ``One can't proceed from the informal to the formal by formal means.'=
'
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
