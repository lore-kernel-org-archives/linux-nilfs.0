From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/7] nilfs2 additional fixes
Date: Tue, 10 May 2016 22:24:24 +0900
Message-ID: <1462886671-3521-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=ZPxZO6BOw11fJrEYWua1KNr7yw7mwJzq9Nh5vyMmXds=;
        b=qBWRPDBU2EOfzo5l8aY4/rzAlH5WspR4/j8cxz11FuNz67iVsLxekwegQPXzKicjrK
         gaMo7s09XrFS5kczNiaEors/Uh2YyRC+BU+wzB21ljr/dAH3JUaAnrH7y60t03nK1X31
         9akSKN0wotfGhhtTlxLSE3J91iKda9DYooILpIXTeACBXwyqnNb3AFbxuMyx32eeHN5x
         giTLqHWQbURTVahNy6o03k+nBXuPdbiqF+TXnB5zW1NXagU1M2Pne49Ychd0S3MKW5Qs
         uZlPr84uFH7daqqD2CSZII6fbFAGQWVlg0ochYiLz5K4HOsDsmEDonIzlmpBH6xMr6XV
         EMBA==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Hi Andrew,

Please append the following changes for the upcoming merge window:

Ryusuke Konishi (7):
      nilfs2: do not emit extra newline on nilfs_warning() and nilfs_error()
      nilfs2: remove space before semicolon
      nilfs2: fix code indent coding style issue
      nilfs2: avoid bare use of 'unsigned'
      nilfs2: remove unnecessary else after return or break
      nilfs2: remove loops of single statement macros
      nilfs2: fix block comments


The first patch "nilfs2: do not emit extra newline on nilfs_warning()
and nilfs_error()" fixes the issue that part of warning/error messages
of nilfs2 insert an empty line in the kernel ring buffer.

The rest cleans several coding style issues caught by checkpatch.pl.

Thanks,
Ryusuke Konishi
--

 fs/nilfs2/alloc.c         |  30 +++++++------
 fs/nilfs2/alloc.h         |   2 +-
 fs/nilfs2/bmap.c          |   4 +-
 fs/nilfs2/bmap.h          |  16 ++++---
 fs/nilfs2/btree.c         |  15 ++++---
 fs/nilfs2/cpfile.c        |  14 +++---
 fs/nilfs2/cpfile.h        |   4 +-
 fs/nilfs2/dat.c           |   2 +-
 fs/nilfs2/dat.h           |   2 +-
 fs/nilfs2/dir.c           |  51 +++++++++++-----------
 fs/nilfs2/direct.c        |  11 ++---
 fs/nilfs2/ifile.c         |   6 ++-
 fs/nilfs2/inode.c         |  93 +++++++++++++++++++++++----------------
 fs/nilfs2/mdt.c           |   4 +-
 fs/nilfs2/mdt.h           |   6 +--
 fs/nilfs2/namei.c         |   4 +-
 fs/nilfs2/nilfs.h         |  26 +++++++----
 fs/nilfs2/page.c          |   8 ++--
 fs/nilfs2/page.h          |   3 +-
 fs/nilfs2/recovery.c      |  18 +++++---
 fs/nilfs2/segbuf.c        |   4 +-
 fs/nilfs2/segbuf.h        |   5 ++-
 fs/nilfs2/segment.c       | 108 ++++++++++++++++++++++++++--------------------
 fs/nilfs2/segment.h       |  38 ++++++++++------
 fs/nilfs2/super.c         |   4 +-
 fs/nilfs2/sysfs.c         |   6 +--
 fs/nilfs2/the_nilfs.c     |  10 +++--
 fs/nilfs2/the_nilfs.h     |  19 ++++----
 include/linux/nilfs2_fs.h |  72 ++++++++++++++++++++-----------
 29 files changed, 342 insertions(+), 243 deletions(-)


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
