From: Jan de Kruyf <jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: urgent help need! disk partition info lost
Date: Tue, 3 Nov 2009 20:14:22 +0200
Message-ID: <ee5afd760911031014l5bd4899ble3b6522e758bfb8d@mail.gmail.com>
References: <856033f20911021106u771f823dkb48395958ad83a37@mail.gmail.com>
	<ee5afd760911021138p25f34ca4gcb66547812cb858e@mail.gmail.com>
	<856033f20911021320w68e11498w4d5619ce5d586e80@mail.gmail.com>
	<856033f20911021527j3dbe86bcy37e9da592e1f0d5d@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0649585297=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <856033f20911021527j3dbe86bcy37e9da592e1f0d5d-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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

--===============0649585297==
Content-Type: multipart/alternative; boundary=0014852e1ed4aec7b804777b7641

--0014852e1ed4aec7b804777b7641
Content-Type: text/plain; charset=ISO-8859-1

 hallo,
Almost sounds like you had only the root master-boot-record /dev/mmcblk0
before and now you have added 1 main partition /dev/mmcblk0p1.

If (and only if) that is the case we have to undo the the 1st partition +
check that no nilfs is overwritten.
and I would have to urgently study fdisk to see exactly what it writes when
and where.
The last time I did tricks like these is quit a few years ago.

It is the Linux version of fdisk is it??

So here is the plan of action:
hexdump the master boot record to file.
like this:

dd if=/dev/mmcblk0 of=backup-mmcblk0.mbr count=1 bs=512

then dump any partitions of the device in a format useful as input to
sfdisk. For example,
                  % sfdisk -d /dev/mmcblk0  > mmcblk0 .out
sfdisk is a tool provided with the util-linux
package<http://www.kernel.org/pub/linux/utils/util-linux/>.


or you could use hexdump to get machine readable or man readable images.
Here is the man readable version:
hd -n512 /dev/mmcblk0 > backup-mmcblk0.mbr
hd -n512 /dev/mmcblk0p1 >backup-mmcblk0p1.mbr
etc.

By the way boor records always end with '55 AA'.

Keep your files in a safe place in case we mess something we can at least go
back to the present situation.
If you could dd the whole drive to a file, now that would be magic indeed!
but you must have the space on a harddrive.
count=... is the number of sectors in the above line (dd ...) that you dump
to file.
Hexedit will tell you the number of sectors is you start it with -s option
and then go to the last sector.
DONT stop hexedit with control-x use cntl-c.
DONT use high level or even midlevel tools on a stuffed disk, it normally
messes more than it solves.
unless of course you really,really know what you are doing.
Fiddling the bytes is in general safe and gives results, if a man keeps a
cool head.

Please send me the fdisk version, the size of the card, and the mbr dump to
feast my eyes on.

cheers,

Jan de kruyf.



On Tue, Nov 3, 2009 at 1:27 AM, Paul L <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> just want to add that I've always been using 1 partition on this
> device, it's actually /dev/mmcblk0p1. But hexedit /dev/mmcblk0p1
> doesn't show that 34 34 at line begining with 0x400, only hexedit
> /dev/mmcblk0 shows it. Not sure if this is a problem.
>
> Any help is greatly appreciated!
>
>
> On 11/2/09, Paul L <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > Thanks for the tips. When I first used the SD card, I used fdisk to
> > create the partition.
> >
> > The device is /dev/mmcblk0, and hexedit -d -s /dev/mmcblk0 shows that
> > at the line 0x0400, it is indeed 34 34. What should I do then?
> >
> > I tried gparted, but apparently it has no support for nilfs2.
> >
> > Regards,
> > Paul Liu
> >
> > On 11/2/09, Jan de Kruyf <jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >> Did you first format this card with fdisk?
> >> did you give it the exact same info this time around?
> >>
> >> Can you read /dev/'sdcard' ? (sdcard being the device in the dev
> >> directory
> >> where the card lives)
> >>
> >> If yes can you run hexedit -s /dev/sdcard1  in a terminal as root?
> >> and go to address 0400 - 04B0 to see if nilfs still exists?
> >>
> >> be very careful no to save any data in hexedit, it will definitely and
> >> finally
> >> destoy your data.
> >>
> >> 0400 looks vagely like this:
> >> 00000400   02 00 00 00 00 00 34 34  00 01 00 00 D3 56 F0 B9
> >> ......44.....V..
> >> 00000410   39 BF D9 73 02 00 00 00  CA 02 00 00 00 00 00 00
> >> 9..s............
> >> 00000420   00 B4 66 65 01 00 00 00  01 00 00 00 00 00 00 00
> >> ..fe............
> >> 00000430   00 08 00 00 05 00 00 00  01 00 00 00 00 00 00 00
> >> ................
> >> 00000440   01 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> >> ................
> >> 00000450   00 48 16 00 00 00 00 00  73 95 DC 4A 00 00 00 00
> >> .H......s..J....
> >> 00000460   00 00 00 00 00 00 00 00  73 95 DC 4A 00 00 00 00
> >> ........s..J....
> >> 00000470   00 00 32 00 01 00 01 00  73 95 DC 4A 00 00 00 00
> >> ..2.....s..J....
> >> 00000480   00 4E ED 00 00 00 00 00  00 00 00 00 0B 00 00 00
> >> .N..............
> >> 00000490   80 00 20 00 C0 00 10 00  4C 73 DD 3D 01 EC 45 85  ..
> >> .....Ls.=..E.
> >> 000004A0   94 28 44 42 3D F6 EF EC  56 61 72 36 34 00 00 00
> >> .(DB=...Var64...
> >> 000004B0   00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> >> ................
> >> 000004C0   00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> >> ................
> >>
> >> the 34 34 in the top line say this is nilfs.
> >>
> >>
> >> cheers
> >>
> >> jan de kruyf
> >>
> >>
> >>
> >>
> >> On Mon, Nov 2, 2009 at 9:06 PM, Paul L <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >>
> >>> Due to some careless handling of my laptop, the SD card popped out
> >>> when the machine is still running. When I put it back in and reboot
> >>> the machine, it says "partition table error". I then ran fdisk and
> >>> recreated the single partition. Then I can no longer mount the nilfs2
> >>> partition that was on the SD card!
> >>>
> >>> Can any one help to me recover the file system? I believe all data are
> >>> still there, but just some bits and pieces are missing for the mount
> >>> to work. Any help is greatly appreciated!
> >>>
> >>> PS: I've a deadline to meet in 4 hours, not sure if I can get my stuff
> >>> back in time... so help please!
> >>>
> >>> --
> >>> Regards,
> >>> Paul Liu
> >>>
> >>> Yale Haskell Group
> >>> http://www.haskell.org/yale
> >>> _______________________________________________
> >>> users mailing list
> >>> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> >>> https://www.nilfs.org/mailman/listinfo/users
> >>>
> >>
> >
> >
> > --
> > Regards,
> > Paul Liu
> >
> > Yale Haskell Group
> > http://www.haskell.org/yale
> >
>
>
> --
> Regards,
> Paul Liu
>
> Yale Haskell Group
> http://www.haskell.org/yale
> _______________________________________________
> users mailing list
> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> https://www.nilfs.org/mailman/listinfo/users
>

--0014852e1ed4aec7b804777b7641
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

=A0hallo,<br>Almost sounds like you had only the root master-boot-record /d=
ev/mmcblk0 before and now you have added 1 main partition /dev/mmcblk0p1.<b=
r><br>If (and only if) that is the case we have to undo the the 1st partiti=
on + check that no nilfs is overwritten.<br>
and I would have to urgently study fdisk to see exactly what it writes when=
 and where. <br>The last time I did tricks like these is quit a few years a=
go.<br><br>It is the Linux version of fdisk is it??<br><br>So here is the p=
lan of action:<br>
hexdump the master boot record to file.<br>like this:<br><pre>dd if=3D/dev/=
mmcblk0 of=3Dbackup-mmcblk0.mbr count=3D1 bs=3D512<br></pre>then dump any p=
artitions of the device in a format useful as input to sfdisk. For example,=
<br>
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 % sfdisk -d /dev/mmcblk=
0=A0 &gt; mmcblk0
.out<br>sfdisk is a tool provided with the <a href=3D"http://www.kernel.org=
/pub/linux/utils/util-linux/" class=3D"external text" title=3D"http://www.k=
ernel.org/pub/linux/utils/util-linux/" rel=3D"nofollow">util-linux package<=
/a>.
<br><br>or you could use hexdump to get machine readable or man readable im=
ages. Here is the man readable version:<br>hd -n512 /dev/mmcblk0 &gt; backu=
p-mmcblk0.mbr<br>hd -n512 /dev/mmcblk0p1 &gt;backup-mmcblk0p1.mbr<br>etc.<b=
r>
<br>By the way boor records always end with &#39;55 AA&#39;.<br><br>Keep yo=
ur files in a safe place in case we mess something we can at least go back =
to the present situation.<br>If you could dd the whole drive to a file, now=
 that would be magic indeed! but you must have the space on a harddrive.<br=
>
count=3D... is the number of sectors in the above line (dd ...) that you du=
mp to file.<br>Hexedit will tell you the number of sectors is you start it =
with -s option and then go to the last sector.<br>DONT stop hexedit with co=
ntrol-x use cntl-c.<br>
DONT use high level or even midlevel tools on a stuffed disk, it normally m=
esses more than it solves.<br>unless of course you really,really know what =
you are doing.<br>Fiddling the bytes is in general safe and gives results, =
if a man keeps a cool head.<br>
<br>Please send me the fdisk version, the size of the card, and the mbr dum=
p to feast my eyes on.<br><br>cheers,<br><br>Jan de kruyf.<br>=A0=A0 <br><b=
r><br><div class=3D"gmail_quote">On Tue, Nov 3, 2009 at 1:27 AM, Paul L <sp=
an dir=3D"ltr">&lt;<a href=3D"mailto:ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org">ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org</=
a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">just want to add =
that I&#39;ve always been using 1 partition on this<br>
device, it&#39;s actually /dev/mmcblk0p1. But hexedit /dev/mmcblk0p1<br>
doesn&#39;t show that 34 34 at line begining with 0x400, only hexedit<br>
/dev/mmcblk0 shows it. Not sure if this is a problem.<br>
<div class=3D"im"><br>
Any help is greatly appreciated!<br>
<br>
<br>
</div><div><div></div><div class=3D"h5">On 11/2/09, Paul L &lt;<a href=3D"m=
ailto:ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org">ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org</a>&gt; wrote:<br>
&gt; Thanks for the tips. When I first used the SD card, I used fdisk to<br=
>
&gt; create the partition.<br>
&gt;<br>
&gt; The device is /dev/mmcblk0, and hexedit -d -s /dev/mmcblk0 shows that<=
br>
&gt; at the line 0x0400, it is indeed 34 34. What should I do then?<br>
&gt;<br>
&gt; I tried gparted, but apparently it has no support for nilfs2.<br>
&gt;<br>
&gt; Regards,<br>
&gt; Paul Liu<br>
&gt;<br>
&gt; On 11/2/09, Jan de Kruyf &lt;<a href=3D"mailto:jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org"=
>jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org</a>&gt; wrote:<br>
&gt;&gt; Did you first format this card with fdisk?<br>
&gt;&gt; did you give it the exact same info this time around?<br>
&gt;&gt;<br>
&gt;&gt; Can you read /dev/&#39;sdcard&#39; ? (sdcard being the device in t=
he dev<br>
&gt;&gt; directory<br>
&gt;&gt; where the card lives)<br>
&gt;&gt;<br>
&gt;&gt; If yes can you run hexedit -s /dev/sdcard1 =A0in a terminal as roo=
t?<br>
&gt;&gt; and go to address 0400 - 04B0 to see if nilfs still exists?<br>
&gt;&gt;<br>
&gt;&gt; be very careful no to save any data in hexedit, it will definitely=
 and<br>
&gt;&gt; finally<br>
&gt;&gt; destoy your data.<br>
&gt;&gt;<br>
&gt;&gt; 0400 looks vagely like this:<br>
&gt;&gt; 00000400 =A0 02 00 00 00 00 00 34 34 =A000 01 00 00 D3 56 F0 B9<br=
>
&gt;&gt; ......44.....V..<br>
&gt;&gt; 00000410 =A0 39 BF D9 73 02 00 00 00 =A0CA 02 00 00 00 00 00 00<br=
>
&gt;&gt; 9..s............<br>
&gt;&gt; 00000420 =A0 00 B4 66 65 01 00 00 00 =A001 00 00 00 00 00 00 00<br=
>
&gt;&gt; ..fe............<br>
&gt;&gt; 00000430 =A0 00 08 00 00 05 00 00 00 =A001 00 00 00 00 00 00 00<br=
>
&gt;&gt; ................<br>
&gt;&gt; 00000440 =A0 01 00 00 00 00 00 00 00 =A000 00 00 00 00 00 00 00<br=
>
&gt;&gt; ................<br>
&gt;&gt; 00000450 =A0 00 48 16 00 00 00 00 00 =A073 95 DC 4A 00 00 00 00<br=
>
&gt;&gt; .H......s..J....<br>
&gt;&gt; 00000460 =A0 00 00 00 00 00 00 00 00 =A073 95 DC 4A 00 00 00 00<br=
>
&gt;&gt; ........s..J....<br>
&gt;&gt; 00000470 =A0 00 00 32 00 01 00 01 00 =A073 95 DC 4A 00 00 00 00<br=
>
&gt;&gt; ..2.....s..J....<br>
&gt;&gt; 00000480 =A0 00 4E ED 00 00 00 00 00 =A000 00 00 00 0B 00 00 00<br=
>
&gt;&gt; .N..............<br>
&gt;&gt; 00000490 =A0 80 00 20 00 C0 00 10 00 =A04C 73 DD 3D 01 EC 45 85 =
=A0..<br>
&gt;&gt; .....Ls.=3D..E.<br>
&gt;&gt; 000004A0 =A0 94 28 44 42 3D F6 EF EC =A056 61 72 36 34 00 00 00<br=
>
&gt;&gt; .(DB=3D...Var64...<br>
&gt;&gt; 000004B0 =A0 00 00 00 00 00 00 00 00 =A000 00 00 00 00 00 00 00<br=
>
&gt;&gt; ................<br>
&gt;&gt; 000004C0 =A0 00 00 00 00 00 00 00 00 =A000 00 00 00 00 00 00 00<br=
>
&gt;&gt; ................<br>
&gt;&gt;<br>
&gt;&gt; the 34 34 in the top line say this is nilfs.<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; cheers<br>
&gt;&gt;<br>
&gt;&gt; jan de kruyf<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; On Mon, Nov 2, 2009 at 9:06 PM, Paul L &lt;<a href=3D"mailto:nineg=
ua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org">ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org</a>&gt; wrote:<br>
&gt;&gt;<br>
&gt;&gt;&gt; Due to some careless handling of my laptop, the SD card popped=
 out<br>
&gt;&gt;&gt; when the machine is still running. When I put it back in and r=
eboot<br>
&gt;&gt;&gt; the machine, it says &quot;partition table error&quot;. I then=
 ran fdisk and<br>
&gt;&gt;&gt; recreated the single partition. Then I can no longer mount the=
 nilfs2<br>
&gt;&gt;&gt; partition that was on the SD card!<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; Can any one help to me recover the file system? I believe all =
data are<br>
&gt;&gt;&gt; still there, but just some bits and pieces are missing for the=
 mount<br>
&gt;&gt;&gt; to work. Any help is greatly appreciated!<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; PS: I&#39;ve a deadline to meet in 4 hours, not sure if I can =
get my stuff<br>
&gt;&gt;&gt; back in time... so help please!<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; --<br>
&gt;&gt;&gt; Regards,<br>
&gt;&gt;&gt; Paul Liu<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; Yale Haskell Group<br>
&gt;&gt;&gt; <a href=3D"http://www.haskell.org/yale" target=3D"_blank">http=
://www.haskell.org/yale</a><br>
&gt;&gt;&gt; _______________________________________________<br>
&gt;&gt;&gt; users mailing list<br>
&gt;&gt;&gt; <a href=3D"mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org">users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org</a><br>
&gt;&gt;&gt; <a href=3D"https://www.nilfs.org/mailman/listinfo/users" targe=
t=3D"_blank">https://www.nilfs.org/mailman/listinfo/users</a><br>
&gt;&gt;&gt;<br>
&gt;&gt;<br>
&gt;<br>
&gt;<br>
&gt; --<br>
&gt; Regards,<br>
&gt; Paul Liu<br>
&gt;<br>
&gt; Yale Haskell Group<br>
&gt; <a href=3D"http://www.haskell.org/yale" target=3D"_blank">http://www.h=
askell.org/yale</a><br>
&gt;<br>
<br>
<br>
</div></div>--<br>
<div><div></div><div class=3D"h5">Regards,<br>
Paul Liu<br>
<br>
Yale Haskell Group<br>
<a href=3D"http://www.haskell.org/yale" target=3D"_blank">http://www.haskel=
l.org/yale</a><br>
_______________________________________________<br>
users mailing list<br>
<a href=3D"mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org">users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org</a><br>
<a href=3D"https://www.nilfs.org/mailman/listinfo/users" target=3D"_blank">=
https://www.nilfs.org/mailman/listinfo/users</a><br>
</div></div></blockquote></div><br>

--0014852e1ed4aec7b804777b7641--

--===============0649585297==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============0649585297==--
