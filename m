From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH 1/2] nilfs2: add nilfs_sufile_trim_fs to trim clean segs
Date: Mon, 17 Feb 2014 10:06:56 +0100
Message-ID: <5301D130.9050000@gmx.net>
References: <cover.1392470644.git.andreas.rohner@gmx.net>	<cover.1392470644.git.andreas.rohner@gmx.net>	<02d463460388a9bdc1413aa4d6fdfa5a402b9452.1392470644.git.andreas.rohner@gmx.net> <20140217.120000.397306175.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140217.120000.397306175.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Ryusuke,

On 2014-02-17 04:00, Ryusuke Konishi wrote:
>> +int nilfs_sufile_trim_fs(struct inode *sufile, struct fstrim_range *range)
>> +{
>> +	struct the_nilfs *nilfs = sufile->i_sb->s_fs_info;
>> +	struct buffer_head *su_bh;
>> +	struct nilfs_segment_usage *su;
>> +	void *kaddr;
>> +	size_t susz = NILFS_MDT(sufile)->mi_entry_size;
>> +	ssize_t n;
>> +	sector_t seg_start, seg_end, start = 0, nblocks = 0;
>> +	u64 segnum, end, minlen, trimmed = 0;
>> +	int i, ret = 0;
>> +	unsigned long segusages_per_block;
>> +	unsigned int sects_per_block;
>> +
>> +	segusages_per_block = nilfs_sufile_segment_usages_per_block(sufile);
>> +	sects_per_block = (1 << nilfs->ns_blocksize_bits) /
>> +		bdev_logical_block_size(nilfs->ns_bdev);
>> +	segnum = nilfs_get_segnum_of_block(nilfs, range->start >>
>> +			nilfs->ns_blocksize_bits);
>> +	end = nilfs_get_segnum_of_block(nilfs, (range->start + range->len)
>> +			>> nilfs->ns_blocksize_bits);
>> +	minlen = range->minlen >> nilfs->ns_blocksize_bits;
>> +
>> +	if (minlen > nilfs->ns_blocks_per_segment ||
> 
> This check looks inappropriate.  If we set a lower limit for
> range->minlin, I think it should be the file system size (block device
> size).  For your information, the meaning of minlen is described as
> follows in the man page of fstrim command:
> 
>   Minimum contiguous free range to discard, in bytes. (This
>   value is internally rounded up to a multiple of the filesystem
>   block size).  Free ranges smaller than this will be ignored.
>   By increasing this value, the fstrim operation will complete
>   more quickly for filesystems with badly fragmented freespace,
>   although not all blocks will be discarded.  Default value is
>   zero, discard every free block.
> 
> So, too small lower limit interferes purpose of the minlen argument.

Agreed.

>> +	    segnum >= nilfs->ns_nsegments ||
> 
> This is bad too, because userland programs usually don't know the
> segment structure of NILFS.  When we specify the partition size to
> range->len, FITRIM can fail due to this check.
> 
> The upper limit of (range->start + range->len) should be
> the block device size.

ext4 also checks the range structure like that. Besides couldn't it be
possible, that the block device is bigger than the file system?

>> +	    range->len < nilfs->ns_blocksize)
> 
> This looks OK.
> 
>> +		return -EINVAL;
> 
> I think these EINVAL checks should be move to ioctl interface side
> because they should be performed in a perspective of general file
> system and shouldn't depend on the internal structure of NILFS so
> much.  If we need to adjust the range in this function, we should do
> it silently.

I just did it the same way as it is done in ext4.

>> +	if (end > nilfs->ns_nsegments)
>> +		end = nilfs->ns_nsegments;
> 
> Yes, this adjustment is what we should do here, but 'end' segnum was
> rounded down to segment alighment before.  So, it should be:
> 
>   if (end >= nilfs->ns_nsegments)
> 	end = nilfs->ns_nsegments - 1;
> 
>> +	if (end == segnum)
>> +		goto out;
> 
> and
> 
>   if (end < segnum)
> 	goto out;
> 
>> +
>> +	down_read(&NILFS_MDT(sufile)->mi_sem);
>> +
>> +	while (segnum < end) {
> 
> and
> 
>   while (segnum <= end) {
> 
>> +		n = min_t(unsigned long,
>> +			  segusages_per_block -
>> +				  nilfs_sufile_get_offset(sufile, segnum),
>> +			  end - segnum);
> 
> Then, we can reuse nilfs_sufile_segment_usages_in_block() to calculate
> 'n'.

Yes we can do this, if you want to use
nilfs_sufile_segment_usages_in_block(). I would just like to state, that
my code is also correct here.

> 
>> +		ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 0,
>> +							   &su_bh);
>> +		if (ret < 0) {
>> +			if (ret != -ENOENT)
>> +				goto out_sem;
>> +			/* hole */
>> +			segnum += n;
>> +			continue;
> 
> Skipping segments within segment usage blocks which are hole, are OK
> since they are never written after the previous mkfs and mkfs.nilfs2
> discards segments.
> 
> However, note that this also separates the extent defined with (start,
> nblocks).  So, (start, nblocks) should be updated and
> blkdev_issue_discard() should be called as needed.

As far as I can tell this is not necessary here. But I checked the
function again and I found a small bug further below.

>> +		}
>> +
>> +		kaddr = kmap(su_bh->b_page);
> 
> Avoid using kmap()/kunmap() (if possible), these are expensive for
> architectures nowadays which shares virtual address space among
> processors.  I think we can replace them with kmap_atomic() and
> kunmap_atomic() for this function by carefully releasing the highmem
> before calling blocking operations such as blkdev_issue_discard() and
> nilfs_sufile_get_segment_usage_block().

Ok. Yes that should be possible.

>> +		su = nilfs_sufile_block_get_segment_usage(
>> +			sufile, segnum, su_bh, kaddr);
>> +		for (i = 0; i < n; ++i, ++segnum, su = (void *)su + susz) {
>> +			if (!nilfs_segment_usage_clean(su))
>> +				continue;
>> +
>> +			nilfs_get_segment_range(nilfs, segnum, &seg_start,
>> +						&seg_end);
>> +
>> +			if (!nblocks) {
>> +				start = seg_start;
>> +				nblocks = seg_end - seg_start + 1;
>> +			} else if (start + nblocks == seg_start) {
>> +				nblocks += seg_end - seg_start + 1;
>> +			} else {
> 
> We should ignore the extent if the size is smaller than range->minlen.

Agreed.

>> +				ret = blkdev_issue_discard(nilfs->ns_bdev,
>> +						start * sects_per_block,
>> +						nblocks * sects_per_block,
>> +						GFP_NOFS, 0);
>> +				if (ret < 0) {
>> +					kunmap(kaddr);
>> +					put_bh(su_bh);
>> +					goto out_sem;
>> +				}
>> +
>> +				trimmed += nblocks;
>> +				nblocks = 0;

This should be:

+				start = seg_start;
+				nblocks = seg_end - seg_start + 1;


Regards,
Andreas Rohner

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
