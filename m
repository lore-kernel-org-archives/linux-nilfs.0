From: Milos Jana <milosdsax-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Can't mount nilfs - error searching super root.
Date: Sun, 10 May 2009 16:50:36 +0200
Message-ID: <3313c4ab0905100750p503664acl3b44d043db3d23ae@mail.gmail.com>
References: <3313c4ab0902110709v1e9783fcm8f3dad6507f40347@mail.gmail.com>
	<20090212.143408.130857730.ryusuke@osrg.net>
	<3313c4ab0904220618r22b62e7qa8b239ccbcf02270@mail.gmail.com>
	<20090422.234455.05227091.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1579095786=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090422.234455.05227091.ryusuke-sG5X7nlA6pw@public.gmane.org>
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

--===============1579095786==
Content-Type: multipart/alternative; boundary=0015174c111e02ce2e04698ffceb

--0015174c111e02ce2e04698ffceb
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,
The same problem (error searching super root) occurred after one week of
using NILFS, this time the drive was formated and mounted with
nilfs/nilfs-utils version 2.0.12.


On Wed, Apr 22, 2009 at 4:44 PM, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:

> The disk format compatibility is not broken for x86.  You can try the
> latest nilfs2-utils and nilfs2-module.
>
> Since the "error searching super root" problem is not a bug of mount
> procedure but a result of incomplete disk write, it will occur for the
> nilfs2 drive in question.
>
> Even after you create a new partition with mkfs.nilfs2, it could be
> reproduced if the device or (or the device driver) still has the
> problem on sync write.  So please do not put valuable data on the
> nilfs2 partition.
>
> I'd like to know the root cause of the problem and take measures if I
> can do something on file system layer.
> I appreciate if you retry using nilfs on the device.
>
> Thanks,
> Ryusuke Konishi
>
>
>

--0015174c111e02ce2e04698ffceb
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,<br>The same problem (error searching super root) occurred after one wee=
k of using NILFS, this time the drive was formated and mounted with nilfs/n=
ilfs-utils version 2.0.12. <br><br><br><div class=3D"gmail_quote">On Wed, A=
pr 22, 2009 at 4:44 PM, Ryusuke Konishi <span dir=3D"ltr">&lt;<a href=3D"ma=
ilto:ryusuke-sG5X7nlA6pw@public.gmane.org">ryusuke-sG5X7nlA6pw@public.gmane.org</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">The disk format c=
ompatibility is not broken for x86. =A0You can try the<br>
latest nilfs2-utils and nilfs2-module.<br>
<br>
Since the &quot;error searching super root&quot; problem is not a bug of mo=
unt<br>
procedure but a result of incomplete disk write, it will occur for the<br>
nilfs2 drive in question.<br>
<br>
Even after you create a new partition with mkfs.nilfs2, it could be<br>
reproduced if the device or (or the device driver) still has the<br>
problem on sync write. =A0So please do not put valuable data on the<br>
nilfs2 partition.<br>
<br>
I&#39;d like to know the root cause of the problem and take measures if I<b=
r>
can do something on file system layer.<br>
I appreciate if you retry using nilfs on the device.<br>
<br>
Thanks,<br>
<font color=3D"#888888">Ryusuke Konishi<br>
</font><div><div></div><div class=3D"h5"><br><br>
</div></div></blockquote></div><br>

--0015174c111e02ce2e04698ffceb--

--===============1579095786==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1579095786==--
