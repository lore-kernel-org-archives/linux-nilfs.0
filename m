From: Paul L <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Segment magic number invalid
Date: Fri, 14 May 2010 20:24:02 -0400
Message-ID: <AANLkTikEfAtM5PdXSFw5pA_8mDW5pcyxes3GTO3kMBPa@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:received:received:date:message-id
         :subject:from:to:content-type;
        bh=70MVYzArqxBXzr7p1NzY/R7X+DqLyCIZQexYPxdgorI=;
        b=R/nWFHlNmMv+Bm4B+OUSevL7+/lbj/Y9kQsjhupY622mKgCekZV8KKcfVz+kbXm3IQ
         UNLn62ZI6VEysEdVtkl5VCAMghzgslLXD4PHDQye9tS2+Y5pshnbubZHUIAnrJih6AN7
         wlbzHwLvTFvDhGudRzFN+JYvVPVViVHRyVeK0=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

I have my home directory mounted as a nilfs2 partition. Today what
happened was that first I noticed google-chrome reporting it cannot
load user profile, I initially thought it was a google-chrome error.
At the time I was still able to view and modify my home directory. But
then after rebooting the system, my home partition no longer mounts.
I'm using nilfs-2.0.19 and nilfs-utils-2.0.18 with Linux kernel
2.6.28.

Here is the error message from dmesg (after turning on debugging
message for nilfs2):

NILFS nilfs_fill_super: start(silent=0)
NILFS(recovery) nilfs_search_super_root: looking segment
(seg_start=1607680, seg_end=1609727, segnum=785, seg_seq=307637)
NILFS(recovery) load_segment_summary: checking segment
(pseg_start=1608334, full_check=0)
NILFS(recovery) load_segment_summary: done (ret=3)
NILFS(recovery) nilfs_search_super_root: strayed: scan_newer=0, ret=3
NILFS warning: Segment magic number invalid
NILFS: error searching super root.
NILFS nilfs_fill_super: aborted
NILFS put_nilfs: the_nilfs on bdev mmcblk0p1 was freed

I then dumped the first and last (backup) copy of the nilfs2 super
block, they are identical, and given below:

00000400   02 00 00 00 00 00 34 34  00 01 00 00 A1 6A E9 71  ......44.....j.q
00000410   A3 F1 DD BE 02 00 00 00  AF 07 00 00 00 00 00 00  ................
00000420   00 E0 BF D7 03 00 00 00  01 00 00 00 00 00 00 00  ................
00000430   00 08 00 00 05 00 00 00  7C 3D 0A 00 00 00 00 00  ........|=......
00000440   8E 8A 18 00 00 00 00 00  B5 B1 04 00 00 00 00 00  ................
00000450   00 B8 23 00 00 00 00 00  B9 AF F3 4A 00 00 00 00  ..#........J....
00000460   D9 E1 D6 4B 00 00 00 00  49 8F ED 4B 00 00 00 00  ...K....I..K....
00000470   37 00 32 00 03 00 01 00  B9 AF F3 4A 00 00 00 00  7.2........J....elp
00000480   00 4E ED 00 00 00 00 00  00 00 00 00 0B 00 00 00  .N..............
00000490   80 00 20 00 C0 00 10 00  13 1C FC 11 D7 43 4C 09  .. ..........CL.
000004A0   81 64 93 0A F4 54 CF 5E  48 4F 4D 45 00 00 00 00  .d...T.^HOME....


I wonder if there is a fsck tool to help me recover the file system.
Any help is greatly appreciated!

PS: last time I had a different problem of losing partition info, and
later successfully recovered with the help from people on the list. So
thanks! Now I'm actually backing up my files every two weeks, but
it'll still be great if it can recover and even better if we can trace
the problem.

-- 
Regards,
Paul Liu

Yale Haskell Group
http://www.haskell.org/yale
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
