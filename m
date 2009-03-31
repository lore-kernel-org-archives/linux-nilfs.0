From: Alex Bitney <san-UZOCzndLCy9BDgjK7y7TUQ@public.gmane.org>
Subject: Re: Constant checkpointing and cleanerd activity -
	doesn't play nice with mount --bind ?
Date: Tue, 31 Mar 2009 15:14:48 +0000
Message-ID: <591bc86b0903310814t2814ab95ie71077d5bb59f99d@mail.gmail.com>
References: <20090317.224324.58871500.ryusuke@osrg.net>
	<20090317191924.1924576b@natsu.i4> 
	<20090331.234437.112904649.ryusuke@osrg.net>
	<20090401.001059.06956465.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0680638147=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090401.001059.06956465.ryusuke-sG5X7nlA6pw@public.gmane.org>
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

--===============0680638147==
Content-Type: multipart/alternative; boundary=001636c5b47ed80bf704666ba9bb

--001636c5b47ed80bf704666ba9bb
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On Tue, Mar 31, 2009 at 3:10 PM, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:

> On Tue, 31 Mar 2009 23:44:37 +0900 (JST), Ryusuke Konishi <
> ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:
>
> Let me add one thing.  Since the bind-mount and original r/w-mount
> share the same device, only one cleanerd is enough for them.  (In
> fact, two cleanerds conflict with one another).  So, we can give over
> the GC functionality to the original mount point without incident.


Just a question; why can't you use single cleaner? It would detect all
mounted partitions and perform needed tasks, maybe in parallel, as needed.


>
> Ryusuke
>

Regards,
Alex

--001636c5b47ed80bf704666ba9bb
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br><div class=3D"gmail_quote">On Tue, Mar 31, 2009 at 3:10 PM, Ryusuke Kon=
ishi <span dir=3D"ltr">&lt;<a href=3D"mailto:ryusuke-sG5X7nlA6pw@public.gmane.org">ryusuke@osrg=
.net</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"bo=
rder-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding=
-left: 1ex;">

<div class=3D"im">On Tue, 31 Mar 2009 23:44:37 +0900 (JST), Ryusuke Konishi=
 &lt;<a href=3D"mailto:ryusuke-sG5X7nlA6pw@public.gmane.org">ryusuke-sG5X7nlA6pw@public.gmane.org</a>&gt; wrote:<br=
>
<br>
</div>Let me add one thing. =A0Since the bind-mount and original r/w-mount<=
br>
share the same device, only one cleanerd is enough for them. =A0(In<br>
fact, two cleanerds conflict with one another). =A0So, we can give over<br>
the GC functionality to the original mount point without incident.</blockqu=
ote><div><br>Just a question; why can&#39;t you use single cleaner? It woul=
d detect all mounted partitions and perform needed tasks, maybe in parallel=
, as needed.<br>

=A0</div><blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid =
rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<font color=3D"#888888"><br>
Ryusuke<br>
</font></blockquote></div><br>Regards,<br>Alex<br>

--001636c5b47ed80bf704666ba9bb--

--===============0680638147==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============0680638147==--
