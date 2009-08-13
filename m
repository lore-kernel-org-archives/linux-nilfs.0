From: "Barham, David" <david.barham-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Subject: [SPAM] RE: [SPAM] installation/getting started issues
	onSLES 11
Date: Thu, 13 Aug 2009 14:02:03 +0200
Message-ID: <80225669DEC80D488C4A0B5150466E1802BB3B11@dekomplm002.net.plm.eds.com>
References: <80225669DEC80D488C4A0B5150466E1802BB39E7@dekomplm002.net.plm.eds.com>
	<871d267c0908121832mcabe0b9ub9cdf8fbb8117f0c@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1141347719=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-Class: urn:content-classes:message
In-Reply-To: <871d267c0908121832mcabe0b9ub9cdf8fbb8117f0c-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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

--===============1141347719==
Content-Class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01CA1C0D.E0725477"

------_=_NextPart_001_01CA1C0D.E0725477
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

Many thanks

That make it all work!

Perhaps this would be worth adding to the installation notes on the
website.

=20

David

=20

From: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org [mailto:users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org] On Behalf
Of Zhang Qiang
Sent: 13 August 2009 02:32
To: NILFS Users mailing list
Subject: Re: [NILFS users] [SPAM] installation/getting started issues
onSLES 11

=20

Hi,
Have you install the nilfs2 kernel module[nilfs2.ko].

This error info seems show that the nilfs2 filesystem type have not
registered on your system, and you should do 'insmod nilfs2.ko'.  Is
this module included in nilfs-kmp-default-2.0.15_2.6.

27.19_5-2.1.x86_64.rpm?


Expect this info can help you.

-Regards
-Qiang



2009/8/12 Barham, David <david.barham-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>

I've just downloaded and installed the RPMs for SLES 11 from
opensuse.org.

I've successfully installed
nilfs-kmp-default-2.0.15_2.6.27.19_5-2.1.x86_64.rpm and
nilfs-utils-2.0.14-4.2.x86_64.rpm.

=20

These installed with no error.

=20

Mkfs appears to work without error.

=20

# mkfs -t nilfs2 /dev/sdb

mkfs.nilfs2 ver 2.0

Start writing file system initial data to the device

       Blocksize:4096  Device:/dev/sdb  Device Size:1500301910016

File system initialization succeeded !!

=20

But when I tried to mount the filesystem I get

=20

# mount -t nilfs2 /dev/sdb /data1

mount.nilfs2: WARNING! - The NILFS on-disk format may change at any
time.

mount.nilfs2: WARNING! - Do not place critical data on a NILFS
filesystem.

mount.nilfs2: cannot find or load nilfs2 filesystem

=20

Any ideas? I can see an /sbin/mount.nilfs2 and all the other files I
would expect.

=20

Is this a terrible newbie misunderstanding?=20

What am I doing wrong?=20

Am I missing some other vital rpm?

=20

Thanks

David Barham

=20


_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

=20


------_=_NextPart_001_01CA1C0D.E0725477
Content-Type: text/html; charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" =
xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:x=3D"urn:schemas-microsoft-com:office:excel" =
xmlns:p=3D"urn:schemas-microsoft-com:office:powerpoint" =
xmlns:a=3D"urn:schemas-microsoft-com:office:access" =
xmlns:dt=3D"uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" =
xmlns:s=3D"uuid:BDC6E3F0-6DA3-11d1-A2A3-00AA00C14882" =
xmlns:rs=3D"urn:schemas-microsoft-com:rowset" xmlns:z=3D"#RowsetSchema" =
xmlns:b=3D"urn:schemas-microsoft-com:office:publisher" =
xmlns:ss=3D"urn:schemas-microsoft-com:office:spreadsheet" =
xmlns:c=3D"urn:schemas-microsoft-com:office:component:spreadsheet" =
xmlns:odc=3D"urn:schemas-microsoft-com:office:odc" =
xmlns:oa=3D"urn:schemas-microsoft-com:office:activation" =
xmlns:html=3D"http://www.w3.org/TR/REC-html40" =
xmlns:q=3D"http://schemas.xmlsoap.org/soap/envelope/" =
xmlns:rtc=3D"http://microsoft.com/officenet/conferencing" =
xmlns:D=3D"DAV:" xmlns:Repl=3D"http://schemas.microsoft.com/repl/" =
xmlns:mt=3D"http://schemas.microsoft.com/sharepoint/soap/meetings/" =
xmlns:x2=3D"http://schemas.microsoft.com/office/excel/2003/xml" =
xmlns:ppda=3D"http://www.passport.com/NameSpace.xsd" =
xmlns:ois=3D"http://schemas.microsoft.com/sharepoint/soap/ois/" =
xmlns:dir=3D"http://schemas.microsoft.com/sharepoint/soap/directory/" =
xmlns:ds=3D"http://www.w3.org/2000/09/xmldsig#" =
xmlns:dsp=3D"http://schemas.microsoft.com/sharepoint/dsp" =
xmlns:udc=3D"http://schemas.microsoft.com/data/udc" =
xmlns:xsd=3D"http://www.w3.org/2001/XMLSchema" =
xmlns:sub=3D"http://schemas.microsoft.com/sharepoint/soap/2002/1/alerts/"=
 xmlns:ec=3D"http://www.w3.org/2001/04/xmlenc#" =
xmlns:sp=3D"http://schemas.microsoft.com/sharepoint/" =
xmlns:sps=3D"http://schemas.microsoft.com/sharepoint/soap/" =
xmlns:xsi=3D"http://www.w3.org/2001/XMLSchema-instance" =
xmlns:udcs=3D"http://schemas.microsoft.com/data/udc/soap" =
xmlns:udcxf=3D"http://schemas.microsoft.com/data/udc/xmlfile" =
xmlns:udcp2p=3D"http://schemas.microsoft.com/data/udc/parttopart" =
xmlns:wf=3D"http://schemas.microsoft.com/sharepoint/soap/workflow/" =
xmlns:dsss=3D"http://schemas.microsoft.com/office/2006/digsig-setup" =
xmlns:dssi=3D"http://schemas.microsoft.com/office/2006/digsig" =
xmlns:mdssi=3D"http://schemas.openxmlformats.org/package/2006/digital-sig=
nature" =
xmlns:mver=3D"http://schemas.openxmlformats.org/markup-compatibility/2006=
" xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" =
xmlns:mrels=3D"http://schemas.openxmlformats.org/package/2006/relationshi=
ps" xmlns:spwp=3D"http://microsoft.com/sharepoint/webpartpages" =
xmlns:ex12t=3D"http://schemas.microsoft.com/exchange/services/2006/types"=
 =
xmlns:ex12m=3D"http://schemas.microsoft.com/exchange/services/2006/messag=
es" =
xmlns:pptsl=3D"http://schemas.microsoft.com/sharepoint/soap/SlideLibrary/=
" =
xmlns:spsl=3D"http://microsoft.com/webservices/SharePointPortalServer/Pub=
lishedLinksService" xmlns:Z=3D"urn:schemas-microsoft-com:" =
xmlns:st=3D"&#1;" xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 12 (filtered medium)">
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:Tahoma;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	font-size:12.0pt;
	font-family:"Times New Roman","serif";}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
p
	{mso-style-priority:99;
	mso-margin-top-alt:auto;
	margin-right:0cm;
	mso-margin-bottom-alt:auto;
	margin-left:0cm;
	font-size:12.0pt;
	font-family:"Times New Roman","serif";}
span.EmailStyle18
	{mso-style-type:personal-reply;
	font-family:"Calibri","sans-serif";
	color:#1F497D;}
.MsoChpDefault
	{mso-style-type:export-only;}
@page Section1
	{size:612.0pt 792.0pt;
	margin:72.0pt 72.0pt 72.0pt 72.0pt;}
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

<body lang=3DEN-GB link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal><span =
style=3D'font-size:11.0pt;font-family:"Calibri","sans-serif";
color:#1F497D'>Many thanks<o:p></o:p></span></p>

<p class=3DMsoNormal><span =
style=3D'font-size:11.0pt;font-family:"Calibri","sans-serif";
color:#1F497D'>That make it all work!<o:p></o:p></span></p>

<p class=3DMsoNormal><span =
style=3D'font-size:11.0pt;font-family:"Calibri","sans-serif";
color:#1F497D'>Perhaps this would be worth adding to the installation =
notes on
the website.<o:p></o:p></span></p>

<p class=3DMsoNormal><span =
style=3D'font-size:11.0pt;font-family:"Calibri","sans-serif";
color:#1F497D'><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal><span =
style=3D'font-size:11.0pt;font-family:"Calibri","sans-serif";
color:#1F497D'>David<o:p></o:p></span></p>

<p class=3DMsoNormal><span =
style=3D'font-size:11.0pt;font-family:"Calibri","sans-serif";
color:#1F497D'><o:p>&nbsp;</o:p></span></p>

<div style=3D'border:none;border-top:solid #B5C4DF 1.0pt;padding:3.0pt =
0cm 0cm 0cm'>

<p class=3DMsoNormal><b><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:
"Tahoma","sans-serif"'>From:</span></b><span lang=3DEN-US =
style=3D'font-size:10.0pt;
font-family:"Tahoma","sans-serif"'> users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
[mailto:users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org] <b>On Behalf Of </b>Zhang Qiang<br>
<b>Sent:</b> 13 August 2009 02:32<br>
<b>To:</b> NILFS Users mailing list<br>
<b>Subject:</b> Re: [NILFS users] [SPAM] installation/getting started =
issues
onSLES 11<o:p></o:p></span></p>

</div>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Hi,<br>
Have you install the nilfs2 kernel module[nilfs2.ko].<br>
<br>
This error info seems show that the nilfs2 filesystem type have not =
registered
on your system, and you should do 'insmod nilfs2.ko'.&nbsp; Is this =
module
included in nilfs-kmp-default-2.0.15_2.6.<o:p></o:p></p>

<p>27.19_5-2.1.x86_64.rpm?<o:p></o:p></p>

<p class=3DMsoNormal style=3D'margin-bottom:12.0pt'><br>
Expect this info can help you.<br>
<br>
-Regards<br>
-Qiang<br>
<br>
<o:p></o:p></p>

<div>

<p class=3DMsoNormal>2009/8/12 Barham, David &lt;<a
href=3D"mailto:david.barham-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org">david.barham-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org</a>&gt;=
<o:p></o:p></p>

<div>

<div>

<p>I&#8217;ve just downloaded and installed the RPMs for SLES 11 from <a
href=3D"http://opensuse.org" =
target=3D"_blank">opensuse.org</a>.<o:p></o:p></p>

<p>I&#8217;ve successfully installed
nilfs-kmp-default-2.0.15_2.6.27.19_5-2.1.x86_64.rpm and
nilfs-utils-2.0.14-4.2.x86_64.rpm.<o:p></o:p></p>

<p>&nbsp;<o:p></o:p></p>

<p>These installed with no error.<o:p></o:p></p>

<p>&nbsp;<o:p></o:p></p>

<p>Mkfs appears to work without error.<o:p></o:p></p>

<p>&nbsp;<o:p></o:p></p>

<p># mkfs -t nilfs2 /dev/sdb<o:p></o:p></p>

<p>mkfs.nilfs2 ver 2.0<o:p></o:p></p>

<p>Start writing file system initial data to the device<o:p></o:p></p>

<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Blocksize:4096&nbsp;
Device:/dev/sdb&nbsp; Device Size:1500301910016<o:p></o:p></p>

<p>File system initialization succeeded !!<o:p></o:p></p>

<p>&nbsp;<o:p></o:p></p>

<p>But when I tried to mount the filesystem I get<o:p></o:p></p>

<p>&nbsp;<o:p></o:p></p>

<p># mount -t nilfs2 /dev/sdb /data1<o:p></o:p></p>

<p>mount.nilfs2: WARNING! - The NILFS on-disk format may change at any =
time.<o:p></o:p></p>

<p>mount.nilfs2: WARNING! - Do not place critical data on a NILFS =
filesystem.<o:p></o:p></p>

<p>mount.nilfs2: cannot find or load nilfs2 filesystem<o:p></o:p></p>

<p>&nbsp;<o:p></o:p></p>

<p>Any ideas? I can see an /sbin/mount.nilfs2 and all the other files I =
would
expect.<o:p></o:p></p>

<p>&nbsp;<o:p></o:p></p>

<p>Is this a terrible newbie misunderstanding? <o:p></o:p></p>

<p>What am I doing wrong? <o:p></o:p></p>

<p>Am I missing some other vital rpm?<o:p></o:p></p>

<p>&nbsp;<o:p></o:p></p>

<p>Thanks<o:p></o:p></p>

<p>David Barham<o:p></o:p></p>

<p>&nbsp;<o:p></o:p></p>

</div>

</div>

<p class=3DMsoNormal style=3D'margin-bottom:12.0pt'><br>
_______________________________________________<br>
users mailing list<br>
<a href=3D"mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org">users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org</a><br>
<a href=3D"https://www.nilfs.org/mailman/listinfo/users" =
target=3D"_blank">https://www.nilfs.org/mailman/listinfo/users</a><o:p></=
o:p></p>

</div>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

</div>

</body>

</html>

------_=_NextPart_001_01CA1C0D.E0725477--

--===============1141347719==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1141347719==--
