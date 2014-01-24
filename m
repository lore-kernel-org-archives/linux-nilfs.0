From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH v2 2/3] nilfs2: add nilfs_sufile_set_suinfo to update
 segment usage info
Date: Fri, 24 Jan 2014 13:34:36 +0100
Message-ID: <52E25DDC.2060502@gmx.net>
References: <cec6a449ddf5ae9da2928cdddfb96ebcb2789eee.1390312777.git.andreas.rohner@gmx.net>	<cec6a449ddf5ae9da2928cdddfb96ebcb2789eee.1390312777.git.andreas.rohner@gmx.net>	<2fd48b2d524a59a02bdad13c0c194de3e5b55cc7.1390312777.git.andreas.rohner@gmx.net> <20140124.205623.400541300.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140124.205623.400541300.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014-01-24 12:56, Ryusuke Konishi wrote:
> On Tue, 21 Jan 2014 15:00:29 +0100, Andreas Rohner wrote:
>> This patch introduces the nilfs_sufile_set_suinfo function, which
>> expects an array of nilfs_suinfo_update structures and updates the
>> segment usage information accordingly.
>>
>> This is basically a helper function for the newly introduced
>> NILFS_IOCTL_SET_SUINFO ioctl.
>>
>> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
>> ---
>>  fs/nilfs2/sufile.c | 91 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  fs/nilfs2/sufile.h |  2 +-
>>  2 files changed, 92 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
>> index 3127e9f..81c3438 100644
>> --- a/fs/nilfs2/sufile.c
>> +++ b/fs/nilfs2/sufile.c
>> @@ -870,6 +870,97 @@ ssize_t nilfs_sufile_get_suinfo(struct inode *sufile, __u64 segnum, void *buf,
>>  }
>>  
>>  /**
>> + * nilfs_sufile_set_suinfo -
> 
> Please fill the summary line of function even though
> nilfs_sufile_get_suinfo() function lacks it.
> 
>  * nilfs_sufile_set_suinfo - update segment usage information
> 
>> + * @sufile: inode of segment usage file
>> + * @buf: array of suinfo
>> + * @supsz: byte size of suinfo
>> + * @nsup: size of suinfo array
>> + *
>> + * Description: Takes an array of nilfs_suinfo_update structs and updates
>> + * segment usage accordingly.
>> + *
>> + * Return Value: On success, 0 is returned and .... On error, one of the
>> + * following negative error codes is returned.
>> + *
>> + * %-EIO - I/O error.
>> + *
>> + * %-ENOMEM - Insufficient amount of memory available.
>> + *
>> + * %-EINVAL - Invalid segment number in input
>> + */
>> +ssize_t nilfs_sufile_set_suinfo(struct inode *sufile, void *buf,
>> +				unsigned supsz, size_t nsup)
>> +{
>> +	struct buffer_head *bh;
>> +	struct nilfs_suinfo_update *sup, *supv = buf;
>> +	struct nilfs_segment_usage *su;
>> +	void *kaddr;
>> +	unsigned long blkoff, prev_blkoff;
>> +	size_t nerr = 0;
>> +	int ret = 0;
>> +
>> +	if (unlikely(nsup == 0))
>> +		goto out;
>> +
>> +	down_write(&NILFS_MDT(sufile)->mi_sem);
>> +	for (sup = supv; sup < supv + nsup; sup++) {
>> +		if (unlikely(sup->sup_segnum >=
>> +				nilfs_sufile_get_nsegments(sufile))) {
>> +			printk(KERN_WARNING
>> +			       "%s: invalid segment number: %llu\n", __func__,
>> +			       (unsigned long long)sup->sup_segnum);
>> +			nerr++;
>> +		}
>> +	}
>> +	if (nerr > 0) {
>> +		ret = -EINVAL;
>> +		goto out_sem;
>> +	}
> 
> Seems that you can exit from inside the loop:
> 
> 	for (sup = supv; sup < supv + nsup; sup++) {
> 		if (unlikely(sup->sup_segnum >=
> 				nilfs_sufile_get_nsegments(sufile))) {
> 			printk(KERN_WARNING
> 			       "%s: invalid segment number: %llu\n", __func__,
> 			       (unsigned long long)sup->sup_segnum);
> 			ret = -EINVAL;
> 			goto out_sem;
> 		}
> 	}

Yes. I copied that from nilfs_sufile_updatev.

>> +
>> +	sup = supv;
>> +	blkoff = nilfs_sufile_get_blkoff(sufile, sup->sup_segnum);
>> +	ret = nilfs_mdt_get_block(sufile, blkoff, 1, NULL, &bh);
>> +	if (ret < 0)
>> +		goto out_sem;
>> +
>> +	for (;;) {
>> +		kaddr = kmap_atomic(bh->b_page);
>> +		su = nilfs_sufile_block_get_segment_usage(
>> +			sufile, sup->sup_segnum, bh, kaddr);
>> +
>> +		if (nilfs_suinfo_update_lastmod(sup))
>> +			su->su_lastmod = cpu_to_le64(sup->sup_sui.sui_lastmod);
>> +
>> +		if (nilfs_suinfo_update_nblocks(sup))
>> +			su->su_nblocks = cpu_to_le32(sup->sup_sui.sui_nblocks);
>> +
>> +		if (nilfs_suinfo_update_flags(sup))
>> +			su->su_flags = cpu_to_le32(sup->sup_sui.sui_flags);
> 
> You must also update the counter value of sh_ncleansegs, sh_ndirtysegs
> in the nilfs_sufile_header struct of sufile header block based on the
> change of these flags.
> 
> In addition, you should ignore NILFS_SEGMENT_USAGE_ACTIVE_FLAG as
> below because this flag is a virtual flag set by running nilfs kernel
> code.  The flag bit should not be written to sufile on disk.
> 
>           (sui_flags & ~(1UL << NILFS_SEGMENT_USAGE_ACTIVE))

Yes. I didn't think of that.

>> +
>> +		kunmap_atomic(kaddr);
>> +
>> +		if (++sup >= supv + nsup)
> 
> You must not use the automatic pointer operation of C language for
> nilfs_suinfo_update because it may be extended in a future release.
> This "++sup" breaks forward compatibility of the ioctl.
> 
> You should do this by:
> 
>                 sup = (void *)sup + supsz;
> 
> Note that pointer type is automatically converted for "void *" type
> variables.


Makes sense. I guess I blindly copied that from nilfs_sufile_updatev,
but with a simple array of __u64 it works of course. With a structure,
that is subject to change, not so much any more.

>> +			break;
>> +		prev_blkoff = blkoff;
>> +		blkoff = nilfs_sufile_get_blkoff(sufile, sup->sup_segnum);
>> +		if (blkoff == prev_blkoff)
>> +			continue;
>> +
>> +		/* get different block */
> 
> You must mark bh that this function changed as dirty with
> mark_buffer_dirty(bh).  Otherwise, the change will be gone.
> 
> 
>> +		brelse(bh);
>> +		ret = nilfs_mdt_get_block(sufile, blkoff, 1, NULL, &bh);
>> +		if (unlikely(ret < 0))
>> +			goto out_sem;
>> +	}
>> +	brelse(bh);
>> +
> 
> The sufile should be marked as dirty (if any change happened):
> 
>     nilfs_mdt_mark_dirty(sufile);

Of course. I am sorry that's a really stupid error. I will fix it right
away.

Thanks for your review. I am really embarrassed about all the stupid
avoidable errors.

br,
Andreas Rohner
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
