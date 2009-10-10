From: Jan de Kruyf <jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: cleanerd
Date: Sun, 11 Oct 2009 00:18:10 +0200
Message-ID: <ee5afd760910101518u4a85fd0fn6e5539a327b2a876@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1294978510=="
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

--===============1294978510==
Content-Type: multipart/alternative; boundary=001485eb04fd6750a504759c1235

--001485eb04fd6750a504759c1235
Content-Type: text/plain; charset=ISO-8859-1

Hallo,
Here is an interesting disaster with nilfs2. Lightening went down the
chimney on the other side of the wall. Computer was off, but plugged in.
Motherboard died.

So I now try to fix partitions. at the moment it is /var. /home will come
later.

Here is the problem:
/var data is readable but the cleanerd has become confused after the
disaster and has filled up the partition

partition size 5.8 Gig, data size 2.56 Gig, but usage is now 100%
Normal mounting:
cleanerd cannot be stopped anymore, neither with TERM or KILL signals.

lscp shows only cleaner checkpoints now.

When mounting without the cleanerd running there are no dmesg's of interest
on mounting or on execution of any command

To rescue the partition do I copy the data to another disk and reformat? Or
is there a simpler solution?


Best Regard,

Jan de Kruyf.
------------------

ps.
 running debian lenny, kernel 2.6.26-1-686

branch 'master' of http://git.nilfs.org/nilfs2-utils  dd. 11 july 2009
branch 'master' of http://git.nilfs.org/nilfs2-module  dd. 11 july 2009
tag 'v2.0.15'

and here is the superblock of the partition:


00000000: 0200 0000 0000 3434 0001 0000 8422 95d1  ......44....."..
00000010: 80b7 90e7 0200 0000 ca02 0000 0000 0000  ................
00000020: 00b4 6665 0100 0000 0100 0000 0000 0000  ..fe............
00000030: 0008 0000 0500 0000 e1e6 1400 0000 0000  ................
00000040: d69f 0d00 0000 0000 c181 0900 0000 0000  ................
00000050: 0000 0000 0000 0000 4815 5a4a 0000 0000  ........H.ZJ....
00000060: 3713 d04a 0000 0000 3713 d04a 0000 0000  7..J....7..J....
00000070: 4000 3200 0000 0100 4815 5a4a 0000 0000  @.2.....H.ZJ....
00000080: 004e ed00 0000 0000 0000 0000 0b00 0000  .N..............
00000090: 8000 2000 c000 1000 470b 1351 09a6 4016  .. .....G..Q..@.
000000a0: 9397 70f2 82f5 d61b 7661 7200 0000 0000  ..p.....var.....
000000b0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
000000c0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
000000d0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
000000e0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
000000f0: 0000 0000 0000 0000 0000 0000 0000 0000  ................

--001485eb04fd6750a504759c1235
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hallo,<br>Here is an interesting disaster with nilfs2. Lightening went down=
 the chimney on the other side of the wall. Computer was off, but plugged i=
n.<br>Motherboard died.<br><br>So I now try to fix partitions. at the momen=
t it is /var. /home will come later.<br>
<br>Here is the problem:<br>/var data is readable but the cleanerd has beco=
me confused after the disaster and has filled up the partition<br><br>parti=
tion size 5.8 Gig, data size 2.56 Gig, but usage is now 100%<br>Normal moun=
ting:<br>
cleanerd cannot be stopped anymore, neither with TERM or KILL signals.<br><=
br>lscp shows only cleaner checkpoints now.<br><br>When mounting without th=
e cleanerd running there are no dmesg&#39;s of interest on mounting or on e=
xecution of any command<br>
<br>To rescue the partition do I copy the data to another disk and reformat=
? Or is there a simpler solution?<br><br><br>Best Regard,<br><br>Jan de Kru=
yf.<br>------------------<br><br>ps.<br>=A0running debian lenny, kernel 2.6=
.26-1-686<br>
<br>branch &#39;master&#39; of <a href=3D"http://git.nilfs.org/nilfs2-utils=
">http://git.nilfs.org/nilfs2-utils</a>=A0 dd. 11 july 2009<br>branch &#39;=
master&#39; of <a href=3D"http://git.nilfs.org/nilfs2-module">http://git.ni=
lfs.org/nilfs2-module</a>=A0 dd. 11 july 2009=A0=A0 tag &#39;v2.0.15&#39;<b=
r>
<br>and here is the superblock of the partition:<br>
<br>
<br>
00000000: 0200 0000 0000 3434 0001 0000 8422 95d1=A0 ......44.....&quot;..<=
br>
00000010: 80b7 90e7 0200 0000 ca02 0000 0000 0000=A0 ................<br>
00000020: 00b4 6665 0100 0000 0100 0000 0000 0000=A0 ..fe............<br>
00000030: 0008 0000 0500 0000 e1e6 1400 0000 0000=A0 ................<br>
00000040: d69f 0d00 0000 0000 c181 0900 0000 0000=A0 ................<br>
00000050: 0000 0000 0000 0000 4815 5a4a 0000 0000=A0 ........H.ZJ....<br>
00000060: 3713 d04a 0000 0000 3713 d04a 0000 0000=A0 7..J....7..J....<br>
00000070: 4000 3200 0000 0100 4815 5a4a 0000 0000=A0 @.2.....H.ZJ....<br>
00000080: 004e ed00 0000 0000 0000 0000 0b00 0000=A0 .N..............<br>
00000090: 8000 2000 c000 1000 470b 1351 09a6 4016=A0 .. .....G..Q..@.<br>
000000a0: 9397 70f2 82f5 d61b 7661 7200 0000 0000=A0 ..p.....var.....<br>
000000b0: 0000 0000 0000 0000 0000 0000 0000 0000=A0 ................<br>
000000c0: 0000 0000 0000 0000 0000 0000 0000 0000=A0 ................<br>
000000d0: 0000 0000 0000 0000 0000 0000 0000 0000=A0 ................<br>
000000e0: 0000 0000 0000 0000 0000 0000 0000 0000=A0 ................<br>
000000f0: 0000 0000 0000 0000 0000 0000 0000 0000=A0 ................<br><b=
r><br>

--001485eb04fd6750a504759c1235--

--===============1294978510==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1294978510==--
