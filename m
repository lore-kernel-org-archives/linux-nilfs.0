From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v5 2/2] nilfs2: use atomic_long_t type for inodes_count and blocks_count fields in nilfs_root struct
Date: Sun, 26 May 2013 16:18:20 +0400
Message-ID: <DF00B7E3-7352-4AEC-B0D9-AB7E624E5793@dubeyko.com>
References: <20130524190146.GF30270@logfs.org> <9EFBFA22-976F-4478-9B78-701B5A498E23@dubeyko.com> <20130524213712.GG30270@logfs.org> <20130525.123303.412805468.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=+dCwWJP40HWUb4qbYpF0Ntjido1CthJahgSXmhptfBo=;
	b=edeuSAEo2qdqUiQ2LLGZfT24sUnVCB5vLgb//xXZGoQTYUhsFxbHjKbuvLOeyvnx5PoJ/U0mkHnehWDFJ9UKpbbbiEYbtqeIZHfZx8MmRvi1N+M+wHanvEU8ttmJhwr0;
In-Reply-To: <20130525.123303.412805468.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: joern-PCqxUs/MD9bYtjvyW6yDsg@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hi Ryusuke,

On May 25, 2013, at 7:33 AM, Ryusuke Konishi wrote:

> On Fri, 24 May 2013 17:37:12 -0400, J=F6rn Engel wrote:
>> On Sat, 25 May 2013 02:01:04 +0400, Vyacheslav Dubeyko wrote:
>>> On May 24, 2013, at 11:01 PM, J=F6rn Engel wrote:
>>>> On Fri, 24 May 2013 23:30:10 +0400, Vyacheslav Dubeyko wrote:
>>>>> On May 24, 2013, at 9:54 PM, J=F6rn Engel wrote:
>>>>>> On Fri, 24 May 2013 17:32:52 +0400, Vyacheslav Dubeyko wrote:
>>>>>>>=20
>>>>>>> Subject: [PATCH v5 2/2] nilfs2: use atomic_long_t type for inod=
es_count
>>>>>> ...
>>>>>>> The cp_inodes_count and cp_blocks_count are represented as
>>>>>>> __le64 type in on-disk structure (struct nilfs_checkpoint).
>>>>>>=20
>>>>>> Isn't atomic_long_t defined to be 32bit on 32bit architectures?
>>>>>=20
>>>>> As I understand, yes.
>>>>=20
>>>> And it doesn't concern you to use a 32bit memory structure to
>>>> represent a 64bit on-disk structure? ;)
>>>=20
>>> I suppose that you mean possibility to mount NILFS2 volume under 32=
 bit architecture
>>> after working with this volume under 64 bit architecture. Am I corr=
ect?
>>>=20
>>> Have you any concrete remarks about code of the patch? Feel free to=
 offer your vision.
>>=20
>> Replace atomic_long_t with atomic64_t and replace the various access=
or
>> functions.  The on-disk data structure is 64bit, so of course you us=
e
>> a 64bit in-memory structure.
>>=20
>> Does it really take a vision to come up with this idea?
>=20
> Things are not so simple.  It is not guaranteed that 32-bit
> architectures can handle 64-bit on-disk values.  (Think ino_t, page
> index, or nrpages.  These are defined with "unsigned long".)
>=20
> However, these "inodes_count" and "blocks_count" are directly
> corresponding to their on-disk counterparts, so using atomic64_t look=
s
> more intuitive for most people; using atomic_long_t for these was
> confusing.
>=20
> Ok, I agree.
>=20
> Vyacheslav, could you please consider taking in J=F6rn's comment ?
>=20

So, I have such understanding. Please, correct me if I'm wrong.

The atomic_long_t and atomic64_t types are 64 bits on 64-bit architectu=
re.
The atomic_long_t type is 32 bits on 32-bit architecture. So, If we wan=
t to have
64 bits atomic counter on 32-bit architecture then we need to use gener=
ic atomic64_t
implementation (asm-generic/atomic64.t). But generic 64-bit atomic supp=
ort
depends from CONFIG_GENERIC_ATOMIC64 configuration option
(http://lxr.free-electrons.com/source/include/linux/atomic.h#L127). As =
a result,
NILFS2 driver needs to have dependance from CONFIG_GENERIC_ATOMIC64
configuration option on 32-bit architecture configuration.

With the best regards,
Vyacheslav Dubeyko.

>=20
> With regards,
> Ryusuke Konishi

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
