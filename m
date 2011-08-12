From: Gordan Bobic <gordan-UpbECiGlrmGsTnJN9+BGXg@public.gmane.org>
Subject: Re: More on =?UTF-8?Q?nilfs=5Fcleanerd=20and=20excessive=20writes?=
 =?UTF-8?Q?=20=28=31=20month=20flash=20card=20life=20expetancy=29?=
Date: Fri, 12 Aug 2011 15:11:48 +0100
Message-ID: <a28efbf664e71d72d32cf6696265a71a@mail.shatteredsilicon.net>
References: <87e2dc262f71d35a8fe5e0983fc1b7e6@mail.shatteredsilicon.net>
 <-3370132062042111051@unknownmsgid>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <-3370132062042111051@unknownmsgid>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?J=C3=A9r=C3=B4me_Poulin?= <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc:   <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

 As of which version? I'm running 2.0.15.

 Gordan

 On Fri, 12 Aug 2011 09:51:03 -0400, J=C3=A9r=C3=B4me Poulin=20
 <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> I do not know what version of the NILFS-Tools you're using but the
> latest is configurable in this way, that it will only clean when=20
> space
> is critical.
>
> Envoy=C3=A9 de mon appareil mobile.
>
> J=C3=A9r=C3=B4me Poulin
> Solutions G.A.
>
> On 2011-08-12, at 06:38, Gordan Bobic <gordan-UpbECiGlrmGsTnJN9+BGXg@public.gmane.org> wrote:
>
>> I just did some basic measuring and it looks like the total writes=20
>> by nilfs_cleanerd on my SD card total about 1GB/minute (16MB/second,=
=20
>> all my card can handle). Since the system is used all the time while=
=20
>> it is on, that involves there always being things that need to be=20
>> garbage collected, so it runs all the time. Even assuming it=20
>> performance isn't an issue (running at nice 19 and ionice -c3, and=20
>> performance IS an issue), that still means that the SD card will get=
=20
>> 1,440GB of writes/day (1,4TB!). It's a 32GB MLC flash card, so=20
>> assuming a 5,000 erase cycle life of 32nm MLC (ignoring any inevitab=
le=20
>> write amplification), that gives life expectancy of 160TB, or at the=
=20
>> given rate of nilfs_cleanerd churn, about 12 days of usage. Call it =
a=20
>> month with the assumption the machine isn't used all day every day.
>>
>> This is quite thoroughly unacceptable for usage on any flash media.=20
>> Ignoring any other optimizations that might be applicable (e.g.=20
>> smaller block size to minimize the number of blocks that have to be=20
>> re-written), my immediate redneck solution is running this every=20
>> minute as a cron job:
>>
>>
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> #!/bin/bash
>>
>> # Substitute /dev/mmcblk1p4 for your nilfs partition
>> used=3D`df | grep /dev/mmcblk1p4 | awk '{ print $5; }' | sed -e=20
>> 's/%//'`
>>
>> # If disk usage is more than 90%...
>> if [ $used -gt 90 ]; then
>>    # If nilfs_cleanerd is not running...
>>    if (! pgrep nilfs_cleanerd > /dev/null ); then
>>        nohup nice -n 19 ionice -c 3 /sbin/nilfs_cleanerd > /dev/null=
=20
>> 2>&1 &
>>    fi
>> # If disk usage is less than 90%...
>> elif [ $used -lt 80 ]; then
>>    pkill nilfs_cleanerd > /dev/null 2>&1
>> fi
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>
>> This could of course be improved and "enterpriseified" further, e.g.=
=20
>> check for all nilfs partitions and do the checks on all of them, mak=
e=20
>> the free space amount thresholds based on 1/3 and 2/3 of free space=20
>> (fs size - du), but this problem shouldn't really be looking for a=20
>> solution in a cron job.
>>
>> It's not ideal and nilfs_cleanerd should be configurable to moderate=
=20
>> itself in a similar way, but until that happens, I don't see any=20
>> alternative to the above cron job. The write performance is fantasti=
c=20
>> for tasks that do a lot of writing, but the life expectancy issue is=
 a=20
>> very real one.
>>
>> Gordan
>> --
>> To unsubscribe from this list: send the line "unsubscribe=20
>> linux-nilfs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
