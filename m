From: "TscheiEll" <lucky-joe-Mmb7MZpHnFY@public.gmane.org>
Subject: memory space
Date: Mon, 8 Oct 2007 18:38:16 +0200
Message-ID: <HNEOIAEJHENCDLHKJGHBMEHNDAAA.lucky-joe@gmx.de>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0460135800=="
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

This is a multi-part message in MIME format.

--===============0460135800==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0013_01C809DA.63C2A400"

This is a multi-part message in MIME format.

------=_NextPart_000_0013_01C809DA.63C2A400
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Hi @all,


I am new to this list and i am interested in some more information about
nilfs.
First I am interested in resource requirements needed.
I am planning to use nilfs with a memory block device under user-mode linux
with a 2MB static-ramdisc. So what are the memory-sized I minimal need to
integrate it in my linux and how much space is neede for the jornalling ?

Regards

Joe

------=_NextPart_000_0013_01C809DA.63C2A400
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; =
charset=3Diso-8859-1">
<meta name=3DProgId content=3DWord.Document>
<meta name=3DGenerator content=3D"Microsoft Word 9">
<meta name=3DOriginator content=3D"Microsoft Word 9">
<link rel=3DFile-List href=3D"cid:filelist.xml-/egBJUhh8MVV+duYyMWK9jRmByFHzeGd@public.gmane.org">
<!--[if gte mso 9]><xml>
 <o:OfficeDocumentSettings>
  <o:DoNotRelyOnCSS/>
 </o:OfficeDocumentSettings>
</xml><![endif]--><!--[if gte mso 9]><xml>
 <w:WordDocument>
  <w:View>Normal</w:View>
  <w:Zoom>0</w:Zoom>
  <w:DocumentKind>DocumentEmail</w:DocumentKind>
  <w:HyphenationZone>21</w:HyphenationZone>
  <w:EnvelopeVis/>
 </w:WordDocument>
</xml><![endif]-->
<style>
<!--
 /* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{mso-style-parent:"";
	margin:0cm;
	margin-bottom:.0001pt;
	mso-pagination:widow-orphan;
	font-size:12.0pt;
	font-family:"Times New Roman";
	mso-fareast-font-family:"Times New Roman";}
p.MsoAutoSig, li.MsoAutoSig, div.MsoAutoSig
	{margin:0cm;
	margin-bottom:.0001pt;
	mso-pagination:widow-orphan;
	font-size:12.0pt;
	font-family:"Times New Roman";
	mso-fareast-font-family:"Times New Roman";}
span.EmailFormatvorlage15
	{mso-style-type:personal-compose;
	mso-ansi-font-size:10.0pt;
	mso-ascii-font-family:Arial;
	mso-hansi-font-family:Arial;
	mso-bidi-font-family:Arial;
	color:black;}
@page Section1
	{size:595.3pt 841.9pt;
	margin:70.85pt 70.85pt 2.0cm 70.85pt;
	mso-header-margin:35.4pt;
	mso-footer-margin:35.4pt;
	mso-paper-source:0;}
div.Section1
	{page:Section1;}
-->
</style>
</head>

<body lang=3DDE style=3D'tab-interval:35.4pt'>

<div class=3DSection1>

<p class=3DMsoNormal><span class=3DEmailFormatvorlage15><font size=3D2 =
color=3Dblack
face=3DArial><span =
style=3D'font-size:10.0pt;mso-bidi-font-size:12.0pt;font-family:
Arial'>Hi @all,<o:p></o:p></span></font></span></p>

<p class=3DMsoNormal><span class=3DEmailFormatvorlage15><font size=3D2 =
color=3Dblack
face=3DArial><span =
style=3D'font-size:10.0pt;mso-bidi-font-size:12.0pt;font-family:
Arial'><![if =
!supportEmptyParas]>&nbsp;<![endif]><o:p></o:p></span></font></span></p>

<p class=3DMsoNormal><span class=3DEmailFormatvorlage15><font size=3D2 =
color=3Dblack
face=3DArial><span =
style=3D'font-size:10.0pt;mso-bidi-font-size:12.0pt;font-family:
Arial'><![if =
!supportEmptyParas]>&nbsp;<![endif]><o:p></o:p></span></font></span></p>

<p class=3DMsoNormal><span class=3DEmailFormatvorlage15><font size=3D2 =
color=3Dblack
face=3DArial><span lang=3DEN-US =
style=3D'font-size:10.0pt;mso-bidi-font-size:12.0pt;
font-family:Arial;mso-ansi-language:EN-US'>I am new to this list and i =
am interested
in some more information about =
nilfs.<o:p></o:p></span></font></span></p>

<p class=3DMsoNormal><span class=3DEmailFormatvorlage15><font size=3D2 =
color=3Dblack
face=3DArial><span lang=3DEN-US =
style=3D'font-size:10.0pt;mso-bidi-font-size:12.0pt;
font-family:Arial;mso-ansi-language:EN-US'>First I am interested in =
resource
requirements needed.<o:p></o:p></span></font></span></p>

<p class=3DMsoNormal><span class=3DEmailFormatvorlage15><font size=3D2 =
color=3Dblack
face=3DArial><span lang=3DEN-US =
style=3D'font-size:10.0pt;mso-bidi-font-size:12.0pt;
font-family:Arial;mso-ansi-language:EN-US'>I am planning to use nilfs =
with a
memory block device under user-mode linux with a 2MB static-ramdisc. So =
what
are the memory-sized I minimal need to integrate it in my linux and how =
much
space is neede for the jornalling ?<o:p></o:p></span></font></span></p>

<p class=3DMsoNormal><span class=3DEmailFormatvorlage15><font size=3D2 =
color=3Dblack
face=3DArial><span lang=3DEN-US =
style=3D'font-size:10.0pt;mso-bidi-font-size:12.0pt;
font-family:Arial;mso-ansi-language:EN-US'><![if =
!supportEmptyParas]>&nbsp;<![endif]><o:p></o:p></span></font></span></p>

<p class=3DMsoNormal><span class=3DEmailFormatvorlage15><font size=3D2 =
color=3Dblack
face=3DArial><span lang=3DEN-US =
style=3D'font-size:10.0pt;mso-bidi-font-size:12.0pt;
font-family:Arial;mso-ansi-language:EN-US'>Regards<o:p></o:p></span></fon=
t></span></p>

<p class=3DMsoNormal><span class=3DEmailFormatvorlage15><font size=3D2 =
color=3Dblack
face=3DArial><span lang=3DEN-US =
style=3D'font-size:10.0pt;mso-bidi-font-size:12.0pt;
font-family:Arial;mso-ansi-language:EN-US'><![if =
!supportEmptyParas]>&nbsp;<![endif]><o:p></o:p></span></font></span></p>

<p class=3DMsoNormal><span class=3DEmailFormatvorlage15><font size=3D2 =
color=3Dblack
face=3DArial><span lang=3DEN-US =
style=3D'font-size:10.0pt;mso-bidi-font-size:12.0pt;
font-family:Arial;mso-ansi-language:EN-US'>Joe<o:p></o:p></span></font></=
span></p>

</div>

</body>

</html>

------=_NextPart_000_0013_01C809DA.63C2A400--


--===============0460135800==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============0460135800==--

