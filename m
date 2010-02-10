From: Sebastian Reichelt <SebastianR-Mmb7MZpHnFY@public.gmane.org>
Subject: Kernel BUG in btree.c:514 when mounting
Date: Wed, 10 Feb 2010 14:06:18 +0000 (UTC)
Message-ID: <loom.20100210T143343-933@post.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello!

After using nilfs2 for about 3 months (the version in Linux 2.6.31, not sure
about the exact nilfs2 version number), I can no longer mount my root partition,
as I immediately get a kernel BUG in btree.c:514. The process causing it is
nilfs_cleanerd, though I suspect that might just be the first process to be
executed. (Unfortunately, it is executed even if I use the "ro" option on the
Linux command line -- why?!) It happens during a sys_open call. If the entire
stack trace helps, I could post that, too.

In any case, it would be nice if, upon encountering a file system corruption of
some sort, the nilfs implementation didn't BUG, but had an "errors=remount-ro"
option like other file systems. Of course, that leaves open the question of how
the file system got corrupted in the first place. The computer shut down cleanly
yesterday.

Would it be possible to send the partition image to someone? The partition size
is about 10 GB.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
