From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: More on nilfs_cleanerd and excessive writes (1 month flash card
 life expetancy)
Date: Fri, 12 Aug 2011 09:51:03 -0400
Message-ID: <-3370132062042111051@unknownmsgid>
References: <87e2dc262f71d35a8fe5e0983fc1b7e6@mail.shatteredsilicon.net>
Mime-Version: 1.0 (iPhone Mail 8J2)
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=references:from:in-reply-to:mime-version:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        bh=HXzEpDke+MBrbGWpUEekjlr7UGmZGJ1mSBec0W0Dyak=;
        b=NhRD1+UG8z4y8HqpxkWM18KSr/IR+464WZhuc8TpIQVxTVM/3FxYwjJ959LH0mN2t3
         mf7TNjRjBhjy3gAEcGjd8inj+vE5pMaBE1UK17iVoD9E2MOIEJUeZc881+iIHo7U3XDV
         ZvHzyv4ccHEce/RnH/xzOxz2Dy1QA+XJjIRkM=
In-Reply-To: <87e2dc262f71d35a8fe5e0983fc1b7e6-tp2ajI7sM87MEvS+BUbURm2TqnkC6wfpXqFh9Ls21Oc@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Gordan Bobic <gordan-UpbECiGlrmGsTnJN9+BGXg@public.gmane.org>
Cc: "<linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

I do not know what version of the NILFS-Tools you're using but the
latest is configurable in this way, that it will only clean when space
is critical.

Envoy=C3=A9 de mon appareil mobile.

J=C3=A9r=C3=B4me Poulin
Solutions G.A.

On 2011-08-12, at 06:38, Gordan Bobic <gordan-UpbECiGlrmGsTnJN9+BGXg@public.gmane.org> wrote:

> I just did some basic measuring and it looks like the total writes by=
 nilfs_cleanerd on my SD card total about 1GB/minute (16MB/second, all =
my card can handle). Since the system is used all the time while it is =
on, that involves there always being things that need to be garbage col=
lected, so it runs all the time. Even assuming it performance isn't an =
issue (running at nice 19 and ionice -c3, and performance IS an issue),=
 that still means that the SD card will get 1,440GB of writes/day (1,4T=
B!). It's a 32GB MLC flash card, so assuming a 5,000 erase cycle life o=
f 32nm MLC (ignoring any inevitable write amplification), that gives li=
fe expectancy of 160TB, or at the given rate of nilfs_cleanerd churn, a=
bout 12 days of usage. Call it a month with the assumption the machine =
isn't used all day every day.
>
> This is quite thoroughly unacceptable for usage on any flash media. I=
gnoring any other optimizations that might be applicable (e.g. smaller =
block size to minimize the number of blocks that have to be re-written)=
, my immediate redneck solution is running this every minute as a cron =
job:
>
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> #!/bin/bash
>
> # Substitute /dev/mmcblk1p4 for your nilfs partition
> used=3D`df | grep /dev/mmcblk1p4 | awk '{ print $5; }' | sed -e 's/%/=
/'`
>
> # If disk usage is more than 90%...
> if [ $used -gt 90 ]; then
>    # If nilfs_cleanerd is not running...
>    if (! pgrep nilfs_cleanerd > /dev/null ); then
>        nohup nice -n 19 ionice -c 3 /sbin/nilfs_cleanerd > /dev/null =
2>&1 &
>    fi
> # If disk usage is less than 90%...
> elif [ $used -lt 80 ]; then
>    pkill nilfs_cleanerd > /dev/null 2>&1
> fi
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> This could of course be improved and "enterpriseified" further, e.g. =
check for all nilfs partitions and do the checks on all of them, make t=
he free space amount thresholds based on 1/3 and 2/3 of free space (fs =
size - du), but this problem shouldn't really be looking for a solution=
 in a cron job.
>
> It's not ideal and nilfs_cleanerd should be configurable to moderate =
itself in a similar way, but until that happens, I don't see any altern=
ative to the above cron job. The write performance is fantastic for tas=
ks that do a lot of writing, but the life expectancy issue is a very re=
al one.
>
> Gordan
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
