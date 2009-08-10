From: Zhang Qiang <zhangqiang.buaa-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH]nilfs2: An unassigned variable is assigned
	to a never used structure member
Date: Mon, 10 Aug 2009 09:05:27 +0800
Message-ID: <871d267c0908091805v6721d434yb9707eb6ed5b1391@mail.gmail.com>
References: <4A7EAF46.6090302@gmail.com>
	<20090809.215419.08269814.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1447020866=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090809.215419.08269814.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: qiang.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, yanhai.zhu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

--===============1447020866==
Content-Type: multipart/alternative; boundary=000e0cd2122678a5b30470bf2eda

--000e0cd2122678a5b30470bf2eda
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

2009/8/9 Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>

> Hi!
> On Sun, 09 Aug 2009 19:13:10 +0800, Zhang Qiang wrote:
> > nilfs2: In procedure 'nilfs_get_sb()', when a nilfs filesysttem is
> mounted for the first time, local variable 'nilfs->ns_last_cno' is used
> before loading the latest checkpoint number from disk (in
> 'nilfs_fill_super'). 'nilfs->ns_last_cno' is assigned to 'sd.cno', but
> 'sd.cno' has never been used in the procedure.
> >
> > Signed-off-by: Zhang Qiang <zhangqiang.buaa-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >
> > ---
> >  fs/nilfs2/super.c |    4 ----
> >  1 files changed, 0 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> > index 8e2ec43..d8bfcfd 100644
> > --- a/fs/nilfs2/super.c
> > +++ b/fs/nilfs2/super.c
> > @@ -1125,10 +1125,6 @@ nilfs_get_sb(struct file_system_type *fs_type, int
> flags,
> >        */
> >       sd.sbi = nilfs_find_sbinfo(nilfs, !(flags & MS_RDONLY), sd.cno);
> >
> > -     if (!sd.cno)
> > -             /* trying to get the latest checkpoint.  */
> > -             sd.cno = nilfs_last_cno(nilfs);
> > -
> >       /*
> >        * Get super block instance holding the nilfs_sb_info struct.
> >        * A new instance is allocated if no existing mount is present or
> > --
> > 1.6.0.6
>
> Right.  The substitution became obsolete after a change merged in
> 2.6.31-rc1.
>
> Applied. Thank you.
>
> Ryusuke Konishi
>

Thanks a lot :-)

-Regards
-Qiang

--000e0cd2122678a5b30470bf2eda
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br><br><div class=3D"gmail_quote">2009/8/9 Ryusuke Konishi <span dir=3D"lt=
r">&lt;<a href=3D"mailto:ryusuke-sG5X7nlA6pw@public.gmane.org">ryusuke-sG5X7nlA6pw@public.gmane.org</a>&gt;</span><=
br><blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(20=
4, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Hi!<br>
<div><div></div><div class=3D"h5">On Sun, 09 Aug 2009 19:13:10 +0800, Zhang=
 Qiang wrote:<br>
&gt; nilfs2: In procedure &#39;nilfs_get_sb()&#39;, when a nilfs filesystte=
m is mounted for the first time, local variable &#39;nilfs-&gt;ns_last_cno&=
#39; is used before loading the latest checkpoint number from disk (in &#39=
;nilfs_fill_super&#39;). &#39;nilfs-&gt;ns_last_cno&#39; is assigned to &#3=
9;sd.cno&#39;, but &#39;sd.cno&#39; has never been used in the procedure.<b=
r>

&gt;<br>
&gt; Signed-off-by: Zhang Qiang &lt;<a href=3D"mailto:zhangqiang.buaa@gmail=
.com">zhangqiang.buaa-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org</a>&gt;<br>
&gt;<br>
&gt; ---<br>
&gt; =A0fs/nilfs2/super.c | =A0 =A04 ----<br>
&gt; =A01 files changed, 0 insertions(+), 4 deletions(-)<br>
&gt;<br>
&gt; diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c<br>
&gt; index 8e2ec43..d8bfcfd 100644<br>
&gt; --- a/fs/nilfs2/super.c<br>
&gt; +++ b/fs/nilfs2/super.c<br>
&gt; @@ -1125,10 +1125,6 @@ nilfs_get_sb(struct file_system_type *fs_type, =
int flags,<br>
&gt; =A0 =A0 =A0 =A0*/<br>
&gt; =A0 =A0 =A0 sd.sbi =3D nilfs_find_sbinfo(nilfs, !(flags &amp; MS_RDONL=
Y), sd.cno);<br>
&gt;<br>
&gt; - =A0 =A0 if (!sd.cno)<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 /* trying to get the latest checkpoint. =A0*=
/<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 sd.cno =3D nilfs_last_cno(nilfs);<br>
&gt; -<br>
&gt; =A0 =A0 =A0 /*<br>
&gt; =A0 =A0 =A0 =A0* Get super block instance holding the nilfs_sb_info st=
ruct.<br>
&gt; =A0 =A0 =A0 =A0* A new instance is allocated if no existing mount is p=
resent or<br>
&gt; --<br>
&gt; 1.6.0.6<br>
<br>
</div></div>Right. =A0The substitution became obsolete after a change merge=
d in<br>
2.6.31-rc1.<br>
<br>
Applied. Thank you.<br>
<font color=3D"#888888"><br>
Ryusuke Konishi<br>
</font></blockquote></div><br>Thanks a lot :-)<br><br>-Regards<br>-Qiang<br=
><br>

--000e0cd2122678a5b30470bf2eda--

--===============1447020866==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1447020866==--
