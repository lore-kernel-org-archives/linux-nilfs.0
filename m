From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Which version of nilfs do you use?
Date: Thu, 27 Dec 2012 11:35:13 +0100
Message-ID: <1902997.ayblf9kj7g@coil>
References: <AAEC3976-3D79-4170-B1DC-2A04499392DE@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:from:to:cc:subject:date:message-id:x-face:user-agent
         :in-reply-to:references:mime-version:content-transfer-encoding
         :content-type;
        bh=h9fR5pJL46VK0xDxy+RXzrXaIOz8SJgWj2qs7A0DJAA=;
        b=gVnV5PUFs6UbswkIhnaI61Tucpc8OUTaanibsWcYJC3XVaGXYWQI6611rhIJWFSqBR
         vSB7keK0SPQQ6PHA+qBc0baF9cIzipqxdx5Li5fuS8wU5pJDW35Tb4Xt9KVkj0wMlZjW
         vdI84XCM/yx3Ow5j8OQ+kqrmGnC7DH3xa38ZpzXV6IetsGnGf47mUz/A1tE4z/g7B7Ei
         m/FR+z8DNcMNKvMu+/whfHyzg/wXH3MVhmxMyByO9ggUVM3oboL/y9HttvLiZhm3WRrB
         caRE4R8Wk4FVOEIbmyZ+2gzQiYCpiTudj+f1IkBcyIZxn8Iq9KXAriB6MhZhFppZyhhk
         +3bg==
In-Reply-To: <AAEC3976-3D79-4170-B1DC-2A04499392DE-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Elmer Zhang <freeboy6716-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hi Elmer,


On Thursday 27 of December 2012 17:47:34 you wrote:
> I am trying to use NILFS2 to make MySQL cold backup, but  the MySQL t=
ables
> often be crashed. It seems there is some problems with nilfs filesyst=
em.
>=20
> I have described how I use nilfs in this mail:
> http://www.mail-archive.com/linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg01481.html
>=20
> Can I know which version of nilfs do you use, and what do you use nil=
fs for?

=46WIW,  I have MySQL installation on NILFS2 and it works just fine. Th=
e server=20
is only under light load, thou. MySQL version 5.5.27 (and 5.1.50 earlie=
r on);=20
NILFS2 from kernel v3.0 and later, up to v3.5.

Perhaps your problems have something to do with MySQL recovery of data =
from=20
the cold backup? In MySQL Reference Manual chapter 7 -- Backup and Reco=
very=20
covers the subject.

If I'm reading your other email correctly, it seems you copied MyISAM f=
iles=20
without shutting MySQL down first. That's not supposed to be done with =
non-
transactional tables, AFAIK, and I'd suspect this as the main trouble s=
ource.=20

On the other hand, InnoDB tables should survive being copied from worki=
ng=20
MySQL, as long as you observe correct order of (table, log files) copyi=
ng --=20
not sure which goes first, it's in the docs.


Cheers,
--=20
dexen deVries

[[[=E2=86=93][=E2=86=92]]]


Reality is just a convenient measure of complexity.
                -- Alvy Ray Smith
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
