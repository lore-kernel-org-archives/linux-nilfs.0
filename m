From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: mount & fsck of nilfs partition fail.
Date: Wed, 15 Jun 2011 19:58:58 +0900 (JST)
Message-ID: <20110615.195858.252298449.ryusuke@osrg.net>
References: <20110614.085157.212693296.ryusuke@osrg.net>
	<053D39D3D76C474EB2D2A284AA6BA3181B05E4E394@COLOSSEXCH01.starsolutions.com>
	<20110615.104251.29260790.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110615.104251.29260790.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: zahid.chowdhury-VJizFkI/10gAspv4Qr0y0gC/G2K4zDHf@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 15 Jun 2011 10:42:51 +0900 (JST), Ryusuke Konishi wrote:
> On Tue, 14 Jun 2011 11:04:26 -0700, Zahid Chowdhury wrote:
> > Hello Ryusuke,
> >   I changed the code some to:
> > diff -u --ignore-all-space fsck0.nilfs2.c ~/nilfs/nilfs-utils.git/nilfs2-utils/sbin/fsck
> > --- fsck0.nilfs2.c      2011-06-14 11:03:49.000000000 -0700
> > +++ /root/nilfs/nilfs-utils.git/nilfs2-utils/sbin/fsck/fsck0.nilfs2.c   2011-06-14 11:01:34.000000000 -0700
> > @@ -172,10 +172,14 @@
> >  static void read_block(int fd, __u64 blocknr, void *buf,
> >                        unsigned long size)
> >  {
> > +        int num_read;
> >         if (lseek64(fd, blocknr * blocksize, SEEK_SET) < 0 ||
> > -           read(fd, buf, size) < size)
> > -               die("cannot read block (blocknr = %llu): %s",
> > -                   (unsigned long long)blocknr, strerror(errno));
> > +            (num_read = read(fd, buf, size) < size)) {
> > +                fprintf(stderr, "Read size was: %d\tNum read: %d\tStrerror: %s\n",
> > +                    size, num_read, strerror(errno));
> > +                die("cannot read block (blocknr = %llu)",
> > +                    (unsigned long long)blocknr);
> > +        }
> >  }
> > 
> >  static inline __u64 segment_start_blocknr(unsigned long segnum)
> > 
> > and I got this as output:
> > 
> > ./fsck0.nilfs2 -f -v /dev/sda2
> > Super-block:
> >     revision = 2.0
> >     blocksize = 4096
> >     write time = 2011-06-11 23:22:03
> >     indicated log: blocknr = 1648528
> >         segnum = 804, seq = 401758, cno=3250953
> > 
> > Unclean FS.
> > The latest log is lost. Trying rollback recovery..
> > ......
> > Searching the latest checkpoint.
> > Read size was: 4096     Num read: 1     Strerror: Success
> > fsck0.nilfs2: cannot read block (blocknr = 2696911)
> 
> The return value looks weird.
> Is your block device readable ?
> 
>  # dd if=/dev/sda2 of=/sda2-image-file
> 
> If you can copy the block device into an image file.  You may be able
> to recover it through a loop device.
> 
>  # losetup /dev/loop0 /sda2-image-file
>  # ./fsck0.nilfs2 -f -v /dev/loop0
> 
> Otherwise, you may need a low level recovery for the device.
> 
> Regards,
> Ryusuke Konishi

Ah, sorry.  I noticed that the block number (= 2696911) is beyond the
size of your block device.  It is the cause of this error.

I'll look into the rollback loop code of fsck0.nilfs2 to find out the
root cause of this out-of-range access.


Ryusuke Konishi


> > The mount error is:
> > $ mount -t nilfs2 /dev/sda2 /writable
> > Jun 14 10:52:13 _Lab kernel: NILFS warning: mounting unchecked fs
> > Jun 14 10:52:13 _Lab kernel: NILFS warning: Checksum error in segment payload
> > Jun 14 10:52:13 _Lab kernel: NILFS: error searching super root.
> > mount.nilfs2: Error while mounting /dev/sda2 on /writable: Invalid argument
> > 
> > 
> > Will it still be possible to recover the partition or is this error fatal? Thanks all.
> > 
> > Zahid
> > 
> > 
> > -----Original Message-----
> > From: Ryusuke Konishi [mailto:konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org] 
> > Sent: Monday, June 13, 2011 4:52 PM
> > To: Zahid Chowdhury
> > Cc: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Subject: Re: mount & fsck of nilfs partition fail.
> > 
> > On Mon, 13 Jun 2011 16:28:19 -0700, Zahid Chowdhury wrote:
> > > Hello Dexen/Ryusuke,
> > >   Thanks both for your help. I tried this:
> > >    [quadcore:~/nilfs/nilfs-utils.git/nilfs2-utils] git fetch
> > >            http://git.nilfs.org/nilfs2-utils-devel.git fsck0:fsck0
> > >    fatal: Refusing to fetch into current branch
> > >    [quadcore:~/nilfs/nilfs-utils.git/nilfs2-utils] git checkout fsck0
> > >    Already on "fsck0"
> > > I also tried from scratch with your commands below (not co, but checkout) -
> > > there were no changes to the file with diff:
> > >   nilfs2-utils-devel/sbin/fsck/fsck0.nilfs2.c
> > 
> > Sorry, the fsck0 branch was not propery updated.
> > I just fixed the problem in the git repo.
> > 
> > Regards,
> > Ryusuke Konishi
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
