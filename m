From: =?KOI8-R?B?88XSx8XKIOHMxcvTwc7E0s/X?= <splavgm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: very large mount time after unxepected power down
Date: Tue, 30 Oct 2012 16:20:50 +0300
Message-ID: <CAFPMYnEZ28qvwkE3kaB59h2rD_8noT+gQtp7Hs6uvmHcL6KzYA@mail.gmail.com>
References: <CAFPMYnE3ybWO4o=E1UonAZJ7Uwn5y9n4840ksYGAu7qAYJ0zKw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        bh=TJhhshVUXqGUsnbmaMtPit0aPLMzGABmWOi2U2d8/z0=;
        b=l9GWbNJ3lUk7BBQ64vi9dgOKf8h7Ttqb7/TZFd9aNmi3rJiBkhF2Ra0r2yKBIeHzYy
         D1jeCzU1+0zdMmC0VcJvXoirJVwV8TtmJ62sNwJxPDlmHrfhZZmXj71O5GCsozlE/lP8
         mZEld/uTN709JO2CEhRrMKtqCOH4ULxXntELq+zh8lm12QbyXcLhiWyJDXnqnuhU/kwI
         4ORxei1s42tGMC8NZKquPqWD2PempyAoftvcnyYROMzGMbrVYwzivrLALTlWeUFAuGMZ
         UFFLD01d11uIpswTPO84vuBZzPD2rH5LUOPJfaCG7SNvT9Ss7RYlfHE46QIvfAbcnkpY
         ryLA==
In-Reply-To: <CAFPMYnE3ybWO4o=E1UonAZJ7Uwn5y9n4840ksYGAu7qAYJ0zKw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Good time of the day!

I'v got a nilfs2 partition on a 1TB md RAID1 partition composed of two
HDD's. Kernel 3.5.3, userspace utils v2.1.1. Gentoo linux
distribution.
Just updated utils to 2.1.4 but no failure since.

After power shutdown, mount takes about several hours.

For the first time I thought that it won't mount at all and tried to
use fsck tool, found somewhere in the internet(don't really remember).
It reported that superblock is ok.
Than I commented the check in the source file and the default number
of blocks to check appeared to be too small. It failed to find the
next superblock. I've increased the number, but increasing it to *100
didn't help.
So, probably the reserved SB is too far from away and it takes too
long to find it.

Does anybody knows, how can it be speed up? I know, UPS is a solution,
but I consider it be a bug.

nilfs-tune -l /dev/md0
nilfs-tune 2.1.1
Filesystem volume name:   (none)
Filesystem UUID:          9adc7cf2-4c04-4030-91d9-fae9a19ded03
Filesystem magic number:  0x3434
Filesystem revision #:    2.0
Filesystem features:      (none)
Filesystem state:         invalid or mounted
Filesystem OS type:       Linux
Block size:               4096
Filesystem created:       Wed Feb 29 20:32:28 2012
Last mount time:          Fri Oct 26 23:54:26 2012
Last write time:          Mon Oct 29 20:05:34 2012
Mount count:              11
Maximum mount count:      50
Reserve blocks uid:       0 (user root)
Reserve blocks gid:       0 (group root)
First inode:              11
Inode size:               128
DAT entry size:           32
Checkpoint size:          192
Segment usage size:       16
Number of segments:       119233
Device size:              1000202649600
First data block:         1
# of blocks per segment:  2048
Reserved segments %:      5
Last checkpoint #:        1003256
Last block address:       160163840
Last sequence #:          3416007
Free blocks count:        53164032
Commit interval:          0
# of blks to create seg:  0
CRC seed:                 0xc2316108
CRC check sum:            0x56f9857c
CRC check data size:      0x00000118

--------------------------------------------------
Aleksandrov Sergey Vasil'evich
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
