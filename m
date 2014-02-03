From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/4] nilfs2 updates
Date: Tue,  4 Feb 2014 01:50:40 +0900
Message-ID: <1391446244-1435-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Hi Andrew,

Please queue this patchset for the next merge window.

Andreas's three patches will add a new ioctl which helps to mitigate
overheads of garbage collection of nilfs.  The original cover letter
can be seen at:

 [1] http://marc.info/?l=linux-nilfs&m=139081676816008

there the userland counterpart is not yet finished, but this kernel
patchset is ready for merge, I think.

My additional patch updates entries of nilfs2 file system in
MAINTAINERS file (independently).

Thanks in advance,
Ryusuke Konishi
--
Andreas Rohner (3):
      nilfs2: add struct nilfs_suinfo_update and flags
      nilfs2: add nilfs_sufile_set_suinfo to update segment usage
      nilfs2: implementation of NILFS_IOCTL_SET_SUINFO ioctl

Ryusuke Konishi (1):
      nilfs2: update MAINTAINERS file entries

 MAINTAINERS               |    4 +-
 fs/nilfs2/ioctl.c         |   92 +++++++++++++++++++++++++++++++
 fs/nilfs2/sufile.c        |  131 +++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/sufile.h        |    1 +
 include/linux/nilfs2_fs.h |   44 +++++++++++++++
 5 files changed, 270 insertions(+), 2 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
