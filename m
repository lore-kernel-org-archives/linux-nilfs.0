From: Prasenjit Giri <tangyorangesour-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Creating NILFS2 on Fedora 11
Date: Wed, 9 Sep 2009 10:09:08 +0530
Message-ID: <2324ff2b0909082139x660cfb7dj3b6cd4f37f6bbc5f@mail.gmail.com>
References: <2324ff2b0909062047scb58709h3255655c068661be@mail.gmail.com> 
	<debc30fc0909062113h29610480wb4ea49c59eecdb39@mail.gmail.com> 
	<4AA6832B.7070905@redhat.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0182787685=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <4AA6832B.7070905-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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

--===============0182787685==
Content-Type: multipart/alternative; boundary=0016e648f676122d0204731dab92

--0016e648f676122d0204731dab92
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello Jerome and Eric,Thanks for the info. See I was trying to do the b-
tree based directory management and if fedora is still in the dumps
supporting NILFS2, which distro do you think I must use? or rather which
distro's have you all been using...

On Tue, Sep 8, 2009 at 9:45 PM, Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> J=E9r=F4me Poulin wrote:
> > fdisk shows the partition type which should be 83 (Linux), not what FS
> > it contains, most likely no utilities (like blkid) support detecting
> > NilFS2 yet. Be sure to keep in mind the experimental nature of NilFS2
> > before putting all your data on it.
>
> That's right, blkid in fedora (also blkid upstream) does not yet
> recognize nilfs; the devels said that the format is still too much in
> flux to code the recognition into tools like this yet.
>
> -Eric
> _______________________________________________
> users mailing list
> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> https://www.nilfs.org/mailman/listinfo/users
>



--=20
Prasenjit Giri

--0016e648f676122d0204731dab92
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello Jerome and Eric,<div>Thanks for the info. See I was trying to do the =
b- tree based directory management and if fedora is still in the dumps supp=
orting NILFS2, which distro do you think I must use? or rather which distro=
&#39;s have you all been using...<br>

<br><div class=3D"gmail_quote">On Tue, Sep 8, 2009 at 9:45 PM, Eric Sandeen=
 <span dir=3D"ltr">&lt;<a href=3D"mailto:sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org">sandeen@redhat=
.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"ma=
rgin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex;">

<div class=3D"im">J=E9r=F4me Poulin wrote:<br>
&gt; fdisk shows the partition type which should be 83 (Linux), not what FS=
<br>
&gt; it contains, most likely no utilities (like blkid) support detecting<b=
r>
&gt; NilFS2 yet. Be sure to keep in mind the experimental nature of NilFS2<=
br>
&gt; before putting all your data on it.<br>
<br>
</div>That&#39;s right, blkid in fedora (also blkid upstream) does not yet<=
br>
recognize nilfs; the devels said that the format is still too much in<br>
flux to code the recognition into tools like this yet.<br>
<font color=3D"#888888"><br>
-Eric<br>
</font><div><div></div><div class=3D"h5">__________________________________=
_____________<br>
users mailing list<br>
<a href=3D"mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org">users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org</a><br>
<a href=3D"https://www.nilfs.org/mailman/listinfo/users" target=3D"_blank">=
https://www.nilfs.org/mailman/listinfo/users</a><br>
</div></div></blockquote></div><br><br clear=3D"all"><br>-- <br>Prasenjit G=
iri<br>
</div>

--0016e648f676122d0204731dab92--

--===============0182787685==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============0182787685==--
