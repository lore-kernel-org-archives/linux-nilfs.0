From: Prasenjit Giri <tangyorangesour-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: How does NILFS2 handle directory management
Date: Fri, 11 Sep 2009 09:28:55 +0530
Message-ID: <2324ff2b0909102058g1ee407fco3f2482b4732dacca@mail.gmail.com>
References: <2324ff2b0909101216q31dad1a8y43ea0f229923a0c3@mail.gmail.com>
	<20090910192619.GA1263@heethoofdje.13thmonkey.org>
	<20090911.102118.69189169.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1831919331=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090911.102118.69189169.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: NILFS2 <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

--===============1831919331==
Content-Type: multipart/alternative; boundary=0016e6480ca6c4d9e904734555a6

--0016e6480ca6c4d9e904734555a6
Content-Type: text/plain; charset=ISO-8859-1

On Fri, Sep 11, 2009 at 6:51 AM, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:

> Hi Prasenjit Giri, and Reinoud,
> On Thu, 10 Sep 2009 21:26:19 +0200, Reinoud Zandijk <wrote:
> > Hi Prasenjit Giri,
> >
> > On Fri, Sep 11, 2009 at 12:46:04AM +0530, Prasenjit Giri wrote:
> > > Even after looking through various sites, forums, mailing lists I could
> not
> > > uncover the present directoy management of NILFS2.
> > >
> > > As I see a B-tree directory management in your long term to do list, it
> > > would be really nice if someone would ought to share the information
> > > regarding the present directory management of NILFS2
> >
> > Currently directories are recorded just as a sequential file but not
> filled
> > with user data but with dirent entries in their blocks like ext2fs does.
> > Nothing special about that :)
> >
> > I dont know if b+tree directory management would be preferable though.
> With
> > some smart caching all directory operations can be made O(1) anyway.
> >
> > With regards,
> > Reinoud Zandijk
>
> Yes, directory is a file and it's already managed with b-tree like
> other files.  However, the current directory design is not O(log n),
> and is actually slow especially for file creation.
>
> So, it leaves room for considering the true "b-tree directory
> management".
>
> OTOH, the replacement has the following points to notice:
>
>  1) It may complicate the log writer.
>
>    The current log writer is designed on the basis that every data
>    and meta data is a file.  In NILFS, inodes, segment usage state,
>    and checkpoints, are managed with correponding meta-data files.
>
>    The true "b-tree directory management" may break this uniformity.
>
>  2) A disk format change is required.
>    (We can deem this a trade-off at this stage)
>
> This may be a -v3 material.  But anyway, patch proposals are welcome.
>
> Thank you,
> Ryusuke Konishi
>



Hello Reinoud Zandijk, Ryusuke Konishi

This has been more than helpful as I was at complete lost. But with this new
side of it could you explain the quoted, " --- true 'b-tree directory
management' --- ".

I've on this mail list, looking for ideas that would be feasible for an
undergrad project -- though this adds a very unpleasant twist.

Is writable snapshot feasible ? If so, is there an abstract for this
purpose? Is it doable in a years time?

Or could you all please suggest an alternative on such grounds.
With regards,
Prasenjit Giri
Rajesh D. Yadav
Ashwin Goel
Sunil V. Chitkote


-- 
Prasenjit Giri

--0016e6480ca6c4d9e904734555a6
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br><br>
<div class=3D"gmail_quote">On Fri, Sep 11, 2009 at 6:51 AM, Ryusuke Konishi=
 <span dir=3D"ltr">&lt;<a href=3D"mailto:ryusuke-sG5X7nlA6pw@public.gmane.org">ryusuke-sG5X7nlA6pw@public.gmane.org=
</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">Hi Prasenjit Giri, and Reinoud,<=
br>On Thu, 10 Sep 2009 21:26:19 +0200, Reinoud Zandijk &lt;wrote:<br>
<div class=3D"im">&gt; Hi Prasenjit Giri,<br>&gt;<br>&gt; On Fri, Sep 11, 2=
009 at 12:46:04AM +0530, Prasenjit Giri wrote:<br>&gt; &gt; Even after look=
ing through various sites, forums, mailing lists I could not<br>&gt; &gt; u=
ncover the present directoy management of NILFS2.<br>
&gt; &gt;<br>&gt; &gt; As I see a B-tree directory management in your long =
term to do list, it<br>&gt; &gt; would be really nice if someone would ough=
t to share the information<br>&gt; &gt; regarding the present directory man=
agement of NILFS2<br>
&gt;<br>&gt; Currently directories are recorded just as a sequential file b=
ut not filled<br>&gt; with user data but with dirent entries in their block=
s like ext2fs does.<br>&gt; Nothing special about that :)<br>&gt;<br>&gt; I=
 dont know if b+tree directory management would be preferable though. With<=
br>
&gt; some smart caching all directory operations can be made O(1) anyway.<b=
r>&gt;<br>&gt; With regards,<br>&gt; Reinoud Zandijk<br><br></div>Yes, dire=
ctory is a file and it&#39;s already managed with b-tree like<br>other file=
s. =A0However, the current directory design is not O(log n),<br>
and is actually slow especially for file creation.<br><br>So, it leaves roo=
m for considering the true &quot;b-tree directory<br>management&quot;.<br><=
br>OTOH, the replacement has the following points to notice:<br><br>=A01) I=
t may complicate the log writer.<br>
<br>=A0 =A0The current log writer is designed on the basis that every data<=
br>=A0 =A0and meta data is a file. =A0In NILFS, inodes, segment usage state=
,<br>=A0 =A0and checkpoints, are managed with correponding meta-data files.=
<br><br>=A0 =A0The true &quot;b-tree directory management&quot; may break t=
his uniformity.<br>
<br>=A02) A disk format change is required.<br>=A0 =A0(We can deem this a t=
rade-off at this stage)<br><br>This may be a -v3 material. =A0But anyway, p=
atch proposals are welcome.<br><br>Thank you,<br><font color=3D"#888888">Ry=
usuke Konishi<br>
</font></blockquote></div><br>
<div>=A0</div>
<div>=A0</div>
<div>Hello Reinoud Zandijk, Ryusuke Konishi<br>=A0<br>This has been more th=
an helpful as I was at complete lost. But with this new side of it could yo=
u explain the quoted, &quot; --- true &#39;b-tree directory management&#39;=
 --- &quot;. <br>
=A0<br>I&#39;ve on this mail list, looking for ideas that would be feasible=
 for an undergrad project -- though this adds a very unpleasant twist.<br>=
=A0<br>Is writable snapshot feasible ? If so, is there an abstract for this=
 purpose? Is it doable in a years time?<br>
=A0<br>Or could you all please suggest an alternative on such grounds.<br><=
/div>
<div>With regards, <br>Prasenjit Giri<br>Rajesh D. Yadav<br>Ashwin Goel<br>=
Sunil V. Chitkote<br clear=3D"all"></div><br clear=3D"all">
<div></div><br>-- <br>Prasenjit Giri<br>

--0016e6480ca6c4d9e904734555a6--

--===============1831919331==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1831919331==--
