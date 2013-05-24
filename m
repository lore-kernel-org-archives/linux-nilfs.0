From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH v5 2/2] nilfs2: use atomic_long_t type for inodes_count
 and blocks_count fields in nilfs_root struct
Date: Fri, 24 May 2013 17:37:12 -0400
Message-ID: <20130524213712.GG30270@logfs.org>
References: <1369402372.2235.23.camel@slavad-ubuntu>
 <20130524175406.GD30270@logfs.org>
 <C2E05418-7137-46A8-AEC9-0E6A10F42669@dubeyko.com>
 <20130524190146.GF30270@logfs.org>
 <9EFBFA22-976F-4478-9B78-701B5A498E23@dubeyko.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9EFBFA22-976F-4478-9B78-701B5A498E23@dubeyko.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Clemens Eisserer <linuxhippy@gmail.com>

On Sat, 25 May 2013 02:01:04 +0400, Vyacheslav Dubeyko wrote:
> On May 24, 2013, at 11:01 PM, J=C3=B6rn Engel wrote:
> > On Fri, 24 May 2013 23:30:10 +0400, Vyacheslav Dubeyko wrote:
> >> On May 24, 2013, at 9:54 PM, J=C3=B6rn Engel wrote:
> >>> On Fri, 24 May 2013 17:32:52 +0400, Vyacheslav Dubeyko wrote:
> >>>>=20
> >>>> Subject: [PATCH v5 2/2] nilfs2: use atomic_long_t type for inode=
s_count
> >>> ...
> >>>> The cp_inodes_count and cp_blocks_count are represented as
> >>>> __le64 type in on-disk structure (struct nilfs_checkpoint).
> >>>=20
> >>> Isn't atomic_long_t defined to be 32bit on 32bit architectures?
> >>=20
> >> As I understand, yes.
> >=20
> > And it doesn't concern you to use a 32bit memory structure to
> > represent a 64bit on-disk structure? ;)
>=20
> I suppose that you mean possibility to mount NILFS2 volume under 32 b=
it architecture
> after working with this volume under 64 bit architecture. Am I correc=
t?
>=20
> Have you any concrete remarks about code of the patch? Feel free to o=
ffer your vision.

Replace atomic_long_t with atomic64_t and replace the various accessor
functions.  The on-disk data structure is 64bit, so of course you use
a 64bit in-memory structure.

Does it really take a vision to come up with this idea?

J=C3=B6rn

--
People will accept your ideas much more readily if you tell them
that Benjamin Franklin said it first.
-- unknown
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
