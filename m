From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/4] nilfs-utils: fix typos
Date: Sun, 20 Apr 2014 00:14:11 +0900
Message-ID: <1397920455-373-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This series fixes typos in nilfs-utils detected by aspell command.

Thanks,
Ryusuke Konishi
--
Ryusuke Konishi (4):
      nilfs-utils: fix typos in ChangeLog file
      nilfs-utils: fix typos in manpages
      nilfs-utils: fix typos in messages
      nilfs-utils: fix typos in source files

 ChangeLog                        | 10 +++++-----
 bin/lssu.c                       |  2 +-
 include/nilfs.h                  |  4 ++--
 lib/gc.c                         |  4 ++--
 man/mount.nilfs2.8               |  4 ++--
 man/nilfs-resize.8               |  2 +-
 sbin/cleanerd/cleanerd.c         |  8 ++++----
 sbin/mkfs/bitops.c               |  2 +-
 sbin/mkfs/mkfs.c                 |  4 ++--
 sbin/mount/mount_opts.h          |  2 +-
 sbin/nilfs-clean/nilfs-clean.c   |  2 +-
 sbin/nilfs-resize/nilfs-resize.c |  2 +-
 12 files changed, 23 insertions(+), 23 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
