From: Assaf Weizman <assaf.weizman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: troubles installing the new Nilfs2 - 2.0.8 version
Date: Sun, 1 Mar 2009 14:39:14 +0200
Message-ID: <63c84f240903010439k1c99a6dap2775a100ba16e0e2@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1813743556=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

--===============1813743556==
Content-Type: multipart/alternative; boundary=001636c5a9bd58cdef04640dfd29

--001636c5a9bd58cdef04640dfd29
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello,
I'm asking for your help.
I tried to uninstall the old 2.0.7 version and install the 2.0.8 one, but
all these errors keep popping up:

[root@asaftest new2.0.8]# cd nilfs-2.0.8
[root@asaftest nilfs-2.0.8]# make
make -C fs
make[1]: Entering directory `/home/assafw/nilfs/new2.0.8/nilfs-2.0.8/fs'
make -C /lib/modules/2.6.18-53.1.19.el5/build
SUBDIRS=3D/home/assafw/nilfs/new2.0.8/nilfs-2.0.8/fs
BUILD_DIR=3D/home/assafw/nilfs/new2.0.8/nilfs-2.0.8/fs modules
make[2]: Entering directory `/usr/src/kernels/2.6.18-53.1.19.el5-i686'
  CC [M]  /home/assafw/nilfs/new2.0.8/nilfs-2.0.8/fs/inode.o
In file included from /home/assafw/nilfs/new2.0.8/nilfs-2.0.8/fs/nilfs.h:31=
,
                 from /home/assafw/nilfs/new2.0.8/nilfs-2.0.8/fs/inode.c:28=
:
/home/assafw/nilfs/new2.0.8/nilfs-2.0.8/fs/kern_feature.h:307: error:
redefinition of =D7=92=E2=82=AC=CB=9Cinc_nlink=D7=92=E2=82=AC=E2=84=A2
include/linux/fs.h:1203: error: previous definition of =D7=92=E2=82=AC=CB=
=9Cinc_nlink=D7=92=E2=82=AC=E2=84=A2 was
here
In file included from /home/assafw/nilfs/new2.0.8/nilfs-2.0.8/fs/inode.c:31=
:
/home/assafw/nilfs/new2.0.8/nilfs-2.0.8/fs/mdt.h: In function
=D7=92=E2=82=AC=CB=9CNILFS_MDT=D7=92=E2=82=AC=E2=84=A2:
/home/assafw/nilfs/new2.0.8/nilfs-2.0.8/fs/mdt.h:57: error: =D7=92=E2=82=AC=
=CB=9Cconst struct
inode=D7=92=E2=82=AC=E2=84=A2 has no member named =D7=92=E2=82=AC=CB=9Cu=D7=
=92=E2=82=AC=E2=84=A2
/home/assafw/nilfs/new2.0.8/nilfs-2.0.8/fs/inode.c: In function
=D7=92=E2=82=AC=CB=9Cnilfs_new_inode=D7=92=E2=82=AC=E2=84=A2:
/home/assafw/nilfs/new2.0.8/nilfs-2.0.8/fs/inode.c:355: error: =D7=92=E2=82=
=AC=CB=9Cstruct
inode=D7=92=E2=82=AC=E2=84=A2 has no member named =D7=92=E2=82=AC=CB=9Ci_bl=
ksize=D7=92=E2=82=AC=E2=84=A2
/home/assafw/nilfs/new2.0.8/nilfs-2.0.8/fs/inode.c: In function
=D7=92=E2=82=AC=CB=9Cnilfs_read_inode_common=D7=92=E2=82=AC=E2=84=A2:
/home/assafw/nilfs/new2.0.8/nilfs-2.0.8/fs/inode.c:476: error: =D7=92=E2=82=
=AC=CB=9Cstruct
inode=D7=92=E2=82=AC=E2=84=A2 has no member named =D7=92=E2=82=AC=CB=9Ci_bl=
ksize=D7=92=E2=82=AC=E2=84=A2
make[3]: *** [/home/assafw/nilfs/new2.0.8/nilfs-2.0.8/fs/inode.o] Error 1
make[2]: *** [_module_/home/assafw/nilfs/new2.0.8/nilfs-2.0.8/fs] Error 2
make[2]: Leaving directory `/usr/src/kernels/2.6.18-53.1.19.el5-i686'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/assafw/nilfs/new2.0.8/nilfs-2.0.8/fs'
make: *** [fs] Error 2


anyone have an idea?

--001636c5a9bd58cdef04640dfd29
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello,<br>I&#39;m asking for your help.<br>I tried to unin=
stall the old 2.0.7 version and install the 2.0.8 one, but all these errors=
 keep popping up:<br><br>[root@asaftest new2.0.8]# cd nilfs-2.0.8<br>[root@=
asaftest nilfs-2.0.8]# make<br>
make -C fs <br>make[1]: Entering directory `/home/assafw/nilfs/new2.0.8/nil=
fs-2.0.8/fs&#39;<br>make -C /lib/modules/2.6.18-53.1.19.el5/build SUBDIRS=
=3D/home/assafw/nilfs/new2.0.8/nilfs-2.0.8/fs BUILD_DIR=3D/home/assafw/nilf=
s/new2.0.8/nilfs-2.0.8/fs modules<br>
make[2]: Entering directory `/usr/src/kernels/2.6.18-53.1.19.el5-i686&#39;<=
br>=C2=A0 CC [M]=C2=A0 /home/assafw/nilfs/new2.0.8/nilfs-2.0.8/fs/inode.o<b=
r>In file included from /home/assafw/nilfs/new2.0.8/nilfs-2.0.8/fs/nilfs.h:=
31,<br>
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 from /home/assafw/nilfs/new2.0.8/nilfs-2.0.8/fs/inode=
.c:28:<br>/home/assafw/nilfs/new2.0.8/nilfs-2.0.8/fs/kern_feature.h:307: er=
ror: redefinition of =D7=92=E2=82=AC=CB=9Cinc_nlink=D7=92=E2=82=AC=E2=84=A2=
<br>include/linux/fs.h:1203: error: previous definition of =D7=92=E2=82=AC=
=CB=9Cinc_nlink=D7=92=E2=82=AC=E2=84=A2 was here<br>
In file included from /home/assafw/nilfs/new2.0.8/nilfs-2.0.8/fs/inode.c:31=
:<br>/home/assafw/nilfs/new2.0.8/nilfs-2.0.8/fs/mdt.h: In function =D7=92=
=E2=82=AC=CB=9CNILFS_MDT=D7=92=E2=82=AC=E2=84=A2:<br>/home/assafw/nilfs/new=
2.0.8/nilfs-2.0.8/fs/mdt.h:57: error: =D7=92=E2=82=AC=CB=9Cconst struct ino=
de=D7=92=E2=82=AC=E2=84=A2 has no member named =D7=92=E2=82=AC=CB=9Cu=D7=92=
=E2=82=AC=E2=84=A2<br>
/home/assafw/nilfs/new2.0.8/nilfs-2.0.8/fs/inode.c: In function =D7=92=E2=
=82=AC=CB=9Cnilfs_new_inode=D7=92=E2=82=AC=E2=84=A2:<br>/home/assafw/nilfs/=
new2.0.8/nilfs-2.0.8/fs/inode.c:355: error: =D7=92=E2=82=AC=CB=9Cstruct ino=
de=D7=92=E2=82=AC=E2=84=A2 has no member named =D7=92=E2=82=AC=CB=9Ci_blksi=
ze=D7=92=E2=82=AC=E2=84=A2<br>/home/assafw/nilfs/new2.0.8/nilfs-2.0.8/fs/in=
ode.c: In function =D7=92=E2=82=AC=CB=9Cnilfs_read_inode_common=D7=92=E2=82=
=AC=E2=84=A2:<br>
/home/assafw/nilfs/new2.0.8/nilfs-2.0.8/fs/inode.c:476: error: =D7=92=E2=82=
=AC=CB=9Cstruct inode=D7=92=E2=82=AC=E2=84=A2 has no member named =D7=92=E2=
=82=AC=CB=9Ci_blksize=D7=92=E2=82=AC=E2=84=A2<br>make[3]: *** [/home/assafw=
/nilfs/new2.0.8/nilfs-2.0.8/fs/inode.o] Error 1<br>make[2]: *** [_module_/h=
ome/assafw/nilfs/new2.0.8/nilfs-2.0.8/fs] Error 2<br>
make[2]: Leaving directory `/usr/src/kernels/2.6.18-53.1.19.el5-i686&#39;<b=
r>make[1]: *** [default] Error 2<br>make[1]: Leaving directory `/home/assaf=
w/nilfs/new2.0.8/nilfs-2.0.8/fs&#39;<br>make: *** [fs] Error 2<br><br><br>
anyone have an idea?<br></div>

--001636c5a9bd58cdef04640dfd29--

--===============1813743556==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1813743556==--
