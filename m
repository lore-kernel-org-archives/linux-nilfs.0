From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Performance about nilfs2 for SSD
Date: Thu, 30 Sep 2010 13:41:56 +0900 (JST)
Message-ID: <20100930.134156.237257990.ryusuke@osrg.net>
References: <20100926.181707.70807240.ryusuke@osrg.net>
	<AANLkTimXE22zz2TvMX6VGkFiosvF6qBxmpacc2PYDng6@mail.gmail.com>
	<AANLkTinLs14zOK8A-m76AsJt3E04W4_bSeinZjT=g9eR@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinLs14zOK8A-m76AsJt3E04W4_bSeinZjT=g9eR-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-8859-1"
To: yuehaixu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yhxu-jgEIgUtgKzeHXe+LvDLADg@public.gmane.org

Hi,
On Wed, 29 Sep 2010 17:44:30 -0400, Yuehai Xu wrote:
> I asked the same question in the list of Linux-btrfs, what I got is
> that the inode itself will be overwritten too, except for the
> superblocks. That seems make sense, how about NILFS2? I guess it
> should be the same.

No, nilfs doesn't overwrite inodes.  In nilfs, inodes are stored in a
metadata file called "ifile", and this file is appended to logs like
regular files.  This is the way that nilfs makes many versions of
checkpoints (or snapshots).

See slides pp.8-10 of "http://www.nilfs.org/papers/jls2009-nilfs.pdf"
for the format.

OTOH, superblocks are written back periodically if there are some
changes.

> However, though I don't do much tests about SSD, I am wondering
> whether it will be a bottleneck, since even the data is written to a
> new place instead of writing it to the original one, the superblocks
> which are in a fixed place should be updated all the time. This
> operation might cause much more frequent over-writes to the areas
> where the super blocks are. Is the SSD smart enough to handle this
> over-write? or the file system can do something to avoid such kind of
> situation.

I think such overwrites on super block are also replaced with append
writes in the recent SSD drives though I don't know to what degree
they are aware of filesystems.

=46ilesystem may be able to avoid such situation by dividing layout
information and statistical information in which the former needs to
be located in a fixed place but the latter doesn't have to be that
way.

> Anyway, or this problem might not even be a problem for file system
> because there are cache and the writes can be delayed.
>=20
> I appreciate for your comments.
>=20
> Thanks,
> Yuehai

Regards,
Ryusuke Konishi

> On Tue, Sep 28, 2010 at 4:03 PM, Yuehai Xu <yuehaixu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote=
:
> > Hi,
> >
> > On Sun, Sep 26, 2010 at 5:17 AM, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>=
 wrote:
> >> Hi,
> >> On Sat, 25 Sep 2010 18:54:04 -0400, Yuehai Xu wrote:
> >>> Hi,
> >>>
> >>> I have a SSD which is Intel x25-v, I use it to test the performan=
ce of
> >>> different file systems. The results seems confusing to me. It is =
from
> >>> postmark in which I set file number to 50,000 with each size from=
 9216
> >>> bytes to 15360 bytes
> >>>
> >>> =A0 =A0 =A0 EXT3 =A0 =A0NILFS2 =A0BTRFS =A0 EXT4 =A0 =A0XFS =A0 =A0=
 REISERFS =A0 =A0 =A0 =A0EXT2
> >>> PostMark(R) =A0 146.67Kb/s =A052.21Kb/s =A0 90.59Kb/s
> >>> 172.12Kb/s =A0 =A060.39Kb/s =A0 =A0 =A0 146.67Kb/s =A0 =A0 =A083.=
25Kb/s
> >>> PostMark(W) =A0 28.09Mb/s =A0 =A0 =A0 10Mb/s =A017.35Mb/s =A0 =A0=
 =A0 31.04Mb/s =A0 =A0 =A0 11.56Mb/s =A0 =A0 =A0 28.09Mb/s =A0 =A0 =A0 =
15.94Mb/s
> >>>
> >>> From the results, the throughput both for R/W of NILFS2 is much
> >>> smaller than EXT3. As I noticed that the performance of NILFS2 fo=
r SSD
> >>> is much better than other file systems from the web site. What's =
the
> >>> matter with my own test result? My kernel is 2.6.32, and I use de=
fault
> >>> way to format NILFS2, nothing special is done. So, my questions a=
re:
> >>>
> >>> 1. Are there any special parameters that I need to configure when=
 I
> >>> mount/format my SSD?
> >>
> >> Nilfs in latest kernels have "discard" mount option, but I think
> >> it won't change the above result dramatically.
> >>
> >>> 2. Is the performance much different from different kind of SSD?
> >>> 3. As I know, NILFS2 is a kind of Log-file system, which means it
> >>> always makes the random writes sequentially and tries to avoid th=
e
> >>> cost of overwrite for SSD. Does it need to overwrite its meta dat=
a?
> >>> Since I think NILFS2 should always make a mapping table, how abou=
t
> >>> when the mapping table need to be updated?
> >>
> >> For older SSD drives, it may be true.
> >>
> >> But, recent intelligent SSD drives are doing LFS like optimization=
s
> >> internally, so I guess they would show similar trend.
> >
> > What do you mean for "similar trend"? Do you mean that the throughp=
ut
> > should be almost the same no matter the different kinds of file
> > systems?
> >
> >>
> >> Unfortunately NILFS2 has performance issue due to its DAT and Garb=
age
> >> Collection design, and it seems to be hurting the merit of LFS for
> >> such high-throughput devices.
> >>
> >> DAT is metadata which is used to convert indirect block addresses
> >> (called virtual block number) to real block addresses. =A0This mak=
es
> >> relocation of disk blocks possible, but at the same time, it makes
> >> latency of disk access double against blocks read first time.
> >>
> >> To mitigate this design drawback, nilfs is applying readahead for =
such
> >> metadata, but it has much room for tuning. =A0For instance, I rece=
ntly
> >> sent some patches to improve read performance on intel SSD for 2.6=
=2E36.
> >>
> >> For details on the metadata organization and disk address conversi=
on
> >> of NILFS2, please see the slides:
> >>
> >> =A0http://www.nilfs.org/papers/jls2009-nilfs.pdf
> >
> > From the slice and Documentation/filesystems/nilfs2.txt, I notice t=
hat
> > the DAT is stored almost at the end of every LOG, which seems certa=
in
> > parts of a disk. I know that Log-structure File System doesn't
> > overwrite the original files, however, what confuses me is whether =
the
> > mapping info in inode should be overwritten. For example, suppose
> > mapping info(LBA->PBA) of file A is stored in inode A. If file A is
> > over written, actually the new file is written to B, then, I think =
the
> > corresponding mapping info in inode A should changes from file A to
> > file B. In that way, is this operation a kind of over-write? Even
> > though I read the papers from the link you give me, I don't get the
> > exact answer.
> >
> > I appreciate your answer very much.
> >
> > For NILFS2, as you have said, DAT is used to convert virtual block
> > address to real block address, that is from logical block address(L=
BA)
> > to physical block address(PBA), I guess this is the place to mainta=
in
> > the mapping info. However, when these info are updated, for example=
,
> > when over write happens, the original virtual block address should =
map
> > to a new real block address, in such case, will over write happen i=
n
> > DAT? Is this one of the reason for SSD's performance of NILFS2?
> >
> > From the papers I have read, the general idea to do garbage collect=
ion
> > is to copy some "live" from segments and compact them into a new li=
ve
> > segments and then write them back, marking the original segments as
> > free. Do you have any ideas to optimize this gc?
> >
> > Since I only read some papers and don't hack the source code, the
> > questions I asked might be naive, I really appreciate your replying
> >
> > Thanks,
> > Yuehai
> >
> >>
> >> A link page ( http://www.nilfs.org/en/links.html ) has some more
> >> related links.
> >>
> >>> 4. What's special has done to optimize the performance of SSD? I =
guess
> >>> Log-file systems might have better performance than fast file sys=
tems
> >>> such as EXT2/3, but at least right now the results shows that I w=
as
> >>> wrong.
> >>
> >> As I wrote above, recent SSD drives adopt own LFS like optimizatio=
n,
> >> and the performance characteristics are greatly affected by it. =A0=
It's
> >> well explained in the following article:
> >>
> >> =A0http://lwn.net/Articles/353411/
> >>
> >>
> >> Regards,
> >> Ryusuke Konishi
> >>
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs=
" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
