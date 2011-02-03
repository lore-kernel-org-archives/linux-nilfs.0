From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCHv2 0/5] nilfs2: FS_IOC_GETFLAGS/SETFLAGS/GETVERSION support
Date: Fri,  4 Feb 2011 00:20:09 +0900
Message-ID: <1296746414-11444-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

Changes from v1:

 * add compat_ioctl to avoid a compatibility issue where application is
   32 bit but kernel is 64 bit.
 * rebased to v2.6.38-rc3

Ryusuke Konishi
--
Ryusuke Konishi (5):
      nilfs2: use common file attribute macros
      nilfs2: mark S_NOATIME on inodes only if NOATIME attribute is set
      nilfs2: tighten restrictions on inode flags
      nilfs2: implement FS_IOC_GETFLAGS/SETFLAGS/GETVERSION
      nilfs2: add compat ioctl

 fs/nilfs2/dir.c           |    5 +--
 fs/nilfs2/file.c          |    2 +-
 fs/nilfs2/inode.c         |   19 +++------
 fs/nilfs2/ioctl.c         |   91 +++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/nilfs.h         |   18 +++++++++
 include/linux/nilfs2_fs.h |   20 ----------
 6 files changed, 118 insertions(+), 37 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
