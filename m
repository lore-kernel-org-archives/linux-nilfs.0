From: =?utf-8?B?SsO2cm4=?= Engel <joern-PCqxUs/MD9bYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v5 2/2] nilfs2: use atomic_long_t type for inodes_count
 and blocks_count fields in nilfs_root struct
Date: Fri, 24 May 2013 13:54:06 -0400
Message-ID: <20130524175406.GD30270@logfs.org>
References: <1369402372.2235.23.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1369402372.2235.23.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Fri, 24 May 2013 17:32:52 +0400, Vyacheslav Dubeyko wrote:
>
> Subject: [PATCH v5 2/2] nilfs2: use atomic_long_t type for inodes_cou=
nt
=2E..
> The cp_inodes_count and cp_blocks_count are represented as
> __le64 type in on-disk structure (struct nilfs_checkpoint).

Isn't atomic_long_t defined to be 32bit on 32bit architectures?

J=C3=B6rn

--
What one programmer can do in one month, two programmers can do in two =
months.
-- Fred Brooks
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
