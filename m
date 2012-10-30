From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: very large mount time after unxepected power down
Date: Tue, 30 Oct 2012 20:35:41 +0300
Message-ID: <AFFE5823-0AD0-488C-B465-55CF45A10785@dubeyko.com>
References: <CAFPMYnE3ybWO4o=E1UonAZJ7Uwn5y9n4840ksYGAu7qAYJ0zKw@mail.gmail.com> <CAFPMYnEZ28qvwkE3kaB59h2rD_8noT+gQtp7Hs6uvmHcL6KzYA@mail.gmail.com> <1351604965.2069.13.camel@slavad-ubuntu> <CAFPMYnHhtFxuVZOMu9MZ6Xb74mFPm1a-4axyFKkHiJjDEW_4BA@mail.gmail.com> <1351608774.2026.6.camel@slavad-ubuntu> <CAFPMYnGn4aNf=5B9v93TtTc6x4hG1ULgt0P9i75uO=xGX0U2bg@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=j7ViRZrIkH4uvZnszAND6d3t3Qn9uaX5SGaK7ZJl6/Q=;
	b=XlmEEjL9n43J6MWlyE8mS3pABuUkYSDHyYgFiD4DZAGd2jAf487FfMJmJA3wz0TAam1wFsScI4O2GUxzgJHH0ZcVa0+w4Ukjdu2erSsU/ihU0C6p3dxxAUSd+lFtpFL6;
In-Reply-To: <CAFPMYnGn4aNf=5B9v93TtTc6x4hG1ULgt0P9i75uO=xGX0U2bg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="koi8-r"
To: =?utf-8?B?0KHQtdGA0LPQtdC5INCQ0LvQtdC60YHQsNC90LTRgNC+0LI=?= <splavgm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


On Oct 30, 2012, at 6:02 PM, =F3=C5=D2=C7=C5=CA =E1=CC=C5=CB=D3=C1=CE=C4=
=D2=CF=D7 wrote:

> --------------------------------------------------
> =E1=CC=C5=CB=D3=C1=CE=C4=D2=CF=D7 =F3=C5=D2=C7=C5=CA =F7=C1=D3=C9=CC=D8=
=C5=D7=C9=DE
>=20
>=20
> 2012/10/30 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>:
>> On Tue, 2012-10-30 at 17:30 +0300, =F3=C5=D2=C7=C5=CA =E1=CC=C5=CB=D3=
=C1=CE=C4=D2=CF=D7 wrote:
>>> --------------------------------------------------
>>> =E1=CC=C5=CB=D3=C1=CE=C4=D2=CF=D7 =F3=C5=D2=C7=C5=CA =F7=C1=D3=C9=CC=
=D8=C5=D7=C9=DE
>>>=20
>>>=20
>>> 2012/10/30 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>:
>>>> Hi,
>>>>=20
>>>> On Tue, 2012-10-30 at 16:20 +0300, =F3=C5=D2=C7=C5=CA =E1=CC=C5=CB=
=D3=C1=CE=C4=D2=CF=D7 wrote:
>>>>> Good time of the day!
>>>>>=20
>>>>> I'v got a nilfs2 partition on a 1TB md RAID1 partition composed o=
f two
>>>>> HDD's. Kernel 3.5.3, userspace utils v2.1.1. Gentoo linux
>>>>> distribution.
>>>>> Just updated utils to 2.1.4 but no failure since.
>>>>>=20
>>>>> After power shutdown, mount takes about several hours.
>>>>>=20
>>>>=20
>>>> What about RAID1 consistency? Could you describe more about your R=
AID
>>>> configuration?
>>>=20
>>> # cat /proc/mdstat
>>> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [=
raid4]
>>> md0 : active raid1 sdb1[0] sdc1[2]
>>>      976760400 blocks super 1.2 [2/2] [UU]
>>>=20
>>> So, raid is consistent. Reading speed from md device is about 60MB/=
s
>>> according to iostat.
>>>=20
>>>>> For the first time I thought that it won't mount at all and tried=
 to
>>>>> use fsck tool, found somewhere in the internet(don't really remem=
ber).
>>>>> It reported that superblock is ok.
>>>>=20
>>>> So, I am implementing the fsck tool for NILFS2. I guess that you t=
ake
>>>> sources from NILFS2 e-mail list.
>>>>=20
>>>>> Than I commented the check in the source file and the default num=
ber
>>>>> of blocks to check appeared to be too small. It failed to find th=
e
>>>>> next superblock. I've increased the number, but increasing it to =
*100
>>>>> didn't help.
>>>>=20
>>>> Sorry, I can't understand about what sources you are talking. Coul=
d you
>>>> describe more details about what and where you commented?
>>>>=20
>>> I've forced test_latest_log to return negative result. And changed
>>> MAX_SCAN_SEGMENTS to 100000
>>> That was not enough. It finished without finding the SB.
>>>=20
>>>=20
>>> The load from fsck was the same as from mount.
>>> About 60MB/s read from md device and about 30% load on one core.
>>>=20
>>>>> So, probably the reserved SB is too far from away and it takes to=
o
>>>>> long to find it.
>>>>>=20
>>>>=20
>>>> If you try to find the second superblock then it is placed in the =
begin
>>>> of last 4 KB of the volume. Your device size is 1000202649600 byte=
s.
>>>>=20
>>>>> Does anybody knows, how can it be speed up? I know, UPS is a solu=
tion,
>>>>> but I consider it be a bug.
>>>>>=20
>>>>=20
>>>> Could you share more details about situation during mount operatio=
ns? I
>>>> mean: (1) NILFS2-related messages in the system log; (2) "ps ax" o=
utput;
>>>> (3) maybe "top" output can be useful also; (4) "mount" output befo=
re
>>>> trying to mount NILFS2 volume.
>>> last situation:
>>>=20
>>> messages log:
>>> Oct 30 12:18:52 router kernel: [  159.674579] NILFS warning: mounti=
ng
>>> unchecked fs
>>> .....
>>> .....
>>> Oct 30 13:03:06 router kernel: [ 2810.304245] NILFS: recovery compl=
ete.
>>> Oct 30 13:03:06 router kernel: [ 2810.325240] segctord starting.
>>> Construction interval =3D 5 seconds, CP frequency < 30 seconds
>>> Oct 30 13:03:07 router nilfs_cleanerd[15453]: start
>>> Oct 30 13:03:07 router nilfs_cleanerd[15453]: pause (clean check)
>>>=20
>>=20
>> Could you share content of your /etc/nilfs_cleanerd.conf file?
>=20
>=20
> protection_period       3600
> min_clean_segments      10%
> max_clean_segments      20%
> clean_check_interval    10
> selection_policy        timestamp
> nsegments_per_clean     4
> mc_nsegments_per_clean  8
> cleaning_interval       5
> mc_cleaning_interval    2
> retry_interval          30
> use_mmap
> log_priority            info
>=20
>> Could you try to reproduce the issue with log_priority enhanced to d=
ebug
>> level (I mean option in nilfs_cleanerd.conf) and share messages log
>> again?
>=20
> I can, but a bit later, if you don''t mind(in 24 hours).
>=20

Please, try to mount with using "strace". The output of "strace" can be=
 useful. Please, share it after trying.

Thanks,
Vyacheslav Dubeyko.

>>> It took about 45 minutes.
>>> Previous time it took more than 4 hours.
>>=20
>> You mean that your console returns input after 45 minutes when you t=
ry
>> to execute mount. Am I correct?
>=20
> Yes, you are correct.
>=20
> --------------------------------------------------
> Aleksandrov Sergey Vasil'evich
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
