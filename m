From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH 3/6] nilfs2: scan dat entries at snapshot creation/deletion
 time
Date: Mon, 17 Mar 2014 10:35:33 +0100
Message-ID: <5326C1E5.10108@gmx.net>
References: <cover.1394966728.git.andreas.rohner@gmx.net>	 <29dee92595249b713fff1e4903d5d76556926eec.1394966729.git.andreas.rohner@gmx.net> <1395039845.2205.20.camel@slavad-CELSIUS-H720>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1395039845.2205.20.camel@slavad-CELSIUS-H720>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014-03-17 08:04, Vyacheslav Dubeyko wrote:
> On Sun, 2014-03-16 at 11:47 +0100, Andreas Rohner wrote:
>> To accurately count the number of live blocks in a segment, it is
>> important to take snapshots into account, because snapshots can protect
>> reclaimable blocks from being cleaned.
>>
>> This patch uses the previously reserved de_rsv field of the
>> nilfs_dat_entry struct to store one of the snapshots the corresponding
>> block belongs to. One block can belong to many snapshots, but because
>> the snapshots are stored in a sorted linked list, it is easy to check if
>> a block belongs to any other snapshot given the previous and the next
>> snapshot. For example if the current snapshot (in de_ss) is being
>> removed and neither the previous nor the next snapshot is in the range
>> of de_start to de_end, then it is guaranteed that the block doesn't
>> belong to any other snapshot and is reclaimable. On the other hand if
>> lets say the previous snapshot is in the range of de_start to de_end, we
>> simply set de_ss to the previous snapshot and the block is not
>> reclaimable.
>>
>> To implement this every DAT entry is scanned at snapshot
>> creation/deletion time and updated if needed. 
> 
> It is well known problem of NILFS2 that deletion is very slow operation
> for big files because of necessity to update DAT file (de_end: end
> checkpoint number). So, how your addition does affect this disadvantage?

Additionally to setting "de_end: end checkpoint number" the live block
counter in the SUFILE needs to be decremented. This makes the deletion a
little bit more expensive, but its not really noticeable, because the
SUFILE-Entries are mostly in the cache. I have timed the deletion of 100
GB and there is no discernible difference in the performance.

But my additions make snapshot creation and deletion more expensive.

>> To avoid too many update
>> operations only potentially reclaimable blocks are ever updated. For
>> example if there are some deleted files and the checkpoint to which
>> these files belong is turned into a snapshot, then su_nblocks is
>> incremented for these blocks, which reverses the decrement that happened
>> when the files were deleted. If after some time this snapshot is
>> deleted, su_nblocks is decremented again to reverse the increment at
>> creation time.
>>
>> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
>> ---
>>  fs/nilfs2/cpfile.c        |  7 ++++
>>  fs/nilfs2/dat.c           | 86 +++++++++++++++++++++++++++++++++++++++++++++++
>>  fs/nilfs2/dat.h           | 26 ++++++++++++++
>>  include/linux/nilfs2_fs.h |  4 +--
>>  4 files changed, 121 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
>> index 0d58075..29952f5 100644
>> --- a/fs/nilfs2/cpfile.c
>> +++ b/fs/nilfs2/cpfile.c
>> @@ -28,6 +28,7 @@
>>  #include <linux/nilfs2_fs.h>
>>  #include "mdt.h"
>>  #include "cpfile.h"
>> +#include "sufile.h"
>>  
>>
>>  static inline unsigned long
>> @@ -584,6 +585,7 @@ static int nilfs_cpfile_set_snapshot(struct inode *cpfile, __u64 cno)
>>  	struct nilfs_cpfile_header *header;
>>  	struct nilfs_checkpoint *cp;
>>  	struct nilfs_snapshot_list *list;
>> +	struct the_nilfs *nilfs = cpfile->i_sb->s_fs_info;
>>  	__u64 curr, prev;
>>  	unsigned long curr_blkoff, prev_blkoff;
>>  	void *kaddr;
>> @@ -681,6 +683,8 @@ static int nilfs_cpfile_set_snapshot(struct inode *cpfile, __u64 cno)
>>  	mark_buffer_dirty(header_bh);
>>  	nilfs_mdt_mark_dirty(cpfile);
>>  
>> +	nilfs_dat_scan_inc_ss(nilfs->ns_dat, cno);
>> +
>>  	brelse(prev_bh);
>>  
>>   out_curr:
>> @@ -703,6 +707,7 @@ static int nilfs_cpfile_clear_snapshot(struct inode *cpfile, __u64 cno)
>>  	struct nilfs_cpfile_header *header;
>>  	struct nilfs_checkpoint *cp;
>>  	struct nilfs_snapshot_list *list;
>> +	struct the_nilfs *nilfs = cpfile->i_sb->s_fs_info;
>>  	__u64 next, prev;
>>  	void *kaddr;
>>  	int ret;
>> @@ -784,6 +789,8 @@ static int nilfs_cpfile_clear_snapshot(struct inode *cpfile, __u64 cno)
>>  	mark_buffer_dirty(header_bh);
>>  	nilfs_mdt_mark_dirty(cpfile);
>>  
>> +	nilfs_dat_scan_dec_ss(nilfs->ns_dat, cno, prev, next);
>> +
>>  	brelse(prev_bh);
>>  
>>   out_next:
>> diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
>> index 0d5fada..89a4a5f 100644
>> --- a/fs/nilfs2/dat.c
>> +++ b/fs/nilfs2/dat.c
>> @@ -28,6 +28,7 @@
>>  #include "mdt.h"
>>  #include "alloc.h"
>>  #include "dat.h"
>> +#include "sufile.h"
>>  
>>
>>  #define NILFS_CNO_MIN	((__u64)1)
>> @@ -97,6 +98,7 @@ void nilfs_dat_commit_alloc(struct inode *dat, struct nilfs_palloc_req *req)
>>  	entry->de_start = cpu_to_le64(NILFS_CNO_MIN);
>>  	entry->de_end = cpu_to_le64(NILFS_CNO_MAX);
>>  	entry->de_blocknr = cpu_to_le64(0);
>> +	entry->de_ss = cpu_to_le64(0);
>>  	kunmap_atomic(kaddr);
>>  
>>  	nilfs_palloc_commit_alloc_entry(dat, req);
>> @@ -121,6 +123,7 @@ static void nilfs_dat_commit_free(struct inode *dat,
>>  	entry->de_start = cpu_to_le64(NILFS_CNO_MIN);
>>  	entry->de_end = cpu_to_le64(NILFS_CNO_MIN);
>>  	entry->de_blocknr = cpu_to_le64(0);
>> +	entry->de_ss = cpu_to_le64(0);
>>  	kunmap_atomic(kaddr);
>>  
>>  	nilfs_dat_commit_entry(dat, req);
>> @@ -201,6 +204,7 @@ void nilfs_dat_commit_end(struct inode *dat, struct nilfs_palloc_req *req,
>>  		WARN_ON(start > end);
>>  	}
>>  	entry->de_end = cpu_to_le64(end);
>> +	entry->de_ss = cpu_to_le64(NILFS_CNO_MAX);
>>  	blocknr = le64_to_cpu(entry->de_blocknr);
>>  	kunmap_atomic(kaddr);
>>  
>> @@ -365,6 +369,8 @@ int nilfs_dat_move(struct inode *dat, __u64 vblocknr, sector_t blocknr)
>>  	}
>>  	WARN_ON(blocknr == 0);
>>  	entry->de_blocknr = cpu_to_le64(blocknr);
>> +	if (entry->de_ss == cpu_to_le64(NILFS_CNO_MAX))
>> +		entry->de_ss = cpu_to_le64(0);
>>  	kunmap_atomic(kaddr);
>>  
>>  	mark_buffer_dirty(entry_bh);
>> @@ -430,6 +436,86 @@ int nilfs_dat_translate(struct inode *dat, __u64 vblocknr, sector_t *blocknrp)
>>  	return ret;
>>  }
>>  
>> +void nilfs_dat_do_scan_dec(struct inode *dat, struct nilfs_palloc_req *req,
>> +			   void *data)
>> +{
>> +	struct nilfs_dat_entry *entry;
>> +	__u64 start, end, prev_ss;
>> +	__u64 *ssp = data, ss = ssp[0], prev = ssp[1], next = ssp[2];
>> +	sector_t blocknr;
>> +	void *kaddr;
>> +	struct the_nilfs *nilfs;
>> +
>> +	kaddr = kmap_atomic(req->pr_entry_bh->b_page);
>> +	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
>> +					     req->pr_entry_bh, kaddr);
>> +	start = le64_to_cpu(entry->de_start);
>> +	end = le64_to_cpu(entry->de_end);
>> +	blocknr = le64_to_cpu(entry->de_blocknr);
>> +	prev_ss = le64_to_cpu(entry->de_ss);
>> +
>> +	if (blocknr != 0 && end != NILFS_CNO_MAX && ss >= start && ss < end) {
> 
> I think that it makes sense to use small functions with clear names
> about what we check.

Ok.

>> +		if (prev_ss == ss || prev_ss == NILFS_CNO_MAX) {
>> +			if (prev && prev >= start && prev < end)
>> +				entry->de_ss = cpu_to_le64(prev);
>> +			else if (next && next >= start && next < end)
>> +				entry->de_ss = cpu_to_le64(next);
>> +			else
>> +				entry->de_ss = cpu_to_le64(0);
> 
> Ditto.
> 
>> +
>> +			if (prev_ss != NILFS_CNO_MAX)
>> +				prev_ss = le64_to_cpu(entry->de_ss);
>> +			kunmap_atomic(kaddr);
>> +			mark_buffer_dirty(req->pr_entry_bh);
>> +			nilfs_mdt_mark_dirty(dat);
>> +		} else
>> +			kunmap_atomic(kaddr);
>> +
>> +		if (prev_ss == 0) {
>> +			nilfs = dat->i_sb->s_fs_info;
>> +			nilfs_sufile_add_segment_usage(nilfs->ns_sufile,
>> +				nilfs_get_segnum_of_block(nilfs, blocknr),
>> +				-1, 0);
>> +		}
>> +	} else
>> +		kunmap_atomic(kaddr);
>> +}
>> +
>> +void nilfs_dat_do_scan_inc(struct inode *dat, struct nilfs_palloc_req *req,
>> +			   void *data)
>> +{
>> +	struct nilfs_dat_entry *entry;
>> +	__u64 start, end, prev_ss;
>> +	__u64 *ssp = data, ss = *ssp;
>> +	sector_t blocknr;
>> +	void *kaddr;
>> +	struct the_nilfs *nilfs;
>> +
>> +	kaddr = kmap_atomic(req->pr_entry_bh->b_page);
>> +	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
>> +			req->pr_entry_bh, kaddr);
>> +	start = le64_to_cpu(entry->de_start);
>> +	end = le64_to_cpu(entry->de_end);
>> +	blocknr = le64_to_cpu(entry->de_blocknr);
>> +	prev_ss = le64_to_cpu(entry->de_ss);
>> +
>> +	if (blocknr != 0 && end != NILFS_CNO_MAX && ss >= start && ss < end &&
>> +			(prev_ss == 0 || prev_ss == NILFS_CNO_MAX)) {
> 
> Ditto. Moreover, you repeat this check.

What do you mean? Where do I repeat this check?

>> +
>> +		entry->de_ss = cpu_to_le64(ss);
>> +
>> +		kunmap_atomic(kaddr);
>> +		mark_buffer_dirty(req->pr_entry_bh);
>> +		nilfs_mdt_mark_dirty(dat);
>> +
>> +		nilfs = dat->i_sb->s_fs_info;
>> +		nilfs_sufile_add_segment_usage(nilfs->ns_sufile,
>> +				nilfs_get_segnum_of_block(nilfs, blocknr),
> 
> Looks weird. Maybe, variable?

Ok.

Thanks for your review so far.

Best regards,
Andreas Rohner

> Thanks,
> Vyacheslav Dubeyko.
> 
>> +				1, 0);
>> +	} else
>> +		kunmap_atomic(kaddr);
>> +}
>> +
>>  ssize_t nilfs_dat_get_vinfo(struct inode *dat, void *buf, unsigned visz,
>>  			    size_t nvi)
>>  {
>> diff --git a/fs/nilfs2/dat.h b/fs/nilfs2/dat.h
>> index cbd8e97..92a187e 100644
>> --- a/fs/nilfs2/dat.h
>> +++ b/fs/nilfs2/dat.h
>> @@ -55,5 +55,31 @@ ssize_t nilfs_dat_get_vinfo(struct inode *, void *, unsigned, size_t);
>>  
>>  int nilfs_dat_read(struct super_block *sb, size_t entry_size,
>>  		   struct nilfs_inode *raw_inode, struct inode **inodep);
>> +void nilfs_dat_do_scan_dec(struct inode *, struct nilfs_palloc_req *, void *);
>> +void nilfs_dat_do_scan_inc(struct inode *, struct nilfs_palloc_req *, void *);
>> +
>> +/**
>> + * nilfs_dat_scan_dec_ss - scan all dat entries for a checkpoint dec suinfo
>> + * @dat: inode of dat file
>> + * @cno: snapshot number
>> + * @prev: previous snapshot number
>> + * @next: next snapshot number
>> + */
>> +static inline int nilfs_dat_scan_dec_ss(struct inode *dat, __u64 cno,
>> +					__u64 prev, __u64 next)
>> +{
>> +	__u64 data[3] = { cno, prev, next };
>> +	return nilfs_palloc_scan_entries(dat, nilfs_dat_do_scan_dec, data);
>> +}
>> +
>> +/**
>> + * nilfs_dat_scan_dec_ss - scan all dat entries for a checkpoint inc suinfo
>> + * @dat: inode of dat file
>> + * @cno: snapshot number
>> + */
>> +static inline int nilfs_dat_scan_inc_ss(struct inode *dat, __u64 cno)
>> +{
>> +	return nilfs_palloc_scan_entries(dat, nilfs_dat_do_scan_inc, &cno);
>> +}
>>  
>>  #endif	/* _NILFS_DAT_H */
>> diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
>> index ca269ad..ba9ebe02 100644
>> --- a/include/linux/nilfs2_fs.h
>> +++ b/include/linux/nilfs2_fs.h
>> @@ -475,13 +475,13 @@ struct nilfs_palloc_group_desc {
>>   * @de_blocknr: block number
>>   * @de_start: start checkpoint number
>>   * @de_end: end checkpoint number
>> - * @de_rsv: reserved for future use
>> + * @de_ss: one of the snapshots the block belongs to
>>   */
>>  struct nilfs_dat_entry {
>>  	__le64 de_blocknr;
>>  	__le64 de_start;
>>  	__le64 de_end;
>> -	__le64 de_rsv;
>> +	__le64 de_ss;
>>  };
>>  
>>  #define NILFS_MIN_DAT_ENTRY_SIZE	32
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
