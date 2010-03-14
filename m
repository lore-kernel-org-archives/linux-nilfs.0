From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/6] nilfs2 trivial fixes
Date: Sun, 14 Mar 2010 11:28:33 +0900
Message-ID: <1268533719-19454-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

These are all trivial patches. typo fixes, coding style fixes, and a
fix of missing static specifiers.  I'll send these upstream.

Thanks,
Ryusuke Konishi
--
Ryusuke Konishi (6):
      nilfs2: fix discrepancy in use of static specifier
      nilfs2: fix function name typos in docbook comments
      nilfs2: fix typo "cout" -> "count" in error message
      nilfs2: fix various typos in comments
      nilfs2: remove spaces before tabs
      nilfs2: remove whitespaces before quoted newlines

 fs/nilfs2/alloc.h     |    2 +-
 fs/nilfs2/dat.c       |    2 +-
 fs/nilfs2/dir.c       |    2 +-
 fs/nilfs2/gcinode.c   |    4 ++--
 fs/nilfs2/page.c      |    4 ++--
 fs/nilfs2/segbuf.c    |   10 +++++-----
 fs/nilfs2/segment.c   |    8 ++++----
 fs/nilfs2/segment.h   |    4 ++--
 fs/nilfs2/sufile.c    |    2 +-
 fs/nilfs2/super.c     |    4 ++--
 fs/nilfs2/the_nilfs.c |    2 +-
 11 files changed, 22 insertions(+), 22 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
