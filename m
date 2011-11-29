From: Seiji Kihara <kihara-sG5X7nlA6pw@public.gmane.org>
Subject: Re: nilfs2 on Scientific Linux 6
Date: Tue, 29 Nov 2011 12:48:39 +0900
Message-ID: <CA+G-kwVLmzddBcJKN69z1t+eE9=PxZTzvHLtQs2Wj-cF5BxfJQ@mail.gmail.com>
References: <4EBE1010.4030607@takezono2.tv>
	<20111113.035822.33559163.ryusuke@osrg.net>
	<4EC76694.6070601@takezono2.tv>
	<20111119.235302.142386436.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        bh=vN687NicvC7fM/W0Cn+oWe4ba6qpm6ij/SUt9sQRs1M=;
        b=RrmTmJBRzkofs/w+hcjYHXDddDwy9P9+YlkAX2HtDAttQxGqYtESyZcajoB7BW+jpl
         8Q/Sl1x8dUBmslB400wAI62MOW533N4L4EEE7Azju5b0AKySS+DTp0e1GosuUPUWrBEw
         j9jKUr7vYHUfemoRZL7pYEN+Inthtv7kol7gQ=
In-Reply-To: <20111119.235302.142386436.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Shingo TAKADA <takada-tMH8t/rmczD1BV07Z2N/PQ@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello Takada-san and all,

I made RPM packages of nilfs2-kmod and nilfs-utils for RHEL 6 clones.
They are placed at the NILFS site below:

http://www.nilfs.org/pub/centos/6/SRPMS/
http://www.nilfs.org/pub/centos/6/RPMS/x86_64/
http://www.nilfs.org/pub/centos/6/RPMS/i686/

Any feedback is welcome.

Regards,

Seiji Kihara

At 2011/11/19 23:53, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wr=
ote:
> Hi TAKADA-san,
> On Sat, 19 Nov 2011 17:19:32 +0900, Shingo TAKADA wrote:
>> Hi
>>
>> i cloned the centos6 repo and confirmed nilfs2 works fine!
>> there's no kernel panics happend on my environment, lscp and unmount
>> works well. thank you very much.
>>
>>
>> then, i'm trying to build rpm package of the centos6 kmod.
>> but i'm not familiar with rpm and kernel modules.
>>
>> i'm reusing SPEC file from centos5's nilfs srpm.
>> kmodtool is renewed in RHEL6, replace with it.
>>
>> in SPEC file, build and install section, SPEC file calls
>> make with "modules" and "modules_install" argument.
>> Makefile in the centos6-kmod repo has no such rules.
>>
>> how should i fix Makefile or SPEC file?
>
> You may change both files.
>
> I'm not familiar with rpm build, too. =A0But, I guess it's possible t=
o
> add modules and modules_install targets to makefiles in the
> nilfs2-kmod package to handle the change.
>
> Send us back the patch when well done. =A0I will apply it to my
> centos6-kmod tree. =A0(At least for changes against makefiles).
>
>
> Thanks,
> Ryusuke Konishi
>
>
>> thanks.
>> Shingo TAKADA
>>
>> (11/11/13 3:58), Ryusuke Konishi wrote:
>> > Hi,
>> > On Sat, 12 Nov 2011 15:20:00 +0900, Shingo TAKADA wrote:
>> >> Hi
>> >>
>> >> thank you for your advice.
>> >>
>> >> I replace the line, REQ_UNPLUG, with your patch, BIO_RW_UNPLUG in
>> >> segbuf.c in SL6's kernel srpm archive.
>> >>
>> >> make is done successfully like 2.6.32.27's case (see my last post=
),
>> >> and kernel panics like 2.6.32.27's case when unmounting the nilfs=
2
>> >> partition...
>> >>
>> >> i rebuilt the nilfs2 partition again after replacing the nilfs2.k=
o
>> >> module and modprobe it.
>> >
>> > I've pushed out a standalone nilfs2 kmod for Centos6 and SL6.
>> >
>> > It is available from http://git.nilfs.org/nilfs2-kmod-centos6.git =
as
>> > follows:
>> >
>> > =A0 $ git clone http://git.nilfs.org/nilfs2-kmod-centos6.git
>> > =A0 $ cd nilfs2-kmod-centos6
>> > =A0 $ make
>> > =A0 $ sudo make install
>> >
>> > It includes important changes and bug-fixes which are backported f=
rom
>> > newer kernels. =A0The kmod seems to work fine so far for me. =A0Ch=
eck it
>> > out.
>> >
>> >
>> > Regards,
>> > Ryusuke Konishi
>> >
>> >> thanks.
>> >> Shingo TAKADA
>> >>
>> >> (11/11/10 13:20), Ryusuke Konishi wrote:
>> >>> Hi,
>> >>> On Wed, 09 Nov 2011 16:18:53 +0900, Shingo TAKADA wrote:
>> >>>> hi.
>> >>>>
>> >>>> I'm trying to use nilfs2 on Scientific Linux 6.1 with kernel
>> >>>> 2.6.32-131.17.1.el6.x86_64.
>> >>>> currently, there's no official package for SL6.1 (and RHEL6),
>> >>>> so i tried to build rpm package using CentOS 5's srpm.
>> >>>>
>> >>>> i installed nilfs-kmod-2.0.22-4.src.rpm, extract nilfs-2.0.22.t=
ar.bz2 and
>> >>>> tried to make, but fails like:
>> >>>>
>> >>>> $ pwd
>> >>>> /tmp/rpmbuild/SOURCES/nilfs-2.0.22/fs
>> >>>> $ make -C /usr/src/kernels/2.6.32-131.17.1.el6.x86_64 M=3D`pwd`
>> >>>> make: Entering directory `/usr/src/kernels/2.6.32-131.17.1.el6.=
x86_64'
>> >>>> =A0 =A0 LD =A0 =A0 =A0/tmp/rpmbuild/SOURCES/nilfs-2.0.22/fs/bui=
lt-in.o
>> >>>> =A0 =A0 CC [M] =A0/tmp/rpmbuild/SOURCES/nilfs-2.0.22/fs/inode.o
>> >>>> In file included from /tmp/rpmbuild/SOURCES/nilfs-2.0.22/fs/ino=
de.c:28:
>> >>>> /tmp/rpmbuild/SOURCES/nilfs-2.0.22/fs/nilfs.h: In function =91n=
ilfs_init_acl=92:
>> >>>> /tmp/rpmbuild/SOURCES/nilfs-2.0.22/fs/nilfs.h:234: error: deref=
erencing
>> >>>> pointer to incomplete type
>> >>>> make[1]: *** [/tmp/rpmbuild/SOURCES/nilfs-2.0.22/fs/inode.o] Er=
ror 1
>> >>>> make: *** [_module_/tmp/rpmbuild/SOURCES/nilfs-2.0.22/fs] Error=
 2
>> >>>> make: Leaving directory `/usr/src/kernels/2.6.32-131.17.1.el6.x=
86_64'
>> >>>>
>> >>>>
>> >>>> I installed SL6.1's kernel Source RPM(srpm) , try to make from =
the
>> >>>> sources in the srpm. i installed kernel-2.6.32-131.17.1.el6.src=
=2Erpm
>> >>>> using yumdownloader.
>> >>>>
>> >>>> but fails like:
>> >>>> $ pwd
>> >>>> /tmp/sl6-srpm-nilfs2
>> >>>> $ make -C /usr/src/kernels/2.6.32-131.17.1.el6.x86_64 M=3D`pwd`
>> >>>> make: Entering directory `/usr/src/kernels/2.6.32-131.17.1.el6.=
x86_64'
>> >>>> =A0 =A0 LD =A0 =A0 =A0/tmp/sl6-srpm-nilfs2/built-in.o
>> >>>> =A0 =A0 CC [M] =A0/tmp/sl6-srpm-nilfs2/inode.o
>> >>>> =A0 =A0 CC [M] =A0/tmp/sl6-srpm-nilfs2/file.o
>> >>>> =A0 =A0 CC [M] =A0/tmp/sl6-srpm-nilfs2/dir.o
>> >>>> =A0 =A0 CC [M] =A0/tmp/sl6-srpm-nilfs2/super.o
>> >>>> =A0 =A0 CC [M] =A0/tmp/sl6-srpm-nilfs2/namei.o
>> >>>> =A0 =A0 CC [M] =A0/tmp/sl6-srpm-nilfs2/page.o
>> >>>> =A0 =A0 CC [M] =A0/tmp/sl6-srpm-nilfs2/mdt.o
>> >>>> =A0 =A0 CC [M] =A0/tmp/sl6-srpm-nilfs2/btnode.o
>> >>>> =A0 =A0 CC [M] =A0/tmp/sl6-srpm-nilfs2/bmap.o
>> >>>> =A0 =A0 CC [M] =A0/tmp/sl6-srpm-nilfs2/btree.o
>> >>>> =A0 =A0 CC [M] =A0/tmp/sl6-srpm-nilfs2/direct.o
>> >>>> =A0 =A0 CC [M] =A0/tmp/sl6-srpm-nilfs2/dat.o
>> >>>> =A0 =A0 CC [M] =A0/tmp/sl6-srpm-nilfs2/recovery.o
>> >>>> =A0 =A0 CC [M] =A0/tmp/sl6-srpm-nilfs2/the_nilfs.o
>> >>>> =A0 =A0 CC [M] =A0/tmp/sl6-srpm-nilfs2/segbuf.o
>> >>>> /tmp/sl6-srpm-nilfs2/segbuf.c: In function =91nilfs_segbuf_writ=
e=92:
>> >>>> /tmp/sl6-srpm-nilfs2/segbuf.c:396: error: =91REQ_UNPLUG=92 unde=
clared (first
>> >>>> use in this function)
>> >>>> /tmp/sl6-srpm-nilfs2/segbuf.c:396: error: (Each undeclared iden=
tifier is
>> >>>> reported only once
>> >>>> /tmp/sl6-srpm-nilfs2/segbuf.c:396: error: for each function it =
appears in.)
>> >>>> make[1]: *** [/tmp/sl6-srpm-nilfs2/segbuf.o] Error 1
>> >>>> make: *** [_module_/tmp/sl6-srpm-nilfs2] Error 2
>> >>>> make: Leaving directory `/usr/src/kernels/2.6.32-131.17.1.el6.x=
86_64'
>> >>>
>> >>> REQ_UNPLUG was introduced by the following patch (and has gone w=
ith
>> >>> other patch). =A0This seems to be a difference between the vanil=
la
>> >>> kernel and the SL6 kernel. =A0Thanks for reporting.
>> >>>
>> >>> diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
>> >>> index 2e6a272..4588fb9 100644
>> >>> --- a/fs/nilfs2/segbuf.c
>> >>> +++ b/fs/nilfs2/segbuf.c
>> >>> @@ -508,7 +508,7 @@ static int nilfs_segbuf_write(struct nilfs_s=
egment_buffer *s
>> >>> egbuf,
>> >>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Last BIO is always sent=
 through the following
>> >>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* submission.
>> >>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> >>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rw |=3D (1<< =A0 BIO_RW_SYNCIO) | =
(1<< =A0 BIO_RW_UNPLUG);
>> >>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rw |=3D REQ_SYNC | REQ_UNPLUG;
>> >>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 res =3D nilfs_segbuf_submit_=
bio(segbuf,&wi, rw);
>> >>> =A0 =A0 =A0 =A0 =A0 }
>> >>>
>> >>>
>> >>>> how should i do to use nilfs on SL6 environment?
>> >>>> or do you have any plan to release CentOS6 package of nilfs?
>> >>>
>> >>> We feel the necessity for creating kmod branch for the Centos6 k=
ernel,
>> >>> but don't have concrete plan.
>> >>>
>> >>> Ok, I will try it when I have time. =A0Or, does anyone want to t=
ry it?
>> >>>
>> >>> Thanks,
>> >>> Ryusuke Konishi
>> >>>
>> >>>> my environment: Scientific Linux 6.1 x64 on XenServer 5.6 SP2.
>> >>>>
>> >>>> Shingo TAKADA
>> >>>> --
>> >>>> takada-tMH8t/rmczD1BV07Z2N/PQ@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
