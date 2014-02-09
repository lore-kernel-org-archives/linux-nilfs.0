From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [patch 0/2] add live block count option to lssu command
Date: Mon, 10 Feb 2014 03:48:32 +0900
Message-ID: <1391971714-1724-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This series adds -l option and -p option to lssu command.

"-l" option prints count of in-use blocks of the moment (i.e. live
blocks), and "-p" option allows users to specify a protection period
which is applied for testing if each block in segments is protected
and not reclaimable.

These options would help to choose min_reclaimable_blocks parameter
or to consider how to improve garbage collection algorithm.

Regards,
Ryusuke Konishi
--
Ryusuke Konishi (2):
      nilfs-utils: renew parser library
      lssu: add option to print count of live blocks

 bin/Makefile.am                |    6 +-
 bin/chcp.c                     |    2 +-
 bin/lssu.c                     |  251 +++++++++++++++++++++++++++++++++++-----
 bin/rmcp.c                     |    2 +-
 include/Makefile.am            |    2 +-
 include/cno.h                  |   17 ---
 include/parser.h               |   19 +++
 lib/Makefile.am                |   10 +-
 lib/cno.c                      |  101 ----------------
 lib/parser.c                   |  154 ++++++++++++++++++++++++
 man/lssu.1                     |   14 ++-
 sbin/nilfs-clean/Makefile.am   |    3 +-
 sbin/nilfs-clean/nilfs-clean.c |   69 +++--------
 13 files changed, 435 insertions(+), 215 deletions(-)
 delete mode 100644 include/cno.h
 create mode 100644 include/parser.h
 delete mode 100644 lib/cno.c
 create mode 100644 lib/parser.c

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
