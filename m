From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] mkfs: check sizes of important structs at build time
Date: Sun, 05 Jan 2014 01:08:43 +0900 (JST)
Message-ID: <20140105.010843.356918311.konishi.ryusuke@lab.ntt.co.jp>
References: <1388842171-16105-1-git-send-email-mitake.hitoshi@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1388842171-16105-1-git-send-email-mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Hitoshi Mitake <mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>

On Sat,  4 Jan 2014 22:29:31 +0900, Hitoshi Mitake wrote:
> Current nilfs_check_ondisk_sizes() checks sizes of important structs
> at run time. The checking should be done at build time. This patch
> adds a new macro, BUILD_BUG_ON(), for this purpose. It is similar to
> static_assert() of C++11. If an argument is true, the macro causes a
> bulid error.
> 
> Below is an example of BUILD_BUG_ON(). When the checked conditions are
> true like below:
> 
> /* intentional change for testing BUILD_BUG_ON() */
> 
> static __attribute__((used)) void nilfs_check_ondisk_sizes(void)
> {
> 	BUILD_BUG_ON(sizeof(struct nilfs_inode) > NILFS_MIN_BLOCKSIZE);
> ...
> 
> build process of mkfs.o causes errors like this:
> 
> gcc -std=gnu99 -DHAVE_CONFIG_H -I. -I../..  -I../../include  -Wall -g -O2 -MT mkfs.o -MD -MP -MF .deps/mkfs.Tpo -c -o mkfs.o mkfs.c
> mkfs.c: In function 'nilfs_check_ondisk_sizes':
> mkfs.c:429:2: error: negative width in bit-field '<anonymous>'
> mkfs.c:430:2: error: negative width in bit-field '<anonymous>'
> mkfs.c:431:2: error: negative width in bit-field '<anonymous>'
> mkfs.c:432:2: error: negative width in bit-field '<anonymous>'
> mkfs.c:433:2: error: negative width in bit-field '<anonymous>'
> mkfs.c:434:2: error: negative width in bit-field '<anonymous>'
> mkfs.c:435:2: error: negative width in bit-field '<anonymous>'
> 
> Signed-off-by: Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This is an interesting patch.

I am inclined to apply this since the every test in the
nilfs_check_ondisk_sizes function is static.

If we will add a new check that depends on block size in a future, we
need to add a separate runtime check function as Vyacheslav wrote, but
I think you are doing right thing.

One my question is why you used bit operator.  The BUILD_BUG_ON marcro
of kernel is implemented with negative array index.
Is there any reason for this ?

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
