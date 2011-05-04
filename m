From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/4] nilfs2 resize support
Date: Thu,  5 May 2011 03:18:51 +0900
Message-ID: <1304533135-25398-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This series adds (on-line) resize feature to the nilfs2 filesystem.
Both expansion and shrinking of the filesystem become possible with
this series.

Shrinking of the filesystem is realized with help from a user-land
resize tool "nilfs-resize".  It first sets a limit on the range of
segments that the nilfs kernel code allocates, then moves in-use
segments into the range by utilizing garbage collection API.

A new ioctl command is added to limit the allocation range of
segments.  And, the existent resize ioctl is finally implemented.

The nilfs-resize program is inteded to be a part of nilfs-utils (may
be incorporated into the next util release).  At present, it's only
available from "resize" branch of the following git tree:

  http://git.nilfs.org/nilfs2-utils-devel.git

   -- see http://www.nilfs.org/git/ to know how to get it.


The usage of this program is as follows:

  $ nilfs-resize [option] device [size]

If the size is larger than the current filesystem size, nilfs-resize
extends the filesystem to the given size.  If the size is smaller than
the current filesystem size, nilfs-resize tries to shrink the
filesystem to the given size.  The shrinking will fail if the
filesystem does not have enough free space.

Like other filesystems, the partition size must be extended before
extending the filesystem size.  This can be done by partition tools
such as fdisk or lvmextend.  Conversely, shrinking of the filesystem
should be performed before truncating the partition.

Off-line resizing is not yet available, and I'm feeling it needs some
more consideration.

The nilfs-resize tool is currently experimental, but the kernel
patches work fine so far.  So, I'm planning to queue them for the next
merge window unless a critical problem arises.


Thanks,
Ryusuke Konishi
--
Ryusuke Konishi (4):
      nilfs2: add ioctl which limits range of segment to be allocated
      nilfs2: add routine to move secondary super block
      nilfs2: add truncation routine of segment usage file
      nilfs2: implement resize ioctl

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
