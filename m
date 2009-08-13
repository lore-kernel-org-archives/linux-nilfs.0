From: Zhang Qiang <zhangqiang.buaa-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [SPAM] installation/getting started issues on
	SLES 11
Date: Thu, 13 Aug 2009 09:32:25 +0800
Message-ID: <871d267c0908121832mcabe0b9ub9cdf8fbb8117f0c@mail.gmail.com>
References: <80225669DEC80D488C4A0B5150466E1802BB39E7@dekomplm002.net.plm.eds.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0534393889=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <80225669DEC80D488C4A0B5150466E1802BB39E7-q6sIb7dcTNEDs3eufgyKiYGWD8NUZu9dQQ4Iyu8u01E@public.gmane.org>
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

--===============0534393889==
Content-Type: multipart/alternative; boundary=000e0cd254f2751e750470fbe80a

--000e0cd254f2751e750470fbe80a
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hi,
Have you install the nilfs2 kernel module[nilfs2.ko].

This error info seems show that the nilfs2 filesystem type have not
registered on your system, and you should do 'insmod nilfs2.ko'.  Is this
module included in nilfs-kmp-default-2.0.15_2.6.

27.19_5-2.1.x86_64.rpm?

Expect this info can help you.

-Regards
-Qiang


2009/8/12 Barham, David <david.barham-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>

>  I=92ve just downloaded and installed the RPMs for SLES 11 from opensuse.=
org
> .
>
> I=92ve successfully installed
> nilfs-kmp-default-2.0.15_2.6.27.19_5-2.1.x86_64.rpm and
> nilfs-utils-2.0.14-4.2.x86_64.rpm.
>
>
>
> These installed with no error.
>
>
>
> Mkfs appears to work without error.
>
>
>
> # mkfs -t nilfs2 /dev/sdb
>
> mkfs.nilfs2 ver 2.0
>
> Start writing file system initial data to the device
>
>        Blocksize:4096  Device:/dev/sdb  Device Size:1500301910016
>
> File system initialization succeeded !!
>
>
>
> But when I tried to mount the filesystem I get
>
>
>
> # mount -t nilfs2 /dev/sdb /data1
>
> mount.nilfs2: WARNING! - The NILFS on-disk format may change at any time.
>
> mount.nilfs2: WARNING! - Do not place critical data on a NILFS filesystem=
.
>
> mount.nilfs2: cannot find or load nilfs2 filesystem
>
>
>
> Any ideas? I can see an /sbin/mount.nilfs2 and all the other files I woul=
d
> expect.
>
>
>
> Is this a terrible newbie misunderstanding?
>
> What am I doing wrong?
>
> Am I missing some other vital rpm?
>
>
>
> Thanks
>
> David Barham
>
>
>
> _______________________________________________
> users mailing list
> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> https://www.nilfs.org/mailman/listinfo/users
>
>

--000e0cd254f2751e750470fbe80a
Content-Type: text/html; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hi,<br>Have you install the nilfs2 kernel module[nilfs2.ko].<br><br>This er=
ror info seems show that the nilfs2 filesystem type have not registered on =
your system, and you should do &#39;insmod nilfs2.ko&#39;.=A0 Is this modul=
e included in nilfs-kmp-default-2.0.15_2.6.<p>
27.19_5-2.1.x86_64.rpm?</p><br>Expect this info can help you.<br><br>-Regar=
ds<br>-Qiang<br><br><br><div class=3D"gmail_quote">2009/8/12 Barham, David =
<span dir=3D"ltr">&lt;<a href=3D"mailto:david.barham-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org">david.bar=
ham-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org</a>&gt;</span><br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">








<div link=3D"blue" vlink=3D"purple" lang=3D"EN-GB">

<div>

<p>I=92ve just downloaded and installed the RPMs for SLES
11 from <a href=3D"http://opensuse.org" target=3D"_blank">opensuse.org</a>.=
</p>

<p>I=92ve successfully installed nilfs-kmp-default-2.0.15_2.6.27.19_5-2.1.x=
86_64.rpm
and nilfs-utils-2.0.14-4.2.x86_64.rpm.</p>

<p>=A0</p>

<p>These installed with no error.</p>

<p>=A0</p>

<p>Mkfs appears to work without error.</p>

<p>=A0</p>

<p># mkfs -t nilfs2 /dev/sdb</p>

<p>mkfs.nilfs2 ver 2.0</p>

<p>Start writing file system initial data to the device</p>

<p>=A0=A0=A0=A0=A0=A0 Blocksize:4096=A0
Device:/dev/sdb=A0 Device Size:1500301910016</p>

<p>File system initialization succeeded !!</p>

<p>=A0</p>

<p>But when I tried to mount the filesystem I get</p>

<p>=A0</p>

<p># mount -t nilfs2 /dev/sdb /data1</p>

<p>mount.nilfs2: WARNING! - The NILFS on-disk format may change
at any time.</p>

<p>mount.nilfs2: WARNING! - Do not place critical data on a
NILFS filesystem.</p>

<p>mount.nilfs2: cannot find or load nilfs2 filesystem</p>

<p>=A0</p>

<p>Any ideas? I can see an /sbin/mount.nilfs2 and all the other
files I would expect.</p>

<p>=A0</p>

<p>Is this a terrible newbie misunderstanding? </p>

<p>What am I doing wrong? </p>

<p>Am I missing some other vital rpm?</p>

<p>=A0</p>

<p>Thanks</p>

<p>David Barham</p>

<p>=A0</p>

</div>

</div>


<br>_______________________________________________<br>
users mailing list<br>
<a href=3D"mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org">users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org</a><br>
<a href=3D"https://www.nilfs.org/mailman/listinfo/users" target=3D"_blank">=
https://www.nilfs.org/mailman/listinfo/users</a><br>
<br></blockquote></div><br>

--000e0cd254f2751e750470fbe80a--

--===============0534393889==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============0534393889==--
