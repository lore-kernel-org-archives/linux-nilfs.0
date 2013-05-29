From: =?utf-8?B?SsO2cm4=?= Engel <joern-PCqxUs/MD9bYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v6 2/2] nilfs2: use atomic64_t type for inodes_count
 and blocks_count fields in nilfs_root struct
Date: Wed, 29 May 2013 15:16:10 -0400
Message-ID: <20130529191610.GA6658@logfs.org>
References: <1369819590.2224.22.camel@slavad-ubuntu>
 <20130530.003256.27786650.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130530.003256.27786650.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Thu, 30 May 2013 00:32:56 +0900, Ryusuke Konishi wrote:
> On Wed, 29 May 2013 13:26:30 +0400, Vyacheslav Dubeyko wrote:
> > From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> > Subject: [PATCH v6 2/2] nilfs2: use atomic64_t type for inodes_coun=
t and blocks_count fields in nilfs_root struct
> >=20
> > The cp_inodes_count and cp_blocks_count are represented as
> > __le64 type in on-disk structure (struct nilfs_checkpoint).
> > But analogous fields in in-core structure (struct nilfs_root)
> > are represented by atomic_t type.
> >=20
> > This patch replaces atomic_t on atomic64_t type in representation
> > of inodes_count and blocks_count fields in struct nilfs_root.
> >=20
> > Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> > CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
> > CC: Joern Engel <joern-PCqxUs/MD9bYtjvyW6yDsg@public.gmane.org>
>=20
> Acked-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Not sure how much this is actually worth, but

Acked-by: Joern Engel <joern-PCqxUs/MD9bYtjvyW6yDsg@public.gmane.org>

J=C3=B6rn

--
Linux is more the core point of a concept that surrounds "open source"
which, in turn, is based on a false concept. This concept is that
people actually want to look at source code.
-- Rob Enderle
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
