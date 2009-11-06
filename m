From: Jan de Kruyf <jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [SPAM] Re: urgent help need! disk partition info
	lost
Date: Fri, 6 Nov 2009 22:02:35 +0200
Message-ID: <ee5afd760911061202qeb092c6tc95e305b25f843a@mail.gmail.com>
References: <856033f20911021106u771f823dkb48395958ad83a37@mail.gmail.com>
	<856033f20911041131n54c420fuf16b10fefb343188@mail.gmail.com>
	<ee5afd760911041326g77cab1d9r90f55657dc11a789@mail.gmail.com>
	<856033f20911041719w12410864hdbdb8d5e6aed2070@mail.gmail.com>
	<856033f20911041957n7c88e5afvb60b6de9ee42bce7@mail.gmail.com>
	<ee5afd760911050718t4eca6855kdf70fcc7f2014bf8@mail.gmail.com>
	<856033f20911051002x79461f91o60e07f651a24f7c4@mail.gmail.com>
	<ee5afd760911051211n788e4f36g7f60d06e691817d8@mail.gmail.com>
	<856033f20911060943i35d9cae4rcaf6a6dd12a6d845@mail.gmail.com>
	<debc30fc0911061124r1a13335v61c8df3dffa70c51@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1216337607=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <debc30fc0911061124r1a13335v61c8df3dffa70c51-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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

--===============1216337607==
Content-Type: multipart/alternative; boundary=001485e9a5a03b4f2b0477b95383

--001485e9a5a03b4f2b0477b95383
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Oh du cleveres Kerlchen. What a way to spend a beautiful friday!
Well you were smart after all I must say. And I would like to add that
I have done similar things with ext2 and it was not half as easy. So Nilfs
shines
as far as I am concerned.

And yes I did expect the partially lost file because the faulty superblock
was written after
the superblock at 0x400400.

So let us sign a petition to the Master (Ryusuke are you listening!) to
provide a special mount-flag
for recovery purposes only so the mounting goes on as far as practical with
suitable warnings.
Perhaps you could supply a diff with the changes you made for your case
Paul.

> I guess you're going to make a backup every week from now :)

Nah, he's got friends -- whaddo ye mean . . . .

Regards,

Jan de Kruyf.


On Fri, Nov 6, 2009 at 9:24 PM, J=E9r=F4me Poulin <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>w=
rote:

> On Fri, Nov 6, 2009 at 12:43 PM, Paul L <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > Ok, based on the info so far, I've successfully recovered my files!
> >
> ...
> >
> > 6. Now it seemed no way to proceed, and I decided to try my luck by
> > modifying nilfs_search_super_root(...) function to do a partial check
> > instead of a full check (by changing the flag from 1 to 0). Compiled,
> > installed, and rebooted.
> >
> This is where I'd like to add, the filesystem should always allow to
> mount read-only whatever there is corruption or not, if there is bad
> bad trouble it should mount read-only and ignore the cleanerd, isn't
> that right?
>
> > It then all worked out from there. I immediately plugged in a USB
> > drive, and copied all my files to the backup. Only one file seemed to
> > have been damaged during the incident. I didn't bother to check if all
> > the prevoius checkpoint on the nilfs2 partition worked and just went
> > ahead and re-partitioned and re-formatted the SD card.
> >
> > I must thank Jan de Kruyf for the tremendeous help! Thank you all very
> much!
> >
> > Now I'm just going to celebrate the magical recovery from the loss of
> > months' hard work!
> >
> >
> I guess you're going to make a backup every week from now :)
> _______________________________________________
> users mailing list
> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> https://www.nilfs.org/mailman/listinfo/users
>

--001485e9a5a03b4f2b0477b95383
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Oh du cleveres Kerlchen. What a way to spend a beautiful friday!<br>Well yo=
u were smart after all I must say. And I would like to add that <br>I have =
done similar things with ext2 and it was not half as easy. So Nilfs shines<=
br>
as far as I am concerned.<br><br>And yes I did expect the partially lost fi=
le because the faulty superblock was written after <br>the superblock at 0x=
400400.<br><br>So let us sign a petition to the Master (Ryusuke are you lis=
tening!) to provide a special mount-flag <br>
for recovery purposes only so the mounting goes on as far as practical with=
 suitable warnings.<br>Perhaps you could supply a diff with the changes you=
 made for your case Paul.<br><br>&gt; I guess you&#39;re going to make a ba=
ckup every week from now :)<br>
<br>Nah, he&#39;s got friends -- whaddo ye mean . . . . <br><br>Regards,<br=
><br>Jan de Kruyf.<br><br><br><div class=3D"gmail_quote">On Fri, Nov 6, 200=
9 at 9:24 PM, J=E9r=F4me Poulin <span dir=3D"ltr">&lt;<a href=3D"mailto:jer=
omepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org">jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><div class=3D"im"=
>On Fri, Nov 6, 2009 at 12:43 PM, Paul L &lt;<a href=3D"mailto:ninegua@gmai=
l.com">ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org</a>&gt; wrote:<br>

&gt; Ok, based on the info so far, I&#39;ve successfully recovered my files=
!<br>
&gt;<br>
</div>...<br>
<div class=3D"im">&gt;<br>
&gt; 6. Now it seemed no way to proceed, and I decided to try my luck by<br=
>
&gt; modifying nilfs_search_super_root(...) function to do a partial check<=
br>
&gt; instead of a full check (by changing the flag from 1 to 0). Compiled,<=
br>
&gt; installed, and rebooted.<br>
&gt;<br>
</div>This is where I&#39;d like to add, the filesystem should always allow=
 to<br>
mount read-only whatever there is corruption or not, if there is bad<br>
bad trouble it should mount read-only and ignore the cleanerd, isn&#39;t<br=
>
that right?<br>
<div class=3D"im"><br>
&gt; It then all worked out from there. I immediately plugged in a USB<br>
&gt; drive, and copied all my files to the backup. Only one file seemed to<=
br>
&gt; have been damaged during the incident. I didn&#39;t bother to check if=
 all<br>
&gt; the prevoius checkpoint on the nilfs2 partition worked and just went<b=
r>
&gt; ahead and re-partitioned and re-formatted the SD card.<br>
&gt;<br>
&gt; I must thank Jan de Kruyf for the tremendeous help! Thank you all very=
 much!<br>
&gt;<br>
&gt; Now I&#39;m just going to celebrate the magical recovery from the loss=
 of<br>
&gt; months&#39; hard work!<br>
&gt;<br>
&gt;<br>
</div>I guess you&#39;re going to make a backup every week from now :)<br>
<div><div></div><div class=3D"h5">_________________________________________=
______<br>
users mailing list<br>
<a href=3D"mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org">users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org</a><br>
<a href=3D"https://www.nilfs.org/mailman/listinfo/users" target=3D"_blank">=
https://www.nilfs.org/mailman/listinfo/users</a><br>
</div></div></blockquote></div><br>

--001485e9a5a03b4f2b0477b95383--

--===============1216337607==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1216337607==--
