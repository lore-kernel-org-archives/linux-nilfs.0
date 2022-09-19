From: Vishal Moola <vishal.moola@gmail.com>
Subject: Re: [PATCH v2 00/23] Convert to filemap_get_folios_tag()
Date: Mon, 19 Sep 2022 10:34:40 -0700
Message-ID: <CAOzc2pznw0qp3xVm98-TdU=JBVxintYN1Q4Ci9qTQkBYRxi9QQ@mail.gmail.com>
References: <20220912182224.514561-1-vishal.moola@gmail.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=kdS9QD9VodJFlDe/hzPt/fIHrfeguLlK063E4oft3xY=;
        b=RSsN1QZHs/TmzsGp1gwypXdKb/ST8jjoxnGgjyJpGV7sq5aaYponooE63RtJDRuoFk
         4VXjc4NPaG7MQomjEcSt+y7p4ZVGuVPclZGjlL/vQiCR0Me8vanyEOYot/zi8Qsubu9j
         Ix69jBgynF7tCkr+xxKol7c7kNhnVS8KJgxgKk0lyolCfmfJb+3zoq8Vz25NtkyW/5RJ
         p2+8AeVSPil9bJICaFxtsaSaqUw5Kt5tKUWnYm/Zm3aB+7O1VaahZGVySmK2tZf55QM0
         YghzgAsvx0sqLEfTTQQuMHFJo6+U/klj2pt5kixy16lXa6EmRGn5eHCZGXkCezFh7SPi
         kjXg==
In-Reply-To: <20220912182224.514561-1-vishal.moola@gmail.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-nilfs@vger.kernel.org, linux-mm@kvack.org

On Mon, Sep 12, 2022 at 11:25 AM Vishal Moola (Oracle)
<vishal.moola@gmail.com> wrote:
>
> This patch series replaces find_get_pages_range_tag() with
> filemap_get_folios_tag(). This also allows the removal of multiple
> calls to compound_head() throughout.
> It also makes a good chunk of the straightforward conversions to folios,
> and takes the opportunity to introduce a function that grabs a folio
> from the pagecache.
>
> F2fs and Ceph have quite alot of work to be done regarding folios, so
> for now those patches only have the changes necessary for the removal of
> find_get_pages_range_tag(), and only support folios of size 1 (which is
> all they use right now anyways).
>
> I've run xfstests on btrfs, ext4, f2fs, and nilfs2, but more testing may be
> beneficial. The page-writeback and filemap changes implicitly work. Testing
> and review of the other changes (afs, ceph, cifs, gfs2) would be appreciated.
> ---
> v2:
>   Got Acked-By tags for nilfs and btrfs changes
>   Fixed an error arising in f2fs
>   - Reported-by: kernel test robot <lkp@intel.com>
>
> Vishal Moola (Oracle) (23):
>   pagemap: Add filemap_grab_folio()
>   filemap: Added filemap_get_folios_tag()
>   filemap: Convert __filemap_fdatawait_range() to use
>     filemap_get_folios_tag()
>   page-writeback: Convert write_cache_pages() to use
>     filemap_get_folios_tag()
>   afs: Convert afs_writepages_region() to use filemap_get_folios_tag()
>   btrfs: Convert btree_write_cache_pages() to use
>     filemap_get_folio_tag()
>   btrfs: Convert extent_write_cache_pages() to use
>     filemap_get_folios_tag()
>   ceph: Convert ceph_writepages_start() to use filemap_get_folios_tag()
>   cifs: Convert wdata_alloc_and_fillpages() to use
>     filemap_get_folios_tag()
>   ext4: Convert mpage_prepare_extent_to_map() to use
>     filemap_get_folios_tag()
>   f2fs: Convert f2fs_fsync_node_pages() to use filemap_get_folios_tag()
>   f2fs: Convert f2fs_flush_inline_data() to use filemap_get_folios_tag()
>   f2fs: Convert f2fs_sync_node_pages() to use filemap_get_folios_tag()
>   f2fs: Convert f2fs_write_cache_pages() to use filemap_get_folios_tag()
>   f2fs: Convert last_fsync_dnode() to use filemap_get_folios_tag()
>   f2fs: Convert f2fs_sync_meta_pages() to use filemap_get_folios_tag()
>   gfs2: Convert gfs2_write_cache_jdata() to use filemap_get_folios_tag()
>   nilfs2: Convert nilfs_lookup_dirty_data_buffers() to use
>     filemap_get_folios_tag()
>   nilfs2: Convert nilfs_lookup_dirty_node_buffers() to use
>     filemap_get_folios_tag()
>   nilfs2: Convert nilfs_btree_lookup_dirty_buffers() to use
>     filemap_get_folios_tag()
>   nilfs2: Convert nilfs_copy_dirty_pages() to use
>     filemap_get_folios_tag()
>   nilfs2: Convert nilfs_clear_dirty_pages() to use
>     filemap_get_folios_tag()
>   filemap: Remove find_get_pages_range_tag()
>
>  fs/afs/write.c          | 114 +++++++++++++++++----------------
>  fs/btrfs/extent_io.c    |  57 +++++++++--------
>  fs/ceph/addr.c          | 138 ++++++++++++++++++++--------------------
>  fs/cifs/file.c          |  33 +++++++++-
>  fs/ext4/inode.c         |  55 ++++++++--------
>  fs/f2fs/checkpoint.c    |  49 +++++++-------
>  fs/f2fs/compress.c      |  13 ++--
>  fs/f2fs/data.c          |  69 ++++++++++----------
>  fs/f2fs/f2fs.h          |   5 +-
>  fs/f2fs/node.c          |  72 +++++++++++----------
>  fs/gfs2/aops.c          |  64 ++++++++++---------
>  fs/nilfs2/btree.c       |  14 ++--
>  fs/nilfs2/page.c        |  59 ++++++++---------
>  fs/nilfs2/segment.c     |  44 +++++++------
>  include/linux/pagemap.h |  32 +++++++---
>  include/linux/pagevec.h |   8 ---
>  mm/filemap.c            |  87 ++++++++++++-------------
>  mm/page-writeback.c     |  44 +++++++------
>  mm/swap.c               |  10 ---
>  19 files changed, 507 insertions(+), 460 deletions(-)
>
> --
> 2.36.1
>

Just following up on these patches. Many of the changes still need review.
If anyone has time this week to look over any of the affected areas (pagecache,
afs, ceph, ciph, ext4, f2fs, or gfs) feedback would be much appreciated.

Also, Thanks to David for looking at btrfs and Ryusuke for looking at
nilfs already.
