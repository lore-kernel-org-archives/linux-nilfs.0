From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/4] nilfs2: FS_IOC_GETFLAGS/SETFLAGS/GETVERSION support
Date: Thu, 20 Jan 2011 02:41:27 +0900
Message-ID: <1295458891-22715-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This series implements FS_IOC_GETFLAGS, FS_IOC_SETFLAGS, and
FS_IOC_GETVERSION ioctls to make the standard attributes set and the
file generation number available for nilfs2 from lsattr and chattr
commands.

The first three patches fix up minor issues on the current attributes
set of nilfs2, and the fourth one adds these ioctls.

Ryusuke Konishi
--
Ryusuke Konishi (4):
      nilfs2: use common file attribute macros
      nilfs2: mark S_NOATIME on inodes only if NOATIME attribute is set
      nilfs2: tighten restrictions on inode flags
      nilfs2: implement FS_IOC_GETFLAGS/SETFLAGS/GETVERSION

 fs/nilfs2/dir.c           |    3 --
 fs/nilfs2/inode.c         |   19 ++++--------
 fs/nilfs2/ioctl.c         |   70 +++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/nilfs.h         |   17 +++++++++++
 include/linux/nilfs2_fs.h |   20 -------------
 5 files changed, 94 insertions(+), 35 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
