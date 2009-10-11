From: Jan de Kruyf <jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cleanerd
Date: Sun, 11 Oct 2009 07:32:50 +0200
Message-ID: <ee5afd760910102232o5f17c50cxb5024f6f76ecbcf5@mail.gmail.com>
References: <ee5afd760910101518u4a85fd0fn6e5539a327b2a876@mail.gmail.com>
	<20091011.122911.131278678.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1564970655=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20091011.122911.131278678.ryusuke-sG5X7nlA6pw@public.gmane.org>
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

--===============1564970655==
Content-Type: multipart/alternative; boundary=00163600d26ce3c5af0475a224cf

--00163600d26ce3c5af0475a224cf
Content-Type: text/plain; charset=ISO-8859-1

Hallo,
Sorry the detail was a little bit scant last night.
The nilfs versions running on the machine at the time of the disaster were
the latest versions.
This is the maintenance hard-drive running, I will update today.

The loop is (as far as I can see now from the logs)
-
-------kern.log-------------------------------------------
Oct 10 06:53:11 debianLenny kernel: [44514.982086] segctord starting.
Construction interval = 5 seconds, CP frequency < 30 seconds
Oct 10 06:53:11 debianLenny kernel: [44515.115227] NILFS warning: mounting
unchecked fs
Oct 10 06:53:11 debianLenny kernel: [44515.398152] NILFS: recovery complete.
Oct 10 06:53:28 debianLenny kernel: [44535.631729] NILFS warning (device
hdb9): nilfs_clean_segments: segment construction failed. (err=-28)
Oct 10 06:53:33 debianLenny kernel: [44542.849960] NILFS warning (device
hdb9): nilfs_clean_segments: segment construction failed. (err=-28)
Oct 10 06:53:38 debianLenny kernel: [44550.592403] NILFS warning (device
hdb9): nilfs_clean_segments: segment construction failed. (err=-28)
---------------------------------------------------------------

this is from the maintenance versions on /dev/hda (still to be updated),
with /dev/hdb not functional.
It will fill up the log until the partition is full.


I will dd the partion into a loop-mountable file once I have updated, so
diagnostics
may continue.

I was aware of this problem before: when you overfill a partition cleanerd
goes into this loop.

The interesting part is: how did cleanerd get confused this time. since the
partition was only half full
and cleanerd was running more or less regularly. I am only aware that I
stopped cleanerd a few times that day with TERM
since it was in the way of other work. It made the /home partition so slow
that I could not write a dvd anymore.
But this is a separate issue.

So I will do a low-level check on the sick disc to check for media format
failures
and I will try to do some log reading over the next few days to see if I can
find
the log of the first mount after the accident.

Regards
Jan de Kruyf.

"Let us sing, the Lord is on his Throne and the earth is full of his Glory."
enjoy the rest of your day.



On Sun, Oct 11, 2009 at 5:29 AM, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:

> Hi,
> On Sun, 11 Oct 2009 00:18:10 +0200, Jan de Kruyf wrote:
> > Hallo,
> > Here is an interesting disaster with nilfs2. Lightening went down the
> > chimney on the other side of the wall. Computer was off, but plugged in.
> > Motherboard died.
> >
> > So I now try to fix partitions. at the moment it is /var. /home will come
> > later.
> >
> > Here is the problem:
> > /var data is readable but the cleanerd has become confused after the
> > disaster and has filled up the partition
> >
> > partition size 5.8 Gig, data size 2.56 Gig, but usage is now 100%
> > Normal mounting:
> > cleanerd cannot be stopped anymore, neither with TERM or KILL signals.
>
> Seems like it went into an infinite loop.
>
> Can you change ``log priority'' written in /etc/nilfs_cleanerd.conf ?
>
> Cleanerd may log additional messages if you change it ``debug'' level:
>
>  log_priority         debug
>
> The syslog is written out to the /var directory, so you should
> mount the /var data on /mnt or other.
>
> > lscp shows only cleaner checkpoints now.
> >
> > When mounting without the cleanerd running there are no dmesg's of
> interest
> > on mounting or on execution of any command
> >
> > To rescue the partition do I copy the data to another disk and reformat?
> Or
> > is there a simpler solution?
>
> Well, I recommend you to upgrade the module to the latest version
> 'v2.0.17' because former versions may cause file system corruption or
> kernel oopses if things turn out bad.  Two maintenance releases were
> made after you pulled nilfs2-module.git.
>
> nilfs-utils also has new version (v2.0.14).
>
> If you will see the same problem for these new versions, maybe you
> should make a backup copy and reformat the partition.
>
> But, I would appreciate it if you could help me to find the cause of
> the busy loop in cleanerd before the reformat.
>
> > Best Regard,
> >
> > Jan de Kruyf.
> > ------------------
>
> Thank you for reporting the issue.
>
> With regards,
> Ryusuke Konishi
>
> > ps.
> >  running debian lenny, kernel 2.6.26-1-686
> >
> > branch 'master' of http://git.nilfs.org/nilfs2-utils  dd. 11 july 2009
> > branch 'master' of http://git.nilfs.org/nilfs2-module  dd. 11 july 2009
> > tag 'v2.0.15'
> >
> > and here is the superblock of the partition:
> >
> >
> > 00000000: 0200 0000 0000 3434 0001 0000 8422 95d1  ......44....."..
> > 00000010: 80b7 90e7 0200 0000 ca02 0000 0000 0000  ................
> > 00000020: 00b4 6665 0100 0000 0100 0000 0000 0000  ..fe............
> > 00000030: 0008 0000 0500 0000 e1e6 1400 0000 0000  ................
> > 00000040: d69f 0d00 0000 0000 c181 0900 0000 0000  ................
> > 00000050: 0000 0000 0000 0000 4815 5a4a 0000 0000  ........H.ZJ....
> > 00000060: 3713 d04a 0000 0000 3713 d04a 0000 0000  7..J....7..J....
> > 00000070: 4000 3200 0000 0100 4815 5a4a 0000 0000  @.2.....H.ZJ....
> > 00000080: 004e ed00 0000 0000 0000 0000 0b00 0000  .N..............
> > 00000090: 8000 2000 c000 1000 470b 1351 09a6 4016  .. .....G..Q..@.
> > 000000a0: 9397 70f2 82f5 d61b 7661 7200 0000 0000  ..p.....var.....
> > 000000b0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
> > 000000c0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
> > 000000d0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
> > 000000e0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
> > 000000f0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
>

--00163600d26ce3c5af0475a224cf
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hallo,<br>Sorry the detail was a little bit scant last night. <br>The nilfs=
 versions running on the machine at the time of the disaster were the lates=
t versions.<br>This is the maintenance hard-drive running, I will update to=
day.<br>
<br>The loop is (as far as I can see now from the logs) <br>-<br>-------ker=
n.log-------------------------------------------<br>Oct 10 06:53:11 debianL=
enny kernel: [44514.982086] segctord starting. Construction interval =3D 5 =
seconds, CP frequency &lt; 30 seconds<br>
Oct 10 06:53:11 debianLenny kernel: [44515.115227] NILFS warning: mounting =
unchecked fs<br>Oct 10 06:53:11 debianLenny kernel: [44515.398152] NILFS: r=
ecovery complete.<br>Oct 10 06:53:28 debianLenny kernel: [44535.631729] NIL=
FS warning (device hdb9): nilfs_clean_segments: segment construction failed=
. (err=3D-28)<br>
Oct 10 06:53:33 debianLenny kernel: [44542.849960] NILFS warning (device hd=
b9): nilfs_clean_segments: segment construction failed. (err=3D-28)<br>Oct =
10 06:53:38 debianLenny kernel: [44550.592403] NILFS warning (device hdb9):=
 nilfs_clean_segments: segment construction failed. (err=3D-28)<br>
---------------------------------------------------------------<br><br>this=
 is from the maintenance versions on /dev/hda (still to be updated), with /=
dev/hdb not functional. <br>It will fill up the log until the partition is =
full.<br>
<br><br>I will dd the partion into a loop-mountable file once I have update=
d, so diagnostics <br>may continue.<br><br>I was aware of this problem befo=
re: when you overfill a partition cleanerd goes into this loop.<br><br>
The interesting part is: how did cleanerd get confused this time. since the=
 partition was only half full<br>and cleanerd was running more or less regu=
larly. I am only aware that I stopped cleanerd a few times that day with TE=
RM <br>
since it was in the way of other work. It made the /home partition so slow =
that I could not write a dvd anymore.<br>But this is a separate issue.<br><=
br>So I will do a low-level check on the sick disc to check for media forma=
t failures<br>
and I will try to do some log reading over the next few days to see if I ca=
n find<br>the log of the first mount after the accident.<br><br>Regards<br>=
Jan de Kruyf.<br><br>&quot;Let us sing, the Lord is on his Throne and the e=
arth is full of his Glory.&quot;<br>
enjoy the rest of your day.<br><br><br><br><div class=3D"gmail_quote">On Su=
n, Oct 11, 2009 at 5:29 AM, Ryusuke Konishi <span dir=3D"ltr">&lt;<a href=
=3D"mailto:ryusuke-sG5X7nlA6pw@public.gmane.org">ryusuke-sG5X7nlA6pw@public.gmane.org</a>&gt;</span> wrote:<br><blo=
ckquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, 204,=
 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Hi,<br>
<div class=3D"im">On Sun, 11 Oct 2009 00:18:10 +0200, Jan de Kruyf wrote:<b=
r>
&gt; Hallo,<br>
&gt; Here is an interesting disaster with nilfs2. Lightening went down the<=
br>
&gt; chimney on the other side of the wall. Computer was off, but plugged i=
n.<br>
&gt; Motherboard died.<br>
&gt;<br>
&gt; So I now try to fix partitions. at the moment it is /var. /home will c=
ome<br>
&gt; later.<br>
&gt;<br>
&gt; Here is the problem:<br>
&gt; /var data is readable but the cleanerd has become confused after the<b=
r>
&gt; disaster and has filled up the partition<br>
&gt;<br>
&gt; partition size 5.8 Gig, data size 2.56 Gig, but usage is now 100%<br>
&gt; Normal mounting:<br>
&gt; cleanerd cannot be stopped anymore, neither with TERM or KILL signals.=
<br>
<br>
</div>Seems like it went into an infinite loop.<br>
<br>
Can you change ``log priority&#39;&#39; written in /etc/nilfs_cleanerd.conf=
 ?<br>
<br>
Cleanerd may log additional messages if you change it ``debug&#39;&#39; lev=
el:<br>
<br>
 =A0log_priority =A0 =A0 =A0 =A0 debug<br>
<br>
The syslog is written out to the /var directory, so you should<br>
mount the /var data on /mnt or other.<br>
<div class=3D"im"><br>
&gt; lscp shows only cleaner checkpoints now.<br>
&gt;<br>
&gt; When mounting without the cleanerd running there are no dmesg&#39;s of=
 interest<br>
&gt; on mounting or on execution of any command<br>
&gt;<br>
&gt; To rescue the partition do I copy the data to another disk and reforma=
t? Or<br>
&gt; is there a simpler solution?<br>
<br>
</div>Well, I recommend you to upgrade the module to the latest version<br>
&#39;v2.0.17&#39; because former versions may cause file system corruption =
or<br>
kernel oopses if things turn out bad. =A0Two maintenance releases were<br>
made after you pulled nilfs2-module.git.<br>
<br>
nilfs-utils also has new version (v2.0.14).<br>
<br>
If you will see the same problem for these new versions, maybe you<br>
should make a backup copy and reformat the partition.<br>
<br>
But, I would appreciate it if you could help me to find the cause of<br>
the busy loop in cleanerd before the reformat.<br>
<div class=3D"im"><br>
&gt; Best Regard,<br>
&gt;<br>
&gt; Jan de Kruyf.<br>
&gt; ------------------<br>
<br>
</div>Thank you for reporting the issue.<br>
<br>
With regards,<br>
<font color=3D"#888888">Ryusuke Konishi<br>
</font><div><div></div><div class=3D"h5"><br>
&gt; ps.<br>
&gt; =A0running debian lenny, kernel 2.6.26-1-686<br>
&gt;<br>
&gt; branch &#39;master&#39; of <a href=3D"http://git.nilfs.org/nilfs2-util=
s" target=3D"_blank">http://git.nilfs.org/nilfs2-utils</a> =A0dd. 11 july 2=
009<br>
&gt; branch &#39;master&#39; of <a href=3D"http://git.nilfs.org/nilfs2-modu=
le" target=3D"_blank">http://git.nilfs.org/nilfs2-module</a> =A0dd. 11 july=
 2009<br>
&gt; tag &#39;v2.0.15&#39;<br>
&gt;<br>
&gt; and here is the superblock of the partition:<br>
&gt;<br>
&gt;<br>
&gt; 00000000: 0200 0000 0000 3434 0001 0000 8422 95d1 =A0......44.....&quo=
t;..<br>
&gt; 00000010: 80b7 90e7 0200 0000 ca02 0000 0000 0000 =A0................<=
br>
&gt; 00000020: 00b4 6665 0100 0000 0100 0000 0000 0000 =A0..fe............<=
br>
&gt; 00000030: 0008 0000 0500 0000 e1e6 1400 0000 0000 =A0................<=
br>
&gt; 00000040: d69f 0d00 0000 0000 c181 0900 0000 0000 =A0................<=
br>
&gt; 00000050: 0000 0000 0000 0000 4815 5a4a 0000 0000 =A0........H.ZJ....<=
br>
&gt; 00000060: 3713 d04a 0000 0000 3713 d04a 0000 0000 =A07..J....7..J....<=
br>
&gt; 00000070: 4000 3200 0000 0100 4815 5a4a 0000 0000 =A0@.2.....H.ZJ....<=
br>
&gt; 00000080: 004e ed00 0000 0000 0000 0000 0b00 0000 =A0.N..............<=
br>
&gt; 00000090: 8000 2000 c000 1000 470b 1351 09a6 4016 =A0.. .....G..Q..@.<=
br>
&gt; 000000a0: 9397 70f2 82f5 d61b 7661 7200 0000 0000 =A0..p.....var.....<=
br>
&gt; 000000b0: 0000 0000 0000 0000 0000 0000 0000 0000 =A0................<=
br>
&gt; 000000c0: 0000 0000 0000 0000 0000 0000 0000 0000 =A0................<=
br>
&gt; 000000d0: 0000 0000 0000 0000 0000 0000 0000 0000 =A0................<=
br>
&gt; 000000e0: 0000 0000 0000 0000 0000 0000 0000 0000 =A0................<=
br>
&gt; 000000f0: 0000 0000 0000 0000 0000 0000 0000 0000 =A0................<=
br>
</div></div></blockquote></div><br>

--00163600d26ce3c5af0475a224cf--

--===============1564970655==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1564970655==--
