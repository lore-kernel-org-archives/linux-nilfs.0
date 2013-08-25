From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Cleaner won't start
Date: Sun, 25 Aug 2013 18:43:59 -0400
Message-ID: <CALJXSJq9DR6tapLRvq3rZGFsne-CUriruGAyzgO7pAB9ESe-bA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:content-type;
        bh=aPlIqRkLSxLZTUuR/q64nlEjQV3DY/1r2rHOSzxrVpc=;
        b=bvrCcbhPjQ0yG9fCSE504LKk81JHt/J4TziooWcF58kY0dLhfMBYMDitQpNXXIUwVe
         qO+371vpKpWa/r8mlr5Ri9O9jD+evlS6q0Mc32H+ULOEETfDGPO8zxqTcxcoXSzn08Fj
         GB+xxgZXS+d2n6gH1Vaw3pFdyVeZ9BV35YNO3BxK+hFPi+hLFVlTpYpai5Z8fgFU0VF9
         J2Q0b4fHp8BTgUR3/ccvuwDGakcylTKuK0PHeHxoziyPRQmVY/8AVpHKGC5jITIF+wZT
         gDjj53ntCQNoTrFCOgDBRfpiTsU8V/9yerGSZYgsbyUcDC9S3rM+gKJ9RYWYQiv5dXSq
         KUNg==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

I don't know if it is related to my other problem, but now, the
cleaner won't start. I noticed low disk space warnings and now at 91%
used space.

Here is what syslog has to say:
Aug 25 18:37:22 nilfs_cleanerd[3512]: start
Aug 25 18:37:22 nilfs_cleanerd[3512]: pause (clean check)
Aug 25 18:37:22 nilfs_cleanerd[3512]: resume (clean check)
Aug 25 18:37:23 kernel: [  758.822120] nilfs_ioctl_move_inode_block:
conflicting data buffer: ino=76070, cno=3769693, offset=0,
blocknr=46096310, vblocknr=4731085
Aug 25 18:37:23 kernel: [  758.822158] NILFS: GC failed during
preparation: cannot read source blocks: err=-17
Aug 25 18:37:23 nilfs_cleanerd[3512]: cannot clean segments: File exists
Aug 25 18:37:23 nilfs_cleanerd[3512]: shutdown

If it is related, should I start from scratch or should we debug this?
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
