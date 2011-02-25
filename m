From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: FIBMAP ioctl missing
Date: Fri, 25 Feb 2011 09:02:46 +0100
Message-ID: <201102250902.46443.dexen.devries@gmail.com>
References: <201102242334.38044.dexen.devries@gmail.com> <-2895307820866716365@unknownmsgid>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        bh=/3RVwC9XJ4inPvZVkqp/wBlTOfD7jAYK+DtsOGSmf1s=;
        b=ZqzZJYM1XS+Uc9JMbHrem1UxsRegc7k0YT8tRiEoftJiEmX1lLRRlgQAss15oyJ3mj
         ZgMeNVFoLANLnIeBNP8T93RyfJ57DMh5o/djIKuHLH6vArfUM//Q9K3Ja6xIljjpzUYz
         JpRpwj+bqKGKR98HMGFYTlKWIgj12GR2buiLo=
In-Reply-To: <-2895307820866716365@unknownmsgid>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Friday 25 of February 2011 01:21:53 you wrote:
> Just thinking about it fast, NILFS2 is a filesystem that wraps around
> the disk forever and LILO writes a bitmap of where the kernel image
> is. So if NILFS moves the image then LILO is at lost and will load
> some data which is not the kernel instead. A fast guess I would say
> using LILO on NILFS is impossible by design.

That's a good point, thanks.

A dirty hack comes to my mind, back from the days of DOS: files marked =
with=20
`system' attribute were not moved during defrag (important for io.sys &=
=20
msdos.sys). Perhaps using some sensible attribute (i? t? a new one?) wo=
uld=20
prevent nilfs_cleanerd from moving the file?

Would require implementing attributes on NILFS, thou.

Regards,
--=20
dexen deVries

[[[=E2=86=93][=E2=86=92]]]

> how does a C compiler get to be that big? what is all that code doing=
?

iterators, string objects, and a full set of C macros that ensure
boundary conditions and improve interfaces.

ron minnich, in response to Charles Forsyth

http://9fans.net/archive/2011/02/90
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
