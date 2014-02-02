From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH v2 0/1] nilfs2: add mount option that reduces super block writes
Date: Sun,  2 Feb 2014 17:50:08 +0100
Message-ID: <cover.1391359219.git.andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

Hi,

This is an experimental patch. I am not suggesting to use this as a 
default recovery option. I had some time over the weekend to improve my 
first version significantly. The primary goal of this patch is to test 
how bad a linear scan of all segments really is for performance.

The patch introduces a mount option that allows the user to disable the 
periodic overwrite of the super block during normal file system 
operation. The super block needs to point to the latest segment, to 
allow the file system to recover in case of an unclean shutdown, but 
this leads to a lot of writes to this one particular block. This is 
usually not a problem, but it can lead to wear leveling problems with 
cheap flash based storage devices.

Instead of periodically writing to the super block, this patch only 
writes at mount and umount time and performs a linear scan for the 
latest segment in case a recovery is necessary.

Here are the test results for some devices:

100GB HDD:
Recovery:     45.042s
Normal Mount: 0.165s

100GB SSD:
Recovery:     0.752s
Normal Mount: 0.059s

16GB SD-Card:
Recovery:     3.833s
Normal Mount: 0.652s

16GB Micro-SD-Card:
Recovery:     4.011s
Normal Mount: 1.104s

8GB USB-Stick:
Recovery:     1.704s
Normal Mount: 0.549s

The HDD is obviously intolerably slow for this task, but still the read 
ahead improved its time significantly.

SSDs are really really good for these kind of random read operations. I 
measured it three times to be sure. Since I know the addresses of the 
blocks in advance, I do a 64 block read ahead so that the I/O queue of 
the SSD is always full. That way it can read with almost full bandwidth. 

The SD-Cards and the USB-Stick are not particularly fast, but they are 
small enough so that the recovery time is tolerable.

Best regards,
Andreas Rohner

---
v2: Add validity checks
    Add history of recent segments
    Add check of partial segments
    Add readahead
    Add fast crc checksum replacing ss_pad

Andreas Rohner (1):
  nilfs2: add mount option that reduces super block writes

 fs/nilfs2/recovery.c      | 248 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/segbuf.c        |  16 ++-
 fs/nilfs2/segment.c       |   3 +-
 fs/nilfs2/segment.h       |   1 +
 fs/nilfs2/super.c         |  10 +-
 fs/nilfs2/the_nilfs.c     |   3 +
 include/linux/nilfs2_fs.h |   6 +-
 7 files changed, 281 insertions(+), 6 deletions(-)

-- 
1.8.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
