From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH 1/2] nilfs2: add nilfs_sufile_trim_fs to trim clean segs
Date: Mon, 17 Feb 2014 12:00:00 +0900 (JST)
Message-ID: <20140217.120000.397306175.konishi.ryusuke@lab.ntt.co.jp>
References: <cover.1392470644.git.andreas.rohner@gmx.net>
	<cover.1392470644.git.andreas.rohner@gmx.net>
	<02d463460388a9bdc1413aa4d6fdfa5a402b9452.1392470644.git.andreas.rohner@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <02d463460388a9bdc1413aa4d6fdfa5a402b9452.1392470644.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Andreas,
On Sat, 15 Feb 2014 14:34:25 +0100, Andreas Rohner wrote:
> This patch adds the nilfs_sufile_trim_fs function, which takes a
> fstrim_range structure and calls blkdev_issue_discard for every
> clean segment in the specified range.
> 
> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

Thank you for doing this work.
I'll add comments inline below.

> ---
>  fs/nilfs2/sufile.c | 114 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/nilfs2/sufile.h |   1 +
>  2 files changed, 115 insertions(+)
> 
> diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
> index 3127e9f..022b17f 100644
> --- a/fs/nilfs2/sufile.c
> +++ b/fs/nilfs2/sufile.c
> @@ -870,6 +870,120 @@ ssize_t nilfs_sufile_get_suinfo(struct inode *sufile, __u64 segnum, void *buf,
>  }
>  
>  /**
> + * nilfs_sufile_trim_fs() - trim ioctl handle function
> + * @sufile: inode of segment usage file
> + * @range: fstrim_range structure
> + *
> + * start:	First Byte to trim
> + * len:		number of Bytes to trim from start
> + * minlen:	minimum extent length in Bytes
> + *
> + * Decription: nilfs_sufile_trim_fs goes through all segments containing bytes
> + * from start to start+len. For each clean segment blkdev_issue_discard
> + * function is invoked to trim it.
> + *
> + * Return Value: On success, 0 is returned or negative error code, otherwise.
> + */
> +int nilfs_sufile_trim_fs(struct inode *sufile, struct fstrim_range *range)
> +{
> +	struct the_nilfs *nilfs = sufile->i_sb->s_fs_info;
> +	struct buffer_head *su_bh;
> +	struct nilfs_segment_usage *su;
> +	void *kaddr;
> +	size_t susz = NILFS_MDT(sufile)->mi_entry_size;
> +	ssize_t n;
> +	sector_t seg_start, seg_end, start = 0, nblocks = 0;
> +	u64 segnum, end, minlen, trimmed = 0;
> +	int i, ret = 0;
> +	unsigned long segusages_per_block;
> +	unsigned int sects_per_block;
> +
> +	segusages_per_block = nilfs_sufile_segment_usages_per_block(sufile);
> +	sects_per_block = (1 << nilfs->ns_blocksize_bits) /
> +		bdev_logical_block_size(nilfs->ns_bdev);
> +	segnum = nilfs_get_segnum_of_block(nilfs, range->start >>
> +			nilfs->ns_blocksize_bits);
> +	end = nilfs_get_segnum_of_block(nilfs, (range->start + range->len)
> +			>> nilfs->ns_blocksize_bits);
> +	minlen = range->minlen >> nilfs->ns_blocksize_bits;
> +
> +	if (minlen > nilfs->ns_blocks_per_segment ||

This check looks inappropriate.  If we set a lower limit for
range->minlin, I think it should be the file system size (block device
size).  For your information, the meaning of minlen is described as
follows in the man page of fstrim command:

  Minimum contiguous free range to discard, in bytes. (This
  value is internally rounded up to a multiple of the filesystem
  block size).  Free ranges smaller than this will be ignored.
  By increasing this value, the fstrim operation will complete
  more quickly for filesystems with badly fragmented freespace,
  although not all blocks will be discarded.  Default value is
  zero, discard every free block.

So, too small lower limit interferes purpose of the minlen argument.

> +	    segnum >= nilfs->ns_nsegments ||

This is bad too, because userland programs usually don't know the
segment structure of NILFS.  When we specify the partition size to
range->len, FITRIM can fail due to this check.

The upper limit of (range->start + range->len) should be
the block device size.

> +	    range->len < nilfs->ns_blocksize)

This looks OK.

> +		return -EINVAL;

I think these EINVAL checks should be move to ioctl interface side
because they should be performed in a perspective of general file
system and shouldn't depend on the internal structure of NILFS so
much.  If we need to adjust the range in this function, we should do
it silently.

> +	if (end > nilfs->ns_nsegments)
> +		end = nilfs->ns_nsegments;

Yes, this adjustment is what we should do here, but 'end' segnum was
rounded down to segment alighment before.  So, it should be:

  if (end >= nilfs->ns_nsegments)
	end = nilfs->ns_nsegments - 1;

> +	if (end == segnum)
> +		goto out;

and

  if (end < segnum)
	goto out;

> +
> +	down_read(&NILFS_MDT(sufile)->mi_sem);
> +
> +	while (segnum < end) {

and

  while (segnum <= end) {

> +		n = min_t(unsigned long,
> +			  segusages_per_block -
> +				  nilfs_sufile_get_offset(sufile, segnum),
> +			  end - segnum);

Then, we can reuse nilfs_sufile_segment_usages_in_block() to calculate
'n'.

> +		ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 0,
> +							   &su_bh);
> +		if (ret < 0) {
> +			if (ret != -ENOENT)
> +				goto out_sem;
> +			/* hole */
> +			segnum += n;
> +			continue;

Skipping segments within segment usage blocks which are hole, are OK
since they are never written after the previous mkfs and mkfs.nilfs2
discards segments.

However, note that this also separates the extent defined with (start,
nblocks).  So, (start, nblocks) should be updated and
blkdev_issue_discard() should be called as needed.

> +		}
> +
> +		kaddr = kmap(su_bh->b_page);

Avoid using kmap()/kunmap() (if possible), these are expensive for
architectures nowadays which shares virtual address space among
processors.  I think we can replace them with kmap_atomic() and
kunmap_atomic() for this function by carefully releasing the highmem
before calling blocking operations such as blkdev_issue_discard() and
nilfs_sufile_get_segment_usage_block().

> +		su = nilfs_sufile_block_get_segment_usage(
> +			sufile, segnum, su_bh, kaddr);
> +		for (i = 0; i < n; ++i, ++segnum, su = (void *)su + susz) {
> +			if (!nilfs_segment_usage_clean(su))
> +				continue;
> +
> +			nilfs_get_segment_range(nilfs, segnum, &seg_start,
> +						&seg_end);
> +
> +			if (!nblocks) {
> +				start = seg_start;
> +				nblocks = seg_end - seg_start + 1;
> +			} else if (start + nblocks == seg_start) {
> +				nblocks += seg_end - seg_start + 1;
> +			} else {

We should ignore the extent if the size is smaller than range->minlen.


> +				ret = blkdev_issue_discard(nilfs->ns_bdev,
> +						start * sects_per_block,
> +						nblocks * sects_per_block,
> +						GFP_NOFS, 0);
> +				if (ret < 0) {
> +					kunmap(kaddr);
> +					put_bh(su_bh);
> +					goto out_sem;
> +				}
> +
> +				trimmed += nblocks;
> +				nblocks = 0;
> +			}
> +		}
> +		kunmap(kaddr);
> +		put_bh(su_bh);
> +	}
> +
> +	if (nblocks) {
> +		ret = blkdev_issue_discard(nilfs->ns_bdev,
> +					   start * sects_per_block,
> +					   nblocks * sects_per_block,
> +					   GFP_NOFS, 0);
> +		if (!ret)
> +			trimmed += nblocks;
> +	}
> +
> +out_sem:
> +	up_read(&NILFS_MDT(sufile)->mi_sem);
> +out:
> +	range->len = trimmed << nilfs->ns_blocksize_bits;
> +	return ret;
> +}
> +
> +/**
>   * nilfs_sufile_read - read or get sufile inode
>   * @sb: super block instance
>   * @susize: size of a segment usage entry
> diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
> index e84bc5b..2434abd 100644
> --- a/fs/nilfs2/sufile.h
> +++ b/fs/nilfs2/sufile.h
> @@ -65,6 +65,7 @@ void nilfs_sufile_do_set_error(struct inode *, __u64, struct buffer_head *,
>  int nilfs_sufile_resize(struct inode *sufile, __u64 newnsegs);
>  int nilfs_sufile_read(struct super_block *sb, size_t susize,
>  		      struct nilfs_inode *raw_inode, struct inode **inodep);
> +int nilfs_sufile_trim_fs(struct inode *sufile, struct fstrim_range *range);
>  
>  /**
>   * nilfs_sufile_scrap - make a segment garbage
> -- 
> 1.8.5.4
> 

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
