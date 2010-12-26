From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/2] nilfs2: support fiemap ioctl
Date: Sun, 26 Dec 2010 21:56:12 +0900
Message-ID: <1293368174-1197-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This series adds fiemap support to nilfs.

The fiemap gives an efficient method for userspace to get file extent
mappings.  It returns a list of extents instead of block-by-block
mapping, and is used to inspect fragmentation pattern of a file or to
speed up the boot process with readahead utilities (e.g. "ureadahead"
of Ubuntu).

Details on the fiemap are explained in
Documentation/filesystems/fiemap.txt of the kernel tree.

In this series, the first patch marks "delayed" flag on buffer heads
which are mapped to a file but not yet allocated to disk space.  This
allows fiemap handler to distinguish regions of such unlocated data.

The second patch implements the fiemap handler and enables the
feature.

These seem to work well so far, and I'm planning to send them to the
upcoming merge window.

Thanks,
Ryusuke Konishi
--
Ryusuke Konishi (2):
      nilfs2: mark buffer heads as delayed until the data is written to disk
      nilfs2: fiemap support

 fs/nilfs2/file.c    |    1 +
 fs/nilfs2/inode.c   |  132 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/namei.c   |    1 +
 fs/nilfs2/nilfs.h   |    2 +
 fs/nilfs2/page.c    |   84 ++++++++++++++++++++++++++++++++
 fs/nilfs2/page.h    |    3 +
 fs/nilfs2/segment.c |    2 +
 7 files changed, 225 insertions(+), 0 deletions(-)


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
