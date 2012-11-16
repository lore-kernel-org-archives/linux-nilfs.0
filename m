From: =?KOI8-R?B?88XSx8XKIOHMxcvTwc7E0s/X?= <splavgm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: very large mount time after unxepected power down
Date: Fri, 16 Nov 2012 16:56:58 +0300
Message-ID: <CAFPMYnHAcy3u9D6UnNeUCUuiNfDG_1RccWk948JVMg75P_PFcg@mail.gmail.com>
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
	<CAFPMYnEYnLv5e6a3ZcFRjw-8cNB80T5=mpuiX9jaWa+pEj8Q-A@mail.gmail.com>
	<1353073969.9135.7.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=fI2iYQ326TYrQ54zG1g7dvlS3S9hUapOC4UezLWtAFQ=;
        b=PFn/JIlAoTBw+64NeGJGL1p1fBs3nJwE4nBWraBcWh0yo5vmE6hCe2S66zYBwrAxQG
         XWgmm3MscourW5RExfrPPa49yisg9MlYZ1/qvvZdJbriBoTj8jvXBWhPtZXvh51CeiDj
         G8wmrzsK0SCsA8y8zhib8NTFntunsLzda9HmVXVSO9GrxEAV8Zkd4hJ2eIhPc+9/AiJ9
         gmpxpbsfsdlIs7bwh0cAy3EDaaZ06kr3pXDi6A4LiJL+KgmApL0z/35Mv0SwmAxPB/Sa
         kTqIvKxm6IAkTyYoZqMjrUJe/FzPiXCHBvu5ULNZlvKAkKXIiTSK0uISWdAHX4OWqsq1
         DSLw==
In-Reply-To: <1353073969.9135.7.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="koi8-r"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Ok, thanks. I'll try to apply it. I've also turned on function graph
tracing, may be the graph for init_nilfs function will help.
--------------------------------------------------
=E1=CC=C5=CB=D3=C1=CE=C4=D2=CF=D7 =F3=C5=D2=C7=C5=CA =F7=C1=D3=C9=CC=D8=
=C5=D7=C9=DE


2012/11/16 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>:
> On Fri, 2012-11-16 at 10:11 +0300, =F3=C5=D2=C7=C5=CA =E1=CC=C5=CB=D3=
=C1=CE=C4=D2=CF=D7 wrote:
>> dmesg:
>> [53994.254432] NILFS warning: mounting unchecked fs
>> [56686.968229] NILFS: recovery complete.
>> [56686.969316] segctord starting. Construction interval =3D 5 second=
s,
>> CP frequency < 30 seconds
>>
>> messages:
>> Nov 15 10:57:06 router kernel: [53994.254432] NILFS warning: mountin=
g
>> unchecked fs
>> Nov 15 11:42:02 router kernel: [56686.968229] NILFS: recovery comple=
te.
>> Nov 15 11:42:02 router kernel: [56686.969316] segctord starting.
>> Construction interval =3D 5 seconds, CP frequency < 30 seconds
>>
>> May be there is some kernel config option to get more debug output?
>>
>
> I prepared small patch (please, find in attachment). This patch simpl=
y
> adds several debug messages into recovery module. I suggest to apply =
the
> patch on your NILFS2 driver and try to mount again in the issue
> environment. I hope that these debug messages can give more informati=
on
> about issue on your side.
>
> The patch uses pr_debug() call. Please, see
> Documentation/dynamic-debug-howto.txt for more details.
>
> To be honest, I don't test the patch yet. So, if you will have any
> troubles, please, e-mail to me.
>
> With the best regards,
> Vyacheslav Dubeyko.
>
>> As for fsck, I have not found it in git public repo, so where can I
>> get the latest version?
>> --------------------------------------------------
>
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
