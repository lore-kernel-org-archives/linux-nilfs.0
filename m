From: =?KOI8-R?B?88XSx8XKIOHMxcvTwc7E0s/X?= <splavgm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: very large mount time after unxepected power down
Date: Tue, 30 Oct 2012 17:30:47 +0300
Message-ID: <CAFPMYnHhtFxuVZOMu9MZ6Xb74mFPm1a-4axyFKkHiJjDEW_4BA@mail.gmail.com>
References: <CAFPMYnE3ybWO4o=E1UonAZJ7Uwn5y9n4840ksYGAu7qAYJ0zKw@mail.gmail.com>
	<CAFPMYnEZ28qvwkE3kaB59h2rD_8noT+gQtp7Hs6uvmHcL6KzYA@mail.gmail.com>
	<1351604965.2069.13.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=soLNkoltj/HoSIILpY+lzovPtVVfDGPSNucV/Z4YR7s=;
        b=fE7FDCvFuYMSHPM0R/PxjwP/XPMCeAgMjhBDfxzctUg+RKNn3zJRK8Ts7bkpCjL1C3
         j0Pf0suZGnAoCTj+QIiQM53TuYoRWj01i2HVuS4zbn4VovNj5ZuWkrkp8655d5cfoNp8
         qtm0TIi8pCzZMq8cktG9+bJoV0i/HjWRGG2+5wNFxceWeLIcEwCJpRuyqu5OoM0Aqym0
         bJLp8TXR3tg2xn33xVwC9UiVl+gDLxLQk75GTzyC5deWz0Ii7XXWZ0+zHRdkzG32LuqK
         T/7m1dWpwCi7H1xbkUh4ydYjyI44D/p8kixzBwKL2LKvCrIyJ2vBfrpw0CtHrLW8TAXG
         /ImQ==
In-Reply-To: <1351604965.2069.13.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="koi8-r"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

--------------------------------------------------
=E1=CC=C5=CB=D3=C1=CE=C4=D2=CF=D7 =F3=C5=D2=C7=C5=CA =F7=C1=D3=C9=CC=D8=
=C5=D7=C9=DE


2012/10/30 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>:
> Hi,
>
> On Tue, 2012-10-30 at 16:20 +0300, =F3=C5=D2=C7=C5=CA =E1=CC=C5=CB=D3=
=C1=CE=C4=D2=CF=D7 wrote:
>> Good time of the day!
>>
>> I'v got a nilfs2 partition on a 1TB md RAID1 partition composed of t=
wo
>> HDD's. Kernel 3.5.3, userspace utils v2.1.1. Gentoo linux
>> distribution.
>> Just updated utils to 2.1.4 but no failure since.
>>
>> After power shutdown, mount takes about several hours.
>>
>
> What about RAID1 consistency? Could you describe more about your RAID
> configuration?

# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid=
4]
md0 : active raid1 sdb1[0] sdc1[2]
      976760400 blocks super 1.2 [2/2] [UU]

So, raid is consistent. Reading speed from md device is about 60MB/s
according to iostat.

>> For the first time I thought that it won't mount at all and tried to
>> use fsck tool, found somewhere in the internet(don't really remember=
).
>> It reported that superblock is ok.
>
> So, I am implementing the fsck tool for NILFS2. I guess that you take
> sources from NILFS2 e-mail list.
>
>> Than I commented the check in the source file and the default number
>> of blocks to check appeared to be too small. It failed to find the
>> next superblock. I've increased the number, but increasing it to *10=
0
>> didn't help.
>
> Sorry, I can't understand about what sources you are talking. Could y=
ou
> describe more details about what and where you commented?
>
I've forced test_latest_log to return negative result. And changed
MAX_SCAN_SEGMENTS to 100000
That was not enough. It finished without finding the SB.


The load from fsck was the same as from mount.
About 60MB/s read from md device and about 30% load on one core.

>> So, probably the reserved SB is too far from away and it takes too
>> long to find it.
>>
>
> If you try to find the second superblock then it is placed in the beg=
in
> of last 4 KB of the volume. Your device size is 1000202649600 bytes.
>
>> Does anybody knows, how can it be speed up? I know, UPS is a solutio=
n,
>> but I consider it be a bug.
>>
>
> Could you share more details about situation during mount operations?=
 I
> mean: (1) NILFS2-related messages in the system log; (2) "ps ax" outp=
ut;
> (3) maybe "top" output can be useful also; (4) "mount" output before
> trying to mount NILFS2 volume.
last situation:

messages log:
Oct 30 12:18:52 router kernel: [  159.674579] NILFS warning: mounting
unchecked fs
=2E....
=2E....
Oct 30 13:03:06 router kernel: [ 2810.304245] NILFS: recovery complete.
Oct 30 13:03:06 router kernel: [ 2810.325240] segctord starting.
Construction interval =3D 5 seconds, CP frequency < 30 seconds
Oct 30 13:03:07 router nilfs_cleanerd[15453]: start
Oct 30 13:03:07 router nilfs_cleanerd[15453]: pause (clean check)

It took about 45 minutes.
Previous time it took more than 4 hours.
Both times RAID was consistent.

top showed one process eating about 27% of cpu (2 cores, AMD Athon II
X2 250 @3000MHz)
Also, about 80% of memory is used for cache.
Sory, have not saved ps output...

I can repeat the situation if it helps.

--------------------------------------------------
Aleksandrov Sergey Vasil'evich
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
