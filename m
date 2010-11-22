From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/3] nilfs-utils: add discard support to mkfs.nilfs2
Date: Mon, 22 Nov 2010 19:24:00 +0900
Message-ID: <1290421443-27679-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This series allows mkfs.nilfs2 to issue trim/discard command to the
device.

The trim/discard is used to inform a solid-state drive or a
thin-provisioned storage which blocks of data are no longer considered
in use and can be wiped internally.  This feature is known to be
helpful for handling garbage collection overhead in recent SSDs.

With this series, mkfs2.nilfs2 attempts to use it by default to wipe
out the partition.  If the device doesn't support the discard, only
the head and tail of the partition will be zero-filled as before.

User can see if the discard is succeeded or not with "verbose" mode
option (-v):

 $ sudo mkfs -t nilfs2 -v /dev/sdb1
 mkfs.nilfs2 (nilfs-utils 2.0.20)
 Start writing file system initial data to the device
        Blocksize:4096  Device:/dev/sdb1  Device Size:80023716864
 Discard device from 1024 to 80023716864: succeeded.
 Discard succeeded and will return 0s  - skip wiping
 File system initialization succeeded !! 

If "-K" option is specified, mkfs.nilfs2 will turn off the discard.

The discard here is only applied at mkfs time.  To let the nilfs2
filesystem use it, user needs to specify "discard" mount option, which
is (experimentally) available since kernel 2.6.34.


Thanks,
Ryusuke Konishi

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
