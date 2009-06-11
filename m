From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Stressing GC
Date: Thu, 11 Jun 2009 12:51:17 -0400
Message-ID: <debc30fc0906110951j4d32efb1xd3f73c0cd07a06e1@mail.gmail.com>
References: <20090610210859.GA17619@apu.cs.fiu.edu>
	<4A30856F.3000103@0bits.com> 
	<20090611153950.GA26921@apu.cs.fiu.edu>
	<20090611152040.GF21314@aardappel.13thmonkey.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1747278941=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090611152040.GF21314-5cYspOl2ggRz6xQTk39kMVfVdRo2wo/d@public.gmane.org>
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

--===============1747278941==
Content-Type: multipart/alternative; boundary=00163630f2dbb8870c046c1567f2

--00163630f2dbb8870c046c1567f2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>
> On Thu, Jun 11, 2009 at 11:39:50AM -0400, Luis Useche wrote:
> With the current GC implementation, I am unable to do my experiment. I set
> "protection_period 0" but still have the problem. Besides, this is
> probably not the right solution either since the GC can do unnecessary work
> that can underestimate the potential of nilfs. I need the first option (1)
> from the first paragraph above.
>

For this situation, would it be possible instead, to have to GC collect all
the space that can be freed, have the filesystem informed of what blocks can
be freed anytime (like a memory cache which can be flushed anytime), and
have the FS give the free space information for what it calculated as
removable? So with this we could have checkpoint for longuer than the
protection_period and still have the free space available for thing the
filesystem can just overwrite. I really don't know how it is coded as I'm
just a user for now, but that would be even greater.

On Thu, Jun 11, 2009 at 11:20 AM, Reinoud Zandijk <reinoud-S783fYmB3Ccdnm+yROfE0A@public.gmane.org>wrote:

>
> idealiter there should be an analog to VMS's purge command, say purge_nilfs
> or
> `nilfs purge /mnt' that flushes all data not protected by a snapshot or the
> last checkpoint.


That would be a great alternative thinking of the current state of the
project, if it's possible to tell the GC to flush all non protected data
'right now'.

--00163630f2dbb8870c046c1567f2
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div class=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"borde=
r-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-le=
ft: 1ex;"><div class=3D"im">
On Thu, Jun 11, 2009 at 11:39:50AM -0400, Luis Useche wrote:</div><div clas=
s=3D"im"> With the current GC implementation, I am unable to do my experime=
nt. I set<br>
 &quot;protection_period 0&quot; but still have the problem. Besides, this =
is<br>
 probably not the right solution either since the GC can do unnecessary wor=
k<br>
 that can underestimate the potential of nilfs. I need the first option (1)=
<br>
 from the first paragraph above.</div></blockquote><div>=A0</div><div>For t=
his situation, would it be possible instead, to have to GC collect all the =
space that can be freed, have the filesystem informed of what blocks can be=
 freed anytime (like a memory cache which can be flushed anytime), and have=
 the FS give the free space information for what it calculated as removable=
? So with this we could have checkpoint for longuer than the protection_per=
iod and still have the free space available for thing the filesystem can ju=
st overwrite. I really don&#39;t know how it is coded as I&#39;m just a use=
r for now, but that would be even greater.</div>

<div><br>On Thu, Jun 11, 2009 at 11:20 AM, Reinoud Zandijk <span dir=3D"ltr=
">&lt;<a href=3D"mailto:reinoud-S783fYmB3Ccdnm+yROfE0A@public.gmane.org">reinoud-S783fYmB3Ccdnm+yROfE0A@public.gmane.org</a>&gt;</spa=
n> wrote:=A0</div><blockquote class=3D"gmail_quote" style=3D"border-left: 1=
px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"=
>

<div class=3D"im"><br>
</div>idealiter there should be an analog to VMS&#39;s purge command, say p=
urge_nilfs or<br>
`nilfs purge /mnt&#39; that flushes all data not protected by a snapshot or=
 the<br>
last checkpoint.</blockquote><br><div>That would be a great alternative thi=
nking of the current state of the project, if it&#39;s possible to tell the=
 GC to flush all=A0non protected data &#39;right now&#39;.</div></div>

--00163630f2dbb8870c046c1567f2--

--===============1747278941==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1747278941==--
