From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: [PATCH v5 2/2] nilfs2: use atomic_long_t type for inodes_count
 and blocks_count fields in nilfs_root struct
Date: Sat, 25 May 2013 12:33:03 +0900 (JST)
Message-ID: <20130525.123303.412805468.konishi.ryusuke@lab.ntt.co.jp>
References: <20130524190146.GF30270@logfs.org>
	<9EFBFA22-976F-4478-9B78-701B5A498E23@dubeyko.com>
	<20130524213712.GG30270@logfs.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20130524213712.GG30270@logfs.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="utf-8"
To: joern@logfs.org, Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Clemens Eisserer <linuxhippy@gmail.com>

On Fri, 24 May 2013 17:37:12 -0400, J=C3=B6rn Engel wrote:
> On Sat, 25 May 2013 02:01:04 +0400, Vyacheslav Dubeyko wrote:
>> On May 24, 2013, at 11:01 PM, J=C3=B6rn Engel wrote:
>> > On Fri, 24 May 2013 23:30:10 +0400, Vyacheslav Dubeyko wrote:
>> >> On May 24, 2013, at 9:54 PM, J=C3=B6rn Engel wrote:
>> >>> On Fri, 24 May 2013 17:32:52 +0400, Vyacheslav Dubeyko wrote:
>> >>>>=20
>> >>>> Subject: [PATCH v5 2/2] nilfs2: use atomic_long_t type for inod=
es_count
>> >>> ...
>> >>>> The cp_inodes_count and cp_blocks_count are represented as
>> >>>> __le64 type in on-disk structure (struct nilfs_checkpoint).
>> >>>=20
>> >>> Isn't atomic_long_t defined to be 32bit on 32bit architectures?
>> >>=20
>> >> As I understand, yes.
>> >=20
>> > And it doesn't concern you to use a 32bit memory structure to
>> > represent a 64bit on-disk structure? ;)
>>=20
>> I suppose that you mean possibility to mount NILFS2 volume under 32 =
bit architecture
>> after working with this volume under 64 bit architecture. Am I corre=
ct?
>>=20
>> Have you any concrete remarks about code of the patch? Feel free to =
offer your vision.
>=20
> Replace atomic_long_t with atomic64_t and replace the various accesso=
r
> functions.  The on-disk data structure is 64bit, so of course you use
> a 64bit in-memory structure.
>=20
> Does it really take a vision to come up with this idea?

Things are not so simple.  It is not guaranteed that 32-bit
architectures can handle 64-bit on-disk values.  (Think ino_t, page
index, or nrpages.  These are defined with "unsigned long".)

However, these "inodes_count" and "blocks_count" are directly
corresponding to their on-disk counterparts, so using atomic64_t looks
more intuitive for most people; using atomic_long_t for these was
confusing.

Ok, I agree.

Vyacheslav, could you please consider taking in J=C3=B6rn's comment ?


With regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
