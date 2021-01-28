From: Chaitanya Kulkarni <Chaitanya.Kulkarni-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [RFC PATCH 02/34] block: introduce and use bio_new
Date: Thu, 28 Jan 2021 08:34:28 +0000
Message-ID: <DM6PR04MB497297B2D0CB8DF8894EB65386BA9@DM6PR04MB4972.namprd04.prod.outlook.com>
References: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
	<20210128071133.60335-3-chaitanya.kulkarni@wdc.com>
	<BL0PR04MB6514C554B4AC96866BC1B16FE7BA9@BL0PR04MB6514.namprd04.prod.outlook.com>
	<BL0PR04MB6514DBA7EDB8EC87A1C20871E7BA9@BL0PR04MB6514.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6380031738630904480=="
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
	d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
	t=1611822877; x=1643358877;
	h=from:to:cc:subject:date:message-id:references: mime-version;
	bh=EIoojLv+ntCZJjOGXIHHi5MvCvxiH+mSoftep2wA4IM=;
	b=LT7I9xpP6Nkj+R6AwN9ZrBdiQnCSFNvJDhI2V7Ruk2KA8Be/Ocy4y1Y8
	8yHlOdHblV4xtteXhZd3uJhR26oK/J658oaE/IrIEpEwGqqCs5p9tjQ0j
	fTsBidzBjZG6zx9eeOoMZbHPy9+J9MkGTdSv3DSNqDTeNb3YsXCAGWd4d
	qtohoZwTrp2Lq3R8+DvsZgwfcQTH+7k1xjVI7etgPzSVCz351AvD3MKrs
	79hCEfceM+0W/2Do/QSgF4lQN2xmG2DUIjcjx8QDecgzn4qpUwpjzcOTf
	uI6xvOdmkpP8T4/fvRI2Kl7n4shpl7a+OIQEF+Qws1XQDEqWCZ9tiwKX2 w==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com; 
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=3mgDQNQRRXtFVwM4GmqX8oF5/l8qUac6jUbD4sbQilg=;
	b=xnQ/nBcAFDGEt+UwO2EpTdtUqqCI+BD9kH44D1nmyXvjH7B08U/hA1ijsQl/lRRnOq8KMLcEeW1Fc0LZi31aVsrREkRSkQ2Vam57f6aqYuKKNvEwON9ivsL2As3ENL+yDBMdrrDJ/fPBE274uaf8pSDmvdY6wMh6WnlrFuz74TM=
Content-Language: en-US
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Damien Le Moal <Damien.LeMoal-Sjgp3cTcYWE@public.gmane.org>, "linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org" <drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>, "xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org" <xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fscrypt-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fscrypt-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org" <o>
Cc: "shaggy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <shaggy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "tiwai-l3A5Bk7waGM@public.gmane.org" <tiwai-l3A5Bk7waGM@public.gmane.org>, "djwong-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <djwong-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "gustavoars-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <gustavoars-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "joseph.qi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org" <joseph.qi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, "pavel-+ZI9xUNit7I@public.gmane.org" <pavel-+ZI9xUNit7I@public.gmane.org>, "alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org" <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "mark-qFb/fKtWg+rQT0dZR+AlfA@public.gmane.org" <mark-qFb/fKtWg+rQT0dZR+AlfA@public.gmane.org>, "osandov-b10kYP2dOMg@public.gmane.org" <osandov-b10kYP2dOMg@public.gmane.org>, "ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "ngupta-KNmc09w0p+Ednm+yROfE0A@public.gmane.org" <ngupta-KNmc09w0p+Ednm+yROfE0A@public.gmane.org>, Naohiro Aota <Naohiro.Aota-Sjgp3cTcYWE@public.gmane.org>, "konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "hare-l3A5Bk7waGM@public.gmane.org" <hare-l3A5Bk7waGM@public.gmane.org>, "ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <min>

--===============6380031738630904480==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_DM6PR04MB497297B2D0CB8DF8894EB65386BA9DM6PR04MB4972namp_"

--_000_DM6PR04MB497297B2D0CB8DF8894EB65386BA9DM6PR04MB4972namp_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On 1/27/21 11:27 PM, Damien Le Moal wrote:

+
+       bio_set_dev(bio, bdev);
+       bio->bi_iter.bi_sector =3D sector;
+       bio_set_op_attrs(bio, op, op_flags);


This function is obsolete. Open code this.


And that also mean that you could remove one argument to bio_new(): combine=
 op
and op_flags into "unsigned int opf"



I did that initially but kept it separate for RFC, that is much easier than=
 having

an extra arg, will change it in V1.

--_000_DM6PR04MB497297B2D0CB8DF8894EB65386BA9DM6PR04MB4972namp_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
</head>
<body>
<div class=3D"moz-cite-prefix">On 1/27/21 11:27 PM, Damien Le Moal wrote:<b=
r>
</div>
<blockquote type=3D"cite" cite=3D"mid:BL0PR04MB6514DBA7EDB8EC87A1C20871E7BA=
9@BL0PR04MB6514.namprd04.prod.outlook.com">
<blockquote type=3D"cite" style=3D"color: #007cff;">
<blockquote type=3D"cite" style=3D"color: #007cff;">
<pre class=3D"moz-quote-pre" wrap=3D"">+=0A=
+	bio_set_dev(bio, bdev);=0A=
+	bio-&gt;bi_iter.bi_sector =3D sector;=0A=
+	bio_set_op_attrs(bio, op, op_flags);=0A=
</pre>
</blockquote>
<pre class=3D"moz-quote-pre" wrap=3D"">This function is obsolete. Open code=
 this.=0A=
</pre>
</blockquote>
<pre class=3D"moz-quote-pre" wrap=3D"">And that also mean that you could re=
move one argument to bio_new(): combine op=0A=
and op_flags into &quot;unsigned int opf&quot;=0A=
=0A=
</pre>
</blockquote>
<p><font face=3D"monospace">I did that initially but kept it separate for R=
FC, that is much easier than having</font></p>
<p><font face=3D"monospace">an extra arg, will change it in V1.</font><br>
</p>
</body>
</html>

--_000_DM6PR04MB497297B2D0CB8DF8894EB65386BA9DM6PR04MB4972namp_--

--===============6380031738630904480==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
drbd-dev mailing list
drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
https://lists.linbit.com/mailman/listinfo/drbd-dev

--===============6380031738630904480==--
