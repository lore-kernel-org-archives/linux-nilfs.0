From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH v2 0/5] nilfs-utils: skip inefficient gc operations
Date: Fri, 24 Jan 2014 15:18:57 +0100
Message-ID: <52E27651.6070207@gmx.net>
References: <cover.1390310509.git.andreas.rohner@gmx.net> <85EBEC6B-CA69-472A-8DDD-8E056F809EC4@dubeyko.com> <52E15B9E.6040307@gmx.net> <FC7F25C5-1E72-4DF5-B860-FBCE36E91EAB@dubeyko.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <FC7F25C5-1E72-4DF5-B860-FBCE36E91EAB-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2014-01-24 09:02, Vyacheslav Dubeyko wrote:
>=20
>> 23 =D1=8F=D0=BD=D0=B2. 2014 =D0=B3., =D0=B2 22:12, Andreas Rohner <a=
ndreas.rohner-hi6Y0CQ0nG0@public.gmane.org>:
>>>
>>>> This patch set implements a small new feature and there shouldn't =
be
>>>> any compatibility issues. It enables the GC to check how much free
>>>> space can be gained from cleaning a segment and if it is less than=
 a
>>>> certain threshold it will abort the operation and try a different
>>>> segment.
>>>
>>> When you have cleaned a segment then you can use the whole one.
>>> So, if segment has 8 MB in size then it will be available 8 MB free=
 space.
>>> The phrase "It enables the GC to check how much free space can be g=
ained
>>> from cleaning a segment" really confuses me. Because I always know
>>> how much space I gain after cleaning every segment. I suppose that =
you
>>> mean something different. Am I correct?
>>
>> You have to move the live blocks to a new segment, so you gain only =
(8
>> MB - live_blocks) of free space.
>=20
> You always will have 8 MB after cleaning (garbage collection).  So, a=
ll segments
> are identical from the free space point of view. What does GC check? =
And how
> can GC distinguish segments on the basis of free space? All cleaned s=
egments
> return 8 MB free space for further allocation. So, all used segments =
will be over
> any threshold.

I am sorry if I wasn't clear enough. The invalidated blocks in a segmen=
t
are basically unusable free space, that needs to be garbage collected.
If you clean a segment you only gain the space of the invalidated
blocks, from the perspective of the whole file system. Of course the
whole segment is free after cleaning, but the live blocks were moved
somewhere else and occupy space there. So from the perspective of the
whole file system you only really gained the amount of space occupied b=
y
the invalidated blocks.

>>>> Although no blocks need to be moved, the SUFILE entry of the
>>>> corresponding segment needs to be updated to avoid an infinite loo=
p.
>>>>
>>>> This is potentially useful for all gc policies, but it is especial=
ly
>>>> beneficial for the timestamp policy.
>>>
>>> I completely misunderstand this statement. What do you mean?
>>
>> Well the timestamp policy always selects the oldest segment. If the
>> oldest segment is below the threshold it won't be cleaned. If we don=
't
>> change the timestamp it will be immediately selected again and it
>> probably will still be below the threshold and so on in an infinite =
loop.
>=20
> I understand your approach. But I misunderstand about what usefulness
> you are talking. What is it?
>=20

It helps to avoid unnecessary copy operations of data.

>>>>
>>>> The speed of the GC was tuned to the HDD. It was probably too aggr=
essive=20
>>>> for the much faster SSD. That is probably the reason why the diffe=
rence=20
>>>> in GB written and read is much higher than 20 GB.
>>>
>>> I misunderstand completely what you mean here.
>>
>> You need to be a bit more specific. These are the results of my
>> benchmark. The GB Written and GB Read values are calculated by simpl=
y
>> importing /proc/diskstats into R (You subtract the values before the
>> benchmark from those after the benchmark).
>>
>> The patched version writes less and reads less. Pretty simple.
>=20
> Here I asked about aggressiveness related to SSD. What do you mean?

I meant the configuration of the GC. The benchmark writes a lot of data=
,
and the GC needs to keep up with that. So I configured

protection_period 30
mc_nsegments_per_clean =3D 4
mc_cleaning_interval =3D 0.25

This works for the hard drive, because it is too slow to really reach
the 0.25 seconds anyway. The SSD on the other hand reaches the 0.25
seconds easily and that is probably too fast. So there is no time for
the data to get invalidated and the GC moves too much data around. So m=
y
point is, that the results for the SSD are not to be trusted and that I
need to repeat these measurements with different settings.

br,
Andreas Rohner
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
