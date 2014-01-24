From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 0/5] nilfs-utils: skip inefficient gc operations
Date: Fri, 24 Jan 2014 12:02:24 +0400
Message-ID: <FC7F25C5-1E72-4DF5-B860-FBCE36E91EAB@dubeyko.com>
References: <cover.1390310509.git.andreas.rohner@gmx.net> <85EBEC6B-CA69-472A-8DDD-8E056F809EC4@dubeyko.com> <52E15B9E.6040307@gmx.net>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:Date:Subject:From:Cc:Message-Id:Content-Transfer-Encoding:Content-Type:In-Reply-To:Mime-Version:References; bh=MNub0eGBTQRaXMraRLH5TKamUmlANmKsMP938aT/YRk=;
	b=WJ3z7S70u/oPnkrCgk6w1jRuu1a6oqHAI3UStpYbPBHMIUE74AIEdPTQIHD+6psnUVLEo91G/2Yj/AAOjtdY9wYXNp25UK74haSa5x9+NGUUb0R7hZm8tYHUeN+GNidV;
In-Reply-To: <52E15B9E.6040307-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>


> 23 =D1=CE=D7. 2014 =C7., =D7 22:12, Andreas Rohner <andreas.rohner@gm=
x.net>:
>>=20
>>> This patch set implements a small new feature and there shouldn't b=
e
>>> any compatibility issues. It enables the GC to check how much free
>>> space can be gained from cleaning a segment and if it is less than =
a
>>> certain threshold it will abort the operation and try a different
>>> segment.
>>=20
>> When you have cleaned a segment then you can use the whole one.
>> So, if segment has 8 MB in size then it will be available 8 MB free =
space.
>> The phrase "It enables the GC to check how much free space can be ga=
ined
>> from cleaning a segment" really confuses me. Because I always know
>> how much space I gain after cleaning every segment. I suppose that y=
ou
>> mean something different. Am I correct?
>=20
> You have to move the live blocks to a new segment, so you gain only (=
8
> MB - live_blocks) of free space.

You always will have 8 MB after cleaning (garbage collection).  So, all=
 segments
are identical from the free space point of view. What does GC check? An=
d how
can GC distinguish segments on the basis of free space? All cleaned seg=
ments
return 8 MB free space for further allocation. So, all used segments wi=
ll be over
any threshold.

>>> Although no blocks need to be moved, the SUFILE entry of the
>>> corresponding segment needs to be updated to avoid an infinite loop=
=2E
>>>=20
>>> This is potentially useful for all gc policies, but it is especiall=
y
>>> beneficial for the timestamp policy.
>>=20
>> I completely misunderstand this statement. What do you mean?
>=20
> Well the timestamp policy always selects the oldest segment. If the
> oldest segment is below the threshold it won't be cleaned. If we don'=
t
> change the timestamp it will be immediately selected again and it
> probably will still be below the threshold and so on in an infinite l=
oop.

I understand your approach. But I misunderstand about what usefulness
you are talking. What is it?

[snip]
>>>=20
>>> The speed of the GC was tuned to the HDD. It was probably too aggre=
ssive=20
>>> for the much faster SSD. That is probably the reason why the differ=
ence=20
>>> in GB written and read is much higher than 20 GB.
>>=20
>> I misunderstand completely what you mean here.
>=20
> You need to be a bit more specific. These are the results of my
> benchmark. The GB Written and GB Read values are calculated by simply
> importing /proc/diskstats into R (You subtract the values before the
> benchmark from those after the benchmark).
>=20
> The patched version writes less and reads less. Pretty simple.

Here I asked about aggressiveness related to SSD. What do you mean?

Thanks,
Vyacheslav Dubeyko.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
