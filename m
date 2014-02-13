From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/10] nilfs-utils: correct coding style issues
Date: Fri, 14 Feb 2014 03:24:00 +0900
Message-ID: <1392315850-29149-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This series gets rid of a bunch of coding style issues detected by
script/checkpatch.pl.  These errors and warnings are mainly detected
by "checkpatch.pl --file" command.  This patchset improves the result
of an exhaustive test with the tool though it still reports warnings
including few false positives.

Ryusuke Konishi
--
Ryusuke Konishi (10):
      nilfs-utils: fix order of storage class specifiers
      nilfs-utils: insert backslash between lines splitting quoted string
      nilfs-utils: do not indent labels
      nilfs-utils: remove unnecessary whitespace before quoted newlines
      nilfs-utils: do not initialize static or global variables to 0 or NULL
      nilfs-utils: remove unnecessary parentheses from return statements
      nilfs-utils: remove spaces between function name and open parenthesis
      mount/sundires.c: fix indent
      nilfs-utils: add missing space chars
      nilfs-utils: remove unnecessary externs

 bin/chcp.c                       |    2 +-
 bin/dumpseg.c                    |    2 +-
 bin/lscp.c                       |    6 +-
 bin/lssu.c                       |    6 +-
 bin/mkcp.c                       |    2 +-
 bin/rmcp.c                       |    6 +-
 include/nls.h                    |    4 +-
 lib/cleaner_ctl.c                |   12 +-
 lib/cleaner_exec.c               |    2 +-
 lib/nilfs.c                      |    2 +-
 sbin/cleanerd/cleanerd.c         |   11 +-
 sbin/mkfs/bitops.c               |    2 +-
 sbin/mkfs/mkfs.c                 |   54 ++++---
 sbin/mount/fstab.c               |  147 +++++++++---------
 sbin/mount/fstab.h               |   28 ++--
 sbin/mount/mount.nilfs2.c        |   43 +++---
 sbin/mount/mount_libmount.c      |   14 +-
 sbin/mount/mount_mntent.c        |   39 ++---
 sbin/mount/mount_mntent.h        |    8 +-
 sbin/mount/mount_opts.c          |   14 +-
 sbin/mount/sundries.c            |  314 +++++++++++++++++++-------------------
 sbin/mount/sundries.h            |   30 ++--
 sbin/mount/umount.nilfs2.c       |   27 ++--
 sbin/mount/umount_libmount.c     |    8 +-
 sbin/mount/xmalloc.c             |   12 +-
 sbin/nilfs-clean/nilfs-clean.c   |   12 +-
 sbin/nilfs-resize/nilfs-resize.c |   72 ++++-----
 sbin/nilfs-tune/nilfs-tune.c     |   24 +--
 28 files changed, 449 insertions(+), 454 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
