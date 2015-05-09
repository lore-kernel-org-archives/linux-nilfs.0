From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH v2 6/9] nilfs2: add tracking of block deletions and updates
Date: Sat, 09 May 2015 22:02:08 +0200
Message-ID: <554E67C0.1050309@gmx.net>
References: <1430647522-14304-1-git-send-email-andreas.rohner@gmx.net>	<1430647522-14304-7-git-send-email-andreas.rohner@gmx.net> <20150509.160512.1087140271092828536.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150509.160512.1087140271092828536.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2015-05-09 09:05, Ryusuke Konishi wrote:
> On Sun,  3 May 2015 12:05:19 +0200, Andreas Rohner wrote:
>> This patch adds tracking of block deletions and updates for all files.
>> It uses the fact, that for every block, NILFS2 keeps an entry in the
>> DAT file and stores the checkpoint where it was created, deleted or
>> overwritten. So whenever a block is deleted or overwritten
>> nilfs_dat_commit_end() is called to update the DAT entry. At this
>> point this patch simply decrements the su_nlive_blks field of the
>> corresponding segment. The value of su_nlive_blks is set at segment
>> creation time.
>>
>> The DAT file itself has of course no DAT entries for its own blocks, but
>> it still has to propagate deletions and updates to its btree. When this
>> happens this patch again decrements the su_nlive_blks field of the
>> corresponding segment.
>>
>> The new feature compatibility flag NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS
>> can be used to enable or disable the block tracking at any time.
>>
>> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
>> ---
>>  fs/nilfs2/btree.c   | 33 ++++++++++++++++++++++++++++++---
>>  fs/nilfs2/dat.c     | 15 +++++++++++++--
>>  fs/nilfs2/direct.c  | 20 +++++++++++++++-----
>>  fs/nilfs2/page.c    |  6 ++++--
>>  fs/nilfs2/page.h    |  3 +++
>>  fs/nilfs2/segbuf.c  |  3 +++
>>  fs/nilfs2/segbuf.h  |  5 +++++
>>  fs/nilfs2/segment.c | 48 +++++++++++++++++++++++++++++++++++++-----------
>>  fs/nilfs2/sufile.c  | 17 ++++++++++++++++-
>>  fs/nilfs2/sufile.h  |  3 ++-
>>  10 files changed, 128 insertions(+), 25 deletions(-)
>>
>> diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
>> index 059f371..d3b2763 100644
>> --- a/fs/nilfs2/btree.c
>> +++ b/fs/nilfs2/btree.c
>> @@ -30,6 +30,7 @@
>>  #include "btree.h"
>>  #include "alloc.h"
>>  #include "dat.h"
>> +#include "sufile.h"
>>  
>>  static void __nilfs_btree_init(struct nilfs_bmap *bmap);
>>  
> 
>> @@ -1889,9 +1890,35 @@ static int nilfs_btree_propagate_p(struct nilfs_bmap *btree,
>>  				   int level,
>>  				   struct buffer_head *bh)
>>  {
>> -	while ((++level < nilfs_btree_height(btree) - 1) &&
>> -	       !buffer_dirty(path[level].bp_bh))
>> -		mark_buffer_dirty(path[level].bp_bh);
>> +	struct the_nilfs *nilfs = btree->b_inode->i_sb->s_fs_info;
>> +	struct nilfs_btree_node *node;
>> +	__u64 ptr, segnum;
>> +	int ncmax, vol, counted;
>> +
>> +	vol = buffer_nilfs_volatile(bh);
>> +	counted = buffer_nilfs_counted(bh);
>> +	set_buffer_nilfs_counted(bh);
>> +
>> +	while (++level < nilfs_btree_height(btree)) {
>> +		if (!vol && !counted && nilfs_feature_track_live_blks(nilfs)) {
>> +			node = nilfs_btree_get_node(btree, path, level, &ncmax);
>> +			ptr = nilfs_btree_node_get_ptr(node,
>> +						       path[level].bp_index,
>> +						       ncmax);
>> +			segnum = nilfs_get_segnum_of_block(nilfs, ptr);
>> +			nilfs_sufile_dec_nlive_blks(nilfs->ns_sufile, segnum);
>> +		}
>> +
>> +		if (path[level].bp_bh) {
>> +			if (buffer_dirty(path[level].bp_bh))
>> +				break;
>> +
>> +			mark_buffer_dirty(path[level].bp_bh);
>> +			vol = buffer_nilfs_volatile(path[level].bp_bh);
>> +			counted = buffer_nilfs_counted(path[level].bp_bh);
>> +			set_buffer_nilfs_counted(path[level].bp_bh);
>> +		}
>> +	}
>>  
>>  	return 0;
>>  }
> 
> Consider the following comments:
> 
> - Please use volatile flag also for the duplication check instead of
>   adding nilfs_counted flag.

I thought volatile already means something else. I wasn't sure if could
use it. I will change it and remove the nilfs_counted flag.

> - btree.c, direct.c, and dat.c shouldn't refer SUFILE directly.
>   Please add a wrapper function like "nilfs_dec_nlive_blks(nilfs, blocknr)"
>   to the implementation of the_nilfs.c, and use it instead.
> - To clarify implementation separate function to update pointers
>   like nilfs_btree_propagate_v() is doing.

Ok.

> - The return value of nilfs_sufile_dec_nlive_blks() looks to be ignored
>   intentionally.  Please add a comment explaining why you do so.

I just thought, that the block tracking isn't important enough to cause
a fatal error. I should at least use the WARN_ON() macro. Do you think I
should return possible errors?

> e.g.
> 
> static void nilfs_btree_update_p(struct nilfs_bmap *btree,
>                                  struct nilfs_btree_path *path, int level)
> {
> 	struct the_nilfs *nilfs = btree->b_inode->i_sb->s_fs_info;
> 	struct nilfs_btree_node *parent;
> 	__u64 ptr;
> 	int ncmax;
> 
> 	if (nilfs_feature_track_live_blks(nilfs)) {
> 		parent = nilfs_btree_get_node(btree, path, level + 1, &ncmax);
> 		ptr = nilfs_btree_node_get_ptr(parent,
> 					       path[level + 1].bp_index,
> 					       ncmax);
> 		nilfs_dec_nlive_blks(nilfs, ptr);
> 		/* (Please add a comment explaining why we ignore the return value) */
> 	}
> 	set_buffer_nilfs_volatile(path[level].bp_bh);
> }
> 
> static int nilfs_btree_propagate_p(struct nilfs_bmap *btree,
> 				   struct nilfs_btree_path *path,
> 				   int level,
> 				   struct buffer_head *bh)
> {
> 	/*
> 	 * Update pointer to the given dirty buffer.  If the buffer is
> 	 * marked volatile, it shouldn't be updated because it's
> 	 * either a newly created buffer or an already updated one.
> 	 */
> 	if (!buffer_nilfs_volatile(path[level].bp_bh))
> 		nilfs_btree_update_p(btree, path, level);
> 
> 	/*
> 	 * Mark upper nodes dirty and update their pointers unless
> 	 * they're already marked dirty.
> 	 */
> 	while (++level < nilfs_btree_height(btree) - 1 &&
> 	       !buffer_dirty(path[level].bp_bh)) {
> 
> 		WARN_ON(buffer_nilfs_volatile(path[level].bp_bh));
> 		nilfs_btree_update_p(btree, path, level);
> 		mark_buffer_dirty(path[level].bp_bh);
> 	}
> 	return 0;
> }
> 
>> diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
>> index 0d5fada..9c2fc32 100644
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
>> @@ -188,9 +189,10 @@ void nilfs_dat_commit_end(struct inode *dat, struct nilfs_palloc_req *req,
>>  			  int dead)
>>  {
>>  	struct nilfs_dat_entry *entry;
>> -	__u64 start, end;
>> +	__u64 start, end, segnum;
>>  	sector_t blocknr;
>>  	void *kaddr;
>> +	struct the_nilfs *nilfs;
>>  
>>  	kaddr = kmap_atomic(req->pr_entry_bh->b_page);
>>  	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
>> @@ -206,8 +208,17 @@ void nilfs_dat_commit_end(struct inode *dat, struct nilfs_palloc_req *req,
>>  
>>  	if (blocknr == 0)
>>  		nilfs_dat_commit_free(dat, req);
>> -	else
> 
> Add braces around nilfs_dat_commit_free() since you add multiple
> sentences in the else clause.  See the chapter 3 of CodingStyle file.

Ok sorry for that.

>> +	else {
>>  		nilfs_dat_commit_entry(dat, req);
>> +
>> +		nilfs = dat->i_sb->s_fs_info;
>> +
>> +		if (nilfs_feature_track_live_blks(nilfs)) {
> 
>> +			segnum = nilfs_get_segnum_of_block(nilfs, blocknr);
>> +			nilfs_sufile_dec_nlive_blks(nilfs->ns_sufile, segnum);
> 
> Ditto.  Call nilfs_dec_nlive_blks(nilfs, blocknr) instead and do not
> to add dependency to SUFILE in dat.c.
> 
>> +		}
>> +	}
>> +
>>  }
>>  
>>  void nilfs_dat_abort_end(struct inode *dat, struct nilfs_palloc_req *req)
>> diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
>> index ebf89fd..42704eb 100644
>> --- a/fs/nilfs2/direct.c
>> +++ b/fs/nilfs2/direct.c
>> @@ -26,6 +26,7 @@
>>  #include "direct.h"
>>  #include "alloc.h"
>>  #include "dat.h"
>> +#include "sufile.h"
>>  
>>  static inline __le64 *nilfs_direct_dptrs(const struct nilfs_bmap *direct)
>>  {
>> @@ -268,18 +269,27 @@ int nilfs_direct_delete_and_convert(struct nilfs_bmap *bmap,
>>  static int nilfs_direct_propagate(struct nilfs_bmap *bmap,
>>  				  struct buffer_head *bh)
>>  {
>> +	struct the_nilfs *nilfs = bmap->b_inode->i_sb->s_fs_info;
>>  	struct nilfs_palloc_req oldreq, newreq;
>>  	struct inode *dat;
>> -	__u64 key;
>> -	__u64 ptr;
>> +	__u64 key, ptr, segnum;
>>  	int ret;
>>  
>> -	if (!NILFS_BMAP_USE_VBN(bmap))
>> -		return 0;
>> -
> 
>>  	dat = nilfs_bmap_get_dat(bmap);
>>  	key = nilfs_bmap_data_get_key(bmap, bh);
>>  	ptr = nilfs_direct_get_ptr(bmap, key);
>> +
> 
>> +	if (unlikely(!NILFS_BMAP_USE_VBN(bmap))) {
>> +		if (!buffer_nilfs_volatile(bh) && !buffer_nilfs_counted(bh) &&
>> +				nilfs_feature_track_live_blks(nilfs)) {
>> +			set_buffer_nilfs_counted(bh);
>> +			segnum = nilfs_get_segnum_of_block(nilfs, ptr);
>> +
>> +			nilfs_sufile_dec_nlive_blks(nilfs->ns_sufile, segnum);
>> +		}
>> +		return 0;
>> +	}
> 
> Use the volatile flag also for duplication check, and do not use
> unlikely() marcro when testing "!NILFS_BMAP_USE_VBN(bmap)".  It's
> not exceptional as error:
> 
> 	if (!NILFS_BMAP_USE_VBN(bmap)) {
> 		if (!buffer_nilfs_volatile(bh)) {
> 			if (nilfs_feature_track_live_blks(nilfs))
> 				nilfs_dec_nlive_blks(nilfs, ptr);
> 			set_buffer_nilfs_volatile(bh);
> 		}
> 		return 0;
> 	}

During my tests, this was only called once directly after the first
bytes are written on a newly formatted volume. This can only be true for
the DAT-File and the DAT-File is very unlikely to be small enough to use
the direct bmap, except on a newly formatted volume. Do you mean, that
unlikely() should only be used for errors?

>> +
>>  	if (!buffer_nilfs_volatile(bh)) {
>>  		oldreq.pr_entry_nr = ptr;
>>  		newreq.pr_entry_nr = ptr;
>> diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
>> index 45d650a..fd21b43 100644
>> --- a/fs/nilfs2/page.c
>> +++ b/fs/nilfs2/page.c
>> @@ -92,7 +92,8 @@ void nilfs_forget_buffer(struct buffer_head *bh)
>>  	const unsigned long clear_bits =
>>  		(1 << BH_Uptodate | 1 << BH_Dirty | 1 << BH_Mapped |
>>  		 1 << BH_Async_Write | 1 << BH_NILFS_Volatile |
>> -		 1 << BH_NILFS_Checked | 1 << BH_NILFS_Redirected);
>> +		 1 << BH_NILFS_Checked | 1 << BH_NILFS_Redirected |
> 
>> +		 1 << BH_NILFS_Counted);
> 
> You don't have to add nilfs_counted flag as I mentioned above.  Remove
> this.
> 
>>  
>>  	lock_buffer(bh);
>>  	set_mask_bits(&bh->b_state, clear_bits, 0);
>> @@ -422,7 +423,8 @@ void nilfs_clear_dirty_page(struct page *page, bool silent)
>>  		const unsigned long clear_bits =
>>  			(1 << BH_Uptodate | 1 << BH_Dirty | 1 << BH_Mapped |
>>  			 1 << BH_Async_Write | 1 << BH_NILFS_Volatile |
>> -			 1 << BH_NILFS_Checked | 1 << BH_NILFS_Redirected);
>> +			 1 << BH_NILFS_Checked | 1 << BH_NILFS_Redirected |
> 
>> +			 1 << BH_NILFS_Counted);
> 
> Ditto.
> 
>>  
>>  		bh = head = page_buffers(page);
>>  		do {
>> diff --git a/fs/nilfs2/page.h b/fs/nilfs2/page.h
>> index a43b828..4e35814 100644
>> --- a/fs/nilfs2/page.h
>> +++ b/fs/nilfs2/page.h
>> @@ -36,12 +36,15 @@ enum {
>>  	BH_NILFS_Volatile,
>>  	BH_NILFS_Checked,
>>  	BH_NILFS_Redirected,
>> +	BH_NILFS_Counted,
> 
> Ditto.
> 
>>  };
>>  
>>  BUFFER_FNS(NILFS_Node, nilfs_node)		/* nilfs node buffers */
>>  BUFFER_FNS(NILFS_Volatile, nilfs_volatile)
>>  BUFFER_FNS(NILFS_Checked, nilfs_checked)	/* buffer is verified */
>>  BUFFER_FNS(NILFS_Redirected, nilfs_redirected)	/* redirected to a copy */
> 
>> +/* counted by propagate_p for segment usage */
>> +BUFFER_FNS(NILFS_Counted, nilfs_counted)
> 
> Ditto.
> 
>>  
>>  
>>  int __nilfs_clear_page_dirty(struct page *);
>> diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
>> index dc3a9efd..dabb65b 100644
>> --- a/fs/nilfs2/segbuf.c
>> +++ b/fs/nilfs2/segbuf.c
>> @@ -57,6 +57,9 @@ struct nilfs_segment_buffer *nilfs_segbuf_new(struct super_block *sb)
>>  	INIT_LIST_HEAD(&segbuf->sb_segsum_buffers);
>>  	INIT_LIST_HEAD(&segbuf->sb_payload_buffers);
>>  	segbuf->sb_super_root = NULL;
> 
>> +	segbuf->sb_flags = 0;
> 
> You don't have to add sb_flags.  Use sci->sc_stage.flags instead
> because the flag is used to manage internal state of segment
> construction rather than the state of segbuf.

Yes that is true. I'll change that.

>> +	segbuf->sb_nlive_blks = 0;
>> +	segbuf->sb_nsnapshot_blks = 0;
>>  
>>  	init_completion(&segbuf->sb_bio_event);
>>  	atomic_set(&segbuf->sb_err, 0);
>> diff --git a/fs/nilfs2/segbuf.h b/fs/nilfs2/segbuf.h
>> index b04f08c..a802f61 100644
>> --- a/fs/nilfs2/segbuf.h
>> +++ b/fs/nilfs2/segbuf.h
>> @@ -83,6 +83,9 @@ struct nilfs_segment_buffer {
>>  	sector_t		sb_fseg_start, sb_fseg_end;
>>  	sector_t		sb_pseg_start;
>>  	unsigned		sb_rest_blocks;
> 
>> +	int			sb_flags;
> 
> ditto.
> 
>> +	__u32			sb_nlive_blks;
>> +	__u32			sb_nsnapshot_blks;
>>  
>>  	/* Buffers */
>>  	struct list_head	sb_segsum_buffers;
>> @@ -95,6 +98,8 @@ struct nilfs_segment_buffer {
>>  	struct completion	sb_bio_event;
>>  };
>>  
>> +#define NILFS_SEGBUF_SUSET	BIT(0)	/* segment usage has been set */
>> +
> 
> Ditto.
> 
>>  #define NILFS_LIST_SEGBUF(head)  \
>>  	list_entry((head), struct nilfs_segment_buffer, sb_list)
>>  #define NILFS_NEXT_SEGBUF(segbuf)  NILFS_LIST_SEGBUF((segbuf)->sb_list.next)
>> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
>> index c6abbad9..14e76c3 100644
>> --- a/fs/nilfs2/segment.c
>> +++ b/fs/nilfs2/segment.c
>> @@ -762,7 +762,8 @@ static int nilfs_test_metadata_dirty(struct the_nilfs *nilfs,
>>  		ret++;
>>  	if (nilfs_mdt_fetch_dirty(nilfs->ns_cpfile))
>>  		ret++;
>> -	if (nilfs_mdt_fetch_dirty(nilfs->ns_sufile))
>> +	if (nilfs_mdt_fetch_dirty(nilfs->ns_sufile) ||
>> +	    nilfs_sufile_cache_dirty(nilfs->ns_sufile))
>>  		ret++;
>>  	if ((ret || nilfs_doing_gc()) && nilfs_mdt_fetch_dirty(nilfs->ns_dat))
>>  		ret++;
>> @@ -1368,36 +1369,49 @@ static void nilfs_free_incomplete_logs(struct list_head *logs,
>>  }
>>  
>>  static void nilfs_segctor_update_segusage(struct nilfs_sc_info *sci,
>> -					  struct inode *sufile)
>> +					  struct the_nilfs *nilfs)
> 
> Do not change the sufile argument to nilfs.  It's not necessary
> for this change.

Ok.

>>  {
>>  	struct nilfs_segment_buffer *segbuf;
>> -	unsigned long live_blocks;
>> +	struct inode *sufile = nilfs->ns_sufile;
>> +	unsigned long nblocks;
>>  	int ret;
>>  
>>  	list_for_each_entry(segbuf, &sci->sc_segbufs, sb_list) {
>> -		live_blocks = segbuf->sb_sum.nblocks +
>> +		nblocks = segbuf->sb_sum.nblocks +
>>  			(segbuf->sb_pseg_start - segbuf->sb_fseg_start);
> 
>>  		ret = nilfs_sufile_set_segment_usage(sufile, segbuf->sb_segnum,
>> -						     live_blocks,
>> +						     nblocks,
>> +						     segbuf->sb_nlive_blks,
>> +						     segbuf->sb_nsnapshot_blks,
>>  						     sci->sc_seg_ctime);
> 
> With this change, two different semantics, "set" and "modify", are
> mixed up in the arguments of nilfs_sufile_set_segment_usage().  It's
> bad and confusing.
> 
> Please change nilfs_sufile_set_segment_usage() function, for instance,
> to nilfs_sufile_modify_segment_usage() and rewrite the above part
> so that all counter arguments are passed with the "modify" semantics.

Ok.

>>  		WARN_ON(ret); /* always succeed because the segusage is dirty */
>> +
>> +		segbuf->sb_flags |= NILFS_SEGBUF_SUSET;
> 
> Use sci->sc_stage.flags adding NILFS_CF_SUMOD flag.  Note that the
> flag must be added also to NILFS_CF_HISTORY_MASK so that the flag will
> be cleared every time a new cycle starts in the loop of
> nilfs_segctor_do_construct().

Ok.

>>  	}
>>  }
>>  
>> -static void nilfs_cancel_segusage(struct list_head *logs, struct inode *sufile)
>> +static void nilfs_cancel_segusage(struct list_head *logs,
>> +				  struct the_nilfs *nilfs)
> 
> Ditto.  Do not change the sufile argument to the pointer to nilfs
> object.
> 
>>  {
>>  	struct nilfs_segment_buffer *segbuf;
>> +	struct inode *sufile = nilfs->ns_sufile;
>> +	__s64 nlive_blks = 0, nsnapshot_blks = 0;
>>  	int ret;
>>  
>>  	segbuf = NILFS_FIRST_SEGBUF(logs);
> 
>> +	if (segbuf->sb_flags & NILFS_SEGBUF_SUSET) {
> 
> Ditto.
> 
>> +		nlive_blks = -(__s64)segbuf->sb_nlive_blks;
>> +		nsnapshot_blks = -(__s64)segbuf->sb_nsnapshot_blks;
>> +	}
>>  	ret = nilfs_sufile_set_segment_usage(sufile, segbuf->sb_segnum,
>>  					     segbuf->sb_pseg_start -
>> -					     segbuf->sb_fseg_start, 0);
>> +					     segbuf->sb_fseg_start,
>> +					     nlive_blks, nsnapshot_blks, 0);
> 
> Ditto.
> 
>>  	WARN_ON(ret); /* always succeed because the segusage is dirty */
>>  
>>  	list_for_each_entry_continue(segbuf, logs, sb_list) {
>>  		ret = nilfs_sufile_set_segment_usage(sufile, segbuf->sb_segnum,
>> -						     0, 0);
>> +						     0, 0, 0, 0);
>>  		WARN_ON(ret); /* always succeed */
>>  	}
>>  }
>> @@ -1499,6 +1513,7 @@ nilfs_segctor_update_payload_blocknr(struct nilfs_sc_info *sci,
>>  	if (!nfinfo)
>>  		goto out;
>>  
>> +	segbuf->sb_nlive_blks = segbuf->sb_sum.nfileblk;
>>  	blocknr = segbuf->sb_pseg_start + segbuf->sb_sum.nsumblk;
>>  	ssp.bh = NILFS_SEGBUF_FIRST_BH(&segbuf->sb_segsum_buffers);
>>  	ssp.offset = sizeof(struct nilfs_segment_summary);
>> @@ -1728,7 +1743,7 @@ static void nilfs_segctor_abort_construction(struct nilfs_sc_info *sci,
>>  	nilfs_abort_logs(&logs, ret ? : err);
>>  
>>  	list_splice_tail_init(&sci->sc_segbufs, &logs);
>> -	nilfs_cancel_segusage(&logs, nilfs->ns_sufile);
>> +	nilfs_cancel_segusage(&logs, nilfs);
>>  	nilfs_free_incomplete_logs(&logs, nilfs);
>>  
>>  	if (sci->sc_stage.flags & NILFS_CF_SUFREED) {
>> @@ -1790,7 +1805,8 @@ static void nilfs_segctor_complete_write(struct nilfs_sc_info *sci)
>>  			const unsigned long clear_bits =
>>  				(1 << BH_Dirty | 1 << BH_Async_Write |
>>  				 1 << BH_Delay | 1 << BH_NILFS_Volatile |
>> -				 1 << BH_NILFS_Redirected);
>> +				 1 << BH_NILFS_Redirected |
>> +				 1 << BH_NILFS_Counted);
> 
> Ditto.  Stop to add nilfs_counted flag.
> 
>>  
>>  			set_mask_bits(&bh->b_state, clear_bits, set_bits);
>>  			if (bh == segbuf->sb_super_root) {
>> @@ -1995,7 +2011,14 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
>>  
>>  			nilfs_segctor_fill_in_super_root(sci, nilfs);
>>  		}
>> -		nilfs_segctor_update_segusage(sci, nilfs->ns_sufile);
>> +
>> +		if (nilfs_feature_track_live_blks(nilfs)) {
>> +			err = nilfs_sufile_flush_cache(nilfs->ns_sufile, 0,
>> +						       NULL);
>> +			if (unlikely(err))
>> +				goto failed_to_write;
>> +		}
>> +		nilfs_segctor_update_segusage(sci, nilfs);
>>  
>>  		/* Write partial segments */
>>  		nilfs_segctor_prepare_write(sci);
>> @@ -2022,6 +2045,9 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
>>  		}
>>  	} while (sci->sc_stage.scnt != NILFS_ST_DONE);
>>  
> 
>> +	if (nilfs_feature_track_live_blks(nilfs))
>> +		nilfs_sufile_shrink_cache(nilfs->ns_sufile);
> 
> As I mentioned on ahead, this shrink cache function should be called
> from a destructor of sufile which doesn't exist at present.
> 
>> +
>>   out:
>>  	nilfs_segctor_drop_written_files(sci, nilfs);
>>  	return err;
>> diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
>> index 80bbd87..9cd8820d 100644
>> --- a/fs/nilfs2/sufile.c
>> +++ b/fs/nilfs2/sufile.c
>> @@ -527,10 +527,13 @@ int nilfs_sufile_mark_dirty(struct inode *sufile, __u64 segnum)
>>   * @sufile: inode of segment usage file
>>   * @segnum: segment number
>>   * @nblocks: number of live blocks in the segment
>> + * @nlive_blks: number of live blocks to add to the su_nlive_blks field
>> + * @nsnapshot_blks: number of snapshot blocks to add to su_nsnapshot_blks
>>   * @modtime: modification time (option)
>>   */
>>  int nilfs_sufile_set_segment_usage(struct inode *sufile, __u64 segnum,
>> -				   unsigned long nblocks, time_t modtime)
>> +				   unsigned long nblocks, __s64 nlive_blks,
>> +				   __s64 nsnapshot_blks, time_t modtime)
> 
> As I mentioned above, this function should be renamed to
> nilfs_sufile_modify_segment_usage() and the semantics of nblocks,
> nlive_blks, nsnapshot_blks arguments should be uniformed to "modify"
> semantics.
> 
> Also the types of these three counter arguments is not uniformed.

I used signed types for nlive_blks, nsnapshot_blks to be able to pass
negative numbers in nilfs_cancel_segusage().

Regards,
Andreas Rohner

> Regards,
> Ryusuke Konishi
> 
>>  {
>>  	struct buffer_head *bh;
>>  	struct nilfs_segment_usage *su;
>> @@ -548,6 +551,18 @@ int nilfs_sufile_set_segment_usage(struct inode *sufile, __u64 segnum,
>>  	if (modtime)
>>  		su->su_lastmod = cpu_to_le64(modtime);
>>  	su->su_nblocks = cpu_to_le32(nblocks);
>> +
>> +	if (nilfs_sufile_live_blks_ext_supported(sufile)) {
>> +		nsnapshot_blks += le32_to_cpu(su->su_nsnapshot_blks);
>> +		nsnapshot_blks = min_t(__s64, max_t(__s64, nsnapshot_blks, 0),
>> +				       nblocks);
>> +		su->su_nsnapshot_blks = cpu_to_le32(nsnapshot_blks);
>> +
>> +		nlive_blks += le32_to_cpu(su->su_nlive_blks);
>> +		nlive_blks = min_t(__s64, max_t(__s64, nlive_blks, 0), nblocks);
>> +		su->su_nlive_blks = cpu_to_le32(nlive_blks);
>> +	}
>> +
>>  	kunmap_atomic(kaddr);
>>  
>>  	mark_buffer_dirty(bh);
>> diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
>> index 662ab56..3466abb 100644
>> --- a/fs/nilfs2/sufile.h
>> +++ b/fs/nilfs2/sufile.h
>> @@ -60,7 +60,8 @@ int nilfs_sufile_set_alloc_range(struct inode *sufile, __u64 start, __u64 end);
>>  int nilfs_sufile_alloc(struct inode *, __u64 *);
>>  int nilfs_sufile_mark_dirty(struct inode *sufile, __u64 segnum);
>>  int nilfs_sufile_set_segment_usage(struct inode *sufile, __u64 segnum,
>> -				   unsigned long nblocks, time_t modtime);
>> +				   unsigned long nblocks, __s64 nlive_blks,
>> +				   __s64 nsnapshot_blks, time_t modtime);
>>  int nilfs_sufile_get_stat(struct inode *, struct nilfs_sustat *);
>>  ssize_t nilfs_sufile_get_suinfo(struct inode *, __u64, void *, unsigned,
>>  				size_t);
>> -- 
>> 2.3.7
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
