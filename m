From: Marcel (Felix) Giannelia <felix-tCryr5mBeWKsTnJN9+BGXg@public.gmane.org>
Subject: nilfs recovery after cheap SSD failure
Date: Mon, 13 Feb 2012 21:16:51 -0800
Message-ID: <20120213211651.74b46182@saira.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

I tried to send this as two posts last week, but it appears from the
various archives of this list that those posts didn't make it. So,
here is a tale of how a cheap SSD corrupted a nilfs2 filesystem and how
I was able to recover it, consolidated and edited a bit:


INITIAL SYMPTOMS

My netbook froze intermittently without warning, then began showing DMA
write command errors on my SSD in the dmesg. NILFS initially didn't
react to this, but then then the machine froze solid for a few minutes.
When it came back there were errors from NILFS, and the SSD
disappeared so I was forced to reboot.

After the reboot, /home refused to mount, giving the following error:

 NILFS: Invalid checkpoint (checkpoint number=116290)
 NILFS: error while loading last checkpoint (checkpoint number=116290)


BACKGROUND

After some reading, I discovered that the SSD in question, a Samsung
P-SSD1800, is incredibly cheap: it uses flash rated for only 3000 write
cycles, appears to have no wear-levelling, and will silently return
data for a block on which there's been a write error.

e.g., say a cell contains "abc" and you try to write "def" to it. The
attempt might cause the SSD to return a DMA write error, but if you
later go to read that block, you have no idea what's in it -- it might
be "abc", "dbc", or "000" -- but the device will return it as a
successful read.

Had I known those things, I probably would not have put NILFS on this
thing (seeing as NILFS has those nasty fixed-location superblocks that
get updated all the time...). However, what's done is done, and NILFS's
checksumming *did* prevent silent data corruption in this case. And
considering I bought this netbook used after it had XP (with a
pagefile!) on it, 6 months of heavy use is pretty good.


INVESTIGATION & DATA RECOVERY

(Everything described below I did on a dd copy of the filesystem, on a
different machine.)

I had backups, and in there I happened to have a text file listing the
snapshots I'd made, so I tried a few of those known-good checkpoint
numbers, but interestingly I got the exact same mount error (i.e. same
cp number and everything).

It took me a while, but I was able to track down a copy of fsck0.nilfs2
(which used to be available under nilfs2-utils-devel when that git tree
was hosted on nilfs.org, but it is not present in the new git tree on
github.com). The copy I got was from here:

 github.com/konis/nilfs-utils/tree/fsck0

(In case anyone finding this later runs into compile errors about
"undefined reference to `le64_to_cpu'", le16_to_cpu, and O_LARGEFILE
not being defined, insert these two lines in the top of fsck0.nilfs2.c:
#include <nilfs.h>
#define O_LARGEFILE     0100000

and the compile command sequence is:
 aclocal && autoheader && libtoolize -c --force && automake -a -c &&
autoconf ./configure
 make
)

Anyway, I ran fsck0.nilfs2 on the loop device of the dd image, and it
told me that the filesystem was completely clean:

======
# fsck0.nilfs2 -v /dev/mapper/netbook
Super-block:
    revision = 2.0
    blocksize = 4096
    write time = 2012-02-08 16:54:52
    indicated log: blocknr = 195390
        segnum = 95, seq = 18922, cno=116290

Clean FS.
A valid log is pointed to by superblock (No change needed): blocknr =
195390 segnum = 95, seq = 18922, cno=116290
    creation time = 2012-02-08 16:34:31
======

My guess is that the log got written correctly and with a valid
checksum, but that some other important part of that checkpoint got
gibbled. On mount, the check routines had declared it valid by the time
they reached the gibbled part and NILFS didn't know what to do from
there.

In order to fix it, I opened up a hex editor on the image and jumped to
address 4096 * 195390, where I deliberately corrupted a few bytes. I
ran fsck0.nilfs2 again, and this time it gave me the option to roll
back the (now) corrupted log.

...After which the filesystem mounted cleanly! Sort of.  Some
files/directories weren't readable and returned nasty messages like
this in the dmesg:

=====
NILFS warning (device dm-0): nilfs_ifile_get_inode_block: unable to read
inode: 3421
attempt to access beyond end of device
dm-0: rw=0, want=3465637700349233464, limit=4610048
NILFS warning (device dm-0): nilfs_ifile_get_inode_block: unable to read
inode: 3421
NILFS: bad btree node (blocknr=191506): level = 125, flags = 0xa,
nchildren = 56
NILFS error (device dm-0): nilfs_bmap_lookup_at_level: broken bmap
(inode number=3)
=====

But the important thing is that all the files I had created that day
and most of the ones from the last week (i.e. the ones from after I got
lazy with the backups :P) were readable. Files farther back in time
seemed to have a higher probability of being lost.

I tried both mounting some earlier checkpoints and a few repeats of the
"deliberately corrupt the last log and roll back" procedure, but files
that were unreadable remained so.

That's about it; perhaps that'll help someone else someday.

Thanks for a great filesystem (which really can't be blamed for this on
such a crappy SSD) -- and if you could get those superblocks to move
around a bit and be a little less write-amplified, that would be cool :)


~Felix.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
