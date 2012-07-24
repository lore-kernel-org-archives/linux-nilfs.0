From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: read error on superblock
Date: Tue, 24 Jul 2012 09:52:18 +0200
Message-ID: <31237317.NQxpWWcrpc@coil>
References: <2948186.vfdzh15lNi@coil> <20120724.090604.40913934.konishi.ryusuke@lab.ntt.co.jp> <1343111197.1982.32.camel@slavad-ubuntu-11>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-face:user-agent:in-reply-to
         :references:mime-version:content-transfer-encoding:content-type;
        bh=QzsZza2ZdSMhD0dfCs+84hepZ6kl/pFHMD3bXZu5ZhI=;
        b=0mI35i4XKZ4zGTQ1cXxmEQ9wAExk0w7Nk1kVqj8lPzi4hgzeqGuFtFOpvE2q9KTkUb
         fNp+IIarJ/RBhqCb32zmmQIUEGEPyAV9OOEPSbdujmF3SgTszYLGaRi3zfdFNLozRJ+f
         jd8q9PhweJ2621WNC4NcUSLvmSWJW/Zhn4wZrxfAmxDurN2jQrYfXcfnVDRpOwqzWDMu
         ZU+tIpx+Yw613cgzWvFwFRotOZUJVO8XJ1uyzX8X6gOqCIHAHJ2d/ZKoXqLa3ONc8jk3
         Pl3CtGFvhbpETl++CFsYh1Y70wtLnS2J9FOGuSYQHbNwGC3leJTdhYs0wknNGKc7ssbs
         AnXw==
In-Reply-To: <1343111197.1982.32.camel@slavad-ubuntu-11>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>

Hi Vyacheslav,


On Tuesday 24 of July 2012 10:26:37 you wrote:
> I am afraid that it is not so good from the end user point of view.
>=20
> First of all, the message "mount: /dev/sda3: can't read superblock" c=
an
> confuse user. The reason is bad sectors inside the volume but user is
> informed about impossibility to read superblock.
>=20
> Secondly, it is possible situation when it really needs to use a volu=
me
> in the case of presence of bad sectors. And I think that users can
> expect such NILFS behavior because of declared reliability.
>=20
> Unfortunately, as I can understand, NILFS hasn't bad blocks table and
> can't process situation of bad blocks presence on volume correctly. I=
t
> means that NILFS interprets bad blocks as exceptional case. But from =
my
> point of view, it makes sense to interpret bad blocks as usual thing =
and
> try to work in the presence of ones. For example, fsck potentially ca=
n
> check NILFS volume on bad blocks presence, construct bad blocks table
> and save it on the volume.
>=20
> I suggest to add "virtual" special file for bad blocks description. I=
t
> can be described by inode in ifile and all bad blocks can be describe=
d
> in DAT file as parts of this "virtual" special file. So, as a result,
> NILFS file system driver will have bad blocks table which can be a ba=
sis
> for excluding bad blocks from operation and trying to survive in the =
not
> good device environment.
>=20
> What do you think about such idea?

I believe bad sectors to be thing of the past mostly; any decent harddr=
ive=20
(probably also any decent SSD) should re-map them after some re-reads. =
Some=20
data & meta-data loss is possible, but overall the FS should be accessi=
ble=20
again.
I have no idea why my particular HDD did not re-map; perhaps it just ta=
kes=20
much longer than I gave it.

As a point of reference, XFS does not do bad block management either; h=
owever,=20
the partition driver of IRIX does bad sector management -- so it is=20
implemented one layer below the FS.


I guess it /may be/ possible to use Linux' `dm' driver in such manner.


Cheers,
--=20
dexen deVries

[[[=E2=86=93][=E2=86=92]]]

"all dichotomies are either true or false" is a true paradox because it=
's=20
paradoxical only if it is a paradox ;)
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
