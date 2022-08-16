From: "Vishal Moola (Oracle)" <vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 0/7] Convert to filemap_get_folios_contig()
Date: Tue, 16 Aug 2022 10:52:39 -0700
Message-ID: <20220816175246.42401-1-vishal.moola@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=vqWu9nIMNs2OYllxNa/lgOV5pa8uiLhr0uktPZgpEhc=;
        b=JJCfNmBZtK7Rg0LXuekIXzocFyEbiUou4havkGQOMvUoSdfxVx8XppTLKJTOFqUZx5
         hta/gDv8tA7m2h/EMpdDQjY/WBac8uFD2WO8SklWF4kOI0kf2SQCzx7txtv3r2gE83u9
         r324iX+CFT0tepJ2GssUIre+HbXMmMh5tO6NODLP4obrp9z7fdBzbpA6465pvcUBO5DC
         ByknkvBBsLQh4zIdTwXT0OEHCt9ZiQ2srmS8ChuKTITaTBE/jBiXatN+/xfGvnEVOl+q
         uC40CwHcJ2i7TBvHjRD+vMrN1gNxcFfEJX0Mh8wFWqgJJn6xvbeN0VnyzqxL4qx0tnVV
         pI9w==
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

 fs/btrfs/compression.c           | 26 ++++++------
 fs/btrfs/extent_io.c             | 33 +++++++--------
 fs/btrfs/subpage.c               |  2 +-
 fs/btrfs/tests/extent-io-tests.c | 31 +++++++-------
 fs/nilfs2/page.c                 | 39 ++++++++----------
 fs/ramfs/file-nommu.c            | 50 ++++++++++++----------
 include/linux/pagemap.h          |  4 +-
 mm/filemap.c                     | 71 +++++++++++++++++++-------------
 8 files changed, 134 insertions(+), 122 deletions(-)

-- 
2.36.1

