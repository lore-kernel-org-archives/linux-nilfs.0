From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Nilfs features
Date: Fri, 29 May 2009 23:44:15 -0400
Message-ID: <debc30fc0905292044r311a2842j53832195d0ef88bd@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1915544192=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

--===============1915544192==
Content-Type: multipart/alternative; boundary=0016e64ec8fcfe8c62046b190250

--0016e64ec8fcfe8c62046b190250
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>
> No, not demanding anything. Requesting it as a feature. While your
> design has a very crucial use-case of constant checkpointing, there is
>
> also a use-case to *suspend* checkpointing (or enable it on demand
> only). As mentioned in my previous example, when restoring to a
> filesystem, or even installing new software, it is extremely unlikely
> that you would want a to go back to a point *inbetween* the time you
>
> started the install/restore to the time it completed. Say for example
> you are installing a new version of Openoffice which installs
>
> home:/opt/openoffice.org$ find . ! -type d |wc -l
>
> 4100
>
> 4000 odd files. For sure if the software didn't work, crashed, was
> buggy, i would go back completely to the pre-install state and would
> never need any intervening checkpoint. In this case i would suspend
>
> checkpointing before installing (which may by default create a
> snapshot), and then i'd restart the constant checkpointing after i'd
> finished the install/restore. Please note, i am not comparing nilfs to
> zfs, but zfs doesn't have constant cp (i think) but does have the
>
> feature i mention, i.e you take snapshots when needed (perhaps via a
> cron job daily, monthly, weekly)
>
> I just want to give my though on this one, keeping checkpoints as-is seems
ideal to me, in this case you have a very granular way to go back in time,
however, what you say is right, when installing a new software for example,
it's nice to have a way to get back to it, I guess in this case you would
just convert the last checkpoint to snapshot before the installation so you
have a time mark of where to rollback (and of course have a steady state
which won't go away during the installation), right?

--0016e64ec8fcfe8c62046b190250
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<blockquote style=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt=
 0pt 0pt 0.8ex; padding-left: 1ex;" class=3D"gmail_quote"><pre>No, not dema=
nding anything. Requesting it as a feature. While your<br>design has a very=
 crucial use-case of constant checkpointing, there is<br>

also a use-case to *suspend* checkpointing (or enable it on demand<br>only)=
. As mentioned in my previous example, when restoring to a<br>filesystem, o=
r even installing new software, it is extremely unlikely<br>that you would =
want a to go back to a point *inbetween* the time you<br>

started the install/restore to the time it completed. Say for example<br>yo=
u are installing a new version of Openoffice which installs<br><br>home:/op=
t/<a href=3D"http://openoffice.org">openoffice.org</a>$ find . ! -type d |w=
c -l<br>

4100<br><br>4000 odd files. For sure if the software didn&#39;t work, crash=
ed, was<br>buggy, i would go back completely to the pre-install state and w=
ould<br>never need any intervening checkpoint. In this case i would suspend=
<br>

checkpointing before installing (which may by default create a<br>snapshot)=
, and then i&#39;d restart the constant checkpointing after i&#39;d<br>fini=
shed the install/restore. Please note, i am not comparing nilfs to<br>
zfs, but zfs doesn&#39;t have constant cp (i think) but does have the<br>
feature i mention, i.e you take snapshots when needed (perhaps via a<br>cro=
n job daily, monthly, weekly)</pre></blockquote><div>I just want to give my=
 though on this one, keeping checkpoints as-is seems ideal to me, in this c=
ase you have a very granular way to go back in time, however, what you say =
is right, when installing a new software for example, it&#39;s nice to have=
 a way to get back to it, I guess in this case you would just convert the l=
ast checkpoint to snapshot before the installation so you have a time mark =
of where to rollback (and of course have a steady state which won&#39;t go =
away during the installation), right? <br>

</div>

--0016e64ec8fcfe8c62046b190250--

--===============1915544192==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1915544192==--
