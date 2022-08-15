From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH 0/7] Convert to filemap_get_folios_contig()
Date: Mon, 15 Aug 2022 11:54:45 -0700
Message-ID: <20220815185452.37447-1-vishal.moola@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=TcoNVDdeHBjRL/cgwoXp3ksLrjGTv3LMhMhYdWqOUwk=;
        b=ip3lNnuRVCkKTJpyHRzp+iY1wE94DuhoDhEvhy2tFyM0MQL201v5SEkPA+UV8sh9TQ
         I/tYbxzs13zwkDghMIwYShD0PlhCUsKMKVL5HQh/tKqD1rzj6EXWyH4zVwPgOk6w3wVX
         d1npJ3/rrsl3qskZgl40Wpt/2Nkm7uDW95Zk6B+dz0gFLJFm2YDbhm8yXhWV0A0Vvgdd
         AcJDbbzRGabl/HUPXwY2vCQZXK/yEKeSFf8Ybwqvh8uOq9MzANixeh/dAAq4xoM4mtd9
         rpKgcJBOcGdyevdujOPAEJ+NpMWqCUndMIfJHFsDlXjT5sympvogVbr+jDBb4R8o+u5g
         OPsQ==
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-fsdevel@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, "Vishal Moola (Oracle)" <vishal.moola@gmail.com>

This patch series replaces find_get_pages_contig() with
filemap_get_folios_contig(). I've run xfstests on btrfs. I've also
tested the ramfs changes. I ran some xfstests on nilfs2, and its
seemingly fine although more testing may be beneficial.

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
 fs/nilfs2/page.c                 | 38 ++++++++---------
 fs/ramfs/file-nommu.c            | 50 ++++++++++++----------
 include/linux/pagemap.h          |  4 +-
 mm/filemap.c                     | 71 +++++++++++++++++++-------------
 8 files changed, 134 insertions(+), 121 deletions(-)

-- 
2.36.1

