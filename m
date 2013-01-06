From: Elmer Zhang <freeboy6716-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: nilfs causes the server crashed
Date: Sun, 6 Jan 2013 15:44:25 +0800
Message-ID: <0E29E2A8-658D-4911-A1B9-7080BAFDE020@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:from:content-type:content-transfer-encoding:subject
         :message-id:date:to:mime-version:x-mailer;
        bh=SdT7HLDMkSxsRQgIQi8I0nJrn9ehhTFKklsFCuMV7eY=;
        b=klOQqbauCb8/kenOn78WqGzgqLcznfwEPvwPmSbhzCteBaGxpxm73B6wzk8ajIV3mu
         zruETEkgkcmNqidDs+V8rWH/fyW/JsLr3tBnCQRtqFWqSeoLDjpTSrdg5Nd0M/r67996
         VV3wyT1q1jj/rK5sX/aV6bJsbBAeqRUOHduUHV2iCgRhocCmf5IyFn5P7wyKpB1f9Hlo
         O0Wu743UGCLmSghIM61PYQ3RECDP39E38bWm/ixkWqKFgRVny4q1z3QPdlbzFwUDS6OY
         c1pgGKct55uuAu/5yfR2OAbj5+OSgwiszeKmmarP3N5dXusfSPeVnik5i7ekwe+JB7Jn
         nA6A==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
My server always crash and reboot when I start MySQLs which stores the data on NILFS2 filesystem.

I found some vmcore, but they are so big and I don't know how to extract useful information from them.
 ~]# ll -h /var/crash/*/*
-rw------- 1 root root 141M Dec 20 16:14 /var/crash/127.0.0.1-2012-12-20-16:14:03/vmcore
-rw------- 1 root root 512M Jan  4 16:00 /var/crash/127.0.0.1-2013-01-04-15:59:20/vmcore
-rw------- 1 root root  92M Jan  4 16:25 /var/crash/127.0.0.1-2013-01-04-16:25:35/vmcore
-rw------- 1 root root  62M Jan  4 16:50 /var/crash/127.0.0.1-2013-01-04-16:50:02/vmcore
-rw------- 1 root root  63M Jan  4 18:55 /var/crash/127.0.0.1-2013-01-04-18:55:43/vmcore
-rw------- 1 root root  80M Jan  5 14:55 /var/crash/127.0.0.1-2013-01-05-14:55:15/vmcore
-rw------- 1 root root  65M Jan  5 15:30 /var/crash/127.0.0.1-2013-01-05-15:30:35/vmcore
-rw------- 1 root root 199M Jan  6 15:06 /var/crash/127.0.0.1-2013-01-06-15:06:19/vmcore

And below is some snapshot of the screen, hope it's useful:
http://d.pr/i/4OZR
http://d.pr/i/10M3
http://d.pr/i/HnJn
http://d.pr/i/HW6t

My environment:
kernel: 2.6.32-220.13.1.el6.x86_64
kmod-nilfs2-0.4.3-1.el6.x86_64
nilfs-utils-2.1.4-7.x86_64
Raid: raid10 with SEAGATE ST32000444SS(2TB) * 12
mount: /dev/sdb2 on /data0 type nilfs2 (rw,noatime,gcpid=9047)

~]# nilfs-tune -l /dev/sdb2 
nilfs-tune 2.1.4
Filesystem volume name:	  (none)
Filesystem UUID:	  dcfb7152-a342-48d0-a712-212a3062395e
Filesystem magic number:  0x3434
Filesystem revision #:	  2.0
Filesystem features:      (none)
Filesystem state:	  invalid or mounted,error
Filesystem OS type:	  Linux
Block size:		  4096
Filesystem created:	  Mon Dec  3 13:56:51 2012
Last mount time:	  Sun Jan  6 15:41:34 2013
Last write time:	  Sun Jan  6 15:41:34 2013
Mount count:		  25
Maximum mount count:	  50
Reserve blocks uid:	  0 (user root)
Reserve blocks gid:	  0 (group root)
First inode:		  11
Inode size:		  128
DAT entry size:		  32
Checkpoint size:	  192
Segment usage size:	  16
Number of segments:	  1246464
Device size:		  10456104173568
First data block:	  1
# of blocks per segment:  2048
Reserved segments %:	  5
Last checkpoint #:	  6327388
Last block address:	  256856089
Last sequence #:	  3862375
Free blocks count:	  598300672
Commit interval:	  60
# of blks to create seg:  0
CRC seed:		  0x3adfb6c3
CRC check sum:		  0xca2168f3
CRC check data size:	  0x00000118
 

Thanks
---
Elmer Zhang

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
