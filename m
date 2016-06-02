From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/8] nilfs2 updates
Date: Thu,  2 Jun 2016 22:58:03 +0900
Message-ID: <1464875891-5443-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=lQgQf7NC/jKRtiAlAJ6OxT4Stf0KJpq7w1wOp/quw4I=;
        b=CwDDkoEMnPR7aCrkO50VmGvJufgfUHYEFO2wKKSzhWVZv0tjoPDqyvP1MaxKNrqscR
         S0XJDJDscGrR2mjDXCcb6ukLI6aJB6tE19P/xTtZ8cmtZbCGW3UfNPa5ZP8Ou1PBPAkv
         syLbmX0P6c/rZ1AUI3PKdXd/8jbWMVpNvHkKR/grWmMJ3ilUEx4DuSZMz4EjjswrVydb
         yTrKE0XIAT+sW7vWFW/13NL5s367G2LAobQfYXqhx/9rOe0yGqzqIcbmqbBgALdINpFl
         DE74qTV7Obfb8XXhZdP09lcMEoUtp/gfZGZj1qzk5eVbb1/fI6W3ftGLRH4y08QVuSbw
         Xrfw==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Hi Andrew,

Please queue the following changes for the next merge window:

Ryusuke Konishi (8):
      nilfs2: hide function name argument from nilfs_error()
      nilfs2: add nilfs_msg() message interface
      nilfs2: embed a back pointer to super block instance in nilfs object
      nilfs2: reduce bare use of printk() with nilfs_msg()
      nilfs2: replace nilfs_warning() with nilfs_msg()
      nilfs2: emit error message when I/O error is detected
      nilfs2: do not use yield()
      nilfs2: refactor parser of snapshot mount option

* Brief Summary

This series revises message interface of nilfs, and cleans a few
more checkpatch warnings.

>      nilfs2: hide function name argument from nilfs_error()

This simplifies argument of nilfs_error() output routine.

>      nilfs2: add nilfs_msg() message interface
>      nilfs2: embed a back pointer to super block instance in nilfs object
>      nilfs2: reduce bare use of printk() with nilfs_msg()
>      nilfs2: replace nilfs_warning() with nilfs_msg()

These add a new message routine "nilfs_msg()", use it to reduce bare
use of printk(), and also unify nilfs_warning() output routine to it.

>      nilfs2: emit error message when I/O error is detected

This helps to distinguish whether a file system error comes from the
underlying device or not by having io routines of nilfs output error
messages when they detect an I/O error.

>      nilfs2: do not use yield()
>      nilfs2: refactor parser of snapshot mount option

These remove two remaining checkpatch warnings.


Thanks,
Ryusuke Konishi
--
 fs/nilfs2/alloc.c     |  45 +++++------
 fs/nilfs2/bmap.c      |   4 +-
 fs/nilfs2/btree.c     |  61 +++++++++------
 fs/nilfs2/cpfile.c    |  22 +++---
 fs/nilfs2/dat.c       |  19 +++--
 fs/nilfs2/dir.c       |  38 +++++-----
 fs/nilfs2/direct.c    |  10 ++-
 fs/nilfs2/gcinode.c   |   9 ++-
 fs/nilfs2/ifile.c     |   7 +-
 fs/nilfs2/inode.c     |  32 ++++----
 fs/nilfs2/ioctl.c     |  47 ++++++------
 fs/nilfs2/mdt.c       |   6 +-
 fs/nilfs2/namei.c     |   6 +-
 fs/nilfs2/nilfs.h     |  27 ++++++-
 fs/nilfs2/page.c      |  19 +++--
 fs/nilfs2/recovery.c  |  72 +++++++++---------
 fs/nilfs2/segbuf.c    |   6 +-
 fs/nilfs2/segment.c   |  47 ++++++------
 fs/nilfs2/sufile.c    |  31 ++++----
 fs/nilfs2/super.c     | 206 ++++++++++++++++++++++++++------------------------
 fs/nilfs2/sysfs.c     |  30 ++++----
 fs/nilfs2/the_nilfs.c | 134 +++++++++++++++++---------------
 fs/nilfs2/the_nilfs.h |   4 +-
 23 files changed, 469 insertions(+), 413 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
