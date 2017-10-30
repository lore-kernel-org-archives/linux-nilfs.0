From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 0/4] nilfs2 updates
Date: Mon, 30 Oct 2017 21:52:11 +0900
Message-ID: <1509367935-3086-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=P3aTy0zR+Z3JbibWYIcmfZH083V6hC4RFqODFCTdC28=;
        b=sb+CBtrryoh9wI/boF5sfFlmkybOHiof4KwV1V8y1mqpESXxSQY0EwOwW2ro/DpAXf
         72hn7wWHzg/maphxe1iEsqu50PjB+bHIeW0rgxHz79p68JhpTlCN8t0Os+6xjxgmu5FI
         81TxvBNw4S+fgttg5BmTYNX8XmUjuhQsOG6NWMvJStuolvMB4F/jCX7jaXXSfMiWNUV5
         aaQjh38wA5KOxG3EDyY3NtrgzkxMR1N4azXQZ20SE3ZOOnqoab0vqLbt/528BirEFhyA
         3prgC4JfqRIHB5DA9+w2dQdqQGBLqFjCS2WsPw72MZcMNOpy0H1rQiv9IGRbyTjLPsZD
         PGkA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-nilfs <linux-nilfs@vger.kernel.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

Hi Andrew,

Please queue the following changes for the next merge window:

Andreas Rohner (1):
      nilfs2: Fix race condition that causes file system corruption

Elena Reshetova (1):
      fs, nilfs: convert nilfs_root.count from atomic_t to refcount_t

Ryusuke Konishi (2):
      nilfs2: align block comments of nilfs_sufile_truncate_range() at *
      nilfs2: use octal for unreadable permission macro

In this series,

>      nilfs2: Fix race condition that causes file system corruption

fixes a file system corruption issue in some high loads.

>      fs, nilfs: convert nilfs_root.count from atomic_t to refcount_t

introduces refcount_t type to nilfs.

>      nilfs2: align block comments of nilfs_sufile_truncate_range() at *
>      nilfs2: use octal for unreadable permission macro

are style fixes, both of which are based on suggestions of recent
checkpatch.pl.

Thanks,
Ryusuke Konishi
--
 fs/nilfs2/namei.c     |  2 +-
 fs/nilfs2/segment.c   |  6 ++++--
 fs/nilfs2/sufile.c    | 32 ++++++++++++++++----------------
 fs/nilfs2/the_nilfs.c |  8 ++++----
 fs/nilfs2/the_nilfs.h |  5 +++--
 5 files changed, 28 insertions(+), 25 deletions(-)

