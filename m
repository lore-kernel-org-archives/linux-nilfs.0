From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/3] nilfs2 lockdep warning fixes
Date: Mon, 21 Mar 2022 21:57:04 +0900
Message-ID: <1647867427-30498-1-git-send-email-konishi.ryusuke@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=sCS6c171oyN7Cq0gnRAYsCzijiKw228qCeDaGu15gbQ=;
        b=kxKHOOABq7S1CRI0KHi/xF4YyJwZK6cmyIAmwClbqrsolrkKTytDk72Ruj1zQ60y+T
         Nu8rNFZiEQIf1Y85wSPGdZnAGOotwnU4irRb20LPXBjW3zPkW8vg5i7swBTxNpr5kQV5
         sofHwBwkj7lvrMa17ETqe0YBxjeqA2mGuyt2bAsCMEQGh2iqppvq9gr7hhy/Z4Y5izRf
         rSgUKLtRTkM46bqRfxVYyCt8xaSxRcm1WaUgyKJhgfdBCvkpzqhdkyi37ugmo5MLzrRR
         ckgR32huHN2VCsgpYMOPznMSjSo8U9JjG7G4k1pIN+nkF3U4MQfqcWKBXVWc9l70Fmf1
         MQpg==
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

Hi Andrew,

please consider applying the following changes to -mm tree.

Ryusuke Konishi (3):
  nilfs2: fix lockdep warnings in page operations for btree nodes
  nilfs2: fix lockdep warnings during disk space reclamation
  nilfs2: get rid of nilfs_mapping_init()

The first two are to resolve the lockdep warning issue, and the last
one is the accompanying cleanup and low priority.

The merge window is already open, but this is for the reported issues,
so I'll send it without waiting at this point when tests have passed.

Based on your comment, this series solves the issue by separating
inode object as needed.  Since I was worried about the impact of the
object composition changes, I tested the series carefully not to cause
regressions especially for delicate functions such like disk space
reclamation and snapshots.


Thanks,
Ryusuke Konishi
--
 fs/nilfs2/btnode.c  |  23 +++++++-
 fs/nilfs2/btnode.h  |   1 +
 fs/nilfs2/btree.c   |  27 ++++++---
 fs/nilfs2/dat.c     |   4 +-
 fs/nilfs2/gcinode.c |   7 ++-
 fs/nilfs2/inode.c   | 159 +++++++++++++++++++++++++++++++++++++++++++++++-----
 fs/nilfs2/mdt.c     |  43 +++++++++-----
 fs/nilfs2/mdt.h     |   6 +-
 fs/nilfs2/nilfs.h   |  16 +++---
 fs/nilfs2/page.c    |  16 +-----
 fs/nilfs2/page.h    |   1 -
 fs/nilfs2/segment.c |   9 ++-
 fs/nilfs2/super.c   |   5 +-
 13 files changed, 241 insertions(+), 76 deletions(-)

-- 
1.8.3.1

