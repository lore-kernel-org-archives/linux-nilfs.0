From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: It is not possible to restore file from a mounted snapshot using
 a hardlink
Date: Sun, 27 Feb 2011 11:02:17 -0500
Message-ID: <-5862432177062534167@unknownmsgid>
References: <201102271420.57110.dexen.devries@gmail.com>
Mime-Version: 1.0 (iPhone Mail 8B117)
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:references:from:in-reply-to:mime-version:date
         :message-id:subject:to:cc:content-type:content-transfer-encoding;
        bh=1omCuwHxbliO9XxvlYuI9pf5umz/J7QZ7nGUOZMiG8Y=;
        b=BMnrirBZ9J7SgHERhzclKIr2RFXNRGaaY00aGMZtFpYSWeDy2zorIeccymrJgd0/Ka
         EGMivAa8Yj3LL1ztQe8eJ6Ac8F/S18N5sl9UAcKQJYGVPxb7Tox3LfzYYcaKk6N8FP21
         nmqQbnaYSJf/r7Ua30ha624t0OL9dGyK1fzNc=
In-Reply-To: <201102271420.57110.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Just after replying I noticed you talked about cp=3D and noticed I sent
to the nilfs mailing list and not btrfs !  So cp --reflink does not
work on NILFS but would be a nice feature :)

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
