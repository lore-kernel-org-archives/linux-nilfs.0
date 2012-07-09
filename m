From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: nilfs2 weird issue - snapshots are gone, cleanerd not running
Date: Mon, 9 Jul 2012 22:55:40 +0400
Message-ID: <51D5FCEA-7103-4D4A-BADA-99A9780D9B68@dubeyko.com>
References: <20120709073300.GP1478@wloczykij> <1341826112.1965.6.camel@slavad-ubuntu-11> <20120709165626.GT1478@wloczykij>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=2fLpR4uWID41mGa4zGd01taYyp3mR6hs4bozcs8iOzo=;
	b=YacS1vnz05k+sI9+v53OdCIGZB1mzg0yosn38Hc0J+3S+k/3wutEhaVemBkVCtFmHg9/TZBrpfcdlXL60qambPGGmaVOCbh6HJTWzWeTQeVsEVGSvodO9hn+jnDsJ5Sg;
In-Reply-To: <20120709165626.GT1478@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Piotr,

You are right. I can reproduce this issue very simply. The nilfs_cleane=
rd doesn't started during mount really.

I can detect some suspicious output of strace during mount and next try=
ing to start of nilfs_cleanerd:

=2E...
set_tid_address(0xb76a0768)             =3D 21036
set_robust_list(0xb76a0770, 0xc)        =3D 0
futex(0xbfdd4f90, FUTEX_WAKE_PRIVATE, 1) =3D 0
futex(0xbfdd4f90, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 1, NU=
LL, bfdd4fa0) =3D -1 EAGAIN (Resource temporarily unavailable)

=2E...
mq_open("nilfs-cleanerq-2066", O_RDONLY|O_CREAT, 0600, {mq_maxmsg=3D6, =
mq_msgsize=3D4096}) =3D -1 ENOSYS (Function not implemented)

But maybe it is not reason of the problem. It needs to investigate the =
issue more deeply.

Thanks,
Vyacheslav Dubeyko.

On Jul 9, 2012, at 8:56 PM, Piotr Szymaniak wrote:

> On Mon, Jul 09, 2012 at 01:28:32PM +0400, Vyacheslav Dubeyko wrote:
>> Hi Piotr,
>>=20
>> Does system journals on your machines contain any interested details
>> about reported issue? Could you try to extract some error or warning
>> messages from system journal?
>=20
> (resend as I replied only to Vyacheslav)
>=20
> If by journals you mean logs then no. I'm only able to find some like
> this:
> Jul  3 10:32:45 wloczykij nilfs_cleanerd[1434]: resume (clean check)
> Jul  3 10:41:37 wloczykij nilfs_cleanerd[1434]: pause (clean check)
>=20
> That's all about nilfs in the last week and current log has only manu=
al
> runs related to those operation described before.
>=20
> Piotr Szymaniak.
>=20
>=20
>> On Mon, 2012-07-09 at 09:33 +0200, Piotr Szymaniak wrote:
>>> Hi.
>>>=20
>>> I've upgraded nilfs-utils (running Gentoo) on 29 july. Today I ran =
out
>>> of space on my / and found that nilfs_cleanerd isn't working. When =
I
>>> start it from the command line it exits instantly. Also, all previo=
us
>>> checkpoints on / (also on two other mountpoints on different machin=
e)
>>> are gone.
>>>=20
>>> What I did? Downgraded nilfs-utils to 2.1.1, remounted mountpoints.=
 On
>>> the second machine it's runnig fine (cleaned _all_ checkpoints), on=
 the
>>> first one with disk space issue it exits just like 2.1.3.
>>>=20
>>> Here are some fs details. Machine with disk space issues, rootfs:
>>>    CNO        DATE     TIME  MODE  FLG     NBLKINC       ICNT
>>> 147688  2012-07-09 08:38:14   cp    -        11075     242915
>>> 147689  2012-07-09 08:38:14   cp    -           60     242895
>>> (=85)
>>> 148999  2012-07-09 09:13:46   cp    -           60     242888
>>> 149000  2012-07-09 09:19:45   cp    -           44     242888
>>>=20
>>> Filesystem      Size  Used Avail Use% Mounted on
>>> rootfs           24G   13G   11G  56% /
>>>=20
>>> mount shows:
>>> /dev/sda2 on / type nilfs2 (rw,noatime,nodiratime,gcpid=3D15356)
>>>=20
>>> There's no nilfs_cleanerd with pid 15356.
>>>=20
>>>=20
>>> Second machine rootfs:
>>>   CNO        DATE     TIME  MODE  FLG     NBLKINC       ICNT
>>> 92246  2012-07-09 08:16:58   cp    -          118      44669
>>> (=85)
>>> 92439  2012-07-09 09:19:14   cp    -           29      44668
>>> 92440  2012-07-09 09:19:46   cp    -           33      44668
>>>=20
>>> Filesystem         Size  Used Avail Use% Mounted on
>>> rootfs             3.7G  888M  2.6G  26% /
>>>=20
>>> (it should be around 3G used)
>>>=20
>>> Second machine second mountpoint:
>>>   CNO        DATE     TIME  MODE  FLG     NBLKINC       ICNT
>>>  1496  2012-07-09 03:31:23   cp    -         8837     132766
>>>  1497  2012-07-09 03:31:26   cp    -          468     132766
>>>  1498  2012-07-09 03:41:27   cp    -         1474     132765
>>>=20
>>> (this fs should containt *all* 1498 checkpoints)
>>>=20
>>> Filesystem         Size  Used Avail Use% Mounted on
>>> /dev/dm-2          117G   58G   54G  76% /mnt/home_backup
>>>=20
>>> (in this one it should be around 100G of used space)
>>>=20
>>> mount:
>>> /dev/dm-2 on /mnt/home_backup type nilfs2 (rw,gcpid=3D13135)
>>> /dev/sda3 on / type nilfs2 (rw,noatime,nodiratime,gcpid=3D1363)
>>>=20
>>> Both cleaners running (the second mountpoint - /mnt/home_backup - i=
s under
>>> heavy load and I suppose it will end with around 20G used space).
>>>=20
>>> Where to go from this point? How to debug nilfs_cleanerd issue?
>>>=20
>>>=20
>>> Piotr Szymaniak.
>>=20
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nilf=
s" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> --=20
> Marriage is like a coffin and each kid is like another nail.
>  -- Homer Simpson

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
