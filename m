From: "Vishal Moola (Oracle)" <vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 0/7] Convert to filemap_get_folios_contig()
Date: Tue, 23 Aug 2022 17:40:16 -0700
Message-ID: <20220824004023.77310-1-vishal.moola@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=SlBXFXTYk1JyGPv88MWJugtZv0AA300hEZIB82Z3nMg=;
        b=kDItX/cKhy/iYe03htpkysRohqwZ/5zX0XVJ+zwQsVsZAfS3KDz9Wf64U2JLd258x4
         7oaiHcFz4C1afU4v5L3syQDv30o1sxV7t3h7bu/zm+qpT2CHzbtjQvSfTqiWse1/lIiB
         eJqKDZu5WwSn4L5YIuuYtjB9XvRADjD2fQEVEdHDG2wM5qJjzxaJf6z2silC+pIuH0TG
         l5rxbIcMOLwYaO+fbk++0ZSSw0Qr82EF9XKtmjOaj4QWQjph60o2JFsZPE5hZ7XY2u20
         uqhOhcRE5SyGAb/9KLGxZ0K8NwihJ8a5c5dOl0yW5Vy5EvadUOPqLCFI4BGdLbmw/veW
         5XVA==
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Vishal Moola (Oracle)" <vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

This patch series replaces find_get_pages_contig() with
filemap_get_folios_contig(). I've run xfstests on btrfs. I've also
tested the ramfs changes. I ran some xfstests on nilfs2, and its
seemingly fine although more testing may be beneficial.
---

v2:
  - Removed an unused label in nilfs2
  - Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

v3:
  - Fixed minor style issues in btrfs patches
  - Fixed an issue in nilfs2 regarding the block index
  - "nr" renamed to "nr_folios" in nilfs2 and ramfs for clarity
  - Got some Acked-by's

Vishal Moola (Oracle) (7):
  filemap: Add filemap_get_folios_contig()
  btrfs: Convert __process_pages_contig() to use
    filemap_get_folios_contig()
  btrfs: Convert end_compressed_writeback() to use filemap_get_folios()
  btrfs: Convert process_page_range() to use filemap_get_folios_contig()
  nilfs2: Convert nilfs_find_uncommited_extent() to use
    filemap_get_folios_contig()
  ramfs: Convert ramfs_nommu_get_unmapped_area() to use
    filemap_get_folios_contig()
  filemap: Remove find_get_pages_contig()

 fs/btrfs/compression.c           | 31 +++++++-------
 fs/btrfs/extent_io.c             | 33 +++++++--------
 fs/btrfs/subpage.c               |  2 +-
 fs/btrfs/tests/extent-io-tests.c | 32 +++++++-------
 fs/nilfs2/page.c                 | 45 ++++++++------------
 fs/ramfs/file-nommu.c            | 50 ++++++++++++----------
 include/linux/pagemap.h          |  4 +-
 mm/filemap.c                     | 71 +++++++++++++++++++-------------
 8 files changed, 139 insertions(+), 129 deletions(-)

-- 
2.36.1

