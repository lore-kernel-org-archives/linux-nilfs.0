From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/2] nilfs-utils: move generic definitions into util.h
Date: Wed, 12 Feb 2014 01:23:07 +0900
Message-ID: <1392135789-5287-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This series gathers up some generic macros and moves them into
include/util.h to make them reusable, and then, simplifies a part of
min/max calculations with the moved macros, min_t() and max_t().

Ryusuke Konishi
--
Ryusuke Konishi (2):
      nilfs-utils: move utility definitions into util.h
      nilfs-utils: use min_t() and max_t()

 bin/lscp.c                       |    8 +++----
 bin/lssu.c                       |    3 ++-
 include/Makefile.am              |    2 +-
 include/util.h                   |   49 ++++++++++++++++++++++++++++++++++++++
 lib/cnoconv.c                    |    5 ++--
 lib/gc.c                         |    8 +++----
 lib/nilfs.c                      |    8 ++++---
 sbin/cleanerd/cleanerd.c         |   27 ++++-----------------
 sbin/mkfs/mkfs.c                 |   27 +++++++--------------
 sbin/nilfs-resize/nilfs-resize.c |   21 ++--------------
 10 files changed, 83 insertions(+), 75 deletions(-)
 create mode 100644 include/util.h


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
