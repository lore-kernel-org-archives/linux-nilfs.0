From: Andrea Gelmini <andrea.gelmini-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Problem setting CP interval
Date: Wed, 8 Jun 2011 18:53:01 +0200
Message-ID: <BANLkTim7Dp7-U1ee1hm7EWpw5We+pPBjAw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        bh=YZkA4XQTf/8bF/3JL68GHswW/E4iHUgSTLjoysAoBlc=;
        b=vUB8ffrrPgpHke93hQk7WZWsgHqu5uHak7eRv8v4aY3MXLTynjDuDdsNo6cXf/rTyN
         5lMG8Vi5RpJb4+ZjBm7MkSxo70BO4yFImW1v9YJF3PnybNAdWdejLPgBQ1kifSOVF+g9
         IT7PECxdHWrPFeT8G7gRfRsTAGYSUSRY2Y6MA=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="tis-620"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi all,
   and thanks a lot for your work on NILFS2. It's wonderful.
   I'm using it for my /home, and it works good.
   Today I tried to change checkpoint interval using nilfs-tune.=C2=B9
   So, nilfs-tune -l gives me:

nilfs-tune 2.1.0-rc1
=46ilesystem volume name:	  home
=46ilesystem UUID:	  b22b2da4-be32-4e0c-ba33-1adeff256e2f
=46ilesystem magic number:  0x3434
=46ilesystem revision #:	  2.0
=46ilesystem features:      (none)
=46ilesystem state:	  invalid or mounted
=46ilesystem OS type:	  Linux
Block size:		  2048
=46ilesystem created:	  Mon Jun  6 19:55:33 2011
Last mount time:	  Wed Jun  8 18:40:20 2011
Last write time:	  Wed Jun  8 18:48:16 2011
Mount count:		  20
Maximum mount count:	  50
Reserve blocks uid:	  0 (user root)
Reserve blocks gid:	  0 (group root)
=46irst inode:		  11
Inode size:		  128
DAT entry size:		  32
Checkpoint size:	  192
Segment usage size:	  16
Number of segments:	  35678
Device size:		  149648572416
=46irst data block:	  2
# of blocks per segment:  2048
Reserved segments %:	  1
Last checkpoint #:	  50352
Last block address:	  50374721
Last sequence #:	  24583
=46ree blocks count:	  22718464
Commit interval:	  20
# of blks to create seg:  0
CRC seed:		  0x8987044d
CRC check sum:		  0xc50b9714
CRC check data size:	  0x00000118

   But it doesn't care... I can change 'Commit interval' in any way,
   but when I mount it I see this:
[ 2366.096819] segctord starting. Construction interval =3D 0 seconds,
CP frequency < 30 seconds
[ 2535.082421] segctord starting. Construction interval =3D 0 seconds,
CP frequency < 30 seconds

   So, I have continuos checkpoint, like this:
   lscp|tail
               50244  2011-06-08 18:45:22   cp    -          141     60=
0277
               50245  2011-06-08 18:45:22   cp    -           41     60=
0277
               50246  2011-06-08 18:45:22   cp    -           57     60=
0277
               50247  2011-06-08 18:45:23   cp    -         5884     60=
0277
               50248  2011-06-08 18:45:23   cp    -         7736     60=
0277
               50249  2011-06-08 18:45:23   cp    -          747     60=
0276

I've tried stock Ubuntu kernel, also, but it's always the same.

Thanks a lot for your time,
Andrea

---------------------
=C2=B9 I'm using latest git tree for nilfs tools and kernel.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
