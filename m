From: Daniel LeBlanc <daniel.leblanc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [NILFS] NILFS filesystem stability
Date: Mon, 4 Jan 2010 12:03:39 -0500
Message-ID: <aff377151001040903m6a2cf379q99daf8a517ffeabb@mail.gmail.com>
References: <71d11f861001011335j459d29e8oddb7f4d49dd41126@mail.gmail.com>
	<20100103.163927.12303106.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1854879669=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=gamma;
	h=domainkey-signature:mime-version:received:in-reply-to:references
	:date:message-id:subject:from:to:cc:content-type;
	bh=57/XSbM5qcSpY5RWbfo+L6bjW3r3t8AtQPAA2Bf8Z8E=;
	b=DDbyDV5YEycA9oVaWf5nLDT8acivpNCZblSEJnEQR3+A4xRiO9o6voc8gLVGDcpHV2
	a7sjuwLSRqiVyPQvg8ToC/WFG7Qt9yExMwb7qaBHqBZQyp7bxbnwSqCa6qzLWetib3oH
	S9+tkhxI88JAy0e4iC+sHFKNJGaiFy3nMUil0=
In-Reply-To: <20100103.163927.12303106.ryusuke-sG5X7nlA6pw@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/options/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Mime-version: 1.0
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

--===============1854879669==
Content-Type: multipart/alternative; boundary=001636c5b90aeff031047c59b351

--001636c5b90aeff031047c59b351
Content-Type: text/plain; charset=ISO-8859-1

Hi,


On Sun, Jan 3, 2010 at 2:39 AM, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:

> ...
>
> It still needs backup since NILFS is not of help for hardware
> malfunction.  However, I feel it's actually helpful for human errors
> through experiences like that.

...
>
>
That- I think - is the answer to a question I wanted to ask for some times
now. I've been using XFS for a while now but eventually got bad sectors on
many disks and found XFS to be of limited help when that happens. So,
looking for alternatives I got interested in NILFS development. Do
I understand correctly that NILFS is not really better than other FS (xfs)
when the hardware deteriorates and bad sectors appear?

Is it in the plans to somehow 'support' bad sectors reallocation (or such)?



> Note that NILFS still lacks fsck.  You may go back before filesystem
> corruption, but this is not always possible since some types of
> metadata are not redundant.
>

Curious on any scenario you have in mind for such a case to show up?
Hardware malfunction and/or hdd access from outside NILFS? A bug? Something
else?



> ...
>
Ryusuke Konishi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



Cheers,

Daniel LeBlanc
software engineer

--001636c5b90aeff031047c59b351
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Hi,</div><div><br></div><br><div class=3D"gmail_quote">On Sun, Jan 3, =
2010 at 2:39 AM, Ryusuke Konishi <span dir=3D"ltr">&lt;<a href=3D"mailto:ry=
usuke-sG5X7nlA6pw@public.gmane.org">ryusuke-sG5X7nlA6pw@public.gmane.org</a>&gt;</span> wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex;">
...<br>
<br>
It still needs backup since NILFS is not of help for hardware<br>
malfunction. =A0However, I feel it&#39;s actually helpful for human errors<=
br>
through experiences like that.=A0</blockquote><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex=
;"><div class=3D"im">...</div>
<br></blockquote><div><br></div><div>That- I think - is the answer to a que=
stion I wanted to ask for some times now. I&#39;ve been using XFS for a whi=
le now but eventually got bad sectors on many disks and found XFS to be of =
limited help when that happens. So, looking for alternatives I got interest=
ed in NILFS=A0development. Do I=A0understand=A0correctly that NILFS is not =
really better than other FS (xfs) when the hardware deteriorates and bad se=
ctors appear?</div>
<div><br></div><div>Is it in the plans to somehow &#39;support&#39; bad sec=
tors reallocation (or such)?</div><div><br></div><div>=A0</div><blockquote =
class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid=
;padding-left:1ex;">

Note that NILFS still lacks fsck. =A0You may go back before filesystem<br>
corruption, but this is not always possible since some types of<br>
metadata are not redundant.<br></blockquote><div><br></div><div>Curious on =
any scenario you have in mind for such a case to show up? Hardware malfunct=
ion and/or hdd access from outside NILFS? A bug? Something else?</div>
<div><br></div><div>=A0</div><blockquote class=3D"gmail_quote" style=3D"mar=
gin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex;">
<div class=3D"im">...=A0</div></blockquote><blockquote class=3D"gmail_quote=
" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex;">=
<div class=3D"im"><span class=3D"Apple-style-span" style=3D"color: rgb(136,=
 136, 136); ">Ryusuke Konishi</span></div>
<div><div></div><div class=3D"h5">--<br>
To unsubscribe from this list: send the line &quot;unsubscribe linux-nilfs&=
quot; in<br>
the body of a message to <a href=3D"mailto:majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org">major=
domo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org</a><br>
More majordomo info at =A0<a href=3D"http://vger.kernel.org/majordomo-info.=
html" target=3D"_blank">http://vger.kernel.org/majordomo-info.html</a><br>
</div></div></blockquote></div><br><div><br></div><div><br></div><div>Cheer=
s,=A0</div><div><br></div><div>Daniel LeBlanc</div><div>software engineer</=
div>

--001636c5b90aeff031047c59b351--

--===============1854879669==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1854879669==--
