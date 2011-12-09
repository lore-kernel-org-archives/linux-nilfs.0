From: Zahid Chowdhury <zahid.chowdhury-VJizFkI/10gAspv4Qr0y0gC/G2K4zDHf@public.gmane.org>
Subject: RE: nilfs_cleanerd from nilfs-utils shutdown on version 2.0 and 2.1
 does not fail but says nothing and does not clean the old checkpoints nor
 newer (actually older) ones.
Date: Fri, 9 Dec 2011 14:39:39 -0800
Message-ID: <053D39D3D76C474EB2D2A284AA6BA3181F26AE83D1@COLOSSEXCH01.starsolutions.com>
References: <20111209.132225.33374267.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111209.132225.33374267.ryusuke-sG5X7nlA6pw@public.gmane.org>
Content-Language: en-US
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello Ryusuke,
  Yes, the Dec. 2 dates are the rewound dates - no cleanup happens of any of the checkpoints created on Dec. 2 after this (nor the Dec. 8 ones) - thus the disk will just fill-up unless you end up reaching Dec. 8 before the fill-up. One time on testing with the 2.1 gc daemon we got crashes on each startup (i.e. the stacktrace below), none of the other times did get a 2.1 crash - 3 - 4 times we tried - i.e. the cleaner crash was a different problem, cleared up on a reboot. Thanks, any help is much appreciated.

Zahid

-----Original Message-----
From: Ryusuke Konishi [mailto:konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org] 
Sent: Thursday, December 08, 2011 8:22 PM
To: Zahid Chowdhury
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: Re: nilfs_cleanerd from nilfs-utils shutdown on version 2.0 and 2.1 does not fail but says nothing and does not clean the old checkpoints nor newer (actually older) ones.

On Wed, 7 Dec 2011 17:43:13 -0800, Zahid Chowdhury wrote:
> Hello,
>   On further testing with more iterations with nilfs 2.1 with a only
>   a date rewind (across reboots also) the old dates do not get
>   cleaned up and the new checkpoints with the rewound dates are not
>   cleaned up (my previous testing with 2.1 daemon was on a loopback
>   mount and involved 2 iterations - all testing now was on live
>   systems) - though the 2.1 daemon does not crash it is a do nothing
>   process. A few times we had nilfs_cleanerd 2.1 crashes (reboots
>   fixed that - no crashes, but no checkpoint cleanup after the
>   reboot). Here is the stacktrace from the crash for a 3.0.4 kernel:
> 
> Dec  2 13:53:22  kernel: Pid: 1717, comm: nilfs_cleanerd Not tainted 3.0.4 #4
> Dec  2 13:53:22  kernel: Call Trace:
> Dec  2 13:53:22  kernel:  [<c043e1d0>] ? warn_slowpath_common+0x65/0x7a
> Dec  2 13:53:22  kernel:  [<c043e1f9>] ? warn_slowpath_null+0x14/0x18
> Dec  2 13:53:22  kernel:  [<f84c000d>] ? nilfs_ioctl_move_blocks+0x11d/0x199 [nilfs2]
> Dec  2 13:53:22  kernel:  [<f84c02cd>] ? nilfs_ioctl_clean_segments+0x236/0x2b6 [nilfs2]
> Dec  2 13:53:22  kernel:  [<f84bfd23>] ? nilfs_ioctl_get_bdescs+0x68/0x7b [nilfs2]
> Dec  2 13:53:22  kernel:  [<f84c06f2>] ? nilfs_ioctl+0x192/0x1bb [nilfs2]
> Dec  2 13:53:22  kernel:  [<f84c0560>] ? nilfs_ioctl_set_alloc_range+0x12b/0x12b [nilfs2]
> Dec  2 13:53:22  kernel:  [<c04fffdc>] ? vfs_ioctl+0x1e/0x38
> Dec  2 13:53:22  kernel:  [<c050061c>] ? do_vfs_ioctl+0x164/0x16b
> Dec  2 13:53:22  kernel:  [<c0500668>] ? sys_ioctl+0x45/0x5c
> Dec  2 13:53:22  kernel:  [<c07311df>] ? sysenter_do_call+0x12/0x28
> Dec  2 13:53:22  kernel:  [<c0720000>] ? ab8500_regulator_probe+0x147/0x1af
> Dec  2 13:53:22  kernel: ---[ end trace 34bfcccc859adad2 ]---
> Dec  2 13:53:22  kernel: NILFS: GC failed during preparation: cannot read source blocks: err=-17
> Dec  2 13:53:22  nilfs_cleanerd[1717]: cannot clean segments: File exists
> Dec  2 13:53:22  nilfs_cleanerd[1717]: shutdown
> Dec  2 14:06:10  nilfs_cleanerd[15310]: start
> Dec  2 14:06:12  kernel: ------------[ cut here ]------------
> Dec  2 14:06:12  kernel: WARNING: at fs/nilfs2/ioctl.c:449 nilfs_ioctl_move_blocks+0x11d/0x199 [nilfs2]()
> Dec  2 14:06:12  kernel: Pid: 15310, comm: nilfs_cleanerd Tainted: G        W   3.0.4 #4
> Dec  2 14:06:12  kernel: Call Trace:
> Dec  2 14:06:12  kernel:  [<c043e1d0>] ? warn_slowpath_common+0x65/0x7a
> Dec  2 14:06:12  kernel:  [<c043e1f9>] ? warn_slowpath_null+0x14/0x18
> Dec  2 14:06:12  kernel:  [<f84c000d>] ? nilfs_ioctl_move_blocks+0x11d/0x199 [nilfs2]
> Dec  2 14:06:12  kernel:  [<f84c02cd>] ? nilfs_ioctl_clean_segments+0x236/0x2b6 [nilfs2]
> Dec  2 14:06:12  kernel:  [<f84bfd23>] ? nilfs_ioctl_get_bdescs+0x68/0x7b [nilfs2]
> Dec  2 14:06:12  kernel:  [<f84c06f2>] ? nilfs_ioctl+0x192/0x1bb [nilfs2]
> Dec  2 14:06:12  kernel:  [<f84c0560>] ? nilfs_ioctl_set_alloc_range+0x12b/0x12b [nilfs2]
> Dec  2 14:06:12  kernel:  [<c04fffdc>] ? vfs_ioctl+0x1e/0x38
> Dec  2 14:06:12  kernel:  [<c050061c>] ? do_vfs_ioctl+0x164/0x16b
> Dec  2 14:06:12  kernel:  [<c0500668>] ? sys_ioctl+0x45/0x5c
> Dec  2 14:06:12  kernel:  [<c07311df>] ? sysenter_do_call+0x12/0x28
> Dec  2 14:06:12  kernel: ---[ end trace 34bfcccc859adad3 ]---
> Dec  2 14:06:12  kernel: NILFS: GC failed during preparation: cannot read source blocks: err=-17
> Dec  2 14:06:12  nilfs_cleanerd[15310]: cannot clean segments: File exists
> Dec  2 14:06:12  nilfs_cleanerd[15310]: shutdown
> Dec  2 14:08:11  nilfs_cleanerd[15574]: start
> Dec  2 14:08:13  kernel: ------------[ cut here ]------------
> Dec  2 14:08:13  kernel: WARNING: at fs/nilfs2/ioctl.c:449 nilfs_ioctl_move_blocks+0x11d/0x199 [nilfs2]()
> 
> Note, that moving the date forward from to the most forward
> checkpoint in the future cleans all checkpoints in both 2.0 & 2.1
> daemons.
> 
> Zahid

Thank you for the test.

"Dec 2" lines are rewound dates, right ? 
So you mean the cleaner crash was different problem ?

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
