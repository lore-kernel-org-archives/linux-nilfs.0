From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 0/2] two more nilfs2 patches
Date: Thu, 19 Jul 2012 21:34:17 +0900
Message-ID: <1342701259-32314-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-nilfs <linux-nilfs@vger.kernel.org>, Vyacheslav Dubeyko <slava@dubeyko.com>

Hi Andrew,

Please apply the following two patches and send them upstream at the
upcoming merge window, along with the previous patchset.

These add missing comments on structures in nilfs2.

Thanks,
Ryusuke Konishi
--

Vyacheslav Dubeyko (2):
      NILFS2: add omitted comments for structures in nilfs2_fs.h
      NILFS2: add omitted comments for different structures in driver implementation

 fs/nilfs2/alloc.h         |   14 +++++++---
 fs/nilfs2/bmap.h          |    7 +++++
 fs/nilfs2/btnode.h        |    8 +++++-
 fs/nilfs2/dat.c           |    6 +++++
 fs/nilfs2/export.h        |    8 ++++++
 fs/nilfs2/ifile.c         |    6 ++++-
 fs/nilfs2/inode.c         |    7 +++++
 fs/nilfs2/mdt.h           |    7 +++++
 fs/nilfs2/nilfs.h         |   17 ++++++++++--
 fs/nilfs2/sufile.c        |    8 +++++-
 fs/nilfs2/the_nilfs.h     |    3 +--
 include/linux/nilfs2_fs.h |   63 ++++++++++++++++++++++++++++-----------------
 12 files changed, 120 insertions(+), 34 deletions(-)
