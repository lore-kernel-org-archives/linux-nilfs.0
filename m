From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix segctor bug that causes file system corruption
Date: Thu, 02 Jan 2014 17:38:55 +0100
Message-ID: <52C5961F.8000608@gmx.net>
References: <1388674131-22579-1-git-send-email-andreas.rohner@gmx.net> <741898E4-B794-47FF-ABF6-2DCACA2AED43@dubeyko.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <741898E4-B794-47FF-ABF6-2DCACA2AED43-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,

On 2014-01-02 17:59, Vyacheslav Dubeyko wrote:
> What version of the kernel did you used during the issue
> reproducing? Do you have the patch [1] in your kernel?

I used kernel version 3.12.4. A call to

git log --grep="Vyacheslav Dubeyko"

gives me your your patch as the first entry in the commit log, so I am
quite certain, that it was applied.

> Of course, you can discover some new issue. But, currently, I can't
> understand relation between the error message from
> nilfs_sufile_do_cancel_free() and next messages from
> nilfs_bmap_last_key() from your description. So, I need to think
> over your description more deeply and I need in confirmation that
> you reproduce the issue with presence of patch [1] in your kernel.

I am sorry if my description was not clear enough. The problem is with
the retry loop in nilfs_segctor_collect. If the current segment buffer
is full a new segment is allocated and the collection is retried. But
if the allocation of a new segment happens before
nilfs_sufile_cancel_freev, there is a possibility, that a segment is
selected, that before was freed during nilfs_segctor_collect_blocks.
Now the collection is retried and the segments are freed again. This
time though the newly allocated segment is freed as well, without any
error messages. It is still used to write active data, while it is
marked as free in the SUFILE. At some later time it is overwritten,
which can cause all kinds of errors.

If you follow the 10 steps I outlined in my commit message, you should
be able to see the problem. If some of the steps are unclear, I am
happy to provide a more thorough explanation.

best regards,
Andreas Rohner
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSxZYfAAoJEPtvGDmQA801AK4P/3d5V2l77GPVPLiTUDBGoLm8
hFH86x5tcrFuoGCbP72FC9RtslVa654BMaieu2jqpmrJRKMQLEaEfBgsAgwC6sT1
mN1JFp7iMLlF4ECoCy3sJNKFVNNPhA+O7Rt/LJL94PLQayqHCl0RKGUZpjxIp5/v
mncjOsePwOVLbMpeYcNVcDL7IKc5hZ6xyB9Z1uqgwxvcsgFESacurfeS71Fj57wU
UMnD31oOqKYqgXEhyA+Vj8Ow5bOmYcE0WbYZh3obZSD2Efr2GWqnUZKyIY/K3+aM
dlcgOYTou4/rbxND/2rh15u8aSJSIDls8sORvQ0fu9bANmEAZZI+AvmdJA15feR4
kmoYJB0oD+0dGAA7JMRlDCte/wz2dRcHVlJ5Rz/SJ/flE83NEbjn9SCqispqJXJE
3IcMU/37/onTS/3q8CXSB836Pym5vTN9PXRzrFZeUrKcxWLgRYrtC4/PaLt8KdhC
HWM7U8TCV9LFEJ2efEqbNjLYOnyCVe36OQEOaeTCeshdtN2PZj+9YQBKFYnNoOXs
q0LXVUXhXrcTSyd7xaZv/HxrIsqpzz0iqyVW8yiZO2CZjJy4t5kxh58j4dmCh8Ku
C90f3FCUWxbMr2pu/0lWw4ySyF119iO1nhJnRHqfBr2iGdYlUcyqEA9ylqwGVAhQ
b/Pb36DpG9NQNQOwTcsP
=bSZ7
-----END PGP SIGNATURE-----
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
