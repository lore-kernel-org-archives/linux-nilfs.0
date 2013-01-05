From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: A lot of NILFS: bad btree node messages (readonly fs)
Date: Sat, 5 Jan 2013 14:40:19 +0300
Message-ID: <C2F4A5DE-538B-4468-9A6A-BA619EDDA462@dubeyko.com>
References: <20121129210650.GA4028@wloczykij> <1354255744.2090.3.camel@slavad-ubuntu> <20121130073219.GB4028@wloczykij> <1356415552.2052.11.camel@slavad-ubuntu> <20130103214913.GE2080@wloczykij> <28ABE57F-66DD-491E-9FDB-A6CE3CF773FB@dubeyko.com> <20130104191633.GF2080@wloczykij>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=9GiywgerGL6bu5R0bh5mV+bvqDw9lLCaxiL3CsIEfoM=;
	b=ZCZYWlelBAw+U+uRuFLJQYv1hOP65cFC/f0f42cE85EpgCXIkQU3j1Wb2UHnGqdoanZVVoC1OkIP3Dz0ZG+K7+DbENUIIlmzQ0SKV/keceH2MXHz0fkwE371+t/Cle3Z;
In-Reply-To: <20130104191633.GF2080@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


On Jan 4, 2013, at 10:16 PM, Piotr Szymaniak wrote:

[snip]
>>=20
>> So, maybe the nature of /var/tmp/kdecache-$USER/foo.kcache is a reas=
on
>> of the issue. It is a very interesting detail. Could you share more
>> details about this file? I mean size, creation time, modification
>> time, owner, rights and so on. Moreover, could you share more detail=
s
>> about your hardware environment? I mean CPU and RAM details.
>=20
> maszn ~ # file /var/tmp/kdecache-appe/plasma_theme_Transparent-sima84=
=2Ekcache
> gives me an i/o error and remounts ro.
>=20
> maszn ~ # stat /var/tmp/kdecache-appe/plasma_theme_Transparent-sima84=
=2Ekcache
>  File: =91/var/tmp/kdecache-appe/plasma_theme_Transparent-sima84.kcac=
he=92
>  Size: 84213856        Blocks: 165144     IO Block: 4096   regular fi=
le
> Device: 802h/2050d      Inode: 102230      Links: 1
> Access: (0664/-rw-rw-r--)  Uid: ( 1001/   appe)   Gid: (  414/   appe=
)
> Access: 2012-11-14 16:15:01.377207479 +0100
> Modify: 2012-11-14 16:15:01.377207479 +0100
> Change: 2012-11-14 16:15:01.377207479 +0100
>=20
> Intel Pentium Dual-Core E5400, 4GB RAM, nilfs2 is located on part of
> Kingston SSD. It runs x86 Gentoo Linux with vanilla kernel (from
> kernel.org) and I try to keep it up to date (3.6.8 right now, but I w=
as
> away for some time) and recent nilfs-utils from the portage tree (thi=
s
> could also be considered as "up to date" or "up to upstream releases"=
).
>=20

Thank you for details.

>=20
>> I think that it can be very interesting to know about how this file =
is
>> distributed on the volume. Could you get by means of dumpseg
>> information about several last segments? I don't know how many it
>> needs for understanding but maybe about 10 can be enough for the
>> beginning.
>=20
> The file is pretty old so last 10 segments won't solve the issue, rig=
ht?
>=20

You know that only patch can solve the issue. :-)

I simply try to collect enough details about the issue for deep underst=
anding of it. There are two ways of issue investigation: (1) reproducin=
g on my side; (2) preparing special debug output that can give more det=
ails about the issue on your side. So, I feel necessity to prepare a pa=
tch with additional debug output that can be enabled in NILFS2 in the c=
ase of special needs.

Currently, I have such understanding of the situation. As I can see fro=
m the error output and preliminary code analysis, it occurs situation w=
hen allocation code discovers that memory page is uptodate before readi=
ng. It can means that we have synchronization issue. But it needs to in=
vestigate situation more deeply.

 Now I am preparing patch for another issue with very long mount time. =
So, when I end this activity then I begin more deep investigation of th=
e issue with readonly fs.

Thanks,
Vyacheslav Dubeyko.

> Piotr Szymaniak.
> --=20
> Natezyl sluch. Nic poza odglosami owadow z dziedzinca i naszeptywanie=
m
> spryskiwaczy trawnika. Nic poza miarowym kapaniem z kranu w lazience.
> To bylo niczym zycie, skapujace kropla po kropli. K a p, k a p, k a p=
,
> wszystko w kanal.
>  -- Graham Masterton, "The Burning"

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
