From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v13 00/72] Convert page cache to XArray
Date: Mon, 11 Jun 2018 07:05:27 -0700
Message-ID: <20180611140639.17215-1-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=b97DwwVrc8rHLFvjKplVbfyNNJ9JE2iwoiXANNZEbXg=; b=MeUdvVpmf/j1Pepg9zm8Aa9n+t
 XkLgVX+Ep6qN5y5Zi/YZrsC6S4uyDgxV30V8o2V5gIudlyMEKdbdx8ZuQGLcWjdi2+sXM2nkF9xTf
 KXZTWPFoOImvZDOyyiluTc3rL/BkHm1xo1Dft3tREGa79ZueNN14lDrcFSTmm14fjsrI=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:
 Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
 Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
 In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=b97DwwVrc8rHLFvjKplVbfyNNJ9JE2iwoiXANNZEbXg=; b=DovkvXPThABBRs+q2Jfvrdr4Vz
 ICvYOay2R0gT0CboT/PhZncpSQWoI6lppS8buQ4XYFADJ5iAFXiaFYWRys404jxgX9TttWtZwjURg
 kraJPKiDmk2RXzWV1GkubFIfzaTz6kzCBk5TEo85kxOOS8Y8ruPQhNs1IgyuvcREsUWQ=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=Message-Id:Date:Subject:Cc:To:From:
 Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=b97DwwVrc8rHLFvjKplVbfyNNJ9JE2iwoiXANNZEbXg=; b=U4FYZs02pHLMn4wAnYb7dA8Ag
 mQsz/vfN76b92sk5sVIhgDUaV43aSi/HGgEwhxXY1LdMLFXeCswy7KnkI+ooODNfsKfyHAOk+5Dxq
 r1gc+NJGckb8sVGXrCVU8VvKESUiWQZ3jN6kSdV2jvgIZH1sDT2Q2O6KRz4v6EdY5nT9A2Ro00y50
 Vw8wVIh5tkOH+eUAFI4uFlYwHrrCoRddqqDkmn4f5Dv3jC6q6VZlxgM0fg2jCporhHc5m6pku/ANL
 S3Db0qNjfWwRRknrjZLmIWrLyohBpnmPomUYWQ4NgcwGEQnq61rd9rmoBIYXAh23208DyNd8BdsPv
 fUgMP8Okw==;
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, linux-f2fs-devel@lists.sourceforge.net, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>

From: Matthew Wilcox <mawilcox@microsoft.com>

The XArray is a replacement for the radix tree.  For the moment it uses
the same data structures, enabling a gradual replacement.  This patch
set implements the XArray and converts the page cache to use it.

A version of these patches has been running under xfstests for over 48
hours, so I have some confidence in them.  The DAX changes are untested.
This is based on next-20180608 and is available as a git tree at
git://git.infradead.org/users/willy/linux-dax.git xarray-20180608

My plan for getting this lot merged is to create a git branch from -rc1
and ask that to be included in -next.  Last call for reviews/acks.
I'd suggest looking at the page cache changes (patches 19-68) rather
than the XArray patches themselves.  I know there's a lot of patches,
but each individual patch is quite small.

In particular, I'd like reviews from filesystem people of their own
filesystem conversions.  I have that from David Sterba for btrfs, but
I've had no response from the nilfs2 or f2fs people.

Changes since v12:
 - Fixed bug in page cache lookup conversion which could lead to
   returning pages which had been released from the page cache.  Split
   out the seven converted functions each into their own patch to allow
   for better bisection.
 - Fixed bug in workingset conversion that led to exceptional entries not
   being deleted from the XArray.
 - Fixed several bugs in DAX conversion.
 - Added xas_for_each_conflict() and use it in DAX.
 - Undid change of xas_load() behaviour with multislot xa_state that
   was introduced in v10.  Removed test cases, since we don't want that
   behaviour.
 - Re-added conversion of dax_layout_busy_page.
 - Reordered a DAX bugfix to the head of the queue to allow it to
   be merged independently.
 - Dropped "dax_insert_mapping_entry always succeeds" due to being
   merged by Dan.  Thanks, Dan!
 - Dropped "dax: Return fault code from dax_load_hole" as it was taken
   care of by Souptick's patch.
 - At Ross's request, renamed dax_mk_foo() to dax_make_foo().
 - Renamed DAX_ENTRY_LOCK to DAX_LOCKED.
 - Updated migrate_page_move_mapping conversion.
 - Split out the radix tree test suite addition of ubsan.
 - Split out radix tree code deletion.
 - Removed __radix_tree_create from the public API.
 - Fixed up a couple of comments in DAX.
 - Renamed shmem_xa_replace() to shmem_replace_entry().
 - Corrected some typos in the XArray kerneldoc and reworded a few
   sentences in xarray.rst.
 - Added a new section on multi-index entries to xarray.rst, replacing the
   single paragraph we used to have.
 - Fixed multi-index xas_store(xas, NULL) and added test-cases.
 - Fixed multi-index xas_store() in the presence of tags (the new entry is
   tagged if any of the entries it is replacing is tagged).
 - Dropped lustre patch due to removal from staging
 - Use XA_BUG_ON() more in the test suite rather than assert().
   Conversion not completed.
 - Deleted an unused variable from nilfs2 conversion.
 - Rename f2fs_clear_radix_tree_dirty_tag to f2fs_clear_page_cache_dirty_tag

Matthew Wilcox (72):
  radix tree test suite: Enable ubsan
  dax: Fix use of zero page
  xarray: Replace exceptional entries
  xarray: Change definition of sibling entries
  xarray: Add definition of struct xarray
  xarray: Define struct xa_node
  xarray: Add documentation
  xarray: Add xa_load
  xarray: Add XArray tags
  xarray: Add xa_store
  xarray: Add xa_cmpxchg and xa_insert
  xarray: Add xa_for_each
  xarray: Add xa_extract
  xarray: Add xa_destroy
  xarray: Add xas_next and xas_prev
  xarray: Add xas_for_each_conflict
  xarray: Add xas_create_range
  xarray: Add MAINTAINERS entry
  page cache: Rearrange address_space
  page cache: Convert hole search to XArray
  page cache: Add and replace pages using the XArray
  page cache: Convert page deletion to XArray
  page cache: Convert find_get_entry to XArray
  page cache: Convert find_get_entries to XArray
  page cache: Convert find_get_pages_range to XArray
  page cache: Convert find_get_pages_contig to XArray
  page cache; Convert find_get_pages_range_tag to XArray
  page cache: Convert find_get_entries_tag to XArray
  page cache: Convert filemap_map_pages to XArray
  radix tree test suite: Convert regression1 to XArray
  page cache: Convert delete_batch to XArray
  page cache: Remove stray radix comment
  page cache: Convert filemap_range_has_page to XArray
  mm: Convert page-writeback to XArray
  mm: Convert workingset to XArray
  mm: Convert truncate to XArray
  mm: Convert add_to_swap_cache to XArray
  mm: Convert delete_from_swap_cache to XArray
  mm: Convert __do_page_cache_readahead to XArray
  mm: Convert page migration to XArray
  mm: Convert huge_memory to XArray
  mm: Convert collapse_shmem to XArray
  mm: Convert khugepaged_scan_shmem to XArray
  mm: Convert is_page_cache_freeable to XArray
  pagevec: Use xa_tag_t
  shmem: Convert shmem_radix_tree_replace to XArray
  shmem: Convert shmem_confirm_swap to XArray
  shmem: Convert find_swap_entry to XArray
  shmem: Convert shmem_add_to_page_cache to XArray
  shmem: Convert shmem_alloc_hugepage to XArray
  shmem: Convert shmem_free_swap to XArray
  shmem: Convert shmem_partial_swap_usage to XArray
  memfd: Convert memfd_wait_for_pins to XArray
  memfd: Convert memfd_tag_pins to XArray
  shmem: Comment fixups
  btrfs: Convert page cache to XArray
  fs: Convert buffer to XArray
  fs: Convert writeback to XArray
  nilfs2: Convert to XArray
  f2fs: Convert to XArray
  dax: Rename some functions
  dax: Hash on XArray instead of mapping
  dax: Convert dax_insert_pfn_mkwrite to XArray
  dax: Convert dax_layout_busy_page to XArray
  dax: Convert __dax_invalidate_entry to XArray
  dax: Convert dax writeback to XArray
  dax: Convert page fault handlers to XArray
  page cache: Finish XArray conversion
  radix tree: Remove radix_tree_update_node_t
  radix tree: Remove split/join code
  radix tree: Remove radix_tree_maybe_preload_order
  radix tree: Remove radix_tree_clear_tags

 .clang-format                                 |    1 -
 Documentation/core-api/index.rst              |    1 +
 Documentation/core-api/xarray.rst             |  395 ++++
 MAINTAINERS                                   |   12 +
 arch/powerpc/include/asm/book3s/64/pgtable.h  |    4 +-
 arch/powerpc/include/asm/nohash/64/pgtable.h  |    4 +-
 drivers/gpu/drm/i915/i915_gem.c               |   17 +-
 fs/btrfs/compression.c                        |    6 +-
 fs/btrfs/extent_io.c                          |   12 +-
 fs/buffer.c                                   |   14 +-
 fs/dax.c                                      |  792 ++++----
 fs/ext4/inode.c                               |    2 +-
 fs/f2fs/data.c                                |    6 +-
 fs/f2fs/dir.c                                 |    2 +-
 fs/f2fs/f2fs.h                                |    2 +-
 fs/f2fs/inline.c                              |    2 +-
 fs/f2fs/node.c                                |    6 +-
 fs/fs-writeback.c                             |   25 +-
 fs/gfs2/aops.c                                |    2 +-
 fs/inode.c                                    |    2 +-
 fs/nfs/blocklayout/blocklayout.c              |    2 +-
 fs/nilfs2/btnode.c                            |   26 +-
 fs/nilfs2/page.c                              |   29 +-
 fs/proc/task_mmu.c                            |    2 +-
 include/linux/fs.h                            |   63 +-
 include/linux/pagemap.h                       |   10 +-
 include/linux/pagevec.h                       |    8 +-
 include/linux/radix-tree.h                    |  136 +-
 include/linux/swap.h                          |   22 +-
 include/linux/swapops.h                       |   19 +-
 include/linux/xarray.h                        | 1026 ++++++++++
 lib/Makefile                                  |    2 +-
 lib/idr.c                                     |   66 +-
 lib/radix-tree.c                              |  575 +-----
 lib/xarray.c                                  | 1767 +++++++++++++++++
 mm/filemap.c                                  |  723 +++----
 mm/huge_memory.c                              |   17 +-
 mm/khugepaged.c                               |  177 +-
 mm/madvise.c                                  |    2 +-
 mm/memcontrol.c                               |    2 +-
 mm/memfd.c                                    |  105 +-
 mm/migrate.c                                  |   48 +-
 mm/mincore.c                                  |    2 +-
 mm/page-writeback.c                           |   72 +-
 mm/readahead.c                                |   10 +-
 mm/shmem.c                                    |  201 +-
 mm/swap.c                                     |    6 +-
 mm/swap_state.c                               |  119 +-
 mm/truncate.c                                 |   27 +-
 mm/vmscan.c                                   |   10 +-
 mm/workingset.c                               |   71 +-
 tools/include/asm-generic/bitops.h            |    1 +
 tools/include/asm-generic/bitops/atomic.h     |    9 -
 tools/include/asm-generic/bitops/non-atomic.h |  109 +
 tools/include/linux/bitmap.h                  |    1 +
 tools/include/linux/spinlock.h                |   12 +-
 tools/testing/radix-tree/.gitignore           |    2 +
 tools/testing/radix-tree/Makefile             |   20 +-
 tools/testing/radix-tree/benchmark.c          |   91 -
 tools/testing/radix-tree/bitmap.c             |   23 +
 tools/testing/radix-tree/idr-test.c           |    6 +-
 tools/testing/radix-tree/linux/bug.h          |    1 +
 tools/testing/radix-tree/linux/kconfig.h      |    1 +
 tools/testing/radix-tree/linux/kernel.h       |    5 +
 tools/testing/radix-tree/linux/lockdep.h      |   11 +
 tools/testing/radix-tree/linux/rcupdate.h     |    2 +
 tools/testing/radix-tree/linux/xarray.h       |    3 +
 tools/testing/radix-tree/main.c               |   20 +-
 tools/testing/radix-tree/multiorder.c         |  272 +--
 tools/testing/radix-tree/regression1.c        |   58 +-
 tools/testing/radix-tree/regression3.c        |   23 -
 tools/testing/radix-tree/tag_check.c          |   32 +-
 tools/testing/radix-tree/test.c               |   53 +-
 tools/testing/radix-tree/test.h               |    6 +
 tools/testing/radix-tree/xarray-test.c        |  631 ++++++
 75 files changed, 5392 insertions(+), 2652 deletions(-)
 create mode 100644 Documentation/core-api/xarray.rst
 create mode 100644 lib/xarray.c
 create mode 100644 tools/include/asm-generic/bitops/non-atomic.h
 create mode 100644 tools/testing/radix-tree/bitmap.c
 create mode 100644 tools/testing/radix-tree/linux/kconfig.h
 create mode 100644 tools/testing/radix-tree/linux/lockdep.h
 create mode 100644 tools/testing/radix-tree/linux/xarray.h
 create mode 100644 tools/testing/radix-tree/xarray-test.c

-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
