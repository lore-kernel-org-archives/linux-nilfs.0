From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v2 8/9] nilfs2: correct live block tracking for GC
 protection period
Date: Mon, 11 May 2015 11:07:26 +0900 (JST)
Message-ID: <20150511.110726.725667075147435663.konishi.ryusuke@lab.ntt.co.jp>
References: <1430647522-14304-9-git-send-email-andreas.rohner@gmx.net>
	<20150511.031512.1036934606749624197.konishi.ryusuke@lab.ntt.co.jp>
	<20150511.032323.1250231827423193240.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=VsbLGQMhFnaamAZUF8Ox7xrsTNNjZ1I2M+84xacg67k=;
        b=OP9WCZ3UqfyMxmJ/NZOkCOmv+qv3TAwDLZAJ/AZjUjEyJhN0QsEUEqW04JcrSf8ABf
         n7zZReRxzjKOyPghMqquLGotfWGXE+SeNlpZwTRQXFiIUCYB/sJ36P+ksOWkgwpsuZhy
         beRXE9qRpXWQUvDEWux1E3eO6ANlYzPq4RwT+J2CKsqo8GU0CGf64xuJkn7zGYzUF2T6
         kYJxHgkw3W+EnoAtRZm1mhu7c4VDIhgmMMtu2dDKRnWxHhZl/m032js/ac+vCWL4koRJ
         wIg/gfJXpZmARhun34braGFR4IB5zxR8Jdix1ZpwuE87S2ubKXUUNQdE7uSMHCkih8Nr
         fseA==
In-Reply-To: <20150511.032323.1250231827423193240.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 11 May 2015 03:23:23 +0900 (JST), Ryusuke Konishi wrote:
> On Mon, 11 May 2015 03:15:12 +0900 (JST), Ryusuke Konishi wrote:
>> On Sun,  3 May 2015 12:05:21 +0200, Andreas Rohner wrote:
>>> +/**
>>> + * nilfs_segctor_dec_nlive_blks_gc - dec. nlive_blks for blocks of GC-Inodes
>>> + * @dat: dat inode
>>> + * @segbuf: currtent segment buffer
>>> + * @bh: current buffer head
>>> + *
>>> + * Description: nilfs_segctor_dec_nlive_blks_gc() is called if the inode to
>>> + * which @bh belongs is a GC-Inode. In that case it is not necessary to
>>> + * decrement the previous segment, because at the end of the GC process it
>>> + * will be freed anyway. It is however necessary to check again if the blocks
>>> + * are alive here, because the last check was in userspace without the proper
>>> + * locking. Additionally the blocks protected by the protection period should
>>> + * be considered reclaimable. It is assumed, that @bh->b_blocknr contains
>>> + * a virtual block number, which is only true if @bh is part of a GC-Inode.
>>> + */
>> 
>>> +static void nilfs_segctor_dec_nlive_blks_gc(struct inode *dat,
>>> +					    struct nilfs_segment_buffer *segbuf,
>>> +					    struct buffer_head *bh) {
>>> +	bool isreclaimable = buffer_nilfs_period_protected(bh) ||
>>> +				nilfs_dat_is_live(dat, bh->b_blocknr) <= 0;
>>> +
>>> +	if (!buffer_nilfs_snapshot_protected(bh) && isreclaimable)
>>> +		segbuf->sb_nlive_blks--;
>>> +	if (buffer_nilfs_snapshot_protected(bh))
>>> +		segbuf->sb_nsnapshot_blks++;
>>> +}
>> 
>> I have some comments on this function:
>> 
>>  - The position of the brace "{" violates a CodingStyle rule of function.
>>  - buffer_nilfs_snapshot_protected() is tested twice, but this can be
>>    reduced as follows:
>> 
>> 	if (buffer_nilfs_snapshot_protected(bh))
>> 		segbuf->sb_nsnapshot_blks++;
>> 	else if (isreclaimable)
>> 		segbuf->sb_nlive_blks--;
>> 
>>  - Additionally, I prefer "reclaimable" to "isreclaimable" since it's
>>    simpler and still trivial.
>> 
>>  - The logic of isreclaimable is counterintuitive.  
>> 
>>> +	bool isreclaimable = buffer_nilfs_period_protected(bh) ||
>>> +				nilfs_dat_is_live(dat, bh->b_blocknr) <= 0;
>> 
>>    It looks like buffer_nilfs_period_protected(bh) here implies that
>>    the block is deleted.  But it's independent from the buffer is
>>    protected by protection_period or not.
>> 
>>    Why not just adding "still alive" or "deleted" flag and its
>>    corresponding vdesc flag instead of adding the period protected
>>    flag ?
>> 
>>    If we add the "still alive" flag, which means that the block is
>>    not yet deleted from the latest checkpoint, then this function
>>    can be simplified as follows:
>> 
>> static void nilfs_segctor_dec_nlive_blks_gc(struct inode *dat,
>> 					    struct nilfs_segment_buffer *segbuf,
>> 					    struct buffer_head *bh)
>> {
>> 	if (buffer_nilfs_snapshot_protected(bh))
>> 		segbuf->sb_nsnapshot_blks++;
> 
>> 	else if (!buffer_nilfs_still_alive(bh) ||
>> 		 nilfs_dat_is_live(dat, bh->b_blocknr) <= 0)
>> 		segbuf->sb_nlive_blks--;
> 
> This was wrong.  It should be:
> 
> 	else if (!buffer_nilfs_still_alive(bh) &&
> 		 nilfs_dat_is_live(dat, bh->b_blocknr) <= 0)
> 		segbuf->sb_nlive_blks--;

Sorry for confusing you.  I read again the code, and now feel
the previous one (the following) was rather correct.

>> 	if (buffer_nilfs_snapshot_protected(bh))
>> 		segbuf->sb_nsnapshot_blks++;
>> 	else if (!buffer_nilfs_still_alive(bh) ||
>> 		 nilfs_dat_is_live(dat, bh->b_blocknr) <= 0)
>> 		segbuf->sb_nlive_blks--;

Could you confirm which logic correctly implements the algorithm that
you intended ?

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
