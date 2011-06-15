From: Zahid Chowdhury <zahid.chowdhury-VJizFkI/10gAspv4Qr0y0gC/G2K4zDHf@public.gmane.org>
Subject: RE: mount & fsck of nilfs partition fail.
Date: Wed, 15 Jun 2011 11:38:16 -0700
Message-ID: <053D39D3D76C474EB2D2A284AA6BA3181B05E99563@COLOSSEXCH01.starsolutions.com>
References: <053D39D3D76C474EB2D2A284AA6BA3181B05E4E394@COLOSSEXCH01.starsolutions.com>
	<20110615.104251.29260790.ryusuke@osrg.net>
	<20110615.195858.252298449.ryusuke@osrg.net>
 <20110616.033201.162617955.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110616.033201.162617955.ryusuke-sG5X7nlA6pw@public.gmane.org>
Content-Language: en-US
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello Ryusuke,
  Yes, "the data on the partition is important". Please let me know how to
"get a backtrace of the error" and I will send it to you. Thanks a lot.

Zahid

-----Original Message-----
From: Ryusuke Konishi [mailto:konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org] 
Sent: Wednesday, June 15, 2011 11:32 AM
To: Zahid Chowdhury
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: mount & fsck of nilfs partition fail.

On Wed, 15 Jun 2011 19:58:58 +0900 (JST), Ryusuke Konishi wrote:
> On Wed, 15 Jun 2011 10:42:51 +0900 (JST), Ryusuke Konishi wrote:
> > On Tue, 14 Jun 2011 11:04:26 -0700, Zahid Chowdhury wrote:
> > > Hello Ryusuke,
> > >   I changed the code some to:
> > > diff -u --ignore-all-space fsck0.nilfs2.c ~/nilfs/nilfs-utils.git/nilfs2-utils/sbin/fsck
> > > --- fsck0.nilfs2.c      2011-06-14 11:03:49.000000000 -0700
> > > +++ /root/nilfs/nilfs-utils.git/nilfs2-utils/sbin/fsck/fsck0.nilfs2.c   2011-06-14 11:01:34.000000000 -0700
> > > @@ -172,10 +172,14 @@
> > >  static void read_block(int fd, __u64 blocknr, void *buf,
> > >                        unsigned long size)
> > >  {
> > > +        int num_read;
> > >         if (lseek64(fd, blocknr * blocksize, SEEK_SET) < 0 ||
> > > -           read(fd, buf, size) < size)
> > > -               die("cannot read block (blocknr = %llu): %s",
> > > -                   (unsigned long long)blocknr, strerror(errno));
> > > +            (num_read = read(fd, buf, size) < size)) {
> > > +                fprintf(stderr, "Read size was: %d\tNum read: %d\tStrerror: %s\n",
> > > +                    size, num_read, strerror(errno));
> > > +                die("cannot read block (blocknr = %llu)",
> > > +                    (unsigned long long)blocknr);
> > > +        }
> > >  }
> > > 
> > >  static inline __u64 segment_start_blocknr(unsigned long segnum)
> > > 
> > > and I got this as output:
> > > 
> > > ./fsck0.nilfs2 -f -v /dev/sda2
> > > Super-block:
> > >     revision = 2.0
> > >     blocksize = 4096
> > >     write time = 2011-06-11 23:22:03
> > >     indicated log: blocknr = 1648528
> > >         segnum = 804, seq = 401758, cno=3250953
> > > 
> > > Unclean FS.
> > > The latest log is lost. Trying rollback recovery..
> > > ......
> > > Searching the latest checkpoint.
> > > Read size was: 4096     Num read: 1     Strerror: Success
> > > fsck0.nilfs2: cannot read block (blocknr = 2696911)
> 
> Ah, sorry.  I noticed that the block number (= 2696911) is beyond the
> size of your block device.  It is the cause of this error.
> 
> I'll look into the rollback loop code of fsck0.nilfs2 to find out the
> root cause of this out-of-range access.

Uum, this bug is not trivial.

Clearly this happened in the context of
find_latest_cno_in_logical_segment() function, but I couldn't find any
suspicious callsites so far.

If you hurry, please go ahead.

Otherwise (if the data on the partition is important), I need your
help to narrow down this problem.  If we can get a backtrace of the
error, things would become clear.

Anyway, I would like to release an updated nilfs2 kmod in a week or so
for centos users to minimize this sort of thing.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
