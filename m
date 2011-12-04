From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: nilfs_cleanerd from nilfs-utils shutdown on version 2.0 and
 2.1 does not fail but says nothing and does not clean the old checkpoints
 nor newer (actually older) ones.
Date: Sun, 04 Dec 2011 23:56:40 +0900 (JST)
Message-ID: <20111204.235640.258486441.ryusuke@osrg.net>
References: <053D39D3D76C474EB2D2A284AA6BA3181F26A4F05D@COLOSSEXCH01.starsolutions.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <053D39D3D76C474EB2D2A284AA6BA3181F26A4F05D-ZjuI7xOJlFPnaE3xbIMyWkCiaQ3SRT3KFkJ40O1dFu8@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: zahid.chowdhury-VJizFkI/10gAspv4Qr0y0gC/G2K4zDHf@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

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
