From: Jon Watte <jwatte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: nilfs error
Date: Fri, 6 Dec 2013 18:17:25 -0800
Message-ID: <CAJgyHGOeRhj7D4GeyfHhBjXLE3K40DiakT2Zms2D7TPB-BiRog@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:content-type;
        bh=Yyo710/vJlyZIXbAEuMq/8jAafFgGCjqBoOIHP0nkSM=;
        b=UhmmryldZMhIwe9quhA6z4uCDqN12vThH3cNW1BYof8+1i4ZQJEXJCZzutQOspRh/T
         SZZ1Im4DwzZtl4BVALqjScE80NXINyDACt6NYoujV5jGWEbGvIixzRIfU5TbPs1UR4oh
         sT/drVzc5Vs7koBjwGd7GVSY5lTRT+kBWCKx6GRMXsyuuh7B5dg6hzz/3bhlKhvt5iCp
         Y/d8AuLFUKudhNAeoeQnPC9sTYUt2n/88MCcqN1IKgKTuW6rwgUR9IwUT3/0GEe6sT9W
         +qV2x7BytKWakla6mZyDPufsH59NNJIcPIOe4Afc4pvspr5ku47BfJ3Bs6csVGSfXWFM
         TDjg==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

First, let me describe my usage pattern, which is boring -- the
interesting technical stuff comes later down.

I have a mini-ATX computer with a small (32 GB) SSD, which I have
partitioned with two small partitions for /boot and swap, and one
large partition for nilfs2 root-and-everything-else.
This system has been running fine, using Arch Linux distribution x64
flavor for over a year.
I update it to the latest Arch kernel weekly, which means I'm running
fairly new code. Gotta live dangerously!
The usage pattern for this system is light; mostly web browsing (using
chromium) and software development (using vim, gcc, make, and
LXTerminal.)

Two days ago, after the latest kernel update, the drive turned
read-only in the middle of usage. I could not use "shutdown" because
"sudo" could not write its logfiles.
This has happened before when I've filled the disk too full without
noticing, so I just turned off power without shutdown (I often do this
anyway -- a "sync" in terminal and a toggle switch power-off a few
seconds later.) Typically, the checkpoint cleanup on boot would clear
this up if this was the problem.

However, yesterday when booting up agian, it refused to mount the root
disk, and booting was halted, with the messages shown in the below
photograph. Note that, because I can't boot, I can't get this output
in a copy-and-paste-able form!

https://pbs.twimg.com/media/BaxOmptCYAABQuW.jpg:large

The two repeated messages are (typed in from the photo):
NILFS: bad bree node (blocknr=1364234) ; level = 100; flags = 0x73;
nchildren = 12336
NILFS error (device sda1): nilfs_bmap_lookup_contig: broken bmap
(inode number=3935)

I cloned the sda1 partition (the main partition) to my file server for
posterity, and re-formatted the hard drive using btrfs for now until I
can get clarity on this problem.

Interesting observation: That disk image CAN be mounted if I boot the
Arch-ISO distribution image from March 2013, but can NOT be mounted if
I try to boot from it with a later kernel. Maybe someone better with
"pacman" than I am can compare kernel versions from March 2013 vs Now?

I don't really want to put this image up for FTP because it contains
my SSH private keys (one of which is not pass-phrased) but if there is
something I can do with it to help debug this occurrence, I'd be happy
to try it.


This is very sad, because I've had nothing but good performance from
nilfs since I installed it 18 months ago.


Sincerely,

Jon Watte


--
"I pledge allegiance to the flag of the United States of America, and
to the republic for which it stands, one nation indivisible, with
liberty and justice for all."
~ Adopted by U.S. Congress, June 22, 1942
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
