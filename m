From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: ifile is broken
Date: Sat, 25 Sep 2010 23:04:34 +0900 (JST)
Message-ID: <20100925.230434.166472968.ryusuke@osrg.net>
References: <AANLkTin1CT82ou1odPRYCDVZSNZGP-wBRG3xKifHqWHt@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTin1CT82ou1odPRYCDVZSNZGP-wBRG3xKifHqWHt-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: paolo-UnihLHphgvQ1GQ1Ptb7lUw@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 21 Sep 2010 11:23:13 +0200, Paolo Giangrandi <paolo-UnihLHphgvQ1GQ1Ptb7lUw@public.gmane.org> wrote:
> Hi,
> I'm using NILFS2 as root filesystem (it's on /dev/sda2, only /boot was
> apart on an EXT2 /dev/sda1, if I recall correctly) on my Archlinux
> (with Linux 2.6.35.4 and nilfs-utils 2.0.19).
> I got to manually run nilfs_cleanerd anytime I boot (read somewhere
> it's because my /usr is on NILFS2 as well).
> Yesterday, by mistake, I ran nilfs_cleanerd twice. Shut the system as
> soon as I realized but now it's not booting anymore: a kernel oops
> gets printed...
> 
> Waiting 10 seconds for device /dev/sda2 ...
> attempt to access beyond end of device
> sda2: rw=16, want=4283850835945523848, limit=15695505
> Pid :1, comm: init Not tainted 2.6.35-ARCH #1
> Call Trace:
> *snip*
> NILFS: btree level mismatch: 68 != 1
> NILFS error (device sda2): nilfs_ifile_get_inode_block: ifile is broken
> ERROR: Root device mounted successfully, but /sbin/init does not exist.
> Bailing out, you are on your own. Good luck.
> 
> /dev/sda2 gets mounted anyway on ramfs' /new_root, but if I try to
> access most of its subdirectories more kernel oops appear, and only
> very few files are shown. My home dir is completely gone.
> 
> So, uh, other than pointing out this bug (I guess a second
> nilfs_cleanerd should just quit, not shred your system...) I'd like to
> know if there's any way to get my data back... I'll backup (through
> dd) my whole /dev/sda (it's an 8GB SD) hoping to be able to recover it
> soon...
> 
> Thanks,
> Paolo.

Sorry for my late reply.

If you haven't yet reformatted the partition, try the following
manual recovery:

 $ cd your-work-directory
 $ git clone http://git.nilfs.org/nilfs2-utils.git
 $ cd nilfs2-utils
 $ git fetch http://git.nilfs.org/nilfs2-utils-devel.git fsck0:fsck0

   -- This will download fsck0.nilfs2 from nilfs2-utils-devel git repo.

 $ git checkout fsck0
 $ aclocal && autoheader && libtoolize -c --force && automake -a -c && autoconf
 $ ./configure
 $ make

   -- These steps will build fsck0.nilfs2.  You may need to install
      libtool, autoconf (-2.6 or later), and automake packages.

 $ cd sbin/fsck
 $ su
 # ./fsck0.nilfs2 /dev/sda2
 Super-block:
     revision = 2.0
     blocksize = 4096
     write time = 2010-09-25 22:19:18
     indicated log: blocknr = 116170
         segnum = 56, seq = 56, cno=1134
                  ^^

 Clean FS.
 A valid log is pointed to by superblock (No change needed): blocknr = 116170
     segnum = 56, seq = 56, cno=1134
     creation time = 2010-09-25 21:15:04

 # dd if=/dev/zero of=/dev/sda2 bs=8M count=1 seek=56
                                                   ^^
   -- Get the number of latest segment and destroy it.
      This is destructive, so you are strongly recommended to
      backup the partition with dd or something before trying this.

 # ./fsck0.nilfs2 /dev/sda2

   ...
   Do you wish to overwrite super block (y/N)?

   - Run fsck0.nilfs2 again, and press "y" if the above prompt
     appears.

 # mount -t nilfs2 -o ro,norecovery /dev/sda2 /nilfs

   - Mount the partition with "norecovery" mount option, and
     salvage data if succeeded to mount it.

You may need to destroy more segments (i.e. 55,54,.. in the above
example) to find a mountable checkpoint.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
