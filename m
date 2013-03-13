From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: mkfs.nilfs2 -b 1024 -B 8192
Date: Wed, 13 Mar 2013 12:25:01 +0400
Message-ID: <1363163101.2540.28.camel@slavad-ubuntu>
References: <20130313071453.GA17072@grill.lan>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=7ynxvNeZ3XvZzDVeC+W+LxsAgdGnXxOnZ7RqWCgFHQQ=;
	b=rcTOD2Hix6mYk4ol3q8dwXv6xlx/P07ZHkY1YmtnLHYqkmFQhGn8LTEGVpEbEAOsW+d7lyTo3/Sdsi3rB/k5otHc03n16BgUR7XGIv7ZpUP0Jz11TgY8JJqZ8tBZPV49;
In-Reply-To: <20130313071453.GA17072-P/DK4avwC2n/PtFMR13I2A@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Anthony Doggett <Anthony2486-fDpYTK8McCxDP812hmKXO1pr/1R2p/CL@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Anthony,

On Wed, 2013-03-13 at 07:14 +0000, Anthony Doggett wrote:
> Hi
> 
> Thanks for nilfs:)
> I have been trying it out again recently, this time using 1kB blocks for
> the partitions containing often-appended files like those in $HOME and
> /var.  Unfortunately the 1kB partitions keep dying; I detail the one of
> the common failures that I've managed to cut down below.
> 
> I started using nilfs with the default block/segment size, but was
> surprised how many blocks get appended by operations like "echo
> something >> something.txt".  Decreasing the block size from 4kB to 1kB
> reduced the amount of disk space required to house partitions containing
> $HOME and /var/log by about 60%.
> 

Thank you for report.

Yes, I am afraid that NILFS2 is not very well tested for the case of 1
KB block size.


> The machine I've been trialling nilfs on is running Debian Testing,
> Linux version 3.2.0-4-686-pae (debian-kernel-0aAXYlwwYIJuHlm7Suoebg@public.gmane.org) (gcc
> version 4.6.3 (Debian 4.6.3-14) ) #1 SMP Debian 3.2.35-2), but I've also
> reproduced it (identically) with Debian Unstable amd64 and Debian
> Experimental (using the 3.8-trunk kernel).  The problematic partitions
> were formatted with "mkfs.nilfs2 -b 1024 -B 8192".  A script to
> reproduce this issue is below.  Am I hitting the "bad btree node
> messages" issue mentioned in
> http://www.mail-archive.com/linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg01535.html ?
> 

Sorry, I don't clearly understand. Have you READ-ONLY FS issue only? Or
have you kernel panic? Could you confirm what situation you have?

Yes, I think that you have reproduced the issue with "bad btree nodes".
Currently, I am thinking that issue with "flush kernel thread" and "bad
btree nodes" are related. But maybe I am not fully correct. Your e-mail
gives me some thoughts about it.

The "flush kernel thread" issue is complex issue. The nature of this
issue begins from architectural solution of b-trees and DAT file. After
unsuccessful trying to elaborate simple fix I concluded that a clear
solution can be extents support implementation or adding special
metadata structure for GC operations. So, I think over about starting
implementation of it. But currently I hesitate about what can be a
better for start of implementation.

> Thanks,
> Anthony
> 
> Script:
>     VG=unencrypted
>     #apt-get install nilfs-tools darcs
>     lvcreate --size 2G --name ntest $VG
>     mkfs.nilfs2 -b 1024 -B 8192 /dev/mapper/$VG-ntest
>     mkdir /var/tmp/n
>     mkdir /var/tmp/n/ntest
>     mount /dev/mapper/$VG-ntest /var/tmp/n/ntest
>     mkdir /var/tmp/n/ntest/thedir
>     cd /var/tmp/n/ntest/thedir
>     sleep 2
>     date
>     darcs init
>     sleep 2
>     dmesg|tail -n 5
>     date
>     darcs whatsnew || true
>     date
>     sleep 2
>     dmesg|tail -n 5
> 

Thank you for the script and description of reproduction patch. You are
the first who describe it. I'll try to reproduce the issue with using
your script. Unfortunately, my previous efforts of reproduction the
issue were unsuccessful. So, maybe the "bad btree nodes" issue is not
fully related with "flush kernel thread" issue. If I will reproduce the
issue by means of your script then I can investigate the "bad btree
nodes" issue more deeply.

> (It's the "darcs whatsnew" that trips the issue.)
> 
> The error resulting from the above (the "inode number" varies):
> 
>     [63097.325138] segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
>     [63102.496756] nilfs_direct_assign: invalid pointer: 0
>     [63102.496786] NILFS error (device dm-17): nilfs_bmap_assign: broken bmap (inode number=28)
>     [63102.496798]
>     [63102.524403] Remounting filesystem read-only
> 
> The other error that I keep getting (again, only on the 1kB partitions):
> 
>     [  923.632623] nilfs_btree_propagate: key = 11, level == 0
>     [  968.416465] nilfs_btree_propagate: key = 11, level == 0
>     [  973.536551] nilfs_btree_propagate: key = 11, level == 0
>     [  981.088554] nilfs_btree_propagate: key = 11, level == 0
>     [  986.112465] nilfs_btree_propagate: key = 11, level == 0
> 
> This second error I have managed to suffer on multiple nilfs partitions
> (complete with the same key and level, and both on old partitions that
> have been gc'd many times and on fresh never-gc'd partitions) but have
> yet to reproduce with anything smaller than "run X, firefox, rsync and
> vim and a handful of other apps for a few minutes".

Thank you. It needs to investigate this issue more deeply.

Thanks,
Vyacheslav Dubeyko.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
