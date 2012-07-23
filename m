From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: read error on superblock
Date: Mon, 23 Jul 2012 20:24:10 +0200
Message-ID: <8066200.UhSxO3eimj@blitz>
References: <1343035048.1974.6.camel@slavad-ubuntu-11> <2948186.vfdzh15lNi@coil> <20120723.201918.94868195.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-face:user-agent:in-reply-to
         :references:mime-version:content-transfer-encoding:content-type;
        bh=FbKUNuA8aBHVBX24kZ9VpY8dXQwT1x/Uq0uzggAxuY0=;
        b=LJUmMqes1HTAcgY3Il4eRJsHyOlTMZZCYgFXUPcR9V6q1/+53eWIkyj6JaE9k/rkZh
         PqxcvxjiwSoJUuPL5+xHjJPo5kmstEFEW/q0R1Jd/0rsAEor2uHtUsAYTrErcYBnYMOt
         32+5l0SrJ4L+fiaQtcTjv6tw/eOA8YRNTZf95tCmAiKmDMtFP7ftE6WLFv+KBC9Sz2Rr
         FDEUGOkMGH0rclwE6QclGzcYiq/FECorelXZDXG6DAAQa9KS3TaSi1ruxVYOd/gtZ2pX
         C6KeN7hhslIL4ty0JLPtmA2W7NrRsDky0CjwClIG4S6BGyyR+aI3Hp3dZuwXW0Ura0Lf
         xc9A==
In-Reply-To: <20120723.201918.94868195.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Hi again,


I've copied the whole filesystem elsewhere (to a file) with `ddrescue'. It found 
one damaged area on the drive, but apparently neither at start nor at the end 
of partition.

The FS on the drive was marked as `dirty' (requiring recovery upon mount). My 
guess is that kernel attempted recovery, and gave up upon read error.

Unfortunately, the `norecovery' option did not help with the drive; it only 
helped once i've moved whole FS to file.


Log from ddrescue:


# Rescue Logfile. Created by GNU ddrescue version 1.14
# Command line: ddrescue /dev/sdc3 sda3 sda3.log
# current_pos  current_status
0x149E0CCC00     +
#      pos        size  status
0x00000000  0x149E0CC000  +
0x149E0CC000  0x00001000  -
0x149E0CD000  0x11220D3000  +


my understanding is, the following line describes the damaged area, format: 
start length status-marker (`-' for error)
0x149E0CC000  0x00001000  -


Once the FS was copied to a file, it mounted correctly:
# mount -o ro,loop,norecovery ./sda3.img ./some-mountpoint 


My gripe with current (linux-3.5.0) NILFS2 driver is that I couldn't tell it 
to ignore read errors and thus force it to mount the filesystem. Ony after I've 
moved some 160GB of FS to a file (that's a bit tedious :P) it opened the FS 
just fine.


Cheers,
-- 
dexen deVries

1972 - Dennis Ritchie invents a powerful gun that shoots both forward and 
backward simultaneously. Not satisfied with the number of deaths and permanent 
maimings from that invention he invents C and Unix.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
