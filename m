From: shubham sharma <shubham20006-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: nilfs compilation errors
Date: Mon, 30 Apr 2012 16:49:12 +0530
Message-ID: <CAGS5fSzREKF5QGKMUWwZ9RXhY==STpDkm-aDF9_0L8oNoJ7VPg@mail.gmail.com>
References: <CAGS5fSyvGmPexvi92oaTjXeATOSaxj9XRA+Liih7uWGUjFKODg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        bh=i9Qn58P0tsqEeNucnFh8IJ/80paQmFB0iLEfakcKRFE=;
        b=S3y0PIdP1KOKuI975Gk9PcH0iuMn3TMV7vcyCvyDPO1oyYxIpqx4ExrJMajhFz7Ena
         UChBDGLdKEc0+vPN8gbaUxsCeGjsasmx4mZk3Er1pa8MM/vFjN044CbA94gHjBMp9xdV
         L3BHkwh0MXhrJn4MctZHGuCjEyqaX9lptj/Rcn1N6ICg6sC3WeyxTOYO6SlQNQb0mDB7
         G+dnQUn4ZWhKe2LwJyRzTEs3aw2SGXEMtdb0EJbGaSI2nrRhxHC7DwWsHB4iBWHCd0SC
         /ffT2ifpCUsgO900bGqylII1lzdC9PYZyfAXqJr+X3A25+U48w9O6W77468PfVpjLIQ3
         MUoA==
In-Reply-To: <CAGS5fSyvGmPexvi92oaTjXeATOSaxj9XRA+Liih7uWGUjFKODg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

I am trying to compile the nilfs sources on Ubuntu but it is giving
compilation errors.

My kernel version is

----8<----
shubham@shubham-VirtualBox:~/work/nilfs/git_repo/nilfs2-module$ uname -=
r
3.0.0-12-generic
----8<----

I got the nilfs sources from the git repository:

----8<----
shubham@shubham-VirtualBox:~/work/nilfs$=A0git clone
git://github.com/nilfs-dev/nilfs2-module.git
----8<----

After getting the sources, i tried to compile the sources but i am
getting the following compilation errors:

----8<----
shubham@shubham-VirtualBox:~/work/nilfs/git_repo/nilfs2-module$ make
make -C fs
make[1]: Entering directory `/home/shubham/work/nilfs/git_repo/nilfs2-m=
odule/fs'
make -C /lib/modules/3.0.0-12-generic/build
SUBDIRS=3D/home/shubham/work/nilfs/git_repo/nilfs2-module/fs
BUILD_DIR=3D/home/shubham/work/nilfs/git_repo/nilfs2-module/fs modules
make[2]: Entering directory `/usr/src/linux-headers-3.0.0-12-generic'
=A0 CC [M] =A0/home/shubham/work/nilfs/git_repo/nilfs2-module/fs/inode.=
o
In file included from
/home/shubham/work/nilfs/git_repo/nilfs2-module/fs/inode.c:28:0:
/home/shubham/work/nilfs/git_repo/nilfs2-module/fs/nilfs.h: In
function =91nilfs_init_acl=92:
/home/shubham/work/nilfs/git_repo/nilfs2-module/fs/nilfs.h:234:31:
error: dereferencing pointer to incomplete type
/home/shubham/work/nilfs/git_repo/nilfs2-module/fs/inode.c: In
function =91nilfs_write_begin=92:
/home/shubham/work/nilfs/git_repo/nilfs2-module/fs/inode.c:212:5:
warning: passing argument 1 of =91block_write_begin=92 from incompatibl=
e
pointer type [enabled by default]
include/linux/buffer_head.h:204:5: note: expected =91struct
address_space *=92 but argument is of type =91struct file *=92
/home/shubham/work/nilfs/git_repo/nilfs2-module/fs/inode.c:212:5:
warning: passing argument 2 of =91block_write_begin=92 makes integer fr=
om
pointer without a cast [enabled by default]
include/linux/buffer_head.h:204:5: note: expected =91loff_t=92 but
argument is of type =91struct address_space *=92
/home/shubham/work/nilfs/git_repo/nilfs2-module/fs/inode.c:212:5:
warning: passing argument 5 of =91block_write_begin=92 makes pointer fr=
om
integer without a cast [enabled by default]
include/linux/buffer_head.h:204:5: note: expected =91struct page **=92 =
but
argument is of type =91unsigned int=92
/home/shubham/work/nilfs/git_repo/nilfs2-module/fs/inode.c:212:5:
warning: passing argument 6 of =91block_write_begin=92 from incompatibl=
e
pointer type [enabled by default]
include/linux/buffer_head.h:204:5: note: expected =91int (*)(struct
inode *, sector_t, =A0struct buffer_head *, int)=92 but argument is of
type =91struct page **=92
/home/shubham/work/nilfs/git_repo/nilfs2-module/fs/inode.c:212:5:
error: too many arguments to function =91block_write_begin=92
include/linux/buffer_head.h:204:5: note: declared here
/home/shubham/work/nilfs/git_repo/nilfs2-module/fs/inode.c: At top leve=
l:
/home/shubham/work/nilfs/git_repo/nilfs2-module/fs/inode.c:302:2:
error: unknown field =91sync_page=92 specified in initializer
/home/shubham/work/nilfs/git_repo/nilfs2-module/fs/inode.c:302:16:
error: =91block_sync_page=92 undeclared here (not in a function)
/home/shubham/work/nilfs/git_repo/nilfs2-module/fs/inode.c: In
function =91nilfs_delete_inode=92:
/home/shubham/work/nilfs/git_repo/nilfs2-module/fs/inode.c:721:3:
error: implicit declaration of function =91clear_inode=92
[-Werror=3Dimplicit-function-declaration]
/home/shubham/work/nilfs/git_repo/nilfs2-module/fs/inode.c: In
function =91nilfs_setattr=92:
/home/shubham/work/nilfs/git_repo/nilfs2-module/fs/inode.c:759:2:
error: implicit declaration of function =91inode_setattr=92
[-Werror=3Dimplicit-function-declaration]
cc1: some warnings being treated as errors

make[3]: *** [/home/shubham/work/nilfs/git_repo/nilfs2-module/fs/inode.=
o]
Error 1
make[2]: *** [_module_/home/shubham/work/nilfs/git_repo/nilfs2-module/f=
s]
Error 2
make[2]: Leaving directory `/usr/src/linux-headers-3.0.0-12-generic'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/shubham/work/nilfs/git_repo/nilfs2-mo=
dule/fs'
make: *** [fs] Error 2
----8<----

Is there any step that I am missing before compiling the code?

Regards,
Shubham
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
