From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 00/11] nilfs2 updates
Date: Fri, 29 Apr 2016 22:15:36 +0900
Message-ID: <1461935747-10380-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=h6SWH4QtJoz2kVcA/k5kZzv/OFCMCvZgnTiWLri2fwY=;
        b=dKrxFdQDk6Aj69F1j/MOjtlIfP2Hw2UiQMdk8kss1e+m6xeNxnfcoizvNB60qMKOaJ
         mH0s7ttRFnZGMkC138IhE8Jo3Rvhre+NxMXO3l4V0sXeuemT/+B9rEDY6iM4OU7XqC+x
         gh8dS8h5IgmYcFN/NrR3YwdpyCGhrOlVdoDSChiynzNfzWijioyHFyLoynFq1iR6JN6k
         wji/duZC/5/WOv9lPmwpXbKc+pFUQ8FxDjYXt2LRc+7I7f8zuiErkUtX+wr2ffGiyCOl
         x3E5KjiMiD/AAOniCmtHfT4gouhI/b3KeP3tLVMPxHZSfGQQS3EGi2Mt6KAopp/3Rf7v
         lE7w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

Hi Andrew,

Please queue the following changes for the next merge window:

Ryusuke Konishi (11):
      nilfs2: fix white space issue in nilfs_mount()
      nilfs2: remove space before comma
      nilfs2: remove FSF mailing address from GPL notices
      nilfs2: clean up old e-mail addresses
      MAINTAINERS: add web link for nilfs project
      nilfs2: clarify permission to replicate the design
      nilfs2: get rid of nilfs_mdt_mark_block_dirty()
      nilfs2: move cleanup code of metadata file from inode routines
      nilfs2: replace __attribute__((packed)) with __packed
      nilfs2: add missing line spacing
      nilfs2: clean trailing semicolons in macros

* Brief summary

These are mostly for cleanup.

> nilfs2: fix white space issue in nilfs_mount()
> nilfs2: remove space before comma
> nilfs2: remove FSF mailing address from GPL notices

These fix style issues that checkpatch.pl reported as error.

> nilfs2: clean up old e-mail addresses
> MAINTAINERS: add web link for nilfs project

These remove obsolete e-mail addresses and update project
information in MAINTAINERS file.

> nilfs2: clarify permission to replicate the design

This clarifies, in response to a developer's request, that
reimplementing nilfs2 is permitted.

> nilfs2: get rid of nilfs_mdt_mark_block_dirty()
> nilfs2: move cleanup code of metadata file from inode routines

These are for refactoring.

> nilfs2: replace __attribute__((packed)) with __packed
> nilfs2: add missing line spacing
> nilfs2: clean trailing semicolons in macros

These fix style issues that checkpatch.pl reported as warning.

Thanks,
Ryusuke Konishi
--

 Documentation/filesystems/nilfs2.txt |  5 +++
 MAINTAINERS                          |  1 +
 fs/nilfs2/alloc.c                    |  9 ++----
 fs/nilfs2/alloc.h                    |  9 ++----
 fs/nilfs2/bmap.c                     |  6 +---
 fs/nilfs2/bmap.h                     |  6 +---
 fs/nilfs2/btnode.c                   |  9 ++----
 fs/nilfs2/btnode.h                   |  8 ++---
 fs/nilfs2/btree.c                    |  6 +---
 fs/nilfs2/btree.h                    |  6 +---
 fs/nilfs2/cpfile.c                   |  8 ++---
 fs/nilfs2/cpfile.h                   |  6 +---
 fs/nilfs2/dat.c                      |  6 +---
 fs/nilfs2/dat.h                      |  6 +---
 fs/nilfs2/dir.c                      |  8 ++---
 fs/nilfs2/direct.c                   |  6 +---
 fs/nilfs2/direct.h                   |  6 +---
 fs/nilfs2/export.h                   |  2 +-
 fs/nilfs2/file.c                     |  7 +----
 fs/nilfs2/gcinode.c                  |  9 ++----
 fs/nilfs2/ifile.c                    |  8 ++---
 fs/nilfs2/ifile.h                    |  9 ++----
 fs/nilfs2/inode.c                    | 12 +++-----
 fs/nilfs2/ioctl.c                    | 17 ++++++-----
 fs/nilfs2/mdt.c                      | 59 ++++++++++++++++--------------------
 fs/nilfs2/mdt.h                      | 15 +++++----
 fs/nilfs2/namei.c                    |  8 ++---
 fs/nilfs2/nilfs.h                    |  7 +----
 fs/nilfs2/page.c                     |  7 +----
 fs/nilfs2/page.h                     |  7 +----
 fs/nilfs2/recovery.c                 |  7 ++---
 fs/nilfs2/segbuf.c                   |  6 +---
 fs/nilfs2/segbuf.h                   |  6 +---
 fs/nilfs2/segment.c                  |  7 ++---
 fs/nilfs2/segment.h                  |  6 +---
 fs/nilfs2/sufile.c                   | 14 ++++-----
 fs/nilfs2/sufile.h                   | 10 ++----
 fs/nilfs2/super.c                    | 17 ++++-------
 fs/nilfs2/sysfs.h                    |  6 ++--
 fs/nilfs2/the_nilfs.c                |  6 +---
 fs/nilfs2/the_nilfs.h                |  8 ++---
 include/linux/nilfs2_fs.h            |  7 +----
 42 files changed, 121 insertions(+), 257 deletions(-)

