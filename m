From: Anthony Doggett <Anthony2486-fDpYTK8McCxDP812hmKXO1pr/1R2p/CL@public.gmane.org>
Subject: mkfs.nilfs2 -b 1024 -B 8192
Date: Wed, 13 Mar 2013 07:14:53 +0000
Message-ID: <20130313071453.GA17072@grill.lan>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi

Thanks for nilfs:)
I have been trying it out again recently, this time using 1kB blocks for
the partitions containing often-appended files like those in $HOME and
/var.  Unfortunately the 1kB partitions keep dying; I detail the one of
the common failures that I've managed to cut down below.

I started using nilfs with the default block/segment size, but was
surprised how many blocks get appended by operations like "echo
something >> something.txt".  Decreasing the block size from 4kB to 1kB
reduced the amount of disk space required to house partitions containing
$HOME and /var/log by about 60%.

The machine I've been trialling nilfs on is running Debian Testing,
Linux version 3.2.0-4-686-pae (debian-kernel-0aAXYlwwYIJuHlm7Suoebg@public.gmane.org) (gcc
version 4.6.3 (Debian 4.6.3-14) ) #1 SMP Debian 3.2.35-2), but I've also
reproduced it (identically) with Debian Unstable amd64 and Debian
Experimental (using the 3.8-trunk kernel).  The problematic partitions
were formatted with "mkfs.nilfs2 -b 1024 -B 8192".  A script to
reproduce this issue is below.  Am I hitting the "bad btree node
messages" issue mentioned in
http://www.mail-archive.com/linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg01535.html ?

Thanks,
Anthony

Script:
    VG=unencrypted
    #apt-get install nilfs-tools darcs
    lvcreate --size 2G --name ntest $VG
    mkfs.nilfs2 -b 1024 -B 8192 /dev/mapper/$VG-ntest
    mkdir /var/tmp/n
    mkdir /var/tmp/n/ntest
    mount /dev/mapper/$VG-ntest /var/tmp/n/ntest
    mkdir /var/tmp/n/ntest/thedir
    cd /var/tmp/n/ntest/thedir
    sleep 2
    date
    darcs init
    sleep 2
    dmesg|tail -n 5
    date
    darcs whatsnew || true
    date
    sleep 2
    dmesg|tail -n 5

(It's the "darcs whatsnew" that trips the issue.)

The error resulting from the above (the "inode number" varies):

    [63097.325138] segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
    [63102.496756] nilfs_direct_assign: invalid pointer: 0
    [63102.496786] NILFS error (device dm-17): nilfs_bmap_assign: broken bmap (inode number=28)
    [63102.496798]
    [63102.524403] Remounting filesystem read-only

The other error that I keep getting (again, only on the 1kB partitions):

    [  923.632623] nilfs_btree_propagate: key = 11, level == 0
    [  968.416465] nilfs_btree_propagate: key = 11, level == 0
    [  973.536551] nilfs_btree_propagate: key = 11, level == 0
    [  981.088554] nilfs_btree_propagate: key = 11, level == 0
    [  986.112465] nilfs_btree_propagate: key = 11, level == 0

This second error I have managed to suffer on multiple nilfs partitions
(complete with the same key and level, and both on old partitions that
have been gc'd many times and on fresh never-gc'd partitions) but have
yet to reproduce with anything smaller than "run X, firefox, rsync and
vim and a handful of other apps for a few minutes".
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
