From: Eric A <eric225125-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: Re: df reports used space gradually growing.
Date: Sun, 26 Jul 2009 10:40:08 -0700 (PDT)
Message-ID: <288232.83823.qm@web58801.mail.re1.yahoo.com>
References: <675178.67834.qm@web58804.mail.re1.yahoo.com>
	<debc30fc0907260905w76ccec51g421ab08ecf3f67bd@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0789649574=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <debc30fc0907260905w76ccec51g421ab08ecf3f67bd-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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

--===============0789649574==
Content-Type: multipart/alternative; boundary="0-1246140788-1248630008=:83823"

--0-1246140788-1248630008=:83823
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

You're right; nilfs_cleanered wasn't running.  I've tried rebooting and it =
still isn't automatically starting.  I'm running 2.6.31-rc4 and nilfs-utils=
-2.0.14.  The following is the relevant fstab line:=0A=0A/dev/sda2         =
      /               nilfs2          rw,noatime              0 0=0A =0A=0A=
I manually started nilfs_cleanered and have been running it for about an ho=
ur.  Conky shows disk read/writes of 1MiB  every 2 seconds or so, but I don=
't see any space being freed up.  In fact, df still reports a gradual filli=
ng of the disk.=0A=0AEric=0A=0A=0A=0A=0A________________________________=0A=
From: J=E9r=F4me Poulin <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>=0ATo: eric225125-/E1597aS9LQAvxtiuMwx3w@public.gmane.org=
=0ACc: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>=0ASent: Sunday, July 26, =
2009 12:05:56 PM=0ASubject: Re: [NILFS users] df reports used space gradual=
ly growing.=0A=0AOn Sun, Jul 26, 2009 at 11:18 AM, Eric A<eric225125@yahoo.=
com> wrote:=0A> I installed nilfs2 on my 32GB SSD for my rootfs about a wee=
k ago and have=0A> been very impressed with the improvements in write speed=
..  However, I just=0A> noticed that df reports I am using 25GB when there i=
s only about 13GB of=0A> data on the disk.  The 13GB size agrees with du an=
d the size of my daily=0A> ext2 backup.  I monitored the situation over nig=
ht, and the size reported by=0A> df appears to be growing by about 1-2GB a =
day.=0A>=0AThis sounds like the nilfs_cleanerd is not running, could you ch=
eck if=0Ait appears in ps output?=0A=0A> Is the size reported by df incorre=
ct?  What will happen when it reports that=0A> the entire disk is full?=0A>=
=0ADepending on the version of NILFS you're using, you may be in trouble,=
=0Aelse, just starting nilfs_cleanerd manually should be able to free up=0A=
all the space.=0A_______________________________________________=0Ausers ma=
iling list=0Ausers-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org=0Ahttps://www.nilfs.org/mailman/listinfo/users=
=0A=0A=0A=0A      
--0-1246140788-1248630008=:83823
Content-Type: text/html; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

<html><head><style type=3D"text/css"><!-- DIV {margin:0px;} --></style></he=
ad><body><div style=3D"font-family:times new roman,new york,times,serif;fon=
t-size:12pt"><div>You're right; nilfs_cleanered wasn't running.&nbsp; I've =
tried rebooting and it still isn't automatically starting.&nbsp; I'm runnin=
g 2.6.31-rc4 and nilfs-utils-2.0.14.&nbsp; The following is the relevant fs=
tab line:<br><br>/dev/sda2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; nilfs2&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rw,noatime&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 0<br>&nbsp;<br></div><div =
style=3D"font-family: times new roman,new york,times,serif; font-size: 12pt=
;">I manually started nilfs_cleanered and have been running it for about an=
 hour.&nbsp; Conky shows disk read/writes of 1MiB&nbsp; every 2 seconds or
 so, but I don't see any space being freed up.&nbsp; In fact, df still repo=
rts a gradual filling of the disk.<br><br>Eric<br><br><br><div style=3D"fon=
t-family: arial,helvetica,sans-serif; font-size: 13px;"><font face=3D"Tahom=
a" size=3D"2"><hr size=3D"1"><b><span style=3D"font-weight: bold;">From:</s=
pan></b> J=E9r=F4me Poulin &lt;jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org&gt;<br><b><span style=
=3D"font-weight: bold;">To:</span></b> eric225125-/E1597aS9LQAvxtiuMwx3w@public.gmane.org<br><b><span sty=
le=3D"font-weight: bold;">Cc:</span></b> NILFS Users mailing list &lt;users=
@nilfs.org&gt;<br><b><span style=3D"font-weight: bold;">Sent:</span></b> Su=
nday, July 26, 2009 12:05:56 PM<br><b><span style=3D"font-weight: bold;">Su=
bject:</span></b> Re: [NILFS users] df reports used space gradually growing=
..<br></font><br>=0AOn Sun, Jul 26, 2009 at 11:18 AM, Eric A&lt;<a ymailto=
=3D"mailto:eric225125-/E1597aS9LQAvxtiuMwx3w@public.gmane.org" href=3D"mailto:eric225125-/E1597aS9LQAvxtiuMwx3w@public.gmane.org">eric2=
25125-/E1597aS9LQAvxtiuMwx3w@public.gmane.org</a>&gt; wrote:<br>&gt; I installed nilfs2 on my 32GB SSD fo=
r my rootfs about a week ago and have<br>&gt; been very impressed with the =
improvements in write speed.&nbsp; However, I just<br>&gt; noticed that df =
reports I am using 25GB when there is only about 13GB of<br>&gt; data on th=
e disk.&nbsp; The 13GB size agrees with du and the size of my daily<br>&gt;=
 ext2 backup.&nbsp; I monitored the situation over night, and the size repo=
rted by<br>&gt; df appears to be growing by about 1-2GB a day.<br>&gt;<br>T=
his sounds like the nilfs_cleanerd is not running, could you check if<br>it=
 appears in ps output?<br><br>&gt; Is the size reported by df incorrect?&nb=
sp; What will happen when it reports that<br>&gt; the entire disk is full?<=
br>&gt;<br>Depending on the version of NILFS you're using, you may be in tr=
ouble,<br>else,
 just starting nilfs_cleanerd manually should be able to free up<br>all the=
 space.<br>_______________________________________________<br>users mailing=
 list<br><a ymailto=3D"mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org" href=3D"mailto:users@nilfs.o=
rg">users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org</a><br><a href=3D"https://www.nilfs.org/mailman/listinf=
o/users" target=3D"_blank">https://www.nilfs.org/mailman/listinfo/users</a>=
<br></div></div></div><br>=0A=0A=0A=0A      </body></html>
--0-1246140788-1248630008=:83823--


--===============0789649574==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============0789649574==--

