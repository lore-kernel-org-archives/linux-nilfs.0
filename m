From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH 1/2] nilfs2: add nilfs_sufile_trim_fs to trim clean segs
Date: Wed, 19 Feb 2014 07:36:58 +0100
Message-ID: <5304510A.8080006@gmx.net>
References: <cover.1392676472.git.andreas.rohner@gmx.net>	<cover.1392676472.git.andreas.rohner@gmx.net>	<0ba40f9a0504b2a228e0714032f82556e03b927e.1392676472.git.andreas.rohner@gmx.net> <20140219.033733.321498615.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140219.033733.321498615.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014-02-18 19:37, Ryusuke Konishi wrote:
> On Mon, 17 Feb 2014 23:39:51 +0100, Andreas Rohner wrote:
>> This patch adds the nilfs_sufile_trim_fs function, which takes a
>> fstrim_range structure and calls blkdev_issue_discard for every
>> clean segment in the specified range. The range is truncated to sector
>> boundaries.
>>
>> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
>> ---
>>  fs/nilfs2/sufile.c | 144 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  fs/nilfs2/sufile.h |   1 +
>>  2 files changed, 145 insertions(+)
>>
>> diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
>> index 3127e9f..3605cc9 100644
>> --- a/fs/nilfs2/sufile.c
>> +++ b/fs/nilfs2/sufile.c
>> @@ -870,6 +870,150 @@ ssize_t nilfs_sufile_get_suinfo(struct inode *sufile, __u64 segnum, void *buf,
>>  }
>>  
>>  /**
>> + * nilfs_sufile_trim_fs() - trim ioctl handle function
>> + * @sufile: inode of segment usage file
>> + * @range: fstrim_range structure
>> + *
>> + * start:	First Byte to trim
>> + * len:		number of Bytes to trim from start
>> + * minlen:	minimum extent length in Bytes
>> + *
>> + * Decription: nilfs_sufile_trim_fs goes through all segments containing bytes
>> + * from start to start+len. start is rounded up to the next sector boundary
>> + * and start+len is rounded down. For each clean segment blkdev_issue_discard
>> + * function is invoked to trim it.
>> + *
>> + * Return Value: On success, 0 is returned or negative error code, otherwise.
>> + */
>> +int nilfs_sufile_trim_fs(struct inode *sufile, struct fstrim_range *range)
>> +{
>> +	struct the_nilfs *nilfs = sufile->i_sb->s_fs_info;
>> +	struct buffer_head *su_bh;
>> +	struct nilfs_segment_usage *su;
>> +	void *kaddr;
>> +	size_t n, i, susz = NILFS_MDT(sufile)->mi_entry_size;
>> +	sector_t seg_start, seg_end, real_start, real_end,
>> +				start = 0, nblocks = 0;
>> +	u64 segnum, end, minlen, trimmed = 0;
>> +	int ret = 0;
>> +	unsigned int sect_size, sects_per_block;
>> +
>> +	sect_size = bdev_logical_block_size(nilfs->ns_bdev);
>> +	sects_per_block = (1 << nilfs->ns_blocksize_bits) / sect_size;
> 
>> +	real_start = (range->start + sect_size - 1) / sect_size;
>> +	real_end = (range->start + range->len) / sect_size;
> 
> Why not use start_sect, end_sect instead of real_start, real_end?
> real_{start,end} are not intuitive to me.

Yes that looks better.

> We need to use do_div() for these divisions, and DIV_ROUND_UP_ULL()
> macro should be applied to round up the start sector.
> 
> Moreover, we have to avoid overflow in "range->start + range->len".
> Actually, range->len is usually set to UULONG_MAX.

Ah yes I forgot to test that case.

> So, these will be as follows:
> 
> 	u64 len = range->len;
> 
> 	...
> 
> 	do_div(len, sect_size);
> 	if (!len)
> 		goto out;
> 
> 	...
> 	start_sect = DIV_ROUND_UP_ULL(range->start, sect_size);
> 	end_sect = start_sect + len - 1;  /* this end_sect is inclusive */

I don't get why this has to be inclusive. To me this seems to be a
matter of taste. I think it is much easier to reason about this stuff
and more "natural", if start_sect is inclusive and end_sect is
exclusive. Then segnum is inclusive and end is exclusive. It is just
like with pointer arithmetic.

> Note that, we also should care about large range->start to avoid
> overflow in substitution to start_sect (sector_t) since sector_t may
> be 32-bit.  We should check it before the division.
> 
> Here, I recant my earlier comment.  We should do the following check
> in this function to clarify that the overflow issue is handled
> properly.

Ok.

> 	u64 max_byte =
> 		((u64)nilfs->ns_nsegments * nilfs->ns_blocks_per_segments)
> 			<< nilfs->ns_blocksize_bits;
> 
> 	...
> 	if (range.len < nilfs->ns_blocksize || range.start >= max_byte)
> 		return -EINVAL;
> 	...
> 	(divisions)
> 
>> +	segnum = nilfs_get_segnum_of_block(nilfs, real_start / sects_per_block);
>> +	end = nilfs_get_segnum_of_block(nilfs, ((real_end + sects_per_block - 1)
>> +			/ sects_per_block) + nilfs->ns_blocks_per_segment - 1);
> 
> It would be better to use the following intermediate variables to
> improve readability of these calculations.

Ok.

> And, these calculations need sector_div() and DIV_ROUND_UP_SECTOR_T()
> macro:
> 
> 	start_block = start_sect;
> 	sector_div(start_block, sects_per_block);
> 
> 	end_block = DIV_ROUND_UP_SECTOR_T(end_sect, sects_per_block);
> 
> 	segnum = nilfs_get_segnum_of_block(nilfs, start_block);
> 	end = nilfs_get_segnum_of_block(
> 			nilfs, end_block + nilfs->ns_blocks_per_segment - 1);
> 
>> +	minlen = range->minlen / sect_size;
> 
> And, this one needs do_div():
> 
> 	minlen = range->minlen;
> 	do_div(minlen, sect_size);
> 
>> +
>> +
>> +	if (end > nilfs->ns_nsegments)
>> +		end = nilfs->ns_nsegments;
>> +	if (segnum >= nilfs->ns_nsegments || end <= segnum)
>> +		goto out;
>> +
>> +	down_read(&NILFS_MDT(sufile)->mi_sem);
>> +
>> +	while (segnum < end) {
>> +		n = nilfs_sufile_segment_usages_in_block(sufile, segnum,
>> +				end - 1);
>> +
>> +		ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 0,
>> +							   &su_bh);
>> +		if (ret < 0) {
>> +			if (ret != -ENOENT)
>> +				goto out_sem;
>> +			/* hole */
>> +			segnum += n;
>> +			continue;
>> +		}
>> +
>> +		kaddr = kmap_atomic(su_bh->b_page);
>> +		su = nilfs_sufile_block_get_segment_usage(sufile, segnum,
>> +				su_bh, kaddr);
>> +		for (i = 0; i < n; ++i, ++segnum, su = (void *)su + susz) {
>> +			if (!nilfs_segment_usage_clean(su))
>> +				continue;
>> +
>> +			nilfs_get_segment_range(nilfs, segnum, &seg_start,
>> +						&seg_end);
>> +
>> +			if (!nblocks) {
>> +				/* start new extent */
>> +				start = seg_start;
>> +				nblocks = seg_end - seg_start + 1;
>> +				continue;
>> +			}
>> +
>> +			if (start + nblocks == seg_start) {
>> +				/* add to previous extent */
>> +				nblocks += seg_end - seg_start + 1;
>> +				continue;
>> +			}
>> +
>> +			/* discard previous extent */
>> +			start *= sects_per_block;
>> +			nblocks *= sects_per_block;
>> +			if (start < real_start) {
>> +				nblocks -= real_start - start;
>> +				start = real_start;
>> +			}
> 
>> +			if (start + nblocks > real_end)
>> +				nblocks = real_end - start;
> 
> Why do you need this adjustment during discarding "previous" extent ?

You are right I don't need it.

>> +			if (nblocks >= minlen) {
>> +				kunmap_atomic(kaddr);
>> +
>> +				ret = blkdev_issue_discard(nilfs->ns_bdev,
>> +						start, nblocks, GFP_NOFS, 0);
>> +				if (ret < 0) {
>> +					put_bh(su_bh);
>> +					goto out_sem;
>> +				}
>> +
>> +				trimmed += nblocks;
>> +				kaddr = kmap_atomic(su_bh->b_page);
>> +				su = nilfs_sufile_block_get_segment_usage(
>> +					sufile, segnum, su_bh, kaddr);
>> +			}
>> +
>> +			/* start new extent */
>> +			start = seg_start;
>> +			nblocks = seg_end - seg_start + 1;
>> +		}
>> +		kunmap_atomic(kaddr);
>> +		put_bh(su_bh);
>> +	}
>> +
>> +
>> +	if (nblocks) {
>> +		/* discard last extent */
>> +		start *= sects_per_block;
>> +		nblocks *= sects_per_block;
>> +		if (start < real_start) {
>> +			nblocks -= real_start - start;
>> +			start = real_start;
>> +		}
>> +		if (start + nblocks > real_end)
>> +			nblocks = real_end - start;
>> +
>> +		if (nblocks >= minlen) {
>> +			ret = blkdev_issue_discard(nilfs->ns_bdev, start,
>> +					nblocks, GFP_NOFS, 0);
>> +			if (!ret)
>> +				trimmed += nblocks;
>> +		}
>> +	}
>> +
>> +out_sem:
>> +	up_read(&NILFS_MDT(sufile)->mi_sem);
>> +out:
>> +	range->len = trimmed * sect_size;
>> +	return ret;
>> +}
>> +
>> +/**
>>   * nilfs_sufile_read - read or get sufile inode
>>   * @sb: super block instance
>>   * @susize: size of a segment usage entry
>> diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
>> index e84bc5b..2434abd 100644
>> --- a/fs/nilfs2/sufile.h
>> +++ b/fs/nilfs2/sufile.h
>> @@ -65,6 +65,7 @@ void nilfs_sufile_do_set_error(struct inode *, __u64, struct buffer_head *,
>>  int nilfs_sufile_resize(struct inode *sufile, __u64 newnsegs);
>>  int nilfs_sufile_read(struct super_block *sb, size_t susize,
>>  		      struct nilfs_inode *raw_inode, struct inode **inodep);
>> +int nilfs_sufile_trim_fs(struct inode *sufile, struct fstrim_range *range);
>>  
>>  /**
>>   * nilfs_sufile_scrap - make a segment garbage
>> -- 
>> 1.9.0
> 
> Please try to compile this patch both for 32-bit kernel and 64-bit
> kernel to test if the patch is architecture independent.

Ok.

With all the proper division macros it gets very complicated. I think it
would simplify things if we just truncate to block size instead of
sector size. Then we could use simple bit shifts. It would look
something like this:

	if (range->len < nilfs->ns_blocksize ||
			range->start >= max_byte)
		return -EINVAL;
	/* sector_t could be 32 bit */
	if (range->len > max_byte)
		range->len = max_byte;

	sects_per_block = (1 << nilfs->ns_blocksize_bits) /
			bdev_logical_block_size(nilfs->ns_bdev);

	start_block = (range->start + nilfs->ns_blocksize - 1) >>
			nilfs->ns_blocksize_bits;
	end_block = start_block + (range->len >>
				nilfs->ns_blocksize_bits);

	segnum = nilfs_get_segnum_of_block(nilfs, start_block);
	end = nilfs_get_segnum_of_block(nilfs, end_block +
			nilfs->ns_blocks_per_segment - 1);

	minlen = range->minlen >> nilfs->ns_blocksize_bits;


What do you think?

Regards,
Andreas Rohner
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
