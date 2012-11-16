From: =?KOI8-R?B?88XSx8XKIOHMxcvTwc7E0s/X?= <splavgm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: very large mount time after unxepected power down
Date: Fri, 16 Nov 2012 10:11:11 +0300
Message-ID: <CAFPMYnEYnLv5e6a3ZcFRjw-8cNB80T5=mpuiX9jaWa+pEj8Q-A@mail.gmail.com>
References: <CAFPMYnE3ybWO4o=E1UonAZJ7Uwn5y9n4840ksYGAu7qAYJ0zKw@mail.gmail.com>
	<CAFPMYnEZ28qvwkE3kaB59h2rD_8noT+gQtp7Hs6uvmHcL6KzYA@mail.gmail.com>
	<1351604965.2069.13.camel@slavad-ubuntu>
	<CAFPMYnHhtFxuVZOMu9MZ6Xb74mFPm1a-4axyFKkHiJjDEW_4BA@mail.gmail.com>
	<1351608774.2026.6.camel@slavad-ubuntu>
	<CAFPMYnGn4aNf=5B9v93TtTc6x4hG1ULgt0P9i75uO=xGX0U2bg@mail.gmail.com>
	<AFFE5823-0AD0-488C-B465-55CF45A10785@dubeyko.com>
	<CAFPMYnEtXMr1UOVYdNNRxxH83=O-_UOR_ZhCdqjh+JuUNrFiDA@mail.gmail.com>
	<1351664002.2105.3.camel@slavad-ubuntu>
	<CAFPMYnHyUSEr5jwBNkh43Xpt=VrzgiSCK8LG3Vkf3HcwV9cnMQ@mail.gmail.com>
	<CAFPMYnHB=x2y3C-bVSEcaT2nMYn12zc5Jnr56ph31zBbym4Kfw@mail.gmail.com>
	<CAFPMYnE2j0DjiqcSuJRiJX5hfDjHoyh-WUhG0cMav9K=tbsLDQ@mail.gmail.com>
	<1352961172.2076.10.camel@slavad-ubuntu>
	<CAFPMYnH4npNU8dJKAHwjatxAA=WoT10EWho5xyYjZJjz4uOYBA@mail.gmail.com>
	<CAFPMYnG6zjT6-=x7XcVuuCp1__H0FhCBfNmyrfQi8dNpWC_m2w@mail.gmail.com>
	<1353047197.2029.5.camel@slavad-ubuntu>
	<CAFPMYnFLSZW068cFZ4FqDKF5sS_zF3SoV=vPG2=m+kvaxq-BZA@mail.gmail.com>
	<1353048835.2029.17.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=QASBvNSq1w7JLiRwWE9QvIDi9BqTI4nYGVeXm7QYI4o=;
        b=E9GSfc5uQYRrvnVer86/Cut00L/YCIfk0yEqdeCHbKJ1mf8Gsy11ukaEyVZogwISH9
         EVAbjihtZMd9h5UeMXx7uH4bhDNZ9PRKpen2y2g1ajiSHlqv8q/dnRN6i1gHgz7uVFb6
         nM+vuDLexEk2dbSv99ongeimDkuIwIp3Xf3+/gvWovu6RTFDs25cuNn1OI3kZ26fAW0h
         N3G9DFTxMzkIn0n6sK+va8iRFWCKBlMAUeteLLiUkqFXKs23IAskiSMxC5WYDwWuxiqi
         xdzY+64DfJ55Em33Uxaxx4Fmo3FUX37S187Hxegb8RPzBDt8Wx5lmAVgSxjeXis32q2+
         L8wg==
In-Reply-To: <1353048835.2029.17.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="koi8-r"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

dmesg:
[53994.254432] NILFS warning: mounting unchecked fs
[56686.968229] NILFS: recovery complete.
[56686.969316] segctord starting. Construction interval =3D 5 seconds,
CP frequency < 30 seconds

messages:
Nov 15 10:57:06 router kernel: [53994.254432] NILFS warning: mounting
unchecked fs
Nov 15 11:42:02 router kernel: [56686.968229] NILFS: recovery complete.
Nov 15 11:42:02 router kernel: [56686.969316] segctord starting.
Construction interval =3D 5 seconds, CP frequency < 30 seconds

May be there is some kernel config option to get more debug output?

As for fsck, I have not found it in git public repo, so where can I
get the latest version?
--------------------------------------------------
=E1=CC=C5=CB=D3=C1=CE=C4=D2=CF=D7 =F3=C5=D2=C7=C5=CA =F7=C1=D3=C9=CC=D8=
=C5=D7=C9=DE


2012/11/16 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>:
> On Fri, 2012-11-16 at 09:40 +0300, =F3=C5=D2=C7=C5=CA =E1=CC=C5=CB=D3=
=C1=CE=C4=D2=CF=D7 wrote:
>> Sorry, but I didn't save top output this time..
>> But for sure, it was "mount /dev/md0 /nfs/raid -o ...." process. The
>> CPU load was fully in kernel space.
>> So while the mount call, the kernel was doing something very both IO
>> and CPU intensive for almost 50 minutes.
>> As I have already written the load was about 80MB/s read IO accordin=
g
>> to iotop, and about 60% of the first CPU core according to top.
>>
>
> Ok. I see.
>
> I suspect currently that you can have some special corruption of the
> volume state that is resulted in so long recovery code working time. =
But
> if so, then you can have some warning messages in system log from
> recovery subsystem (maybe not, of course). As I know, Gentoo has spec=
ial
> log that keeps error and warning messages from the kernel. Could you
> check that shared by you the dmesg output contains error messages fro=
m
> kernel?
>
> Moreover, current functionality state of fsck.nilfs2 is not very usef=
ul
> yet. But it can check superblocks and segment summary headers validit=
y.
> Maybe it makes sense to check your volume by fsck.nilfs2. Could you t=
ry
> to check your volume?
>
> With the best regards,
> Vyacheslav Dubeyko.
>
>
>> If this info is not sufficient I'll try to reproduce the case as soo=
n
>> as possible.
>> --------------------------------------------------
>> =E1=CC=C5=CB=D3=C1=CE=C4=D2=CF=D7 =F3=C5=D2=C7=C5=CA =F7=C1=D3=C9=CC=
=D8=C5=D7=C9=DE
>>
>>
>> 2012/11/16 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>:
>> > On Thu, 2012-11-15 at 16:08 +0300, =F3=C5=D2=C7=C5=CA =E1=CC=C5=CB=
=D3=C1=CE=C4=D2=CF=D7 wrote:
>> >> lssu, lscp after mount. Actually I missed the moment and
>> >> nilfs_cleanerd has cleaned some data.
>> >> Mount took about 50 minutes.
>> >>
>> >
>> > Thank you for info.
>> >
>> > I have some additional questions after thinking about issue. As I
>> > remember, you wrote that you tried to understand what process eats=
 CPU
>> > time during issue. But you don't share details about it. Could you=
 share
>> > details of "top" and "ps ax" outputs for the case of issue reprodu=
cing?
>> >
>> > With the best regards,
>> > Vyacheslav Dubeyko.
>> >
>> >> --------------------------------------------------
>> >> =E1=CC=C5=CB=D3=C1=CE=C4=D2=CF=D7 =F3=C5=D2=C7=C5=CA =F7=C1=D3=C9=
=CC=D8=C5=D7=C9=DE
>> >>
>> >>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
