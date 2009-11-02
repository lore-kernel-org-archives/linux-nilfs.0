From: Jan de Kruyf <jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: urgent help need! disk partition info lost
Date: Mon, 2 Nov 2009 21:38:24 +0200
Message-ID: <ee5afd760911021138p25f34ca4gcb66547812cb858e@mail.gmail.com>
References: <856033f20911021106u771f823dkb48395958ad83a37@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0228907966=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <856033f20911021106u771f823dkb48395958ad83a37-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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

--===============0228907966==
Content-Type: multipart/alternative; boundary=001485eba0b556672d04776885c2

--001485eba0b556672d04776885c2
Content-Type: text/plain; charset=ISO-8859-1

Did you first format this card with fdisk?
did you give it the exact same info this time around?

Can you read /dev/'sdcard' ? (sdcard being the device in the dev directory
where the card lives)

If yes can you run hexedit -s /dev/sdcard1  in a terminal as root?
and go to address 0400 - 04B0 to see if nilfs still exists?

be very careful no to save any data in hexedit, it will definitely and
finally
destoy your data.

0400 looks vagely like this:
00000400   02 00 00 00 00 00 34 34  00 01 00 00 D3 56 F0 B9
......44.....V..
00000410   39 BF D9 73 02 00 00 00  CA 02 00 00 00 00 00 00
9..s............
00000420   00 B4 66 65 01 00 00 00  01 00 00 00 00 00 00 00
..fe............
00000430   00 08 00 00 05 00 00 00  01 00 00 00 00 00 00 00
................
00000440   01 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
................
00000450   00 48 16 00 00 00 00 00  73 95 DC 4A 00 00 00 00
.H......s..J....
00000460   00 00 00 00 00 00 00 00  73 95 DC 4A 00 00 00 00
........s..J....
00000470   00 00 32 00 01 00 01 00  73 95 DC 4A 00 00 00 00
..2.....s..J....
00000480   00 4E ED 00 00 00 00 00  00 00 00 00 0B 00 00 00
.N..............
00000490   80 00 20 00 C0 00 10 00  4C 73 DD 3D 01 EC 45 85  ..
.....Ls.=..E.
000004A0   94 28 44 42 3D F6 EF EC  56 61 72 36 34 00 00 00
.(DB=...Var64...
000004B0   00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
................
000004C0   00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
................

the 34 34 in the top line say this is nilfs.


cheers

jan de kruyf




On Mon, Nov 2, 2009 at 9:06 PM, Paul L <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Due to some careless handling of my laptop, the SD card popped out
> when the machine is still running. When I put it back in and reboot
> the machine, it says "partition table error". I then ran fdisk and
> recreated the single partition. Then I can no longer mount the nilfs2
> partition that was on the SD card!
>
> Can any one help to me recover the file system? I believe all data are
> still there, but just some bits and pieces are missing for the mount
> to work. Any help is greatly appreciated!
>
> PS: I've a deadline to meet in 4 hours, not sure if I can get my stuff
> back in time... so help please!
>
> --
> Regards,
> Paul Liu
>
> Yale Haskell Group
> http://www.haskell.org/yale
> _______________________________________________
> users mailing list
> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> https://www.nilfs.org/mailman/listinfo/users
>

--001485eba0b556672d04776885c2
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Did you first format this card with fdisk?<br>did you give it the exact sam=
e info this time around?<br><br>Can you read /dev/&#39;sdcard&#39; ? (sdcar=
d being the device in the dev directory <br>where the card lives)<br><br>
If yes can you run hexedit -s /dev/sdcard1=A0 in a terminal as root?<br>and=
 go to address 0400 - 04B0 to see if nilfs still exists?<br><br>be very car=
eful no to save any data in hexedit, it will definitely and finally <br>des=
toy your data.<br>
<br>0400 looks vagely like this:<br>00000400=A0=A0 02 00 00 00 00 00 34 34=
=A0 00 01 00 00 D3 56 F0 B9=A0 ......44.....V..<br>00000410=A0=A0 39 BF D9 =
73 02 00 00 00=A0 CA 02 00 00 00 00 00 00=A0 9..s............<br>00000420=
=A0=A0 00 B4 66 65 01 00 00 00=A0 01 00 00 00 00 00 00 00=A0 ..fe..........=
..<br>
00000430=A0=A0 00 08 00 00 05 00 00 00=A0 01 00 00 00 00 00 00 00=A0 ......=
..........<br>00000440=A0=A0 01 00 00 00 00 00 00 00=A0 00 00 00 00 00 00 0=
0 00=A0 ................<br>00000450=A0=A0 00 48 16 00 00 00 00 00=A0 73 95=
 DC 4A 00 00 00 00=A0 .H......s..J....<br>
00000460=A0=A0 00 00 00 00 00 00 00 00=A0 73 95 DC 4A 00 00 00 00=A0 ......=
..s..J....<br>00000470=A0=A0 00 00 32 00 01 00 01 00=A0 73 95 DC 4A 00 00 0=
0 00=A0 ..2.....s..J....<br>00000480=A0=A0 00 4E ED 00 00 00 00 00=A0 00 00=
 00 00 0B 00 00 00=A0 .N..............<br>
00000490=A0=A0 80 00 20 00 C0 00 10 00=A0 4C 73 DD 3D 01 EC 45 85=A0 .. ...=
..Ls.=3D..E.<br>000004A0=A0=A0 94 28 44 42 3D F6 EF EC=A0 56 61 72 36 34 00=
 00 00=A0 .(DB=3D...Var64...<br>000004B0=A0=A0 00 00 00 00 00 00 00 00=A0 0=
0 00 00 00 00 00 00 00=A0 ................<br>
000004C0=A0=A0 00 00 00 00 00 00 00 00=A0 00 00 00 00 00 00 00 00=A0 ......=
..........<br><br>the 34 34 in the top line say this is nilfs.<br><br><br>c=
heers<br><br>jan de kruyf<br><br><br><br><br><div class=3D"gmail_quote">On =
Mon, Nov 2, 2009 at 9:06 PM, Paul L <span dir=3D"ltr">&lt;<a href=3D"mailto=
:ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org">ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">Due to some carel=
ess handling of my laptop, the SD card popped out<br>
when the machine is still running. When I put it back in and reboot<br>
the machine, it says &quot;partition table error&quot;. I then ran fdisk an=
d<br>
recreated the single partition. Then I can no longer mount the nilfs2<br>
partition that was on the SD card!<br>
<br>
Can any one help to me recover the file system? I believe all data are<br>
still there, but just some bits and pieces are missing for the mount<br>
to work. Any help is greatly appreciated!<br>
<br>
PS: I&#39;ve a deadline to meet in 4 hours, not sure if I can get my stuff<=
br>
back in time... so help please!<br>
<br>
--<br>
Regards,<br>
Paul Liu<br>
<br>
Yale Haskell Group<br>
<a href=3D"http://www.haskell.org/yale" target=3D"_blank">http://www.haskel=
l.org/yale</a><br>
_______________________________________________<br>
users mailing list<br>
<a href=3D"mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org">users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org</a><br>
<a href=3D"https://www.nilfs.org/mailman/listinfo/users" target=3D"_blank">=
https://www.nilfs.org/mailman/listinfo/users</a><br>
</blockquote></div><br>

--001485eba0b556672d04776885c2--

--===============0228907966==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============0228907966==--
