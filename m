From: Quentin RAMEAU <quinq.ml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Can't start nilfs_cleanerd on root fs.
Date: Sat, 4 Jul 2009 16:43:31 +0200
Message-ID: <21e999b60907040743l3940f2a2y1a7b0e56dfe73d73@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0849362186=="
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

--===============0849362186==
Content-Type: multipart/alternative; boundary=001636c5c242f8cf35046de24b90

--001636c5c242f8cf35046de24b90
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello,

I formated my root fs with nilfs a few days ago, but I can't start cleanerd
for that fs.
I have another nilfs on that system that seems to work correctly.

Maybe I am doing something wrong, at least, there something that could be
done, here is some info about it:

$ uname -r
2.6.30-zen1

$ mount -t nilfs2
/dev/hda3 on / type nilfs2 (rw,gcpid=1510)
/dev/hda4 on /DATA type nilfs2 (rw,gcpid=1675)

$ ps -ef | grep nilfs
root      1675     1  0 12:56 ?        00:00:02 /sbin/nilfs_cleanerd -n
/dev/hda4 /DATA

$ nilfs_cleanerd /dev/hda3 && tail /var/log/everything/current | grep nilfs
Jul 04 15:46:29 [nilfs_cleanerd] start
Jul 04 15:46:29 [nilfs_cleanerd] cannot open nilfs on /dev/hda3: Invalid
argument
Jul 04 15:46:29 [nilfs_cleanerd] cannot create cleanerd on /dev/hda3:
Invalid argument
Jul 04 15:46:29 [nilfs_cleanerd] shutdown

I formated both FSs with nilfs-utils 2.0.12, but I am now using 2.0.13
(problem occured with both versions).
I can provide an more info that is necessary.

--001636c5c242f8cf35046de24b90
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello,<br><br>I formated my root fs with nilfs a few days ago, but I can&#3=
9;t start cleanerd for that fs.<br>I have another nilfs on that system that=
 seems to work correctly.<br><br>Maybe I am doing something wrong, at least=
, there something that could be done, here is some info about it:<br>
<br>$ uname -r<br>2.6.30-zen1<br><br>$ mount -t nilfs2<br>/dev/hda3 on / ty=
pe nilfs2 (rw,gcpid=3D1510)<br>/dev/hda4 on /DATA type nilfs2 (rw,gcpid=3D1=
675)<br><br>$ ps -ef | grep nilfs<br>root=A0=A0=A0=A0=A0 1675=A0=A0=A0=A0 1=
=A0 0 12:56 ?=A0=A0=A0=A0=A0=A0=A0 00:00:02 /sbin/nilfs_cleanerd -n /dev/hd=
a4 /DATA<br>
<br>$ nilfs_cleanerd /dev/hda3 &amp;&amp; tail /var/log/everything/current =
| grep nilfs<br>Jul 04 15:46:29 [nilfs_cleanerd] start<br>Jul 04 15:46:29 [=
nilfs_cleanerd] cannot open nilfs on /dev/hda3: Invalid argument<br>Jul 04 =
15:46:29 [nilfs_cleanerd] cannot create cleanerd on /dev/hda3: Invalid argu=
ment<br>
Jul 04 15:46:29 [nilfs_cleanerd] shutdown<br><br>I formated both FSs with n=
ilfs-utils 2.0.12, but I am now using 2.0.13 (problem occured with both ver=
sions).<br>I can provide an more info that is necessary.<br>

--001636c5c242f8cf35046de24b90--

--===============0849362186==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============0849362186==--
