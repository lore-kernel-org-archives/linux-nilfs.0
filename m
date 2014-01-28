From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v3 2/3] nilfs2: add nilfs_sufile_set_suinfo to update
 segment usage
Date: Tue, 28 Jan 2014 10:03:04 +0900 (JST)
Message-ID: <20140128.100304.163656186.konishi.ryusuke@lab.ntt.co.jp>
References: <93a209490951530b1b9eb03be4e3b309d36740f4.1390816620.git.andreas.rohner@gmx.net>
	<20140128.040735.413842146.konishi.ryusuke@lab.ntt.co.jp>
	<52E6EEEB.4080303@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52E6EEEB.4080303-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 28 Jan 2014 00:42:35 +0100, Andreas Rohner wrote:
> On 2014-01-27 20:07, Ryusuke Konishi wrote:
>> On Mon, 27 Jan 2014 10:59:27 +0100, Andreas Rohner wrote:
>>> +			|| (nilfs_suinfo_update_flags(sup) &&
>>> +				(sup->sup_sui.sui_flags &
>>> +				(~0UL << (NILFS_SEGMENT_USAGE_ERROR + 1)))))
>> 
>> Ditto. We need to add a definition to nilfs2_fs.h.
>> 
>> enum {
>>         NILFS_SEGMENT_USAGE_ACTIVE,
>>         NILFS_SEGMENT_USAGE_DIRTY,
>>         NILFS_SEGMENT_USAGE_ERROR,
>> 	__NR_NILFS_SEGMENT_USAGE_FLAGS
>> };
>> 
>> 		    (nilfs_suinfo_update_flags(sup) &&
>> 		     (sup->sup_sui.sui_flags &
>> 		      (~0UL << __NR_NILFS_SEGMENT_USAGE_FLAGS))))
>> 
>> By the way, this will dismiss the capability that userland cleaner
>> programs uses the rest of su_flags for their own purpose such as GC
>> optimization.  I think this (rejecting or utilizing it) should be
>> carefully determined.
>> 
>> Any comments on this?
> 
> Hmm, I think it can't hurt to let the userland cleaner use the su_flags.
> As far as I can tell, it shouldn't affect the kernel side.
> nilfs_segment_usage_set_clean() would still work and
> nilfs_sufile_do_scrap() overwrites the whole su_flags as well.

Well, actually the current definition of
nilfs_segment_usage_set_clean() and also nilfs_segment_usage_clean()
are written without compatibility consideration.

It looks to be a separate change if we allow to use the upper bits.
In that case, a bunch of changes and a new feature_compat_ro flag to
deal it as a disk format change, would be needed.

Ok, let's take the above one which protects the upper bits for now.

>>> +			nilfs_sufile_mod_counter(header_bh, ncleansegs,
>>> +					ndirtysegs);
>> 
>> Does it work for a negative value without cast of (u64) ?
>> Please confirm that these counters are updated as you expected.
>> 
>>> +			NILFS_SUI(sufile)->ncleansegs += ncleansegs;
>> 
>> Ditto.  
> 
> I have tested it and it works. At least on my 64 bit architecture. It is
> probably still a good idea to do an explicit cast.
> 
> How about I use s64 for ncleaned and ndirtied and move
> nilfs_sufile_mod_counter outside the loop?

Yes, this one looks better.  In that case, the u64 cast seems
unnecessary.

> 	s64 ncleaned = 0, ndirtied = 0;
> 
> 	...
> 
> 	for (;;) {
> 		...
> 	}
> 	mark_buffer_dirty(bh);
> 	brelse(bh);
> 
>  out_mark:
> 	if (ncleaned || ndirtied) {
> 		nilfs_sufile_mod_counter(header_bh, (u64)ncleaned,
> 				(u64)ndirtied);

> 		NILFS_SUI(sufile)->ncleansegs += ncleaned;

This one looks unclear.

How about defining ncleaned and ndirtied with unsigned long type and
cast them to (u64) for the arguments of nilfs_sufile_mod_counter() ?

Regards,
Ryusuke Konishi


> 	}
> 	nilfs_mdt_mark_dirty(sufile);
>  out_header:
> 	brelse(header_bh);
>  out_sem:
> 	up_write(&NILFS_MDT(sufile)->mi_sem);
> 	return ret;
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
