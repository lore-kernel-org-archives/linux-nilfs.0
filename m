From: Jan Misiak <fijam7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: kernel panic (2.6.36) after file system corruption (?)
Date: Tue, 21 Dec 2010 18:35:55 +0100
Message-ID: <AANLkTik55mzijPR3ibT2+tKN6QEi2U1mpyprRQ3KU2xO@mail.gmail.com>
References: <AANLkTika7SunjtX+eMq=22L97T=dHBs0_GFdL8KbKwQ3@mail.gmail.com>
 <20101220.020412.51927139.ryusuke@osrg.net> <AANLkTimMj1DdHaCJwJiGaKY4=+rB6jn6ru1L0koV=suK@mail.gmail.com>
 <20101221.115542.199417894.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:received:mime-version:received:in-reply-to
         :references:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        bh=BlSx03zqBriC49WShT0nnxgaeoXDQLt3bmPjL8XkAjA=;
        b=vn/cEqLAMAL/+taZyuvk52m62p/qSMO9UmO9JbUuqLJ/mWE6Jd9nFVCKHaqrqMPs8b
         jKZ63zd7d4IRtvMovOYFvGpdcfOmhJXN/iaNO9u86BRqlDI3I3zg6q30hCVLakZnUY1l
         Su5tT92/tqyUt2cR9YR2zeV9pqPWMB+M9AWr8=
In-Reply-To: <20101221.115542.199417894.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 21 December 2010 03:55, Ryusuke Konishi
<konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:
> Could you get device size information in a few ways?

Certainly.

> 1) sysfs reported sizes
> =C2=A0# cat /sys/block/sdb/size
31506432

> =C2=A0# cat /sys/block/sdb/sdb1/size
31504384

> 2) Sizes on the partition table
> =C2=A0# fdisk -lu /dev/sdb
Disk /dev/sdb: 16.1 GB, 16131293184 bytes
25 heads, 25 sectors/track, 50410 cylinders, total 31506432 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x04030201

Device Boot      Start         End      Blocks   Id  System
/dev/sdb1            2048    31506431    15752192    7  HPFS/NTFS

> 3) Dump of the first super block (it has the layout information)
> =C2=A0# dd if=3D/dev/sdb1 bs=3D1k count=3D1 skip=3D1 2>/dev/null | hd
#dd if=3D/dev/sdb1 bs=3D1k count=3D1 skip=3D1 2>/dev/null | hexdump
0000000 0002 0000 0000 3434 0100 0000 e5da ead2
0000010 e644 38c1 0002 0000 0782 0000 0000 0000
0000020 0000 c170 0003 0000 0001 0000 0000 0000
0000030 0800 0000 0005 0000 92c7 0002 0000 0000
0000040 f800 0013 0000 0000 f1e3 0001 0000 0000
0000050 6000 0007 0000 0000 8836 4c69 0000 0000
0000060 f119 4cf0 0000 0000 f119 4cf0 0000 0000
0000070 002f 0032 0000 0001 8836 4c69 0000 0000
0000080 4e00 00ed 0000 0000 0000 0000 000b 0000
0000090 0080 0020 00c0 0010 2be3 b1ef 799b cb4b
00000a0 d0a5 5ae1 9892 80a8 0000 0000 0000 0000
00000b0 0000 0000 0000 0000 0000 0000 0000 0000
*
0000400

Hope that helps. Please let me know if you need anything else.

Regards,
Jan
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
