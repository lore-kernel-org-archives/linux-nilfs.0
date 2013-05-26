From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v5 2/2] nilfs2: use atomic_long_t type for inodes_count
 and blocks_count fields in nilfs_root struct
Date: Sun, 26 May 2013 23:43:25 +0900 (JST)
Message-ID: <20130526.234325.77354133.konishi.ryusuke@lab.ntt.co.jp>
References: <20130524213712.GG30270@logfs.org>
	<20130525.123303.412805468.konishi.ryusuke@lab.ntt.co.jp>
	<DF00B7E3-7352-4AEC-B0D9-AB7E624E5793@dubeyko.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <DF00B7E3-7352-4AEC-B0D9-AB7E624E5793-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="utf-8"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: joern-PCqxUs/MD9bYtjvyW6yDsg@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Sun, 26 May 2013 16:18:20 +0400, Vyacheslav Dubeyko wrote:
> Hi Ryusuke,
>=20
> On May 25, 2013, at 7:33 AM, Ryusuke Konishi wrote:
>=20
>> On Fri, 24 May 2013 17:37:12 -0400, J=C3=B6rn Engel wrote:
>>> On Sat, 25 May 2013 02:01:04 +0400, Vyacheslav Dubeyko wrote:
>>>> On May 24, 2013, at 11:01 PM, J=C3=B6rn Engel wrote:
>>>>> On Fri, 24 May 2013 23:30:10 +0400, Vyacheslav Dubeyko wrote:
>>>>>> On May 24, 2013, at 9:54 PM, J=C3=B6rn Engel wrote:
>>>>>>> On Fri, 24 May 2013 17:32:52 +0400, Vyacheslav Dubeyko wrote:
>>>>>>>>=20
>>>>>>>> Subject: [PATCH v5 2/2] nilfs2: use atomic_long_t type for ino=
des_count
>>>>>>> ...
>>>>>>>> The cp_inodes_count and cp_blocks_count are represented as
>>>>>>>> __le64 type in on-disk structure (struct nilfs_checkpoint).
>>>>>>>=20
>>>>>>> Isn't atomic_long_t defined to be 32bit on 32bit architectures?
>>>>>>=20
>>>>>> As I understand, yes.
>>>>>=20
>>>>> And it doesn't concern you to use a 32bit memory structure to
>>>>> represent a 64bit on-disk structure? ;)
>>>>=20
>>>> I suppose that you mean possibility to mount NILFS2 volume under 3=
2 bit architecture
>>>> after working with this volume under 64 bit architecture. Am I cor=
rect?
>>>>=20
>>>> Have you any concrete remarks about code of the patch? Feel free t=
o offer your vision.
>>>=20
>>> Replace atomic_long_t with atomic64_t and replace the various acces=
sor
>>> functions.  The on-disk data structure is 64bit, so of course you u=
se
>>> a 64bit in-memory structure.
>>>=20
>>> Does it really take a vision to come up with this idea?
>>=20
>> Things are not so simple.  It is not guaranteed that 32-bit
>> architectures can handle 64-bit on-disk values.  (Think ino_t, page
>> index, or nrpages.  These are defined with "unsigned long".)
>>=20
>> However, these "inodes_count" and "blocks_count" are directly
>> corresponding to their on-disk counterparts, so using atomic64_t loo=
ks
>> more intuitive for most people; using atomic_long_t for these was
>> confusing.
>>=20
>> Ok, I agree.
>>=20
>> Vyacheslav, could you please consider taking in J=C3=B6rn's comment =
?
>>=20
>=20
> So, I have such understanding. Please, correct me if I'm wrong.
>=20
> The atomic_long_t and atomic64_t types are 64 bits on 64-bit architec=
ture.
> The atomic_long_t type is 32 bits on 32-bit architecture. So, If we w=
ant to have
> 64 bits atomic counter on 32-bit architecture then we need to use gen=
eric atomic64_t
> implementation (asm-generic/atomic64.t). But generic 64-bit atomic su=
pport
> depends from CONFIG_GENERIC_ATOMIC64 configuration option
> (http://lxr.free-electrons.com/source/include/linux/atomic.h#L127). A=
s a result,
> NILFS2 driver needs to have dependance from CONFIG_GENERIC_ATOMIC64
> configuration option on 32-bit architecture configuration.

You don't have to add denpendency to CONFIG_GENERIC_ATOMIC64.

In my understanding, the generic atomic64 operations (i.e. routines in
lib/atomic64.c) are only used when selected architecture doesn't have
own implementation.

=46or instance, sparc32 uses the generic implementation, but x86_64
architecture uses arch/x86/include/asm/atomic64_64.h, and x86_32 uses
arch/x86/include/asm/atomic64_32.h and
arch/x86/lib/atomic64_{386,cx8}_32.S for 32-bit.

CONFIG_GENERIC_ATOMIC64 is selected by arch/*/Kconfig in the former
case.  It is not intended to be selected directly by users.

With regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
