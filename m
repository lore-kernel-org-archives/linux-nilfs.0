From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Segment magic number invalid
Date: Mon, 17 May 2010 11:46:57 +0900 (JST)
Message-ID: <20100517.114657.112904526.ryusuke@osrg.net>
References: <20100516.103300.124959052.ryusuke@osrg.net>
	<AANLkTinBFQYWRZRmVL69lqxRG1p0cBQ2AxBiFk4SlNE8@mail.gmail.com>
	<AANLkTimHvMze3B8fQE383WW8WLbOYcZx0pz0sfjC2DhJ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimHvMze3B8fQE383WW8WLbOYcZx0pz0sfjC2DhJ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Sun, 16 May 2010 14:32:05 -0400, Paul L wrote:
> Sorry, should have sent it to the list instead.
> 
>  Thanks for the patch! I tried it, but seems it still can't find the
>  super root. Here is the output. What shall I do now?
> 
>  Super-block:
>      revision = 2.0
>      blocksize = 4096
>      write time = 2010-05-14 13:58:33
>      indicated log: blocknr = 1608334
>          segnum = 785, seq = 307637, cno=671100
> 
>  Clean FS.
>  The latest log is lost. Trying rollback recovery..
>  .......
>  fsck0.nilfs2: Cannot find super root

Can you try increasing the number defined at the following line in
sbin/fsck/fsck0.nilfs2.c ?

 #define  MAX_SCAN_SEGMENT          50

Regards,
Ryusuke Konishi
 
> > On 5/15/10, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:
> >> Hi,
> >> On Fri, 14 May 2010 20:24:02 -0400, Paul L wrote:
> >>> I have my home directory mounted as a nilfs2 partition. Today what
> >>> happened was that first I noticed google-chrome reporting it cannot
> >>> load user profile, I initially thought it was a google-chrome error.
> >>> At the time I was still able to view and modify my home directory. But
> >>> then after rebooting the system, my home partition no longer mounts.
> >>> I'm using nilfs-2.0.19 and nilfs-utils-2.0.18 with Linux kernel
> >>> 2.6.28.
> >>>
> >>> Here is the error message from dmesg (after turning on debugging
> >>> message for nilfs2):
> >>>
> >>> NILFS nilfs_fill_super: start(silent=0)
> >>> NILFS(recovery) nilfs_search_super_root: looking segment
> >>> (seg_start=1607680, seg_end=1609727, segnum=785, seg_seq=307637)
> >>> NILFS(recovery) load_segment_summary: checking segment
> >>> (pseg_start=1608334, full_check=0)
> >>> NILFS(recovery) load_segment_summary: done (ret=3)
> >>> NILFS(recovery) nilfs_search_super_root: strayed: scan_newer=0, ret=3
> >>> NILFS warning: Segment magic number invalid
> >>> NILFS: error searching super root.
> >>> NILFS nilfs_fill_super: aborted
> >>> NILFS put_nilfs: the_nilfs on bdev mmcblk0p1 was freed
> >>>
> >>> I then dumped the first and last (backup) copy of the nilfs2 super
> >>> block, they are identical, and given below:
> >>>
> >>> 00000400   02 00 00 00 00 00 34 34  00 01 00 00 A1 6A E9 71
> >>> ......44.....j.q
> >>> 00000410   A3 F1 DD BE 02 00 00 00  AF 07 00 00 00 00 00 00
> >>> ................
> >>> 00000420   00 E0 BF D7 03 00 00 00  01 00 00 00 00 00 00 00
> >>> ................
> >>> 00000430   00 08 00 00 05 00 00 00  7C 3D 0A 00 00 00 00 00
> >>> ........|=......
> >>> 00000440   8E 8A 18 00 00 00 00 00  B5 B1 04 00 00 00 00 00
> >>> ................
> >>> 00000450   00 B8 23 00 00 00 00 00  B9 AF F3 4A 00 00 00 00
> >>> ..#........J....
> >>> 00000460   D9 E1 D6 4B 00 00 00 00  49 8F ED 4B 00 00 00 00
> >>> ...K....I..K....
> >>> 00000470   37 00 32 00 03 00 01 00  B9 AF F3 4A 00 00 00 00
> >>> 7.2........J....elp
> >>> 00000480   00 4E ED 00 00 00 00 00  00 00 00 00 0B 00 00 00
> >>> .N..............
> >>> 00000490   80 00 20 00 C0 00 10 00  13 1C FC 11 D7 43 4C 09  ..
> >>> ..........CL.
> >>> 000004A0   81 64 93 0A F4 54 CF 5E  48 4F 4D 45 00 00 00 00
> >>> .d...T.^HOME....
> >>>
> >>>
> >>> I wonder if there is a fsck tool to help me recover the file system.
> >>> Any help is greatly appreciated!
> >>>
> >>> PS: last time I had a different problem of losing partition info, and
> >>> later successfully recovered with the help from people on the list. So
> >>> thanks! Now I'm actually backing up my files every two weeks, but
> >>> it'll still be great if it can recover and even better if we can trace
> >>> the problem.
> >>
> >> Your filesystem seems to have lost the latest log according to the
> >> report.
> >>
> >> The attached patch may help to recover it.  It is revised scan tool
> >> for nilfs-utils-2.0.18.
> >>
> >> After compiling the tool, you can use it like:
> >>
> >>  # cd nilfs-utils-2.0.18
> >>  # sbin/fsck/fsck0 <device>
> >>
> >> The tool will confirm whether to update super blocks if it finds the
> >> latest log.
> >>
> >> You may need to do
> >>
> >>  $ aclocal && autoheader && libtoolize -c --foce && automake -a -c &&
> >> autoconf
> >>  $ ./configure
> >>
> >> before build the tool.
> >>
> >> With regards,
> >> Ryusuke Konishi
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
