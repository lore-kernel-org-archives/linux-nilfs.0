From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Segment magic number invalid
Date: Mon, 17 May 2010 16:26:14 +0900 (JST)
Message-ID: <20100517.162614.107743625.ryusuke@osrg.net>
References: <AANLkTimHvMze3B8fQE383WW8WLbOYcZx0pz0sfjC2DhJ@mail.gmail.com>
	<20100517.114657.112904526.ryusuke@osrg.net>
	<AANLkTimfmJU5h4pS23eKpjLNV_c6d4YEBHNmBdcy-r4g@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimfmJU5h4pS23eKpjLNV_c6d4YEBHNmBdcy-r4g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-8859-1"
To: ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Mon, 17 May 2010 00:14:59 -0400, Paul L wrote:
> Wow, that does the trick! Here is the output after I change the numbe=
r to 500.
>=20
> Super-block:
>     revision =3D 2.0
>     blocksize =3D 4096
>     write time =3D 2010-05-14 13:58:33
>     indicated log: blocknr =3D 1608334
>         segnum =3D 785, seq =3D 307637, cno=3D671100
>=20
> Clean FS.
> The latest log is lost. Trying rollback recovery..
> ...................
> Searching the latest checkpoint.
> Selected log: blocknr =3D 1304576
>     segnum =3D 637, seq =3D 307489, cno=3D670854
>     creation time =3D 2010-05-14 09:48:18
> Do you wish to overwrite super block (y/N)? y
> Recovery will complete on mount.
>=20
> I then mount /home, and things seem to work fine! Can I be sure that
> everything will be ok from now on? Or should I backup and reformat?
> Thanks!

That was good!=20

I recommend you to backup just now and reformat the partition since
the recovered filesystem rewound logs and may contain broken blocks
that GC later overrode.  (If you were suspending GC, the filesystem is
guranteed to be consistent.)

It may be clean, but the fsck tool doesn't yet support sanity check.

> Actually, I now wonder what could have gone wrong in my case. I wasn'=
t
> doing any disk intensive task and the machine wasn't suspended to ram
> during the course.

This problem can happen if the block device doesn't support "write
barrier" properly.  Unfortunately, such devices are not uncommon even
now.

I feel we should do something for it.

> On a separate note, I noticed that Nilfs2 has a higher chance of
> corruption when I mount over (a slightly sluggish) network. My backup
> plan is also using Nilfs2, as detailed in this web page:
>=20
>   http://www.thev.net/PaulLiu/backup-plan.html
>=20
> I rarely had any problem doing it over a USB hard drive, but when I
> remotely mount the backup image from a SMBFS over the network, I ran
> into problems of dangling nilfs_cleanerd, or just simply corrupted
> Nilfs2 partition for quite a few times, till the point that I reverte=
d
> back to a local USB drive. Maybe this kind of use case can help you
> guys debugging the code and make it more robust. Just a wishful
> thought!

Thanks for the information.  Looks helpful for debugging.

Thanks,
Ryusuke Konishi

> On Sun, May 16, 2010 at 10:46 PM, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> =
wrote:
> > Hi,
> > On Sun, 16 May 2010 14:32:05 -0400, Paul L wrote:
> >> Sorry, should have sent it to the list instead.
> >>
> >> =A0Thanks for the patch! I tried it, but seems it still can't find=
 the
> >> =A0super root. Here is the output. What shall I do now?
> >>
> >> =A0Super-block:
> >> =A0 =A0 =A0revision =3D 2.0
> >> =A0 =A0 =A0blocksize =3D 4096
> >> =A0 =A0 =A0write time =3D 2010-05-14 13:58:33
> >> =A0 =A0 =A0indicated log: blocknr =3D 1608334
> >> =A0 =A0 =A0 =A0 =A0segnum =3D 785, seq =3D 307637, cno=3D671100
> >>
> >> =A0Clean FS.
> >> =A0The latest log is lost. Trying rollback recovery..
> >> =A0.......
> >> =A0fsck0.nilfs2: Cannot find super root
> >
> > Can you try increasing the number defined at the following line in
> > sbin/fsck/fsck0.nilfs2.c ?
> >
> > =A0#define =A0MAX_SCAN_SEGMENT =A0 =A0 =A0 =A0 =A050
> >
> > Regards,
> > Ryusuke Konishi
> >
> >> > On 5/15/10, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:
> >> >> Hi,
> >> >> On Fri, 14 May 2010 20:24:02 -0400, Paul L wrote:
> >> >>> I have my home directory mounted as a nilfs2 partition. Today =
what
> >> >>> happened was that first I noticed google-chrome reporting it c=
annot
> >> >>> load user profile, I initially thought it was a google-chrome =
error.
> >> >>> At the time I was still able to view and modify my home direct=
ory. But
> >> >>> then after rebooting the system, my home partition no longer m=
ounts.
> >> >>> I'm using nilfs-2.0.19 and nilfs-utils-2.0.18 with Linux kerne=
l
> >> >>> 2.6.28.
> >> >>>
> >> >>> Here is the error message from dmesg (after turning on debuggi=
ng
> >> >>> message for nilfs2):
> >> >>>
> >> >>> NILFS nilfs_fill_super: start(silent=3D0)
> >> >>> NILFS(recovery) nilfs_search_super_root: looking segment
> >> >>> (seg_start=3D1607680, seg_end=3D1609727, segnum=3D785, seg_seq=
=3D307637)
> >> >>> NILFS(recovery) load_segment_summary: checking segment
> >> >>> (pseg_start=3D1608334, full_check=3D0)
> >> >>> NILFS(recovery) load_segment_summary: done (ret=3D3)
> >> >>> NILFS(recovery) nilfs_search_super_root: strayed: scan_newer=3D=
0, ret=3D3
> >> >>> NILFS warning: Segment magic number invalid
> >> >>> NILFS: error searching super root.
> >> >>> NILFS nilfs_fill_super: aborted
> >> >>> NILFS put_nilfs: the_nilfs on bdev mmcblk0p1 was freed
> >> >>>
> >> >>> I then dumped the first and last (backup) copy of the nilfs2 s=
uper
> >> >>> block, they are identical, and given below:
> >> >>>
> >> >>> 00000400 =A0 02 00 00 00 00 00 34 34 =A000 01 00 00 A1 6A E9 7=
1
> >> >>> ......44.....j.q
> >> >>> 00000410 =A0 A3 F1 DD BE 02 00 00 00 =A0AF 07 00 00 00 00 00 0=
0
> >> >>> ................
> >> >>> 00000420 =A0 00 E0 BF D7 03 00 00 00 =A001 00 00 00 00 00 00 0=
0
> >> >>> ................
> >> >>> 00000430 =A0 00 08 00 00 05 00 00 00 =A07C 3D 0A 00 00 00 00 0=
0
> >> >>> ........|=3D......
> >> >>> 00000440 =A0 8E 8A 18 00 00 00 00 00 =A0B5 B1 04 00 00 00 00 0=
0
> >> >>> ................
> >> >>> 00000450 =A0 00 B8 23 00 00 00 00 00 =A0B9 AF F3 4A 00 00 00 0=
0
> >> >>> ..#........J....
> >> >>> 00000460 =A0 D9 E1 D6 4B 00 00 00 00 =A049 8F ED 4B 00 00 00 0=
0
> >> >>> ...K....I..K....
> >> >>> 00000470 =A0 37 00 32 00 03 00 01 00 =A0B9 AF F3 4A 00 00 00 0=
0
> >> >>> 7.2........J....elp
> >> >>> 00000480 =A0 00 4E ED 00 00 00 00 00 =A000 00 00 00 0B 00 00 0=
0
> >> >>> .N..............
> >> >>> 00000490 =A0 80 00 20 00 C0 00 10 00 =A013 1C FC 11 D7 43 4C 0=
9 =A0..
> >> >>> ..........CL.
> >> >>> 000004A0 =A0 81 64 93 0A F4 54 CF 5E =A048 4F 4D 45 00 00 00 0=
0
> >> >>> .d...T.^HOME....
> >> >>>
> >> >>>
> >> >>> I wonder if there is a fsck tool to help me recover the file s=
ystem.
> >> >>> Any help is greatly appreciated!
> >> >>>
> >> >>> PS: last time I had a different problem of losing partition in=
fo, and
> >> >>> later successfully recovered with the help from people on the =
list. So
> >> >>> thanks! Now I'm actually backing up my files every two weeks, =
but
> >> >>> it'll still be great if it can recover and even better if we c=
an trace
> >> >>> the problem.
> >> >>
> >> >> Your filesystem seems to have lost the latest log according to =
the
> >> >> report.
> >> >>
> >> >> The attached patch may help to recover it. =A0It is revised sca=
n tool
> >> >> for nilfs-utils-2.0.18.
> >> >>
> >> >> After compiling the tool, you can use it like:
> >> >>
> >> >> =A0# cd nilfs-utils-2.0.18
> >> >> =A0# sbin/fsck/fsck0 <device>
> >> >>
> >> >> The tool will confirm whether to update super blocks if it find=
s the
> >> >> latest log.
> >> >>
> >> >> You may need to do
> >> >>
> >> >> =A0$ aclocal && autoheader && libtoolize -c --foce && automake =
-a -c &&
> >> >> autoconf
> >> >> =A0$ ./configure
> >> >>
> >> >> before build the tool.
> >> >>
> >> >> With regards,
> >> >> Ryusuke Konishi
> >> >>
> >> >
> >> >
> >> > --
> >> > Regards,
> >> > Paul Liu
> >> >
> >> > Yale Haskell Group
> >> > http://www.haskell.org/yale
> >> >
> >>
> >>
> >> --
> >> Regards,
> >> Paul Liu
> >>
> >> Yale Haskell Group
> >> http://www.haskell.org/yale
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ni=
lfs" in
> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
> >
>=20
>=20
>=20
> --=20
> Regards,
> Paul Liu
>=20
> Yale Haskell Group
> http://www.haskell.org/yale
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
