From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v2 9/9] nilfs2: prevent starvation of segments
 protected by snapshots
Date: Thu, 21 May 2015 00:49:37 +0900 (JST)
Message-ID: <20150521.004937.1737206804262552497.konishi.ryusuke@lab.ntt.co.jp>
References: <1430647522-14304-1-git-send-email-andreas.rohner@gmx.net>
	<1430647522-14304-10-git-send-email-andreas.rohner@gmx.net>
	<20150520.234335.542615158366069430.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=2PwoGzIilJrOQPHWPcrMCWxQy685LrBufjjzDy5FbNQ=;
        b=WEEg6+VvcHGNMLUjn48WALxWCfqK+oq+4f76cRVj3fL83vwFI9iu1qetAmkaS+K1S+
         7lWdm/IydUXSE6/ybekD+YYKqdN8o9cElygLhjmVuS2HjSXIdNPWibXE7q4c+f6qogNf
         s0hbLJ0miG8ZUwXlJ1CS+aZSfgXekpTGf1WIXj42WJLxoJn9DNEwTqxxvW1GZj2oihyB
         3wXr6zb2uRv2yPcOR3iN0frUtgN1BnvDpYMotD8zYXzQ2ShOHPO37hijkUd7PhGdCSCS
         b0oXwZ9OhsaWhlhNGUFsDE+mA1UOXsO9QQ0AvcbNhzwz6SumA2pF6UOndA/5VaqSMCS3
         JBIg==
In-Reply-To: <20150520.234335.542615158366069430.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 20 May 2015 23:43:35 +0900 (JST), Ryusuke Konishi wrote:
> On Sun,  3 May 2015 12:05:22 +0200, Andreas Rohner wrote:
>> It doesn't really matter if the number of reclaimable blocks for a
>> segment is inaccurate, as long as the overall performance is better than
>> the simple timestamp algorithm and starvation is prevented.
>> 
>> The following steps will lead to starvation of a segment:
>> 
>> 1. The segment is written
>> 2. A snapshot is created
>> 3. The files in the segment are deleted and the number of live
>>    blocks for the segment is decremented to a very low value
>> 4. The GC tries to free the segment, but there are no reclaimable
>>    blocks, because they are all protected by the snapshot. To prevent an
>>    infinite loop the GC has to adjust the number of live blocks to the
>>    correct value.
>> 5. The snapshot is converted to a checkpoint and the blocks in the
>>    segment are now reclaimable.
>> 6. The GC will never attempt to clean the segment again, because it
>>    looks as if it had a high number of live blocks.
>> 
>> To prevent this, the already existing padding field of the SUFILE entry
>> is used to track the number of snapshot blocks in the segment. This
>> number is only set by the GC, since it collects the necessary
>> information anyway. So there is no need, to track which block belongs to
>> which segment. In step 4 of the list above the GC will set the new field
>> su_nsnapshot_blks. In step 5 all entries in the SUFILE are checked and
>> entries with a big su_nsnapshot_blks field get their su_nlive_blks field
>> reduced.
>> 
>> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
> 
> I still don't know whether this workaround is the way we should take
> or not.  This patch has several drawbacks:
> 
>  1. It introduces overheads to every "chcp cp" operation
>     due to traversal rewrite of sufile.
>     If the ratio of snapshot protected blocks is high, then
>     this overheads will be big.
> 
>  2. The traversal rewrite of sufile will causes many sufile blocks will be
>     written out.   If most blocks are protected by a snapshot,
>     more than 4MB of sufile blocks will be written per 1TB capacity.
> 
>     Even though this rewrite may not happen for contiguous "chcp cp"
>     operations, it still has potential for creating sufile write blocks
>     if the application of nilfs manipulates snapshots frequently.
> 
>  3. The ratio of the threshold "max_segblks" is hard coded to 50%
>     of blocks_per_segment.  It is not clear if the ratio is good
>     (versatile).
> 
> I will add comments inline below.
> 
>> ---
>>  fs/nilfs2/ioctl.c  | 50 +++++++++++++++++++++++++++++++-
>>  fs/nilfs2/sufile.c | 85 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  fs/nilfs2/sufile.h |  3 ++
>>  3 files changed, 137 insertions(+), 1 deletion(-)
>> 
>> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
>> index 40bf74a..431725f 100644
>> --- a/fs/nilfs2/ioctl.c
>> +++ b/fs/nilfs2/ioctl.c
>> @@ -200,6 +200,49 @@ static int nilfs_ioctl_getversion(struct inode *inode, void __user *argp)
>>  }
>>  
>>  /**
>> + * nilfs_ioctl_fix_starving_segs - fix potentially starving segments
>> + * @nilfs: nilfs object
>> + * @inode: inode object
>> + *
>> + * Description: Scans for segments, which are potentially starving and
>> + * reduces the number of live blocks to less than half of the maximum
>> + * number of blocks in a segment. This requires a scan of the whole SUFILE,
>> + * which can take a long time on certain devices and under certain conditions.
>> + * To avoid blocking other file system operations for too long the SUFILE is
>> + * scanned in steps of NILFS_SUFILE_STARVING_SEGS_STEP. After each step the
>> + * locks are released and cond_resched() is called.
>> + *
>> + * Return Value: On success, 0 is returned and on error, one of the
>> + * following negative error codes is returned.
>> + *
>> + * %-EIO - I/O error.
>> + *
>> + * %-ENOMEM - Insufficient amount of memory available.
>> + */
> 
>> +static int nilfs_ioctl_fix_starving_segs(struct the_nilfs *nilfs,
>> +					 struct inode *inode) {
> 
> This "inode" argument is meaningless for this routine.
> Consider passing "sb" instead.
> 
> I feel odd for the function name "fix starving segs".  It looks to
> give a workaround rather than solve the root problem of gc in nilfs.
> It looks like what this patch is doing, is "calibrating" live block
> count.
> 
>> +	struct nilfs_transaction_info ti;
> 
>> +	unsigned long i, nsegs = nilfs_sufile_get_nsegments(nilfs->ns_sufile);
> 
> nsegs is set outside the transaction lock.
> 
> Since the file system can be resized (both shrinked or extended)
> outside the lock, nsegs must be initialized or updated in the
> section where the tranaction lock is held.
> 
>> +	int ret = 0;
>> +
>> +	for (i = 0; i < nsegs; i += NILFS_SUFILE_STARVING_SEGS_STEP) {
>> +		nilfs_transaction_begin(inode->i_sb, &ti, 0);
>> +
>> +		ret = nilfs_sufile_fix_starving_segs(nilfs->ns_sufile, i,
>> +				NILFS_SUFILE_STARVING_SEGS_STEP);
>> +		if (unlikely(ret < 0)) {
>> +			nilfs_transaction_abort(inode->i_sb);
>> +			break;
>> +		}
>> +
>> +		nilfs_transaction_commit(inode->i_sb); /* never fails */
>> +		cond_resched();
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +/**
>>   * nilfs_ioctl_change_cpmode - change checkpoint mode (checkpoint/snapshot)
>>   * @inode: inode object
>>   * @filp: file object
>> @@ -224,7 +267,7 @@ static int nilfs_ioctl_change_cpmode(struct inode *inode, struct file *filp,
>>  	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
>>  	struct nilfs_transaction_info ti;
>>  	struct nilfs_cpmode cpmode;
>> -	int ret;
>> +	int ret, is_snapshot;
>>  
>>  	if (!capable(CAP_SYS_ADMIN))
>>  		return -EPERM;
>> @@ -240,6 +283,7 @@ static int nilfs_ioctl_change_cpmode(struct inode *inode, struct file *filp,
>>  	mutex_lock(&nilfs->ns_snapshot_mount_mutex);
>>  
>>  	nilfs_transaction_begin(inode->i_sb, &ti, 0);
>> +	is_snapshot = nilfs_cpfile_is_snapshot(nilfs->ns_cpfile, cpmode.cm_cno);
>>  	ret = nilfs_cpfile_change_cpmode(
>>  		nilfs->ns_cpfile, cpmode.cm_cno, cpmode.cm_mode);
>>  	if (unlikely(ret < 0))
>> @@ -248,6 +292,10 @@ static int nilfs_ioctl_change_cpmode(struct inode *inode, struct file *filp,
>>  		nilfs_transaction_commit(inode->i_sb); /* never fails */
>>  
>>  	mutex_unlock(&nilfs->ns_snapshot_mount_mutex);
>> +
> 
>> +	if (is_snapshot > 0 && cpmode.cm_mode == NILFS_CHECKPOINT &&
>> +			nilfs_feature_track_live_blks(nilfs))
>> +		ret = nilfs_ioctl_fix_starving_segs(nilfs, inode);
> 
> Should we use this return value ?
> This doesn't relate to the success and failure of "chcp" operation.
> 
> nilfs_ioctl_fix_starving_segs() is called every time "chcp cp" is
> called.  I prefer to delay this extra work with a workqueue and to
> skip starting a new work if the previous work is still running.
> 
>>  out:
>>  	mnt_drop_write_file(filp);
>>  	return ret;
>> diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
>> index 9cd8820d..47e2c05 100644
>> --- a/fs/nilfs2/sufile.c
>> +++ b/fs/nilfs2/sufile.c
>> @@ -1215,6 +1215,91 @@ out_sem:
>>  }
>>  
>>  /**
>> + * nilfs_sufile_fix_starving_segs - fix potentially starving segments
>> + * @sufile: inode of segment usage file
>> + * @segnum: segnum to start
>> + * @nsegs: number of segments to check
>> + *
>> + * Description: Scans for segments, which are potentially starving and
>> + * reduces the number of live blocks to less than half of the maximum
>> + * number of blocks in a segment. This way the segment is more likely to be
>> + * chosen by the GC. A segment is marked as potentially starving, if more
>> + * than half of the blocks it contains are protected by snapshots.
>> + *
>> + * Return Value: On success, 0 is returned and on error, one of the
>> + * following negative error codes is returned.
>> + *
>> + * %-EIO - I/O error.
>> + *
>> + * %-ENOMEM - Insufficient amount of memory available.
>> + */
>> +int nilfs_sufile_fix_starving_segs(struct inode *sufile, __u64 segnum,
>> +				   __u64 nsegs)
>> +{
>> +	struct buffer_head *su_bh;
>> +	struct nilfs_segment_usage *su;
>> +	size_t n, i, susz = NILFS_MDT(sufile)->mi_entry_size;
>> +	struct the_nilfs *nilfs = sufile->i_sb->s_fs_info;
>> +	void *kaddr;
>> +	unsigned long maxnsegs, segusages_per_block;
>> +	__u32 max_segblks = nilfs->ns_blocks_per_segment >> 1;
>> +	int ret = 0, blkdirty, dirty = 0;
>> +
>> +	down_write(&NILFS_MDT(sufile)->mi_sem);
>> +
> 
>> +	maxnsegs = nilfs_sufile_get_nsegments(sufile);
>> +	segusages_per_block = nilfs_sufile_segment_usages_per_block(sufile);
>> +	nsegs += segnum;
>> +	if (nsegs > maxnsegs)
>> +		nsegs = maxnsegs;
>> +
>> +	while (segnum < nsegs) {
> 
> This local variable "nsegs" is used as an (exclusive) end segment number.
> It's confusing.   You should define "end" variable separately.
> It can be simply calculated by:
> 
>     end = min_t(__u64, segnum + nsegs, nilfs_sufile_get_nsegments(sufile));
> 
> ("maxnsegs" can be removed.)
> 
> Note that the evaluation of each argument will never be done twice in
> min_t() macro since min_t() temporarily stores the evaluation results
> to hidden local variables and uses them for comparison.
> 
> Regards,
> Ryusuke Konishi
> 
> 
>> +		n = nilfs_sufile_segment_usages_in_block(sufile, segnum,
>> +							 nsegs - 1);
>> +
>> +		ret = nilfs_sufile_get_segment_usage_block(sufile, segnum,
>> +							   0, &su_bh);
>> +		if (ret < 0) {
>> +			if (ret != -ENOENT)
>> +				goto out;
>> +			/* hole */
>> +			segnum += n;
>> +			continue;
>> +		}
>> +
>> +		kaddr = kmap_atomic(su_bh->b_page);
>> +		su = nilfs_sufile_block_get_segment_usage(sufile, segnum,
>> +							  su_bh, kaddr);
>> +		blkdirty = 0;
>> +		for (i = 0; i < n; ++i, ++segnum, su = (void *)su + susz) {

I forgot a few comments.

If the segment is not dirty then skip it first for safety.

>> +			if (le32_to_cpu(su->su_nsnapshot_blks) <= max_segblks)
>> +				continue;
>> +			if (le32_to_cpu(su->su_nlive_blks) <= max_segblks)
>> +				continue;

The variable name "max_segblks" is not intuitive.  It gives a
threshold of live block count to make the segment reclaimable or to
calibrate live block counts.  Some sort of word having this nuance is
preferable.

>> +
>> +			su->su_nlive_blks = cpu_to_le32(max_segblks);
>> +			su->su_nsnapshot_blks = cpu_to_le32(max_segblks);

Live block counts are changed, but "su_nlive_lastmod" is not changed.


Regards,
Ryusuke Konishi

>> +			blkdirty = 1;
>> +		}
>> +
>> +		kunmap_atomic(kaddr);
>> +		if (blkdirty) {
>> +			mark_buffer_dirty(su_bh);
>> +			dirty = 1;
>> +		}
>> +		put_bh(su_bh);
>> +		cond_resched();
>> +	}
>> +
>> +out:
>> +	if (dirty)
>> +		nilfs_mdt_mark_dirty(sufile);
>> +
>> +	up_write(&NILFS_MDT(sufile)->mi_sem);
>> +	return ret;
>> +}
>> +
>> +/**
>>   * nilfs_sufile_alloc_cache_node - allocate and insert a new cache node
>>   * @sufile: inode of segment usage file
>>   * @group: group to allocate a node for
>> diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
>> index 3466abb..f11e3e6 100644
>> --- a/fs/nilfs2/sufile.h
>> +++ b/fs/nilfs2/sufile.h
>> @@ -30,6 +30,7 @@
>>  
>>  #define NILFS_SUFILE_CACHE_NODE_SHIFT	6
>>  #define NILFS_SUFILE_CACHE_NODE_COUNT	(1 << NILFS_SUFILE_CACHE_NODE_SHIFT)
>> +#define NILFS_SUFILE_STARVING_SEGS_STEP (1 << 15)
>>  
>>  struct nilfs_sufile_cache_node {
>>  	__u32 values[NILFS_SUFILE_CACHE_NODE_COUNT];
>> @@ -88,6 +89,8 @@ int nilfs_sufile_resize(struct inode *sufile, __u64 newnsegs);
>>  int nilfs_sufile_read(struct super_block *sb, size_t susize,
>>  		      struct nilfs_inode *raw_inode, struct inode **inodep);
>>  int nilfs_sufile_trim_fs(struct inode *sufile, struct fstrim_range *range);
>> +int nilfs_sufile_fix_starving_segs(struct inode *sufile, __u64 segnum,
>> +				   __u64 nsegs);
>>  int nilfs_sufile_dec_nlive_blks(struct inode *sufile, __u64 segnum);
>>  void nilfs_sufile_shrink_cache(struct inode *sufile);
>>  int nilfs_sufile_flush_cache(struct inode *sufile, int only_mark,
>> -- 
>> 2.3.7
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
