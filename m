From: Milos Jana <milosdsax-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Can't mount nilfs - error searching super root.
Date: Sat, 24 Jan 2009 01:13:41 +0100
Message-ID: <3313c4ab0901231613g2d82ea3at13e524dfba28df4@mail.gmail.com>
References: <55b53420901160222g3716f81cy229069f7af717283@mail.gmail.com>
	<20090116.200749.101561788.ryusuke@osrg.net>
	<55b53420901160316h2b1e70e3xc420321973ce99b4@mail.gmail.com>
	<20090116.222255.131926946.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1464581397=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090116.222255.131926946.ryusuke-sG5X7nlA6pw@public.gmane.org>
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

--===============1464581397==
Content-Type: multipart/alternative; boundary=00151749f7cebdd60804612f60fa

--00151749f7cebdd60804612f60fa
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi again,

Looks like I'm unable to mount this drive again. It mounted successfully
several times after following your previous posts, but yesterday the problem
came back. I'm sure that I have been mounting/unmounting my pendrive
properly. This time fsck0.nilfs2 doesn't help - it hangs with "Searching the
latest checkpoint." message (see below).

user@laptop:~$ sudo mount /media/pendrive/
mount.nilfs2: Error while mounting /dev/sdb on /media/pendrive: Invalid
argument

user@laptop:~$ dmesg
...
[22429.446924] NILFS warning: Segment magic number invalid
[22429.446932] NILFS: error searching super root.

user@laptop:~/prog/sources/nilfs-utils-2.0.6$ sudo fsck0.nilfs2 /dev/sdb #
Nilfs-tools with first patch applied
Super-block:
  revision = 2.0, checksum = OK
  blocksize = 4096
  write time = 2009-01-22 23:40:19
  indicated partial segment: blocknr = 1966080
  segnum = 960, seq = 18266, cno=10169

Clean FS.

user@laptop:~/prog/sources/nilfs-utils-2.0.6$ sudo fsck0.nilfs2 /dev/sdb #
Nilfs-tools with additional patch applied
Super-block:
  revision = 2.0, checksum = OK
  blocksize = 4096
  write time = 2009-01-22 23:40:19
  indicated partial segment: blocknr = 1966080
  segnum = 960, seq = 18266, cno=10169

empty or bad segment: segnum = 960, blocknr = 1966080
The latest segment is lost. Trying rollback recovery..
.
Searching the latest checkpoint.    # here it hanged for like 10 minutes
until I killed it

--00151749f7cebdd60804612f60fa
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi again,<br><br>Looks like I&#39;m unable to mount this drive again. It mo=
unted successfully several times after following your previous posts, but y=
esterday the problem came back. I&#39;m sure that I have been mounting/unmo=
unting my pendrive properly. This time fsck0.nilfs2 doesn&#39;t help - it h=
angs with &quot;Searching the latest checkpoint.&quot; message (see below).=
<br>
<br>user@laptop:~$ sudo mount /media/pendrive/<br>mount.nilfs2: Error while=
 mounting /dev/sdb on /media/pendrive: Invalid argument<br><br>user@laptop:=
~$ dmesg<br>...<br>[22429.446924] NILFS warning: Segment magic number inval=
id<br>
[22429.446932] NILFS: error searching super root.<br><br>user@laptop:~/prog=
/sources/nilfs-utils-2.0.6$ sudo fsck0.nilfs2 /dev/sdb # Nilfs-tools with f=
irst patch applied<br>Super-block:<br>&nbsp;   revision =3D 2.0, checksum =
=3D OK<br>
&nbsp;   blocksize =3D 4096<br>&nbsp;   write time =3D 2009-01-22 23:40:19<=
br>&nbsp;   indicated partial segment: blocknr =3D 1966080<br>&nbsp;       =
segnum =3D 960, seq =3D 18266, cno=3D10169<br><br>Clean FS.<br><br>user@lap=
top:~/prog/sources/nilfs-utils-2.0.6$ sudo fsck0.nilfs2 /dev/sdb    # Nilfs=
-tools with additional patch applied<br>
Super-block:<br>&nbsp;   revision =3D 2.0, checksum =3D OK<br>&nbsp;   bloc=
ksize =3D 4096<br>&nbsp;   write time =3D 2009-01-22 23:40:19<br>&nbsp;   i=
ndicated partial segment: blocknr =3D 1966080<br>&nbsp;       segnum =3D 96=
0, seq =3D 18266, cno=3D10169<br><br>
empty or bad segment: segnum =3D 960, blocknr =3D 1966080<br>The latest seg=
ment is lost. Trying rollback recovery..<br>.<br>Searching the latest check=
point. &nbsp; &nbsp;# here it hanged for like 10 minutes until I killed it<=
br><br><br>

--00151749f7cebdd60804612f60fa--

--===============1464581397==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1464581397==--
