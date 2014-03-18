From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 5/6] nilfs2: add counting of live blocks for blocks that
 are overwritten
Date: Tue, 18 Mar 2014 15:50:22 +0400
Message-ID: <1395143422.2207.17.camel@slavad-CELSIUS-H720>
References: <cover.1394966728.git.andreas.rohner@gmx.net>
	 <25dd8a8bb6943ffa3e0663848363135585a48109.1394966729.git.andreas.rohner@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=W3qmCGRymF2Civk+LRjMLt1oVVSEnZu71lUH+ZBu5vM=;
	b=djXnwpfz86U7WvJsip+x06WWvQKCq1w1Vx26kPzuIvPTu5W6il2rTGLvyZxGlhaWvjz9VdI+/fn9sgs0bpVd9DxUb9NnLmGJKjOf9KCHZiJWrvmC8mh5zuPn6qg85LAN;
In-Reply-To: <25dd8a8bb6943ffa3e0663848363135585a48109.1394966729.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, 2014-03-16 at 11:47 +0100, Andreas Rohner wrote:

> diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
> index 7adb15d..e7b19c40 100644
> --- a/fs/nilfs2/dat.c
> +++ b/fs/nilfs2/dat.c
> @@ -445,6 +445,64 @@ int nilfs_dat_clean_snapshot_flag(struct inode *dat, __u64 vblocknr)
>  }
>  
>  /**
> + * nilfs_dat_is_live - checks if the virtual block number is alive

What about nilfs_dat_block_is_alive?

> + * @dat: DAT file inode
> + * @vblocknr: virtual block number
> + *
> + * Description: nilfs_dat_is_live() looks up the DAT entry for @vblocknr and
> + * determines if the corresponding block is alive or not. This check ignores
> + * snapshots and protection periods.
> + *
> + * Return Value: 1 if vblocknr is alive and 0 otherwise. On error, one
> + * of the following negative error codes is returned.

It is really bad idea to mess error codes and info return, from my point
of view. Usually, it results in very buggy code in the place of call.
Actually, you use binary nature of returned value.

I think that it needs to rework ideology of this function. Maybe, it
needs to return bool and to return error value as argument.

> + *
> + * %-EIO - I/O error.
> + *
> + * %-ENOMEM - Insufficient amount of memory available.
> + *
> + * %-ENOENT - A block number associated with @vblocknr does not exist.
> + */
> +int nilfs_dat_is_live(struct inode *dat, __u64 vblocknr)
> +{
> +	struct buffer_head *entry_bh, *bh;
> +	struct nilfs_dat_entry *entry;
> +	sector_t blocknr;
> +	void *kaddr;
> +	int ret;
> +
> +	ret = nilfs_palloc_get_entry_block(dat, vblocknr, 0, &entry_bh);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (!nilfs_doing_gc() && buffer_nilfs_redirected(entry_bh)) {
> +		bh = nilfs_mdt_get_frozen_buffer(dat, entry_bh);
> +		if (bh) {
> +			WARN_ON(!buffer_uptodate(bh));
> +			brelse(entry_bh);
> +			entry_bh = bh;
> +		}
> +	}
> +
> +	kaddr = kmap_atomic(entry_bh->b_page);
> +	entry = nilfs_palloc_block_get_entry(dat, vblocknr, entry_bh, kaddr);
> +	blocknr = le64_to_cpu(entry->de_blocknr);
> +	if (blocknr == 0) {

I suppose that zero is specially named constant?

> +		ret = -ENOENT;
> +		goto out;
> +	}
> +
> +
> +	if (entry->de_end == cpu_to_le64(NILFS_CNO_MAX))
> +		ret = 1;
> +	else
> +		ret = 0;
> +out:
> +	kunmap_atomic(kaddr);
> +	brelse(entry_bh);
> +	return ret;
> +}
> +
> +/**
>   * nilfs_dat_translate - translate a virtual block number to a block number
>   * @dat: DAT file inode
>   * @vblocknr: virtual block number
> diff --git a/fs/nilfs2/dat.h b/fs/nilfs2/dat.h
> index a528024..51d44c0 100644
> --- a/fs/nilfs2/dat.h
> +++ b/fs/nilfs2/dat.h
> @@ -31,6 +31,7 @@
>  struct nilfs_palloc_req;
>  
>  int nilfs_dat_translate(struct inode *, __u64, sector_t *);
> +int nilfs_dat_is_live(struct inode *, __u64);
>  
>  int nilfs_dat_prepare_alloc(struct inode *, struct nilfs_palloc_req *);
>  void nilfs_dat_commit_alloc(struct inode *, struct nilfs_palloc_req *);
> diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
> index b9c5726..c32b896 100644
> --- a/fs/nilfs2/inode.c
> +++ b/fs/nilfs2/inode.c
> @@ -86,6 +86,8 @@ int nilfs_get_block(struct inode *inode, sector_t blkoff,
>  	int err = 0, ret;
>  	unsigned maxblocks = bh_result->b_size >> inode->i_blkbits;
>  
> +	bh_result->b_blocknr = 0;
> +
>  	down_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
>  	ret = nilfs_bmap_lookup_contig(ii->i_bmap, blkoff, &blknum, maxblocks);
>  	up_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index 0b62bf4..3603394 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -612,6 +612,12 @@ static int nilfs_ioctl_move_inode_block(struct inode *inode,
>  		brelse(bh);
>  		return -EEXIST;
>  	}
> +
> +	if (nilfs_vdesc_snapshot(vdesc))
> +		set_buffer_nilfs_snapshot(bh);
> +	if (nilfs_vdesc_protection_period(vdesc))
> +		set_buffer_nilfs_protection_period(bh);
> +
>  	list_add_tail(&bh->b_assoc_buffers, buffers);
>  	return 0;
>  }
> diff --git a/fs/nilfs2/page.h b/fs/nilfs2/page.h
> index ef30c5c..8c34a31 100644
> --- a/fs/nilfs2/page.h
> +++ b/fs/nilfs2/page.h
> @@ -36,13 +36,17 @@ enum {
>  	BH_NILFS_Volatile,
>  	BH_NILFS_Checked,
>  	BH_NILFS_Redirected,
> +	BH_NILFS_Snapshot,
> +	BH_NILFS_Protection_Period,
>  };
>  
>  BUFFER_FNS(NILFS_Node, nilfs_node)		/* nilfs node buffers */
>  BUFFER_FNS(NILFS_Volatile, nilfs_volatile)
>  BUFFER_FNS(NILFS_Checked, nilfs_checked)	/* buffer is verified */
>  BUFFER_FNS(NILFS_Redirected, nilfs_redirected)	/* redirected to a copy */
> -
> +BUFFER_FNS(NILFS_Snapshot, nilfs_snapshot)	/* belongs to a snapshot */
> +BUFFER_FNS(NILFS_Protection_Period, nilfs_protection_period) /* protected by
> +							protection period */
>  
>  int __nilfs_clear_page_dirty(struct page *);
>  
> diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
> index dc3a9efd..c72fc37 100644
> --- a/fs/nilfs2/segbuf.c
> +++ b/fs/nilfs2/segbuf.c
> @@ -28,6 +28,7 @@
>  #include <linux/slab.h>
>  #include "page.h"
>  #include "segbuf.h"
> +#include "sufile.h"
>  
> 
>  struct nilfs_write_info {
> @@ -57,6 +58,8 @@ struct nilfs_segment_buffer *nilfs_segbuf_new(struct super_block *sb)
>  	INIT_LIST_HEAD(&segbuf->sb_segsum_buffers);
>  	INIT_LIST_HEAD(&segbuf->sb_payload_buffers);
>  	segbuf->sb_super_root = NULL;
> +	segbuf->sb_su_blocks = 0;
> +	segbuf->sb_su_blocks_cancel = 0;
>  
>  	init_completion(&segbuf->sb_bio_event);
>  	atomic_set(&segbuf->sb_err, 0);
> @@ -82,6 +85,25 @@ void nilfs_segbuf_map(struct nilfs_segment_buffer *segbuf, __u64 segnum,
>  		segbuf->sb_fseg_end - segbuf->sb_pseg_start + 1;
>  }
>  
> +int nilfs_segbuf_set_sui(struct nilfs_segment_buffer *segbuf,
> +			 struct the_nilfs *nilfs)
> +{
> +	struct nilfs_suinfo si;
> +	ssize_t err;
> +
> +	err = nilfs_sufile_get_suinfo(nilfs->ns_sufile, segbuf->sb_segnum, &si,
> +				      sizeof(si), 1);
> +	if (err != 1)

If nilfs_sufile_get_suinfo() returns error then how it can be equal by
one? What a mess?

> +		return -1;

It is really bad idea. Finally, caller will have -EPERM. Do you mean
this here?

> +
> +	if (si.sui_nblocks == 0)
> +		si.sui_nblocks = segbuf->sb_pseg_start - segbuf->sb_fseg_start;
> +
> +	segbuf->sb_su_blocks = si.sui_nblocks;
> +	segbuf->sb_su_blocks_cancel = si.sui_nblocks;
> +	return 0;
> +}
> +
>  /**
>   * nilfs_segbuf_map_cont - map a new log behind a given log
>   * @segbuf: new segment buffer
> @@ -450,6 +472,9 @@ static int nilfs_segbuf_submit_bh(struct nilfs_segment_buffer *segbuf,
>  
>  	len = bio_add_page(wi->bio, bh->b_page, bh->b_size, bh_offset(bh));
>  	if (len == bh->b_size) {
> +		lock_buffer(bh);
> +		map_bh(bh, segbuf->sb_super, wi->blocknr + wi->end);
> +		unlock_buffer(bh);
>  		wi->end++;
>  		return 0;
>  	}
> diff --git a/fs/nilfs2/segbuf.h b/fs/nilfs2/segbuf.h
> index b04f08c..482bbad 100644
> --- a/fs/nilfs2/segbuf.h
> +++ b/fs/nilfs2/segbuf.h
> @@ -83,6 +83,8 @@ struct nilfs_segment_buffer {
>  	sector_t		sb_fseg_start, sb_fseg_end;
>  	sector_t		sb_pseg_start;
>  	unsigned		sb_rest_blocks;
> +	__u32			sb_su_blocks_cancel;
> +	__s64			sb_su_blocks;
>  
>  	/* Buffers */
>  	struct list_head	sb_segsum_buffers;
> @@ -122,6 +124,8 @@ void nilfs_segbuf_map(struct nilfs_segment_buffer *, __u64, unsigned long,
>  		      struct the_nilfs *);
>  void nilfs_segbuf_map_cont(struct nilfs_segment_buffer *segbuf,
>  			   struct nilfs_segment_buffer *prev);
> +int nilfs_segbuf_set_sui(struct nilfs_segment_buffer *segbuf,
> +			 struct the_nilfs *nilfs);
>  void nilfs_segbuf_set_next_segnum(struct nilfs_segment_buffer *, __u64,
>  				  struct the_nilfs *);
>  int nilfs_segbuf_reset(struct nilfs_segment_buffer *, unsigned, time_t, __u64);
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index a1a1916..5d98a1c 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -1257,6 +1257,10 @@ static int nilfs_segctor_begin_construction(struct nilfs_sc_info *sci,
>  	}
>  	nilfs_segbuf_set_next_segnum(segbuf, nextnum, nilfs);
>  
> +	err = nilfs_segbuf_set_sui(segbuf, nilfs);
> +	if (err)
> +		goto failed;
> +
>  	BUG_ON(!list_empty(&sci->sc_segbufs));
>  	list_add_tail(&segbuf->sb_list, &sci->sc_segbufs);
>  	sci->sc_segbuf_nblocks = segbuf->sb_rest_blocks;
> @@ -1306,6 +1310,10 @@ static int nilfs_segctor_extend_segments(struct nilfs_sc_info *sci,
>  		segbuf->sb_sum.seg_seq = prev->sb_sum.seg_seq + 1;
>  		nilfs_segbuf_set_next_segnum(segbuf, nextnextnum, nilfs);
>  
> +		err = nilfs_segbuf_set_sui(segbuf, nilfs);
> +		if (err)
> +			goto failed;
> +
>  		list_add_tail(&segbuf->sb_list, &list);
>  		prev = segbuf;
>  	}
> @@ -1368,8 +1376,7 @@ static void nilfs_segctor_update_segusage(struct nilfs_sc_info *sci,
>  	int ret;
>  
>  	list_for_each_entry(segbuf, &sci->sc_segbufs, sb_list) {
> -		live_blocks = segbuf->sb_sum.nblocks +
> -			(segbuf->sb_pseg_start - segbuf->sb_fseg_start);
> +		live_blocks = segbuf->sb_sum.nfileblk + segbuf->sb_su_blocks;
>  		ret = nilfs_sufile_set_segment_usage(sufile, segbuf->sb_segnum,
>  						     live_blocks,
>  						     sci->sc_seg_ctime);
> @@ -1383,9 +1390,9 @@ static void nilfs_cancel_segusage(struct list_head *logs, struct inode *sufile)
>  	int ret;
>  
>  	segbuf = NILFS_FIRST_SEGBUF(logs);
> +
>  	ret = nilfs_sufile_set_segment_usage(sufile, segbuf->sb_segnum,
> -					     segbuf->sb_pseg_start -
> -					     segbuf->sb_fseg_start, 0);
> +					segbuf->sb_su_blocks_cancel, 0);
>  	WARN_ON(ret); /* always succeed because the segusage is dirty */
>  
>  	list_for_each_entry_continue(segbuf, logs, sb_list) {
> @@ -1477,7 +1484,9 @@ nilfs_segctor_update_payload_blocknr(struct nilfs_sc_info *sci,
>  				     struct nilfs_segment_buffer *segbuf,
>  				     int mode)
>  {
> +	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
>  	struct inode *inode = NULL;
> +	struct nilfs_inode_info *ii;
>  	sector_t blocknr;
>  	unsigned long nfinfo = segbuf->sb_sum.nfinfo;
>  	unsigned long nblocks = 0, ndatablk = 0;
> @@ -1487,7 +1496,9 @@ nilfs_segctor_update_payload_blocknr(struct nilfs_sc_info *sci,
>  	union nilfs_binfo binfo;
>  	struct buffer_head *bh, *bh_org;
>  	ino_t ino = 0;
> -	int err = 0;
> +	int gc_inode = 0, err = 0;
> +	__u64 segnum, prev_segnum = 0, dectime = 0, maxdectime = 0;
> +	__u32 blkcount = 0;
>  
>  	if (!nfinfo)
>  		goto out;
> @@ -1508,6 +1519,17 @@ nilfs_segctor_update_payload_blocknr(struct nilfs_sc_info *sci,
>  
>  			inode = bh->b_page->mapping->host;
>  
> +			ii = NILFS_I(inode);
> +			gc_inode = test_bit(NILFS_I_GCINODE, &ii->i_state);
> +			dectime = sci->sc_seg_ctime;

The dectime sounds not very good for me.

> +			/* no update of lastdec necessary */
> +			if (ino == NILFS_DAT_INO || ino == NILFS_SUFILE_INO ||
> +					ino == NILFS_CPFILE_INO)
> +				dectime = 0;

What about such?

if (ino == NILFS_DAT_INO ||
    ino == NILFS_SUFILE_INO ||
    ino == NILFS_CPFILE_INO)
	dectime = 0;

But really I prefer to see small check function (is_metadata_file(), for
example).

> +
> +			if (dectime > maxdectime)
> +				maxdectime = dectime;
> +
>  			if (mode == SC_LSEG_DSYNC)
>  				sc_op = &nilfs_sc_dsync_ops;
>  			else if (ino == NILFS_DAT_INO)
> @@ -1515,6 +1537,39 @@ nilfs_segctor_update_payload_blocknr(struct nilfs_sc_info *sci,
>  			else /* file blocks */
>  				sc_op = &nilfs_sc_file_ops;
>  		}
> +
> +		segnum = nilfs_get_segnum_of_block(nilfs, bh->b_blocknr);
> +		if (!gc_inode && bh->b_blocknr > 0 &&
> +			(ino == NILFS_DAT_INO || !buffer_nilfs_node(bh)) &&
> +				segnum < nilfs->ns_nsegments) {
> +
> +			if (segnum != prev_segnum) {
> +				if (blkcount) {
> +					nilfs_sufile_add_segment_usage(
> +							nilfs->ns_sufile,
> +							prev_segnum,
> +							-((__s64)blkcount),
> +							maxdectime);

It is really bad code style. Usually, it means necessity to refactor
function's code. Otherwise, it is really hard to understand the code.

> +				}
> +				prev_segnum = segnum;
> +				blkcount = 0;
> +				maxdectime = dectime;
> +			}
> +
> +
> +			if (segnum == segbuf->sb_segnum)
> +				segbuf->sb_su_blocks--;
> +			else
> +				++blkcount;
> +		} else if (gc_inode && bh->b_blocknr > 0) {
> +			/* check again if gc blocks are alive */
> +			if (!buffer_nilfs_snapshot(bh) &&
> +					(buffer_nilfs_protection_period(bh) ||
> +					!nilfs_dat_is_live(nilfs->ns_dat,
> +							   bh->b_blocknr)))
> +				segbuf->sb_su_blocks--;

Ahhhhh. Again and again. :) Bad code style. You need to improve your
taste. :)

> +		}
> +
>  		bh_org = bh;
>  		get_bh(bh_org);
>  		err = nilfs_bmap_assign(NILFS_I(inode)->i_bmap, &bh, blocknr,
> @@ -1538,6 +1593,10 @@ nilfs_segctor_update_payload_blocknr(struct nilfs_sc_info *sci,
>  		} else if (ndatablk > 0)
>  			ndatablk--;
>  	}
> +
> +	if (blkcount)
> +		nilfs_sufile_add_segment_usage(nilfs->ns_sufile, prev_segnum,
> +				-((__s64)blkcount), maxdectime);

Such way -((__s64)blkcount) looks not very good. Very complex and
confusing construction at whole, from my viewpoint.

Thanks,
Vyacheslav Dubeyko.

>   out:
>  	return 0;
>  
> diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
> index 30ddc86..e05793a 100644
> --- a/include/linux/nilfs2_fs.h
> +++ b/include/linux/nilfs2_fs.h
> @@ -885,6 +885,7 @@ enum {
>  };
>  enum {
>  	NILFS_VDESC_SNAPSHOT,
> +	NILFS_VDESC_PROTECTION_PERIOD,
>  	__NR_NILFS_VDESC_FIELDS,
>  	/* ... */
>  };
> @@ -921,6 +922,7 @@ nilfs_vdesc_##name(const struct nilfs_vdesc *vdesc)			\
>  NILFS_VDESC_FNS(DATA, data)
>  NILFS_VDESC_FNS(NODE, node)
>  NILFS_VDESC_FNS2(SNAPSHOT, snapshot)
> +NILFS_VDESC_FNS2(PROTECTION_PERIOD, protection_period)
>  
>  /**
>   * struct nilfs_bdesc - descriptor of disk block number


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
