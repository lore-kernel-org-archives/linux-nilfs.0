From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/4] some nilfs2 fixes
Date: Mon, 16 Jul 2012 10:05:22 +0900
Message-ID: <1342400726-30670-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Andrew,

Please apply the following patches and send them upstream via the -mm
tree at the next merge window.

This patchset is composed of two comment fixes and two ioctl-related
fixes in which one is for a deadlock issue and another for a potential
timing issue.

Thanks,
Ryusuke Konishi
--

Fernando Luis Vazquez Cao (1):
      NILFS2: remove references to long gone super operations

Ryusuke Konishi (2):
      nilfs2: fix timing issue between rmcp and chcp ioctls
      nilfs2: fix deadlock issue between chcp and thaw ioctls

Vyacheslav Dubeyko (1):
      nilfs2: add omitted comment for ns_mount_state field of the_nilfs structure

 fs/nilfs2/cpfile.c    |   10 +++++++---
 fs/nilfs2/ioctl.c     |    4 ++--
 fs/nilfs2/super.c     |    6 +++---
 fs/nilfs2/the_nilfs.c |    1 +
 fs/nilfs2/the_nilfs.h |    3 +++
 5 files changed, 16 insertions(+), 8 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
