From: Viacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Unrecovered read error issue
Date: Fri, 18 Dec 2015 17:26:12 -0800
Message-ID: <1450488372.2652.25.camel@slavad-ubuntu-14.04>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:content-type:mime-version
         :content-transfer-encoding;
        bh=Wpm592T+rUAqX4QZaqZ2l49gFcQotuxDBXa1naFeDUY=;
        b=b0hk40qiZ1wtHXuhDSTAWDBYFfP7C+dFa5qCVjAABIpeDwSbR3dRQC/xXCGr6aL1Y/
         8K0bU4f85jarC+BXMzwQJNjHMRoOSAmYCdguI1jofPMNyBUa87lsFJrPtSyzLXh6N4VT
         nL3EdJEqCZRKfhQx69jeJeabB7NY+NFYMUNrZQtmanqi5sIAIZFfDfaX8GkZ9yaFQ2IE
         30HYoSAzj3oVSMXHsarcyhosLtaN7D414BW5jqwFfofxu6Dnxt0mYdT6ju2FPGC98OsW
         /ntElKrLO29nq0JWXyjxhbjuAZWSE8jftGdKWNWBQcr7hlOCqi78mfRBK7O5LlkB1Wbm
         QXYw==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Brian Cottingham <spiffytech-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Ryusuke,

Recently, Brian Cottingham <spiffytech-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> reported about issue
with GC of NILFS2. He shared environment and issue details:

Linux spiffyhome 3.16.0-4-amd64 #1 SMP Debian 3.16.7-ckt11-1+deb8u6
(2015-11-09) x86_64 GNU/Linux
nilfs-tools 2.2.1-1

This partition is used for bulk media storage and to hold backups from
my other devices. Pretty low-use; it mostly just sits there waiting
for new data.

The drive is an HDD, purchased 2014-09-04:
http://smile.amazon.com/dp/B00EHBEUZO/ref=pe_385040_121528360_TE_dp_5?sa-no-redirect=1

Model: ATA WDC WD40EZRX-00S (scsi)
Disk /dev/sdb: 4001GB
Sector size (logical/physical): 512B/4096B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size    File system  Name  Flags
 1      1049kB  4001GB  4001GB  nilfs2

Disk /dev/sdb: 3.7 TiB, 4000787030016 bytes, 7814037168 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes

Dec 17 16:02:13 spiffyhome kernel: [175681.852060] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
Dec 17 16:02:13 spiffyhome kernel: [175681.852066] ata2.00: BMDMA stat 0x25
Dec 17 16:02:13 spiffyhome kernel: [175681.852070] ata2.00: failed command: READ DMA EXT
Dec 17 16:02:13 spiffyhome kernel: [175681.852077] ata2.00: cmd 25/00:00:40:b0:fc/00:04:5a:00:00/e0 tag 0 dma 524288 in
Dec 17 16:02:13 spiffyhome kernel: [175681.852077]          res 51/40:4f:f0:b2:fc/40:01:5a:00:00/e0 Emask 0x9 (media error)
Dec 17 16:02:13 spiffyhome kernel: [175681.852081] ata2.00: status: { DRDY ERR }
Dec 17 16:02:13 spiffyhome kernel: [175681.852083] ata2.00: error: { UNC }
Dec 17 16:02:14 spiffyhome kernel: [175681.880266] ata2.00: configured for UDMA/133
Dec 17 16:02:14 spiffyhome kernel: [175681.880680] sd 1:0:0:0: [sdb] Unhandled sense code
Dec 17 16:02:14 spiffyhome kernel: [175681.880683] sd 1:0:0:0: [sdb]
Dec 17 16:02:14 spiffyhome kernel: [175681.880685] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Dec 17 16:02:14 spiffyhome kernel: [175681.880688] sd 1:0:0:0: [sdb]
Dec 17 16:02:14 spiffyhome kernel: [175681.880689] Sense Key : Medium Error [current] [descriptor]
Dec 17 16:02:14 spiffyhome kernel: [175681.880692] Descriptor sense data with sense descriptors (in hex):
Dec 17 16:02:14 spiffyhome kernel: [175681.880694]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
Dec 17 16:02:14 spiffyhome kernel: [175681.880701]         5a fc b2 f0
Dec 17 16:02:14 spiffyhome kernel: [175681.880705] sd 1:0:0:0: [sdb]
Dec 17 16:02:14 spiffyhome kernel: [175681.880707] Add. Sense: Unrecovered read error - auto reallocate failed
Dec 17 16:02:14 spiffyhome kernel: [175681.880709] sd 1:0:0:0: [sdb] CDB:
Dec 17 16:02:14 spiffyhome kernel: [175681.880711] Read(16): 88 00 00 00 00 00 5a fc b0 40 00 00 04 00 00 00
Dec 17 16:02:14 spiffyhome kernel: [175681.880720] end_request: I/O error, dev sdb, sector 1526510320
Dec 17 16:02:14 spiffyhome kernel: [175681.880756] ata2: EH complete
Dec 17 16:02:14 spiffyhome kernel: [175681.880916] NILFS: GC failed during preparation: cannot read source blocks: err=-5

So, it's possible to see that the reason of issue is unrecoverable read
error on HDD side. But the bad thing here that GC stops on every start
because it encounters I/O error again and again. Finally, aged segments
don't reclaim at all. And, as result, free space of a volume is
exhausted.

From one point of view, GC behavior is correct. GC encounters I/O error
because of external reasons and it stops. But such GC behavior is
completely wrong from end user's point of view. Because bad sector is
not critical issue for stopping GC and file system operations. So, the
ideal solution could be some erasure coding scheme implementation. But
even erasure coding scheme is unable to guarantee complete resolving of
such potential issue. Moreover, opportunity to encounter some error on
drive side is much higher for modern HDD with huge capacity (several
TBs) or modern SSDs. So, it makes sense to implement simple solution for
processing likewise issues on GC side. One of the possible solution
could be to return zeroed block for moving with informing end-user about
such issue in syslog. Another way could be to inform user about such
issue and to provide some user-space tool for recovering volume state.
But again recovering will be simply moving zeroed block.

So, what do you think about such issue? What possible and easy solution
do you see? We haven't opportunity for long-term implementation and we
need in some easy hack for it. What do you think?

Thanks,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
