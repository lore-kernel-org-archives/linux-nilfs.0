From: Elmer Zhang <freeboy6716-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Which version of nilfs do you use?
Date: Fri, 28 Dec 2012 10:20:08 +0800
Message-ID: <BB9A0F28-A902-4FE4-BA58-A66EA93290F8@gmail.com>
References: <AAEC3976-3D79-4170-B1DC-2A04499392DE@gmail.com> <1902997.ayblf9kj7g@coil>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:content-type:mime-version:subject:from:in-reply-to:date
         :cc:content-transfer-encoding:message-id:references:to:x-mailer;
        bh=IePKPOuFIHqXYoiqh2k8gqiAWLqnb4KkRKFKaXzKpXw=;
        b=vWVCtUC7V/QXhxAGeolLb1mgUf/LQNsX58eGiuKZbbHqTqXAMeKIHHVq/Fol15iZzK
         MpoP0ft1q+Bb2aJcoGbuIP/0LOTOMXTcCq3Z6PXuf1/Awvopmh38AqmBN/n2jTRKwvy7
         0hzzYM4w5EOGINjxAj/YbIPSXjlGGLIRh3+bJEvKb0FFUDMZMEGxOymx6OihJBcfbp+z
         1bebWLq1c7GAQ1K+lS5WUDNCvUzlT6bhlZGxV02liT9eZH2yOIUhpRAv4qzIhpKDKnHW
         qd6l2vH9djti7PoCJC0vPGjtaiU3/znhCOvlsgndDh28JarC8XfiPUj7s68vObPR6EVJ
         OjoA==
In-Reply-To: <1902997.ayblf9kj7g@coil>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

There is more than 2TB of data and a large number of databases, tables =
in our MySQL service. The conventional cold backup methods can not meet=
 our needs. So we are trying to find some other methods.

I copied the MySQL files after shut MySQL done. The same data runs well=
 with ext4 file system on another server, so I can confirm that my orig=
inal data is no problem.

Elmer Zhang


=D4=DA 2012-12-27=A3=AC18:35=A3=ACdexen deVries <dexen.devries-Re5JQEeQqe8@public.gmane.org=
m> =D0=B4=B5=C0=A3=BA

> Hi Elmer,
>=20
>=20
> On Thursday 27 of December 2012 17:47:34 you wrote:
>> I am trying to use NILFS2 to make MySQL cold backup, but  the MySQL =
tables
>> often be crashed. It seems there is some problems with nilfs filesys=
tem.
>>=20
>> I have described how I use nilfs in this mail:
>> http://www.mail-archive.com/linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg01481.htm=
l
>>=20
>> Can I know which version of nilfs do you use, and what do you use ni=
lfs for?
>=20
> FWIW,  I have MySQL installation on NILFS2 and it works just fine. Th=
e server=20
> is only under light load, thou. MySQL version 5.5.27 (and 5.1.50 earl=
ier on);=20
> NILFS2 from kernel v3.0 and later, up to v3.5.
>=20
> Perhaps your problems have something to do with MySQL recovery of dat=
a from=20
> the cold backup? In MySQL Reference Manual chapter 7 -- Backup and Re=
covery=20
> covers the subject.
>=20
> If I'm reading your other email correctly, it seems you copied MyISAM=
 files=20
> without shutting MySQL down first. That's not supposed to be done wit=
h non-
> transactional tables, AFAIK, and I'd suspect this as the main trouble=
 source.=20
>=20
> On the other hand, InnoDB tables should survive being copied from wor=
king=20
> MySQL, as long as you observe correct order of (table, log files) cop=
ying --=20
> not sure which goes first, it's in the docs.
>=20
>=20
> Cheers,
> --=20
> dexen deVries
>=20
> [[[=A1=FD][=A1=FA]]]
>=20
>=20
> Reality is just a convenient measure of complexity.
>                -- Alvy Ray Smith

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
