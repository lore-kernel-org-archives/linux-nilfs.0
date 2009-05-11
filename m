From: Milos Jana <milosdsax-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Can't mount nilfs - error searching super root.
Date: Mon, 11 May 2009 17:32:48 +0200
Message-ID: <3313c4ab0905110832r6ca78e18h570a6f89d6078be6@mail.gmail.com>
References: <3313c4ab0902110709v1e9783fcm8f3dad6507f40347@mail.gmail.com>
	<20090212.143408.130857730.ryusuke@osrg.net>
	<3313c4ab0904220618r22b62e7qa8b239ccbcf02270@mail.gmail.com>
	<20090422.234455.05227091.ryusuke@osrg.net>
	<3313c4ab0905100750p503664acl3b44d043db3d23ae@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1549693844=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <3313c4ab0905100750p503664acl3b44d043db3d23ae-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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

--===============1549693844==
Content-Type: multipart/alternative; boundary=0015174c0fa8d4b7de0469a4b0cf

--0015174c0fa8d4b7de0469a4b0cf
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

The first patch modifies the file /fs/nilfs2/ioctl.c, while NILFS 2.0.12 an=
d
current git version have this file located under the path /fs/ioctl.c.
Anyway, I have replaced all strings "/fs/nilfs/" with "/fs/", which allowed
me to apply the first patch, but the second one and compilation failed:

$ patch -p1 < patch1.patch
patching file fs/ioctl.c
Hunk #6 succeeded at 572 (offset -2 lines).
Hunk #7 succeeded at 606 (offset -2 lines).

$ patch -p1 < patch2.patch
patching file fs/ioctl.c
Hunk #1 FAILED at 25.
Hunk #5 FAILED at 432.
Hunk #6 succeeded at 448 (offset -2 lines).
Hunk #7 succeeded at 469 (offset -2 lines).
Hunk #8 succeeded at 478 (offset -2 lines).
Hunk #9 succeeded at 486 (offset -2 lines).
Hunk #10 succeeded at 506 (offset -2 lines).
2 out of 10 hunks FAILED -- saving rejects to file fs/ioctl.c.rej
patching file fs/nilfs.h
Hunk #1 succeeded at 245 (offset 9 lines).
patching file fs/segment.c
Hunk #1 succeeded at 2789 (offset 200 lines).
Hunk #2 succeeded at 2807 (offset 200 lines).
patching file fs/segment.h


$ make -j2
/home/user/temp/nilfs-2.0.12/fs/ioctl.c:434: error: conflicting types for
=91nilfs_ioctl_mark_blocks_dirty=92
/home/user/temp/nilfs-2.0.12/fs/ioctl.c:394: error: previous definition of
=91nilfs_ioctl_mark_blocks_dirty=92 was here
/home/user/temp/nilfs-2.0.12/fs/ioctl.c: In function
=91nilfs_ioctl_mark_blocks_dirty=92:
/home/user/temp/nilfs-2.0.12/fs/ioctl.c:439: error:
=91nilfs_ioctl_do_mark_blocks_dirty=92 undeclared (first use in this functi=
on)
/home/user/temp/nilfs-2.0.12/fs/ioctl.c:439: error: (Each undeclared
identifier is reported only once
/home/user/temp/nilfs-2.0.12/fs/ioctl.c:439: error: for each function it
appears in.)
/home/user/temp/nilfs-2.0.12/fs/ioctl.c: In function
=91nilfs_ioctl_prepare_clean_segments=92:
/home/user/temp/nilfs-2.0.12/fs/ioctl.c:488: warning: passing argument 3 of
=91nilfs_ioctl_mark_blocks_dirty=92 makes integer from pointer without a ca=
st
/home/user/temp/nilfs-2.0.12/fs/ioctl.c:496: error: implicit declaration of
function =91nilfs_ioctl_free_segments=92
/home/user/temp/nilfs-2.0.12/fs/ioctl.c: In function
=91nilfs_ioctl_clean_segments=92:
/home/user/temp/nilfs-2.0.12/fs/ioctl.c:544: error: implicit declaration of
function =91memdup_user=92
/home/user/temp/nilfs-2.0.12/fs/ioctl.c:545: warning: assignment makes
pointer from integer without a cast
make[3]: *** [/home/user/temp/nilfs-2.0.12/fs/ioctl.o] Error 1
make[2]: *** [_module_/home/user/temp/nilfs-2.0.12/fs] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.27-10-generic'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/user/temp/nilfs-2.0.12/fs'
make: *** [fs] Error 2

--0015174c0fa8d4b7de0469a4b0cf
Content-Type: text/html; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

The first patch modifies the file /fs/nilfs2/ioctl.c, while NILFS 2.0.12 an=
d current git version have this file located under the path /fs/ioctl.c. An=
yway, I have replaced all strings &quot;/fs/nilfs/&quot; with &quot;/fs/&qu=
ot;, which allowed me to apply the first patch, but the second one and comp=
ilation failed: <br>
<br>$ patch -p1 &lt; patch1.patch<br>patching file fs/ioctl.c<br>Hunk #6 su=
cceeded at 572 (offset -2 lines).<br>Hunk #7 succeeded at 606 (offset -2 li=
nes).<br><br>$ patch -p1 &lt; patch2.patch<br>patching file fs/ioctl.c<br>
Hunk #1 FAILED at 25.<br>Hunk #5 FAILED at 432.<br>Hunk #6 succeeded at 448=
 (offset -2 lines).<br>Hunk #7 succeeded at 469 (offset -2 lines).<br>Hunk =
#8 succeeded at 478 (offset -2 lines).<br>Hunk #9 succeeded at 486 (offset =
-2 lines).<br>
Hunk #10 succeeded at 506 (offset -2 lines).<br>2 out of 10 hunks FAILED --=
 saving rejects to file fs/ioctl.c.rej<br>patching file fs/nilfs.h<br>Hunk =
#1 succeeded at 245 (offset 9 lines).<br>patching file fs/segment.c<br>
Hunk #1 succeeded at 2789 (offset 200 lines).<br>Hunk #2 succeeded at 2807 =
(offset 200 lines).<br>patching file fs/segment.h<br><br><br>$ make -j2 <br=
>/home/user/temp/nilfs-2.0.12/fs/ioctl.c:434: error: conflicting types for =
=91nilfs_ioctl_mark_blocks_dirty=92<br>
/home/user/temp/nilfs-2.0.12/fs/ioctl.c:394: error: previous definition of =
=91nilfs_ioctl_mark_blocks_dirty=92 was here<br>/home/user/temp/nilfs-2.0.1=
2/fs/ioctl.c: In function =91nilfs_ioctl_mark_blocks_dirty=92:<br>/home/use=
r/temp/nilfs-2.0.12/fs/ioctl.c:439: error: =91nilfs_ioctl_do_mark_blocks_di=
rty=92 undeclared (first use in this function)<br>
/home/user/temp/nilfs-2.0.12/fs/ioctl.c:439: error: (Each undeclared identi=
fier is reported only once<br>/home/user/temp/nilfs-2.0.12/fs/ioctl.c:439: =
error: for each function it appears in.)<br>/home/user/temp/nilfs-2.0.12/fs=
/ioctl.c: In function =91nilfs_ioctl_prepare_clean_segments=92:<br>
/home/user/temp/nilfs-2.0.12/fs/ioctl.c:488: warning: passing argument 3 of=
 =91nilfs_ioctl_mark_blocks_dirty=92 makes integer from pointer without a c=
ast<br>/home/user/temp/nilfs-2.0.12/fs/ioctl.c:496: error: implicit declara=
tion of function =91nilfs_ioctl_free_segments=92<br>
/home/user/temp/nilfs-2.0.12/fs/ioctl.c: In function =91nilfs_ioctl_clean_s=
egments=92:<br>/home/user/temp/nilfs-2.0.12/fs/ioctl.c:544: error: implicit=
 declaration of function =91memdup_user=92<br>/home/user/temp/nilfs-2.0.12/=
fs/ioctl.c:545: warning: assignment makes pointer from integer without a ca=
st<br>
make[3]: *** [/home/user/temp/nilfs-2.0.12/fs/ioctl.o] Error 1<br>make[2]: =
*** [_module_/home/user/temp/nilfs-2.0.12/fs] Error 2<br>make[2]: Leaving d=
irectory `/usr/src/linux-headers-2.6.27-10-generic&#39;<br>make[1]: *** [de=
fault] Error 2<br>
make[1]: Leaving directory `/home/user/temp/nilfs-2.0.12/fs&#39;<br>make: *=
** [fs] Error 2<br>

--0015174c0fa8d4b7de0469a4b0cf--

--===============1549693844==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1549693844==--
