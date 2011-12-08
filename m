From: Zahid Chowdhury <zahid.chowdhury-VJizFkI/10gAspv4Qr0y0gC/G2K4zDHf@public.gmane.org>
Subject: RE: nilfs_cleanerd from nilfs-utils shutdown on version 2.0 and 2.1
 does not fail but says nothing and does not clean the old checkpoints nor
 newer (actually older) ones.
Date: Wed, 7 Dec 2011 17:43:13 -0800
Message-ID: <053D39D3D76C474EB2D2A284AA6BA3181F26A4F56B@COLOSSEXCH01.starsolutions.com>
References: <053D39D3D76C474EB2D2A284AA6BA3181F26A4F1F5@COLOSSEXCH01.starsolutions.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <053D39D3D76C474EB2D2A284AA6BA3181F26A4F1F5-ZjuI7xOJlFPnaE3xbIMyWkCiaQ3SRT3KFkJ40O1dFu8@public.gmane.org>
Content-Language: en-US
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hello,
  On further testing with more iterations with nilfs 2.1 with a only a date rewind (across reboots also) the old dates do not get cleaned up and the new checkpoints with the rewound dates are not cleaned up (my previous testing with 2.1 daemon was on a loopback mount and involved 2 iterations - all testing now was on live systems) - though the 2.1 daemon does not crash it is a do nothing process. A few times we had nilfs_cleanerd 2.1 crashes (reboots fixed that - no crashes, but no checkpoint cleanup after the reboot). Here is the stacktrace from the crash for a 3.0.4 kernel:

Dec  2 13:53:22  kernel: Pid: 1717, comm: nilfs_cleanerd Not tainted 3.0.4 #4
Dec  2 13:53:22  kernel: Call Trace:
Dec  2 13:53:22  kernel:  [<c043e1d0>] ? warn_slowpath_common+0x65/0x7a
Dec  2 13:53:22  kernel:  [<c043e1f9>] ? warn_slowpath_null+0x14/0x18
Dec  2 13:53:22  kernel:  [<f84c000d>] ? nilfs_ioctl_move_blocks+0x11d/0x199 [nilfs2]
Dec  2 13:53:22  kernel:  [<f84c02cd>] ? nilfs_ioctl_clean_segments+0x236/0x2b6 [nilfs2]
Dec  2 13:53:22  kernel:  [<f84bfd23>] ? nilfs_ioctl_get_bdescs+0x68/0x7b [nilfs2]
Dec  2 13:53:22  kernel:  [<f84c06f2>] ? nilfs_ioctl+0x192/0x1bb [nilfs2]
Dec  2 13:53:22  kernel:  [<f84c0560>] ? nilfs_ioctl_set_alloc_range+0x12b/0x12b [nilfs2]
Dec  2 13:53:22  kernel:  [<c04fffdc>] ? vfs_ioctl+0x1e/0x38
Dec  2 13:53:22  kernel:  [<c050061c>] ? do_vfs_ioctl+0x164/0x16b
Dec  2 13:53:22  kernel:  [<c0500668>] ? sys_ioctl+0x45/0x5c
Dec  2 13:53:22  kernel:  [<c07311df>] ? sysenter_do_call+0x12/0x28
Dec  2 13:53:22  kernel:  [<c0720000>] ? ab8500_regulator_probe+0x147/0x1af
Dec  2 13:53:22  kernel: ---[ end trace 34bfcccc859adad2 ]---
Dec  2 13:53:22  kernel: NILFS: GC failed during preparation: cannot read source blocks: err=-17
Dec  2 13:53:22  nilfs_cleanerd[1717]: cannot clean segments: File exists
Dec  2 13:53:22  nilfs_cleanerd[1717]: shutdown
Dec  2 14:06:10  nilfs_cleanerd[15310]: start
Dec  2 14:06:12  kernel: ------------[ cut here ]------------
Dec  2 14:06:12  kernel: WARNING: at fs/nilfs2/ioctl.c:449 nilfs_ioctl_move_blocks+0x11d/0x199 [nilfs2]()
Dec  2 14:06:12  kernel: Pid: 15310, comm: nilfs_cleanerd Tainted: G        W   3.0.4 #4
Dec  2 14:06:12  kernel: Call Trace:
Dec  2 14:06:12  kernel:  [<c043e1d0>] ? warn_slowpath_common+0x65/0x7a
Dec  2 14:06:12  kernel:  [<c043e1f9>] ? warn_slowpath_null+0x14/0x18
Dec  2 14:06:12  kernel:  [<f84c000d>] ? nilfs_ioctl_move_blocks+0x11d/0x199 [nilfs2]
Dec  2 14:06:12  kernel:  [<f84c02cd>] ? nilfs_ioctl_clean_segments+0x236/0x2b6 [nilfs2]
Dec  2 14:06:12  kernel:  [<f84bfd23>] ? nilfs_ioctl_get_bdescs+0x68/0x7b [nilfs2]
Dec  2 14:06:12  kernel:  [<f84c06f2>] ? nilfs_ioctl+0x192/0x1bb [nilfs2]
Dec  2 14:06:12  kernel:  [<f84c0560>] ? nilfs_ioctl_set_alloc_range+0x12b/0x12b [nilfs2]
Dec  2 14:06:12  kernel:  [<c04fffdc>] ? vfs_ioctl+0x1e/0x38
Dec  2 14:06:12  kernel:  [<c050061c>] ? do_vfs_ioctl+0x164/0x16b
Dec  2 14:06:12  kernel:  [<c0500668>] ? sys_ioctl+0x45/0x5c
Dec  2 14:06:12  kernel:  [<c07311df>] ? sysenter_do_call+0x12/0x28
Dec  2 14:06:12  kernel: ---[ end trace 34bfcccc859adad3 ]---
Dec  2 14:06:12  kernel: NILFS: GC failed during preparation: cannot read source blocks: err=-17
Dec  2 14:06:12  nilfs_cleanerd[15310]: cannot clean segments: File exists
Dec  2 14:06:12  nilfs_cleanerd[15310]: shutdown
Dec  2 14:08:11  nilfs_cleanerd[15574]: start
Dec  2 14:08:13  kernel: ------------[ cut here ]------------
Dec  2 14:08:13  kernel: WARNING: at fs/nilfs2/ioctl.c:449 nilfs_ioctl_move_blocks+0x11d/0x199 [nilfs2]()

Note, that moving the date forward from to the most forward checkpoint in the future cleans all checkpoints in both 2.0 & 2.1 daemons.

Zahid

-----Original Message-----
From: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Zahid Chowdhury
Sent: Monday, December 05, 2011 2:16 PM
To: Ryusuke Konishi
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; dexen deVries
Subject: RE: nilfs_cleanerd from nilfs-utils shutdown on version 2.0 and 2.1 does not fail but says nothing and does not clean the old checkpoints nor newer (actually older) ones.

Hello Ryusuke,
  I have successfully run the nilfs utils 2.1 with a Centos 5.5 kernel with a nilfs module builtin and cleaned up all checkpoints with no issues whatsoever. Thus, no kernel bug is caused even in the old 2.6.18 kernel from the time rewind. I suggest everybody upgrade to nilfs utils 2.1 wherever possible. Thanks everybody for your help.

Zahid

-----Original Message-----
From: Ryusuke Konishi [mailto:konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org] 
Sent: Sunday, December 04, 2011 6:57 AM
To: Zahid Chowdhury
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; dexen deVries
Subject: Re: nilfs_cleanerd from nilfs-utils shutdown on version 2.0 and 2.1 does not fail but says nothing and does not clean the old checkpoints nor newer (actually older) ones.

Hi,
On Fri, 2 Dec 2011 16:33:09 -0800, Zahid Chowdhury wrote:
> Hello,
>   If I move the system date forward, have some checkpoints created and then move the date backward a 2.0 cleanerd daemon fails on this error:
>     Nov 30 14:39:37 nilfs_cleanerd[5789]: start
>     Nov 30 14:39:38 kernel: nilfs_ioctl_move_inode_block: conflicting data             
>         buffer: ino=4, cno=0, offset=0, blocknr=665655, vblocknr=566462
>     Nov 30 14:39:38 kernel: NILFS: GC failed during preparation: cannot read 
>         source blocks: err=-17
>     Nov 30 14:39:38 nilfs_cleanerd[5789]: cannot clean segments: File exists
>     Nov 30 14:39:38 nilfs_cleanerd[5789]: shutdown
> 
> I cannot ever start up the daemon. If I move to a 2.1 daemon, then it logs no errors, but it cleans no old or newer (really older) checkpoints - it just sits in a do-nothing mode (strace(1) shows he is hung on a mq_timedreceive syscall).

Hmm, this error seems to be caused by a known bug which was already
fixed on nilfs-utils 2.1 with the following patch.

It might be an actual corruption by the kernel code of nilfs2 if you
were using old kernels, but it's most likely due to the bug.

I will backport the fix to nilfs-utils 2.0 series and make another
release of it.

Regards,
Ryusuke Konishi

---
From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

nilfs_cleanerd: fix move block errors with cpfile and sufile

This fixes the following gc error related to cpfile and sufile:

 nilfs_ioctl_move_inode_block: conflicting data buffer: ino=4, cno=0,
 offset=0, blocknr=78648, vblocknr=62283

Blocks of cpfile and sufile should be judged live only if they are
latest, and should not depends on the protection period.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 sbin/cleanerd/cleanerd.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
index 45a0be0..138a444 100644
--- a/sbin/cleanerd/cleanerd.c
+++ b/sbin/cleanerd/cleanerd.c
@@ -748,6 +748,16 @@ static int nilfs_vdesc_is_live(const struct nilfs_vdesc *vdesc,
 	long low, high, index;
 	int s;
 
+	if (vdesc->vd_cno == 0) {
+		/*
+		 * live/dead judge for sufile and cpfile should not
+		 * depend on protection period and snapshots.  Without
+		 * this check, gc will cause buffer conflict error
+		 * because their checkpoint number is always zero.
+		 */
+		return vdesc->vd_period.p_end == NILFS_CNO_MAX;
+	}
+
 	if (vdesc->vd_period.p_end == NILFS_CNO_MAX ||
 	    vdesc->vd_period.p_end > protect)
 		return 1;
-- 
1.7.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
