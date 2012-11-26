From: =?KOI8-R?B?88XSx8XKIOHMxcvTwc7E0s/X?= <splavgm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: very large mount time after unxepected power down
Date: Mon, 26 Nov 2012 22:17:50 +0300
Message-ID: <CAFPMYnGT1byuVA1hCnETWc2GZAbDsjeS95-F8f15QYPe_YHABA@mail.gmail.com>
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
	<CAFPMYnHAcy3u9D6UnNeUCUuiNfDG_1RccWk948JVMg75P_PFcg@mail.gmail.com>
	<CAFPMYnHzghu8k36wQj5h4K7a2wS6EcURcQmCOUTb5B2CJB9ufQ@mail.gmail.com>
	<782558C7-081D-4466-8780-51886E209A62@dubeyko.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=/AZUMRTb0nkaZNqHWokSPm/4MC3Q4HY1ZR8oX8IlHrU=;
        b=Wx3xabQoZx9D9Qw1BoxacVHlMxJCJeVxoP24YtE8fsupnkkT2oxaRufM4fU0uAbqPQ
         RzqGEaLU4GQ0KouSIggilQccR9ZWpot3jVBVDeG/5F8kOew4nMEFph5caoRoNv03Fb9n
         WUFsKFtKQWriwOZRD6IGmLnE5PWLf6FTxex6wDJzDNtxnLcHtMIbINlhrMn6vk2sZat2
         aVWLkUnRP0kjUAxNGRRpfQAQvBrQcU3DfJKNVKpyzfHLIg6dQQsWYi+53E1bW28vyL78
         1JYJfixQTMBJT1QmNEPX+eMvFc6rAv7Jj/PJlexotZTjs0zEGI95S+OqYmHzeVoBmIDV
         +6Dg==
In-Reply-To: <782558C7-081D-4466-8780-51886E209A62-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="koi8-r"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

Unfortunately, the only output I saw is:
Nov 26 15:54:00 router kernel: [ 5808.068533] NILFS warning: mounting
unchecked fs
Nov 26 15:54:00 router kernel: [ 5808.068546] NILFS: nilfs_search_super=
_root
Nov 26 15:54:00 router kernel: [ 5808.068552] NILFS: pseg_start
115603456, seg_seq 4347757
Nov 26 15:54:00 router kernel: [ 5808.068558] NILFS: cno 1252241, segnu=
m 56447

I suppose the last three lines are due to the patch.

Dynamic debug was on:
router dynamic_debug # cat control | grep nilfs
fs/nilfs2/recovery.c:851 [nilfs2]nilfs_search_super_root =3Dp "NILFS:
cno %lld, segnum %lld\012"
fs/nilfs2/recovery.c:850 [nilfs2]nilfs_search_super_root =3Dp "NILFS:
pseg_start %lld, seg_seq %lld\012"
fs/nilfs2/recovery.c:849 [nilfs2]nilfs_search_super_root =3Dp "NILFS:
nilfs_search_super_root\012"
fs/nilfs2/recovery.c:766 [nilfs2]nilfs_salvage_orphan_logs =3Dp "NILFS:
nilfs_salvage_orphan_logs\012"
fs/nilfs2/recovery.c:614 [nilfs2]nilfs_do_roll_forward =3Dp "NILFS:
seg_start %lld, seg_end %lld\012"
fs/nilfs2/recovery.c:613 [nilfs2]nilfs_do_roll_forward =3Dp "NILFS:
segnum %lld\012"
fs/nilfs2/recovery.c:612 [nilfs2]nilfs_do_roll_forward =3Dp "NILFS:
pseg_start %lld, seg_seq %lld\012"
fs/nilfs2/recovery.c:611 [nilfs2]nilfs_do_roll_forward =3Dp "NILFS:
nilfs_do_roll_forward\012"
fs/nilfs2/recovery.c:442 [nilfs2]nilfs_prepare_segment_for_recovery =3D=
p
"NILFS: ri_segnum %lld, ri_nextnum %lld\012"
fs/nilfs2/recovery.c:440 [nilfs2]nilfs_prepare_segment_for_recovery =3D=
p
"NILFS: ns_segnum %lld, ns_nextnum %lld\012"
fs/nilfs2/recovery.c:438 [nilfs2]nilfs_prepare_segment_for_recovery =3D=
p
"NILFS: nilfs_prepare_segment_for_recovery\012"
fs/nilfs2/recovery.c:719 [nilfs2]nilfs_finish_roll_forward =3Dp "NILFS:
nilfs_finish_roll_forward\012"
--------------------------------------------------
=E1=CC=C5=CB=D3=C1=CE=C4=D2=CF=D7 =F3=C5=D2=C7=C5=CA =F7=C1=D3=C9=CC=D8=
=C5=D7=C9=DE


2012/11/27 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>:
> Hi,
>
> On Nov 26, 2012, at 7:19 PM, =F3=C5=D2=C7=C5=CA =E1=CC=C5=CB=D3=C1=CE=
=C4=D2=CF=D7 wrote:
>
>> The bug finally appeared again. Here are the trace log and kernel lo=
g.
>> I've hard rebooted machine so FS is in unchecked state for now and i=
t
>> is possible to make some other tests.
>> I'll manage to do without this partition for a day may be two.
>>
>
> Thank you for logs. But what about my patch with debug output? The ou=
tput of the patch can be very helpful for the issue analysis. It needs =
to understand what segments are processed during mount. Could you share=
 debug output of my patch?
>
> With the best regards,
> Vyacheslav Dubeyko.
>
>>
>> --------------------------------------------------
>> =E1=CC=C5=CB=D3=C1=CE=C4=D2=CF=D7 =F3=C5=D2=C7=C5=CA =F7=C1=D3=C9=CC=
=D8=C5=D7=C9=DE
>>
>>
>> 2012/11/16 =F3=C5=D2=C7=C5=CA =E1=CC=C5=CB=D3=C1=CE=C4=D2=CF=D7 <spl=
avgm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>>> Ok, thanks. I'll try to apply it. I've also turned on function grap=
h
>>> tracing, may be the graph for init_nilfs function will help.
>>> --------------------------------------------------
>>> =E1=CC=C5=CB=D3=C1=CE=C4=D2=CF=D7 =F3=C5=D2=C7=C5=CA =F7=C1=D3=C9=CC=
=D8=C5=D7=C9=DE
>>>
>>>
>>> 2012/11/16 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>:
>>>> On Fri, 2012-11-16 at 10:11 +0300, =F3=C5=D2=C7=C5=CA =E1=CC=C5=CB=
=D3=C1=CE=C4=D2=CF=D7 wrote:
>>>>> dmesg:
>>>>> [53994.254432] NILFS warning: mounting unchecked fs
>>>>> [56686.968229] NILFS: recovery complete.
>>>>> [56686.969316] segctord starting. Construction interval =3D 5 sec=
onds,
>>>>> CP frequency < 30 seconds
>>>>>
>>>>> messages:
>>>>> Nov 15 10:57:06 router kernel: [53994.254432] NILFS warning: moun=
ting
>>>>> unchecked fs
>>>>> Nov 15 11:42:02 router kernel: [56686.968229] NILFS: recovery com=
plete.
>>>>> Nov 15 11:42:02 router kernel: [56686.969316] segctord starting.
>>>>> Construction interval =3D 5 seconds, CP frequency < 30 seconds
>>>>>
>>>>> May be there is some kernel config option to get more debug outpu=
t?
>>>>>
>>>>
>>>> I prepared small patch (please, find in attachment). This patch si=
mply
>>>> adds several debug messages into recovery module. I suggest to app=
ly the
>>>> patch on your NILFS2 driver and try to mount again in the issue
>>>> environment. I hope that these debug messages can give more inform=
ation
>>>> about issue on your side.
>>>>
>>>> The patch uses pr_debug() call. Please, see
>>>> Documentation/dynamic-debug-howto.txt for more details.
>>>>
>>>> To be honest, I don't test the patch yet. So, if you will have any
>>>> troubles, please, e-mail to me.
>>>>
>>>> With the best regards,
>>>> Vyacheslav Dubeyko.
>>>>
>>>>> As for fsck, I have not found it in git public repo, so where can=
 I
>>>>> get the latest version?
>>>>> --------------------------------------------------
>>>>
>> <kern.log><trace_fail>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
