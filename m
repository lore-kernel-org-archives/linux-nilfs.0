From: Zahid Chowdhury <zahid.chowdhury-VJizFkI/10gAspv4Qr0y0gC/G2K4zDHf@public.gmane.org>
Subject: nilfs_cleanerd from nilfs-utils shutdown on version 2.0 and 2.1
 does not fail but says nothing and does not clean the old checkpoints nor
 newer (actually older) ones.
Date: Fri, 2 Dec 2011 16:33:09 -0800
Message-ID: <053D39D3D76C474EB2D2A284AA6BA3181F26A4F05D@COLOSSEXCH01.starsolutions.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,
  If I move the system date forward, have some checkpoints created and then move the date backward a 2.0 cleanerd daemon fails on this error:
    Nov 30 14:39:37 nilfs_cleanerd[5789]: start
    Nov 30 14:39:38 kernel: nilfs_ioctl_move_inode_block: conflicting data             
        buffer: ino=4, cno=0, offset=0, blocknr=665655, vblocknr=566462
    Nov 30 14:39:38 kernel: NILFS: GC failed during preparation: cannot read 
        source blocks: err=-17
    Nov 30 14:39:38 nilfs_cleanerd[5789]: cannot clean segments: File exists
    Nov 30 14:39:38 nilfs_cleanerd[5789]: shutdown

I cannot ever start up the daemon. If I move to a 2.1 daemon, then it logs no errors, but it cleans no old or newer (really older) checkpoints - it just sits in a do-nothing mode (strace(1) shows he is hung on a mq_timedreceive syscall).

On one date change I did receive this message from the 2.0 daemon (the 2.1 daemon never says anything):
    Nov 30 13:45:30 nilfs_cleanerd[1642]: protection time rewinded: old
      period >= 1322747210, new period >= 1322689515

The fix around this is to umount the nilfs partition, move the date to after the lscp(1) future checkpoints, mount nilfs with the cleanerd, get the checkpoints cleaned up, umount nilfs, move the date back, and then mount nilfs.

Has anybody seen this error or are there any other workarounds to this error. Thanks a lot.

Zahid


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
