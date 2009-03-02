From: Assaf Weizman <assaf.weizman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: troubles installing the new Nilfs2 - 2.0.8 version
Date: Mon, 2 Mar 2009 20:20:10 +0200
Message-ID: <63c84f240903021020h7471c6d1s3da16227f97a49b0@mail.gmail.com>
References: <63c84f240903010439k1c99a6dap2775a100ba16e0e2@mail.gmail.com>
	<lutz6cd07q.wl%kihara@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1850236002=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <lutz6cd07q.wl%kihara-sG5X7nlA6pw@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Mime-version: 1.0
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

--===============1850236002==
Content-Type: multipart/alternative; boundary=001636c5b3877b56e2046426de86

--001636c5b3877b56e2046426de86
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Thanks for your help,
I understand that these errors occur because I uninstalled NILFS2 correctly.
A. the 'modinfo nilfs2' showed I have NILFS 2.0.2 mod (before I deleted
manually to .ko file.. - now it shows error)
B. I tried to install several versions of NILFS from centos rpms, but
eventually I installed NILFS successfully version 2.0.7 from source-package
and it worked fine. the troubles occured when I tried to install version
2.0.8.

Does anyone have any suggestion how can I clean old traces of NILFS
RPMS+SOURCE_RPMS+KMODS_RPM+Source Packages?

Best Regrards,
Assaf.


On Mon, Mar 2, 2009 at 6:20 AM, Seiji Kihara <kihara-sG5X7nlA6pw@public.gmane.org> wrote:

> Hello,
>
> At Sun, 1 Mar 2009 14:39:14 +0200,
> Assaf Weizman wrote:
> > Hello,
> > I'm asking for your help.
> > I tried to uninstall the old 2.0.7 version and install the 2.0.8 one, but
> > all these errors keep popping up:
> >
> > [root@asaftest new2.0.8]# cd nilfs-2.0.8
> > [root@asaftest nilfs-2.0.8]# make
> > make -C fs
> > make[1]: Entering directory `/home/assafw/nilfs/new2.0.8/nilfs-2.0.8/fs'
> > make -C /lib/modules/2.6.18-53.1.19.el5/build
> > SUBDIRS=/home/assafw/nilfs/new2.0.8/nilfs-2.0.8/fs
> > BUILD_DIR=/home/assafw/nilfs/new2.0.8/nilfs-2.0.8/fs modules
> > make[2]: Entering directory `/usr/src/kernels/2.6.18-53.1.19.el5-i686'
> >   CC [M]  /home/assafw/nilfs/new2.0.8/nilfs-2.0.8/fs/inode.o
> > In file included from
> /home/assafw/nilfs/new2.0.8/nilfs-2.0.8/fs/nilfs.h:31,
> >                  from
> /home/assafw/nilfs/new2.0.8/nilfs-2.0.8/fs/inode.c:28:
> > /home/assafw/nilfs/new2.0.8/nilfs-2.0.8/fs/kern_feature.h:307: error:
>
> RHEL kernels incorporate some features from newer kernels, but these
> are not detected from their base version number (2.6.18), and some
> kernels including RHEL5 cannot be supported by our standard NILFS
> source package.
>
> We offer source RPMs for distribution kernels and some of them
> includes patches for each distribution kernel.  For RHEL5.2,
>
> http://www.nilfs.org/pub/centos/5/SRPMS/nilfs-kmod-2.0.8-1.src.rpm
>
> can be used.  You can build kernel modules with the `rpmbuild'
> command, and can extract custom patch from it.
>
> Regards,
>
> Seiji Kihara
> NILFS Team, NTT Labs.
> _______________________________________________
> users mailing list
> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> https://www.nilfs.org/mailman/listinfo/users
>

--001636c5b3877b56e2046426de86
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thanks for your help,<br>I understand that these errors oc=
cur because I uninstalled NILFS2 correctly.<br>A. the &#39;modinfo nilfs2&#=
39; showed I have NILFS 2.0.2 mod (before I deleted manually to .ko file.. =
- now it shows error)<br>
B. I tried to install several versions of NILFS from centos rpms, but event=
ually I installed NILFS successfully version 2.0.7 from source-package and =
it worked fine. the troubles occured when I tried to install version 2.0.8.=
<br>
<br>Does anyone have any suggestion how can I clean old traces of NILFS RPM=
S+SOURCE_RPMS+KMODS_RPM+Source Packages?<br><br>Best Regrards,<br>Assaf.<br=
><br><br><div class=3D"gmail_quote">On Mon, Mar 2, 2009 at 6:20 AM, Seiji K=
ihara <span dir=3D"ltr">&lt;<a href=3D"mailto:kihara-sG5X7nlA6pw@public.gmane.org">kihara@osrg.=
net</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">Hello,<br>
<br>
At Sun, 1 Mar 2009 14:39:14 +0200,<br>
<div class=3D"Ih2E3d">Assaf Weizman wrote:<br>
&gt; Hello,<br>
&gt; I&#39;m asking for your help.<br>
&gt; I tried to uninstall the old 2.0.7 version and install the 2.0.8 one, =
but<br>
&gt; all these errors keep popping up:<br>
&gt;<br>
&gt; [root@asaftest new2.0.8]# cd nilfs-2.0.8<br>
&gt; [root@asaftest nilfs-2.0.8]# make<br>
&gt; make -C fs<br>
&gt; make[1]: Entering directory `/home/assafw/nilfs/new2.0.8/nilfs-2.0.8/f=
s&#39;<br>
&gt; make -C /lib/modules/2.6.18-53.1.19.el5/build<br>
&gt; SUBDIRS=3D/home/assafw/nilfs/new2.0.8/nilfs-2.0.8/fs<br>
&gt; BUILD_DIR=3D/home/assafw/nilfs/new2.0.8/nilfs-2.0.8/fs modules<br>
&gt; make[2]: Entering directory `/usr/src/kernels/2.6.18-53.1.19.el5-i686&=
#39;<br>
&gt; =A0 CC [M] =A0/home/assafw/nilfs/new2.0.8/nilfs-2.0.8/fs/inode.o<br>
&gt; In file included from /home/assafw/nilfs/new2.0.8/nilfs-2.0.8/fs/nilfs=
.h:31,<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0from /home/assafw/nilfs/new2.0.8/ni=
lfs-2.0.8/fs/inode.c:28:<br>
&gt; /home/assafw/nilfs/new2.0.8/nilfs-2.0.8/fs/kern_feature.h:307: error:<=
br>
<br>
</div>RHEL kernels incorporate some features from newer kernels, but these<=
br>
are not detected from their base version number (2.6.18), and some<br>
kernels including RHEL5 cannot be supported by our standard NILFS<br>
source package.<br>
<br>
We offer source RPMs for distribution kernels and some of them<br>
includes patches for each distribution kernel. =A0For RHEL5.2,<br>
<br>
<a href=3D"http://www.nilfs.org/pub/centos/5/SRPMS/nilfs-kmod-2.0.8-1.src.r=
pm" target=3D"_blank">http://www.nilfs.org/pub/centos/5/SRPMS/nilfs-kmod-2.=
0.8-1.src.rpm</a><br>
<br>
can be used. =A0You can build kernel modules with the `rpmbuild&#39;<br>
command, and can extract custom patch from it.<br>
<br>
Regards,<br>
<font color=3D"#888888"><br>
Seiji Kihara<br>
NILFS Team, NTT Labs.<br>
_______________________________________________<br>
users mailing list<br>
<a href=3D"mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org">users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org</a><br>
<a href=3D"https://www.nilfs.org/mailman/listinfo/users" target=3D"_blank">=
https://www.nilfs.org/mailman/listinfo/users</a><br>
</font></blockquote></div><br></div>

--001636c5b3877b56e2046426de86--

--===============1850236002==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1850236002==--
