From: Milos Jana <milosdsax-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Can't mount nilfs - error searching super root.
Date: Fri, 16 Jan 2009 10:38:16 +0100
Message-ID: <3313c4ab0901160138u39baa485u56c5f285fb553449@mail.gmail.com>
References: <3313c4ab0901150703o5f86dc67y9261156a5519e1d5@mail.gmail.com>
	<20090116.020115.07539201.ryusuke@osrg.net>
	<3313c4ab0901151010u67983034vd1b8b75e0672d400@mail.gmail.com>
	<20090116.165503.64733535.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1947457040=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090116.165503.64733535.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

--===============1947457040==
Content-Type: multipart/alternative; boundary=0015174bded823bb060460965540

--0015174bded823bb060460965540
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

user@laptop:~/prog/sources/nilfs-utils-2.0.6$ sudo fsck0.nilfs2 /dev/sdb
[sudo] password for user:
Super-block:
  revision = 2.0, checksum = OK
  blocksize = 4096
  write time = 2008-12-28 09:48:42
  indicated partial segment: blocknr = 4263936
  segnum = 2082, seq = 11746, cno=6661

empty or bad segment: segnum = 2082, blocknr = 4263936
The latest segment is lost. Trying rollback recovery..
.
Searching the latest checkpoint.
Selected segment: blocknr = 4261888
  segnum = 2081, seq = 11745, cno=6660
  creation time = 2008-12-28 09:48:34
Do you wish to overwrite super block (y/N)? Y
Recovery will complete on mount.
user@laptop:~/prog/sources/nilfs-utils-2.0.6$ sudo mount /media/pendrive/
mount.nilfs2: Error while mounting /dev/sdb on /media/pendrive: Invalid
argument

dmesg returns the same errors:
[ 553.003240] NILFS warning: Segment magic number invalid
[ 553.003248] NILFS: error searching super root.

On Fri, Jan 16, 2009 at 8:55 AM, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:

> On Thu, 15 Jan 2009 19:10:19 +0100, "Milos Jana" wrote:
> > Nilfs-utils compiled properly with patch after following instructions
> from
> > your previous post. Here is what came out:
> >
> > user@laptop:~$ sudo fsck0.nilfs2 /dev/sdb
> > Super-block:
> >   revision = 2.0, checksum = OK
> >   blocksize = 4096
> >   write time = 2008-12-28 09:48:42
> >   indicated partial segment: blocknr = 4263936
> >   segnum = 2082, seq = 11746, cno=6661
> >
> > Clean FS.
> >
> > user@laptop:~$ sudo mount /media/pendrive/
> > mount.nilfs2: Error while mounting /dev/sdb on /media/pendrive: Invalid
> > argument
>
> Hmm, that's weird.
>
> The partition was cleanly unmounted, but the final segment seems not
> to be written to the disk.
>
> Maybe, we need 'force' option to treat such situation.
>
> In the meatime, could you try the following (additional) patch?
>
> Regards,
> Ryusuke
> --
>
> diff --git a/sbin/mkfs/fsck0.nilfs2.c b/sbin/mkfs/fsck0.nilfs2.c
> index d3d335f..0d51e54 100644
> --- a/sbin/mkfs/fsck0.nilfs2.c
> +++ b/sbin/mkfs/fsck0.nilfs2.c
> @@ -905,10 +905,12 @@ static void nilfs_fsck(const char *device)
>        print_pseg_message(&pseg_ref, "    indicated partial segment");
>        fputc('\n', stderr);
>
> +#if 0
>        if (le16_to_cpu(sb.s_state) & NILFS_VALID_FS) {
>                fprintf(stderr, "Clean FS.\n");
>                goto out_clean;
>        }
> +#endif
>
>        if (nilfs_do_recovery(devfd, &pseg_ref) == 0)
>                goto out;
>

--0015174bded823bb060460965540
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div class=3D"gmail_quote">user@laptop:~/prog/sources/nilfs-utils-2.0.6$ su=
do fsck0.nilfs2 /dev/sdb<br>[sudo] password for user:&nbsp;<br>Super-block:=
<br>&nbsp;   revision =3D 2.0, checksum =3D OK<br>&nbsp;   blocksize =3D 40=
96<br>&nbsp;   write time =3D 2008-12-28 09:48:42<br>
&nbsp;   indicated partial segment: blocknr =3D 4263936<br>&nbsp;       seg=
num =3D 2082, seq =3D 11746, cno=3D6661<br><br>empty or bad segment: segnum=
 =3D 2082, blocknr =3D 4263936<br>The latest segment is lost. Trying rollba=
ck recovery..<br>.<br>
Searching the latest checkpoint.<br>Selected segment: blocknr =3D 4261888<b=
r>&nbsp;   segnum =3D 2081, seq =3D 11745, cno=3D6660<br>&nbsp;   creation =
time =3D 2008-12-28 09:48:34<br>Do you wish to overwrite super block (y/N)?=
 Y<br>Recovery will complete on mount.<br>
user@laptop:~/prog/sources/nilfs-utils-2.0.6$ sudo mount /media/pendrive/<b=
r>mount.nilfs2: Error while mounting /dev/sdb on /media/pendrive: Invalid a=
rgument<br><br></div><div class=3D"gmail_quote">dmesg returns the same erro=
rs:</div>
<div class=3D"gmail_quote"></div><div class=3D"gmail_quote">[  553.003240] =
NILFS warning: Segment magic number invalid<br>[  553.003248] NILFS: error =
searching super root.<br><br></div><div class=3D"gmail_quote"></div><div cl=
ass=3D"gmail_quote">
On Fri, Jan 16, 2009 at 8:55 AM, Ryusuke Konishi <span dir=3D"ltr">&lt;<a h=
ref=3D"mailto:ryusuke-sG5X7nlA6pw@public.gmane.org">ryusuke-sG5X7nlA6pw@public.gmane.org</a>&gt;</span> wrote:<br><=
blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px=
 #ccc solid;padding-left:1ex;">
<div class=3D"Ih2E3d">On Thu, 15 Jan 2009 19:10:19 +0100, &quot;Milos Jana&=
quot; wrote:<br>
&gt; Nilfs-utils compiled properly with patch after following instructions =
from<br>
&gt; your previous post. Here is what came out:<br>
&gt;<br>
&gt; user@laptop:~$ sudo fsck0.nilfs2 /dev/sdb<br>
&gt; Super-block:<br>
&gt; &nbsp; revision =3D 2.0, checksum =3D OK<br>
&gt; &nbsp; blocksize =3D 4096<br>
&gt; &nbsp; write time =3D 2008-12-28 09:48:42<br>
&gt; &nbsp; indicated partial segment: blocknr =3D 4263936<br>
&gt; &nbsp; segnum =3D 2082, seq =3D 11746, cno=3D6661<br>
&gt;<br>
&gt; Clean FS.<br>
&gt;<br>
&gt; user@laptop:~$ sudo mount /media/pendrive/<br>
&gt; mount.nilfs2: Error while mounting /dev/sdb on /media/pendrive: Invali=
d<br>
&gt; argument<br>
<br>
</div>Hmm, that&#39;s weird.<br>
<br>
The partition was cleanly unmounted, but the final segment seems not<br>
to be written to the disk.<br>
<br>
Maybe, we need &#39;force&#39; option to treat such situation.<br>
<br>
In the meatime, could you try the following (additional) patch?<br>
<br>
Regards,<br>
Ryusuke<br>
--<br>
<br>
diff --git a/sbin/mkfs/fsck0.nilfs2.c b/sbin/mkfs/fsck0.nilfs2.c<br>
index d3d335f..0d51e54 100644<br>
--- a/sbin/mkfs/fsck0.nilfs2.c<br>
+++ b/sbin/mkfs/fsck0.nilfs2.c<br>
@@ -905,10 +905,12 @@ static void nilfs_fsck(const char *device)<br>
 &nbsp; &nbsp; &nbsp; &nbsp;print_pseg_message(&amp;pseg_ref, &quot; &nbsp;=
 &nbsp;indicated partial segment&quot;);<br>
 &nbsp; &nbsp; &nbsp; &nbsp;fputc(&#39;\n&#39;, stderr);<br>
<br>
+#if 0<br>
 &nbsp; &nbsp; &nbsp; &nbsp;if (le16_to_cpu(sb.s_state) &amp; NILFS_VALID_F=
S) {<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;fprintf(stderr, &qu=
ot;Clean FS.\n&quot;);<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;goto out_clean;<br>
 &nbsp; &nbsp; &nbsp; &nbsp;}<br>
+#endif<br>
<br>
 &nbsp; &nbsp; &nbsp; &nbsp;if (nilfs_do_recovery(devfd, &amp;pseg_ref) =3D=
=3D 0)<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;goto out;<br>
</blockquote></div><br>

--0015174bded823bb060460965540--

--===============1947457040==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1947457040==--
