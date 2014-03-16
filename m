From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH 2/6] nilfs2: add new timestamp to seg usage and function
 to change su_nblocks
Date: Sun, 16 Mar 2014 13:24:33 +0100
Message-ID: <53259801.5080409@gmx.net>
References: <cover.1394966728.git.andreas.rohner@gmx.net> <12561ce5e2cf8ae07fdda05e16c357f37d17c62f.1394966729.git.andreas.rohner@gmx.net> <2FD47FE0-3468-4EF4-AAAE-4A636C640C44@dubeyko.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2FD47FE0-3468-4EF4-AAAE-4A636C640C44-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014-03-16 14:00, Vyacheslav Dubeyko wrote:
> 
> On Mar 16, 2014, at 1:47 PM, Andreas Rohner wrote:
> 
>> This patch adds an additional timestamp to the segment usage
>> information that indicates the last time the usage information was
>> changed. So su_lastmod indicates the last time the segment itself was
>> modified and su_lastdec indicates the last time the usage information
>> itself was changed.
>>
> 
> What will we have if user changes time?
> What sequence will we have after such "malicious" action?
> Did you test such situation?

The timestamp is just a hint for the userspace GC. If the hint is wrong
the result would be that the GC is less efficient for a while. After a
while it would go back to normal. You have the same problem with the
already existing su_lastmod timestamp.

>> This is important information for the GC, because it needs to avoid
>> selecting segments for cleaning that are created (su_lastmod) outside of
>> the protection period, but the blocks got reclaimable (su_nblocks is
>> decremented) within the protection period. Without that information the
>> GC policy has to assume, that there are reclaimble blocks, only to find
>> out, that they are protected by the protection period.
>>
>> This patch also introduces nilfs_sufile_add_segment_usage(), which can
>> be used to increment or decrement the value of su_nblocks of a specific
>> segment.
>>
>> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
>> ---
>> fs/nilfs2/sufile.c        | 86 +++++++++++++++++++++++++++++++++++++++++++++--
>> fs/nilfs2/sufile.h        | 18 ++++++++++
>> include/linux/nilfs2_fs.h |  7 ++++
>> 3 files changed, 109 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
>> index 2a869c3..0886938 100644
>> --- a/fs/nilfs2/sufile.c
>> +++ b/fs/nilfs2/sufile.c
>> @@ -453,6 +453,8 @@ void nilfs_sufile_do_scrap(struct inode *sufile, __u64 segnum,
>> 	su->su_lastmod = cpu_to_le64(0);
>> 	su->su_nblocks = cpu_to_le32(0);
>> 	su->su_flags = cpu_to_le32(1UL << NILFS_SEGMENT_USAGE_DIRTY);
>> +	if (nilfs_sufile_lastdec_supported(sufile))
>> +		su->su_lastdec = cpu_to_le64(0);
>> 	kunmap_atomic(kaddr);
>>
>> 	nilfs_sufile_mod_counter(header_bh, clean ? (u64)-1 : 0, dirty ? 0 : 1);
>> @@ -482,7 +484,7 @@ void nilfs_sufile_do_free(struct inode *sufile, __u64 segnum,
>> 	WARN_ON(!nilfs_segment_usage_dirty(su));
>>
>> 	sudirty = nilfs_segment_usage_dirty(su);
>> -	nilfs_segment_usage_set_clean(su);
>> +	nilfs_sufile_segment_usage_set_clean(sufile, su);
>> 	kunmap_atomic(kaddr);
>> 	mark_buffer_dirty(su_bh);
>>
>> @@ -549,6 +551,75 @@ int nilfs_sufile_set_segment_usage(struct inode *sufile, __u64 segnum,
>> }
>>
>> /**
>> + * nilfs_sufile_add_segment_usage - decrement usage of a segment
> 
> I feel cultural dissonance about this name. Add or decrement? :)
> Decrement and add are different operations for me.

Yes that description is wrong. Thanks for pointing that out. The long
description below is correct though. By adding a signed value, one can
decrement and increment.

>> + * @sufile: inode of segment usage file
>> + * @segnum: segment number
>> + * @value: value to add to su_nblocks
>> + * @dectime: current time
>> + *
>> + * Description: nilfs_sufile_add_segment_usage() adds a signed value to the
>> + * su_nblocks field of the segment usage information of @segnum. It ensures
>> + * that the result is bigger than 0 and smaller or equal to the maximum number
>> + * of blocks per segment
>> + *
>> + * Return Value: On success, 0 is returned. On error, one of the following
>> + * negative error codes is returned.
>> + *
>> + * %-ENOMEM - Insufficient memory available.
>> + *
>> + * %-EIO - I/O error
>> + *
>> + * %-ENOENT - the specified block does not exist (hole block)
>> + */
>> +int nilfs_sufile_add_segment_usage(struct inode *sufile, __u64 segnum,
>> +				   __s64 value, time_t dectime)
>> +{
>> +	struct the_nilfs *nilfs = sufile->i_sb->s_fs_info;
>> +	struct buffer_head *bh;
>> +	struct nilfs_segment_usage *su;
>> +	void *kaddr;
>> +	int ret;
>> +
>> +	if (value == 0)
>> +		return 0;
>> +
>> +	down_write(&NILFS_MDT(sufile)->mi_sem);
>> +
>> +	ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 0, &bh);
>> +	if (ret < 0)
> 
> Maybe it needs to use unlikely() here.

Yes good idea.

>> +		goto out_sem;
>> +
>> +	kaddr = kmap_atomic(bh->b_page);
>> +	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, bh, kaddr);
>> +	WARN_ON(nilfs_segment_usage_error(su));
>> +
>> +	value += le32_to_cpu(su->su_nblocks);
> 
> Decrement. Really? :)
> 
>> +	if (value < 0)
>> +		value = 0;
>> +	if (value > nilfs->ns_blocks_per_segment)
> 
> maybe "else if" here?

Yes.

>> +		value = nilfs->ns_blocks_per_segment;
>> +
>> +	if (value == le32_to_cpu(su->su_nblocks)) {
>> +		kunmap_atomic(kaddr);
>> +		goto out_brelse;
>> +	}
>> +
>> +	su->su_nblocks = cpu_to_le32(value);
>> +	if (dectime && nilfs_sufile_lastdec_supported(sufile))
>> +		su->su_lastdec = cpu_to_le64(dectime);
>> +	kunmap_atomic(kaddr);
>> +
>> +	mark_buffer_dirty(bh);
>> +	nilfs_mdt_mark_dirty(sufile);
>> +
>> +out_brelse:
>> +	brelse(bh);
>> +out_sem:
>> +	up_write(&NILFS_MDT(sufile)->mi_sem);
>> +	return ret;
>> +}
>> +
>> +/**
>>  * nilfs_sufile_get_stat - get segment usage statistics
>>  * @sufile: inode of segment usage file
>>  * @stat: pointer to a structure of segment usage statistics
>> @@ -698,7 +769,8 @@ static int nilfs_sufile_truncate_range(struct inode *sufile,
>> 		nc = 0;
>> 		for (su = su2, j = 0; j < n; j++, su = (void *)su + susz) {
>> 			if (nilfs_segment_usage_error(su)) {
>> -				nilfs_segment_usage_set_clean(su);
>> +				nilfs_sufile_segment_usage_set_clean(sufile,
>> +						su);
>> 				nc++;
>> 			}
>> 		}
>> @@ -858,6 +930,13 @@ ssize_t nilfs_sufile_get_suinfo(struct inode *sufile, __u64 segnum, void *buf,
>> 			if (nilfs_segment_is_active(nilfs, segnum + j))
>> 				si->sui_flags |=
>> 					(1UL << NILFS_SEGMENT_USAGE_ACTIVE);
>> +			if (sisz >= sizeof(struct nilfs_suinfo)) {
>> +				if (susz >= sizeof(struct nilfs_segment_usage))
>> +					si->sui_lastdec =
>> +						le64_to_cpu(su->su_lastdec);
> 
> Is it really impossible to place assignment on one line?

Yes because it is already indented so much. I couldn't find an easy way
to get rid of the indentation.

>> +				else
>> +					si->sui_lastdec = 0;
>> +			}
>> 		}
>> 		kunmap_atomic(kaddr);
>> 		brelse(su_bh);
>> @@ -935,6 +1014,9 @@ ssize_t nilfs_sufile_set_suinfo(struct inode *sufile, void *buf,
>> 		if (nilfs_suinfo_update_lastmod(sup))
>> 			su->su_lastmod = cpu_to_le64(sup->sup_sui.sui_lastmod);
>>
>> +		if (nilfs_suinfo_update_lastdec(sup))
>> +			su->su_lastdec = cpu_to_le64(sup->sup_sui.sui_lastdec);
>> +
>> 		if (nilfs_suinfo_update_nblocks(sup))
>> 			su->su_nblocks = cpu_to_le32(sup->sup_sui.sui_nblocks);
>>
>> diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
>> index b8afd72..e5455d2 100644
>> --- a/fs/nilfs2/sufile.h
>> +++ b/fs/nilfs2/sufile.h
>> @@ -28,6 +28,23 @@
>> #include <linux/nilfs2_fs.h>
>> #include "mdt.h"
>>
>> +static inline int
>> +nilfs_sufile_lastdec_supported(const struct inode *sufile)
>> +{
>> +	return NILFS_MDT(sufile)->mi_entry_size ==
>> +			sizeof(struct nilfs_segment_usage);
>> +}
>> +
>> +static inline void
>> +nilfs_sufile_segment_usage_set_clean(const struct inode *sufile,
>> +		struct nilfs_segment_usage *su)
>> +{
>> +	su->su_lastmod = cpu_to_le64(0);
>> +	su->su_nblocks = cpu_to_le32(0);
>> +	su->su_flags = cpu_to_le32(0);
>> +	if (nilfs_sufile_lastdec_supported(sufile))
>> +		su->su_lastdec = cpu_to_le64(0);
>> +}
>>
>> static inline unsigned long nilfs_sufile_get_nsegments(struct inode *sufile)
>> {
>> @@ -41,6 +58,7 @@ int nilfs_sufile_alloc(struct inode *, __u64 *);
>> int nilfs_sufile_mark_dirty(struct inode *sufile, __u64 segnum);
>> int nilfs_sufile_set_segment_usage(struct inode *sufile, __u64 segnum,
>> 				   unsigned long nblocks, time_t modtime);
>> +int nilfs_sufile_add_segment_usage(struct inode *, __u64, __s64, time_t);
>> int nilfs_sufile_get_stat(struct inode *, struct nilfs_sustat *);
>> ssize_t nilfs_sufile_get_suinfo(struct inode *, __u64, void *, unsigned,
>> 				size_t);
>> diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
>> index ff3fea3..ca269ad 100644
>> --- a/include/linux/nilfs2_fs.h
>> +++ b/include/linux/nilfs2_fs.h
>> @@ -614,11 +614,13 @@ struct nilfs_cpfile_header {
>>  * @su_lastmod: last modified timestamp
>>  * @su_nblocks: number of blocks in segment
>>  * @su_flags: flags
>> + * @su_lastdec: last decrement of su_nblocks timestamp
>>  */
>> struct nilfs_segment_usage {
>> 	__le64 su_lastmod;
>> 	__le32 su_nblocks;
>> 	__le32 su_flags;
>> +	__le64 su_lastdec;
> 
> So, this change makes on-disk layout incompatible with previous one.
> Am I correct? At first it needs to be fully confident that we really need in
> changing in this place. Secondly, it needs to add incompatible flag for
> s_feature_incompat field of superblock and maybe mount option.

No it IS compatible. NILFS uses the entry sizes stored in the super
block. Notice, that the code does not depend on sizeof(struct
nilfs_suinfo) or sizeof(struct nilfs_segment_usage). So an old kernel
can read a file system with su_lastdec and a new kernel can read an old
file system without su_lastdec.

> The su_lastdec sounds not very good for my taste.

Hmm, yes I agree. It is a remnant of a previous version of my code. I
will think of something better.

Thanks for your review.

br,
Andreas Rohner

> Thanks,
> Vyacheslav Dubeyko.
> 
>> };
>>
>> #define NILFS_MIN_SEGMENT_USAGE_SIZE	16
>> @@ -663,6 +665,7 @@ nilfs_segment_usage_set_clean(struct nilfs_segment_usage *su)
>> 	su->su_lastmod = cpu_to_le64(0);
>> 	su->su_nblocks = cpu_to_le32(0);
>> 	su->su_flags = cpu_to_le32(0);
>> +	su->su_lastdec = cpu_to_le64(0);
>> }
>>
>> static inline int
>> @@ -694,11 +697,13 @@ struct nilfs_sufile_header {
>>  * @sui_lastmod: timestamp of last modification
>>  * @sui_nblocks: number of written blocks in segment
>>  * @sui_flags: segment usage flags
>> + * @sui_lastdec: last decrement of sui_nblocks timestamp
>>  */
>> struct nilfs_suinfo {
>> 	__u64 sui_lastmod;
>> 	__u32 sui_nblocks;
>> 	__u32 sui_flags;
>> +	__u64 sui_lastdec;
>> };
>>
>> #define NILFS_SUINFO_FNS(flag, name)					\
>> @@ -736,6 +741,7 @@ enum {
>> 	NILFS_SUINFO_UPDATE_LASTMOD,
>> 	NILFS_SUINFO_UPDATE_NBLOCKS,
>> 	NILFS_SUINFO_UPDATE_FLAGS,
>> +	NILFS_SUINFO_UPDATE_LASTDEC,
>> 	__NR_NILFS_SUINFO_UPDATE_FIELDS,
>> };
>>
>> @@ -759,6 +765,7 @@ nilfs_suinfo_update_##name(const struct nilfs_suinfo_update *sup)	\
>> NILFS_SUINFO_UPDATE_FNS(LASTMOD, lastmod)
>> NILFS_SUINFO_UPDATE_FNS(NBLOCKS, nblocks)
>> NILFS_SUINFO_UPDATE_FNS(FLAGS, flags)
>> +NILFS_SUINFO_UPDATE_FNS(LASTDEC, lastdec)
>>
>> enum {
>> 	NILFS_CHECKPOINT,
>> -- 
>> 1.9.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
