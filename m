From: =?KOI8-R?B?88XSx8XKIOHMxcvTwc7E0s/X?= <splavgm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: very large mount time after unxepected power down
Date: Fri, 16 Nov 2012 09:40:15 +0300
Message-ID: <CAFPMYnFLSZW068cFZ4FqDKF5sS_zF3SoV=vPG2=m+kvaxq-BZA@mail.gmail.com>
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
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=jDkjPunSFZQoDpKEQVZmtT8i44YzN8a+91x8N5/VgkQ=;
        b=e6HdBHIqa6vEHwkDlkUMQlwnxNi6++HUOG9QWj12tH8qm3e5oDMPqFEW3VxYVXKqog
         7dHdPeTJMeew0kBpIg7X+/FIYFHA7gJ52koU/VikSfRsASFThyd3YDt0eAG5ko8bcsNY
         7UZziWCHIuzpnVNtHjhE/uzBnO8jec93ORH5fj5XfxbtGHRDE5uFsCs2aHr8utSDkFzu
         WVNgKZZYKLdv5rWxlgBZe6PvvVI5T1SL9wgBeZNjRJaSye9z1shCE6WRgjYku80u6WXV
         WS640bB1wpAuFurA8Htfd3iEJZ1XVtyGm53a3JgqV6sQ/edUSENd8Ms2enIyCKdzKo6q
         EkNQ==
In-Reply-To: <1353047197.2029.5.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="koi8-r"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Sorry, but I didn't save top output this time..
But for sure, it was "mount /dev/md0 /nfs/raid -o ...." process. The
CPU load was fully in kernel space.
So while the mount call, the kernel was doing something very both IO
and CPU intensive for almost 50 minutes.
As I have already written the load was about 80MB/s read IO according
to iotop, and about 60% of the first CPU core according to top.

If this info is not sufficient I'll try to reproduce the case as soon
as possible.
--------------------------------------------------
=E1=CC=C5=CB=D3=C1=CE=C4=D2=CF=D7 =F3=C5=D2=C7=C5=CA =F7=C1=D3=C9=CC=D8=
=C5=D7=C9=DE


2012/11/16 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>:
> On Thu, 2012-11-15 at 16:08 +0300, =F3=C5=D2=C7=C5=CA =E1=CC=C5=CB=D3=
=C1=CE=C4=D2=CF=D7 wrote:
>> lssu, lscp after mount. Actually I missed the moment and
>> nilfs_cleanerd has cleaned some data.
>> Mount took about 50 minutes.
>>
>
> Thank you for info.
>
> I have some additional questions after thinking about issue. As I
> remember, you wrote that you tried to understand what process eats CP=
U
> time during issue. But you don't share details about it. Could you sh=
are
> details of "top" and "ps ax" outputs for the case of issue reproducin=
g?
>
> With the best regards,
> Vyacheslav Dubeyko.
>
>> --------------------------------------------------
>> =E1=CC=C5=CB=D3=C1=CE=C4=D2=CF=D7 =F3=C5=D2=C7=C5=CA =F7=C1=D3=C9=CC=
=D8=C5=D7=C9=DE
>>
>>
>> 2012/11/15 =F3=C5=D2=C7=C5=CA =E1=CC=C5=CB=D3=C1=CE=C4=D2=CF=D7 <spl=
avgm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> > 2012/11/15 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>:
>> >
>> >>> The bug appeared again. And apparently it's a kernel one.
>> >>> My bad that I didn't notice that the CPU activity wals in kernel=
 space.
>> >>> The mount process hangs inside mount call itself. I've an strace
>> >>> output, but it's not informative, it perfectly normal besides th=
e hang
>> >>> in mount call.
>> >>
>> >> I will try to reproduce the issue. As I remember, you described y=
our
>> >> environment with details. But what size of files you have prefera=
bly on
>> >> your partition? Moreover, could you share strace output anyway? B=
ecause
>> >> it can be a basis for understanding of achieving the issue reprod=
ucing
>> >> and analysis of execution environment.
>> >
>> > Essentially there are three kind of files: large ones about 700MB-=
2GB,
>> > video, written by rtorrent/libtorrent (with no preallocation, if i=
t
>> > matters)and physics numerical simulation files - about 2GB data fi=
les
>> > and few killobytes long description files.
>> >
>> >>
>> >> If you want to try to investigate and fix the issue by yourself t=
hen
>> >> your strace output is needed also.
>> >>
>> >> By the way, could you share your dmesg output for analysis?
>> >
>> > strace and dmesg output attached. Mount is in progress.
>> >
>> >>
>> >> I think also it can be very useful lscp and lssu output before su=
dden
>> >> power off and after mount is ended successfully. Could you share =
it?
>> >
>> > It will be a bit hard to get the before data, but when mount will =
be
>> > finished I'll send you after results.
>> >
>> >
>> > I'll try to reproduce and get the before results too, but I am not
>> > sure about it.
>> >
>> >
>> > Best regards,
>> > Aleksandrov Sergey Vasil'evich
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
