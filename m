From: Milos Jana <milosdsax-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Can't mount nilfs - error searching super root.
Date: Wed, 11 Feb 2009 16:20:15 +0100
Message-ID: <3313c4ab0902110720j7fddb938y59249197f1b3eeb8@mail.gmail.com>
References: <55b53420901160316h2b1e70e3xc420321973ce99b4@mail.gmail.com>
	<20090116.222255.131926946.ryusuke@osrg.net>
	<3313c4ab0901231613g2d82ea3at13e524dfba28df4@mail.gmail.com>
	<20090130.210323.88475416.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0246174308=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090130.210323.88475416.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>, users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

--===============0246174308==
Content-Type: multipart/alternative; boundary=0015174c11a60b71420462a624a1

--0015174c11a60b71420462a624a1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

I forgot to mention one important thing - there isn't really hang problem -
I just had to wait some long time until fsck0.nilfs returned "cannont read
block" error, it took so long probably because pendrive size is quite big
(32GB). So here is this is the full output:
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

Searching the latest checkpoint.
fsck0.nilfs2: cannot read block (blocknr = 7831552)

--0015174c11a60b71420462a624a1
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div class=3D"gmail_quote">I forgot to mention one important thing - there =
isn&#39;t really hang problem - I just had to wait some long time until fsc=
k0.nilfs returned &quot;cannont read block&quot; error, it took so long pro=
bably because pendrive size is quite big (32GB). So here is this is the ful=
l output:</div>
<div class=3D"gmail_quote"></div>
<div class=3D"gmail_quote">user@laptop:~/prog/sources/nilfs-utils-2.0.6$ su=
do fsck0.nilfs2 /dev/sdb # Nilfs-tools with additional patch applied<br><br=
>Super-block:<br>&nbsp; revision =3D 2.0, checksum =3D OK<br>
&nbsp; blocksize =3D 4096<br>&nbsp; write time =3D 2009-01-22 23:40:19<br>&=
nbsp; indicated partial segment: blocknr =3D 1966080<br>&nbsp; segnum =3D 9=
60, seq =3D 18266, cno=3D10169<br><br>empty or bad segment: segnum =3D 960,=
 blocknr =3D 1966080<br><br>The latest segment is lost. Trying rollback rec=
overy..<br>

<br>Searching the latest checkpoint. &nbsp;<br></div><div class=3D"gmail_qu=
ote">fsck0.nilfs2: cannot read block (blocknr =3D 7831552)</div><div class=
=3D"gmail_quote"><br>
</div><br>

--0015174c11a60b71420462a624a1--

--===============0246174308==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============0246174308==--
