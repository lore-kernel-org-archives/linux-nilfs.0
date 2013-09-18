From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Problems in GC when using NilFS2 with large segment size
Date: Thu, 19 Sep 2013 01:07:34 +0900 (JST)
Message-ID: <20130919.010734.64997601.konishi.ryusuke@lab.ntt.co.jp>
References: <201309161617.AA05682@capsicum.lab.ntt.co.jp>
	<3764420FCC841C4DAE85E3B76FC61A772A5A77E9@wdscexmb03.sc.wdc.com>
	<1379489814.2365.54.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1379489814.2365.54.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: Benixon.Dhas-Sjgp3cTcYWE@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 18 Sep 2013 11:36:54 +0400, Vyacheslav Dubeyko wrote:
> By the way, I am implementing extended attributes (xattr) support in
> NILFS2 right now.

Sounds great.

Could you share your implementation idea again before finishing your
patchset?

Is the basic idea same as the following RFC?

[1] http://www.mail-archive.com/linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg01298.html

There are several implementation approaches:

(1) Add one or multiple xattr meta data files to store xattr blocks.
(2) Add xattr btree to each disk inode (this seems to need inode size
    extension).
(3) Use part of inodes to hold xattr data.
(4) Extend btree to make holding mutiple data streams possible.

And we should first evaluate pros and cons of them to minimize rework,
for example, impact on disk format, impact on GC, impact on log
writer, and so forth.

We also have to decide whether we impose limitation on xattr block
size, that is, whether we support mutiple xattr blocks per inode or
only support single xattr block per inode.

The latter restricted implementation often becomes an issue nowadays.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
