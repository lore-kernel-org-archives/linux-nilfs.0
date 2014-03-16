From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 2/6] nilfs2: add new timestamp to seg usage and function to change su_nblocks
Date: Sun, 16 Mar 2014 17:34:06 +0400
Message-ID: <0ED0D5DA-9AE9-44B8-8936-1680DE2B64C5@dubeyko.com>
References: <cover.1394966728.git.andreas.rohner@gmx.net> <12561ce5e2cf8ae07fdda05e16c357f37d17c62f.1394966729.git.andreas.rohner@gmx.net> <2FD47FE0-3468-4EF4-AAAE-4A636C640C44@dubeyko.com> <53259801.5080409@gmx.net>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:Date:Subject:From:Cc:Message-Id:Content-Transfer-Encoding:Content-Type:In-Reply-To:Mime-Version:References; bh=QzAZ5Zuu4xFk+rAFMUQ+tCUTAxM8GduBeaokiXjPsYg=;
	b=Cc86OE43IPuP8SOTkCGnSEo6WOttOvdzxqkSjhJt+woLS29GBUi0xOMUyuXoUasgs86PXr3kXJha/Z2MyrSkamNTPDr1ypfjJomloz1AUbfiOSRyCt/fyM+oRxuhYgFN;
In-Reply-To: <53259801.5080409-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="koi8-r"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>


> On 16 =CD=C1=D2=D4=C1 2014 =C7., at 16:24, Andreas Rohner <andreas.ro=
hner-hi6Y0CQ0nG0@public.gmane.org> wrote:
>=20
>> On 2014-03-16 14:00, Vyacheslav Dubeyko wrote:
>>=20
>>> On Mar 16, 2014, at 1:47 PM, Andreas Rohner wrote:
>>>=20
>>> This patch adds an additional timestamp to the segment usage
>>> information that indicates the last time the usage information was
>>> changed. So su_lastmod indicates the last time the segment itself w=
as
>>> modified and su_lastdec indicates the last time the usage informati=
on
>>> itself was changed.
>>=20
>> What will we have if user changes time?
>> What sequence will we have after such "malicious" action?
>> Did you test such situation?
>=20
> The timestamp is just a hint for the userspace GC. If the hint is wro=
ng
> the result would be that the GC is less efficient for a while. After =
a
> while it would go back to normal. You have the same problem with the
> already existing su_lastmod timestamp.
>=20

But I worry about such thing. Previously, we had complains of users abo=
ut
different issues with timestamp policy of GC. And I had hope that namel=
y
new GC policies can resolve such GC disadvantage. So, what have we agai=
n?
The same issue of GC?

Thanks,
Vyacheslav Dubeyko.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
