From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: nilfs2 on Scientific Linux 6
Date: Thu, 10 Nov 2011 13:20:55 +0900 (JST)
Message-ID: <20111110.132055.135291500.ryusuke@osrg.net>
References: <4EBA295D.3060400@takezono2.tv>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EBA295D.3060400-tMH8t/rmczD1BV07Z2N/PQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-2022-jp"
To: takada-tMH8t/rmczD1BV07Z2N/PQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Wed, 09 Nov 2011 16:18:53 +0900, Shingo TAKADA wrote:
> hi.
> 
> I'm trying to use nilfs2 on Scientific Linux 6.1 with kernel
> 2.6.32-131.17.1.el6.x86_64.
> currently, there's no official package for SL6.1 (and RHEL6),
> so i tried to build rpm package using CentOS 5's srpm.
> 
> i installed nilfs-kmod-2.0.22-4.src.rpm, extract nilfs-2.0.22.tar.bz2 and
> tried to make, but fails like:
> 
> $ pwd
> /tmp/rpmbuild/SOURCES/nilfs-2.0.22/fs
> $ make -C /usr/src/kernels/2.6.32-131.17.1.el6.x86_64 M=`pwd`
> make: Entering directory `/usr/src/kernels/2.6.32-131.17.1.el6.x86_64'
>   LD      /tmp/rpmbuild/SOURCES/nilfs-2.0.22/fs/built-in.o
>   CC [M]  /tmp/rpmbuild/SOURCES/nilfs-2.0.22/fs/inode.o
> In file included from /tmp/rpmbuild/SOURCES/nilfs-2.0.22/fs/inode.c:28:
> /tmp/rpmbuild/SOURCES/nilfs-2.0.22/fs/nilfs.h: In function ‘nilfs_init_acl’:
> /tmp/rpmbuild/SOURCES/nilfs-2.0.22/fs/nilfs.h:234: error: dereferencing
> pointer to incomplete type
> make[1]: *** [/tmp/rpmbuild/SOURCES/nilfs-2.0.22/fs/inode.o] Error 1
> make: *** [_module_/tmp/rpmbuild/SOURCES/nilfs-2.0.22/fs] Error 2
> make: Leaving directory `/usr/src/kernels/2.6.32-131.17.1.el6.x86_64'
> 
> 
> I installed SL6.1's kernel Source RPM(srpm) , try to make from the
> sources in the srpm. i installed kernel-2.6.32-131.17.1.el6.src.rpm
> using yumdownloader.
> 
> but fails like:
> $ pwd
> /tmp/sl6-srpm-nilfs2
> $ make -C /usr/src/kernels/2.6.32-131.17.1.el6.x86_64 M=`pwd`
> make: Entering directory `/usr/src/kernels/2.6.32-131.17.1.el6.x86_64'
>   LD      /tmp/sl6-srpm-nilfs2/built-in.o
>   CC [M]  /tmp/sl6-srpm-nilfs2/inode.o
>   CC [M]  /tmp/sl6-srpm-nilfs2/file.o
>   CC [M]  /tmp/sl6-srpm-nilfs2/dir.o
>   CC [M]  /tmp/sl6-srpm-nilfs2/super.o
>   CC [M]  /tmp/sl6-srpm-nilfs2/namei.o
>   CC [M]  /tmp/sl6-srpm-nilfs2/page.o
>   CC [M]  /tmp/sl6-srpm-nilfs2/mdt.o
>   CC [M]  /tmp/sl6-srpm-nilfs2/btnode.o
>   CC [M]  /tmp/sl6-srpm-nilfs2/bmap.o
>   CC [M]  /tmp/sl6-srpm-nilfs2/btree.o
>   CC [M]  /tmp/sl6-srpm-nilfs2/direct.o
>   CC [M]  /tmp/sl6-srpm-nilfs2/dat.o
>   CC [M]  /tmp/sl6-srpm-nilfs2/recovery.o
>   CC [M]  /tmp/sl6-srpm-nilfs2/the_nilfs.o
>   CC [M]  /tmp/sl6-srpm-nilfs2/segbuf.o
> /tmp/sl6-srpm-nilfs2/segbuf.c: In function ‘nilfs_segbuf_write’:
> /tmp/sl6-srpm-nilfs2/segbuf.c:396: error: ‘REQ_UNPLUG’ undeclared (first
> use in this function)
> /tmp/sl6-srpm-nilfs2/segbuf.c:396: error: (Each undeclared identifier is
> reported only once
> /tmp/sl6-srpm-nilfs2/segbuf.c:396: error: for each function it appears in.)
> make[1]: *** [/tmp/sl6-srpm-nilfs2/segbuf.o] Error 1
> make: *** [_module_/tmp/sl6-srpm-nilfs2] Error 2
> make: Leaving directory `/usr/src/kernels/2.6.32-131.17.1.el6.x86_64'

REQ_UNPLUG was introduced by the following patch (and has gone with
other patch).  This seems to be a difference between the vanilla
kernel and the SL6 kernel.  Thanks for reporting.

diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index 2e6a272..4588fb9 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -508,7 +508,7 @@ static int nilfs_segbuf_write(struct nilfs_segment_buffer *s
egbuf,
                 * Last BIO is always sent through the following
                 * submission.
                 */
-               rw |= (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG);
+               rw |= REQ_SYNC | REQ_UNPLUG;
                res = nilfs_segbuf_submit_bio(segbuf, &wi, rw);
        }


> how should i do to use nilfs on SL6 environment?
> or do you have any plan to release CentOS6 package of nilfs?

We feel the necessity for creating kmod branch for the Centos6 kernel,
but don't have concrete plan.

Ok, I will try it when I have time.  Or, does anyone want to try it?

Thanks,
Ryusuke Konishi

> my environment: Scientific Linux 6.1 x64 on XenServer 5.6 SP2.
> 
> Shingo TAKADA
> -- 
> takada-tMH8t/rmczD1BV07Z2N/PQ@public.gmane.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
