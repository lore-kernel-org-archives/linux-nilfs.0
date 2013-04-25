From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix issue with broken bmap for the case of
 block size lesser than 4 KB
Date: Fri, 26 Apr 2013 01:37:48 +0900 (JST)
Message-ID: <20130426.013748.27792413.konishi.ryusuke@lab.ntt.co.jp>
References: <1366885717.2119.5.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1366885717.2119.5.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Anthony Doggett <Anthony2486-fDpYTK8McCxDP812hmKXO1pr/1R2p/CL@public.gmane.org>

Hi Vyacheslav,
On Thu, 25 Apr 2013 14:28:37 +0400, Vyacheslav Dubeyko wrote:
> Hi Ryusuke,
> 
> I think that this patch really needs in your review.
> 
> Thanks,
> Vyacheslav Dubeyko.
> --
> From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> Subject: [PATCH] nilfs2: fix issue with broken bmap for the case of block size lesser than 4 KB
> 
> DESCRIPTION:
> There are use-cases when NILFS2 file system (formatted with block size lesser than 4 KB) can be remounted in RO mode because of encountering of "broken bmap" issue.
> 
> The issue was reported by Anthony Doggett <Anthony2486-fDpYTK8McCxDP812hmKXO1pr/1R2p/CL@public.gmane.org>: "The machine I've been trialling nilfs on is running Debian Testing, Linux version 3.2.0-4-686-pae (debian-kernel-0aAXYlwwYIJuHlm7Suoebg@public.gmane.org) (gcc version 4.6.3 (Debian 4.6.3-14) ) #1 SMP Debian 3.2.35-2), but I've also reproduced it (identically) with Debian Unstable amd64 and Debian Experimental (using the 3.8-trunk kernel).  The problematic partitions were formatted with "mkfs.nilfs2 -b 1024 -B 8192"."
> 
> SYMPTOMS:
> (1) System log contains error messages likewise:
> 
>     [63102.496756] nilfs_direct_assign: invalid pointer: 0
>     [63102.496786] NILFS error (device dm-17): nilfs_bmap_assign: broken bmap (inode number=28)
>     [63102.496798]
>     [63102.524403] Remounting filesystem read-only
> 
> (2) The NILFS2 file system is remounted in RO mode.
> 
> REPRODUSING PATH:
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
> REPRODUCIBILITY: 100%
> 
> INVESTIGATION:
> As it was discovered, the issue takes place during segment construction after executing such sequence of user-space operations:
> 
> open("_darcs/index", O_RDWR|O_CREAT|O_NOCTTY, 0666) = 7
> fstat(7, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
> ftruncate(7, 60)
> 
> Factually, the error message "NILFS error (device dm-17): nilfs_bmap_assign: broken bmap (inode number=28)" takes place because of trying to get block number for third block of the file with logical offset #3072 bytes. As it is possible to see from above output, the file has 60 bytes of the whole size. So, it is enough one block (1 KB in size) allocation for the whole file. Trying to operate with several blocks instead of one takes place because of discovering several dirty buffers for this file in nilfs_segctor_scan_file() method. The create_empty_buffers() method creates buffers for the whole page size. So, for the case of 1 KB block this method creates 4 empty buffers. As a result, in the case of block size lesser than 4 KB the NILFS2 code tries to operate with all buffers for the pag
 e without taking into account really allocated buffers count.
> 
> FIX:
> The BH_NILFS_Allocated flag is used as a basis for the issue fix. Namely, this flag is a info that this buffer is a really allocated buffer. So, every buffer is marked as BH_NILFS_Allocated in the case of mapping on real block. And only buffers with flag BH_NILFS_Allocated are getting into operations with its.
> 
> Reported-by: Anthony Doggett <Anthony2486-fDpYTK8McCxDP812hmKXO1pr/1R2p/CL@public.gmane.org>
> Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Adding BH_NILFS_Allocated flag looks overkill for this issue.

Why not modify btree or direct mapping code so that the buffer dirty
flag is propery set or cleared also for 1 KB block?  Basically, the
block mapping code of NILFS is designed to be able to handle 1 KB
block.

If this issue occurs after file size extension with ftruncate(), I
guess handling of hole blocks created by the extension seems to have
problem.

I will look into the issue too.


Regards,
Ryusuke Konishi


> ---
>  fs/nilfs2/btnode.c   |    2 ++
>  fs/nilfs2/btree.c    |    2 ++
>  fs/nilfs2/gcinode.c  |    1 +
>  fs/nilfs2/inode.c    |    2 ++
>  fs/nilfs2/mdt.c      |    2 ++
>  fs/nilfs2/page.c     |    5 +++++
>  fs/nilfs2/page.h     |    1 +
>  fs/nilfs2/recovery.c |   12 +++++++++++-
>  fs/nilfs2/segbuf.c   |    2 ++
>  fs/nilfs2/segment.c  |    5 +++--
>  fs/nilfs2/super.c    |    2 ++
>  11 files changed, 33 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
> index a35ae35..cbc0057 100644
> --- a/fs/nilfs2/btnode.c
> +++ b/fs/nilfs2/btnode.c
> @@ -60,6 +60,7 @@ nilfs_btnode_create_block(struct address_space *btnc, __u64 blocknr)
>  	bh->b_blocknr = blocknr;
>  	set_buffer_mapped(bh);
>  	set_buffer_uptodate(bh);
> +	set_buffer_nilfs_allocated(bh);
>  
>  	unlock_page(bh->b_page);
>  	page_cache_release(bh->b_page);
> @@ -124,6 +125,7 @@ int nilfs_btnode_submit_block(struct address_space *btnc, __u64 blocknr,
>  	*submit_ptr = pblocknr;
>  	err = 0;
>  found:
> +	set_buffer_nilfs_allocated(bh);
>  	*pbh = bh;
>  
>  out_locked:
> diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
> index b2e3ff3..bbdaa1f 100644
> --- a/fs/nilfs2/btree.c
> +++ b/fs/nilfs2/btree.c
> @@ -2068,6 +2068,8 @@ static void nilfs_btree_lookup_dirty_buffers(struct nilfs_bmap *btree,
>  		for (i = 0; i < pagevec_count(&pvec); i++) {
>  			bh = head = page_buffers(pvec.pages[i]);
>  			do {
> +				if (!buffer_nilfs_allocated(bh))
> +					continue;
>  				if (buffer_dirty(bh))
>  					nilfs_btree_add_dirty_buffer(btree,
>  								     lists, bh);
> diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
> index 57ceaf3..f7d714b 100644
> --- a/fs/nilfs2/gcinode.c
> +++ b/fs/nilfs2/gcinode.c
> @@ -111,6 +111,7 @@ int nilfs_gccache_submit_read_data(struct inode *inode, sector_t blkoff,
>  		bh->b_blocknr = vbn;
>   out:
>  	err = 0;
> +	set_buffer_nilfs_allocated(bh);
>  	*out_bh = bh;
>  
>   failed:
> diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
> index ba7a1da..8992291 100644
> --- a/fs/nilfs2/inode.c
> +++ b/fs/nilfs2/inode.c
> @@ -93,6 +93,7 @@ int nilfs_get_block(struct inode *inode, sector_t blkoff,
>  		map_bh(bh_result, inode->i_sb, blknum);
>  		if (ret > 0)
>  			bh_result->b_size = (ret << inode->i_blkbits);
> +		set_buffer_nilfs_allocated(bh_result);
>  		goto out;
>  	}
>  	/* data block was not found */
> @@ -132,6 +133,7 @@ int nilfs_get_block(struct inode *inode, sector_t blkoff,
>  		set_buffer_delay(bh_result);
>  		map_bh(bh_result, inode->i_sb, 0); /* dbn must be changed
>  						      to proper value */
> +		set_buffer_nilfs_allocated(bh_result);
>  	} else if (ret == -ENOENT) {
>  		/* not found is not error (e.g. hole); must return without
>  		   the mapped state flag. */
> diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
> index c4dcd1d..9156635 100644
> --- a/fs/nilfs2/mdt.c
> +++ b/fs/nilfs2/mdt.c
> @@ -57,6 +57,7 @@ nilfs_mdt_insert_new_block(struct inode *inode, unsigned long block,
>  		return ret;
>  
>  	set_buffer_mapped(bh);
> +	set_buffer_nilfs_allocated(bh);
>  
>  	kaddr = kmap_atomic(bh->b_page);
>  	memset(kaddr + bh_offset(bh), 0, 1 << inode->i_blkbits);
> @@ -160,6 +161,7 @@ nilfs_mdt_submit_block(struct inode *inode, unsigned long blkoff,
>  	ret = 0;
>   out:
>  	get_bh(bh);
> +	set_buffer_nilfs_allocated(bh);
>  	*out_bh = bh;
>  
>   failed_bh:
> diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
> index 4f07e0e..b95540e 100644
> --- a/fs/nilfs2/page.c
> +++ b/fs/nilfs2/page.c
> @@ -101,6 +101,7 @@ void nilfs_forget_buffer(struct buffer_head *bh)
>  	clear_buffer_uptodate(bh);
>  	clear_buffer_mapped(bh);
>  	bh->b_blocknr = -1;
> +	clear_buffer_nilfs_allocated(bh);
>  	ClearPageUptodate(page);
>  	ClearPageMappedToDisk(page);
>  	unlock_buffer(bh);
> @@ -159,8 +160,11 @@ int nilfs_page_buffers_clean(struct page *page)
>  
>  	bh = head = page_buffers(page);
>  	do {
> +		if (!buffer_nilfs_allocated(bh))
> +			goto next_buffer;
>  		if (buffer_dirty(bh))
>  			return 0;
> +next_buffer:
>  		bh = bh->b_this_page;
>  	} while (bh != head);
>  	return 1;
> @@ -435,6 +439,7 @@ void nilfs_clear_dirty_page(struct page *page, bool silent)
>  			clear_buffer_nilfs_checked(bh);
>  			clear_buffer_nilfs_redirected(bh);
>  			clear_buffer_uptodate(bh);
> +			clear_buffer_nilfs_allocated(bh);
>  			clear_buffer_mapped(bh);
>  			unlock_buffer(bh);
>  		} while (bh = bh->b_this_page, bh != head);
> diff --git a/fs/nilfs2/page.h b/fs/nilfs2/page.h
> index ef30c5c..008e234 100644
> --- a/fs/nilfs2/page.h
> +++ b/fs/nilfs2/page.h
> @@ -38,6 +38,7 @@ enum {
>  	BH_NILFS_Redirected,
>  };
>  
> +BUFFER_FNS(NILFS_Allocated, nilfs_allocated)
>  BUFFER_FNS(NILFS_Node, nilfs_node)		/* nilfs node buffers */
>  BUFFER_FNS(NILFS_Volatile, nilfs_volatile)
>  BUFFER_FNS(NILFS_Checked, nilfs_checked)	/* buffer is verified */
> diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
> index ff00a0b..bac3575 100644
> --- a/fs/nilfs2/recovery.c
> +++ b/fs/nilfs2/recovery.c
> @@ -122,6 +122,7 @@ static int nilfs_compute_checksum(struct the_nilfs *nilfs,
>  			bh = __bread(nilfs->ns_bdev, ++start, blocksize);
>  			if (!bh)
>  				return -EIO;
> +			set_buffer_nilfs_allocated(bh);
>  			check_bytes -= size;
>  			size = min_t(u64, check_bytes, blocksize);
>  			crc = crc32_le(crc, bh->b_data, size);
> @@ -153,6 +154,7 @@ int nilfs_read_super_root_block(struct the_nilfs *nilfs, sector_t sr_block,
>  		ret = NILFS_SEG_FAIL_IO;
>  		goto failed;
>  	}
> +	set_buffer_nilfs_allocated(bh_sr);
>  
>  	sr = (struct nilfs_super_root *)bh_sr->b_data;
>  	if (check) {
> @@ -196,8 +198,10 @@ nilfs_read_log_header(struct the_nilfs *nilfs, sector_t start_blocknr,
>  	struct buffer_head *bh_sum;
>  
>  	bh_sum = __bread(nilfs->ns_bdev, start_blocknr, nilfs->ns_blocksize);
> -	if (bh_sum)
> +	if (bh_sum) {
> +		set_buffer_nilfs_allocated(bh_sum);
>  		*sum = (struct nilfs_segment_summary *)bh_sum->b_data;
> +	}
>  	return bh_sum;
>  }
>  
> @@ -266,6 +270,7 @@ static void *nilfs_read_summary_info(struct the_nilfs *nilfs,
>  			       nilfs->ns_blocksize);
>  		if (unlikely(!*pbh))
>  			return NULL;
> +		set_buffer_nilfs_allocated(*pbh);
>  		*offset = 0;
>  	}
>  	ptr = (*pbh)->b_data + *offset;
> @@ -303,6 +308,8 @@ static void nilfs_skip_summary_info(struct the_nilfs *nilfs,
>  		brelse(*pbh);
>  		*pbh = __bread(nilfs->ns_bdev, blocknr + bcnt,
>  			       nilfs->ns_blocksize);
> +		if (*pbh)
> +			set_buffer_nilfs_allocated(*pbh);
>  	}
>  }
>  
> @@ -333,6 +340,7 @@ static int nilfs_scan_dsync_log(struct the_nilfs *nilfs, sector_t start_blocknr,
>  	bh = __bread(nilfs->ns_bdev, start_blocknr, nilfs->ns_blocksize);
>  	if (unlikely(!bh))
>  		goto out;
> +	set_buffer_nilfs_allocated(bh);
>  
>  	offset = le16_to_cpu(sum->ss_bytes);
>  	for (;;) {
> @@ -492,6 +500,7 @@ static int nilfs_recovery_copy_block(struct the_nilfs *nilfs,
>  	bh_org = __bread(nilfs->ns_bdev, rb->blocknr, nilfs->ns_blocksize);
>  	if (unlikely(!bh_org))
>  		return -EIO;
> +	set_buffer_nilfs_allocated(bh_org);
>  
>  	kaddr = kmap_atomic(page);
>  	memcpy(kaddr + bh_offset(bh_org), bh_org->b_data, bh_org->b_size);
> @@ -712,6 +721,7 @@ static void nilfs_finish_roll_forward(struct the_nilfs *nilfs,
>  
>  	bh = __getblk(nilfs->ns_bdev, ri->ri_lsegs_start, nilfs->ns_blocksize);
>  	BUG_ON(!bh);
> +	set_buffer_nilfs_allocated(bh);
>  	memset(bh->b_data, 0, bh->b_size);
>  	set_buffer_dirty(bh);
>  	err = sync_dirty_buffer(bh);
> diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
> index dc9a913..c69a2b3 100644
> --- a/fs/nilfs2/segbuf.c
> +++ b/fs/nilfs2/segbuf.c
> @@ -113,6 +113,7 @@ int nilfs_segbuf_extend_segsum(struct nilfs_segment_buffer *segbuf)
>  		       segbuf->sb_pseg_start + segbuf->sb_sum.nsumblk);
>  	if (unlikely(!bh))
>  		return -ENOMEM;
> +	set_buffer_nilfs_allocated(bh);
>  
>  	nilfs_segbuf_add_segsum_buffer(segbuf, bh);
>  	return 0;
> @@ -127,6 +128,7 @@ int nilfs_segbuf_extend_payload(struct nilfs_segment_buffer *segbuf,
>  		       segbuf->sb_pseg_start + segbuf->sb_sum.nblocks);
>  	if (unlikely(!bh))
>  		return -ENOMEM;
> +	set_buffer_nilfs_allocated(bh);
>  
>  	nilfs_segbuf_add_payload_buffer(segbuf, bh);
>  	*bhp = bh;
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index a5752a58..3d4cdae 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -665,7 +665,7 @@ static size_t nilfs_lookup_dirty_data_buffers(struct inode *inode,
>  
>  		bh = head = page_buffers(page);
>  		do {
> -			if (!buffer_dirty(bh))
> +			if (!buffer_dirty(bh) || !buffer_nilfs_allocated(bh))
>  				continue;
>  			get_bh(bh);
>  			list_add_tail(&bh->b_assoc_buffers, listp);
> @@ -699,7 +699,8 @@ static void nilfs_lookup_dirty_node_buffers(struct inode *inode,
>  		for (i = 0; i < pagevec_count(&pvec); i++) {
>  			bh = head = page_buffers(pvec.pages[i]);
>  			do {
> -				if (buffer_dirty(bh)) {
> +				if (buffer_dirty(bh) &&
> +						buffer_nilfs_allocated(bh)) {
>  					get_bh(bh);
>  					list_add_tail(&bh->b_assoc_buffers,
>  						      listp);
> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index c7d1f9f..d190494 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -384,6 +384,7 @@ static int nilfs_move_2nd_super(struct super_block *sb, loff_t sb2off)
>  		ret = -EIO;
>  		goto out;
>  	}
> +	set_buffer_nilfs_allocated(nsbh);
>  	nsbp = (void *)nsbh->b_data + offset;
>  	memset(nsbp, 0, nilfs->ns_blocksize);
>  
> @@ -836,6 +837,7 @@ struct nilfs_super_block *nilfs_read_super_block(struct super_block *sb,
>  	*pbh = sb_bread(sb, sb_index);
>  	if (!*pbh)
>  		return NULL;
> +	set_buffer_nilfs_allocated(*pbh);
>  	return (struct nilfs_super_block *)((char *)(*pbh)->b_data + offset);
>  }
>  
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
