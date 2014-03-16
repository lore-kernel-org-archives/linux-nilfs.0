From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH 2/6] nilfs2: add new timestamp to seg usage and function
 to change su_nblocks
Date: Sun, 16 Mar 2014 17:02:42 +0100
Message-ID: <5325CB22.5010904@gmx.net>
References: <cover.1394966728.git.andreas.rohner@gmx.net> <12561ce5e2cf8ae07fdda05e16c357f37d17c62f.1394966729.git.andreas.rohner@gmx.net> <2FD47FE0-3468-4EF4-AAAE-4A636C640C44@dubeyko.com> <53259801.5080409@gmx.net> <0ED0D5DA-9AE9-44B8-8936-1680DE2B64C5@dubeyko.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0ED0D5DA-9AE9-44B8-8936-1680DE2B64C5-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2014-03-16 14:34, Vyacheslav Dubeyko wrote:
>=20
>> On 16 =D0=BC=D0=B0=D1=80=D1=82=D0=B0 2014 =D0=B3., at 16:24, Andreas=
 Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org> wrote:
>>
>>> On 2014-03-16 14:00, Vyacheslav Dubeyko wrote:
>>>
>>>> On Mar 16, 2014, at 1:47 PM, Andreas Rohner wrote:
>>>>
>>>> This patch adds an additional timestamp to the segment usage
>>>> information that indicates the last time the usage information was
>>>> changed. So su_lastmod indicates the last time the segment itself =
was
>>>> modified and su_lastdec indicates the last time the usage informat=
ion
>>>> itself was changed.
>>>
>>> What will we have if user changes time?
>>> What sequence will we have after such "malicious" action?
>>> Did you test such situation?
>>
>> The timestamp is just a hint for the userspace GC. If the hint is wr=
ong
>> the result would be that the GC is less efficient for a while. After=
 a
>> while it would go back to normal. You have the same problem with the
>> already existing su_lastmod timestamp.
>>
>=20
> But I worry about such thing. Previously, we had complains of users a=
bout
> different issues with timestamp policy of GC. And I had hope that nam=
ely
> new GC policies can resolve such GC disadvantage. So, what have we ag=
ain?
> The same issue of GC?

Yes but I have to compare it to the protection period, which is a
timestamp. Maybe I could use the current checkpoint number instead...

Regards,
Andreas Rohner

> Thanks,
> Vyacheslav Dubeyko.
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs=
" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
