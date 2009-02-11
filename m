From: Milos Jana <milosdsax-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Can't mount nilfs - error searching super root.
Date: Wed, 11 Feb 2009 16:09:32 +0100
Message-ID: <3313c4ab0902110709v1e9783fcm8f3dad6507f40347@mail.gmail.com>
References: <55b53420901160316h2b1e70e3xc420321973ce99b4@mail.gmail.com>
	<20090116.222255.131926946.ryusuke@osrg.net>
	<3313c4ab0901231613g2d82ea3at13e524dfba28df4@mail.gmail.com>
	<20090130.210323.88475416.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2002141067=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090130.210323.88475416.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>, users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

--===============2002141067==
Content-Type: multipart/alternative; boundary=0015174c3f5cb9fb7f0462a5fd1b

--0015174c3f5cb9fb7f0462a5fd1b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Uhm... does it mean that data from my pendrive in unrecoverable? Is there
any chance that future release on fsck0.nilfs will be able to recover it?
On Fri, Jan 30, 2009 at 1:03 PM, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:

> Hi,
> On Sat, 24 Jan 2009 01:13:41 +0100, Milos Jana wrote:
> > Hi again,
> >
> > Looks like I'm unable to mount this drive again. It mounted successfully
> > several times after following your previous posts, but yesterday the
> problem
> > came back. I'm sure that I have been mounting/unmounting my pendrive
> > properly.
>
> Hmm, it's abnormal that this occurs so often.
> The partition was cleanly unmounted, but the latest segment was not
> written.
> The usb device seems to lack proper support of cache flushing if it
> occurs just before power-off.
>
> The usb stack of Linux is often problematic, but this looks terrific.
>
> > This time fsck0.nilfs2 doesn't help - it hangs with "Searching the
> > latest checkpoint." message (see below).
>
> All right, I'll look into the hang problem.
>
> Please note that the fsck0 is not a complete solution.
> To make it better, we need a few changes on the disk format.
>
> Regards,
> Ryusuke
>
> > user@laptop:~$ sudo mount /media/pendrive/
> > mount.nilfs2: Error while mounting /dev/sdb on /media/pendrive: Invalid
> > argument
> >
> > user@laptop:~$ dmesg
> > ...
> > [22429.446924] NILFS warning: Segment magic number invalid
> > [22429.446932] NILFS: error searching super root.
> >
> > user@laptop:~/prog/sources/nilfs-utils-2.0.6$ sudo fsck0.nilfs2 /dev/sdb
> #
> > Nilfs-tools with first patch applied
> > Super-block:
> >   revision = 2.0, checksum = OK
> >   blocksize = 4096
> >   write time = 2009-01-22 23:40:19
> >   indicated partial segment: blocknr = 1966080
> >   segnum = 960, seq = 18266, cno=10169
> >
> > Clean FS.
> >
> > user@laptop:~/prog/sources/nilfs-utils-2.0.6$ sudo fsck0.nilfs2 /dev/sdb
> #
> > Nilfs-tools with additional patch applied
> > Super-block:
> >   revision = 2.0, checksum = OK
> >   blocksize = 4096
> >   write time = 2009-01-22 23:40:19
> >   indicated partial segment: blocknr = 1966080
> >   segnum = 960, seq = 18266, cno=10169
> >
> > empty or bad segment: segnum = 960, blocknr = 1966080
> > The latest segment is lost. Trying rollback recovery..
> > .
> > Searching the latest checkpoint.    # here it hanged for like 10 minutes
> > until I killed it
>

--0015174c3f5cb9fb7f0462a5fd1b
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div class=3D"gmail_quote">Uhm... does it mean that data from my pendrive i=
n unrecoverable? Is there any chance that future release on fsck0.nilfs wil=
l be able to recover it?&nbsp;</div><div class=3D"gmail_quote"></div><div c=
lass=3D"gmail_quote">

</div><div class=3D"gmail_quote">On Fri, Jan 30, 2009 at 1:03 PM, Ryusuke K=
onishi <span dir=3D"ltr">&lt;<a href=3D"mailto:ryusuke-sG5X7nlA6pw@public.gmane.org" target=3D"=
_blank">ryusuke-sG5X7nlA6pw@public.gmane.org</a>&gt;</span> wrote:<br><blockquote class=3D"gmai=
l_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left=
:1ex">

Hi,<br>
<div>On Sat, 24 Jan 2009 01:13:41 +0100, Milos Jana wrote:<br>
&gt; Hi again,<br>
&gt;<br>
&gt; Looks like I&#39;m unable to mount this drive again. It mounted succes=
sfully<br>
&gt; several times after following your previous posts, but yesterday the p=
roblem<br>
&gt; came back. I&#39;m sure that I have been mounting/unmounting my pendri=
ve<br>
&gt; properly.<br>
<br>
</div>Hmm, it&#39;s abnormal that this occurs so often.<br>
The partition was cleanly unmounted, but the latest segment was not written=
.<br>
The usb device seems to lack proper support of cache flushing if it<br>
occurs just before power-off.<br>
<br>
The usb stack of Linux is often problematic, but this looks terrific.<br>
<div><br>
&gt; This time fsck0.nilfs2 doesn&#39;t help - it hangs with &quot;Searchin=
g the<br>
&gt; latest checkpoint.&quot; message (see below).<br>
<br>
</div>All right, I&#39;ll look into the hang problem.<br>
<br>
Please note that the fsck0 is not a complete solution.<br>
To make it better, we need a few changes on the disk format.<br>
<br>
Regards,<br>
<font color=3D"#888888">Ryusuke<br>
</font><div><div><br>
&gt; user@laptop:~$ sudo mount /media/pendrive/<br>
&gt; mount.nilfs2: Error while mounting /dev/sdb on /media/pendrive: Invali=
d<br>
&gt; argument<br>
&gt;<br>
&gt; user@laptop:~$ dmesg<br>
&gt; ...<br>
&gt; [22429.446924] NILFS warning: Segment magic number invalid<br>
&gt; [22429.446932] NILFS: error searching super root.<br>
&gt;<br>
&gt; user@laptop:~/prog/sources/nilfs-utils-2.0.6$ sudo fsck0.nilfs2 /dev/s=
db #<br>
&gt; Nilfs-tools with first patch applied<br>
&gt; Super-block:<br>
&gt; &nbsp; revision =3D 2.0, checksum =3D OK<br>
&gt; &nbsp; blocksize =3D 4096<br>
&gt; &nbsp; write time =3D 2009-01-22 23:40:19<br>
&gt; &nbsp; indicated partial segment: blocknr =3D 1966080<br>
&gt; &nbsp; segnum =3D 960, seq =3D 18266, cno=3D10169<br>
&gt;<br>
&gt; Clean FS.<br>
&gt;<br>
&gt; user@laptop:~/prog/sources/nilfs-utils-2.0.6$ sudo fsck0.nilfs2 /dev/s=
db #<br>
&gt; Nilfs-tools with additional patch applied<br>
&gt; Super-block:<br>
&gt; &nbsp; revision =3D 2.0, checksum =3D OK<br>
&gt; &nbsp; blocksize =3D 4096<br>
&gt; &nbsp; write time =3D 2009-01-22 23:40:19<br>
&gt; &nbsp; indicated partial segment: blocknr =3D 1966080<br>
&gt; &nbsp; segnum =3D 960, seq =3D 18266, cno=3D10169<br>
&gt;<br>
&gt; empty or bad segment: segnum =3D 960, blocknr =3D 1966080<br>
&gt; The latest segment is lost. Trying rollback recovery..<br>
&gt; .<br>
&gt; Searching the latest checkpoint. &nbsp; &nbsp;# here it hanged for lik=
e 10 minutes<br>
&gt; until I killed it<br>
</div></div></blockquote></div><br>

--0015174c3f5cb9fb7f0462a5fd1b--

--===============2002141067==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============2002141067==--
