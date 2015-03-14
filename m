From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH 9/9] nilfs2: prevent starvation of segments protected
 by snapshots
Date: Sat, 14 Mar 2015 23:32:10 +0900 (JST)
Message-ID: <20150314.233210.974163895269325170.konishi.ryusuke@lab.ntt.co.jp>
References: <1424804504-10914-1-git-send-email-andreas.rohner@gmx.net>
	<1424804504-10914-10-git-send-email-andreas.rohner@gmx.net>
	<20150314.125109.1017248837083480553.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=ELh8AR9WRQUiGZNpK/ObKE4QIDnRRth49uIiKlXDMbc=;
        b=bZKSagq5/TpUI2wjmLe022QOWsVxQ9RzOOQuAWPLbFLyFxcNCiUzdKnv1BIVOyMV6B
         Ldvjn4KUtT3J3RJVBZeLhvpoSEV+bgrq22Y25bRnXFyhmrA/2s32x1rAfUiPwFf5wiUq
         M4ofo4A5eyu9WQ33zcr71LJT8sh4h/8tL+wNiv9uCD5QD5l4eTuLLxdH+YCCv1Co10wt
         VlFba5em8V1VmdPL/Lwi80DpkAcvd9edbtUXt0DuNXOhv5eWK0e6gDfBkoh7uXGymwWY
         f6Lru3V6OTetdj9toHT9TP2KCntoG0+SxNHB5kdZzRNSa4EHcO1oZJgizv6CUTxuEC2w
         LGEw==
In-Reply-To: <20150314.125109.1017248837083480553.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


One more comment.

On Sat, 14 Mar 2015 12:51:09 +0900 (JST), Ryusuke Konishi wrote:
> On Tue, 24 Feb 2015 20:01:44 +0100, Andreas Rohner wrote:
>> @@ -1050,6 +1069,85 @@ ssize_t nilfs_sufile_set_suinfo(struct inode *sufile, void *buf,
>>  }
>>  
>>  /**
>> + * nilfs_sufile_fix_starving_segs - fix potentially starving segments
>> + * @sufile: inode of segment usage file
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
>> +int nilfs_sufile_fix_starving_segs(struct inode *sufile)
>> +{
>> +	struct buffer_head *su_bh;
>> +	struct nilfs_segment_usage *su;
>> +	size_t n, i, susz = NILFS_MDT(sufile)->mi_entry_size;
>> +	struct the_nilfs *nilfs = sufile->i_sb->s_fs_info;
>> +	void *kaddr;
>> +	unsigned long nsegs, segusages_per_block;
>> +	__u32 max_segblks = nilfs->ns_blocks_per_segment / 2;
>> +	__u64 segnum = 0;
>> +	int ret = 0, blkdirty, dirty = 0;
>> +
>> +	down_write(&NILFS_MDT(sufile)->mi_sem);
>> +
>> +	segusages_per_block = nilfs_sufile_segment_usages_per_block(sufile);
>> +	nsegs = nilfs_sufile_get_nsegments(sufile);
>> +
>> +	while (segnum < nsegs) {
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
>> +			if (le32_to_cpu(su->su_nsnapshot_blks) <= max_segblks)
>> +				continue;
>> +
>> +			if (su->su_nlive_blks <= max_segblks)
>> +				continue;
>> +
>> +			su->su_nlive_blks = max_segblks;
>> +			blkdirty = 1;
>> +		}
>> +
>> +		kunmap_atomic(kaddr);
>> +		if (blkdirty) {
>> +			mark_buffer_dirty(su_bh);
>> +			dirty = 1;
>> +		}
>> +		put_bh(su_bh);

Insert cond_resched() here to mitigate latency issue (mainly for the
environment in which voluntary preemption is turned off).

Regards,
Ryusuke Konishi

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
>>   * nilfs_sufile_trim_fs() - trim ioctl handle function
>>   * @sufile: inode of segment usage file
>>   * @range: fstrim_range structure
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
