From: "John Garrison" <jgarrison-mRW4Vj+HBIk@public.gmane.org>
Subject: [SPAM]  NILFS2 Cleaner Explanation Request
Date: Fri, 16 Jan 2009 07:16:06 -0600
Message-ID: <000401c977dc$97465850$c5d308f0$@edu>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0174882854=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-Language: en-us
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

This is a multipart message in MIME format.

--===============0174882854==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0005_01C977AA.4CABE850"
Content-Language: en-us

This is a multipart message in MIME format.

------=_NextPart_000_0005_01C977AA.4CABE850
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Could you provide an explanation of the cleanerd's algorithm and method in
cleaning the file system.  What all does it do during a pass, what kind of
complexity is the operation, does it generally follow the cleaner suggested
in the original SPRITE LFS paper (where the write cost on a cleaning
operation is 2/(1-u) where u is the utilization of segments), etc.  The
reason I ask is that in my research, we have done some work on page cache
algorithms to improve the cleaning in a log structured file system.  NILFS2
seems to work quite well in our preliminary tests with Flash SSDs (as one
would expect), but before we move forward to actual implementation of our
page cache ideas, it would be good to understand how the NILFS2 cleaner
works and how we might interact with it.  I have done some digging in the
code, but I think a relatively high level explanation of the strategy and
motivation behind the design choices would be very helpful in understanding
exactly what is going on and how our algorithms might interact with it.
Thanks in advance.

 

John Garrison


------=_NextPart_000_0005_01C977AA.4CABE850
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" =
xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 12 (filtered medium)">
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;}
@page Section1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.Section1
	{page:Section1;}
-->
</style>
<!--[if gte mso 9]><xml>
 <o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
 <o:shapelayout v:ext=3D"edit">
  <o:idmap v:ext=3D"edit" data=3D"1" />
 </o:shapelayout></xml><![endif]-->
</head>

<body lang=3DEN-US link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal>Could you provide an explanation of the cleanerd's =
algorithm
and method in cleaning the file system. &nbsp;What all does it do during =
a
pass, what kind of complexity is the operation, does it generally follow =
the
cleaner suggested in the original SPRITE LFS paper (where the write cost =
on a
cleaning operation is 2/(1-u) where u is the utilization of segments), =
etc.
&nbsp;The reason I ask is that in my research, we have done some work on =
page
cache algorithms to improve the cleaning in a log structured file =
system.
&nbsp;NILFS2 seems to work quite well in our preliminary tests with =
Flash SSDs
(as one would expect), but before we move forward to actual =
implementation of
our page cache ideas, it would be good to understand how the NILFS2 =
cleaner
works and how we might interact with it. &nbsp;I have done some digging =
in the
code, but I think a relatively high level explanation of the strategy =
and
motivation behind the design choices would be very helpful in =
understanding
exactly what is going on and how our algorithms might interact with =
it.&nbsp;
Thanks in advance.<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>John Garrison<o:p></o:p></p>

</div>

</body>

</html>

------=_NextPart_000_0005_01C977AA.4CABE850--


--===============0174882854==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============0174882854==--

