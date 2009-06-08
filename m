From: "Dunphy, Bill" <WDunphy-/3AnZwnt+WyVkR+q5Y5grQ@public.gmane.org>
Subject: [SPAM]  Write hang on ARM based target
Date: Mon, 8 Jun 2009 09:46:52 -0600
Message-ID: <BAEFA5609CC3AB4BAE1625CAD4C27E5C01900F8D@tdpost.td.tandbergdata.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1551217094=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-class: urn:content-classes:message
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

This is a multi-part message in MIME format.

--===============1551217094==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C9E850.578627C2"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C9E850.578627C2
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Greetings,
=20
I'm attempting to get NILFS up and running on a Marvell DB-88F6281-BP-A
(ARM) and have experienced a consistent hang during data transfer.  This
target board is running a 2.6.22.18 kernel and I've tested it against
NILFS versions 2.0.12, 2.0.14 and the latest git pull (6/4/09).  I've
eliminated the garbage collector and and have enabled full debugging for
log capture.  The failure is not immediate or at a fixed point -
typically in the 1-2GB neighborhood of writing variably sized files.
This same exercise (a simple recursive local copy) works flawlessly on
my host Ubuntu i86 machine as well as on the target with an ext3 file
system.
=20
Is there a specific kernel feature that I might be missing and need to
enable?  A kernel version sensitivity?  Is this log information
something you would be interested in seeing?  If so, how verbose would
you like it or better still, how would you like me to collect it?
=20
Thanks,
=20
William Dunphy
=20

------_=_NextPart_001_01C9E850.578627C2
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii">
<META content=3D"MSHTML 6.00.2900.3527" name=3DGENERATOR></HEAD>
<BODY>
<DIV><FONT face=3DArial size=3D2>
<DIV><SPAN class=3D042094718-05062009><FONT face=3DArial size=3D2><SPAN=20
class=3D586520614-08062009>Greetings,</SPAN></FONT></SPAN></DIV>
<DIV><SPAN class=3D042094718-05062009><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><FONT face=3DArial><FONT size=3D2><SPAN =
class=3D042094718-05062009>I'm attempting=20
to get NILFS up and running on a Marvell DB-88F6281-BP-A&nbsp;<SPAN=20
class=3D586520614-08062009>(ARM) </SPAN>and have experienced =
a&nbsp;<SPAN=20
class=3D249191514-08062009>consistent </SPAN>hang during data =
transfer.<SPAN=20
class=3D586520614-08062009>&nbsp; This target board&nbsp;<SPAN=20
class=3D249191514-08062009>is running </SPAN>a 2.6.22.18 kernel and I've =
tested it=20
against NILFS versions 2.0.12, 2.0.14 and the latest git pull =
(6/4/09).&nbsp;=20
</SPAN></SPAN><SPAN class=3D042094718-05062009><SPAN =
class=3D042094718-05062009>I've=20
eliminated the garbage collector and and have enabled full debugging for =
log=20
capture.&nbsp; The failure is not immediate or at a fixed point - =
typically in=20
the 1-2GB neighborhood of writing variably sized files.&nbsp; =
</SPAN><SPAN=20
class=3D042094718-05062009>This same exercise&nbsp;<SPAN=20
class=3D249191514-08062009>(a simple recursive local copy) </SPAN>works =
flawlessly=20
on my host Ubuntu i86 machine<SPAN class=3D586520614-08062009> as well =
as on the=20
target with an ext3 file =
system.</SPAN></SPAN></SPAN></FONT></FONT></DIV>
<DIV><SPAN class=3D042094718-05062009><FONT face=3DArial><FONT =
size=3D2><SPAN=20
class=3D042094718-05062009><SPAN=20
class=3D586520614-08062009></SPAN></SPAN></FONT></FONT></SPAN>&nbsp;</DIV=
>
<DIV><SPAN class=3D042094718-05062009><FONT face=3DArial size=3D2><SPAN=20
class=3D042094718-05062009><SPAN class=3D586520614-08062009><SPAN=20
class=3D249191514-08062009>Is there a specific kernel feature that I =
might be=20
missing and need to enable?&nbsp; A kernel version sensitivity?&nbsp;=20
</SPAN></SPAN></SPAN></FONT><SPAN class=3D042094718-05062009><FONT =
face=3DArial=20
size=3D2>Is this log information something you would be interested in=20
seeing?&nbsp; If so, how verbose would you like it or better still, how =
would=20
you like me to collect it?</FONT></SPAN></DIV>
<DIV>
<DIV><SPAN class=3D042094718-05062009><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D042094718-05062009><FONT face=3DArial=20
size=3D2>Thanks,</FONT></SPAN></DIV>
<DIV><SPAN class=3D042094718-05062009><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D042094718-05062009><FONT face=3DArial =
size=3D2>William=20
Dunphy</FONT></SPAN></DIV>
<DIV><SPAN=20
class=3D042094718-05062009></SPAN>&nbsp;</DIV></DIV></SPAN></FONT></DIV><=
/BODY></HTML>

------_=_NextPart_001_01C9E850.578627C2--

--===============1551217094==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1551217094==--
