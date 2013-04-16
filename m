From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix issue with flush kernel thread after
 remount in RO mode because of driver's internal error or metadata
 corruption
Date: Wed, 17 Apr 2013 01:49:52 +0900 (JST)
Message-ID: <20130417.014952.55839776.konishi.ryusuke@lab.ntt.co.jp>
References: <1366099445.2091.8.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1366099445.2091.8.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Anthony2486-fDpYTK8McCxDP812hmKXO1pr/1R2p/CL@public.gmane.org, hermes-akuOmOme3sQYOdUovKs6ag@public.gmane.org, szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org, zahid.chowdhury-VJizFkI/10gAspv4Qr0y0gC/G2K4zDHf@public.gmane.org, freeboy6716-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Tue, 16 Apr 2013 12:04:05 +0400, Vyacheslav Dubeyko wrote:
> From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> Subject: [PATCH] nilfs2: fix issue with flush kernel thread after remount in RO mode because of driver's internal error or metadata corruption
> 
> DESCRIPTION:
> NILFS2 driver remounts itself in RO mode in the case of metadata corruption discovering (for example, in the case of broken bmap discovering). But, usually, it takes place file system operations before remounting in RO mode. Thereby, NILFS2 driver can be in RO mode with presence of dirty pages in modified inodes' address spaces. It results in flush kernel thread's infinite trying to flush dirty pages in RO mode. As a result, it is possible to see such side effects as: (1) flush kernel thread occupies 50% - 99% of CPU time; (2) system can't be shutdowned without manual power switch off.
> 
> SYMPTOMS:
> (1) System log contains error message: "Remounting filesystem read-only".
> (2) The flush kernel thread occupies 50% - 99% of CPU time.
> (3) The system can't be shutdowned without manual power switch off.
> 
> REPRODUCTION PATH:
> (1) Create volume group with name "unencrypted" by means of vgcreate utility.
> (2) Run script (prepared by Anthony Doggett <Anthony2486-fDpYTK8McCxDP812hmKXO1pr/1R2p/CL@public.gmane.org>):
> 
> ----------------[BEGIN SCRIPT]--------------------
> #!/bin/bash
> 
> VG=unencrypted
> #apt-get install nilfs-tools darcs
> lvcreate --size 2G --name ntest $VG
> mkfs.nilfs2 -b 1024 -B 8192 /dev/mapper/$VG-ntest
> mkdir /var/tmp/n
> mkdir /var/tmp/n/ntest
> mount /dev/mapper/$VG-ntest /var/tmp/n/ntest
> mkdir /var/tmp/n/ntest/thedir
> cd /var/tmp/n/ntest/thedir
> sleep 2
> date
> darcs init
> sleep 2
> dmesg|tail -n 5
> date
> darcs whatsnew || true
> date
> sleep 2
> dmesg|tail -n 5
> ----------------[END SCRIPT]--------------------
> 
> (3) Try to shutdown the system.
> 
> REPRODUCIBILITY: 100%
> 
> FIX:
> The patch implements checking mount state of NILFS2 driver in nilfs_writepage(), nilfs_writepages() and nilfs_mdt_write_page() methods. If it is detected the RO mount state then all dirty pages are simply discarded with warning messages is written in system log.
> 
> Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
> Tested-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>

Thank you for posting this fix.

I'll comment on code inline.

> ---
>  fs/nilfs2/inode.c |   17 +++++++++++++
>  fs/nilfs2/mdt.c   |   19 +++++++++++----
>  fs/nilfs2/page.c  |   69 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/nilfs2/page.h  |    3 ++-
>  4 files changed, 102 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
> index 6b49f14..7f4db1d 100644
> --- a/fs/nilfs2/inode.c
> +++ b/fs/nilfs2/inode.c
> @@ -175,6 +175,11 @@ static int nilfs_writepages(struct address_space *mapping,
>  	struct inode *inode = mapping->host;
>  	int err = 0;
>  
> +	if (inode->i_sb->s_flags & MS_RDONLY) {
> +		nilfs_clear_dirty_pages(mapping, false);
> +		return -EROFS;
> +	}
> +
>  	if (wbc->sync_mode == WB_SYNC_ALL)
>  		err = nilfs_construct_dsync_segment(inode->i_sb, inode,
>  						    wbc->range_start,
> @@ -187,6 +192,18 @@ static int nilfs_writepage(struct page *page, struct writeback_control *wbc)
>  	struct inode *inode = page->mapping->host;
>  	int err;
>  
> +	if (inode && (inode->i_sb->s_flags & MS_RDONLY)) {
> +		/*
> +		 * It means that filesystem was remounted in read-only
> +		 * mode because of error or metadata corruption. But we
> +		 * have dirty pages that try to be flushed in background.
> +		 * So, here we simply discard this dirty page.
> +		 */
> +		err = nilfs_discard_page_in_ro_mode(page);
> +		if (err == -EROFS) /* page is unlocked */
> +			return err;
> +	}
> +
>  	redirty_page_for_writepage(wbc, page);
>  	unlock_page(page);
>  
> diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
> index f9897d0..a386fb0 100644
> --- a/fs/nilfs2/mdt.c
> +++ b/fs/nilfs2/mdt.c
> @@ -375,14 +375,25 @@ int nilfs_mdt_fetch_dirty(struct inode *inode)
>  static int
>  nilfs_mdt_write_page(struct page *page, struct writeback_control *wbc)
>  {
> -	struct inode *inode;
> +	struct inode *inode = page->mapping->host;
>  	struct super_block *sb;
>  	int err = 0;
>  
> +	if (inode && (inode->i_sb->s_flags & MS_RDONLY)) {
> +		/*
> +		 * It means that filesystem was remounted in read-only
> +		 * mode because of error or metadata corruption. But we
> +		 * have dirty pages that try to be flushed in background.
> +		 * So, here we simply discard this dirty page.
> +		 */
> +		err = nilfs_discard_page_in_ro_mode(page);
> +		if (err == -EROFS) /* page is unlocked */
> +			return err;
> +	}
> +
>  	redirty_page_for_writepage(wbc, page);
>  	unlock_page(page);
>  
> -	inode = page->mapping->host;
>  	if (!inode)
>  		return 0;
>  
> @@ -561,10 +572,10 @@ void nilfs_mdt_restore_from_shadow_map(struct inode *inode)
>  	if (mi->mi_palloc_cache)
>  		nilfs_palloc_clear_cache(inode);
>  
> -	nilfs_clear_dirty_pages(inode->i_mapping);
> +	nilfs_clear_dirty_pages(inode->i_mapping, true);
>  	nilfs_copy_back_pages(inode->i_mapping, &shadow->frozen_data);
>  
> -	nilfs_clear_dirty_pages(&ii->i_btnode_cache);
> +	nilfs_clear_dirty_pages(&ii->i_btnode_cache, true);
>  	nilfs_copy_back_pages(&ii->i_btnode_cache, &shadow->frozen_btnodes);
>  
>  	nilfs_bmap_restore(ii->i_bmap, &shadow->bmap_store);
> diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
> index 07f76db..9aa6793 100644
> --- a/fs/nilfs2/page.c
> +++ b/fs/nilfs2/page.c
> @@ -108,6 +108,61 @@ void nilfs_forget_buffer(struct buffer_head *bh)
>  }
>  
>  /**
> + * nilfs_discard_page_in_ro_mode - discard page dirty state in RO mode
> + * @page: discarded dirty page
> + */
> +int nilfs_discard_page_in_ro_mode(struct page *page)
> +{
> +	struct inode *inode = page->mapping->host;
> +	struct super_block *sb;
> +

> +	if (!inode)
> +		return -EINVAL;

This check is redundant.  Please remove it.

> +
> +	BUG_ON(!test_bit(PG_locked, &page->flags));
> +
> +	sb = inode->i_sb;

The local variable "sb" looks unused.

> +
> +	if (inode->i_sb->s_flags & MS_RDONLY) {

This verification is also redundant.  Please remove it.

> +		/*
> +		 * It means that filesystem was remounted in read-only
> +		 * mode because of error or metadata corruption. But we
> +		 * have dirty pages that try to be flushed in background.
> +		 * So, here we simply discard this dirty page.
> +		 */
> +		nilfs_warning(inode->i_sb, __func__,
> +			"discard dirty page: offset %lld, ino %lu\n",
> +			page_offset(page), inode->i_ino);
> +
> +		ClearPageUptodate(page);
> +		ClearPageMappedToDisk(page);
> +		if (page_has_buffers(page)) {
> +			struct buffer_head *bh, *head;
> +
> +			bh = head = page_buffers(page);
> +			do {
> +				lock_buffer(bh);
> +				nilfs_warning(inode->i_sb, __func__,
> +				      "discard dirty block %llu, size %lu\n",
> +				      (u64)bh->b_blocknr, bh->b_size);
> +				clear_buffer_dirty(bh);
> +				clear_buffer_nilfs_volatile(bh);
> +				clear_buffer_nilfs_checked(bh);
> +				clear_buffer_nilfs_redirected(bh);
> +				clear_buffer_uptodate(bh);
> +				clear_buffer_mapped(bh);
> +				unlock_buffer(bh);
> +			} while (bh = bh->b_this_page, bh != head);
> +		}
> +		__nilfs_clear_page_dirty(page);

These lines are basically same as the loop body of
nilfs_clear_dirty_pages().

> +		unlock_page(page);

This unlock_page() is confusing because it is asymmetric and
conditional.  Please move it to callers.

> +	} else
> +		return 0;
> +
> +	return -EROFS;

These return statements are eliminable by removing redundant checks
that I commented above.

After all, I think you should add

  void nilfs_clear_dirty_page(struct page *page, bool silent);

which separates the loop body of the nilfs_clear_dirty_pages(),
and use it instead of nilfs_discard_page_in_ro_mode().


Thanks,
Ryusuke Konishi

> +}
> +
> +/**
>   * nilfs_copy_buffer -- copy buffer data and flags
>   * @dbh: destination buffer
>   * @sbh: source buffer
> @@ -370,7 +425,7 @@ repeat:
>  	goto repeat;
>  }
>  
> -void nilfs_clear_dirty_pages(struct address_space *mapping)
> +void nilfs_clear_dirty_pages(struct address_space *mapping, bool silent)
>  {
>  	struct pagevec pvec;
>  	unsigned int i;
> @@ -384,12 +439,24 @@ void nilfs_clear_dirty_pages(struct address_space *mapping)
>  			struct page *page = pvec.pages[i];
>  			struct buffer_head *bh, *head;
>  
> +			if (!silent) {
> +				nilfs_warning(mapping->host->i_sb, __func__,
> +				    "discard page: offset %lld, ino %lu\n",
> +				    page_offset(page), mapping->host->i_ino);
> +			}
> +
>  			lock_page(page);
>  			ClearPageUptodate(page);
>  			ClearPageMappedToDisk(page);
>  			bh = head = page_buffers(page);
>  			do {
>  				lock_buffer(bh);
> +				if (!silent) {
> +					nilfs_warning(mapping->host->i_sb,
> +					    __func__,
> +					    "discard block %llu, size %lu\n",
> +					    (u64)bh->b_blocknr, bh->b_size);
> +				}
>  				clear_buffer_dirty(bh);
>  				clear_buffer_nilfs_volatile(bh);
>  				clear_buffer_nilfs_checked(bh);
> diff --git a/fs/nilfs2/page.h b/fs/nilfs2/page.h
> index fb7de71..3dcc5c8 100644
> --- a/fs/nilfs2/page.h
> +++ b/fs/nilfs2/page.h
> @@ -49,13 +49,14 @@ int __nilfs_clear_page_dirty(struct page *);
>  struct buffer_head *nilfs_grab_buffer(struct inode *, struct address_space *,
>  				      unsigned long, unsigned long);
>  void nilfs_forget_buffer(struct buffer_head *);
> +int nilfs_discard_page_in_ro_mode(struct page *page);
>  void nilfs_copy_buffer(struct buffer_head *, struct buffer_head *);
>  int nilfs_page_buffers_clean(struct page *);
>  void nilfs_page_bug(struct page *);
>  
>  int nilfs_copy_dirty_pages(struct address_space *, struct address_space *);
>  void nilfs_copy_back_pages(struct address_space *, struct address_space *);
> -void nilfs_clear_dirty_pages(struct address_space *);
> +void nilfs_clear_dirty_pages(struct address_space *, bool);
>  void nilfs_mapping_init(struct address_space *mapping, struct inode *inode,
>  			struct backing_dev_info *bdi);
>  unsigned nilfs_page_count_clean_buffers(struct page *, unsigned, unsigned);
> -- 
> 1.7.9.5
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
