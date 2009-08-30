From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: segctord problem
Date: Sun, 30 Aug 2009 17:30:10 -0400
Message-ID: <debc30fc0908301430x3b4b6138qab5928389be7ea60@mail.gmail.com>
References: <debc30fc0908270825v747c1734xa59126623cfd5b05@mail.gmail.com> 
	<debc30fc0908271439x63d16227mbf5589c8db455b1e@mail.gmail.com> 
	<debc30fc0908290948g3ee60e81u1f024b3031e36f36@mail.gmail.com> 
	<20090830.055014.88471834.ryusuke@osrg.net>
	<debc30fc0908291424l1b403bfcy9940b32fdda49b65@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1012702568=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <debc30fc0908291424l1b403bfcy9940b32fdda49b65-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>, NilFS2 Mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

--===============1012702568==
Content-Type: multipart/alternative; boundary=0016363104876480b4047262a027

--0016363104876480b4047262a027
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Good news, no crash since yesterday same time, 24 hours without a crash in
segctord, which was impossible without the patch, I'll keep you updated if =
I
find anything else.

Thank you!
J=E9r=F4me

On Sat, Aug 29, 2009 at 5:24 PM, J=E9r=F4me Poulin
<jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org<https://mail.google.com/mail?view=3Dcm&tf=3D0&to=3D=
jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> wrote:

> Thank you, I will apply it right away, reboot and see if it happens again
> today, I had the problem at least once a day, so if it's okay until monda=
y I
> guess it's good :)
>
>
> On Sat, Aug 29, 2009 at 4:50 PM, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org<https:=
//mail.google.com/mail?view=3Dcm&tf=3D0&to=3Dryusuke-sG5X7nlA6pw@public.gmane.org>
> > wrote:
>
>> Hi!
>> On Sat, 29 Aug 2009 12:48:03 -0400, J=E9r=F4me Poulin wrote:
>>
> ...

>
>> Thank you for sending me the log.
>>
>> I've found a bug which seems like the cause of this problem.  The
>> following patch is the bugfix.
>>
>> Could you test if the patch makes a difference ?
>>
>> Thanks,
>> Ryusuke Konishi
>>
>>

--0016363104876480b4047262a027
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Good news, no crash since yesterday same time, 24 hours without a crash in =
segctord, which was impossible without the patch, I&#39;ll keep you updated=
 if I find anything else.<br><br>Thank you!<br>J=E9r=F4me<br><br><div class=
=3D"gmail_quote">


On Sat, Aug 29, 2009 at 5:24 PM, J=E9r=F4me Poulin <span dir=3D"ltr">&lt;<a=
 href=3D"https://mail.google.com/mail?view=3Dcm&amp;tf=3D0&amp;to=3Djeromep=
oulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" target=3D"_blank">jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org</a>&gt;</span> wr=
ote:<br><blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid r=
gb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">


Thank you, I will apply it right away, reboot and see if it happens again t=
oday, I had the problem at least once a day, so if it&#39;s okay until mond=
ay I guess it&#39;s good :)<div><div></div><div><br><br><div class=3D"gmail=
_quote">


On Sat, Aug 29, 2009 at 4:50 PM, Ryusuke Konishi <span dir=3D"ltr">&lt;<a h=
ref=3D"https://mail.google.com/mail?view=3Dcm&amp;tf=3D0&amp;to=3Dryusuke@o=
srg.net" target=3D"_blank">ryusuke-sG5X7nlA6pw@public.gmane.org</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">Hi!<br>
<div>On Sat, 29 Aug 2009 12:48:03 -0400, J=E9r=F4me Poulin wrote:</div></bl=
ockquote></div></div></div></blockquote><div>...=A0</div><blockquote class=
=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, 204, 204); margin=
: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">


<div><div><div class=3D"gmail_quote"><blockquote class=3D"gmail_quote" styl=
e=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; =
padding-left: 1ex;"><div><br>
</div>Thank you for sending me the log.<br>
<br>
I&#39;ve found a bug which seems like the cause of this problem. =A0The<br>
following patch is the bugfix.<br>
<br>
Could you test if the patch makes a difference ?<br>
<br>
Thanks,<br>
Ryusuke Konishi<br>
<br>
</blockquote></div></div></div></blockquote></div><br>

--0016363104876480b4047262a027--

--===============1012702568==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1012702568==--
