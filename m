From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v5 00/23] Convert to filemap_get_folios_tag()
Date: Wed,  4 Jan 2023 13:14:25 -0800
Message-ID: <20230104211448.4804-1-vishal.moola@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XF0rWcwOaeOy9W3XDndGOlTI6VOcqMAlw6Z0kSP+ZIE=;
        b=mwUaRHyXO3QpRK5P0JqCEjtDjkmGl7YgUMaT1I2YjsKhseOwqNkNS33mOlEf/eRTXu
         Dx4cepCH0DpI7UZias9hAXzrqhmP9FqJPQ5SpCcrNsEip5tDid5QCJ8rq3xSJ7zfXgzS
         VkkY41Iwf5a5gzpho+eHq9V7JD1kKJVPOfzCuRJq6ljFPE+NlmpfzNYoSMe4wocuCgzf
         S6i7hTWrnSsU5BeCV3tLAdKHoc+E6ZXdQXMGE1pFenz1nLeHJTOMKZAollRFOqAqS7OZ
         auFae1eJ8Ii2yGyYjhvy6b6WvXd1YJI0BgZbYV7R5btP09Ol+PqZuvdKcR/Dbg+8nqw5
         sxBQ==
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-fsdevel@vger.kernel.org
Cc: linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-nilfs@vger.kernel.org, linux-mm@kvack.org, "Vishal Moola (Oracle)" <vishal.moola@gmail.com>

This patch series replaces find_get_pages_range_tag() with
filemap_get_folios_tag(). This also allows the removal of multiple
calls to compound_head() throughout.
It also makes a good chunk of the straightforward conversions to folios,
and takes the opportunity to introduce a function that grabs a folio
from the pagecache.

I've run xfstests on xfs, btrfs, ext4, f2fs, and nilfs2, but more testing may
be beneficial. The page-writeback and filemap changes implicitly work. Still
looking for review of cifs, gfs2, and ext4.

---
v5:
  Rebased onto upstream 6.2-rc2
  Filesystems modified to use folio_get() instead of folio_ref_inc()
  F2fs modified to maintain use of F2FS_ONSTACK_PAGES

v4:
  Fixed a bug with reference counting in cifs changes
  - Reported-by: kernel test robot <oliver.sang@intel.com> 
  Improved commit messages to be more meaningful
  Got some Acked-bys and Reviewed-bys

v3:
  Rebased onto upstream 6.1
  Simplified the ceph patch to only necessary changes
  Changed commit messages throughout to be clearer
  Got an Acked-by for another nilfs patch
  Got Tested-by for afs

v2:
  Got Acked-By tags for nilfs and btrfs changes
  Fixed an error arising in f2fs
  - Reported-by: kernel test robot <lkp@intel.com>

Vishal Moola (Oracle) (23):
  pagemap: Add filemap_grab_folio()
  filemap: Added filemap_get_folios_tag()
  filemap: Convert __filemap_fdatawait_range() to use
    filemap_get_folios_tag()
  page-writeback: Convert write_cache_pages() to use
    filemap_get_folios_tag()
  afs: Convert afs_writepages_region() to use filemap_get_folios_tag()
  btrfs: Convert btree_write_cache_pages() to use
    filemap_get_folio_tag()
  btrfs: Convert extent_write_cache_pages() to use
    filemap_get_folios_tag()
  ceph: Convert ceph_writepages_start() to use filemap_get_folios_tag()
  cifs: Convert wdata_alloc_and_fillpages() to use
    filemap_get_folios_tag()
  ext4: Convert mpage_prepare_extent_to_map() to use
    filemap_get_folios_tag()
  f2fs: Convert f2fs_fsync_node_pages() to use filemap_get_folios_tag()
  f2fs: Convert f2fs_flush_inline_data() to use filemap_get_folios_tag()
  f2fs: Convert f2fs_sync_node_pages() to use filemap_get_folios_tag()
  f2fs: Convert f2fs_write_cache_pages() to use filemap_get_folios_tag()
  f2fs: Convert last_fsync_dnode() to use filemap_get_folios_tag()
  f2fs: Convert f2fs_sync_meta_pages() to use filemap_get_folios_tag()
  gfs2: Convert gfs2_write_cache_jdata() to use filemap_get_folios_tag()
  nilfs2: Convert nilfs_lookup_dirty_data_buffers() to use
    filemap_get_folios_tag()
  nilfs2: Convert nilfs_lookup_dirty_node_buffers() to use
    filemap_get_folios_tag()
  nilfs2: Convert nilfs_btree_lookup_dirty_buffers() to use
    filemap_get_folios_tag()
  nilfs2: Convert nilfs_copy_dirty_pages() to use
    filemap_get_folios_tag()
  nilfs2: Convert nilfs_clear_dirty_pages() to use
    filemap_get_folios_tag()
  filemap: Remove find_get_pages_range_tag()

 fs/afs/write.c          | 116 ++++++++++++++++++++--------------------
 fs/btrfs/extent_io.c    |  57 ++++++++++----------
 fs/ceph/addr.c          |  58 ++++++++++----------
 fs/cifs/file.c          |  32 +++++++++--
 fs/ext4/inode.c         |  65 +++++++++++-----------
 fs/f2fs/checkpoint.c    |  49 +++++++++--------
 fs/f2fs/data.c          |  84 ++++++++++++++++++++---------
 fs/f2fs/node.c          |  72 +++++++++++++------------
 fs/gfs2/aops.c          |  64 ++++++++++++----------
 fs/nilfs2/btree.c       |  14 ++---
 fs/nilfs2/page.c        |  59 ++++++++++----------
 fs/nilfs2/segment.c     |  44 +++++++--------
 include/linux/pagemap.h |  32 +++++++----
 include/linux/pagevec.h |   8 ---
 mm/filemap.c            |  84 ++++++++++++++---------------
 mm/page-writeback.c     |  44 +++++++--------
 mm/swap.c               |  10 ----
 17 files changed, 481 insertions(+), 411 deletions(-)

-- 
2.38.1

