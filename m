From: "customersupport-F+CjGebjtwRZroRs9YW3xA@public.gmane.org" <customersupport-F+CjGebjtwRZroRs9YW3xA@public.gmane.org>
Subject: error mounting, input/output error
Date: Fri, 1 Dec 2017 22:53:06 +0800
Message-ID: <ec8264d8-fb4c-b584-88c1-41ba293aa826@rapidbsure.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=rapidbsure.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Date:Message-ID:Subject:From:To:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=q1zL/lubv791wUM1/ViiRRWjkEjljHKnsGSs+qUCKj4=; b=SbHpKjjv1SeF59pE/OGYO1BCXI
        fOlsmbJYSSR/P0zHC58HP8S2pHPxKcPZeGG80HAT8LNNZ7uh6I2WW4+9VCIqiX7ESCPw/fMB/otW1
        ILLXKbUmWiajK0KYDm0nT5mk2TVIt6oJohGH6WTRt1bi9xbctj3gScMGFFk+cr1v4JhI=;
Content-Language: en-US
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

I have a working hard drive that stopped being able to read the nilfs2
partition after a low battery laptop shutdown

There is no fsck function available, and I failed to copy the image and
reinstall to a reformated partition- as explained below.

Can someone please suggest how to recover the data?

When mounting the partition with

mount -t "nilfs2" -o "uhelper=3Dudisks2,nodev,nosuid" "/dev/sdb2"
"/media/user/Unallocated"
or
mount -t "nilfs2" -o "errors=3Dcontinue,uhelper=3Dudisks2,nodev,nosuid"
"/dev/sdb2" "/media/user/Unallocated"

I get an I/O error "Error while mounting... Input/output error"

output of dmesg


[ 3521.639526] NILFS (sdb2): mounting unchecked fs
[ 3524.672660] ata2.00: exception Emask 0x0 SAct 0x3e000 SErr 0x0 action =
0x0
[ 3524.672668] ata2.00: irq_stat 0x40000008
[ 3524.672673] ata2.00: failed command: READ FPDMA QUEUED
[ 3524.672681] ata2.00: cmd 60/40:68:c0:5d:ba/05:00:e3:00:00/40 tag 13
ncq dma 688128 in
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 res 41/40=
:00:e0:60:ba/00:00:e3:00:00/40 Emask
0x409 (media error) <F>
[ 3524.672684] ata2.00: status: { DRDY ERR }
[ 3524.672687] ata2.00: error: { UNC }
[ 3524.686112] ata2.00: configured for UDMA/133
[ 3524.686206] sd 1:0:0:0: [sdb] tag#13 FAILED Result: hostbyte=3DDID_OK
driverbyte=3DDRIVER_SENSE
[ 3524.686210] sd 1:0:0:0: [sdb] tag#13 Sense Key : Medium Error [current=
]
[ 3524.686213] sd 1:0:0:0: [sdb] tag#13 Add. Sense: Unrecovered read
error - auto reallocate failed
[ 3524.686218] sd 1:0:0:0: [sdb] tag#13 CDB: Read(10) 28 00 e3 ba 5d c0
00 05 40 00
[ 3524.686221] print_req_error: I/O error, dev sdb, sector 3820642528
[ 3524.686272] ata2: EH complete
[ 3527.523500] ata2.00: exception Emask 0x0 SAct 0x4000000 SErr 0x0
action 0x0
[ 3527.523507] ata2.00: irq_stat 0x40000008
[ 3527.523510] ata2.00: failed command: READ FPDMA QUEUED
[ 3527.523514] ata2.00: cmd 60/08:d0:e0:60:ba/00:00:e3:00:00/40 tag 26
ncq dma 4096 in
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 res 41/40=
:00:e0:60:ba/00:00:e3:00:00/40 Emask
0x409 (media error) <F>
[ 3527.523516] ata2.00: status: { DRDY ERR }
[ 3527.523517] ata2.00: error: { UNC }
[ 3527.536847] ata2.00: configured for UDMA/133
[ 3527.536869] sd 1:0:0:0: [sdb] tag#26 FAILED Result: hostbyte=3DDID_OK
driverbyte=3DDRIVER_SENSE
[ 3527.536874] sd 1:0:0:0: [sdb] tag#26 Sense Key : Medium Error [current=
]
[ 3527.536878] sd 1:0:0:0: [sdb] tag#26 Add. Sense: Unrecovered read
error - auto reallocate failed
[ 3527.536885] sd 1:0:0:0: [sdb] tag#26 CDB: Read(10) 28 00 e3 ba 60 e0
00 00 08 00
[ 3527.536887] print_req_error: I/O error, dev sdb, sector 3820642528
[ 3527.536927] ata2: EH complete
[ 3527.536930] NILFS (sdb2): I/O error reading segment
[ 3527.536932] NILFS (sdb2): error -5 while searching super root
--------------------------------------

I tried to clone the partition with partclone using this command

sudo partclone.nilfs2 -c -d -s /dev/sdb2 | gzip -c > /dev/sdb1/sdb2.gz

, but received this error in the logfile:

-------------------

Partclone v0.3.6 http://partclone.org
Starting to clone device (/dev/sdb2) to image (-)
UID is root.
source=3D/dev/sdb2, target=3D-
open source file/device /dev/sdb2
open target file/device -
Initiate image options - version 0002
Initial image hdr - get Super Block from partition
Reading Super Block
nilfsclone.c: cannot open NILFS on /dev/sdb2: Invalid argument

-------------------

I don't know if this is helpful, but here is the output of nilfs-tune

$ sudo nilfs-tune -l /dev/sdb2
[sudo] password for user:
nilfs-tune 2.2.6
Filesystem volume name:=C2=A0=C2=A0=C2=A0 =C2=A0 Unallocated
Filesystem UUID:=C2=A0=C2=A0=C2=A0 =C2=A0 17d750ba-5656-40f5-9b6a-1a608f6=
d6108
Filesystem magic number:=C2=A0 0x3434
Filesystem revision #:=C2=A0=C2=A0=C2=A0 =C2=A0 2.0
Filesystem features:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (none)
Filesystem state:=C2=A0=C2=A0=C2=A0 =C2=A0 invalid or mounted
Filesystem OS type:=C2=A0=C2=A0=C2=A0 =C2=A0 Linux
Block size:=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0 4096
Filesystem created:=C2=A0=C2=A0=C2=A0 =C2=A0 Mon Oct 23 19:49:38 2017
Last mount time:=C2=A0=C2=A0=C2=A0 =C2=A0 Fri Dec=C2=A0 1 15:10:48 2017
Last write time:=C2=A0=C2=A0=C2=A0 =C2=A0 Fri Dec=C2=A0 1 16:39:31 2017
Mount count:=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0 32
Maximum mount count:=C2=A0=C2=A0=C2=A0 =C2=A0 50
Reserve blocks uid:=C2=A0=C2=A0=C2=A0 =C2=A0 0 (user root)
Reserve blocks gid:=C2=A0=C2=A0=C2=A0 =C2=A0 0 (group root)
First inode:=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0 11
Inode size:=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0 128
DAT entry size:=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0 32
Checkpoint size:=C2=A0=C2=A0=C2=A0 =C2=A0 192
Segment usage size:=C2=A0=C2=A0=C2=A0 =C2=A0 16
Number of segments:=C2=A0=C2=A0=C2=A0 =C2=A0 61625
Device size:=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0 516950065152
First data block:=C2=A0=C2=A0=C2=A0 =C2=A0 1
# of blocks per segment:=C2=A0 2048
Reserved segments %:=C2=A0=C2=A0=C2=A0 =C2=A0 5
Last checkpoint #:=C2=A0=C2=A0=C2=A0 =C2=A0 449665
Last block address:=C2=A0=C2=A0=C2=A0 =C2=A0 115409102
Last sequence #:=C2=A0=C2=A0=C2=A0 =C2=A0 114861
Free blocks count:=C2=A0=C2=A0=C2=A0 =C2=A0 30955520
Commit interval:=C2=A0=C2=A0=C2=A0 =C2=A0 0
# of blks to create seg:=C2=A0 0
CRC seed:=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0 0x157de9a6
CRC check sum:=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0 0xb33a8ce1
CRC check data size:=C2=A0=C2=A0=C2=A0 =C2=A0 0x00000118
user@user:~$ nilfs-utils


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
