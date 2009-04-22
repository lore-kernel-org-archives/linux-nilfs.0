From: Milos Jana <milosdsax-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Can't mount nilfs - error searching super root.
Date: Wed, 22 Apr 2009 15:18:33 +0200
Message-ID: <3313c4ab0904220618r22b62e7qa8b239ccbcf02270@mail.gmail.com>
References: <3313c4ab0901231613g2d82ea3at13e524dfba28df4@mail.gmail.com>
	<20090130.210323.88475416.ryusuke@osrg.net>
	<3313c4ab0902110709v1e9783fcm8f3dad6507f40347@mail.gmail.com>
	<20090212.143408.130857730.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1446358497=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090212.143408.130857730.ryusuke-sG5X7nlA6pw@public.gmane.org>
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

--===============1446358497==
Content-Type: multipart/alternative; boundary=0015174c3e9eb993cc04682499b6

--0015174c3e9eb993cc04682499b6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi again,
Is it safe for me to try to mount my drive with current release of nilfs and
nilfs-utils? Release notes are quite short, I'm not sure if disk format
change may affect me and whether "Some reported bugs of userland tools were
fixed" also include "error searching super root" problem.
Regards, MJ

On Thu, Feb 12, 2009 at 7:34 AM, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:

> Hi,
> On Wed, 11 Feb 2009 16:09:32 +0100, Milos Jana wrote:
> > Uhm... does it mean that data from my pendrive in unrecoverable? Is there
> > any chance that future release on fsck0.nilfs will be able to recover it?
> > On Fri, Jan 30, 2009 at 1:03 PM, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
> wrote:
>
> Oh, sorry. I once looked into the fsck0, but it was paused because I
> had to do so many things.  I'll increase priority for this if you
> really need it.  Meanwhile I'm worrying that the same trouble occurs
> again and again even if fsck0 will be improved.
>
> I feel we think removing the cause of the problem because
> making better fsck will take some time.
> And I wonder why the pendrive does not write all data for cleanly
> unmounted partition so often.  It may need bugfix for the device driver,
> for example it may have a silent error problem (i.e. it may complete
> I/O operations even if it couldn't handle them properly).
>
> Anyway, I will be able to back to fsck0 after a while.
>
> Regards,
> Ryusuke
>
>
>

--0015174c3e9eb993cc04682499b6
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Hi again,</div><div>Is it safe for me to try to mount my drive with cu=
rrent release of nilfs and nilfs-utils? Release notes are quite short, I&#3=
9;m not sure if disk format change may affect me and whether &quot;Some rep=
orted bugs of userland tools were fixed&quot; also include &quot;error sear=
ching super root&quot; problem.</div>
<div></div><div>Regards, MJ</div><div><br></div><div class=3D"gmail_quote">=
On Thu, Feb 12, 2009 at 7:34 AM, Ryusuke Konishi <span dir=3D"ltr">&lt;<a h=
ref=3D"mailto:ryusuke-sG5X7nlA6pw@public.gmane.org">ryusuke-sG5X7nlA6pw@public.gmane.org</a>&gt;</span> wrote:<br><=
blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px=
 #ccc solid;padding-left:1ex;">
Hi,<br>
<div class=3D"im">On Wed, 11 Feb 2009 16:09:32 +0100, Milos Jana wrote:<br>
&gt; Uhm... does it mean that data from my pendrive in unrecoverable? Is th=
ere<br>
&gt; any chance that future release on fsck0.nilfs will be able to recover =
it?<br>
&gt; On Fri, Jan 30, 2009 at 1:03 PM, Ryusuke Konishi &lt;<a href=3D"mailto=
:ryusuke-sG5X7nlA6pw@public.gmane.org">ryusuke-sG5X7nlA6pw@public.gmane.org</a>&gt; wrote:<br>
<br>
</div>Oh, sorry. I once looked into the fsck0, but it was paused because I<=
br>
had to do so many things. =A0I&#39;ll increase priority for this if you<br>
really need it. =A0Meanwhile I&#39;m worrying that the same trouble occurs<=
br>
again and again even if fsck0 will be improved.<br>
<br>
I feel we think removing the cause of the problem because<br>
making better fsck will take some time.<br>
And I wonder why the pendrive does not write all data for cleanly<br>
unmounted partition so often. =A0It may need bugfix for the device driver,<=
br>
for example it may have a silent error problem (i.e. it may complete<br>
I/O operations even if it couldn&#39;t handle them properly).<br>
<br>
Anyway, I will be able to back to fsck0 after a while.<br>
<br>
Regards,<br>
<font color=3D"#888888">Ryusuke<br>
</font><div><div class=3D"h5"><br><br></div></div></blockquote></div><div><=
br></div>

--0015174c3e9eb993cc04682499b6--

--===============1446358497==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1446358497==--
